package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    import org.libspark.thread.*;
    import net.*;
    import controller.*;
    import view.WaitThread;
    import model.events.AvatarSaleEvent;

    /**
     * アバタークラス
     *
     *
     */
    public class Avatar  extends EventDispatcher implements IAvatarParts
    {
        public static const NAME_INPUT_SUCCESS:int = 0;  // 名前入力成功
        public static const NAME_ALREADY_USED:int  = 1;  // 使用済み名前
        public static const NAME_CANT_USE:int      = 2;  // 使用不可成功


        public static const UPDATE:String = 'update';  // 情報がアップデート

        public static const GEMS_UPDATE:String = 'gems_update';              // 情報がアップデート
        public static const EXP_UPDATE:String = 'exp_update';                // 情報がアップデート
        public static const LEVEL_UPDATE:String = 'level_update';            // 情報がアップデート
        public static const ENERGY_UPDATE:String = 'energy_update';          // 情報がアップデート
        public static const ENERGY_MAX_UPDATE:String = 'energy_update';      // 情報がアップデート
        public static const RESULT_UPDATE:String = 'result_update';          // 情報がアップデート
        public static const QUEST_FLAG_UPDATE:String = 'quest_flag_update';  // クエスト進行度アップデート
        public static const QUEST_CLEAR_NUM_UPDATE:String = 'quest_clear_update';  // クエスト進行度アップデート
        public static const QUEST_MAX_UPDATE:String = 'quest_max_update';    // クエストMAX数アップデート
        public static const FRIEND_MAX_UPDATE:String = 'friend_max_update';  // フレンドMAX数アップデート
        public static const PART_MAX_UPDATE:String = 'part_max_update';  // パーツMAX数アップデート
        public static const FREE_DUEL_COUNT_UPDATE:String = 'free_duel_count_update';  // フレンドMAX数アップデート
        public static const UPDATE_LOGIN_BONUS:String = 'update_login_bonus';  // ログインボーナス取得

        public static const UPDATE_RECOVERY_INTERVAL:String = 'update_recovery_interval';  // AP回復時間更新
        public static const UPDATE_BONUS:String = 'update_bonus';  // ボーナスがアップデートされた

        public static const UPDATE_ENERGY_MAX:String = 'update_recovery_interval';  // AP回復時間更新

        private var _id:int;                           // ID
        private var _name:String;                      // アバター名
        private var _gems:int;                         // ジェム
        private var _exp:int;                          // 経験値
        private var _level:int;                        // レベル
        private var _energy:int;                       // 行動力
        private var _energyMax:int;                    // 行動力MAX
        private var _recoveryInterval:int;             // 回復間隔
        private var _point:int;                        // バトルポイント
        private var _win:int;                          // 勝利数
        private var _lose:int;                         // 敗北数
        private var _draw:int;                         // 引分数
        private var _questFlag:int = 0;                // クエスト進行度
        private var _questClearNum:int = 0;                // クエストマップの達成度
        private var _currentDeck:int = 1;              // 使用デッキの番号
        private var _remainTime:int = 0;                   // 行動力回復の残り時間
        private var _questMax:int = 0;
        private var _friendMax:int = 0;                    // フレンド
        private var _freeDuelCount:int = 0;                    // フリーデュエル回数
        private var _expPow:int = 100;                    // EXP倍率
        private var _gemsPow:int = 100;                    // GEM倍リス
        private var _questFindPow:int = 100;                    // クエスト時間短縮率
        private var _partInventoryMax:int = Const.AP_INV_MAX;  // パーツ所持数のMAX
//        private var _partInventoryMax:int = 20; // パーツ所持数のMAX
        private var _loginBonus:Array = [-1,-1,-1,-1];            // ログインボーナス

        private var _saleType:int = 0;          // セールタイプ
        private var _saleLimitRestTime:int = 0; // セール終了までの残り時間(秒)
        private var _saleEndAt:Date = null;     // セール終了時間
        private var _isSale:Boolean = false;    // セール中か
        private var _waitThread:Thread;         // セール終了までの待ちThread

        private var _favoriteCharaId:int = 1; // お気に入りキャラID
        private var _resultImages:Object;     // 選択しているリザルト画像のセット

        private var _floorCount:int = 1;

        private var _eventQuestFlag:int = 0;                // イベントクエスト進行度
        private var _eventQuestClearNum:int = 0;            // イベントクエストマップの達成度
        private var _tutorialQuestFlag:int = 0;                // チュートリアルクエスト進行度
        private var _tutorialQuestClearNum:int = 0;            // チュートリアルクエストマップの達成度
        private var _charaVoteQuestFlag:int = 0;                // 人気投票クエスト進行度
        private var _charaVoteQuestClearNum:int = 0;            // 人気投票クエストマップの達成度

        private var _questType:int = Const.QUEST_NORMAL;

        private var _questFlags:Array = [_questFlag,_eventQuestFlag];
        private var _questClearNums:Array = [_questClearNum,_eventQuestClearNum];
//         public const LEVEL_EXP_TABLE:Array  = 
//             [
//                 10, 10, 20, 30, 50, 80, 130, 210, 340, 550, 890,
//                 1440, 2330, 3770, 6100, 9870, 15970, 25840, 41810, 67650, 109460
//                 ];
//         public const LEVEL_ENG_BOUNUS:Array = 
//             [
//                 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3,
//                 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6
//                 ];

//         public static const WEAPON_CARD:int = 0;       // 武器カード
//         public static const EQUIP_CARD:int = 1;        // 装備カード
//         public static const EVENT_CARD:int = 2;        // イベントカード

        // コンストラクタ
        public function Avatar(id:int,
                               name:String,
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
                               partInvId:Array,
                               partArray:Array,
//                                partOffsetX:Array,
//                                partOffsetY:Array,
//                                partColors:Array,
                               partUsed:Array,
                               partEndAt:Array,
                               itemNum:int,
                               itemInvId:Array,
                               itemArray:Array,
                               itemStateArray:Array,
                               deckNum:int,
                               deckNameSet:Array,
                               deckKindSet:Array,
                               deckLevelSet:Array,
                               deckExpSet:Array,
                               deckStatusSet:Array,
                               deckCostSet:Array,
                               deckMaxCostSet:Array,
                               cardNum:int,
                               invIDSet:Array,
                               cardSet:Array,
                               deckIndexSet:Array,
                               positionSet:Array,
                               slotNum:int,
                               slotInvId:Array,
                               slotArray:Array,
                               slotType:Array,
                               slotCombined:Array,
                               slotCombineData:Array,
                               slotDeckIndex:Array,
                               slotDeckPosition:Array,
                               slotCardPosition:Array,
                               questMax:int,
                               questNum:int,
                               questInvId:Array,
                               questArray:Array,
                               questStatus:Array,
                               questFindTime:Array,
                               questBaName:Array,
                               questFlag:int,
                               questClearNum:int,
                               friendMax:int,
                               partMax:int,
                               freeDuelCount:int,
                               expPow:int,
                               gemsPow:int,
                               questFindPow:int,
                               currentDeck:int,
                               saleType:int=0,
                               saleLimitRestTime:int=0,
                               favoriteCharaId:int=1,
                               floorCount:int=1,
                               eventQuestFlag:int=0,
                               eventQuestClearNum:int=0,
                               tutorialQuestFlag:int=0,
                               tutorialQuestClearNum:int=0,
                               charaVoteQuestFlag:int=0,
                               charaVoteQuestClearNum:int=0)
        {
            _id = id;
            _name = name.replace("_rename","");
            _gems = gems;
            _currentDeck = currentDeck;
            _exp = exp;
            _level = level;
            _energy = energy;
            _energyMax = energyMax;
            _point = point;
            _win = win;
            _lose = lose;
            _draw = draw;
            _recoveryInterval = recoveryInterval;
            _remainTime = remainTime;
            _questFlag = questFlag;
            _questClearNum = questClearNum;
            _questMax = questMax;
            _questFindPow = questFindPow;
            _freeDuelCount = freeDuelCount;
            _friendMax = friendMax;
            _partInventoryMax = partMax;
            _gemsPow = gemsPow;
            _expPow = expPow;
            cardsInitialize(deckNum, deckNameSet, deckKindSet, deckLevelSet, deckExpSet, deckStatusSet, deckCostSet, deckMaxCostSet, cardNum, invIDSet, cardSet, deckIndexSet, positionSet);
            partsInitialize(partNum, partInvId, partArray, partUsed, partEndAt);
            itemsInitialize(itemNum, itemInvId, itemArray, itemStateArray);
            slotsInitialize(slotNum, slotInvId, slotArray, slotType, slotCombined, slotDeckIndex, slotDeckPosition, slotCardPosition, slotCombineData);
            questInitialize(questNum,questInvId,questArray,questStatus,questFindTime,questBaName);
            _saleType = saleType;
            // 最初の段階でセール状態かチェック
            if (saleLimitRestTime > 0) {
                _isSale = true;
            }
            updateSaleLimitRestTime(saleLimitRestTime);
            _favoriteCharaId = favoriteCharaId;
            // 変換処理はさむ 関数か何かでも
            _floorCount = floorCount;
            _eventQuestFlag = eventQuestFlag;
            _eventQuestClearNum = eventQuestClearNum;
            _tutorialQuestFlag = tutorialQuestFlag;
            _tutorialQuestClearNum = tutorialQuestClearNum;
            _charaVoteQuestFlag = charaVoteQuestFlag;
            _charaVoteQuestClearNum = charaVoteQuestClearNum;
            log.writeLog(log.LV_DEBUG, this, "init event questFlag", _eventQuestFlag,_eventQuestClearNum);
            log.writeLog(log.LV_DEBUG, this, "init tutorial questFlag", _tutorialQuestFlag,_tutorialQuestClearNum);
            log.writeLog(log.LV_DEBUG, this, "init charaVote questFlag", _charaVoteQuestFlag,_charaVoteQuestClearNum);
            log.writeLog(log.LV_INFO, this, "++New Avatar", name, recoveryInterval);
        }

        // 所持カードの初期化
        public function cardsInitialize(deckNum:int, deckName:Array, deckKind:Array, deckLevel:Array,deckExp:Array, deckStutus:Array,deckCost:Array,deckMaxCost:Array, cardNum:int, invIDSet:Array, cardSet:Array, deckIndexSet:Array, positionSet:Array):void
        {
            CharaCardInventory.initializeInventory();
            CharaCardDeck.initializeDeck();
            WeaponCardDeck.initializeDeck();
            EquipCardDeck.initializeDeck();
            EventCardDeck.initializeDeck();

            // 名前つきデッキを作成
            deckName.forEach(function(item:*, index:int, array:Array):void {new CharaCardDeck(item, deckKind[index], deckLevel[index], deckExp[index], deckStutus[index], deckCost[index], deckMaxCost[index]); new WeaponCardDeck(item); new EquipCardDeck(item), new EventCardDeck(item)});

            // カードインベントリを作成
            invIDSet.forEach(function(item:*, index:int, array:Array):void {new CharaCardInventory(item, CharaCard.ID(cardSet[index]), deckIndexSet[index], positionSet[index])});
            // カードインベントリをpositionでソート
            CharaCardInventory.sortPosition();
            // デッキにカードインベントリをセット
            CharaCardInventory.cards.forEach(function(item:*, index:int, array:Array):void {CharaCardDeck.initCharaCardInventory(item)});
        }

        // 所持パーツの初期化
        public function partsInitialize(partsNum:int, invIDSet:Array, partsSet:Array, usedSet:Array, endAtSet:Array):void
        {
            AvatarPartInventory.initializeInventory();
            // アバターパーツインベントリを作成
            log.writeLog(log.LV_FATAL, this, "part partused 2",usedSet);
            invIDSet.forEach(function(item:*, index:int, array:Array):void {new AvatarPartInventory(item, AvatarPart.ID(partsSet[index]),  usedSet[index], endAtSet[index])});
        }

        // 所持アイテムの初期化
        public function itemsInitialize(itemNum:int, invIDSet:Array, itemsSet:Array, itemStateArray:Array):void
        {
            AvatarItemInventory.initializeInventory();
            // アバターアイテムインベントリを作成
            invIDSet.forEach(function(item:*, index:int, array:Array):void {
                    var isAddItem:Boolean = true;
                    var avatarItem:AvatarItem = AvatarItem.ID(itemsSet[index]);
                    var itemState:int = itemStateArray[index];
                    CONFIG::RAID_ITEM_OFF
                    {
                        if (avatarItem.type == AvatarItem.ITEM_RAID) { isAddItem = false; }
                    }
                    if (isAddItem) {
                        new AvatarItemInventory(item, avatarItem, itemState);
                    }
                });
            // アバターアイテムをソート
            AvatarItemInventory.sortAvatarItemId();
        }

        // スロットカードの初期化
        public function slotsInitialize(slotNum:int, slotInvId:Array, slotArray:Array, slotType:Array, slotCombined:Array, slotDeckIndex:Array, slotDeckPosition:Array, slotCardPosition:Array, slotCombineData:Array):void
        {
            WeaponCardInventory.initializeInventory();
            EquipCardInventory.initializeInventory();
            EventCardInventory.initializeInventory();

            // タイプに応じてカードを作成
            var i:int;
            for(i = 0; i < slotNum; i++)
            {
                switch (slotType[i])
                {
                case Const.SCT_WEAPON: // 武器カード
                    var wc:WeaponCard;
                    if (slotCombined[i]) {
                        wc = WeaponCard.createCombineWeapon(slotArray[i]);
                        var combineData:String = slotCombineData.shift();
                        wc.setCombineWeaponParamByteData(combineData);
                    } else {
                        wc = WeaponCard.ID(slotArray[i]);
                    }
                    new WeaponCardInventory(slotInvId[i], wc, slotDeckIndex[i], slotDeckPosition[i], slotCardPosition[i]);
                    break;
                case Const.SCT_EQUIP: // 装備カード
                    new EquipCardInventory(slotInvId[i], EquipCard.ID(slotArray[i]), slotDeckIndex[i], slotDeckPosition[i], slotCardPosition[i]);
                    break;
                case Const.SCT_EVENT: // イベントカード
                    new EventCardInventory(slotInvId[i], EventCard.ID(slotArray[i]), slotDeckIndex[i], slotDeckPosition[i], slotCardPosition[i]);
                    break;
                default:
                }
            }
            // スロットカードをソート
            WeaponCardInventory.sortWeaponCardId();
            EquipCardInventory.sortEquipCardId();
            EventCardInventory.sortEventCardId();
            WeaponCardInventory.cards.forEach(function(item:WeaponCardInventory, index:int, array:Array):void {WeaponCardDeck.initWeaponCardInventory(item)});
            EquipCardInventory.cards.forEach(function(item:EquipCardInventory, index:int, array:Array):void {EquipCardDeck.initEquipCardInventory(item)});
            EventCardInventory.cards.forEach(function(item:EventCardInventory, index:int, array:Array):void {EventCardDeck.initEventCardInventory(item)});
// WeaponCardDeck.initWeaponCardInventory
        }

        private function questInitialize(questNum:int, questInvId:Array, questArray:Array, questStatus:Array, questFindTime:Array, questBaName:Array):void
        {
            AvatarQuestInventory.initializeInventory();
            log.writeLog(log.LV_FATAL, this, "Quest Init",questNum, questInvId, questArray, questStatus, questFindTime, questBaName);
            // アバタークエストインベントリを作成
            for(var i:int = 0; i < questNum; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "Quest Init",i);
                new AvatarQuestInventory(questInvId[i], Quest.ID(questArray[i]), questFindTime[i], questStatus[i], questBaName[i]);
            }

        }

