package controller
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    import mx.containers.*;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import sound.bgm.LobbyBGM;
    import sound.se.*;
    import sound.BaseSound;
    import sound.bgm.*;
    import sound.se.*;


    import net.Host;

    import model.*;
    import model.events.*;
    import view.*;
    import view.utils.*;
    import view.scene.raid.*;
    import net.server.*;


    /**
     * レイドチャットコントロールクラス
     *
     */
    public class RaidRankCtrl extends BaseCtrl
    {
        public static const BOSS_HP_UPDATE:String   = "boss_hp_update";

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "レイドチャット";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Raid Chat";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "突擊頻道";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "突击聊天";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Raid chat";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS	:String = "Raid Rank";


        protected static var __instance:RaidRankCtrl; // シングルトン保存用

        private var _server:RaidrankServer;
        private var _connected:Boolean = false;        // Serverにコネクトしているか？
        private var _updateEnable:Boolean = true;

        public function RaidRankCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            // ロビーサーバを登録
            _server = RaidrankServer.instance;
            init();
            setHandler();

        }
        private function setHandler():void
        {
        }

        private static function createInstance():RaidRankCtrl
        {
            return new RaidRankCtrl(arguments.callee);
        }

        public static function get instance():RaidRankCtrl
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
        public function start():void
        {
            log.writeLog(log.LV_DEBUG, this, "start");
            // ロビーサーバにつなぐ
            _server.connect();
            waitConnectThread.start();
            //waitConnectThreadStart();
        }

        // connecetWaitスレッドが使うスタートコマンド
        public override function waitStart():void
        {
            log.writeLog(log.LV_DEBUG, this, "wait start", _server.state);
            _server.start(this);

        }

        protected override function get serverName():String
        {
            return _TRANS;
        }


        public override function get connected():Boolean
        {
            return _connected;
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

        // ランキング更新
        public function updateRankList(prfId:int, start:int, count:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "rank request");
                var invId:int = ProfoundInventory.getProfoundInventoryIdForPrfId(prfId);
                _server.csRequestRankingList(invId,start,count);
            }
        }

        // 自分のランク更新
        public function updateMyRank(prfId:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "rank request");
                var invId:int = ProfoundInventory.getProfoundInventoryIdForPrfId(prfId);
                _server.csRequestRankInfo(invId);
            }
        }

        public function getProfoundResultRanking(id:int):void
        {
            if (connected)
            {
                _server.csGetProfoundResultRanking(id);
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



    }
}

