package model.utils
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.net.SharedObject;
    /**
     * モデルのキャッシュ制御クラス
     * 仕様上の制限：寿命は2週間まで（バージョン管理の関係）
     *
     */
    public class Cache  extends EventDispatcher
    {

        // ======================== 追加の必要あり ================ 
        // 注)Lobbyサーバによるバージョン情報の更新も必要
        public static const ACTION_CARD:int = 0;
        public static const CHARA_CARD:int  = 1;
        public static const FEAT:int        = 2;
        public static const DIALOGUE:int    = 3;
        public static const STORY:int       = 4;
        public static const QUEST_LOG:int   = 5;
        public static const AVATAR_ITEM:int = 6;
        public static const AVATAR_PART:int = 7;
        public static const WEAPON_CARD:int = 8;
        public static const EQUIP_CARD:int  = 9;
        public static const EVENT_CARD:int  = 10;
        public static const QUEST:int       = 11;
        public static const QUEST_MAP:int   = 12;
        public static const QUEST_LAND:int  = 13;
        public static const GROWTH_TREE:int  = 14;

        public static const MODEL_NUM:int   = 15;

        public static const NAME_LIST:Array = ["ActionCard", // 0
                                               "CharaCard",  // 1
                                               "Feat",       // 2
                                               "Dialogue",   // 3
                                               "Story",      // 4
                                               "QuestLog",   // 5
                                               "AvatarItem", // 6
                                               "AvatarPart", // 7
                                               "WeaponCard", // 8
                                               "EquipCard",  // 9
                                               "EventCard",  // 10
                                               "Quest",      // 11
                                               "QuestMap",   // 12
                                               "QuestLand",  // 13
                                               "GrowthTree"]; // 14
        // キャッシュのデータセットの配列
        private static var __cacheSet:Vector.<SharedObject > = new Vector.<SharedObject>(MODEL_NUM, true);
        // 実際のデータの配列
        private static var __cacheDataSet:Vector.<CacheData> = new Vector.<CacheData>(MODEL_NUM, true);
        // 書くデータのデータバージョンの配列
        private static var __cacheDataVerSet:Vector.<int> = Vector.<int>([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);

        // =====================================================

        private static var __inited:Boolean = false;

        // キャッシュ情報の初期化
        public static function init():void
        {
            // 初期化済みでないなら
            if (!__inited)
            {
                var tmp:Array;
                // 定義済みのキャッシュモデル一ずつチェックする
                for(var i:int = 0; i < MODEL_NUM; i++){
                    var update:Boolean = false;
                    // キャッシュをすべて読み出す
                    __cacheSet[i] = SharedObject.getLocal(NAME_LIST[i]);

                    // データバージョン０は更新しないの意
                    if (__cacheDataVerSet[i]!=0)
                    {
                        // キャッシュのデータバージョンが存在しない場合
                        if (__cacheSet[i].data.version == undefined)
                        {
                            // 今の値を入れる
                            __cacheSet[i].data.version = __cacheDataVerSet[i];
                        }
                        // データバージョンが異なるか？
                        if (__cacheSet[i].data.version !=__cacheDataVerSet[i])
                        {
                            __cacheSet[i].data.version = __cacheDataVerSet[i];
                            log.writeLog(log.LV_FATAL, "static  Cache update data ver", i,__cacheSet[i].data.version);
                            // アップデートを音にする
                            update = true;
                        }
//                        log.writeLog(log.LV_FATAL, "static  Cache ver", i,__cacheSet[i].data.version);
                    }else{
                        //log.writeLog(log.LV_FATAL, "static  Cache  not update");
                    }

                    // キャッシュが入っていたら取り出す
                    if (__cacheSet[i].data.sets == undefined)
                    {
                        __cacheSet[i].data.sets = [];
                        __cacheDataSet[i] = new CacheData(0);
//                        log.writeLog(log.LV_FATAL, "Cache", "first SET");

                    }else {
                        __cacheDataSet[i] = new CacheData(__cacheSet[i].data.version);
                        tmp = __cacheSet[i].data.sets.slice();
//                        log.writeLog(log.LV_FATAL, "Cache", "load",tmp);
                        __cacheDataSet[i].setParam(tmp,update,__cacheSet[i].data);
//                        log.writeLog(log.LV_FATAL, "Cache", "load",tmp);
                    }
                    __inited = true;
                }
                // 古いキャッシュを消す(保留)
            }
        }

        public static function setDataVersion(type:int, v:int):void
        {
            __cacheDataVerSet[type] = v;
        }

        // キャッシュにセットする
        public static function setCache(type:int, ...rest):void
        {
            // 初期化されているかを見る
            if (__inited)
            {
//                log.writeLog(log.LV_FATAL, "static cache", "setcache", rest);
                // 引数からIDを除いたものをコピー
                var tmp:Array  = rest.slice(1);
                var id:int = rest[0];
                var dateTime:int = new Date().month;
                // 初回の場合データを作る
                if( __cacheSet[type].data.sets[id] == null)
                {
                    // Version, param, check, updatetime
                    __cacheSet[type].data.sets[id] = [tmp[tmp.length-1],null,false, dateTime];
                }
                __cacheDataSet[type].dataParam(rest[0]).updateData(tmp[tmp.length-1],tmp,false, dateTime);
                __cacheSet[type].data.sets[id][1] = __cacheDataSet[type].paramSet[id].getParamByteArray();
                __cacheSet[type].data.sets[id][2] = false;
                __cacheSet[type].data.sets[id][3] = dateTime;
//                log.writeLog(log.LV_FATAL, "chce set result",__cacheSet[type].data.sets);
            }
        }


        public static function resetCache(type:int):void
        {
            if (__cacheSet[type]!=null&&__cacheSet[type].data != null)
            {
                __cacheSet[type].data.sets = [];
                __cacheDataSet[type].reset();
            }
        }


        public static function getCache(type:int,id:int):Boolean
        {
//            log.writeLog(log.LV_FATAL, "static Cache: getCache",type, __inited, __cacheDataSet[type]);
            if (__inited&&__cacheDataSet[type].paramSet[id] !=null&&!__cacheDataSet[type].paramSet[id].check)
            {
//                log.writeLog(log.LV_FATAL, "Cache: ","hit!", id);
                return true;
            }else{
//                log.writeLog(log.LV_FATAL, "Cache: ","not hit!", id);
                return false;
            }
        }

        public static function getDataParam(type:int,id:int):Array
        {
//            log.writeLog(log.LV_FATAL, "Cache static gerDataParam",__cacheDataSet[type].paramSet[id].param);
            return __cacheDataSet[type].paramSet[id].param;
        }
        // コンストラクタ
        public function Cache()
        {

        }
    }
}

