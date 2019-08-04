package controller
{

    import flash.events.*;

    import mx.controls.*;
    import mx.events.*;
    import org.libspark.thread.Thread;

    import model.*;
    import model.events.*;
    import net.server.*;
    import net.Host;
    import view.MainView;

    /**
     * チャットコントロールクラス
     *
     */
    public class ChatCtrl extends BaseCtrl
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "チャット";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Chat";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "聊天";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "聊天";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "채팅";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Chat";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "チャット";

        CONFIG::LOCALE_TH
        private static const _TRANS :String = "แชท";


//         private static var FONT_HEIGHT:int = 14;  // フォントの高さ
//         private static var AREA_HEIGHT:int = 280;  // エリアの高さ

        protected static var __instance:ChatCtrl; // シングルトン保存用
        private static var __waitingThread:Thread;
        public static const CONNECT_UPDATE:String = "connect_update";
        public static const MATCH_LOG_UPDATE:String = "match_log_update";
        public static var currentChannel:int;

        private  var _foeID:int;
        private  var _foeName:String = "";
        private var _server:ChatServer;
        private var _view:MainView;
        private var _allLog:MessageLog = MessageLog.getMessageLog(MessageLog.ALL_LOG);
        private var _channelLog:MessageLog = MessageLog.getMessageLog(MessageLog.CHANNEL_LOG);
        private var _gameLog:MessageLog = MessageLog.getMessageLog(MessageLog.GAME_LOG);
        private var _matchLog:MessageLog = MessageLog.getMessageLog(MessageLog.MATCH_LOG);
        private var _watchLog:MessageLog = MessageLog.getMessageLog(MessageLog.WATCH_LOG);
        private var _started:Boolean = false;

        private var _host:String;
        private var _port:uint;

        protected var _connected:Boolean = false;        // Serverにコネクトしているか？


        public function ChatCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            _server = ChatServer.instance;
            _channelLog.addEventListener(MessageLogEvent.SPEAKING_CHANNEL, chatChannelMesseageHandler);
            _matchLog.addEventListener(MessageLogEvent.SPEAKING_DUEL, chatDuelMesseageHandler);
            _watchLog.addEventListener(MessageLogEvent.SPEAKING_AUDIENCE, chatAudienceMesseageHandler);
            init();
        }

        private static function createInstance():ChatCtrl
        {
            return new ChatCtrl(arguments.callee);
        }

        public static function get instance():ChatCtrl
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }

        private function stateChangeHandler(event:StateChangeEvent):void
        {
            if (!connected)
            {
            }
        }

        public function set foeID(i:int):void
        {
            _foeID = i;
        }

        public function get foeID():int
        {
            return _foeID;
        }

        public function set foeName(s:String):void
        {
            _foeName = s.replace("_rename","");
        }

        public function get foeName():String
        {
            return _foeName;
        }


        protected override function get server():Server
        {
           return  _server;
        }

        public override function get connected():Boolean
        {
            return _connected;
        }

        public override function set connected(b:Boolean):void
        {
            _connected = b;
            dispatchEvent(new Event(CONNECT_UPDATE));
        }

        protected override function get waitingThread():Thread
        {
            return __waitingThread
        }

        protected override function set waitingThread(t:Thread):void
        {
            __waitingThread = t;
        }
        protected override function get serverName():String
        {
//            return "チャット";
            return _TRANS;
        }



        /**
         * チャットのスタート
         *
         */
        public function start():void
        {
             if (!connected)
             {
                 if (_started != true)
                 {
//                      _server.connect();
//                      _server.start(this);
                     _started = true;
                     waitConnectThreadStart();
                 }
             }
        }


        // connecetWaitスレッドが使うスタートコマンド
        public override function waitStart():void
        {
            log.writeLog(log.LV_FATAL, this, "start", _server.state);
            _server.start(this);
            _started = false;

        }

        // チャンネルが選択されてからサーバーに接続する
        public function selectChannelServerConnect(host:String, port:int):void
        {
            log.writeLog(log.LV_FATAL, this, "+++++++++++++++",!connected, (host!=_server.getHost()),(port!=_server.getPort()));
            if (!connected||(host!=_server.getHost())||(port!=_server.getPort()))
            {
                _server.connect(host,port);
            }
        }

        // チャンネルから出て、サーバを切断して次のコネクトを待つ
        public function exitChannelServerDisconnect():void
        {
            _server.exit();
            connected = false;
            waitConnectThreadStart();
        }

        public override function exit():void
        {
            connected = false;
            _server.exit();
            super.exit();
        }


         // 使用する部品を登録
        public function setTextInputs(chatInput:TextInput, chatText:TextArea):void
        {

        }

        private function chatChannelMesseageHandler(e:MessageLogEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "message event channel", e);
            _server.chatMessageChannel(e.str, e.id);
        }

        private function chatDuelMesseageHandler(e:MessageLogEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "message event duel", e);
            _server.chatMessageDuel(e.str, e.id);
        }

        private function chatAudienceMesseageHandler(e:MessageLogEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "message event audience", e);
            _server.chatMessageAudience(e.str);
        }

        // チャットログの更新と追記
        public function setAllChatMessage(msg:String):void
        {
            _allLog.setMessage(msg);
        }

        // チャットチャットログの消去
        public function clearAllChatLog():void
        {
            _allLog.clearLog();
        }

        // デュエルチャットログの更新と追記
        public function setDuelChatMessage(msg:String):void
        {
            _matchLog.setMessage(msg);
//            log.writeLog(log.LV_FATAL, this, "chat log ++++++++", "^"+_foeName, (msg.match(new RegExp("^"+_foeName, "g"))));
            if (msg.match(new RegExp("^"+_foeName+":", "g")).length>0)
            {
                dispatchEvent(new Event(MATCH_LOG_UPDATE));
            }
        }
        public function logsend(l:String):void
        {
            log.writeLog(log.LV_FATAL, this, l);
        }


        // デュエルチャットログの消去
        public function clearDuelChatLog():void
        {
            _matchLog.clearLog();
        }

        // ゲームチャットログの更新と追記
        public function setGameChatMessage(msg:String):void
        {
            _gameLog.setMessage(msg);
        }

        // デュエルチャットログの消去
        public function clearGameChatLog():void
        {
            _gameLog.clearLog();
        }

        // チャンネルチャットログの更新と追記
        public function setChannelChatMessage(msg:String):void
        {
            _channelLog.setMessage(msg);
        }

        // チャンネルチャットログの消去
        public function clearChannelChatLog():void
        {
            _channelLog.clearLog();
        }

        // 観戦チャットログの更新と追記
        public function setAudienceChatMessage(msg:String):void
        {
            _watchLog.setMessage(msg);
        }

        // 観戦チャットログの消去
        public function clearAudienceChatLog():void
        {
            _watchLog.clearLog();
        }

        public function channelIn(id:int):void
        {
//             log.writeLog(log.LV_FATAL, this, "serverrr state!!!!!!!!!!!", _server.state);
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 currentChannel = id;
                _server.channelIn(id);
             }
        }
        public function channelOut(id:int):void
        {
            if (_server.state == Host.CONNECT_AUTHED)
            {
                _server.channelOut(id);
            }
        }

        public function audienceChannelIn(roomId:String):void
        {
             log.writeLog(log.LV_FATAL, this, "*************audienceChannelIn", roomId);
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.audienceChannelIn(roomId);
             }
        }
        public function audienceChannelOut():void
        {
            if (_server.state == Host.CONNECT_AUTHED)
            {
                _server.audienceChannelOut();
            }
        }


        // サーバ接続時イベントハンドラ
        protected override function getServerConnectedHandler(evt:Event):void
        {
            super.getServerConnectedHandler(evt);
        }



    }
}