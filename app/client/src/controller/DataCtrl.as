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
    public class DataCtrl extends BaseCtrl
    {
        public static const UPDATE_FRIEND_LIST:String = "update_friend_list";


        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "Data";

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
        private static const _TRANS	:String = "Data";

        CONFIG::LOCALE_TH
        private static const _TRANS	:String = "Data";


        protected static var __instance:DataCtrl; // シングルトン保存用

        private var _server:DataServer;
        private var _connected:Boolean = false;        // Serverにコネクトしているか？
        private var _updateEnable:Boolean = true;


        public function DataCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            // ロビーサーバを登録
            _server = DataServer.instance;
            init();
        }
        private static function createInstance():DataCtrl
        {
            return new DataCtrl(arguments.callee);
        }

        public static function get instance():DataCtrl
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
            return _TRANS;
        }

        // アバター作製終了をサーバに知らせる
        public function createAvatarSuccess():void
        {
            _server.csCreateAvatarSuccess();
        }

        // 友人を招待
        public function friendInvite(uid:String):void
        {
            _server.csFriendInvite(uid);
        }
        // 友人へカムバック依頼
        public function sendComebackFriend(uid:String):void
        {
            _server.csSendComebackFriend(uid);
        }


        // チャンネル情報を要求
        public function requestChannelInfo():void
        {
            if (connected)
            {
                _server.csRequestChannelListInfo();
            }
        }

        // 友人リストの更新
        public function requestFriendsInfo():void
        {
            if (connected)
            {
                _server.csRequestFriendsInfo();
            }
        }

        // 友人リストの更新
        public function requestFriendList(type:int,offset:int,count:int):void
        {
            if (connected)
            {
                _server.csRequestFriendList(type,offset,count);
            }
        }

        public function updateFriendList():void
        {
            dispatchEvent(new Event(UPDATE_FRIEND_LIST));
        }

      // アバターの検索
        public function searchAvatar(name:String):void
        {
            if (connected)
            {
                _server.csFindAvatar(name);
            }
        }
      // アバターの検索
        public function searchAvatarFinish():void
        {
            FriendListView.searchEnd();
        }

       // 友人はゲームを始めてるか？
        public function friendExist(uid:String):void
        {
        }
        public function updateRankList(k:int,start:int, count:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "rank request");
                _server.csRequestRankingList(k,start,count,Const.SERVER_SB);
            }
        }

        public function updateMyRank(k:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "rank request");
                _server.csRequestRankInfo(k, Const.SERVER_SB);
            }
        }

        public function getProfoundForHash(hash:String):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "get profound",hash);
                _server.csGetProfound(hash);
            }
        }

        public override function get connected():Boolean
        {
            return _server.state == Host.CONNECT_AUTHED;
        }

        public override function set connected(b:Boolean):void
        {
             _connected = b;
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


    }
}