package model
{
    import flash.events.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import org.libspark.thread.Thread;
    import controller.QuestCtrl;
    

    import model.events.*;
    import model.utils.*;


    /**
     * クエストログ情報を扱うクラス
     * 恒久的に保存されるログを扱う
     */
    public class QuestLog extends BaseModel
    {
        // ログの更新
        public static const INIT:String        = 'init';        // 情報をロード
        public static const SPEAKING:String    = "speaking";
        public static const UPDATE:String      = "update";

        // 1ページのMAX
        public static const PAGE_LIMIT:int     = 20;

        // インスタンスがすべて収納されるベクター
        private static var __logs:Array = []; /* of QuestLog */ ;

        private static var __loader:Function;            // パラムを読み込む関数
        private static var __loadings:Object ={};        // ロード中の必殺技


        private static var __pageSet:Vector.<Array> = new Vector.<Array>();

        private var _avatarID      :int; // アバターのID
        private var _type          :int; // タイプ
        private var _typeID        :int; // タイプID
        private var _name          :String; // 名前
        private var _body          :String; // 本文
        private var _date          :Date; // 日付
        private var _ctrl          :QuestCtrl;

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
        }

        private static function getData(id:int):void
        {
            if (__loader == null)
            {
                throw new Error("Warning: Loader is undefined.");
            }else{
                if (Cache.getCache(Cache.QUEST_LOG, id))
                {
                    var a:Array = Cache.getDataParam(Cache.QUEST_LOG, id);
                    updateParam(id, a[0], a[1], a[2], a[3], a[4], a[5], 0, true);
                    log.writeLog(log.LV_FATAL, "CharaCard static", "get param cache", a);
                }else{
                    __loadings[id] = true;
                    log.writeLog(log.LV_FATAL, "CharaCard static", "get param server", a);
                    new ReLoaderThread(__loader, QuestLog.ID(id)).start();
                }
            }
        }


        // データを再読込（再ログイン時にデータ更新を確認するため）
        public static function clearData():void
        {
            __logs.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }

        // IDのQuestLogインスタンスを返す
        public static function ID(id:int):QuestLog
        {
            if (__logs[id] == null)
            {
                __logs[id] = new QuestLog(id);
                getData(id);
            }else{
                if (!(__logs[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __logs[id];
        }

        // ローダがQuestLogのパラメータを更新する
        public static function updateParam(id:int,  avararID:int, type:int, typeID:int, name:String, body:String, date:Number,  version:int = 0,cache:Boolean=false):void
        {
            log.writeLog(log.LV_INFO, "static QuestLog" ,"update id",id);
            if (__logs[id] == null)
            {
                __logs[id] = new QuestLog(id);
            }
            __logs[id]._id            = id;
            __logs[id]._avatarID      = avararID;
            __logs[id]._type          = type;
            __logs[id]._typeID        = typeID;
            __logs[id]._name          = name;
            __logs[id]._body          = body;
            __logs[id]._date          = new Date();
            __logs[id]._date.setTime(date);

            if (!cache)
            {
                Cache.setCache(Cache.QUEST_LOG, id, avararID, type, typeID, name, body, date,  version);
            }

            if (__logs[id]._loaded)
            {
                __logs[id].dispatchEvent(new Event(UPDATE));
                log.writeLog(log.LV_INFO, "static QuestLog" ,"load update",id,__logs[id]._loaded);
            }
            else
            {
                __logs[id]._loaded  = true;
                __logs[id].notifyAll();
                __logs[id].dispatchEvent(new Event(INIT));
                log.writeLog(log.LV_INFO, "static QuestLog" ,"load init",id,__logs[id]);
            }
            __loadings[id] = false;

        }


        // コンストラクタ
        public function QuestLog(id:int)
        {
            _id = id;
            _ctrl = QuestCtrl.instance;
        }

        public function get avararID():int
        {
            return _avatarID;
        }

        public function get type():int
        {
            return _type;
        }
        public function get typeID():int
        {
            return _typeID;
        }

        public function get name():String
        {
            return _name;
        }

        public function get body():String
        {
            return _body;
        }

        public function get date():Date
        {
            return _date;
        }

        public static function updatePageInfo(page:int, ids:Array):void
        {
            __pageSet[page] = ids;
            QuestCtrl.instance.questLogPageUpdate(page);
        }

        public static  function getPageIDs(page:int):Array 
        {
            return __pageSet[page];
        }

        public function speak(str:String):void
        {
            dispatchEvent(new DataEvent(SPEAKING, false,false,str));
        }


    }
}

