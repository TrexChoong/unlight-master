package controller
{
    import flash.events.*;

    import mx.controls.Alert;

    import sound.bgm.LobbyBGM;
    import sound.bgm.TitleBGM;
    import sound.se.*;
    import sound.BaseSound;

    import net.server.*;
    import net.Host;


    import model.*;
    import model.events.*;
    import view.*;
    import view.LobbyView;
    import view.scene.common.*;
    /**
     * ロビー画面コントロールクラス
     *
     */
    public class GlobalChatCtrl extends BaseCtrl
    {

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "GlobalChat";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Lobby";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "大廳";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "大厅";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "로비";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Hall";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "GlobalChat";

        CONFIG::LOCALE_TH
        private static const _TRANS	:String = "GlobalChat";


        protected static var __instance:GlobalChatCtrl; // シングルトン保存用

        private var _server:GlobalchatServer;
        private var _connected:Boolean = false;        // Serverにコネクトしているか？


        public function GlobalChatCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            // ロビーサーバを登録
            _server = GlobalchatServer.instance;
            init();
        }
        private static function createInstance():GlobalChatCtrl
        {
            return new GlobalChatCtrl(arguments.callee);
        }

        public static function get instance():GlobalChatCtrl
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        protected override function get server():Server
        {
           return  _server;
        }

        /**
         * ロビーのスタート
         *
         */
        public function start(view:LobbyView):void
        {
            // ロビーサーバにつなぐ
            _server.connect();
            waitConnectThread.start();
        }

        // connecetWaitスレッドが使うスタートコマンド
        public override function waitStart():void
        {
            log.writeLog(log.LV_FATAL, this, "start", _server.state);
            _server.start(this);

        }

        protected override function get serverName():String
        {
//            return "ロビー";
            return _TRANS;
        }


        public override function get connected():Boolean
        {
            return _server.state == Host.CONNECT_AUTHED;
        }

        public override function set connected(b:Boolean):void
        {
             _connected = b;
             if (b)
             {
                 // updateRankList(4,0,10);
                 // updateMyRank(1);

             }

        }

        public function restart():void
        {
            if (!connected)
            {
                _server.connect();
                waitConnectThread.start();
            }
        }

        // サーバ切断時イベントハンドラ
        protected override function getServerDisconnectedHandler(evt:Event):void
        {
            _server.connect();

        }

        // =============================================================================
        // =============================================================================

        public function addHelpList(key:String,help:String):void
        {
            if (connected) {
                _server.csAddHelpList(key,help);
            }
        }

        public function updateHelp(plId:int,name:String,hash:String):void
        {
            dispatchEvent(new RaidHelpEvent(RaidHelpEvent.UPDATE, plId,name.replace("_rename",""),hash));
        }

        public function acceptHelp(plId:int,name:String,hash:String):void
        {
            Profound.urlProfoundHash = hash;
            dispatchEvent(new RaidHelpEvent(RaidHelpEvent.ACCEPT, plId,name.replace("_rename",""),hash));
        }

    }
}