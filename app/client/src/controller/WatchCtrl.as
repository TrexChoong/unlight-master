package controller
{
    import flash.events.*;

    import mx.controls.*;
    import mx.events.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import net.server.*;
    import net.Host;
    import model.*;
    import model.events.AvatarItemEvent;

    import view.*;
    import view.scene.game.*;

    import sound.BaseSound;
    import sound.bgm.*;
    import sound.se.*;

    /**
     * ゲーム画面コントロールクラス
     *
     */
    public class WatchCtrl extends BaseCtrl
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "対戦";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Duel";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "對戰";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "对战";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "대전";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Duel en ligne";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "対戦";

        CONFIG::LOCALE_TH
        private static const _TRANS :String = "ต่อสู้";


        protected static var __instance:WatchCtrl; // シングルトン保存用
        private static var __waitingThread:Thread;

        private var _server:WatchServer;
        private var _gameSession:int = 0;
        private var _gameLog:MessageLog = MessageLog.getMessageLog(MessageLog.GAME_LOG);

        private var _gameView:GameView;

        private var _createRoomButtons:Array = []; // マッチビューで使用する部屋作成ボタンのArray

        public var _state:int = 0;              // ステータスを保管

        public static const WAITING:int = 0;    // 待機
        public static const EXIT:int = 1;       // 終了
        public static const GAME_STAGE:int = 2; // ゲーム画面
        public static const EDIT:int = 3;       // カード編集

        protected var _stageNo:int = 0; // 今回のステージ ※QuestCtrlでも使用する為protectedにする
//        private var _duelBGM:DuelBGM = new DuelBGM();
        private var _duelBGM:DuelBGM;
        private var _matchBGM:MatchBGM = new MatchBGM();

        private var _connected:Boolean = false;        // Serverにコネクトしているか？



        public function WatchCtrl(caller:Function=null)
        {
//            if( caller != createInstance ) throw new ArgumentErrar("Cannot user access constructor.");
            serverInitialize();
        }

        protected function serverInitialize():void
        {
             _server = WatchServer.instance;
             // サーバの接続イベントを登録
             init();
        }

        // オーバライド前提のサーバゲッタ
        protected override function get server():Server
        {
           return  _server;
        }


        private static function createInstance():WatchCtrl
        {
            return new WatchCtrl(arguments.callee);
        }

        public static function get instance():WatchCtrl
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }

        public function get state():int
        {
            return _state;
        }

        public function set state(i:int):void
        {
            _state = i;
        }

        protected override function get serverName():String
        {
//            return "対戦";
            return _TRANS;
        }

        public override function get connected():Boolean
        {
            return _connected;
        }

        public override function set connected(b:Boolean):void
        {
             _connected = b;
        }


        protected override function get waitingThread():Thread
        {
            return __waitingThread
        }

        protected override function set waitingThread(t:Thread):void
        {
            __waitingThread = t;
        }

        public function get stageNo():int
        {
            return _stageNo;
        }

        public function set stageNo(no:int):void
        {
            _stageNo = no;
        }

        /**
         * ゲームのスタート
         *
         */

        public function watchStart(uid:String):void
        {
            log.writeLog(log.LV_FATAL, this, "watchStart");
            _server.watchStart(uid);
        }

        public function watchCommandGetStart():void
        {
            log.writeLog(log.LV_FATAL, this, "watchCommmandGetStart");
            _server.watchCommandGetStart();
        }

        public function watchFinish():void
        {
            log.writeLog(log.LV_FATAL, this, "watchFinish");
            _server.watchFinish();
        }

        public function start(view:Thread):void
        {
            _gameView = GameView(view); // 非常手段。直す
            waitConnectThreadStart();

        }

        public function watchCancelOrder():void
        {
            log.writeLog(log.LV_FATAL, this, "watchCancelOrder");
            _server.watchCancelOrder();
        }

        public function watchCancelSuccess():void
        {
            _state = WAITING;
            DuelCtrl.instance.state = DuelCtrl.WAITING;
            Duel.instance.endWatchGame();
            MatchCtrl.instance.watchCancelSuccess();
        }

        // connecetWaitスレッドが使うスタートコマンド
        public override function waitStart():void
        {
            log.writeLog(log.LV_FATAL, this, "start", _server.state);
            _server.start(this);

        }

        // チャンネルが選択されてからサーバーに接続する
        public function selectChannelServerConnect(host:String, port:int):void
        {
            log.writeLog(log.LV_FATAL, this, "connect", host, port);
            _server.connect(host,port);
        }

        // チャンネルから出て、サーバを切断して次のコネクトを待つ
        public function exitChannelServerDisconnect():void
        {
            _server.exit();
            waitConnectThreadStart();
        }


        // Viewにシーケンスを追加する
        public function addViewSequence(thread:Thread):void
        {
            _gameView.addSequence(thread);
        }

        // 終了を待たないシーケンスとして追加する
        public function addNoWaitViewSequence(thread:Thread):void
        {
            _gameView.addSequence(new ClousureThread(function():void{thread.start();}));
            _gameView.addSequence(thread);
        }

        // Viewを一定期間止める
        public function sleepViewSequence(time:int):void
        {
            addViewSequence(new SleepThread(time));
        }

        // ゲームの中止
        private function abortGame():void
        {
            addViewSequence(new ClousureThread(_gameView.abortGame));
            addViewSequence(new ClousureThread(Duel.instance.abortGame));
        }

        // 観戦終了
        public function watchViewFinish(isEnd:Boolean,winnerName:String=""):void
        {
            log.writeLog(log.LV_FATAL, this, "watchViewFinish");
            _gameView.viewWatchResult(isEnd,winnerName);
        }

        // Viewにシーケンスををとめる
        public function stopViewSequence():void
        {
            addViewSequence(new ClousureThread(_gameView.finishGame));
        }

        // Viewにシーケンスををとめる
        public function stopWatchViewSequence():void
        {
            // addViewSequence(new ClousureThread(_gameView.watchFinishGame));
        }

        // サーバのコマンドを遅延評価する
        public function commandUpdate():void
        {
            _server.commandShift();
        }


        // アラートの多重起動を防ぐハンドラ
        protected override function logoutAlertOffHandler(event:Event):void
        {
            getServerDisconnectedHandler(event);
            BaseCtrl.alarted = false;
        }

        // サーバ切断時イベントハンドラ
        protected override function getServerDisconnectedHandler(evt:Event):void
        {
            server.removeEventListener(Server.DISCONNECT,getServerDisconnectedHandler); // 切断時

            // ゲーム中ならゲームロビーに戻す
            if (_state == GAME_STAGE)
            {
                log.writeLog(log.LV_WARN, this, "ゲームを止める",_gameView);
                abortGame();
            }

            _connected = false;
        }



        /**
         * ゲームの開始
         *
         */
        // サーバにデュエルの準備を知らせる
        public function startOk():void
        {
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.startOk();
             }
        }



        /**
         * ゲームの終了
         *
         */
        public override  function exit():void
        {
            super.exit()
            Duel.instance.abortGame();
        }


        // メッセージログの更新と追記
        public function setMessage(msg:String):void
        {
            // 観戦はログが先行しないように、シーケンスに追加する
            addViewSequence(new ClousureThread(_gameLog.setMessage, [msg]));
        }

        public function setMessageStrData(str:String):void
        {
            DuelMessage.setMessage(str);
        }

        // エラーパネルのボタンハンドラ（アラートの多重起動を防ぐ）
        protected override function errorOffHandler(event:Event):void
        {
//            log.writeLog(log.LV_FATAL, this, "state is ", _state);
//            waitingStop();
            // ゲーム中ならゲームロビーに戻す
            if (_state == GAME_STAGE)
            {
                log.writeLog(log.LV_WARN, this, "ゲームを止める",_gameView);
//                abortGame();
                //              addViewSequence(new ClousureThread(_gameView.interrupt));
            }
            BaseCtrl.alarted = false;
        }

        // コントローラからビューを取り除く
        public function removeView():void
        {
            _gameView =null;
        }

        public function errorAbortGame():void
        {
            log.writeLog(log.LV_WARN, this, "******************************errorAbortGame",_state);
            // ゲーム中ならゲームロビーに戻す
            if (_state == GAME_STAGE)
            {
                log.writeLog(log.LV_WARN, this, "ゲームを止める",_gameView);
                abortGame();
//                addViewSequence(new ClousureThread(_gameView.interrupt));
            }

        }



        // =================================
        // BGM制御（将来的には移すべき）
        // =================================
        public function playDuelBGM():void
        {
            _duelBGM = new DuelBGM(stageNo);
            _duelBGM.loopSound(0);
        }

        public function stopDuelBGM():void
        {
            _duelBGM.fade(0,2)
        }

        public function playMatchBGM():void
        {
//            log.writeLog(log.LV_FATAL, this, "bgm?", _matchBGM);
            _matchBGM.loopSound(0);
        }

        public function stopMatchBGM():void
        {
            _matchBGM.fade(0,2)
        }

        // =================================
        // アイテム操作
        // =================================

        override public function sendItem(id:int):void
        {
            _server.csAvatarUseItem(id);
        }

        public function useItem(id:int):void
        {
            dispatchEvent(new AvatarItemEvent(AvatarItemEvent.USE_ITEM, id));
        }

        public function getItem(id:int):void
        {
            dispatchEvent(new AvatarItemEvent(AvatarItemEvent.GET_ITEM, id));
        }

/**
 * ==============================================
 * ===============================================
 */



    }
}