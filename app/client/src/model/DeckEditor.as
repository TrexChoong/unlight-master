package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import model.events.*;
    import model.Shop;
    import model.Combine;

    /**
     * デッキ編集クラス
     *
     *
     */
    public class DeckEditor extends BaseModel
    {
        // シングルトンインスタンス
        private static var __instance:DeckEditor;

        // プレイヤーインスタンス
        private var _player:Player = Player.instance;

        // イベント
        public static const START:String  = 'start';                             // カード編集を開始
//        public static const SAVE:String   = 'save';                              // 編集内容を保存
        public static const UPDATE:String = 'update';                            // データの再読み込み
        public static const WAITING:String = 'waiting';                          // 待機中
        public static const CHANGE_TYPE:String = 'change_type';                  // 編集タイプ変更
        public static const INDEX_CHANGE:String = 'index_change';                // インデックスの変更
        public static const END:String    = 'end';                               // カード編集を終了
        public static const DECK_COST_UPDATE:String = 'deck_cost_update';

        // ソートプロパティ定数
        public static const SORT_ID:String = "id";           // カードID
        public static const SORT_NAME:String = "name";       // 名前
        public static const SORT_AB_NAME:String = "abName";  // 英名
        public static const SORT_LEVEL:String = "level";     // レベル
        public static const SORT_HP:String = "hp";           // ヒットポイント
        public static const SORT_AP:String = "ap";           // 攻撃力
        public static const SORT_DP:String = "dp";           // 守備力
        public static const SORT_COST:String = "cost";       // コスト
        public static const SORT_RARITY:String = "rarity";   // レアリティ
        public static const SORT_STORY_AGE_NO:String = "age_no";   // ストーリーの時系列

        // ステート
        private var _state:String = '';

        // ソートプロパティ
        private var _sort:String = SORT_ID;
        private var _sortOrder:Array = [SORT_ID, SORT_LEVEL, SORT_COST, SORT_HP, SORT_AP, SORT_DP, SORT_RARITY, SORT_NAME];
        private var _sortFlip:Boolean = false;

        private var _combine:Combine = Combine.instance;
        private var _selectChara:int = 0;

        // デッキ関連
        private static const _START_INDEX:int = 1;             // デッキの初期インデックス
        private static const _CHARA_CARD_MAX:int = 3;          // デッキの最大カード数
        private static const _WEAPON_CARD_MAX:int = 1;         // デッキの最大カード数
        private static const _EQUIP_CARD_MAX:int = 1;          // デッキの最大カード数
        private static const _EVENT_CARD_MAX:int = 6;          // デッキの最大カード数
        private var _selectIndex:int = 1;                      // 選択中のデッキインデックス
        private var _editType:int = 0;                         // 編集タイプ

//         // 前回のイベントを保管
//         private var _strEvent:String = "";

        /**
         * シングルトンインスタンスを返すクラス関数
         *
         *
         */
        public static function get instance():DeckEditor
        {
            if( __instance == null )
            {
                __instance = createInstance();
            }
            return __instance;
        }

        // 本当のコンストラクタ
        private static function createInstance():DeckEditor
        {
            return new DeckEditor(arguments.callee);
        }

        // コンストラクタ
        public function DeckEditor(caller:Function)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
        }

        // ステータスのゲッター
        public function get state():String
        {
            return _state;
        }

        // ソートのゲッター
        public function get sort():String
        {
            return _sort;
        }

        // ソートのセッター
        public function set sort(s:String):void
        {
            if(_sort == s)
            {
                _sortFlip = !_sortFlip;
            }
            else
            {
                _sortFlip = false;
                _sort = s;
            }

            _sortOrder.slice(_sortOrder.indexOf(s),1);
            _sortOrder.unshift(s);
        }

        public function get selectChara():int
        {
            return _selectChara;
        }
        public function set selectChara(s:int):void
        {
            _selectChara = s;
        }

        public function get deckNum():int
        {
            return CharaCardDeck.decks.length;
        }

        // デッキ番号をセットする
        public function set selectIndex(i:int):void
        {
            if(i < _START_INDEX)
            {
                _selectIndex = CharaCardDeck.decks.length-1;
            }
            else if(i >= CharaCardDeck.decks.length || i == 0)
            {
                _selectIndex = _START_INDEX;
            }
            else
            {
                _selectIndex = i;
            }
            dispatchEvent(new Event(INDEX_CHANGE));
            log.writeLog(log.LV_INFO, this, "select deck is", _selectIndex);

        }

        // ゲームに使用するデッキの番号を取得する
        public function get currentIndex():int
        {
            return _player.avatar.currentDeck;
        }

        // 選択中のデッキ番号を取得する
        public function get selectIndex():int
        {
            return _selectIndex;
        }

        // 編集タイプを取得する
        public function get editType():int
        {
            return _editType;
        }

        // 編集タイプの共通化先。共通化できるパーツは共通化する
        public function substanceEditType(t:int = -1):int
        {
            var type:int = t < 0 ? _editType : t;

            switch (type)
            {
            case InventorySet.TYPE_CHARA:
            case InventorySet.TYPE_MONSTER:
            case InventorySet.TYPE_OTHER:
                return InventorySet.TYPE_CHARA;
                break;
            default:
                return type;
            }
        }

        // 次のデッキ番号を取得する
        public function get nextIndex():int
        {
            if(_selectIndex + 1 > CharaCardDeck.decks.length-1)
            {
                return _START_INDEX;
            }
            else
            {
                return _selectIndex + 1;
            }
        }

        // 前のデッキ番号を取得する
        public function get prevIndex():int
        {
            if(CharaCardDeck.decks.length == 1)
            {
                return _START_INDEX;
            }
            else if(_selectIndex - 1 < _START_INDEX)
            {
                return CharaCardDeck.decks.length-1;
            }
            else
            {
                return _selectIndex - 1;
            }
        }

        // 初期化
        public function initialize():void
        {
            _state = START;
            selectIndex = _player.avatar.currentDeck;
            dispatchEvent(new Event(START));
        }

        // 全ての編集内容を保存する
        public function save():void
        {
//             // フラグを見てカードを保存する
            CharaCardInventory.sortDirtyFlag();
            WeaponCardInventory.sortDirtyFlag();
            EventCardInventory.sortDirtyFlag();
            // CharaCardInventory.cards.forEach(function(item:*, index:int, array:Array):void{if(item.save()){dispatchEvent(new EditCardEvent(EditCardEvent.UPDATE_CHARA_CARD, item));}});
            // 変更のあるカードのみ変更
            CharaCardInventory.getDirtyFlagCardList().forEach(function(item:*, index:int, array:Array):void{dispatchEvent(new EditCardEvent(EditCardEvent.UPDATE_CHARA_CARD, item));});
            WeaponCardInventory.cards.forEach(function(item:*, index:int, array:Array):void{if(item.save()){dispatchEvent(new EditCardEvent(EditCardEvent.UPDATE_WEAPON_CARD, item))}});
            EventCardInventory.cards.forEach(function(item:*, index:int, array:Array):void{if(item.save()){dispatchEvent(new EditCardEvent(EditCardEvent.UPDATE_EVENT_CARD, item))}});
//             dispatchEvent(new Event(SAVE));
        }

        // バインダーにあるカードをソートする
        public function binderSort():void
        {
            InventorySet.type = _editType;

            // フリップの挙動自体をしないよう一時コメントアウト 2012/06/13 yamagishi
            // if(_sortFlip)
            // {
            //     if(_sort == SORT_NAME)
            //     {
            //         InventorySet.inventories.sortOn(_sort, Array.DESCENDING);
            //     }
            //     else
            //     {
            //         InventorySet.inventories.sortOn(_sort, Array.NUMERIC | Array.DESCENDING);
            //     }
            // }
            // else
            // {
            //     if(_sort == SORT_NAME)
            //     {
            //         InventorySet.inventories.sortOn(_sort);
            //     }
            //     else
            //     {
            //         InventorySet.inventories.sortOn(_sort, Array.NUMERIC);
            //     }
            // }

            if(_sort == SORT_NAME)
            {
                InventorySet.inventories.sortOn(_sortOrder);
            }
            else
            {
                InventorySet.inventories.sortOn(_sortOrder, Array.NUMERIC);
            }

            dispatchEvent(new EditDeckEvent(EditDeckEvent.BINDER_SORT));
        }

        public function binderSelect():void
        {
            dispatchEvent(new EditDeckEvent(EditDeckEvent.BINDER_SELECT));
        }

        // 編集タイプを選択する
        public function setEditType(t:int):void
        {
            _editType = t;
            dispatchEvent(new Event(CHANGE_TYPE));
        }

        // カードを選択する
        public function selectCard(charaCardId:int,ci:ICardInventory=null):void
        {
            dispatchEvent(new EditCardEvent(EditCardEvent.SELECT_CARD, ci, charaCardId));
        }

        // ここはカード種類別になる
        // バインダーからデッキにキャラカードインベントリを移す
        public function binderToDeckCharaCard(cci:CharaCardInventory, index:int):void
        {
            if((CharaCardDeck.decks[index].cardInventories.length < _CHARA_CARD_MAX) &&
               (CharaCardDeck.decks[index].checkCharaCardDobble(cci.charaCard) &&
                (CharaCardDeck.decks[index].checkMostarCard(cci.charaCard))) &&
               CharaCardDeck.decks[index].checkUseRaidDuel()
                )
            {
                CharaCardDeck.binderToDeck(index, cci);
                dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_CHARA, cci, index));
                // イベントカードのスロット更新する
                EventCardDeck.decks[index].checkAllSlot();
            }
            //save();
        }


        // デッキからバインダーにキャラカードインベントリを移す
        public function deckToBinderCharaCard(cci:CharaCardInventory):void
        {
            if (CharaCardDeck.decks[cci.index].checkUseRaidDuel()) {
                if (CharaCardDeck.decks[cci.index].checkNotLastPlayerCharaCard(cci.charaCard))
                {
                    CharaCardDeck.deckToBinder(cci);
                    dispatchEvent(new EditCardEvent(EditCardEvent.DECK_TO_BINDER_CHARA, cci, 0));
                }else{
                    deleteDeck(cci.index);
                }
            } else {
                dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_CHARA, cci, cci.index));
            }
            //save();
        }

        public function deckToDeckCharaCard(index:int):void
        {
            CharaCardDeck.updateCharaPos(index);
            EventCardDeck.updateEventPos(index);
            WeaponCardDeck.updateWeaponPos(index);

            EventCardDeck.decks[index].checkAllSlot();

            dispatchEvent(new Event(DECK_COST_UPDATE));

            //save();
        }

        // スロットカードインベントリ更新に失敗インベントリを書き戻す
        public function updateSlotCardInventoryFailed(kind:int, invId:int, index:int , position:int, cPosition:int):void
        {
//             var cardLen:int = invIdSet.length;
//             var cci:CharaCardInventory;
            // バインダーかデッキか
            if(index == 0)
            {
                switch (kind)
                {
                case Const.SCT_WEAPON:
                    var wci:WeaponCardInventory;
                    wci = WeaponCardInventory.getInventory(invId);
                    WeaponCardDeck.deckToBinder(wci);
                  break;
                case Const.SCT_EQUIP:
                    var eci:EquipCardInventory;
                    eci = EquipCardInventory.getInventory(invId);
                    EquipCardDeck.deckToBinder(eci);
                    break;
                case Const.SCT_EVENT:
                    var cci:EventCardInventory;
                    cci = EventCardInventory.getInventory(invId);
                    EventCardDeck.deckToBinder(cci);
                    break;
                default:
                }
            }
        }
        // バインダーからデッキに武器カードインベントリを移す
        public function binderToDeckWeaponCard(ci:ICardInventory, index:int, charPos:int):void
        {
            // 渦戦闘中か
            if (!CharaCardDeck.decks[index].checkUseRaidDuel())
            {
                return;
            }

            // 合成処理用
            if (_combine.state == Combine.COMBINES) {
                log.writeLog(log.LV_FATAL, this, "btdw",ci.cardId,CombineEditDeck.deck.getCardIdList());
                var cardIdList:Array = CombineEditDeck.deck.getCardIdList();
                // 素材をセットできるか判定
                var setCheck:int = CombineEditDeck.deck.checkCardSetList(WeaponCardInventory(ci));
                if (setCheck == CombineEditDeck.SET_SUCCESS){
                    log.writeLog(log.LV_FATAL, this, "btdw 1");
                    if (CombineEditDeck.deck.checkSameCardIn(WeaponCardInventory(ci))) {
                        dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_COMBINE_WEAPON_ADD, ci, index));
                    } else {
                        CombineEditDeck.binderToDeck(WeaponCardInventory(ci), index, charPos);
                        dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_COMBINE_WEAPON, ci, index));
                    }
                } else {
                    // セットできないエラー
                    var errMsg:String = CombineEditDeck.getErrMsg(setCheck);
                    Alerter.showWithSize(errMsg, CombineEditDeck.ERR_MASSAGES[setCheck]["title"]);
                }
                return;
            } else {
                log.writeLog(log.LV_DEBUG, this, "btdw not combine");
                // 素材カードなら装備させない
                if (WeaponCard(ci.card).weaponType == Const.WEAPON_TYPE_MATERIAL) {
                    return;
                }
            }

            // キャラカードがポジションに存在するか？(0,1,2)
            if(CharaCardDeck.decks[index].cardInventories.length < charPos+1)
            {
                return;
            }
            // ポジション存在するカードはMAXより上ならエラー)
            if(WeaponCardDeck.decks[index].getPositionCard(charPos).length >= _WEAPON_CARD_MAX)
            {
                log.writeLog(log.LV_FATAL, this, "overCard",EventCardDeck.decks[index].getPositionCard(charPos));
                return;
            }
            // キャラカードの専用装備判定
            if (WeaponCard.ID(ci.cardId).restriction[0] != "")
            {
                // グループ装備判定
                var restriction:Array = [];
                if (Const.CHARA_GROUP_NAME.hasOwnProperty(WeaponCard.ID(ci.cardId).restriction[0]))
                {
                    restriction = Const.CHARA_GROUP_MEMBERS[WeaponCard.ID(ci.cardId).restriction[0]];
                }
                else
                {
                    restriction = WeaponCard.ID(ci.cardId).restriction;
                }

                // 親のキャラクターIDで見る。親が装備出来るものは子も装備できる
                if (restriction.indexOf(String(CharaCardDeck.decks[index].cardInventories[charPos].card.parentID)) < 0)
                {
                    log.writeLog(log.LV_FATAL, this, "overCard",EventCardDeck.decks[index].getPositionCard(charPos));
                    return;
                }
            }

            WeaponCardDeck.binderToDeck(WeaponCardInventory(ci), index, charPos);
            //save();
            dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_WEAPON, ci, index));

        }

        // デッキからバインダーに武器カードインベントリを移す
        public function deckToBinderWeaponCard(cci:WeaponCardInventory, index:int = 0):void
        {
            // 合成処理用
            log.writeLog(log.LV_FATAL, this, "btdw",cci);
            if (_combine.state == Combine.COMBINES) {
                log.writeLog(log.LV_FATAL, this, "btdw",(_combine.state == Combine.COMBINES));
                CombineEditDeck.deckToBinder(WeaponCardInventory(cci));
                dispatchEvent(new EditCardEvent(EditCardEvent.COMBINE_TO_BINDER_WEAPON, cci, 0));
                return;
            }
            // 渦戦闘中か
            if (!CharaCardDeck.decks[cci.index].checkUseRaidDuel())
            {
                dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_WEAPON, cci, cci.index));
                return;
            }

            WeaponCardDeck.deckToBinder(cci);
            //save();
            dispatchEvent(new EditCardEvent(EditCardEvent.DECK_TO_BINDER_WEAPON, cci, 0));
        }


        // デッキからデッキにイベントカードインベントリを移す
        public function deckToDeckWeaponCard(cci:WeaponCardInventory, index:int = 0, saving:Boolean = true):void
        {
            if (saving)
            {
                //save();
            }
            dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_WEAPON, cci, index));
        }

        // // バインダーから合成候補にカードインベントリを移す
        // public function binderToCombineListWeaponCard(ci:ICardInventory, index:int, charPos:int):void
        // {
        //     WeaponCardDeck.binderToCombineList(WeaponCardInventory(ci), index, charPos);
        //     //save();
        //     dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_COMBINE_WEAPON, ci, index));
        // }

        // // 合成候補からにバインダーカードインベントリを移す
        // public function combineListToBinderWeaponCard(cci:WeaponCardInventory, index:int = 0):void
        // {
        //     WeaponCardDeck.combineListToBinder(WeaponCardInventory(cci));
        //     //save();
        //     dispatchEvent(new EditCardEvent(EditCardEvent.COMBINE_TO_BINDER_WEAPON, cci, index));
        // }

        // バインダーからデッキに装備カードインベントリを移す
        public function binderToDeckEquipCard(cci:ICardInventory, index:int):void
        {
            // 渦戦闘中か
            if (!CharaCardDeck.decks[index].checkUseRaidDuel())
            {
                return;
            }
            if(EquipCardDeck.decks[index].cardInventories.length < _CHARA_CARD_MAX)
            {
                EquipCardDeck.binderToDeck(EquipCardInventory(cci), index);
                //save();
                dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_EQUIP, cci, index));
            }
        }

        // デッキからバインダーに装備カードインベントリを移す
        public function deckToBinderEquipCard(cci:EquipCardInventory, index:int = 0):void
        {
            // 渦戦闘中か
            if (!CharaCardDeck.decks[cci.index].checkUseRaidDuel())
            {
                dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_EQUIP, cci, cci.index));
                return;
            }
            EquipCardDeck.deckToBinder(cci);
            //save();
            dispatchEvent(new EditCardEvent(EditCardEvent.DECK_TO_BINDER_EQUIP, cci, 0));
        }

        // バインダーからデッキにイベントカードインベントリを移す
        public function binderToDeckEventCard(ci:ICardInventory, index:int, charPos:int):void
        {
            // 渦戦闘中か
            if (!CharaCardDeck.decks[index].checkUseRaidDuel())
            {
                return;
            }
            // キャラカードがポジションに存在するか？(0,1,2)
            if(CharaCardDeck.decks[index].cardInventories.length < charPos+1)
            {
                log.writeLog(log.LV_FATAL, this, "chara card is none");
                return;
            }
            // ポジション存在するカードはMAXより上ならエラー)
            if(EventCardDeck.decks[index].getPositionCard(charPos).length >= _EVENT_CARD_MAX)
            {
                log.writeLog(log.LV_FATAL, this, "overCard",EventCardDeck.decks[index].getPositionCard(charPos));
                return;
            }

            // ポジションのカラースロットが開いているか？)
            if(!EventCardDeck.decks[index].checkColorNum(charPos, ci.card.color))
            {
                log.writeLog(log.LV_FATAL, this, "color slot none",EventCardDeck.decks[index].getPositionCard(charPos));
                return;
            }
            EventCardDeck.binderToDeck(EventCardInventory(ci), index, charPos);
            //save();
            dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_EVENT, ci, index));
        }

        // デッキからバインダーにイベントカードインベントリを移す
        public function deckToBinderEventCard(cci:EventCardInventory, index:int = 0):void
        {
            // 渦戦闘中か
            if (!CharaCardDeck.decks[cci.index].checkUseRaidDuel())
            {
                dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_EVENT, cci, cci.index));
                return;
            }
            EventCardDeck.deckToBinder(cci);
            //save();
            dispatchEvent(new EditCardEvent(EditCardEvent.DECK_TO_BINDER_EVENT, cci, 0));
        }

        // デッキからデッキにイベントカードインベントリを移す
        public function deckToDeckEventCard(cci:EventCardInventory, index:int, charPos:int):void
        {
            // 渦戦闘中か
            if (!CharaCardDeck.decks[cci.index].checkUseRaidDuel())
            {
                dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_EVENT, cci, cci.index));
                return;
            }
            // キャラカードがポジションに存在するか？(0,1,2)
            if(CharaCardDeck.decks[index] == null||CharaCardDeck.decks[index].cardInventories.length < charPos+1)
            {
                log.writeLog(log.LV_FATAL, this, "chara card is none");
                return;
            }
            //save();
            dispatchEvent(new EditCardEvent(EditCardEvent.DECK_TO_DECK_EVENT, cci, index));
        }

        public function deckToDeckEventCard2(cci:EventCardInventory, index:int = 0, saving:Boolean = true):void
        {
            if (saving)
            {
                //save();
            }
            dispatchEvent(new EditCardEvent(EditCardEvent.DECK_TO_DECK_EVENT, cci, index));
        }

        public function updateCautions(e:DeckUpdatedEvent):void
        {
            dispatchEvent(new DeckUpdatedEvent(DeckUpdatedEvent.UPDATED_CHARA_CARD, e.charactors, e.parents, e.costs));
        }

        // デッキの名前を変更する
        public function renameDeck(index:int, name:String):void
        {
            // 渦戦闘中か
            if (!CharaCardDeck.decks[index].checkUseRaidDuel())
            {
                return;
            }
            CharaCardDeck.decks[index].name = name;

            dispatchEvent(new EditDeckEvent(EditDeckEvent.RENAME_DECK, index, name));
        }

        // デッキを作成する
        public function createDeck():void
        {
            dispatchEvent(new EditDeckEvent(EditDeckEvent.CREATE_DECK));
        }

        // デッキを削除する
        public function deleteDeck(index:int):void
        {
            // 渦戦闘中か
            if (!CharaCardDeck.decks[index].checkUseRaidDuel())
            {
                return;
            }
//            dispatchEvent(new EditDeckEvent(EditDeckEvent.DELETE_DECK, index));
            var inv:Array  =  CharaCardDeck.decks[index].cardInventories.slice();

            inv.sortOn("position", Array.DESCENDING);
            inv.forEach(function(item:CharaCardInventory, index:int, array:Array):void{
                    log.writeLog(log.LV_FATAL, this, "sorted delete", item, item.position);
                    CharaCardDeck.deckToBinder(item);
                    dispatchEvent(new EditCardEvent(EditCardEvent.DECK_TO_BINDER_CHARA, item, 0));
                });

        }

        // デッキを作成するのに成功
        public function createDeckSuccess(dn:String, dk:int,dl:int, de:int, ds:int, dc:int, dmc:int, cardSet:Array):void
        {
            // クライアントに新しいデッキを追加
            new CharaCardDeck(dn, dk,dl, de, ds, dc, dmc);
            new WeaponCardDeck(dn);
            new EquipCardDeck(dn);
            new EventCardDeck(dn);

            // new CharaCardDeck("No Name");
            // インデックス更新
            var index:int = CharaCardDeck.decks.length-1;
            var charaPos:int = -1;
            cardSet.forEach(function(item:*, i:int, array:Array):void{
                    log.writeLog(log.LV_INFO, this, "createDeckSuccc", item,index);
                    switch (item[0])
                    {
                    case Shop.KIND_EVENT_CARD:
                        var cci:EventCardInventory;
                        cci = EventCardInventory.getInventory(item[1]);
                        EventCardDeck.binderToDeck(cci, index, charaPos);
                        dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_EVENT, cci, index));
                        break;
                    case Shop.KIND_WEAPON_CARD:
                        var wci:WeaponCardInventory;
                        wci = WeaponCardInventory.getInventory(item[1]);
                        WeaponCardDeck.binderToDeck(wci, index, charaPos);
                        dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_WEAPON, wci, index));
                        break;
                    case Shop.KIND_CHARA_CARD:
                        charaPos +=1;
                        var ci:CharaCardInventory;
                        ci = CharaCardInventory.getInventory(item[1]);
                        log.writeLog(log.LV_INFO, this, "cchara carcd inve !!", ci);
                        CharaCardDeck.binderToDeck(index, ci);
                        dispatchEvent(new EditCardEvent(EditCardEvent.BINDER_TO_DECK_CHARA, ci, index));
                        // イベントカードのスロット更新する
                        EventCardDeck.decks[index].checkAllSlot();
                        break;
                    default:
                        break;
                    }
                }
                )
                dispatchEvent(new EditDeckEvent(EditDeckEvent.CREATE_DECK_SUCCESS));
        }

        // デッキを削除するのに成功
        public function deleteDeckSuccess(index:int):void
        {
            // デッキを消去
            CharaCardDeck.deleteDeck(index);
            // インデックス更新
            selectIndex = 1;
            changeCurrentDeck(selectIndex);
            dispatchEvent(new EditDeckEvent(EditDeckEvent.DELETE_DECK_SUCCESS, index));
        }

        // カレントデッキを変更する
        public function changeCurrentDeck(index:int):void
        {
            log.writeLog(log.LV_INFO, this, "change!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", index);
            _player.avatar.currentDeck = index;
            dispatchEvent(new EditDeckEvent(EditDeckEvent.CHANGE_CURRENT_DECK, index));
        }

        // デッキのindex0のキャラナンバーを取り出す
        public function getDeckCharaNo(index:int):int
        {
            var ret:int = 0;
            if(CharaCardDeck.decks[index]!=null)
            {
                if (CharaCardDeck.decks[index].positionCard(0)!=null)
                {
                    var cc:CharaCard = CharaCardDeck.decks[index].positionCard(0).charaCard;
                    if (cc.kind == Const.CC_KIND_EPISODE)
                    {
                        ret = cc.parentID;
                    }
                    else
                    {
                        ret = cc.charactor;
                    }
                }
            }
            return ret;
        }

        // データの再読み込み
        public function update():void
        {
            dispatchEvent(new Event(UPDATE));
        }

        // 待機中
        public function waiting():void
        {
            _state = WAITING;
            dispatchEvent(new Event(WAITING));
        }

        // 編集の終了
        public function finalize():void
        {
            save();
            _state = END;
            dispatchEvent(new Event(END));
        }

        // 現在のデッキのキャラカード枚数
        public function getCharaNum(index:int):int
        {
            return CharaCardDeck.decks[index].cardInventories.length;
        }
    }
}