package net.server
{
    import flash.events.Event;
    import net.*;
    import net.command.*;
    import model.*;
    import model.utils.Cache;
    import model.utils.ClientLog;
    import model.events.*;
    import controller.GlobalChatCtrl;
    import controller.LobbyCtrl;
    import view.*;
    import view.utils.*;

    import model.utils.ConstData;

    /**
     * ロビーサーバからの通信を扱うクラス
     *
     */
    public class GlobalchatServer extends Server
    {
        private var _command:GlobalchatCommand;
        private var _crypted_sign:String;
        private var _ctrl:GlobalChatCtrl;

        private static var __instance:GlobalchatServer;


        // 初期化 サーバを取得
        public function GlobalchatServer(caller:Function = null)
        {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
             _command = new GlobalchatCommand(this);
        }

        private static function createInstance():GlobalchatServer
        {
            return new GlobalchatServer(arguments.callee);
        }

        public static function get instance():GlobalchatServer
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        // コンフィグからのロード
        protected override function configLoad():void
        {
            log.writeLog(log.LV_INFO, this,"configload");
            address = Config.globalChatServerInfo.address;
            port = Config.globalChatServerInfo.port;
            CONFIG::DEBUG
            {
                log.writeLog(log.LV_INFO, this,"configload global chat",address,port);
                Unlight.INS.updateSeverInfo("","","","","","","","","GCS["+address+":"+port.toString()+"]");
            }

        }

        // コマンドの登録
        protected override function get command():Command
        {
            return _command;
        }

        /**
         * サーバのスタート
         *
         */
        public function start(ctrl:GlobalChatCtrl):void
        {
            _ctrl= ctrl
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"global chat server p_session", player.session);
            host.setSessionKey(player.session);
        }


        // 終了
        public override function exit():void
        {
            host.sendCommand(_command.logout());
            super.exit();
        }

        // オーバライド前提のHeartBeatHandler
        protected override function heartBeatHandler(e:Event):void
        {
            host.sendCommand(_command.csKeepAlive());
        }

        /**
         * 送信コマンド
         *
         */

        public function csAddHelpList(key:String,help:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"csAddHelpList",key,help);
            host.sendCommand(_command.csAddHelpList(key,help));
        }

        /**
         * 受信コマンド
         *
         */

        // ネゴシエーション処理の返答
        public function negoCert(crypted_sign:String, ok:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"negotiated ");
            host.sendCommand(_command.login("yes, ok.",crypted_sign));
        }

        // ログインOK
        public function loginCert(msg:String, hash_key:String):void
        {
            log.writeLog(log.LV_DEBUG, "[GlobalchatServer] loginCert.");
            log.writeLog(log.LV_DEBUG, this,"server messeage", msg);
        }

       // ログインOK
        public function loginFail():void
        {
            log.writeLog(log.LV_FATAL, this,"Login Failed!!");
        }


        public function scSendHelp(key:String,avatarName:String,help:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"scSendHelp",key,avatarName,help);
            _ctrl.updateHelp(int(key),avatarName,help);
        }

        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {
            // レイドに関するエラーはProfoundで一度保持する
            if (e == Const.ERROR_PRF_FINISHED || e == Const.ERROR_PRF_HAVE_MAX_OVER) {
                Profound.urlErrorId = e;
            }
            // チケット不足の時に終了イベントを送る
            if (e==70)
            {
//                _ctrl.rareCardEventFinish();
            }

//            _ctrl.waitingStop();
        }

        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }





    }
}




