package net.server
{
    import flash.events.Event;
    import net.*;
    import net.command.*;
    import model.Player;
    import controller.ChatCtrl;

    /**
     * チャットの情報を扱うクラス
     *
     */
    public class ChatServer extends Server
    {

        private var _command:ChatCommand;
        private var _crypted_sign:String;
        private var _ctrl:ChatCtrl;

        private static var __instance:ChatServer;

        // 初期化 サーバを取得
        public function ChatServer(caller:Function = null)
         {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor."); 
            _command = new ChatCommand(this);
         }

        private static function createInstance():ChatServer
        {
            return new ChatServer(arguments.callee);
        }

        public static function get instance():ChatServer
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        protected override function get command():Command
        {
            return _command;
        }

        public function start(ctrl:ChatCtrl):void
        {
            _ctrl= ctrl;
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"chat p_session", player.session);
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



        public function chatMessage(msg:String):void
        {
            host.sendCommand(_command.csMessage(msg));
        }

        public function chatMessageDuel(msg:String, id:int):void
        {
            host.sendCommand(_command.csMessageDuel(msg, id));
        }

        public function chatMessageChannel(msg:String, id:int):void
        {
            host.sendCommand(_command.csMessageChannel(msg, id));
        }

        public function chatMessageAudience(msg:String):void
        {
            log.writeLog(log.LV_INFO, this, "Audience", msg);
            host.sendCommand(_command.csMessageAudience(msg));
        }

        public function channelIn(id:int = 0):void
        {
            host.sendCommand(_command.csChannelIn(id));
        }

        public function channelOut(id:int = 0):void
        {
            host.sendCommand(_command.csChannelOut(id));
        }

        public function audienceChannelIn(roomId:String):void
        {
            host.sendCommand(_command.csAudienceChannelIn(roomId));
        }

        public function audienceChannelOut():void
        {
            host.sendCommand(_command.csAudienceChannelOut());
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

        // チャット内容を受け取る
        public function scSendMessage(msg:String, type:int):void
        {
            log.writeLog(log.LV_INFO, this,"get chat messeage", msg);
            _ctrl.setAllChatMessage(msg);
        }

        // デュエルチャット内容を受け取る
        public function scSendDuelMessage(id:int, msg:String ):void
        {
            log.writeLog(log.LV_INFO, this,"get chat  duel, messeage", msg);
            _ctrl.setDuelChatMessage(msg);
        }

        // チャンネルチャット内容を受け取る
        public function scSendChannelMessage(id:int, msg:String ):void
        {
            log.writeLog(log.LV_INFO, this,"get chat channel, messeage", msg);
            _ctrl.setChannelChatMessage(msg);
        }

        // 観戦者チャット内容を受け取る
        public function scSendAudienceMessage(id:int, msg:String ):void
        {
            log.writeLog(log.LV_INFO, this,"get chat Audience messeage", msg);
            _ctrl.setAudienceChatMessage(msg);
        }

        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }


    }
}