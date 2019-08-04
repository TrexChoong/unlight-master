 // TODO:コンストラクタでIDだけ渡したい。なぜならロード失敗の時IDがわからないから。

package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * クエストクラス
     * 情報を扱う
     *
     */
    public class Quest extends BaseModel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_SEARCH	:String = "探索中";

        CONFIG::LOCALE_EN
        private static const _TRANS_SEARCH	:String = "Exploring";

        CONFIG::LOCALE_TCN
        private static const _TRANS_SEARCH	:String = "搜索中";

        CONFIG::LOCALE_SCN
        private static const _TRANS_SEARCH	:String = "搜索中";

        CONFIG::LOCALE_KR
        private static const _TRANS_SEARCH	:String = "탐색중";

        CONFIG::LOCALE_FR
        private static const _TRANS_SEARCH	:String = "Recherche";

        CONFIG::LOCALE_ID
        private static const _TRANS_SEARCH	:String = "探索中";

        CONFIG::LOCALE_TH
        private static const _TRANS_SEARCH  :String = "กำลังค้นหา";


        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        public static const PROGRESS_UPDATE:String = 'progress_update'; // 情報をロード
        private static var __loader:Function;         // パラムを読み込む関数
        private static var __quests:Object =[];        // ロード済みのクエスト
        private static var __loadings:Object ={};     // ロード中のクエスト

        private static const LEFT_BIT:int = 4; //0b100
        private static const CENTER_BIT:int = 2;// 0b010
        private static const RIGHT_BIT:int = 1;//0b001


        private var _name          :String;          // 名前
        private var _caption       :String;          // キャプション
        private var _ap            :int;             // 消費AP
        private var _kind          :int;             //探索・宝箱
        private var _difficulty    :int;             // 難易度
        private var _rarity        :int;             // レアリティ
        private var _mapId         :int;             // 所属マップ
        private var _storyNo       :int;             // ストーリー番号

        private var _progress:int = 0; // 進行度

        private var _version       :int;
        private var _landSet:Vector.<QuestLand> = new Vector.<QuestLand>(15); // クエスト場所データ
        private var _nextSet:Vector.<int> = new Vector.<int>(15); // 場所データのつながり

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
            Quest.getBlankQuest(); // ブランクだけは速攻で作る
        }

        private static function getData(id:int):void
        {
            var a:Array; /* of ElementType */
            if (ConstData.getData(ConstData.QUEST, id) != null)
            {
                a = ConstData.getData(ConstData.QUEST, id);
                updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8],a[9], a[10], 0, true);
            }

        }

        public static function clearData():void
        {
            __quests.forEach(function(item:Quest, index:int, array:Array):void{if (item != null){item._loaded = false}});
        }

        // IDのQuestインスタンスを返す
        public static function ID(id:int):Quest
        {
//            log.writeLog(log.LV_FATAL, "get feat id",id);
            if (__quests[id] == null)
            {
                if (id == 0)
                {
                    getBlankQuest();
                }else{
                    __quests[id] = new Quest(id);
                    getData(id);
                }
            }else{
                if (!(__quests[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __quests[id];
        }

        // ローダがQuestのパラメータを更新する
        public static function updateParam(id:int,  name:String, caption:String, ap:int, kind:int, difficulty:int, rarity:int,landIDSet:Array, nextSet:Array, mapId:int ,storyNo:int, version:int, cache:Boolean=false):void
        {

            log.writeLog(log.LV_INFO, "static Quest" ,"update id",id, name);

            if (__quests[id] == null)
            {
                __quests[id] = new Quest(id);
            }
            __quests[id]._id         = id;
            __quests[id]._name       = name;
            __quests[id]._caption    = caption;
            __quests[id]._ap         = ap;
            __quests[id]._kind       = kind;
            __quests[id]._difficulty = difficulty;
            __quests[id]._rarity     = rarity;
            __quests[id]._mapId      = mapId;
            __quests[id]._storyNo    = storyNo;
            log.writeLog(log.LV_INFO, "static Quest" ,"update id",id, rarity);
//            landIDSet.forEach(function(item:int, index:int, array:Array):void{__quests[id]._landSet[index] = QuestLand.ID(item)});
            for(var i:int = 0; i < 15; i++){
                if (landIDSet[i]==null)
                {
                    __quests[id]._landSet[i] = QuestLand.ID(0);
                    __quests[id]._nextSet[i] = 0;
                }else{
                    __quests[id]._landSet[i] = QuestLand.ID(landIDSet[i]);
                    __quests[id]._nextSet[i] = nextSet[i];
                }
            }
//            __quests[id]._nextSet    = Vector.<int>(nextSet.concat());

            __quests[id]._version       = version;

            if (!cache)
            {
                Cache.setCache(Cache.QUEST, id,  name, caption, ap, kind, difficulty, rarity, landIDSet, nextSet, mapId, version);
            }

            if (__quests[id]._loaded)
            {
                __quests[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static Quest" ,"load update",id,__quests[id]._loaded);
            }
            else
            {
                __quests[id]._loaded  = true;
                __quests[id].notifyAll();
                __quests[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static Quest" ,"load init",id,__quests[id]);
            }
            __loadings[id] = false;

        }

        // ブランククエスト
        public static function getBlankQuest():Quest
        {
//            log.writeLog(log.LV_FATAL, "STATIC", "blank is here");
            if  (__quests[0] == null)
            {
                __quests[0] = new Quest(0);
                __quests[0]._id         = 0;
//                __quests[0]._name       = "探索中";
                __quests[0]._name       = _TRANS_SEARCH;
                __quests[0]._caption    = "";
                __quests[0]._ap         = 0;
                __quests[0]._kind       = 0;
                __quests[0]._difficulty = 0;
                __quests[0]._rarity     = 0;
                __quests[0]._mapId     = 0;
                for(var i:int = 0; i < 15; i++){
                    __quests[0]._landSet[i] = QuestLand.ID(0);
                    __quests[0]._nextSet[i] = 0;
                }
                __quests[0]._loaded        = true;
                __quests[0].notifyAll();
            }
            return __quests[0]
        }

        // コンストラクタ
        public function Quest(id:int)
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

        public function get ap():int
        {
            return _ap;
        }
        public function get kind():int
        {
            return _kind;
        }
        public function get difficulty():int
        {
            return _difficulty;
        }
        public function get rarity():int
        {
            return _rarity;
        }

        public function get landSet():Vector.<QuestLand>
        {
            return _landSet;
        }
        public function get nextSet():Vector.<int>
        {
            return _nextSet;
        }

        // スタート位置を返す
        public function get startRow():int
        {
            var ret:int = 0;
            for(var i:int = 0; i < 3; i++){
                if (_landSet[i].id != 0)
                {
                    ret = i;
                }
            }
            return ret;
        }

        // Goalかどうかを返す位置を返す
        public function isGoal(i:int):Boolean
        {
            if (int(i/3)>3)
            {
                return true;
            }else if(_nextSet[i]==0) {
                return true;
            }else{
                return false;
            }

        }


        public function getLoader():Thread
        {
            return new ReLoaderThread(__loader, this);
        }

        public function checkRoadExist(row:int, collumn:int, distRow:int, distCollumn:int):Boolean
        {
            var ret:Boolean = false;
            log.writeLog(log.LV_FATAL, this, "check road exist", row,collumn,distRow,distCollumn);

            log.writeLog(log.LV_FATAL, this, "check road exist", (collumn+1) == distCollumn);
            // そもそもColumn飛び越え、戻ることは出来ない
            if ((collumn+1) == distCollumn)
            {
                // スタートならば必ずOK
                log.writeLog(log.LV_FATAL, this, "check road exist",(collumn == -1));
                if (collumn == -1)
                {
                    ret = true;
                }
                else
                {
                    // 現在の位置のイベントをクリアしてるか？
                    if (checkLandDone(collumn*3+row))
                    {
                        // 目的の位置にPATHがあるか？
                        switch (distRow)
                        {
                        case 0:
                            ret = ((LEFT_BIT&nextSet[collumn*3+row]) !=0);
                            break;
                        case 1:
                            ret = ((CENTER_BIT&nextSet[collumn*3+row]) !=0);
                            break;
                        case 2:
                            ret = ((RIGHT_BIT&nextSet[collumn*3+row]) !=0);
                            break;
                        default:
                        }
                    }
                }
            }
            return ret;
        }

        // ストーリーNo
        public function get storyNo():int
        {
           return  _storyNo;
        }

        // 現在マップ進行状況
        public function set progress(p:int):void
        {
            if (_progress != p)
            {
                _progress = p;
                dispatchEvent(new Event(PROGRESS_UPDATE));
            }
        }

        // 現在進行状況
        public function get progress():int
        {
           return  _progress;
        }

        // 所属マップ
        public function get map():QuestMap
        {
            return  QuestMap.ID(_mapId);
        }

        // 特定ランドのイベントは終了しているか？
        public function  checkLandDone(i:int):Boolean
        {
            return ((_progress&(1<<i)) !=0);
        }
    }
}

// import org.libspark.thread.Thread;

// import model.Quest;

// // Questのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _feat:Quest;

//     public function Loader(feat:Quest)
//     {
//         _feat =feat;
//     }

//     protected override function run():void
//     {
//         if (_feat.loaded == false)
//         {
//             _feat.wait()
//         }
//         next(close);
//     }

//     private function close ():void
//     {

//     }

// }
