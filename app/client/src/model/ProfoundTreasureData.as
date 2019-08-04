package model
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * 渦報酬データクラス
     * 情報を扱う
     *
     */
    public class ProfoundTreasureData extends BaseModel
    {
        public static const INIT:String   = 'init';   // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード

        public static const PRF_TRS_TYPE_RANK:int     = 0; // ランク報酬
        public static const PRF_TRS_TYPE_DEFEAT:int   = 1; // 撃破報酬
        public static const PRF_TRS_TYPE_FOUND:int    = 2; // 発見報酬
        public static const PRF_TRS_TYPE_ALL:int      = 3; // 参加報酬

        private static var __prfTrsDatas:Object = [];   // 渦報酬データ
        private static var __loadings:Object ={};       // ロード中の渦データ
        private static var __initData:Boolean = false;

        private var _level:int;        // 報酬レベル
        private var _prfTrsType:int;   // 渦報酬タイプ
        private var _rankMin:int;      // 該当ランク最低値
        private var _rankMax:int;      // 該当ランク最大値
        private var _treasureType:int; // 報酬タイプ
        private var _treasureId:int;   // 報酬ID
        private var _slotType:int;     // スロットタイプ
        private var _value:int;        // 個数

        public static function getFoundBonus(level:int):Array
        {
            initializeData();
            var ret:Array = [];
            __prfTrsDatas.forEach(function(item:ProfoundTreasureData, index:int, array:Array):void{
                    if (item) {
                        if (item.level == level && item.prfTrsType == PRF_TRS_TYPE_FOUND) {
                            ret.push(item);
                        }
                    }
                });
            return ret;
        }
        public static function getRankBonus(level:int,rank:int):Array
        {
            initializeData();
            var ret:Array = [];
            __prfTrsDatas.forEach(function(item:ProfoundTreasureData, index:int, array:Array):void{
                    if (item) {
                        if (item.level == level && item.prfTrsType == PRF_TRS_TYPE_RANK) {
                            if  (item.rankMin <= rank && rank <= item.rankMax) {
                                ret.push(item);
                            }
                        }
                    }
                });
            return ret;
        }

        public static function initializeData():void
        {
            if (__initData == false) {
                var list:Array = ConstData.getDataList(ConstData.PRF_TRS_DATA);
                list.forEach(function(item:Array, index:int, array:Array):void{
                        updateParam(item[0], item[1], item[2], item[3], item[4], item[5], item[6], item[7], item[8], 0, true);
                    });
                __initData = true;
            }
        }

        private static function getData(id:int):void
        {
            log.writeLog(log.LV_INFO, "static profoundTreasureData getData" ,id);
            var a:Array; /* of ElementType */
            if (ConstData.getData(ConstData.PRF_TRS_DATA, id) != null)
            {
                a = ConstData.getData(ConstData.PRF_TRS_DATA, id);
                updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], 0, true);
            }
        }

        public static function clearData():void
        {
            __prfTrsDatas.forEach(function(item:ProfoundTreasureData, index:int, array:Array):void{if (item != null){item._loaded = false}});
        }

        // IDのProfoundTreasureDataインスタンスを返す
        public static function ID(id:int):ProfoundTreasureData
        {
            log.writeLog(log.LV_INFO, "static profoundData ID" ,id);
            if (__prfTrsDatas[id] == null)
            {
                __prfTrsDatas[id] = new ProfoundTreasureData(id);
                getData(id);
            }else{
                if (!(__prfTrsDatas[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __prfTrsDatas[id];
        }

        // ローダがAchievementのパラメータを更新する
        public static function updateParam(id:int, level:int, prfTrsType:String, rankMin:int, rankMax:int, treasureType:int, treasureId:int, slotType:int, value:String, version:int, cache:Boolean=false):void
        {
            // log.writeLog(log.LV_DEBUG, "static ProfoundTreasureData" ,"update id",id, level, prfTrsType, rankMin, rankMax, treasureType, treasureId, slotType, value);

            if (__prfTrsDatas[id] == null)
            {
                __prfTrsDatas[id] = new ProfoundTreasureData(id);
            }
            __prfTrsDatas[id]._id           = id;
            __prfTrsDatas[id]._level        = level;
            __prfTrsDatas[id]._prfTrsType   = prfTrsType;
            __prfTrsDatas[id]._rankMin      = rankMin;
            __prfTrsDatas[id]._rankMax      = rankMax;
            __prfTrsDatas[id]._treasureType = treasureType;
            __prfTrsDatas[id]._treasureId   = treasureId;
            __prfTrsDatas[id]._slotType     = slotType;
            __prfTrsDatas[id]._value        = value;

            if (__prfTrsDatas[id]._loaded)
            {
                __prfTrsDatas[id].dispatchEvent(new Event(UPDATE));
            }
            else
            {
                __prfTrsDatas[id]._loaded  = true;
                __prfTrsDatas[id].notifyAll();
                __prfTrsDatas[id].dispatchEvent(new Event(INIT));
            }
            __loadings[id] = false;
        }

        // コンストラクタ
        public function ProfoundTreasureData(id:int)
        {
            _id = id;
        }

        // レベル取得
        public function get level():int
        {
            return _level;
        }
        public function get prfTrsType():int
        {
            return _prfTrsType;
        }
        public function get rankMin():int
        {
            return _rankMin;
        }
        public function get rankMax():int
        {
            return _rankMax;
        }
        public function get treasureType():int
        {
            return _treasureType;
        }
        public function get treasureId():int
        {
            return _treasureId;
        }
        public function get slotType():int
        {
            return _slotType;
        }
        public function get value():int
        {
            return _value;
        }

    }
}
