package net.server
{
    import flash.events.Event;
    import net.*;
    import net.command.*;
    import model.Player;
    import controller.RaidChatCtrl;

    /**
     * レイドチャットの情報を扱うクラス
     *
     */
    public class RaidchatServer extends Server
    {

        private var _command:RaidchatCommand;
        private var _crypted_sign:String;
        private var _ctrl:RaidChatCtrl;

        private static var __instance:RaidchatServer;

        // 初期化 サーバを取得
        public function RaidchatServer(caller:Function = null)
         {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor."); 
            _command = new RaidchatCommand(this);
         }

        private static function createInstance():RaidchatServer
        {
            return new RaidchatServer(arguments.callee);
        }

        public static function get instance():RaidchatServer
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
            address = Config.raidChatServerInfo.address;
            port = Config.raidChatServerInfo.port;
            log.writeLog(log.LV_DEBUG, this,"configload",address,port);
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("","","","","","RCS["+address+":"+port.toString()+"] ");
            }
        }

        protected override function get command():Command
        {
            return _command;
        }

        public function start(ctrl:RaidChatCtrl):void
        {
            log.writeLog(log.LV_DEBUG, this,"start");
            _ctrl= ctrl;
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"raid chat p_session", player.session);
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

        // コメント保存
        public function csSetComment(prfId:int,comment:String,lastId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs SetComment");
            host.sendCommand(_command.csSetComment(prfId,comment,lastId));
        }

        // コメント取得要求
        public function csRequestComment(prfId:int,lastId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestComment");
            host.sendCommand(_command.csRequestComment(prfId,lastId));
        }

        // BossHp更新
        public function csUpdateBossHP(prfId:int,nowDamage:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs UpdateBossHP");
            host.sendCommand(_command.csUpdateBossHp(prfId,nowDamage));
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

        // コメント取得
        public function scUpdateComment(prfId:int,comment:String,lastId:int):void
        {
            log.writeLog(log.LV_INFO, this, "sc SendComment");
            _ctrl.updateComment(prfId,comment,lastId);
        }

        // BossHp更新
        public function scSendBossDamage(prfId:int,damage:int,strData:String,state:int,stateUpdate:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "sc SendBossDamage",damage,state,stateUpdate);
            _ctrl.sendBossDamage(prfId,damage,strData,state,stateUpdate);
        }

        // BossHp更新
        public function scUpdateBossHp(prfId:int,damage:int):void
        {
            log.writeLog(log.LV_INFO, this, "sc UpdateBossHP",damage);
            _ctrl.setUpdateBossHP(prfId,damage);
        }



    }
}