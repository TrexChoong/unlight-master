package controller
{
    import flash.events.*;
    import flash.utils.*;

    import mx.controls.*;
    import mx.events.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import sound.BaseSound;
    import sound.bgm.*;
    import sound.se.*;


    import net.server.*;
    import net.Host;

    import model.*;
    import model.events.AvatarItemEvent;

    import view.*;
    import view.scene.game.*;


    /**
     * ゲーム画面コントロールクラス
     *
     */
    public class DuelCtrl extends BaseCtrl
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

        protected static var __instance:DuelCtrl; // シングルトン保存用
        private static var __waitingThread:Thread;

        private var _server:GameServer;
        private var _gameSession:int = 0;
        private var _gameLog:MessageLog = MessageLog.getMessageLog(MessageLog.GAME_LOG);
        private var _maxChallageCount:int = 3;

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

//        private var _waitingPanel:MatchWaitingView;
        private var _connected:Boolean = false;        // Serverにコネクトしているか？

        private var _waiting:Boolean = false;


        public function DuelCtrl(caller:Function=null)
        {
//            if( caller != createInstance ) throw new ArgumentErrar("Cannot user access constructor.");
            serverInitialize();
        }

        protected function serverInitialize():void
        {
             _server = GameServer.instance;
             // サーバの接続イベントを登録
             init();
        }

        // オーバライド前提のサーバゲッタ
        protected override function get server():Server
        {
           return  _server;
        }


        private static function createInstance():DuelCtrl
        {
            return new DuelCtrl(arguments.callee);
        }

        public static function get instance():DuelCtrl
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

        public function matchStart(uid:String):void
        {
            log.writeLog(log.LV_DEBUG, this, "matchStart");
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.matchStart(uid);
             }
             new WaitThread(15000, CheckStartMatch,[uid]).start();
        }
        private function CheckStartMatch(uid:String):void
        {
//            log.writeLog(log.LV_DEBUG, this, "CheckStartMatch",Duel.instance.state,getTimer(),MatchRoom.list[uid]) ;
             if (_server.state == Host.CONNECT_AUTHED&&Duel.instance.state != Duel.START)
             {
                 // AIの時はつねに、ABORTの場合はマッチスタートさせない(AIに移行するのが0ターンのときのみの処理なので注意もし将来1ターン以降に戻すなら元に戻すべき。混在するなら分けろ)
                 if(_maxChallageCount > 0 && Channel.list[Channel.current].penaltyType == Channel.PNLY_TYPE_AI ? true : MatchRoom.list[uid] != null)
                 {
                     matchStart(uid);
                     _maxChallageCount -=1;
                 }

             }
        }



        public function start(view:Thread):void
        {
            _gameView = GameView(view); // 非常手段。直す
            waitConnectThreadStart();

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
//            _gameView.addSequence(thread);
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
            // stopViewSequence();
            addViewSequence(new ClousureThread(Duel.instance.abortGame));
        }


        // Viewにシーケンスををとめる
        public function stopViewSequence():void
        {
            addViewSequence(new ClousureThread(_gameView.finishGame));
        }

        // サーバのコマンドを遅延評価する
        public function commandUpdate():Boolean
        {
            var gCmdUpdate:Boolean = _server.commandShift();
            var wCmdUpdate:Boolean = WatchServer.instance.commandShift();
            return (gCmdUpdate || wCmdUpdate);
        }

        // サーバのコマンドを削除する
        public function commandClear():void
        {
            _server.commandClear();
            WatchServer.instance.commandClear();
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
//              addViewSequence(new ClousureThread(_gameView.interrupt));
            }

            _connected = false;
        }


//         public function setCreateButtons(a:Array ):void
//         {
//             _createRoomButtons = a;
//         }

//         public function createButtonsEnable(b:Boolean ):void
//         {
// //            log.writeLog(log.LV_FATAL, this, "button enable!!",b);
//             _createRoomButtons.forEach(function(item:*, index:int, array:Array):void{item.visible = b});
//         }

//         public function waitingRun(t:MatchWaitingView):void
//         {
//             _waiting = true;
//             _waitingPanel = t;
//         }

//         public function waitingEnd():void
//         {
//             _waiting = false
//             _waitingPanel = null;
//         }

//         public function waitingStop():void
//         {
// //            log.writeLog(log.LV_FATAL, this, "waiting is ", _waiting);
//             if (_waiting)
//             {
//                     _waitingPanel.exitPanel();
//             }
//         }





        /**o
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


        // デバッグコードを送る
        public function sendDebugCode(code:int):void
        {
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.csDebugCode(code);
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
            _gameLog.setMessage(msg);
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
            log.writeLog(log.LV_WARN, this, "removeView");
            _gameView =null;
        }

        public function errorAbortGame():void
        {
            log.writeLog(log.LV_WARN, this, "errorAbortGame ", "state",_state);
            // ゲーム中ならゲームロビーに戻す
            if (_state == GAME_STAGE)
            {
                log.writeLog(log.LV_WARN, this, "ゲームを止める",_gameView);
                abortGame();
                // addViewSequence(new ClousureThread(_gameView.interrupt));
            }

        }

        // 開始前に相手が切断などで開始出来ない場合
        public function notStartErrorAbort():void
        {
            if (_state == GAME_STAGE)
            {
                _server.commandPush(abortGame,[]);
            } else {
                _gameView.abortGame();
                Duel.instance.abortGame();
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
            if (_duelBGM) _duelBGM.fade(0,2)
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