//         public function achievementInitialize( achievementArray:Array, achievementStatus:Array, achievementProgress:Array):void
//         {
//             log.writeLog(log.LV_FATAL, this, "Achievement Init", achievementArray, achievementStatus, achievementProgress,achievementCode);
//             var num:int = achievementArray.length;
//             // アチーブメントインベントリを作成
//             for(var i:int = 0; i < num; i++)
//             {
// //                log.writeLog(log.LV_FATAL, this, "Quest Init",i);
//                 var progress:String = "";
//                 var code:String = "";
//                 if ( achievementProgress[i] != null ) progress = achievementProgress[i];
//                 if ( achievementCode[i] != null ) code = achievementCode[i];
//                 new AchievementInventory(achievementArray[i], achievementStatus[i], progress, code);
//             }

//         }

        public function achievementUpdate( achievementsArray:Array, achievementsState:Array, achievementsProgress:Array, achievementsEndAt:Array,achievementsCode:Array):void
        {
//            log.writeLog(log.LV_FATAL, this, "Achievement Update", achievementsArray, achievementsState, achievementsProgress, achievementsEndAt);
            var num:int = achievementsArray.length;
            for(var i:int = 0; i < num; i++)
            {
                var aInv:AchievementInventory = AchievementInventory.getInventory(achievementsArray[i]);
                if (aInv&&aInv.achievementId==achievementsArray[i]) {
                    // アチーブメントインベントリを更新
                    if ( achievementsState[i] != null && aInv.state != achievementsState[i] && aInv.state != Const.ACHIEVEMENT_STATE_FINISH && aInv.state != Const.ACHIEVEMENT_STATE_FAILED ) {
                        aInv.state = achievementsState[i];
                    }
                    if ( achievementsProgress[i] != null ) {
                        aInv.progress = achievementsProgress[i];
                    }
                    if ( achievementsEndAt[i] != null ) {
                        aInv.endAtTime = achievementsEndAt[i];
                    }
                    if ( achievementsCode[i] != null ) {
                        aInv.code = achievementsCode[i];
                        if(achievementsCode[i] != "")
                        {
                            LobbyNotice.setAchievementClearCode(achievementsArray[i]);
                        }
                    }
                }else {
                    // アチーブメントインベントリを作成
                    new AchievementInventory(achievementsArray[i], achievementsState[i], achievementsProgress[i], achievementsEndAt[i],achievementsCode[i]);
                }
            }
        }

        // 行動力のセッター
        public function set energy (i:int):void
        {
            _energy = i;
            dispatchEvent(new Event(ENERGY_UPDATE));
        }

        // 残り時間のセッタ
        public function set remainTime (i:int):void
        {
            _remainTime = i;
        }

        // 行動力MAXのセッター
        public function set energyMax (i:int):void
        {
            _energyMax = i;
            dispatchEvent(new Event(ENERGY_MAX_UPDATE));
        }
        public function get isEnergyMax():Boolean
        {
            return _energyMax <= _energy;
        }

        // Gemのセッター
        public function set gems (i:int):void
        {
            _gems = i;
            dispatchEvent(new Event(GEMS_UPDATE));
        }

        // 経験値のセッター
        public function set exp (i:int):void
        {
            _exp = i;
            dispatchEvent(new Event(EXP_UPDATE));
        }

        // レベルのセッター
        public function set level (i:int):void
        {
            _level = i;
            dispatchEvent(new Event(LEVEL_UPDATE));
        }

        // バトルポイントのゲッター
        public function set point(i:int):void
        {
            _point = i;
            dispatchEvent(new Event(RESULT_UPDATE));
        }

        // バトルポイントのゲッター
        public function set win(i:int):void
        {
            _win = i;
            dispatchEvent(new Event(RESULT_UPDATE));
        }

        // バトルポイントのゲッター
        public function set lose(i:int):void
        {
            _lose = i;
            dispatchEvent(new Event(RESULT_UPDATE));
        }

        // バトルポイントのゲッター
        public function set draw(i:int):void
        {
            _draw = i;
            dispatchEvent(new Event(RESULT_UPDATE));
        }

        // ログインボーナスのセッター
        public function set loginBonus(i:Array):void
        {
            _loginBonus = i;
            LobbyNotice.setLoginInfo(i[0],i[1],i[2],i[3]);
            dispatchEvent(new Event(UPDATE_LOGIN_BONUS));
        }
        // IDのゲッター
        public function get id():int
        {
            return _id;
        }

        // 名前のゲッター
        public function get name():String
        {
            return _name;
        }

        // Gemのゲッター
        public function get gems():int
        {
            return _gems;
        }

        // 経験値のゲッター
        public function get exp():int
        {
            return _exp;
        }

        // レベルのゲッター
        public function get level():int
        {
            return _level;
        }

        // 行動力のゲッター
        public function get energy():int
        {
            return _energy;
        }

        // 行動力のゲッター
        public function get remainTime():int
        {
            return _remainTime;
        }

        // 行動力MAXのゲッター
        public function get energyMax():int
        {
            return _energyMax;
        }

        // バトルポイントのゲッター
        public function get point():int
        {
            return _point;
        }

        // 勝利数のゲッター
        public function get win():int
        {
            return _win;
        }

        // 敗北数のゲッター
        public function get lose():int
        {
            return _lose;
        }

        // 引分数のゲッター
        public function get draw():int
        {
            return _draw;
        }

        public function get partInventoryMax():int
        {
            return _partInventoryMax;
        }

        public function set partInventoryMax(p:int):void
        {
            _partInventoryMax = p;
            dispatchEvent(new Event(PART_MAX_UPDATE));
        }

        public function get checkMaxPartInventory():Boolean
        {
            return AvatarPartInventory.items.length > _partInventoryMax;
        }

        // 次レベル経験値
        public function get nextExp():int
        {
//             var expcount:int = 0;
//             for(var i:int; i < _level+1; i++)
//             {
//                 expcount += Const.LEVEL_EXP_TABLE[i];
//             }
//             return expcount;

            var ret:int = 0;
            if (_level < Const.LEVEL_MAX) { ret = Const.LEVEL_EXP_TABLE[_level]; }
            return ret;
        }

        // 回復間隔のゲッター
        public function get recoveryInterval():int
        {
            return _recoveryInterval;
        }

        // 回復間隔のゲッター
        public function set recoveryInterval(time:int):void
        {
             _recoveryInterval = time;
             dispatchEvent(new Event(UPDATE_RECOVERY_INTERVAL));

        }

        // カレントデッキ番号のゲッター
        public function get currentDeck():int
        {
            return _currentDeck;
        }

        // ログインボーナスのセッター
        public function get loginBonus():Array
        {
            return _loginBonus;
        }

        // カレントデッキ番号のセッター
        public function set currentDeck(i:int):void
        {
            _currentDeck = i;
        }

        // EXPの倍率のセッター
        public function set expPow(i:int):void
        {
            _expPow = i;
            dispatchEvent(new Event(UPDATE_BONUS));
        }

        // EXPの倍率のgettrt
        public function get expPow():int
        {
            return _expPow;
        }

        // GEMの倍率のセッター
        public function set gemsPow(i:int):void
        {
            _gemsPow = i;
            dispatchEvent(new Event(UPDATE_BONUS));
        }

        // GEMの倍率のセッター
        public function get gemsPow():int
        {
            return _gemsPow;
        }

        // EXPのクエスト探索時間倍率のセッター
        public function set questFindPow(i:int):void
        {
            _questFindPow = i;
            dispatchEvent(new Event(UPDATE_BONUS));
        }

        // EXPのクエスト探索時間倍率のセッター
        public function get questFindPow():int
        {
            return _questFindPow;
        }

        public function getEquipedParts():Array
        {
            return AvatarPartInventory.getEquipItems();
        }

         public function getWaitEquipedPartsDataThread():Thread
         {
             return new LoaderThread(this);
         }

        public function get tickets():int
        {
            return AvatarItemInventory.getItemsNum(Const.RARE_CARD_TICKET);
        }

        // 更新イベントのみ発動
        public function setQuestType(t:int,isEvent:Boolean=true):void
        {
            _questType = t;
            if (isEvent) {dispatchEvent(new Event(QUEST_FLAG_UPDATE));}
        }
        public function get questType():int
        {
            return _questType;
        }

        // クエスト進行度を更新
        public function set questFlag(q:int):void
        {
            _questFlag = q;
            dispatchEvent(new Event(QUEST_FLAG_UPDATE));
        }
        public function set eventQuestFlag(q:int):void
        {
            log.writeLog (log.LV_DEBUG,this,"set eventQuestFlag!",_eventQuestFlag,q);
            _eventQuestFlag = q;
            dispatchEvent(new Event(QUEST_FLAG_UPDATE));
        }
        public function set tutorialQuestFlag(q:int):void
        {
            log.writeLog (log.LV_DEBUG,this,"set tutorialQuestFlag!",_tutorialQuestFlag,q);
            _tutorialQuestFlag = q;
            dispatchEvent(new Event(QUEST_FLAG_UPDATE));
        }
        public function set charaVoteQuestFlag(q:int):void
        {
            log.writeLog (log.LV_DEBUG,this,"set charaVoteQuestFlag!",_charaVoteQuestFlag,q);
            _charaVoteQuestFlag = q;
            dispatchEvent(new Event(QUEST_FLAG_UPDATE));
        }
        // クエスト更新度のゲッタ
        public function get questFlag():int
        {
            var flag:int = _questFlag;
            var cap:int = Const.QUEST_CAP;
            if (_questType == Const.QUEST_EVENT) {
                flag = _eventQuestFlag;
                cap = Const.EVENT_QUEST_CAP;
            } else if (_questType == Const.QUEST_TUTORIAL) {
                flag = _tutorialQuestFlag;
                cap = Const.TUTORIAL_QUEST_CAP;
            } else if (_questType == Const.QUEST_CHARA_VOTE) {
                flag = _charaVoteQuestFlag;
                cap = Const.CHARA_VOTE_QUEST_CAP;
            }
//            log.writeLog (log.LV_DEBUG,this,"get qiestFlag!",_questType,flag,cap,_eventQuestFlag,_tutorialQuestFlag,_charaVoteQuestFlag);
            if(flag > cap)
            {
                return cap;
            }
            else
            {
                return flag;
            }
//            return _questFlag;
        }

        // クエスト更新度のゲッタ
        public function get questCap():Boolean
        {
            var flag:int = _questFlag;
            var cap:int = Const.QUEST_CAP;
            if (_questType == Const.QUEST_EVENT) {
                flag = _eventQuestFlag;
                cap = Const.EVENT_QUEST_CAP;
            } else if (_questType == Const.QUEST_TUTORIAL) {
                flag = _tutorialQuestFlag;
                cap = Const.TUTORIAL_QUEST_CAP;
            } else if (_questType == Const.QUEST_CHARA_VOTE) {
                flag = _charaVoteQuestFlag;
                cap = Const.CHARA_VOTE_QUEST_CAP;
            }
            if(flag > cap)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        // クエスト達成数を更新
        public function set questClearNum(q:int):void
        {
            _questClearNum = q;
            dispatchEvent(new Event(QUEST_CLEAR_NUM_UPDATE));
        }
        public function set eventQuestClearNum(q:int):void
        {
            _eventQuestClearNum = q;
            dispatchEvent(new Event(QUEST_CLEAR_NUM_UPDATE));
        }
        public function set tutorialQuestClearNum(q:int):void
        {
            _tutorialQuestClearNum = q;
            dispatchEvent(new Event(QUEST_CLEAR_NUM_UPDATE));
        }
        public function set charaVoteQuestClearNum(q:int):void
        {
            _charaVoteQuestClearNum = q;
            dispatchEvent(new Event(QUEST_CLEAR_NUM_UPDATE));
        }

        // クエスト更新度のゲッタ
        public function get questClearNum():int
        {
            var clearNum:int = _questClearNum;
            if (_questType == Const.QUEST_EVENT) {
                clearNum = _eventQuestClearNum;
            } else if (_questType == Const.QUEST_TUTORIAL) {
                clearNum = _tutorialQuestClearNum;
            } else if (_questType == Const.QUEST_CHARA_VOTE) {
                clearNum = _charaVoteQuestClearNum;
            }
           return clearNum;
        }

        // クエスト探索数のMAXのゲッタ
        public function get questMax():int
        {
            return _questMax;
        }

        // クエスト探索数のMAXのセッタ
        public function set questMax(qm:int):void
        {
            _questMax = qm;
            dispatchEvent(new Event(QUEST_MAX_UPDATE));
        }

        // フレンド数のMAXのゲッタ
        public function get friendMax():int
        {
            return _friendMax;
        }

        // フレンド数のMAXのセッタ
        public function set friendMax(fr:int):void
        {
            _friendMax = fr;
            dispatchEvent(new Event(FRIEND_MAX_UPDATE));
        }


        // フレンド数のMAXのゲッタ
        public function get freeDuelCount():int
        {
            return _freeDuelCount;
        }

        // フレンド数のMAXのセッタ
        public function set freeDuelCount(fr:int):void
        {
            _freeDuelCount = fr;
            dispatchEvent(new Event(FREE_DUEL_COUNT_UPDATE));
        }


        // 経験値をもらった場合レベルアップを何回するかを返す
        public function levelUpNum(e:int):int
        {
            var cExp:int= e+exp;
            var num:int =0;
            while ((cExp - Const.LEVEL_EXP_TABLE[_level+num]) >-1)
            {
                num+=1
            }
            exp = cExp;
            level = level + num;
            log.writeLog(log.LV_FATAL, this, "result::",e,cExp,_level,num);
            return num
        }
        public function getCurrentDeck():CharaCardDeck
        {
//            log.writeLog(log.LV_FATAL, this, "getCure");
            return CharaCardDeck.decks[_currentDeck];
        }
        public function get currentDeckCost():int
        {
            return CharaCardDeck.decks[_currentDeck].cost["total"] + EventCardDeck.decks[_currentDeck].cost + WeaponCardDeck.decks[_currentDeck].cost;
        }

        // セールタイプのゲッター
        public function get saleType():int
        {
            return _saleType;
        }

        // セールタイプのセッター
        public function set saleType(type:int):void
        {
            _saleType = type;
        }

        // セール残り時間の初期化
        public function updateSaleLimitRestTime(restTime:int):void
        {
//            log.writeLog(log.LV_DEBUG, this, "saleLimitRestTime",restTime);
            _saleLimitRestTime = restTime;
            if (_saleLimitRestTime > 0)
            {
                // 終了時間を計算する
                var now:Date = new Date();
                _saleEndAt = new Date(now.getTime()+_saleLimitRestTime*1000);
//                log.writeLog(log.LV_DEBUG, this, "saleLimitRestTime saleEndAt",_saleEndAt,_saleEndAt.getTime());

                // 待ちThreadを起動させる
                var delay:int = _saleEndAt.getTime() - now.getTime();
//                log.writeLog(log.LV_DEBUG, this, "saleLimitRestTime delay",delay);
                if (_waitThread != null && _waitThread.state != ThreadState.TERMINATED)
                {
                    _waitThread.interrupt();
                }
                _waitThread = new WaitThread(delay+1500, saleFinishCheck);
                _waitThread.start();

                // セール中でなかった場合
                if (_isSale == false) {
//                    log.writeLog(log.LV_DEBUG, this, "saleLimitRestTime sale start", _isSale);
                    // セール開始イベントを発行
                    dispatchEvent(new AvatarSaleEvent(AvatarSaleEvent.SALE_START));
                    _isSale = true;
                }
            } else {
                if (_waitThread != null && _waitThread.state != ThreadState.TERMINATED)
                {
                    _waitThread.interrupt();
                }
                if (_saleEndAt)
                {
//                    log.writeLog(log.LV_DEBUG, this, "saleLimitRestTime saled");
                    // セール終了イベントを発行
                    dispatchEvent(new AvatarSaleEvent(AvatarSaleEvent.SALE_FINISH));
                }
                _saleEndAt = null;
            }
        }

        // セール終了チェック
        private function saleFinishCheck():void
        {
//            log.writeLog(log.LV_DEBUG, this, "saleFinishCheck");
            // セール終了かチェックする
            LobbyCtrl.instance.saleFinishCheck();
        }

        // セール残り時間のゲッター
        public function get saleLimitRestTime():Number
        {
            var ret:Number =0;

            if (_saleEndAt != null)
            {
                ret = calcSaleRestTime(_saleEndAt)
            }
            if (ret<0)
            {
                return 0;
            }else{
                return ret;
            }
        }
        private function calcSaleRestTime(endAt:Date):Number
        {
            var now:Date = new Date();
            return endAt.getTime()-now.getTime();
        }

        // セール中かの判定
        public function get isSaleTime():Boolean
        {
            if (_saleLimitRestTime > 0) {
                return true;
            }
            return false;
        }

        // お気に入りキャラID
        public function set favoriteCharaId(id:int):void
        {
            _favoriteCharaId = id;
        }
        // お気に入りキャラID
        public function get favoriteCharaId():int
        {
            return _favoriteCharaId;
        }

        // public function initResultCharaImages():void
        // {
        //     // ここでやるのか
        //     var images:Object = {};
        //     _resultCharaImages = images;
        // }

        // public function get resultCharaImages():Object
        // {
        //     return _resultCharaImages;
        // }

        // フロアカウント
        public function set floorCount(c:int):void
        {
            _floorCount = c;
        }
        // フロアカウント
        public function get floorCount():int
        {
            return _floorCount;
        }
    }
}



