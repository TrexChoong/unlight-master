package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;

    import controller.LobbyCtrl;


    /**
     * ロビーに入ってきたときの告知情報クラス
     * Type
     * 0:ログインボーナス[アイテムタイプとアイテムIDと数]
     * 1:アチーブメント成功ボーナス「アイテムタイプとアイテムIDと数とアチーブメントID」
     * 2:新規アチーブメント「アチーブメントID」
     * 3:ログアウト中のパーツ削除「アイテムID」
     * 4:新しいフレンド認証待ちのが来た「相手の名前」
     * 5:プレゼントもらった「アイテムとIDもらった相手の名前」
     * 6:クエストをもらった「クエストIDともらった相手の名前」
     * 7:貸したものが帰ってきた「カードIDと相手の名前」
     * 8:招待した友人がゲームを始めた「アイテムタイプとアイテムIDと数と相手の名前」
     * 9:宣伝「画像ID」
     * 10:プレゼントしたクエストがクリアされた「相手の名前」
     * 11:カムバック依頼を出した相手が復帰した「相手の名前」
     * 12:久しぶりにUnlightをプレイした「自分の名前」
     * 13:セールを開始した「時間」
     * 14:ニコニコ版開始記念
     * 15:渦取得
     * 16:渦撃破:渦撃破報告「渦名」
     * 17:渦撃破:各種報酬内容「発見、参加、撃破、順位」
     * 18:渦撃破:ランキング報告「発見者名、自分の順位、ランキング」
     * 19:渦終了:タイムアップ
     * 20:中文3周年記念プレゼント
     * 21:お詫び配付
     * 22:新年
     * 23:招待されてゲームを始めた「アイテムタイプとアイテムIDと数」
     * 24:更新情報
     * 25:クリアコード
     * 26:アチーブメント成功ボーナス、選択ゲット
     */

    public class LobbyNotice  extends EventDispatcher
    {

        CONFIG::LOCALE_JP
        private static const _TRANS_DAY:String = "日";
        CONFIG::LOCALE_JP
        private static const _TRANS_HOUR:String = "時間";
        CONFIG::LOCALE_JP
        private static const _TRANS_MIN :String = "分";

        CONFIG::LOCALE_EN
        private static const _TRANS_DAY:String = "D";
        CONFIG::LOCALE_EN
        private static const _TRANS_HOUR:String = "H";
        CONFIG::LOCALE_EN
        private static const _TRANS_MIN :String = "m";

        CONFIG::LOCALE_TCN
        private static const _TRANS_DAY:String = "D";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HOUR:String = "H";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MIN :String = "m";

        CONFIG::LOCALE_SCN
        private static const _TRANS_DAY:String = "D";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HOUR:String = "H";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MIN :String = "m";

        CONFIG::LOCALE_KR
        private static const _TRANS_DAY:String = "D";
        CONFIG::LOCALE_KR
        private static const _TRANS_HOUR:String = "H";
        CONFIG::LOCALE_KR
        private static const _TRANS_MIN :String = "m";

        CONFIG::LOCALE_FR
        private static const _TRANS_DAY:String = "D";
        CONFIG::LOCALE_FR
        private static const _TRANS_HOUR:String = "H";
        CONFIG::LOCALE_FR
        private static const _TRANS_MIN :String = "m";

        CONFIG::LOCALE_ID
        private static const _TRANS_DAY:String = "日";
        CONFIG::LOCALE_ID
        private static const _TRANS_HOUR:String = "時間";
        CONFIG::LOCALE_ID
        private static const _TRANS_MIN :String = "分";

        CONFIG::LOCALE_TH
        private static const _TRANS_DAY:String = "D";
        CONFIG::LOCALE_TH
        private static const _TRANS_HOUR:String = "H";
        CONFIG::LOCALE_TH
        private static const _TRANS_MIN :String = "m";

        // 出現優先順位もかねているので注意！
        public static const TYPE_LOGIN:int           = 0;         //
        public static const TYPE_ACHI_SUCC:int       = 1;         //
        public static const TYPE_ACHI_NEW:int        = 2;         //
        public static const TYPE_VANISH_PART:int     = 3;         //
        public static const TYPE_FRIEND_COME:int     = 4;         //
        public static const TYPE_ITEM_PRESENT:int    = 5;         //
        public static const TYPE_QUEST_PRESENT:int   = 6;         //
        public static const TYPE_RETURN_CARD:int     = 7;         //
        public static const TYPE_INVITE_SUCC:int     = 8;         //
        public static const TYPE_AD:int              = 9;         //
        public static const TYPE_QUEST_SUCC:int      = 10;         //
        public static const TYPE_COMEBK_SUCC:int     = 11;         //
        public static const TYPE_COMEBKED_SUCC:int   = 12;         //
        public static const TYPE_SALE_START:int      = 13;         //
        public static const TYPE_ROOKIE_START:int    = 14;         //
        public static const TYPE_GET_PROFOUND:int    = 15;         //
        public static const TYPE_FIN_PRF_WIN:int     = 16;         //
        public static const TYPE_FIN_PRF_REWARD:int  = 17;         //
        public static const TYPE_FIN_PRF_RANKING:int = 18;         //
        public static const TYPE_FIN_PRF_FAILED:int  = 19;         //
        public static const TYPE_3_ANNIVERSARY:int   = 20;         //
        public static const TYPE_APOLOGY:int         = 21;         //
        public static const TYPE_NEW_YEAR:int        = 22;         //
        public static const TYPE_INVITED_SUCC:int    = 23;         //
        public static const TYPE_UPDATE_NEWS:int     = 24;         //
        public static const TYPE_CLEAR_CODE:int      = 25;         //
        public static const TYPE_GET_SELECTABLE_ITEM:int= 26;         //

        // ProfoundNoticeに関連するタイプ
        public static const PRF_TYPES:Array = [
            TYPE_GET_PROFOUND,TYPE_FIN_PRF_WIN,TYPE_FIN_PRF_REWARD,TYPE_FIN_PRF_RANKING,TYPE_FIN_PRF_FAILED
            ];

        private static var __lists:Vector.<LobbyNotice> = new Vector.<LobbyNotice>();
        private static var __nextID:int = 0;
        private static var __noticeNum:int = 0;
        private static var __getNews:Boolean = true;

        private var _id:int;
        private var _type:int;
        private var _treType:int = 0;
        private var _achiID:int = 0;
        private var _questID:int = 0;
        private var _cardType:int = 0;
        private var _itemID:int = 0;
        private var _adID:int = 0;
        private var _num:int = 0;
        private var _friendName:String = "";
        private var _text:String = "";
        private var _saleType:int = 0;
        private var _raidObj:Object = new Object();

        /**
         * ロビーの情報を得られた時のイベント
         *
         */

        public static function setLoginInfo(treType:int, cType:int, cID:int, num:int):void
        {
            log.writeLog(log.LV_FATAL, "LOBBYNOTICE!!!", TYPE_LOGIN, treType, cID, num, cType);

            if (Const.TG_GEM == treType)
            {
                new LobbyNotice(TYPE_LOGIN, treType, 0, cID, cType);
            }else{
                new LobbyNotice(TYPE_LOGIN, treType, cID, num, cType);
            }
        }

        public static function setAchievementSuccessInfo(achiID:int, treType:int, itemID:int, num:int,cType:int):void
        {
            new LobbyNotice(
                TYPE_ACHI_SUCC,
                treType,
                itemID,
                num,
                cType,
                achiID)
        }

        public static function setAchievementClearCode(achiID:int):void
        {
            new LobbyNotice(
                TYPE_CLEAR_CODE,
                    0,
                0,
                0,
                0,
                achiID)
        }
        public static function setAchievementNewInfo(achiID:int):void
        {
            new LobbyNotice(TYPE_ACHI_NEW,0,0,0,0,achiID)
        }

        public static function setVanishPartInfo(partsID:int):void
        {
            new LobbyNotice(TYPE_VANISH_PART,Const.TG_AVATAR_PART,partsID);
        }
        public static function getNoticeNum():int
        {
            var ret:int = __noticeNum;
            __noticeNum = 0;
            return ret;
        }
        public static function setNotice(no:int, str:String):void
        {
            log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", no,str);
            __noticeNum+=1;
            switch (no)
            {
            case TYPE_ACHI_SUCC:
                var achiDataDet:Array  = str.split(",");
                var achiId:int = achiDataDet.shift();
                achiDataDet.forEach(function(item:*, index:int, array:Array):void
                          {
                              log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", str,item);
                              var itemData:Array = item.split("_");
                              var iType:int = itemData[0];
                              var itemId:int = itemData[1];
                              var num:int = itemData[2];
                              var cType:int = itemData[3];
                              setAchievementSuccessInfo(achiId,iType,itemId,num,cType);
                          });
                break;
            case TYPE_INVITE_SUCC:
                var inviteDataDet:Array  = str.split(",");
                var friendName:String = inviteDataDet.shift();
                inviteDataDet.forEach(function(item:*, index:int, array:Array):void
                          {
                              log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", str,friendName,item);
                              var itemData:Array = item.split("_");
                              new LobbyNotice( TYPE_INVITE_SUCC, Const.TG_AVATAR_ITEM, int(itemData[0]), int(itemData[1]),0, 0, 0, 0, friendName);
                          });
                break;
            case TYPE_QUEST_SUCC:
                var questSuccDataDet:Array  = str.split(",");
                var friendName2:String = questSuccDataDet.shift();

                for(var i:int; i < questSuccDataDet.length; i+=3)
                {
                    log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", questSuccDataDet[i],friendName2,questSuccDataDet[i+1],questSuccDataDet[i+2]);
                    new LobbyNotice( TYPE_QUEST_SUCC,
                                     questSuccDataDet[i],
                                     questSuccDataDet[i+1],
                                     questSuccDataDet[i+2],
                                     0,
                                     0,
                                     0,
                                     0,
                                     friendName2);
                }
                break;
            case TYPE_QUEST_PRESENT:
                var questPreDataDet:Array  = str.split(",");
                var friendName3:String = questPreDataDet.shift();
                new LobbyNotice( TYPE_QUEST_PRESENT,
                                 0,
                                 0,
                                 0,
                                 0,
                                 0,
                                 questPreDataDet[0],
                                 0,
                                 friendName3
                    );
                break;

            case TYPE_COMEBK_SUCC:
                var comebackDataDet:Array  = str.split(",");
                var friendName4:String = comebackDataDet.shift();
                comebackDataDet.forEach(function(item:*, index:int, array:Array):void
                          {
                              log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", str,friendName4,item);
                              new LobbyNotice( TYPE_COMEBK_SUCC, Const.TG_AVATAR_ITEM, item, 1,0, 0, 0, 0, friendName4);
                          });
                break;
            case TYPE_COMEBKED_SUCC:
                var comebackedDataDet:Array  = str.split(",");
                var friendName5:String = comebackedDataDet.shift();
                comebackedDataDet.forEach(function(item:*, index:int, array:Array):void
                          {
                              log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", str,friendName5,item);
                              var item_arr:Array = item.split("_");
                              var iType:int = item_arr[0];
                              var itemId:int = item_arr[1];
                              var num:int = item_arr[2];
                              var sctType:int = item_arr[3];
                              new LobbyNotice( TYPE_COMEBKED_SUCC,iType,itemId,num,sctType,0,0,0,friendName5);
                          });
                break;
            case TYPE_SALE_START:
                var saleStaDataDet:Array  = str.split(",");
                var saleType:int = int(saleStaDataDet.shift());
                var saleSecTime:Number = Number(saleStaDataDet.shift());
                var saleTime:String = TimeFormat.toDateString((saleSecTime/60)); // 分単位で渡す
                log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", saleType,saleTime);
                new LobbyNotice( TYPE_SALE_START,
                                 0,
                                 0,
                                 0,
                                 0,
                                 0,
                                 saleStaDataDet[0],
                                 0,
                                 "",
                                 saleTime,
                                 saleType
                    );
                break;
            case TYPE_ROOKIE_START:
                var rookieStartDataDet:Array  = str.split(",");
                rookieStartDataDet.forEach(function(item:*, index:int, array:Array):void
                          {
                              log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", str,item);
                              var item_arr:Array = item.split("_");
                              var iType:int = item_arr[0];
                              var itemId:int = item_arr[1];
                              var num:int = item_arr[2];
                              new LobbyNotice( TYPE_ROOKIE_START, iType, itemId, num);
                          });
                break;

            case TYPE_GET_PROFOUND:
                var getPrfDataDet:Array  = str.split(",");
                var prfId:int = int(getPrfDataDet.shift());
                var friendName6:String = getPrfDataDet.shift();
                var raidObj:Object = new Object();
                raidObj["prfName"]  = getPrfDataDet.shift();
                raidObj["bossName"] = getPrfDataDet.shift();
                raidObj["bossHp"]   = int(getPrfDataDet.shift());
                new LobbyNotice(TYPE_GET_PROFOUND,0,0,0,0,0,0,0,friendName6,"",0,raidObj);
                break;
            case TYPE_FIN_PRF_FAILED:
                var getPrfDataDet2:Array  = str.split(",");
                var prfId2:int = int(getPrfDataDet2.shift());
                var raidObj2:Object = new Object();
                raidObj2["prfName"]  = getPrfDataDet2.shift();
                raidObj2["bossName"] = getPrfDataDet2.shift();
                new LobbyNotice(TYPE_FIN_PRF_FAILED,0,0,0,0,0,0,0,"","",0,raidObj2);
                break;
            case TYPE_3_ANNIVERSARY:
                var annivDataDet:Array  = str.split(",");
                annivDataDet.forEach(function(item:*, index:int, array:Array):void
                          {
                              log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", str,item);
                              var item_arr:Array = item.split("_");
                              var iType:int = item_arr[0];
                              var itemId:int = item_arr[1];
                              var num:int = item_arr[2];
                              new LobbyNotice( TYPE_3_ANNIVERSARY, iType, itemId, num);
                          });
                break;
            case TYPE_APOLOGY:
                var apolDataDet:Array = str.split(",");
                var date_str:String = apolDataDet.shift();
                apolDataDet.forEach(function(item:*, index:int, array:Array):void
                          {
                              log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", str,item);
                              var item_arr:Array = item.split("_");
                              var iType:int = item_arr[0];
                              var itemId:int = item_arr[1];
                              var num:int = item_arr[2];
                              var sctType:int = item_arr[3];
                              new LobbyNotice( TYPE_APOLOGY,iType,itemId,num,sctType,0,0,0,"",date_str);
                          });
                break;
            case TYPE_NEW_YEAR:
                break;
            case TYPE_INVITED_SUCC:
                var invitedDataDet:Array  = str.split(",");
                invitedDataDet.forEach(function(item:*, index:int, array:Array):void
                          {
                              log.writeLog(log.LV_INFO, "LobbyNotice", "scAddNotice", str,friendName,item);
                              var itemData:Array = item.split("_");
                              new LobbyNotice( TYPE_INVITED_SUCC, int(itemData[0]), int(itemData[1]), int(itemData[2]));
                          });
                break;
            case TYPE_GET_SELECTABLE_ITEM:
                log.writeLog(log.LV_FATAL, "LobbyNotice !!!", "scAddNotice", "selectable item", str);
                // var selectableTreasure:Array = Achievement.ID(int(str)).selectableTreasureSet;
                // log.writeLog(log.LV_FATAL, "LobbyNotice !!!", "scAddNotice", selectableTreasure);
                new LobbyNotice(TYPE_GET_SELECTABLE_ITEM, 0,0,0,0,int(str));
                break;
            }

        }

        public static function setUpdateInfo(text:String):void
        {
            new LobbyNotice(
                TYPE_UPDATE_NEWS,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                "",
                text
                );
        }

        private static function setFinishProfoundNotice(type:int,iType:int,itemId:int,num:int,cType:int,name:String,raidObj:Object):void
        {
            new LobbyNotice(
                type,
                iType,
                itemId,
                num,
                cType,
                0,
                0,
                0,
                name,
                "",
                0,
                raidObj);
        }

        public static function getNotice(delID:int = -1):Vector.<LobbyNotice>
        {
            if (delID>-1)
            {
                deleteNotice(delID);
            }

            //return __lists.sort(compare);;
            return getList();
        }
        private static function getList():Vector.<LobbyNotice>
        {
            var ret:Vector.<LobbyNotice>;
            if (__getNews) {
                ret = __lists.sort(compare);
            } else {
                var tmpArray:Vector.<LobbyNotice> = new Vector.<LobbyNotice>();
                var selectableAchiIDList:Array = [];
                for (var i:int = 0; i < __lists.length; i++) {
                    if (__lists[i].type != TYPE_UPDATE_NEWS) {
                        if (__lists[i].type != TYPE_GET_SELECTABLE_ITEM) {
                            tmpArray.push(__lists[i]);
                        } else {
                            if (selectableAchiIDList.indexOf(__lists[i].achiID)==-1) {
                                tmpArray.push(__lists[i]);
                                selectableAchiIDList.push(__lists[i].achiID);
                            }
                        }
                    }
                }
                ret = tmpArray.sort(compare);
            }
            return ret;
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
        public static function findSameAchiIndex(aID:int):int
        {
            var index:int = -1;
            for(var i:int = 0; i < __lists.length; i++)
            {
                if (__lists[i].achiID== aID)
                {
                    index = i;
                    break;
                }
            }
            return index;

        }


        // コンストラクタ
        public function LobbyNotice(
            type:int          = 0,
            treType:int       = 0,
            itemID:int        = 0,
            num:int           = 0,
            cType:int         = 0,
            achiID:int        = 0,
            questID:int       = 0,
            adID:int          = 0,
            friendName:String = "",
            text:String       = "",
            saleType:int      = 0,
            raidObj:Object    = null
            )
        {
            _type = type;
            _treType = treType;
            _achiID = achiID;
            _questID = questID;
            _cardType = cType;
            _itemID = itemID;
            _adID = adID;
            _num =num;
            _friendName = friendName.replace("_rename","");
            _id = __nextID;
            _text = text;
            _saleType = saleType;
            _raidObj = raidObj;
            __nextID+=1;
            if(achiID>0)
            {
                var findIndex:int = findSameAchiIndex(_achiID)
                if(findIndex > -1)
                {
                    if(__lists[findIndex]._type == TYPE_ACHI_NEW)
                    {
                        __lists[findIndex] = this;
                    }else{
                        __lists.push(this);
                    }
                }else{
                __lists.push(this);
                }
            }else{
                __lists.push(this);
            }
                __lists.sort(compare);

//             __lists.forEach(function(item:*, index:int, array:Vector.<LobbyNotice>):void{
//                     log.writeLog(log.LV_FATAL, this, "achi is ",item.achiID, item.type);
//                 })

       }
        private static function compare(x:LobbyNotice, y:LobbyNotice):Number
        {
            var ret:Number = 0;
            if(x.type == y.type)
            {
                if(x.achiID > y.achiID)
                {
                    ret = 1;
                }else{
                    ret = -1;
                }
            }else{
                if(x.type > y.type)
                {
                    ret = 1;
                }else{
                    ret = -1;
                }
            }
            return ret;
        };

        // Newsを表示するかのフラグ
        public static function set getNews(f:Boolean):void
        {
            __getNews = f;
        }

        public function get type():int
        {
            return _type;
        }
        public function get achiID():int
        {
            return _achiID;
        }
        public function get treType():int
        {
            return _treType;
        }
        public function get questID():int
        {
            return _questID;
        }
        public function get itemID():int
        {
            return _itemID;
        }
        public function get cardType():int
        {
            return _cardType;
        }
        public function get adID():int
        {
            return _adID;
        }
        public function get num():int
        {
            return _num;
        }
        public function get id():int
        {
            return _id;
        }
        public function get friendName():String
        {
            return _friendName;

        }
        public function get text():String
        {
            return _text;
        }
        public function get saleType():int
        {
            return _saleType;
        }
        public function get raidObj():Object
        {
            return _raidObj;
        }
    }
}