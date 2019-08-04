package model
{
    import flash.events.*;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import controller.*;

    // ランキングデータ
    public class ProfoundRanking extends BaseModel
    {
        public static const UPDATE:String = "update";
        public static const MY_RANK_UPDATE:String = "my_rank_update";
        public static const UPDATE_INTERVAL:int = 1000*60*15; // 一時間

        public static const PAGE_NUM:int = 5;
        public static const RANK_LIST_NUM:int = 100;
        public static const PAGE_LENGTH:int = RANK_LIST_NUM/PAGE_NUM;

        private var _ctrl:RaidRankCtrl = RaidRankCtrl.instance;

        private var _nameList:Vector.<String> = new Vector.<String>(RANK_LIST_NUM);     // アバター名
        private var _arrowList:Vector.<int> = new Vector.<int>(RANK_LIST_NUM);          // 矢印
        private var _pointList:Vector.<int> = new Vector.<int>(RANK_LIST_NUM);          // ポイント

        private var _lastUpdateTime:int;

        private var _prfId:int;
        private var _myRank:int = 0;
        private var _myPoint:int = 0;
        private var _nowIndex:int = 0;

        private var _dataLoaded:Array = []; /* of Boolean */ 
        private var _myRankLoaded:Boolean = false;

        private var _rankingUpdateFunc:Function = null;
        private var _myRankUpdateFunc:Function  = null;

        // ランキングデータ
        private static var __prfRanking:Object = new Object();

        public static function getRankingList():Object
        {
            return __prfRanking;
        }

        public static function getProfoundRanking(prfId:int):ProfoundRanking
        {
            if (prfId == 0) return null;
            if (__prfRanking[prfId] == null) __prfRanking[prfId] = new ProfoundRanking(prfId);
            return __prfRanking[prfId];
        }

        // コンストラクタ
        public function ProfoundRanking(prfId:int)
        {
            var d:Date = new Date();
            var now:int= d.getTime();
            _lastUpdateTime = now;

            _prfId = prfId;
            for(var i:int = 0; i < RANK_LIST_NUM; i++){
                _nameList[i] = "------";
                _arrowList[i] = 0;
            }

        }

        // 現在ページの更新
        public function updateNowPageData(ranks:Array):void
        {
            updateData(_nowIndex,ranks);
        }
        // ランキングを更新する
        public function updateData(index:int, ranks:Array):void
        {
            log.writeLog(log.LV_FATAL, this, "update data", ranks.length, _prfId);
            var i:int;
            _nowIndex = index;
            var len:int  = ranks.length;
            for( i = 0; i < PAGE_NUM; i++)
            {
                log.writeLog(log.LV_FATAL, this, "update data",index, ranks);
                if(len > i) {
                    if (ranks[i][0]!=null&&ranks[i][0]!="")
                    {
                        _nameList[i+index]  = ranks[i][0].replace("_rename","");
                        _arrowList[i+index] = int(ranks[i][1]);
                        _pointList[i+index] = int(ranks[i][2]);
                    }
                } else {
                    _nameList[i+index]  = "------";
                    _arrowList[i+index] = 0;
                    _pointList[i+index] = 0;
                }
            }
            if (_rankingUpdateFunc != null) _rankingUpdateFunc();
            // dispatchEvent(new Event(UPDATE));
        }

        // ランキングを更新する
        public function updateMyRank(rank:int,point:int):void
        {
            log.writeLog(log.LV_FATAL, this, "update myrank");
            // 自分が100位以内ならばデータを全部読み直す
            if (_myRank!=rank && rank <= 100)
            {
                _dataLoaded = [];
            }
            _myRank = rank;
            _myPoint = point;
            if (_myRankUpdateFunc != null) _myRankUpdateFunc();
            //dispatchEvent(new Event(MY_RANK_UPDATE));
        }

        public function getRanking(offset:int, count:int):Array
        {
            // ロード済みのデータがないときはfalse
            if (_dataLoaded[offset] == null)
            {
                _dataLoaded[offset] = false;
            }
            // ロードされてないならロード
            if(!_dataLoaded[offset])
            {
                _ctrl.updateRankList(_prfId,offset, count);
                _dataLoaded[offset] = true;
            }else{
                // ロードされているなら時間経過をチェックする
                var d:Date = new Date();
                var now:int= d.getTime();
                if ((now - _lastUpdateTime) > UPDATE_INTERVAL)
                {
                    _dataLoaded = [];
                    _lastUpdateTime = now;
                    _ctrl.updateRankList(_prfId,offset, count);
                    _dataLoaded[offset] = true;
                    if (myRank < 120)
                    {
                        _ctrl.updateMyRank(_prfId);
                    }
                }else{

                };
            }
//            log.writeLog(log.LV_FATAL, this, "get ranking", offset,_nameList.slice(offset, offset+count),_arrowList.slice(offset, offset+count));
            return [_nameList.slice(offset, offset+count),_arrowList.slice(offset, offset+count),_pointList.slice(offset, offset+count)]
        }

        public function setUpdateFunc(rankingFunc:Function = null, myRankFunc:Function = null):void
        {
            _rankingUpdateFunc = rankingFunc;
            _myRankUpdateFunc  = myRankFunc;
        }

        public function get kind():int
        {
            return _prfId;
        }

        public function get myRank():int
        {
            if (!_myRankLoaded)
            {
                _ctrl.updateMyRank(_prfId);
                _myRankLoaded = true;
            }
            return _myRank;
        }

        public function get myPoint():int
        {
            return _myPoint;
        }

        public function resetRanking():void
        {
            _dataLoaded = [];
            _myRankLoaded = false;
        }

    }
}