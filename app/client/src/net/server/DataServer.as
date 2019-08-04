package net.server
{
    import flash.events.Event;
    import net.*;
    import net.command.*;
    import model.*;
    import model.utils.Cache;
    import model.utils.ClientLog;
    import model.events.*;
    import controller.DataCtrl;
    import controller.LobbyCtrl;
    import view.*;
    import view.utils.*;

    import model.utils.ConstData;

    /**
     * ロビーサーバからの通信を扱うクラス
     *
     */
    public class DataServer extends Server
    {
        private var _command:DataCommand;
        private var _crypted_sign:String;
        private var _ctrl:DataCtrl;
        private var _edit:DeckEditor;
        private var _growth:Growth;

        private static var __instance:DataServer;

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_GET		:String = "を獲得しました。";
        CONFIG::LOCALE_JP
        private static const _TRANS_INFO	:String = "情報";
        CONFIG::LOCALE_JP
        private static const _TRANS_USE		:String = "を使用しました。";
        CONFIG::LOCALE_JP
        private static const _TRANS_FINISH_A	:String = "";
        CONFIG::LOCALE_JP
        private static const _TRANS_FINISH_B	:String = "の効果時間が終了したため失われました";

        CONFIG::LOCALE_EN
        private static const _TRANS_GET		:String = "You received ";
        CONFIG::LOCALE_EN
        private static const _TRANS_INFO	:String = "Information";
        CONFIG::LOCALE_EN
        private static const _TRANS_USE		:String = "You used ";
        CONFIG::LOCALE_EN
        private static const _TRANS_FINISH_A	:String = "You have lost ";
        CONFIG::LOCALE_EN
        private static const _TRANS_FINISH_B	:String = " because the effect has elapsed.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_GET	:String = "獲得了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_INFO	:String = "訊息";
        CONFIG::LOCALE_TCN
        private static const _TRANS_USE		:String = "使用了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_FINISH_A	:String = "效果時間結束，";
        CONFIG::LOCALE_TCN
        private static const _TRANS_FINISH_B	:String = "的效果消失了";

        CONFIG::LOCALE_SCN
        private static const _TRANS_GET		:String = "获得了";
        CONFIG::LOCALE_SCN
        private static const _TRANS_INFO	:String = "信息";
        CONFIG::LOCALE_SCN
        private static const _TRANS_USE		:String = "已使用";
        CONFIG::LOCALE_SCN
        private static const _TRANS_FINISH_A	:String = "有效时间到期，失去";
        CONFIG::LOCALE_SCN
        private static const _TRANS_FINISH_B	:String = "。";

        CONFIG::LOCALE_KR
        private static const _TRANS_GET:String = "를 획득하였습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_INFO:String = "정보";
        CONFIG::LOCALE_KR
        private static const _TRANS_USE		:String = "을(를) 사용했습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_FINISH_A	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_FINISH_B	:String = "の効果時間が終了したため失われました";

        CONFIG::LOCALE_FR
        private static const _TRANS_GET		:String = "Vous recevez ";
        CONFIG::LOCALE_FR
        private static const _TRANS_INFO	:String = "Information";
        CONFIG::LOCALE_FR
        private static const _TRANS_USE		:String = "Vous avez utilisé ";
        CONFIG::LOCALE_FR
        private static const _TRANS_FINISH_A	:String = "Le temps de l'effet est terminé. ";
        CONFIG::LOCALE_FR
        private static const _TRANS_FINISH_B	:String = " est invalide.";

        CONFIG::LOCALE_ID
        private static const _TRANS_GET		:String = "を獲得しました。";
        CONFIG::LOCALE_ID
        private static const _TRANS_INFO	:String = "情報";
        CONFIG::LOCALE_ID
        private static const _TRANS_USE		:String = "を使用しました。";
        CONFIG::LOCALE_ID
        private static const _TRANS_FINISH_A	:String = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_FINISH_B	:String = "の効果時間が終了したため失われました";

        CONFIG::LOCALE_TH
        private static const _TRANS_GET     :String = "ได้รับ";
        CONFIG::LOCALE_TH
        private static const _TRANS_INFO    :String = "ข้อมูล";
        CONFIG::LOCALE_TH
        private static const _TRANS_USE     :String = "ใช";
        CONFIG::LOCALE_TH
        private static const _TRANS_FINISH_A    :String = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_FINISH_B    :String = "หายไปเนื่องจากหมดเวลาการใช้งาน";//"の効果時間が終了したため失われました";



        CONFIG::LOCALE_JP
            private static const _ALERT_NO_RESULT	:String = "該当するアバターが存在しません";
        CONFIG::LOCALE_JP
            private static const _ERROR		:String = "検索結果";
        CONFIG::LOCALE_EN
            private static const _ALERT_NO_RESULT	:String = "That avatar does not exist.";
        CONFIG::LOCALE_EN
            private static const _ERROR		:String = "Result";
        CONFIG::LOCALE_TCN
            private static const _ALERT_NO_RESULT	:String = "沒有符合名稱的虛擬人物";
        CONFIG::LOCALE_TCN
            private static const _ERROR		:String = "錯誤";
        CONFIG::LOCALE_SCN
            private static const _ALERT_NO_RESULT	:String = "没有符合的虚拟人物。";
        CONFIG::LOCALE_SCN
            private static const _ERROR		:String = "结果";
        CONFIG::LOCALE_KR
            private static const _ALERT_NO_RESULT	:String = "";
        CONFIG::LOCALE_KR
            private static const _ERROR		:String = "에러";
        CONFIG::LOCALE_FR
            private static const _ALERT_NO_RESULT	:String = "Cet Avatar n'existe pas.";
        CONFIG::LOCALE_FR
            private static const _ERROR		:String = "Erreur";
        CONFIG::LOCALE_ID
            private static const _ALERT_NO_RESULT	:String = "";
        CONFIG::LOCALE_ID
            private static const _ERROR		:String = "検索結果";
        CONFIG::LOCALE_TH
            private static const _ALERT_NO_RESULT   :String = "ไม่มีอวาตาร์ที่สามารถใช้งานได้";
        CONFIG::LOCALE_TH
            private static const _ERROR     :String = "ผลการสำรวจ";

        // アラートを出すか
        private static var __alertOn:Boolean = true;


        // 初期化 サーバを取得
        public function DataServer(caller:Function = null)
        {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
             _command = new DataCommand(this);
             Story.setLoaderFunc(getStoryInfo);
             OtherAvatar.setLoaderFunc(getOtherAvatarInfo);
        }
        public static function alertEnable(b:Boolean):void
        {
            __alertOn = b;
        }

        private static function createInstance():DataServer

       {
            return new DataServer(arguments.callee);
        }

        public static function get instance():DataServer
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        // コンフィグからのロード
        protected override function configLoad():void
        {
            log.writeLog(log.LV_INFO, this,"configload");
            address = Config.dataServerInfo.address;
            port = Config.dataServerInfo.port;
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("","","","DS["+address+":"+port.toString()+"]");
            }

        }

        // コマンドの登録
        protected override function get command():Command
        {
            return _command;
        }

        /**
         * サーバのスタート
         *
         */
        public function start(ctrl:DataCtrl):void
        {
            _ctrl= ctrl
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"data server p_session", player.session);
            host.setSessionKey(player.session);
        }


        // 終了
        public override function exit():void
        {
            host.sendCommand(_command.logout());
            super.exit();
        }

        // オーバライド前提のHeartBeatHandler
        protected override function heartBeatHandler(e:Event):void
        {
            host.sendCommand(_command.csKeepAlive());
        }

        /**
         * 送信コマンド
         *
         */

        // アバター作製終了をサーバに知らせる
        public function csCreateAvatarSuccess():void
        {
            log.writeLog(log.LV_INFO, this,"cs create avatar success!");
            host.sendCommand(_command.csCreateAvatarSuccess());
        }

        // ストーリー情報を取得する
        public function getStoryInfo(id:int):void
        {
            log.writeLog(log.LV_INFO, this,"story info request!",id);
            host.sendCommand(_command.csRequestStoryInfo(Const.getOKStr(),id,Const.getOKStr()));
        }

        // 指定したIDの他のアバタを取得する
        public function getOtherAvatarInfo(id:int):void
        {
            log.writeLog(log.LV_INFO, this,"other avatar info request",id);
            host.sendCommand(_command.csRequestOtherAvatarInfo(id));
        }

        // チャンネルリストの要求
        public function csRequestChannelListInfo():void
        {
            log.writeLog(log.LV_INFO, this, "cs request Channel list info");
            host.sendCommand(_command.csRequestChannelListInfo());
        }
        // フレンド情報のリクエスト
        public function csRequestFriendsInfo():void
        {
            log.writeLog(log.LV_INFO, this, "cs request Friend info");
            host.sendCommand(_command.csRequestFriendsInfo());
        }
        public function csRequestFriendList(type:int,offset:int,count:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs request Friend list",type,offset,count);
            host.sendCommand(_command.csRequestFriendList(type,offset,count));
        }
        // フレンドの招待
        public function csFriendInvite(uid:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs Frieend Invite",uid);
            host.sendCommand(_command.csFriendInvite(uid));
        }

        // フレンドへカムバック依頼
        public function csSendComebackFriend(uid:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs Send Comeback Friend",uid);
            host.sendCommand(_command.csFriendInvite(uid));
        }

        // フレンドがゲームを始めているか？
        public function csCheckExistPlayer(uid:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs check Exst player",uid);
            host.sendCommand(_command.csCheckExistPlayer(uid));
        }

        // ランキング情報の取得
        public function csRequestRankInfo(k:int, serverType:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestRankInfo");
            host.sendCommand(_command.csRequestRankInfo(k, serverType));
        }

        // ランキング一覧の取得
        public function csRequestRankingList(k:int, offset:int, count:int, serverType:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestRankingList", k, offset, count, serverType);
            host.sendCommand(_command.csRequestRankingList(k, offset, count, serverType));
        }

        // 渦の取得
        public function csGetProfound(hash:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs GetProfound", hash);
            host.sendCommand(_command.csGetProfound(hash));
        }
        // アバター名で検索
        public function csFindAvatar(name:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs finAvatar", name);
            host.sendCommand(_command.csFindAvatar(name));
        }



        /**
         * 受信コマンド
         *
         */

        // ネゴシエーション処理の返答
        public function negoCert(crypted_sign:String, ok:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"negotiated ");
            host.sendCommand(_command.login("yes, ok.",crypted_sign));
        }

        // ログインOK
        public function loginCert(msg:String, hash_key:String):void
        {
            log.writeLog(log.LV_DEBUG, "[DataServer] loginCert.");
            log.writeLog(log.LV_DEBUG, this,"server messeage", msg);
            ConstData.dataInit(msg);
            Unlight.setImgHashKey(hash_key);
        }

       // ログインOK
        public function loginFail():void
        {
            log.writeLog(log.LV_FATAL, this,"Login Failed!!");
        }

        // データバージョン情報を受け取る
        public function scDataVersionInfo(ac:int, cc:int, feat:int, dialogue:int, story:int, quest_log:int, avatarItem:int, avatarPart:int, eventCard:int, weaponCard:int, equipCard:int, quest:int,questMap:int, questLand:int, growthTree:int) :void
        {

            Cache.setDataVersion(Cache.ACTION_CARD, ac);
            Cache.setDataVersion(Cache.CHARA_CARD, cc);
            Cache.setDataVersion(Cache.FEAT, feat);
            Cache.setDataVersion(Cache.DIALOGUE, dialogue);
            Cache.setDataVersion(Cache.STORY, story);
            Cache.setDataVersion(Cache.QUEST_LOG, quest_log);
            Cache.setDataVersion(Cache.AVATAR_ITEM, avatarItem);
            Cache.setDataVersion(Cache.AVATAR_PART, avatarPart);
            Cache.setDataVersion(Cache.WEAPON_CARD, weaponCard);
            Cache.setDataVersion(Cache.EQUIP_CARD, equipCard);
            Cache.setDataVersion(Cache.EVENT_CARD, eventCard);

            // 予定
            Cache.setDataVersion(Cache.QUEST, quest);
            Cache.setDataVersion(Cache.QUEST_MAP, questMap);
            Cache.setDataVersion(Cache.QUEST_LAND, questLand);
            Cache.setDataVersion(Cache.GROWTH_TREE, growthTree);

            Cache.init();
       }

        // アバター情報を受け取る
        public function scAvatarInfo(id:int,name:String,
                                     gems:int,
                                     exp:int,
                                     level:int,
                                     energy:int,
                                     energyMax:int,
                                     recoveryInterval:int,
                                     remainTime:int,
                                     point:int,
                                     win:int,
                                     lose:int,
                                     draw:int,
                                     partNum:int,
                                     partInvId:String,
                                     partArray:String,
                                     partUsed:String,
                                     partEndAt:String,
                                     itemNum:int,
                                     itemInvId:String,
                                     itemArray:String,
                                     itemStateArray:String,
                                     deckNum:int,
                                     deckName:String,
                                     deckKind:String,
                                     deckLevel:String,
                                     deckExp:String,
                                     deckStatus:String,
                                     deckCost:String,
                                     deckMaxCost:String,
                                     cardNum:int,
                                     invId:String,
                                     cardArray:String,
                                     deckIndex:String,
                                     deckPosition:String,
                                     slotNum:int,
                                     slotInvId:String,
                                     slotArray:String,
                                     slotType:String,
                                     slotCombined:String,
                                     slotCombineData:String,
                                     slotDeckIndex:String,
                                     slotDeckPosition:String,
                                     slotCardPosition:String,
                                     questMax:int,
                                     questNum:int,
                                     questInvId:String,
                                     questArray:String,
                                     questStatus:String,
                                     questFindTime:String,
                                     questBaName:String,
                                     questFlag:int,
                                     questClearNum:int,
                                     friendMax:int,
                                     partMax:int,
                                     freeDuelCount:int,

                                     expPow:int,
                                     gemsPow:int,
                                     questFindPow:int,

                                     currentDeck:int,
                                     saleType:int,
                                     saleLimitRestTime:int,
                                     favoriteCharaId:int,
                                     floorCount:int,
                                     eventQuestFlag:int,
                                     eventQuestClearNum:int,
                                     tutorialQuestFlag:int,
                                     tutorialQuestClearNum:int,
                                     charaVoteQuestFlag:int,
                                     charaVoteQuestClearNum:int):void
        {
            log.writeLog(log.LV_WARN, this, "scAvatarInfo!",slotCombineData);
            // アバターが未登録の場合
            if ((name == "")&&(gems == 0)&&(deckNum==0))
            {
//                player.state = Player.STATE_REGIST;
            }else{
                // レジストならチュートリアルへ
                if(player.state == Player.STATE_REGIST)
                {
                    player.state = Player.STATE_TUTORIAL;
                }
                else
                {
                    player.state = Player.STATE_LOBBY;
                }
//                 _edit = DeckEditor.instance;
//                 _edit.addEventListener(DeckEditor.START, editStartHandler);
//                 _edit.addEventListener(DeckEditor.END, editEndHandler);
//                 _growth = Growth.instance;
//                 _growth.addEventListener(Growth.START, growthStartHandler);
//                 _growth.addEventListener(Growth.END, growthEndHandler);
                log.writeLog(log.LV_INFO, this, "part equip!", partUsed,string2intArray(partUsed));
                csRequestFriendsInfo();
                // FriendLink.getLinkSet();
                // 最初のロビーログインなら
                if (player.avatar == null)
                {
                    player.avatar = new Avatar(id,name,
                                               gems,
                                               exp,
                                               level,
                                               energy,
                                               energyMax,
                                               recoveryInterval,
                                               remainTime,
                                               point,
                                               win,
                                               lose,
                                               draw,
                                               partNum,
                                               string2intArray(partInvId),
                                               string2intArray(partArray),
                                               string2intArray(partUsed),
                                               string2intArray(partEndAt),
                                               itemNum,
                                               string2intArray(itemInvId),
                                               string2intArray(itemArray),
                                               string2intArray(itemStateArray),
                                               deckNum,
                                               deckName.split(/,/),
                                               deckKind.split(/,/),
                                               deckLevel.split(/,/),
                                               deckExp.split(/,/),
                                               deckStatus.split(/,/),
                                               deckCost.split(/,/),
                                               deckMaxCost.split(/,/),
                                               cardNum,
                                               string2intArray(invId),
                                               string2intArray(cardArray),
                                               string2intArray(deckIndex),
                                               string2intArray(deckPosition),
                                               slotNum,
                                               string2intArray(slotInvId),
                                               string2intArray(slotArray),
                                               string2intArray(slotType),
                                               string2BooleanArray(slotCombined),
                                               slotCombineData.split(/,/),
                                               string2intArray(slotDeckIndex),
                                               string2intArray(slotDeckPosition),
                                               string2intArray(slotCardPosition),
                                               questMax,
                                               questNum,
                                               string2intArray(questInvId),
                                               string2intArray(questArray),
                                               string2intArray(questStatus),
                                               string2intArray(questFindTime),
                                               questBaName.split(/,/),
                                               questFlag,
                                               questClearNum,
                                               friendMax,
                                               partMax,
                                               freeDuelCount,
                                               expPow,
                                               gemsPow,
                                               questFindPow,
                                               currentDeck,
                                               saleType,
                                               saleLimitRestTime,
                                               favoriteCharaId,
                                               floorCount,
                                               eventQuestFlag,
                                               eventQuestClearNum,
                                               tutorialQuestFlag,
                                               tutorialQuestClearNum,
                                               charaVoteQuestFlag,
                                               charaVoteQuestClearNum);
                }else{
                    player.avatar.gems = gems;
                    player.avatar.exp = exp;
                    player.avatar.level = level;
                    player.avatar.energy= energy;
                    player.avatar.energyMax =energyMax;
                    player.avatar.remainTime = remainTime;
                    player.avatar.point = point;
                    player.avatar.win = win;
                    player.avatar.lose = lose;
                    player.avatar.draw = draw;
                    player.avatar.freeDuelCount = freeDuelCount;
                    player.avatar.saleType = saleType;
                    player.avatar.updateSaleLimitRestTime(saleLimitRestTime);
                    player.avatar.favoriteCharaId = favoriteCharaId;
                    player.avatar.floorCount = floorCount;

                }
            }

        }
        public function scAchievementInfo(achievements:String,achievementsState:String,achievementsProgress:String,achievementsEndAt:String,achievementCode:String):void
        {
            log.writeLog(log.LV_INFO, this, "scAchievementInfo", achievements,achievementsState,achievementsProgress,achievementsEndAt,achievementCode);
            if (player.avatar) {
                player.avatar.achievementUpdate(string2intArray(achievements),
                                                string2intArray(achievementsState),
                                                achievementsProgress.split(/_/),
                                                achievementsEndAt.split(","),
                                                achievementCode.split(","));
            }
        }
        public function scRegistInfo(parts:String , cards:String ):void
        {
            log.writeLog(log.LV_INFO, this, "scRegistInfo");
            AvatarPart.setRegistParts(string2intArray(parts));
            CharaCard.setRegistCards(string2intArray(cards));

            // レジストを始める
            player.state = Player.STATE_REGIST;
        }

        // 他のアバター情報を受け取る
        public function scOtherAvatarInfo(id:int, name:String, level:int, partsSet:String, bp:int ):void
        {
            log.writeLog(log.LV_INFO, this, "other avatar info", name);
            OtherAvatar.updateParam(id,  name, level,string2intArray(partsSet),bp);
        }

        // ストーリー情報を受け取る
        public function scStoryInfo(id:int, bookType:int, title:String, content:String, image:String, age_no:String, version:int):void
        {
            Story.updateParam(id, bookType, title, content,image, age_no, version);
        }

        // フレンドリストを更新
        public function scFriendListInfo(ids:String, avIds:String, stSet:String, uidSet:String):void
        {
            log.writeLog(log.LV_INFO, this, "friendList set ", ids, avIds, stSet,uidSet);
            // FriendLink.setLink(ids, avIds, stSet,uidSet);
            LobbyCtrl.instance.friendUpdate();
        }
        // フレンドリストを更新
        public function scFriendList(ids:String, avIds:String, stSet:String, uidSet:String, type:int, offset:int, friendNum:int, blockNum:int, requestNum:int):void
        {
            log.writeLog(log.LV_INFO, this, "friendList set ", ids, avIds, stSet,uidSet,offset);
            FriendLink.setFriendNum(friendNum);
            FriendLink.setBlockNum(blockNum);
            FriendLink.setRequestNum(requestNum);
            FriendLink.setLink(ids, avIds, stSet,uidSet,type,offset);
            LobbyCtrl.instance.friendUpdate();
        }

        // フレンドがゲームを始めているかの情報
        public function scExistPlayerInfo(uid:String, id:int, avId:int):void
        {
            log.writeLog(log.LV_INFO, this, "SNS Friend ", uid, id, avId);
            FriendLink.setSNSLink(uid,id,avId);
        }

        // チャンネルリスト情報を受け取る
        public function scChannelListInfo(id:String, name:String, rule:String, max:String, host:String, port:String, duel_host:String, duel_port:String, chat_host:String, chat_port:String, watch_host:String, watch_port:String, state:String, caption:String,count:String,penalty_type:String,cost_limit_min:String,cost_limit_max:String, watch_mode:String):void
        {
            log.writeLog(log.LV_INFO, this, "id is", id, "name is", name, "rule is", rule, "max is", max, "host is", host, "port is", port, "duel_host is", duel_host, "duel_port is", duel_port, "chat_host is", chat_host, "chat_port is", chat_port, "watch_host is", watch_host, "watch_port is", watch_port, "state is", state, "caption is", caption,"count is",count,"penalty_type is",penalty_type,"cost_limit_min is",cost_limit_min,"cost_limit_max is",cost_limit_max,"watch_mode is",watch_mode);

            Channel.initChannelList(string2intArray(id),
                                    name.split(","),
                                    string2intArray(rule),
                                    string2intArray(max),
                                    host.split(","),
                                    string2intArray(port),
                                    duel_host.split(","),
                                    string2intArray(duel_port),
                                    chat_host.split(","),
                                    string2intArray(chat_port),
                                    watch_host.split(","),
                                    string2intArray(watch_port),
                                    string2intArray(state),
                                    caption.split(","),
                                    string2intArray(count),
                                    string2intArray(penalty_type),
                                    string2intArray(cost_limit_min),
                                    string2intArray(cost_limit_max),
                                    string2intArray(watch_mode)
                );

        }


        public function scUpdateRank(type:int, rank:int, point:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateRank", type,rank);
            switch (type)
            {
            case Const.RANK_TYPE_WD: // 週のデュエルランク
                RankingData.weeklyDuel.updateMyRank(rank,point);
                break;
            case Const.RANK_TYPE_WQ: //
                RankingData.weeklyQuest.updateMyRank(rank,point);
                break;
            case Const.RANK_TYPE_TD: //
                RankingData.totalDuel.updateMyRank(rank,point);
                break;
            case Const.RANK_TYPE_TQ: //
                RankingData.totalQuest.updateMyRank(rank,point);
                break;
            case Const.RANK_TYPE_TE: //
                RankingData.totalEvent.updateMyRank(rank,point);
                break;
            case Const.RANK_TYPE_TV: //
                RankingData.totalCharaVote.updateMyRank(rank,point);
                break;
            default:
                }

//             LobbyNotice.setAchievementNewInfo(achiID);
//             new AchievementInventory(achiID, Const.ACHIEVEMENT_STATE_START)
        }

        public function scUpdateTotalDuelRankingList(start:int, name_list:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateTotalDuelRankingList", start, name_list);
            RankingData.totalDuel.updateData(start,arraySeparateThree(name_list.split(",")))
        }

        public function scUpdateWeeklyDuelRankingList(start:int, name_list:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateWeeklyDuelRankingList", start,name_list);
            RankingData.weeklyDuel.updateData(start,arraySeparateThree(name_list.split(",")));
        }

        public function scUpdateTotalQuestRankingList(start:int, name_list:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateTotalQuestRankingList", start,name_list);
            RankingData.totalQuest.updateData(start,arraySeparateThree(name_list.split(",")));
        }

        public function scUpdateWeeklyQuestRankingList(start:int, name_list:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateWeeklyQuestRankingList", start,name_list);
            RankingData.weeklyQuest.updateData(start,arraySeparateThree(name_list.split(",")));
        }

        public function scUpdateTotalCharaVoteRankingList(start:int, name_list:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateWeeklyQuestRankingList", start,name_list);
            RankingData.totalCharaVote.updateData(start,arraySeparateThree(name_list.split(",")));
        }

        public function scUpdateTotalEventRankingList(start:int, name_list:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateTotalEventRankingList", start,name_list);
            RankingData.totalEvent.updateData(start,arraySeparateThree(name_list.split(",")));
        }

        // アチーブメントクリア
        public function scAchievementClear(achiID:int, itemType:int, itemID:int, itemNum:int, cType:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAchievementClear", achiID, itemType, itemID, itemNum, cType);
            LobbyNotice.setAchievementSuccessInfo(achiID, itemType, itemID, itemNum, cType);
            AchievementInventory.finishAchievementInventory(achiID);
            ClientLog.write( ClientLog.SUCC_ACHIEVEMENT, achiID, true );
        }

        // アチーブメント追加
        public function scAddNewAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAddNewAchievement", achiID);
            LobbyNotice.setAchievementNewInfo(achiID);

            new AchievementInventory(achiID, Const.ACHIEVEMENT_STATE_START)
        }

        // アチーブメント削除
        public function scDeleteAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scDeleteAchievement", achiID);
            AchievementInventory.deleteAchievementInventory(achiID);
        }

        // アチーブメント情報をアップデート
        public function scUpdateAchievementInfo(achievements:String,achievementsState:String,achievementsProgress:String,achievementsEndAt:String,achievementsCode:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateAchievementInfo", achievements,achievementsState,achievementsProgress,achievementsEndAt,achievementsCode);
            if (Player.instance && Player.instance.avatar) {
                Player.instance.avatar.achievementUpdate(string2intArray(achievements),
                                                         string2intArray(achievementsState),
                                                         achievementsProgress.split(/_/),
                                                         achievementsEndAt.split(","),
                                                         achievementsCode.split(",")
                    );
            }
        }
        // フレンドリストを更新
        public function scResultAvatarsList(ids:String):void
        {
            log.writeLog(log.LV_INFO, this, "result serach avatar ", ids);
            if (ids != "")
            {
                FriendLink.setSeachResult(ids);
            }else{
                // Alerter.showWithSize(_ALERT_NO_RESULT, _ERROR);
                FriendLink.clearSeachResult();
            }
            new WaitThread(1000, DataCtrl.instance.searchAvatarFinish).start();
            LobbyCtrl.instance.friendUpdate();
        }

        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {
            // レイドに関するエラーはProfoundで一度保持する
            if (Const.PRF_ERROR_LIST.indexOf(e) != -1) {
                Profound.urlErrorId = e;
            }
            // チケット不足の時に終了イベントを送る
            if (e==70)
            {
//                _ctrl.rareCardEventFinish();
            }

//            _ctrl.waitingStop();
        }

        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }





    }
}




