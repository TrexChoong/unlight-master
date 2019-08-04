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


    import sound.BaseSound;
    import sound.bgm.*;
    import sound.se.*;

    /**
     * ゲーム画面コントロールクラス
     *
     */
    public class MatchCtrl extends BaseCtrl
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


        protected static var __instance:MatchCtrl; // シングルトン保存用
        private static var __waitingThread:Thread;

        private var _server:MatchServer;
        private var _gameSession:int = 0;
        private var _gameLog:MessageLog = MessageLog.getMessageLog(MessageLog.GAME_LOG);

        private var _gameView:GameView;

        private var _createRoomButtons:Array = []; // マッチビューで使用する部屋作成ボタンのArray
        private var _quickStartButtons:Array = []; // マッチビューで使用するクイックマッチボタンのArray

        public var _state:int = 0;              // ステータスを保管

        public static const WAITING:int = 0;    // 待機
        public static const EXIT:int = 1;       // 終了
        public static const GAME_STAGE:int = 2; // ゲーム画面
        public static const EDIT:int = 3;       // カード編集

        private var _waitingPanel:MatchWaitingView;
        private var _radderWaitingPanel:RadderWaitingView;
        private var _watchWaitingPanel:WatchWaitingView;
        private var _connected:Boolean = false;        // Serverにコネクトしているか？

        private var _waiting:Boolean = false;

        public function MatchCtrl(caller:Function=null)
        {
            serverInitialize();
        }

        protected function serverInitialize():void
        {
             _server = MatchServer.instance;
             // サーバの接続イベントを登録
             init();
        }

        // オーバライド前提のサーバゲッタ
        protected override function get server():Server
        {
           return  _server;
        }


        private static function createInstance():MatchCtrl
        {
            return new MatchCtrl(arguments.callee);
        }

        public static function get instance():MatchCtrl
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


        /**
         * ゲームのスタート
         *
         */
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

        // デュエル終了を送る
        public function matchFinish():void
        {
            _server.csMatchFinish();
        }

        // サーバ切断時イベントハンドラ
        // デュエル終了後、ルームリストを更新する
        public function matchListInfoUpdate():void
        {
            _server.csRequestMatchListInfo();
        }

        // サーバ切断時イベントハンドラ
        protected override function getServerDisconnectedHandler(evt:Event):void
        {
            server.removeEventListener(Server.DISCONNECT,getServerDisconnectedHandler); // 切断時


            _connected = false;
        }


        public function setCreateButtons(a:Array ):void
        {
            _createRoomButtons = a;
        }

        public function setQuickButtons(a:Array ):void
        {
            _quickStartButtons = a;
        }

        public function createButtonsEnable(b:Boolean ):void
        {
//            log.writeLog(log.LV_FATAL, this, "button enable!!",b);
            _createRoomButtons.forEach(function(item:*, index:int, array:Array):void{item.visible = b});
        }

        public function quickButtonsEnable(b:Boolean ):void
        {
//            log.writeLog(log.LV_FATAL, this, "button enable!!",b);
            _quickStartButtons.forEach(function(item:*, index:int, array:Array):void{item.visible = b});
        }

        public function waitingRun(t:MatchWaitingView):void
        {
            _waiting = true;
            _waitingPanel = t;
        }

        public function radderWaitingRun(t:RadderWaitingView):void
        {
            _waiting = true;
            _radderWaitingPanel = t;
        }

        public function watchWaitingRun(t:WatchWaitingView):void
        {
            _waiting = true;
            _watchWaitingPanel = t;
        }

        public function waitingEnd():void
        {
            _waiting = false
            _waitingPanel = null;
        }

        public function radderWaitingEnd():void
        {
            _waiting = false
            _radderWaitingPanel = null;
        }

        public function watchWaitingEnd():void
        {
            _waiting = false
            _watchWaitingPanel = null;
        }

        public function waitingStop():void
        {
            // log.writeLog(log.LV_FATAL, this, "waiting is ", _waiting);
            if (_waiting)
            {
                if ( _waitingPanel ) _waitingPanel.exitPanel();
                if ( _radderWaitingPanel ) _radderWaitingPanel.exitPanel();
                if ( _watchWaitingPanel ) _watchWaitingPanel.exitPanel();
            }
        }
        public function radderWaitingStop():void
        {
            if (_waiting)
            {
                    _radderWaitingPanel.exitPanel();
            }
        }

        public function watchWaitingStop():void
        {
            if (_waiting)
            {
                    _watchWaitingPanel.exitPanel();
            }
        }

        public function waitingForceStop():void
        {
            if ( _waitingPanel ) _waitingPanel.forceExitPanel();
            if ( _radderWaitingPanel ) _radderWaitingPanel.forceExitPanel();
            if ( _watchWaitingPanel ) _watchWaitingPanel.forceExitPanel();
        }

        public function removeCreateButtons():void
        {
            _createRoomButtons = null;
        }

        public function removeQuickButtons():void
        {
            _quickStartButtons = null;
        }



        public function addQuickmatchList(rule:int):void
        {
            _server.csAddQuickmatchList(rule);
        }

        public function deleteQuickmatchList():void
        {
            log.writeLog(log.LV_INFO, this, "[deleteQuickmatchList]");
//            _server.csDeleteQuickmatchList();
        }

        // public function deleteQuickmatchList():void
        // {
        //     log.writeLog(log.LV_INFO, this, "[deleteQuickmatchList]");
        //     _server.csDeleteQuickmatchList();
        // }

        public function quickmatchCancelOrder():void
        {
            log.writeLog(log.LV_INFO, this, "[quickmatchCancelOrder]");
            _server.csQuickmatchCancel();
        }

        public function quickmatchCancel(is_success:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "[quickmatchCancel]");
            if ( _radderWaitingPanel ) _radderWaitingPanel.cancelExec(is_success);
        }

        public function watchCancelSuccess():void
        {
            log.writeLog(log.LV_INFO, this, "[watchCancel]");
            if ( _watchWaitingPanel ) _watchWaitingPanel.cancelExec();
        }

        public function joinRoom(uid:String):void
        {
            _server.csRoomJoin(uid);
        }
        public function exitRoom(uid:String):void
        {
            _server.csRoomExit(uid);
        }
        public function deleteRoom(uid:String):void
        {
            _server.csRoomDelete(uid);
        }

        public function achievementClearCheck():void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "ACHICACAachie");
                _server.csAchievementClearCheck();
            }
        }

        public function roomFriendCheck(roomId:String, hostAvatarId:int, guestAvatarId:int):void
        {
            _server.csRoomFriendCheck(roomId, hostAvatarId, guestAvatarId);
        }

        // メッセージログの更新と追記
        public function setMessage(msg:String):void
        {
            _gameLog.setMessage(msg);
        }


        // エラーパネルのボタンハンドラ（アラートの多重起動を防ぐ）
        protected override function errorOffHandler(event:Event):void
        {
//            log.writeLog(log.LV_FATAL, this, "state is ", _state);
            waitingStop();
            super.errorOffHandler(event);
        }


    }
}