package model
{
    import flash.events.*;
    import flash.utils.ByteArray;

    import controller.LobbyCtrl;
    import controller.RaidCtrl;
    import controller.RaidDataCtrl;
    import controller.RaidRankCtrl;

    import model.events.*;

    /**
     * 渦に関する告知情報クラス
     * Type宣言はLobbyNoticeのものを共有
     * Type
     * 15:渦取得
     * 16:渦撃破:参加者全体告知「順位、自分の名前、与ダメージ、取得アイテム」
     * 17:渦撃破:ランキング入賞告知「順位、自分の名前、与ダメージ、取得アイテム」
     * 18:渦撃破:撃破者全体告知「順位、自分の名前、与ダメージ、取得アイテム」
     * 19:渦撃破:ランキング上位報告
     */

    public class ProfoundNotice  extends EventDispatcher
    {
        public static const PRF_RESULT_RANKING_UPD:String = "result_ranking_upd";

        CONFIG::LOCALE_JP
        private static const _TRANS_PRF_RANKING_BASE:String = "__RANK__位 __NAME__ 総ダメージ数[__DMG__]"
        CONFIG::LOCALE_EN
        private static const _TRANS_PRF_RANKING_BASE:String = "Rank __RANK__, __NAME__. Total number of dealt __DMG__."
        CONFIG::LOCALE_TCN
        private static const _TRANS_PRF_RANKING_BASE:String = "第__RANK__名 __NAME__ 總傷害[__DMG__]"
        CONFIG::LOCALE_SCN
        private static const _TRANS_PRF_RANKING_BASE:String = "第__RANK__名 __NAME__ 伤害总数[__DMG__]"
        CONFIG::LOCALE_KR
        private static const _TRANS_PRF_RANKING_BASE:String = "__RANK__位 __NAME__ 総ダメージ数[__DMG__]"
        CONFIG::LOCALE_FR
        private static const _TRANS_PRF_RANKING_BASE:String = "__RANK__ème __NAME__ Total des dommages[__DMG__]"
        CONFIG::LOCALE_ID
        private static const _TRANS_PRF_RANKING_BASE:String = "__RANK__位 __NAME__ 総ダメージ数[__DMG__]"
        CONFIG::LOCALE_TH
        private static const _TRANS_PRF_RANKING_BASE:String = "ลำดับที่__RANK__  __NAME__ แต้มความเสียหายรวม[__DMG__]";//"__RANK__位 __NAME__ 総ダメージ数[__DMG__]"

        private static var __lists:Vector.<ProfoundNotice> = new Vector.<ProfoundNotice>();
        private static var __nextID:int = 0;
        private static var __noticeNum:int = 0;

        private var _id:int;
        private var _type:int;
        private var _prfID:int          = 0;
        private var _prfName:String     = "";
        private var _bossName:String    = "";
        private var _finderName:String  = "";
        private var _selfRank:int       = 0;
        private var _selfName:String    = "";
        private var _selfDmg:int        = 0;
        private var _treType:int        = 0;
        private var _cardType:int       = 0;
        private var _itemID:int         = 0;
        private var _num:int            = 0;
        private var _trsLevel:int       = 0;
        private var _ranking:Array      = null;
        private var _rewards:String     = "";
        private var _raidObj:Object = new Object();

        public static function getNoticeNum():int
        {
            var ret:int = __noticeNum;
            __noticeNum = 0;
            return ret;
        }
        // ノーティスセット済みかPrfIdとTypeからチェックする
        public static function alreadySetCheck(prfId:int,type:int):Boolean
        {
            for (var i:int = 0; i < __lists.length; i++) {
                if (__lists[i].prfID == prfId && __lists[i].type == type) {
                    // log.writeLog(log.LV_DEBUG, "ProfoundNotice", "setCheck already.", prfId,type);
                    return true;
                }
            }
            // log.writeLog(log.LV_DEBUG, "ProfoundNotice", "setCheck non.", prfId,type);
            return false;
        }
        public static function setNotice(no:int, str:String):int
        {
            log.writeLog(log.LV_INFO, "ProfoundNotice", "scAddNotice", no,str);
            __noticeNum+=1;
            var prfID:int = 0;
            var prfName:String = "";
            var bossName:String = "";
            var prfData:Array;
            var rankData:Array;
            switch (no)
            {
            case LobbyNotice.TYPE_GET_PROFOUND:
                var getPrfDataDet:Array  = str.split(",");
                prfID = int(getPrfDataDet.shift());
                var friendName:String = getPrfDataDet.shift();
                var raidObj:Object = new Object();
                raidObj["prfName"]  = getPrfDataDet.shift();
                raidObj["bossName"] = getPrfDataDet.shift();
                raidObj["bossHp"]   = int(getPrfDataDet.shift());
                new ProfoundNotice(no,prfID,"","",friendName,0,"",0,0,0,0,0,0,null,"",raidObj);
                break;
            case LobbyNotice.TYPE_FIN_PRF_WIN:
                var winPrfDataDet:Array  = str.split(",");
                prfID = int(winPrfDataDet.shift());
                if (!alreadySetCheck(prfID,no)) {
                    prfData = winPrfDataDet.shift().split("_");
                    prfName = prfData.shift();
                    bossName = prfData.shift();
                    var finderName:String = prfData.shift();
                    new ProfoundNotice(no,prfID,prfName,bossName,finderName);
                }
                break;
            case LobbyNotice.TYPE_FIN_PRF_REWARD:
                var rewPrfDataDet:Array  = str.split(",");
                prfID = int(rewPrfDataDet.shift());
                // まだセットしてないならセット
                if (!alreadySetCheck(prfID,no)) {
                    var rewardStr:String = rewPrfDataDet.shift();
                    var rewardStrList:Array = rewardStr.split("-");
                    var allRewStr:String = rewardStrList[0];
                    var rankRewStr:String = rewardStrList[1];
                    var defeatRewStr:String = rewardStrList[2];
                    var foundRewStr:String = rewardStrList[3];
                    var rewardList:Array = [foundRewStr,allRewStr,defeatRewStr,rankRewStr];
                    rewardList.forEach(function(items:String, index:int, array:Array):void
                                          {
                                              log.writeLog(log.LV_INFO, "ProfoundNotice", "scAddNotice", items);
                                              var rewards:Array = items.split("+");
                                              rewards.forEach(function(item:String, index:int, array:Array):void
                                                              {
                                                                  log.writeLog(log.LV_DEBUG, "ProfoundNotice", "scAddNotice", item);
                                                                  var itemArr:Array = item.split("_");
                                                                  if (int(itemArr[0])  != 0) {
                                                                      var iType:int = itemArr[0];
                                                                      var itemId:int = itemArr[1];
                                                                      var num:int = itemArr[2];
                                                                      var cType:int = itemArr[3];
                                                                      new ProfoundNotice(no,prfID,"","","",0,"",0,iType,cType,itemId,num,0,null,rewardStr);
                                                                  }
                                                             });
                                          });
                }
                break;
            case LobbyNotice.TYPE_FIN_PRF_RANKING:
                var prfRankingDataDet:Array  = str.split(",");
                prfData = prfRankingDataDet.shift().split("_");
                prfID = prfData[0];
                // まだセットしてないならセット
                if (!alreadySetCheck(prfID,no)) {
                    prfName = prfData[1];
                    bossName = prfData[2];
                    var trsLevel:int = int(prfData[3]);
                    var myRankData:Array = prfData[4].split("-");
                    var myRank:int = int(myRankData[0]);
                    var myScore:int = int(myRankData[1]);
                    var ranking:Array = [];
                    for ( var x:int = 0; x < prfRankingDataDet.length; x++) {
                        var rank:Object = new Object();
                        rankData = prfRankingDataDet[x].split("&");
                        rank["rank"] = rankData[0];
                        rank["name"] = rankData[1];
                        rank["dmg"]  = rankData[2];
                        ranking.push(rank);
                    }
                    new ProfoundNotice(no,prfID,prfName,bossName,"",myRank,"",myScore,0,0,0,0,trsLevel,ranking);
                }
                break;
            case LobbyNotice.TYPE_FIN_PRF_FAILED:
                var failPrfDataDet:Array  = str.split(",");
                prfID = int(failPrfDataDet.shift());
                var raidObj2:Object = new Object();
                raidObj2["prfName"]  = failPrfDataDet.shift();
                raidObj2["bossName"] = failPrfDataDet.shift();
                new ProfoundNotice(no,prfID,"","","",0,"",0,0,0,0,0,0,null,"",raidObj2);
                break;
            }
            return prfID;
        }

        public static function getNotice(delID:int = -1):Vector.<ProfoundNotice>
        {
            if (delID>-1)
            {
                deleteNotice(delID);
            }

            return __lists.sort(compare);;
        }

        public static function deleteNotice(id:int):void
        {
            var delIndex:int = -1;
            for(var i:int = 0; i < __lists.length; i++)
            {
                if (__lists[i].id == id)
                {
                    delIndex = i;
                    break;
                }
            }
            if (delIndex!=-1)
            {
                __lists.splice(delIndex,1);
            }
        }

        public static function setRankingList(prfId:int,type:int,selfRankStr:String,rankingStrList:String):void
        {
            var selfRankData:Array = selfRankStr.split("&");
            var sRank:int = int(selfRankData.shift());
            var sName:String = selfRankData.shift();
            var sDmg:int = int(selfRankData.shift());

            var i:int;
            var ranking:Array = [];
            var rankingList:Array = rankingStrList.split(",");
            for (i = 0; i < rankingList.length; i++) {
                var rank:Object = new Object();
                var rankData:Array = rankingList[i].split("&");
                rank["rank"] = rankData[0];
                rank["name"] = rankData[1];
                rank["dmg"]  = rankData[2];
                ranking.push(rank);
            }
            for (i = 0; i < __lists.length; i++) {
                if (__lists[i].prfID == prfId && __lists[i].type == type) {
                    __lists[i].selfRank = sRank;
                    __lists[i].selfName = sName;
                    __lists[i].selfDmg = sDmg;
                    __lists[i].ranking = ranking;
                    __lists[i].dispatchEvent(new Event(PRF_RESULT_RANKING_UPD));
                    break;
                }
            }
        }

        // コンストラクタ
        public function ProfoundNotice(
            type:int        = 0,
            prfID:int       = 0,
            prfName:String  = "",
            bossName:String = "",
            finderName:String = "",
            selfRank:int    = 0,
            selfName:String = "",
            selfDmg:int     = 0,
            treType:int     = 0,
            cardType:int    = 0,
            itemID:int      = 0,
            num:int         = 0,
            trsLevel:int    = 0,
            ranking:Array   = null,
            rewards:String  = "",
            raidObj:Object  = null
            )
        {
            _type       = type;
            _prfID      = prfID;
            _prfName    = prfName;
            _bossName   = bossName;
            _finderName = finderName.replace("_rename","");
            _selfRank   = selfRank;
            _selfName   = selfName;
            _selfDmg    = selfDmg;
            _treType    = treType;
            _cardType   = cardType;
            _itemID     = itemID;
            _num        = num;
            _trsLevel   = trsLevel;
            _ranking    = ranking;
            _rewards    = rewards;
            _raidObj    = raidObj;
            _id         = __nextID;
            __nextID+=1;
            // log.writeLog(log.LV_DEBUG, this, "const","_type",_type,"_prfID",_prfID,"_prfName",_prfName,"_bossName",_bossName,"_selfRank",_selfRank,"_selfName",_selfName,"_selfDmg",_selfDmg,"_treType",_treType,"_cardType",_cardType,"_itemID",_itemID,"_num",_num,"_ranking",_ranking,"_id",_id,"__nextID",__nextID);
            __lists.push(this);
            __lists.sort(compare);

            // このタイミングでランキングを取得する
            if (_type == LobbyNotice.TYPE_FIN_PRF_RANKING) {
                RaidRankCtrl.instance.getProfoundResultRanking(_prfID);
            }
        }
        private static function compare(x:ProfoundNotice, y:ProfoundNotice):Number
        {
            var ret:Number = 0;
            if (x.prfID > y.prfID) {
                ret = 1;
            } else if (x.prfID < y.prfID) {
                ret = -1;
            } else {
                if(x.type > y.type)
                {
                    ret = 1;
                }else if(x.type < y.type){
                    ret = -1;
                }
            }
            return ret;
        };

        public function get type():int
        {
            return _type;
        }
        public function get prfID():int
        {
            return _prfID;
        }
        public function get prfName():String
        {
            return _prfName;
        }
        public function get bossName():String
        {
            return _bossName;
        }
        public function get finderName():String
        {
            return _finderName;
        }
        public function get selfRank():int
        {
            return _selfRank;
        }
        public function get selfName():String
        {
            return _selfName;
        }
        public function get selfDmg():int
        {
            return _selfDmg;
        }
        public function set selfRank(rank:int):void
        {
            _selfRank = rank;
        }
        public function set selfName(name:String):void
        {
            _selfName = name;
        }
        public function set selfDmg(dmg:int):void
        {
            _selfDmg = dmg;
        }
        public function get treType():int
        {
            return _treType;
        }
        public function get cardType():int
        {
            return _cardType;
        }
        public function get num():int
        {
            return _num;
        }
        public function get trsLevel():int
        {
            return _trsLevel;
        }
        public function get itemID():int
        {
            return _itemID;
        }
        public function get id():int
        {
            return _id;
        }
        public function get ranking():Array
        {
            return _ranking;
        }
        public function set ranking(list:Array):void
        {
            _ranking = list;
        }
        public function get rewards():String
        {
            return _rewards;
        }
        public function get raidObj():Object
        {
            return _raidObj;
        }
    }
}