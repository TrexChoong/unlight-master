package model
{
    import flash.events.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import controller.RaidChatCtrl;

    import model.events.*;

    /**
     * 全て渦のログ情報を管理するクラス
     */
    public class ProfoundLogs extends EventDispatcher
    {
        // ログのタイプ
        public static const ALL_LOG:int      = 0;
        public static const CHAT_LOG:int     = 1;
        public static const PRF_LOG:int      = 2;
        public static const GAME_LOG:int     = 3;
        public static const GAME_ALL_LOG:int = 4;

        private static var __instance:ProfoundLogs = null;

        // インスタンスが収納される配列
        private var _allLogs :Object    = new Object(); /* of ProfoundLog */
        private var _chatLogs:Object    = new Object(); /* of ProfoundLog */
        private var _prfLogs :Object    = new Object(); /* of ProfoundLog */
        private var _gameLogs:Object    = new Object(); /* of ProfoundLog */
        private var _gameAllLogs:Object = new Object(); /* of ProfoundLog */

        // 選択中のPrfID
        private var _prfId:int = 0;


        // 管理インスタンス取得
        public static function getInstance():ProfoundLogs
        {
            if (__instance == null) __instance = new ProfoundLogs(arguments.callee);
            return __instance;
        }

        /**
         * コンストラクタ
         *
         */
        public function ProfoundLogs(caller:Function=null)
        {
            if( caller != getInstance ) throw new ArgumentError("Cannot user access constructor."); 
            init();
        }

        private function init():void
        {
            // 0番を作ってしまう
            _allLogs[0] = new ProfoundLog(0);
            _chatLogs[0] = new ProfoundLog(0);
            _prfLogs[0] = new ProfoundLog(0);
            _gameLogs[0] = new ProfoundLog(0);
            _gameAllLogs[0] = new ProfoundLog(0);
        }

        // Factory
        private function allLog(prfId:int):ProfoundLog
        {
            if (_allLogs[prfId] == null) _allLogs[prfId] = new ProfoundLog(prfId);
            return _allLogs[prfId];
        }

        // Factory
        private function chatLog(prfId:int):ProfoundLog
        {
            if (_chatLogs[prfId] == null) _chatLogs[prfId] = new ProfoundLog(prfId);
            return _chatLogs[prfId];
        }

        // Factory
        private function prfLog(prfId:int):ProfoundLog
        {
            if (_prfLogs[prfId] == null) _prfLogs[prfId] = new ProfoundLog(prfId);
            return _prfLogs[prfId];
        }

        // Factory
        private function gameLog(prfId:int):ProfoundLog
        {
            if (_gameLogs[prfId] == null) _gameLogs[prfId] = new ProfoundLog(prfId);
            return _gameLogs[prfId];
        }

        // Factory
        private function gameAllLog(prfId:int):ProfoundLog
        {
            if (_gameAllLogs[prfId] == null) _gameAllLogs[prfId] = new ProfoundLog(prfId);
            return _gameAllLogs[prfId];
        }

        public function setLogPrfId(prfId:int,str:String,validate:Boolean = true):void
        {
            log.writeLog(log.LV_DEBUG, this, "setLogPrfId", prfId,str);
            if (prfId == 0) return;
            prfLog(prfId).setLog(str,validate);
            allLog(prfId).setLog(str,validate);
            dispatchEvent(new ProfoundLogsEvent(ProfoundLogsEvent.UPDATE, prfId,str));
        }

        public function setGameLogPrfId(prfId:int,str:String,validate:Boolean = true):void
        {
            log.writeLog(log.LV_DEBUG, this, "setGameLogPrfId", prfId,str);
            if (prfId == 0) return;
            gameLog(prfId).setLog(str,validate);
            gameAllLog(prfId).setLog(str,validate);
            dispatchEvent(new ProfoundLogsEvent(ProfoundLogsEvent.UPDATE, prfId,str));
        }

        public function setMessagePrfId(prfId:int,str:String,validate:Boolean = true):void
        {
            log.writeLog(log.LV_DEBUG, this, "setMessagePrfId", prfId,str);
            if (prfId == 0) return;
            // もしブロック済みならなにもしない
            var name:String = str.substring(0, str.indexOf(":"));
            if (FriendLink.getBlockNameList().hasOwnProperty(name))
            {
            } else {
                chatLog(prfId).setComment(str,lastId,false);
                allLog(prfId).setComment(str,lastId,false);
                gameAllLog(prfId).setComment(str,lastId,false);
                dispatchEvent(new ProfoundLogsEvent(ProfoundLogsEvent.UPDATE, prfId, str));
            }
        }

        public function setGameMessagePrfId(prfId:int,str:String,validate:Boolean = true):void
        {
            log.writeLog(log.LV_DEBUG, this, "setGameLogPrfId", prfId,str);
            if (prfId == 0) return;
            // もしブロック済みならなにもしない
            var name:String = str.substring(0, str.indexOf(":"));
            if (FriendLink.getBlockNameList().hasOwnProperty(name))
            {
            } else {
                chatLog(prfId).setComment(str,lastId,false);
                allLog(prfId).setComment(str,lastId,false);
                gameAllLog(prfId).setComment(str,lastId,false);
                dispatchEvent(new ProfoundLogsEvent(ProfoundLogsEvent.UPDATE, prfId,str));
            }
        }

        public function setMessageLastId(prfId:int,lastId:int):void
        {
            chatLog(prfId).lastId = lastId;
            allLog(prfId).lastId = lastId;
            gameAllLog(prfId).lastId = lastId;
        }

        public function logs(type:int):String
        {
            switch (type)
            {
            case ALL_LOG:
                return allLog(_prfId).log;
                break;
            case CHAT_LOG:
                return chatLog(_prfId).log;
                break;
            case PRF_LOG:
                return prfLog(_prfId).log;
                break;
            case GAME_LOG:
                return gameLog(_prfId).log;
                break;
            case GAME_ALL_LOG:
                return gameAllLog(_prfId).log;
                break;
            default:
            }
            return "";
        }

        public function set prfId(prfId:int):void
        {
            _prfId = prfId;
            dispatchEvent(new ProfoundLogsEvent(ProfoundLogsEvent.UPDATE));
            RaidChatCtrl.instance.requestComment(_prfId,lastId);
        }
        public function get prfId():int
        {
            return _prfId;
        }
        public function get lastId():int
        {
            if (_prfId == 0) return 0;
            return chatLog(_prfId).lastId;
        }

        public function speakComment(comment:String):void
        {
            if (_prfId == 0) return;
            dispatchEvent(new ProfoundLogsEvent(ProfoundLogsEvent.SPEAK_COMMENT, _prfId, comment,lastId));
        }

        public function clearLogs(type:int,prfId:int):void
        {
            var log:ProfoundLog = null;
            switch (type)
            {
            case ALL_LOG:
                log = allLog(_prfId);
                break;
            case CHAT_LOG:
                log = chatLog(_prfId);
                break;
            case PRF_LOG:
                log = prfLog(_prfId);
                break;
            case GAME_LOG:
                log = gameLog(_prfId);
                break;
            case GAME_ALL_LOG:
                log = gameAllLog(_prfId);
                break;
            default:
            }
            if (log) {
                log.clearLog();
                if (type == GAME_ALL_LOG && chatLog(_prfId).log != "") {
                    // チャットログをコピー
                    gameAllLog(_prfId).logArr = chatLog(_prfId).logArr.concat();
                }
            }
        }

    }
}