import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import model.*;
import model.Feat;
import model.utils.ReLoaderThread;

// OtherAvatarのロードを待つスレッド
class LoaderThread extends Thread
{
    private var  _a:Avatar;

    public function LoaderThread(a:Avatar)
    {
        _a =a;
    }

    protected override function run():void
    {
        next(loading);
    }

    private function loading ():void
    {
        var pExec:ParallelExecutor = new ParallelExecutor();

        var parts:Array = _a.getEquipedParts(); /* of  = */ 
//        log.writeLog(log.LV_FATAL, this, "avatar parts len",  parts.length);
        for(var i:int = 0; i < parts.length; i++)
        {
            var x:AvatarPart = parts[i];
            pExec.addThread(x.getLoader());
//            log.writeLog(log.LV_FATAL, this, "avatar parts id", x.id, x.loaded);
        }
        pExec.start();
        pExec.join();
        next(close);
    }

    private function waitingTimer ():void
    {
        log.writeLog(log.LV_FATAL, this, "waiting load...");
        sleep(1000);
        next(close);
            
    }
    

    private function close ():void
    {
        var loaded:Boolean = true;
        var parts:Array = _a.getEquipedParts(); /* of  = */ 
        for(var i:int = 0; i < parts.length; i++)
        {
            var x:AvatarPart = parts[i];
            if (x.loaded == false)
            {
                loaded == false;
            }
//            log.writeLog(log.LV_FATAL, this, "avatar parts loaded", loaded);
        }

        if (loaded)
        {
            return
            log.writeLog(log.LV_FATAL, this, "parts data all get. close.");
        }else{
            next(loading);
        }

    }
}

