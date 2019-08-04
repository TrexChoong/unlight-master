package model
{
    import flash.events.*;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import controller.*;
    import net.server.DataServer;
    import model.FriendLink;

    // ランキングデータ
    public class RankingData extends BaseModel
    {
        public static const UPDATE:String = "update";
        public static const MY_RANK_UPDATE:String = "my_rank_update";
        public static const UPDATE_INTERVAL:int = 1000*60*15; // 一時間
//        public static const UPDATE_INTERVAL:int = 1000*60*3; // 一時間

        private static const RANK_LIST_NUM:int          = 100;
        private static const VOTE_RANK_LIST_NUM:int     = 60;

        private var _nameList:Vector.<String> = new Vector.<String>(100);          // アバター名
        private var _arrowList:Vector.<int> = new Vector.<int>(100);          // 矢印
        private var _pointList:Vector.<int> = new Vector.<int>(100);          // ポイント

        private static var __totalDuel:RankingData;
        private static var __weeklyDuel:RankingData;

        private static var __totalQuest:RankingData;
        private static var __weeklyQuest:RankingData;

        private static var __totalCharaVote:RankingData;

        private static var __totalEvent:RankingData;

        private var _lastUpdateTime:int;

        private var _kind:int;
        private var _myRank:int = 0;
        private var _myPoint:int = 0;

        private var _dataLoaded:Array = []; /* of Boolean */ 
        private var _myRankLoaded:Boolean = false;

        public static function getList():Array
        {
            CONFIG::RANK_EVENT_ON
            {
                return [weeklyDuel, totalDuel, weeklyQuest, totalQuest, totalEvent, totalCharaVote];
            }
            CONFIG::RANK_EVENT_OFF
            {
                return [weeklyDuel, totalDuel, weeklyQuest, totalQuest, totalEvent, totalCharaVote];
            }
            CONFIG::CHARA_VOTE_ON
            {
                return [weeklyDuel, totalDuel, weeklyQuest, totalQuest, totalCharaVote, totalEvent];
            }
        }

        public static function getRankType(t:int):int
        {
            var typeList:Array = [Const.RANK_TYPE_WD,Const.RANK_TYPE_TD,Const.RANK_TYPE_WQ,Const.RANK_TYPE_TQ,Const.RANK_TYPE_TE,Const.RANK_TYPE_TV];
            CONFIG::CHARA_VOTE_ON
            {
                typeList = [Const.RANK_TYPE_WD,Const.RANK_TYPE_TD,Const.RANK_TYPE_WQ,Const.RANK_TYPE_TQ,Const.RANK_TYPE_TV,Const.RANK_TYPE_TE];
            }
            return typeList[t];
        }


        public static function get weeklyDuel ():RankingData
        {
            if (__weeklyDuel == null)
            {
                __weeklyDuel = new RankingData(Const.RANK_TYPE_WD);
            }
            return __weeklyDuel;

        }

        public static function get totalDuel ():RankingData
        {
            if (__totalDuel == null)
            {
                __totalDuel = new RankingData(Const.RANK_TYPE_TD);
            }
            return __totalDuel;

        }

        public static function get weeklyQuest ():RankingData
        {
            if (__weeklyQuest == null)
            {
                __weeklyQuest = new RankingData(Const.RANK_TYPE_WQ);
            }
            return __weeklyQuest;
        }

        public static  function get  totalQuest ():RankingData
        {
            if (__totalQuest == null)
            {
                __totalQuest = new RankingData(Const.RANK_TYPE_TQ);
            }
            return __totalQuest;

        }

        public static  function get  totalCharaVote ():RankingData
        {
            if (__totalCharaVote == null)
            {
                __totalCharaVote = new RankingData(Const.RANK_TYPE_TV,true);
            }
            return __totalCharaVote;

        }

        public static  function get  totalEvent ():RankingData
        {
            log.writeLog(log.LV_FATAL, "totalEvent");
            if (__totalEvent == null)
            {
                __totalEvent = new RankingData(Const.RANK_TYPE_TE);
            }
            return __totalEvent;

        }

        // コンストラクタ
        public function RankingData(k:int,half:Boolean=false)
        {
            var d:Date = new Date();
            var now:int= d.getTime();
            _lastUpdateTime = now;

            _kind =k;
            var listMax:int = RANK_LIST_NUM;
            if (half) listMax = VOTE_RANK_LIST_NUM;
            for(var i:int = 0; i < listMax; i++){
                _nameList[i] = "------";
                _arrowList[i] = 0;
            }
        }

        // ランキングを更新する
        public function updateData(index:int, names:Array):void
        {
            log.writeLog(log.LV_FATAL, this, "update data", names.length, _kind);
            var len:int  = names.length;
            var blockList:Object = FriendLink.getMyBlockNameList();
            for(var i:int = 0; i < len; i++)
            {
                log.writeLog(log.LV_FATAL, this, "update data",index, names);
                if (names[i][0]!=null&&names[i][0]!="")
                {
                    if (blockList.hasOwnProperty(names[i][0]))
                    {
                        _nameList[i+index] = "******";
                    }
                    else
                    {
                        _nameList[i+index] = names[i][0].replace("_rename","");
                    }
                    _arrowList[i+index] = int(names[i][1]);
                    _pointList[i+index] = int(names[i][2]);
                }
            }
            
            dispatchEvent(new Event(UPDATE));
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
            dispatchEvent(new Event(MY_RANK_UPDATE));
        }

        public function getRanking(offset:int, count:int):Array
        {
            // ロード済み課のデータがないときはfalse
            if (_dataLoaded[offset] == null)
            {
                _dataLoaded[offset] = false;
            }
            // ロードされてないならロード
            if(!_dataLoaded[offset])
            {
                DataCtrl.instance.updateRankList(_kind,offset, count);
                _dataLoaded[offset] = true;
            }else{
                // ロードされているなら時間経過をチェックする
                var d:Date = new Date();
                var now:int= d.getTime();
                if ((now - _lastUpdateTime) > UPDATE_INTERVAL)
                {
                    _dataLoaded = [];
                    _lastUpdateTime = now;
                    DataCtrl.instance.updateRankList(_kind,offset, count);
                    _dataLoaded[offset] = true;
                    if (myRank < 120)
                    {
                        DataCtrl.instance.updateMyRank(_kind);
                    }
                }else{

                };
            }
            
//            log.writeLog(log.LV_FATAL, this, "get ranking", offset,_nameList.slice(offset, offset+count),_arrowList.slice(offset, offset+count));
            return [_nameList.slice(offset, offset+count),_arrowList.slice(offset, offset+count),_pointList.slice(offset, offset+count)]
        }

        public function get kind():int
        {
            return _kind;
        }

        public function get myRank():int
        {
            if (!_myRankLoaded)
            {
                DataCtrl.instance.updateMyRank(_kind);
                _myRankLoaded = true;
            }
            if (_kind != Const.RANK_TYPE_TV) {
                return _myRank;
            } else {
                return 0;
            }
        }

        public function get myPoint():int
        {
            if (_kind != Const.RANK_TYPE_TV) {
                return _myPoint;
            } else {
                return 0;
            }
        }

    }
}