class ProfoundLog
{
    // ログが保持する行数のMAX
    private static const LOG_LINE_MAX:int    = 999;

    // 収納ログ
    private var _log:Array = []; /* of String */

    // 更新関数
    private var _update:Function = null;

    // ProfoundId
    private var _prfId:int = 0;

    // コメント末尾ID
    private var _commentLastId:int = 0;


    /**
     * コンストラクタ
     *
     */
    public function ProfoundLog(prfId:int)
    {
        _prfId = prfId;
        _update = setMessageUpdate;
    }

    // ログを空に
    public function clearLog():void
    {
        _log =[];
    }

    private function escapeHtml(s:String):String
    {
        return s.replace(/[&]/g,"&amp;").replace(/[<]/g,"&lt;").replace(/[>]/g,"&gt;");
    }
    // メッセージ更新関数
    private function setMessageUpdate(str:String):void
    {
        _log.push(str);
        maxCheck();
    }

    private function maxCheck():void
    {
        if (_log.length>LOG_LINE_MAX)
        {
            _log.shift();
        }
    }

    // メッセージ更新
    public function setMessage(str:String, validate:Boolean = true):void
    {
        if (validate) {
            _update(escapeHtml(str.replace("_rename","")));
        } else {
            _update(str.replace("_rename",""));
        }
    }

    // ログ更新
    public function setLog(str:String,validate:Boolean=true):void
    {
        setMessage(str,validate);
    }
    // コメント更新
    public function setComment(str:String,lastId:int,validate:Boolean=true):void
    {
        str = "<font color = \"#FFFF00\">"+str+"</font>";
        setMessage(str,validate);
        _commentLastId = lastId;
    }

    public function  get log():String
    {
        return (_log&&_log.length > 0) ? _log.join("\n") : "";
    }

    public function  get prfId():int
    {
        return _prfId;
    }
    public function get lastId():int
    {
        return _commentLastId;
    }
    public function set lastId(id:int):void
    {
        _commentLastId = id;
    }
    public function get logArr():Array
    {
        return _log;
    }
    public function set logArr(a:Array):void
    {
        _log = a;
    }
}
