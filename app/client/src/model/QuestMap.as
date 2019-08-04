 // TODO:コンストラクタでIDだけ渡したい。なぜならロード失敗の時IDがわからないから。

package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * クエスト場所クラス
     * 情報を扱う
     * 
     */
    public class QuestMap extends BaseModel
    {
        public static const EVENT_QUEST_START_ID:int = 3026;
        public static const TUTORIAL_QUEST_START_ID:int = 2008;
        public static const CHARA_VOTE_QUEST_START_ID:int = 5000;

        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        private static var __loader:Function;         // パラムを読み込む関数
        private static var __questMaps:Object =[];        // ロード済みのクエスト
        private static var __loadings:Object ={};     // ロード中のクエスト

        private var _name           :String = "";          // 名前
        private var _caption        :String = "";          //キャプション
        private var _region         :int;             // 地域番号
        private var _level          :int;             // 必要レベル
        private var _ap             :int;             // 必要AP
        private var _difficulty     :int;             // 難易度（必要達成度）
        private var _version        :int;

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
        }

        private static function getData(id:int):void
        {
//             if (__loader == null)
//             {
//                 throw new Error("Warning: Loader is undefined.");
//             }else{
                var a:Array; /* of ElementType */ 
                if (ConstData.getData(ConstData.QUEST_MAP, id) != null)
                {
                    a = ConstData.getData(ConstData.QUEST_MAP, id)
                    updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], 0, true);
                }
//                 if (Cache.getCache(Cache.QUEST_MAP, id))
//                 {
//                    var a:Array = Cache.getDataParam(Cache.QUEST_MAP, id);
//                     updateParam(id, a[0], a[1], a[2], a[3],a[4], a[5], a[6], true);
// //                    log.writeLog(log.LV_FATAL, "CharaCard static", "get param cache", a);
//                 }else{
//                 __loadings[id] = true;
//                 new ReLoaderThread(__loader, QuestMap.ID(id)).start();
// //                new ReLoader(__loader, id).start();
// //                __loader(id);
//                 }
//             }
        }

        public static function clearData():void
        {
            __questMaps.forEach(function(item:QuestMap, index:int, array:Array):void{if (item != null){item._loaded = false}});
        }

        // IDのQuestMapインスタンスを返す
        public static function ID(id:int):QuestMap
        {
//            log.writeLog(log.LV_FATAL, "get feat id",id);
            if (__questMaps[id] == null)
            {
                __questMaps[id] = new QuestMap(id);
                getData(id);
            }else{
                if (!(__questMaps[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __questMaps[id];
        }

        // ローダがQuestMapのパラメータを更新する
        public static function updateParam(id:int,  name:String, caption:String, region:int, level:int, ap:int, difficulty:int, version:int, cache:Boolean=false):void
        {

//            log.writeLog(log.LV_INFO, "static QuestMap" ,"update id",id, name, image);

            if (__questMaps[id] == null)
            {
                __questMaps[id] = new QuestMap(id);
            }
            __questMaps[id]._id        = id;
            __questMaps[id]._name      = name;
            __questMaps[id]._caption   = caption;
            __questMaps[id]._region    = region;
            __questMaps[id]._level     = level;
            __questMaps[id]._ap        = ap;
            __questMaps[id]._difficulty = difficulty;

            __questMaps[id]._version   = version;

            if (!cache)
            {
                Cache.setCache(Cache.QUEST_MAP, id, name, caption, region, level, ap, difficulty,version);
            }

            if (__questMaps[id]._loaded)
            {
                __questMaps[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static QuestMap" ,"load update",id,__questMaps[id]._loaded);
            }
            else
            {
                __questMaps[id]._loaded  = true;
                __questMaps[id].notifyAll();
                __questMaps[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static QuestMap" ,"load init",id,__questMaps[id]);
            }
            __loadings[id] = false;

        }


        // コンストラクタ
        public function QuestMap(id:int)
        {
            _id = id;
        }

        public function get name():String
        {
            return _name;
        }


        public function get caption():String
        {
            return _caption;
        }

        public function get region():int
        {
            return _region;
        }
        public function get level():int
        {
            return _level;
        }
        public function get ap():int
        {
            return _ap;
        }

        public function get difficulty():int
        {
            return _difficulty;
        }


        public function getLoader():Thread
        {
            return new ReLoaderThread(__loader, this);
        }

    }
}
