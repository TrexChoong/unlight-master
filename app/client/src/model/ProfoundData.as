package model
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * 渦データクラス
     * 情報を扱う
     *
     */
    public class ProfoundData extends BaseModel
    {
        public static const PROFOUND_BOSS_START_CHARA_ID:int = 3001;  // ボスモンスターのキャラID開始位置

        public static const PRF_TYPE_EVENT:int = 1;
        public static const PRF_TYPE_NORMAL:int = 2;
        public static const PRF_TYPE_MMO_EVENT:int =3;

        public static const INIT:String   = 'init';   // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード

        private static var __profoundDatas:Object = []; // 渦データ
        private static var __loadings:Object ={};       // ロード中の渦データ

        private var _prfType:int;            // 渦の種類
        private var _name:String;            // 名前
        private var _rariry:int;             // レアリティ
        private var _level:int;              // レベル
        private var _questMapId:int;         // 所属クエストID
        private var _stage:int;              // ステージID
        private var _coreMonsterId:int;      // ボスモンスターID
        private var _coreMonsterName:String; // ボスモンスター名
        private var _coreMonsterMaxHp:int;   // ボスモンスター最大HP
        private var _caption:String;         // 説明
        private var _allItems:Array;         // 参加賞
        private var _memberLimit:int;        // 参加可能人数

        private static function getData(id:int):void
        {
            log.writeLog(log.LV_INFO, "static profoundData getData" ,id);
            var a:Array; /* of ElementType */
            if (ConstData.getData(ConstData.PROFOUND_DATA, id) != null)
            {
                a = ConstData.getData(ConstData.PROFOUND_DATA, id);
                updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], 0, true);
            }
        }

        public static function clearData():void
        {
            __profoundDatas.forEach(function(item:ProfoundData, index:int, array:Array):void{if (item != null){item._loaded = false}});
        }

        // IDのProfoundDataインスタンスを返す
        public static function ID(id:int):ProfoundData
        {
            log.writeLog(log.LV_INFO, "static profoundData ID" ,id);
            if (__profoundDatas[id] == null)
            {
                __profoundDatas[id] = new ProfoundData(id);
                getData(id);
            }else{
                if (!(__profoundDatas[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __profoundDatas[id];
        }

        // ローダがAchievementのパラメータを更新する
        public static function updateParam(id:int, prfType:int, name:String, rarity:int, level:int, questMapId:int, stage:int, coreMonsterId:int, coreMonsterName:String, coreMonsterMaxHp:int, caption:String, allItems:String, memberLimit:int, version:int, cache:Boolean=false):void
        {
            log.writeLog(log.LV_INFO, "static ProfoundData" ,"update id",id, name,rarity, level, questMapId, stage, coreMonsterId, coreMonsterName, coreMonsterMaxHp, caption);
            log.writeLog(log.LV_DEBUG, "static ProfoundData" ,"update id",id, name,rarity, level, questMapId, stage, coreMonsterId, coreMonsterName, coreMonsterMaxHp, caption,  allItems, memberLimit);

            if (__profoundDatas[id] == null)
            {
                __profoundDatas[id] = new ProfoundData(id);
            }
            __profoundDatas[id]._id               = id;
            __profoundDatas[id]._prfType          = prfType;
            __profoundDatas[id]._name             = name;
            __profoundDatas[id]._rariry           = rarity;
            __profoundDatas[id]._level            = level;
            __profoundDatas[id]._questMapId       = questMapId;
            __profoundDatas[id]._stage            = stage;
            __profoundDatas[id]._coreMonsterId    = coreMonsterId;
            __profoundDatas[id]._coreMonsterName  = coreMonsterName;
            __profoundDatas[id]._coreMonsterMaxHp = coreMonsterMaxHp;
            __profoundDatas[id]._caption          = caption;
            __profoundDatas[id]._allItems         = convAllItemList(allItems);
            __profoundDatas[id]._memberLimit      = memberLimit;

            if (__profoundDatas[id]._loaded)
            {
                __profoundDatas[id].dispatchEvent(new Event(UPDATE));
            }
            else
            {
                __profoundDatas[id]._loaded  = true;
                __profoundDatas[id].notifyAll();
                __profoundDatas[id].dispatchEvent(new Event(INIT));
            }
            __loadings[id] = false;
        }
        private static function convAllItemList(allItems:String):Array
        {
            var ret:Array = [];
            var list:Array = allItems.split(",");
            log.writeLog(log.LV_DEBUG, "!!!!!!!!!!!!!!!!!!!!!!!!! static profoundData convAllItemList" ,list,list.length,allItems);
            for (var i:int = 0; i < list.length; i++) {
                if (list[i]) {
                    var setData:Array = list[i].split("_");
                    var obj:Object = {}
                    obj["type"]    = int(setData[0]);
                    obj["id"]      = int(setData[1]);
                    obj["num"]     = setData[2];
                    obj["sctType"] = setData[3];
                    ret.push(obj);
                }
            }
            return ret;
        }


        // コンストラクタ
        public function ProfoundData(id:int)
        {
            _id = id;
        }

        // 渦の種類を取得
        public function get prfType():int
        {
            return _prfType;
        }
        // 渦の名前を取得
        public function get name():String
        {
            return _name;
        }
        // レアリティを取得
        public function get rarity():int
        {
            return _rariry;
        }
        // レベルを取得
        public function get level():int
        {
            return _level;
        }
        // 所属クエストIDを取得
        public function get questMapId():int
        {
            return _questMapId;
        }
        // ステージIDを取得
        public function get stage():int
        {
            return _stage;
        }
        // ボスモンスターIdを取得
        public function get coreMonsterId():int
        {
            return _coreMonsterId;
        }
        // ボスモンスター名を取得
        public function get coreMonsterName():String
        {
            return _coreMonsterName;
        }
        // ボスモンスター最大HPを取得
        public function get coreMonsterMaxHp():int
        {
            log.writeLog(log.LV_DEBUG, this ,"coreMonsterMaxHp", _coreMonsterMaxHp);
            return _coreMonsterMaxHp;
        }
        // 説明を取得
        public function get caption():String
        {
            return _caption;
        }
        // 参加賞を取得
        public function get allItems():Array
        {
            return _allItems;
        }
        // 参加可能人数
        public function get memberLimit():int
        {
            return _memberLimit;
        }


    }
}
