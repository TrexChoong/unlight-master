package model
{
    import flash.events.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import model.events.*;
    import controller.*;

    /**
     * メッセージのログ情報を扱うクラス
     * チャットやゲームログを保存する
     */
    public class MessageLog extends EventDispatcher
    {
        // ログのタイプ
        public static const ALL_LOG:int     = 0;
        public static const SYSTEM_LOG:int  = 1;
        public static const GAME_LOG:int    = 2;
        public static const CHANNEL_LOG:int = 3;
        public static const MATCH_LOG:int   = 4;
        public static const WATCH_LOG:int   = 5;
        public static const ROOM_LOG:int    = 6;
        public static const CHANNEL_LOG_A:int = 7;
        public static const CHANNEL_LOG_B:int = 8;
        public static const CHANNEL_LOG_C:int = 9;
        public static const CHANNEL_LOG_DUEL:int = 10;
        public static const CHANNEL_LOG_WATCH:int = 11;

        // ログが保持する行数のMAX
        public static const LOG_LINE_MAX:int    = 999;

        // インスタンスが収納される配列
        private static var __logs:Array= []; /* of MessageLog */ 
        private static var __messages:Array=new Array([], [], [], [], [], [], [], [], [], [], [], []); /* of Array */  //すべてのログメッセージの配列

        // 収納ログ
        private var _log:Array; /* of String */

        // 更新関数
        private var _update:Function;

        // ALL_LOGのメッセージログへのポインタ
        private var _allLog:MessageLog;
        // タイプ
        private var _type:int;

        /**
         * コンストラクタ
         *
         */
        public function MessageLog(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor."); 
        }



        // 本当のコンストラクタ
        private static function createInstance():MessageLog
        {
            return new MessageLog(arguments.callee);
        }

        // Factory
        public static function getMessageLog(type:int):MessageLog
        {
            if (__logs[type] == null)
            {
                __logs[type] = createInstance();
                __logs[type].initLog(type);
            }
            return __logs[type];
        }

        // 初期化
        public function initLog(type:int):void
        {
            _type = type;
            _log = __messages[type];
            if (type == ALL_LOG)
            {
                _update = setMessageAllLog;
            }else{
                _allLog = getMessageLog(ALL_LOG);
                _update = setMessageNormal;
            }
        }


        // ログを空に
        public function clearLog():void
        {
            _log =[];
            FriendLink.clearBlockNameList();
            dispatchEvent(new MessageLogEvent(MessageLogEvent.UPDATE, ""));
        }

        private function escapeHtml(s:String):String
        {
            return s.replace(/[&]/g,"&amp;").replace(/[<]/g,"&lt;").replace(/[>]/g,"&gt;");
        }

        // 通常のメッセージ更新関数
        private function setMessageNormal(str:String):void
        {
            // もしブロック済みならなにもしない
            var name:String = str.substring(0, str.indexOf(":"));
            if (FriendLink.getBlockNameList().hasOwnProperty(name))
            {

            }else{
                if (_type == MATCH_LOG || _type == WATCH_LOG)
                {
                    str = "<font color = \"#FFFF00\">"+str+"</font>";
                }
                _log.push(str);
                maxCheck();
                _allLog.setMessage(str, false);
                dispatchEvent(new MessageLogEvent(MessageLogEvent.UPDATE,str));
            }
        }

        private function maxCheck():void
        {
            if (_log.length>LOG_LINE_MAX)
            {
                _log.shift();
            }
        }


        // 通常のメッセージ全体用メッセージ更新関数
        private function setMessageAllLog(str:String):void
        {
            _log.push(str);
            maxCheck();
            dispatchEvent(new MessageLogEvent(MessageLogEvent.UPDATE, str));
        }

        // メッセージ更新
        public function setMessage(str:String, validate:Boolean = true):void
        {
            if (validate)
            {
                _update(escapeHtml(str.replace("_rename","")));
            }else{
                _update(str.replace("_rename",""));
            }
        }

        public function  get log():String
        {
            return (_log.length > 0) ? _log.join("\n") : "";
        }

        public function  get type():int
        {
            return _type;
        }

        // 全員に話す
        public function speakChannel(id:int, str:String):void
        {
            dispatchEvent(new MessageLogEvent(MessageLogEvent.SPEAKING_CHANNEL, str,id));

        }

        // 特定のプレイヤーに話す
        public function speakDuel(id:int,str:String):void
        {
            dispatchEvent(new MessageLogEvent(MessageLogEvent.SPEAKING_DUEL, str, id));
        }

        // 観戦者に話す
        public function speakAudience(id:int,str:String):void
        {
            dispatchEvent(new MessageLogEvent(MessageLogEvent.SPEAKING_AUDIENCE, str, id));
        }

    }
}
