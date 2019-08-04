package net.server
{
    import flash.events.Event;
    import net.*;
    import net.command.*;
    import model.Player;
    import model.ProfoundRanking;
    import model.ProfoundNotice;
    import controller.RaidRankCtrl;

    /**
     * レイドランク情報を扱うクラス
     *
     */
    public class RaidrankServer extends Server
    {

        private var _command:RaidrankCommand;
        private var _crypted_sign:String;
        private var _ctrl:RaidRankCtrl;

        private static var __instance:RaidrankServer;

        // 初期化 サーバを取得
        public function RaidrankServer(caller:Function = null)
         {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor."); 
            _command = new RaidrankCommand(this);
         }

        private static function createInstance():RaidrankServer
        {
            return new RaidrankServer(arguments.callee);
        }

        public static function get instance():RaidrankServer
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }

        // コンフィグからのロード
        protected override function configLoad():void
        {
            log.writeLog(log.LV_DEBUG, this,"configload");
            address = Config.raidRankServerInfo.address;
            port = Config.raidRankServerInfo.port;
            log.writeLog(log.LV_DEBUG, this,"configload",address,port);
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("","","","","","","","RRS["+address+":"+port.toString()+"] ");
            }
        }

        protected override function get command():Command
        {
            return _command;
        }

        public function start(ctrl:RaidRankCtrl):void
        {
            log.writeLog(log.LV_DEBUG, this,"start");
            _ctrl= ctrl;
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"raid rank p_session", player.session);
            host.setSessionKey(player.session);
        }

        // 終了
        public override function exit():void
        {
            super.exit();
        }

        // オーバライド前提のHeartBeatHandler
        protected override function heartBeatHandler(e:Event):void
        {
            host.sendCommand(_command.csKeepAlive());
        }


        public function getPort():int
        {
            return port;
        }


        public function getHost():String
        {
            return address;
        }

        // ランキング一覧の取得
        public function csRequestRankingList(invId:int, offset:int, count:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestRankingList", invId, offset, count);
            host.sendCommand(_command.csRequestRankingList(invId, offset, count));
        }

        // ランキング情報の取得
        public function csRequestRankInfo(invId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestRankInfo");
            host.sendCommand(_command.csRequestRankInfo(invId));
        }

        // 渦の最終ランキング取得
        public function csGetProfoundResultRanking(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs GetProfoundResultRanking", id);
            host.sendCommand(_command.csGetProfoundResultRanking(id));
        }


        /**
         * 受信コマンド
         *
         */

        // ネゴシエーション処理の返答
        public function negoCert(crypted_sign:String, ok:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"negotiated");
            host.sendCommand(_command.login("yes, ok.",crypted_sign));
        }

        // ログインOK
        public function loginCert(msg:String, hash_key:String):void
        {
            log.writeLog(log.LV_INFO, this,"server messeage", msg);
        }

        // ログイン失敗
        public function loginFail():void
        {
            log.writeLog(log.LV_FATAL, this,"Login Failed!!");
        }

        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }

        public function scUpdateRank(prfId:int, rank:int, point:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateRank", prfId,rank,point);
            var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(prfId);
            if (prfRank) prfRank.updateMyRank(rank,point);
        }

        public function scUpdateRankingList(prfId:int, start:int, rankList:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateTotalDuelRankingList", start, rankList);
            var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(prfId);
            if (prfRank) prfRank.updateData(start,arraySeparateThree(rankList.split(",")));
        }

        // 最終ランキング取得
        public function scProfoundResultRanking(resultRanking:String):void
        {
            log.writeLog(log.LV_INFO, this, "scProfoundResultRanking",resultRanking);
            var noticeData:Array = resultRanking.split("+");
            var prfId:int = int(noticeData.shift());
            var noticeType:int = int(noticeData.shift());
            var selfRankStr:String = noticeData.shift();
            var rankingStrList:String = noticeData.shift();
            ProfoundNotice.setRankingList(prfId,noticeType,selfRankStr,rankingStrList);
        }



    }
}