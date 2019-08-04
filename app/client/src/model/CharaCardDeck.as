package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    import model.*;
    import net.*;

    /**
     * デッキクラス
     *
     *
     */
    public class CharaCardDeck extends EventDispatcher implements IDeck
    {
        public static const UPDATE_POS:String = "update_pos";

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT_MSG1	:String = "同じキャラクターは入れることが出来ません";
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT_MSG2	:String = "このカードはデッキに入れることが出来ません";
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT_MSG3	:String = "モンスターをデッキの先頭には入れられません";
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT_MSG4	:String = "渦戦闘に参加している為、変更できません";

        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT	:String = "Warning";
        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT_MSG1	:String = "You can't add the same character.";
        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT_MSG2	:String = "Cannot put this card in your deck.";
        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT_MSG3	:String = "The first card of your deck cannot be a monster card.";
        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT_MSG4	:String = "Could not change because you are participating in vortex battle.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT_MSG1	:String = "無法放入相同的角色";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT_MSG2	:String = "此卡片無法放入牌組";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT_MSG3	:String = "怪物卡不能放在牌組第一張";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT_MSG4	:String = "由於正在參與渦的戰鬥所以無法變更";

        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT_MSG1	:String = "无法放入一样的角色";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT_MSG2	:String = "这个卡片不能放入卡组中";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT_MSG3	:String = "怪物卡不能放在卡组的第一张";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT_MSG4	:String = "由于正在参加漩涡战斗，因此无法变更";

        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT	:String = "경고";
        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT_MSG1	:String = "같은 캐릭터는 들어갈 수 없습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT_MSG2	:String = "이 카드는 덱에 추가할 수 없습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT_MSG3	:String = "몬스터를 덱의 선두에 넣을 수 없습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT_MSG4	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT	:String = "Attention";
        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT_MSG1	:String = "Vous ne pouvez pas ajouter deux personnages identiques.";
        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT_MSG2	:String = "Impossible de mettre cette carte dans cette pioche.";
        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT_MSG3	:String = "Vous ne pouvez pas mettre une carte Monstre sur le dessus de votre pioche.";
        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT_MSG4	:String = "Vous ne pouvez pas changer car vous participez actuellement à une bataille de Vortex.";

        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT_MSG1	:String = "同じキャラクターは入れることが出来ません";
        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT_MSG2	:String = "このカードはデッキに入れることが出来ません";
        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT_MSG3	:String = "モンスターをデッキの先頭には入れられません";
        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT_MSG4	:String = "渦戦闘に参加している為、変更できません";

        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT   :String = "คำเตือน";
        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT_MSG1  :String = "ไม่สามารถใส่ตัวละครซ้ำกันได้";
        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT_MSG2  :String = "ไม่สามารถใส่การ์ดใบนี้ลงในสำรับได้";
        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT_MSG3  :String = "ไม่สามารถใช้มอนสเตอร์เป็นไพ่ใบหลักได้";
        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT_MSG4  :String = "เพราะว่ากำลังเข้าร่วมต่อสู้กับน้ำวน ไม่สามารถเปลี่ยนได้"; // 渦戦闘に参加している為、変更できません

        // エディットインスタンス
        private var _deckEdit:DeckEditor = DeckEditor.instance;

        public static const UPDATE:String = 'update';  // 情報がアップデート
        private var _name:String;                      // デッキ名
        private var _kind:int;                      // デッキ名
        private var _status:int;                      // 現在のステータス
        private var _level:int;                         // レベル
        private var _exp:int;                          // 経験値
        private var _cost:int;                      // 現在のコスト
        private var _maxCost:int;                      // 最大コスト
        private var _cardInventories:Array = [];       // インベントリ付きカード
        private var _damages:Array = [0,0,0];
        private var _baseCosts:Array = [];             // 現在のデッキの基礎コスト
        private var _charactors:Array = [];            // 現在のデッキのキャラクタ
        private var _parents:Array = [];               // 現在のデッキの親
        private var _cautionLv:Array = [0,0,0];             // 現在のデッキの警告レベル

        private var _isBinder:Boolean = false; // Binderかどうかの判定

        private static var __decks:Array = [];            // Array of CharaCardDeck

        public static function initializeDeck():void
        {
            __decks = [];
        }

        public static function get decks():Array
        {
            return __decks;
        }

        // デッキのカードインベントリを初期化
        public static function initCharaCardInventory(cci:CharaCardInventory):void
        {
            decks[cci.index].cardInventories.push(cci);
        }

        // インベントリの更新
        public static function binderToDeck(index:int, cci:CharaCardInventory):void
        {
            var position:int = binder.cardInventories.indexOf(cci);
            // バインダーにあるのなら更新
            if (position!=-1)
            {
                binder.removeCharaCardInventory(cci);
                decks[index].addCharaCardInventory(cci);
            }
        }

         // デッキからバインダーにカードインベントリを移す
         public static function deckToBinder(cci:CharaCardInventory):void
         {
             decks[cci.index].removeCharaCardInventory(cci);
             binder.addCharaCardInventory(cci);
         }

        // デッキを削除する
        public static function deleteDeck(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = decks[index].cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderCharaCard(decks[index].cardInventories[0]);
            }
            // デッキを削除
            decks.splice(index, 1);
            // 後ろにあるデッキのカードインベントリを修正する
            for(i = index; i < decks.length; i++)
            {
                decks[i].cardInventories.forEach(function(cci:CharaCardInventory, index:int, array:Array):void{cci.index = i});
            }
        }

        // デッキを削除する
        public static function allCardDeckToBinder(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = decks[index].cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderCharaCard(decks[index].cardInventories[0]);
            }
        }

        // カードインベントリ一覧のゲッター
        public static function get binder():CharaCardDeck
        {
            return decks[0];
        }

        // コンストラクタ
        public function CharaCardDeck(name:String, kind:int = 0, level:int = 0, exp:int = 0 , status:int = 0, cost:int=0, maxCost:int =0)
        {
            _name = name;
            _kind = kind;
            _level = level;
            _exp = exp;
            _status = status;
            _cost = cost;
            _maxCost = maxCost;
            if (decks.length == 0) {
                _isBinder = true;
            }
            decks.push(this);
        }

        // デッキにカードインベントリを追加
        public function addCharaCardInventory(cci:CharaCardInventory):void
        {
            if (isBinder) {
                cci.position = -1;
            } else {
                cci.position = _cardInventories.length;
            }
             cci.index = CharaCardDeck.decks.indexOf(this);
            _cardInventories.push(cci);
        }

        // バインダーのカードインベントリを削除
        public function removeCharaCardInventoryId(invId:int):void
        {
            for(var i:int = 0; i < _cardInventories.length; i++)
            {
               if(_cardInventories[i].inventoryID == invId)
               {
                   _cardInventories.splice(i, 1);
                   i--;
               }
            }
        }

        // デッキからカードを消去
        private function removeCharaCardInventory(cci:CharaCardInventory):void
        {
//             log.writeLog(log.LV_FATAL, this, "remove card cci", cci);
//             log.writeLog(log.LV_FATAL, this, "remove cards ", _cardInventories);
//             log.writeLog(log.LV_FATAL, this, "remove card ,len", _cardInventories.length);

            var position:int = _cardInventories.indexOf(cci);

            if(position != -1)
            {
                _cardInventories.splice(position, 1);
                    // バインダーじゃ無ければ全部ずらす
                    if (this != CharaCardDeck.binder)
                    {
                        // 暗黙のずらし
                        // カードが抜けたポイントからのポジションを修正
                        for(var i:int = position; i < _cardInventories.length; i++)
                        {
                            _cardInventories[i].position = i;
                        }
                        // 付随するイベントカードも取り除く＆ずらす
                        EventCardDeck.removeCharaCard(cci.index, cci.position,_cardInventories.length);
                        // 付随する武器カードも取り除く＆ずらす
                        WeaponCardDeck.removeCharaCard(cci.index, cci.position);
//                        log. writeLog(log.LV_FATAL, this, "remove card ,len", _cardInventories.length);
                    }

            }
            else
            {
                log.writeLog(log.LV_FATAL, this, "undefined position card");
            }
         }

        // デッキ内に指定のキャラカードと同じキャラがあるかチェック(入っていたらfalseを返す)
        public function checkCharaCardDobble(cc:CharaCard):Boolean
        {
            var ret:Boolean = true;
            // インベントリの中身をすべてみて
            for(var i:int = 0; i < _cardInventories.length; i++)
            {
                // キャラクター番号が同じモノがあればtrueをいれてBreak
                if(_cardInventories[i].charaCard.isSamePerson(cc))
                {
//                    Alerter.showWithSize("同じキャラクターは入れることが出来ません","警告");
                    Alerter.showWithSize(_TRANS_ALERT_MSG1,_TRANS_ALERT);
                    ret = false;
                    break;
                }
            }
            // キャラクター、通常モンスターカードならBreak
            switch (cc.kind)
            {
            case Const.CC_KIND_CHARA:
            case Const.CC_KIND_MONSTAR:
            case Const.CC_KIND_REBORN_CHARA:
            case Const.CC_KIND_RARE_MONSTAR:
            case Const.CC_KIND_RENTAL:
            case Const.CC_KIND_EPISODE:
                break;
            default:
                Alerter.showWithSize(_TRANS_ALERT_MSG2,_TRANS_ALERT); // "このカードはデッキに入れることが出来ません"
                ret = false;
            }

            return ret;
        }

        public function get length():int
        {
//            log.writeLog(log.LV_FATAL, this, "++++ ",_cardInventories);
            return  _cardInventories.length;
        };

        // デッキの枚数が0枚で最初のカードがモンスターでない
        public function checkMostarCard(cc:CharaCard):Boolean
        {
            var ret:Boolean = true;
            if (_cardInventories.length == 0&& (cc.kind == Const.CC_KIND_MONSTAR || cc.kind == Const.CC_KIND_RARE_MONSTAR))
            {
//                Alerter.showWithSize("モンスターをデッキの先頭には入れられません","警告");
                Alerter.showWithSize(_TRANS_ALERT_MSG3,_TRANS_ALERT);
                ret = false;
            }
            return ret;
        }

        // デッキで最後のキャラカード？
        public function checkNotLastPlayerCharaCard(cc:CharaCard):Boolean
        {
            var ret:Boolean =false;
            var charaPos:int = 10;
            var monPos:int =10;
            // インベントリの中身をすべてみて
            for(var i:int = 0; i < _cardInventories.length; i++)
            {
                switch (_cardInventories[i].charaCard.kind)
                {
                case Const.CC_KIND_CHARA:
                case Const.CC_KIND_REBORN_CHARA:
                case Const.CC_KIND_RENTAL:
                case Const.CC_KIND_EPISODE:
                    // 自分でない人間がいたら
                    if (_cardInventories[i].charaCard.id != cc.id) {
                        charaPos = _cardInventories[i].position;
                    }
                    break;
                default:
                    // 自分でないモンスターがいたら
                    if (_cardInventories[i].charaCard.id != cc.id) {
                        monPos = _cardInventories[i].position;
                    }
                }
            }
            // キャラの方が前ならば
            return charaPos < monPos;
        }

        // 渦戦闘で使用中か判定
        public function checkUseRaidDuel():Boolean
        {
            var ret:Boolean = true;
            if (_status == Const.CDT_RAID) {
                Alerter.showWithSize(_TRANS_ALERT_MSG4,_TRANS_ALERT);
                ret = false;
            }
            return ret;
        }


        // デッキ名のゲッター
        public function get name():String
        {
            return _name;
        }

        // デッキ種類のゲッター
        public function get kind():int
        {
            return _kind;
        }

        // レベルのゲッター
        public function get level():int
        {
            return _level;
        }

        // 経験値のゲッター
        public function get exp():int
        {
            return _exp;
        }

        // デッキ名のセッター
        public function set name(n:String):void
        {
            _name = n;
        }

        public function set level(l:int):void
        {
            _level = l;
        }

        public function set exp(e:int):void
        {
            _exp = e;
        }

        public function set maxCost(c:int):void
        {
            _maxCost = c;
        }


        // カードインベントリ一覧のゲッター
        public function get cardInventories():Array
        {
            return _cardInventories;
        }

        public function sortDeck():void
        {
            _cardInventories.sortOn("position", [Array.NUMERIC]);
        }

        // カードインベントリにあるカードの枚数
        public function sortCharaCardId(id:int):int
        {
            var count:int = 0;
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{if(item.charaCard.id == id){count++}});
            return count;
        }

        // 指定した位置に存在するカードのゲッター
        public function positionCard(position:int):CharaCardInventory
        {
            if(position < _cardInventories.length)
            {
                return _cardInventories[position];
            }
            else
            {
                log.writeLog(log.LV_FATAL, this, "undefined position card");
                return null;
            }
        }

        // デッキデータのアップデート
        public function deckStateUpdate(state:int, hp0:int, hp1:int, hp2:int):void
        {
            _status = state;
            if (state == Const.CDT_DUEL) {
                _damages = [0,0,0];
            } else {
                _damages = [hp0, hp1, hp2];
            }
            dispatchEvent(new Event(UPDATE));
        }

        public static function updateCharaPos(index:int):void
        {
            __decks[index].dispatchEvent(new Event(UPDATE_POS));
        }

        // 総コストのゲッター
        public function get cost():Object
        {
            var costSet:Object = new Object();
            if (_cardInventories.length == 1)
            {
                costSet["total"] = _cardInventories[0].charaCard.cost;
                costSet["correction"] = [0];
                costSet["base"] = [_cardInventories[0].charaCard.cost];
                costSet["middle"] = [_cardInventories[0].charaCard.cost];
                costSet["charactors"] = [_cardInventories[0].charaCard.charactor];
                costSet["parents"] = [_cardInventories[0].charaCard.parentID];
                _parents = costSet["parents"];
                _charactors = [_cardInventories[0].charaCard.charactor];
                _baseCosts = [_cardInventories[0].charaCard.cost];
                _cautionLv = [0];
                return costSet;
            }

            var DECK_INDEX:Array = [0, 1, 2];
            var total:int = 0;
            var corrections:Array = [];
            var middle_cost:Array = [];
            var charactors:Array = [];
            var parents:Array = [];
            var tmp_costs:Array = [];
            var caution_lv:Array = [];
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{
                    tmp_costs.push(item.charaCard.cost);
                    charactors.push(item.charaCard.charactor);
                    parents.push(item.charaCard.parentID);
                });

            var tmp_costs_max:int = Math.max.apply(null, tmp_costs);

            for (var i:int = 0; i < tmp_costs.length; i++)
            {
                var rem:int = int((tmp_costs_max - tmp_costs[i]) / Const.CORRECTION_CRITERIA);
                var c:int = 0;
                var clv:int = 0;
                if (rem == 1) {
                    clv = 1;
                    c = rem * Const.CORRECTION_VALUE;
                }
                else if (rem > 1) {
                    clv = 2;
                    c = 2 * Const.CORRECTION_VALUE;
                }
                caution_lv.push(clv);
                corrections.push(c);
                var mc:int = tmp_costs[i] + c;
                total += mc;
                middle_cost.push(mc);
            }

            costSet["total"] = total;
            costSet["base"] = tmp_costs;
            costSet["middle"] = middle_cost;
            costSet["correction"] = corrections;
            costSet["charactors"] = charactors;
            costSet["parents"] = parents;
            _charactors = charactors;
            _parents = parents;
            _baseCosts = tmp_costs;
            _cautionLv = caution_lv;
            return costSet;
        }

        // 総コストのゲッター
        public function get maxCost():int
        {
            return _maxCost;
        }

        // 現在ダメージのゲッタ
        public function get damages():Array
        {
            return _damages;
        }

        // キャラクターIDのゲッター
        public function get charactors():Array
        {
            return _charactors;
        }

        // キャラクター親IDのゲッター
        public function get parents():Array
        {
            return _parents;
        }

        // 基礎コストのゲッター
        public function get baseCost():Array
        {
            return _baseCosts;
        }

        // 警告レベルのゲッター
        public function get cautionLv():Array
        {
            return _cautionLv;
        }

        public function get isBinder():Boolean
        {
            return _isBinder;
        }
    }
}