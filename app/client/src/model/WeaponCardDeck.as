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
    public class WeaponCardDeck extends EventDispatcher implements IDeck
    {
        // エディットインスタンス
        private var _deckEdit:DeckEditor = DeckEditor.instance;

        public static const UPDATE_POS:String = "update_pos";

        public static const UPDATE:String = 'update';  // 情報がアップデート
        private var _name:String;                      // デッキ名
        private var _cardInventories:Array = [];       // インベントリ付きカード

        private static var __decks:Array = [];            // Array of WeaponCardDeck

        public static function initializeDeck():void
        {
            __decks = [];
        }

        public static function get decks():Array
        {
            return __decks;
        }

        // デッキのカードインベントリを初期化
        public static function initWeaponCardInventory(cci:WeaponCardInventory):void
        {
            decks[cci.index].cardInventories.push(cci);
        }

        // バインダーからデッキにカードインベントリを移す
        public static function binderToDeck(cci:WeaponCardInventory, index:int, charPos:int):void
        {
            binder.removeWeaponCardInventory(cci);
            decks[index].addWeaponCardInventory(cci,charPos);
        }

        // デッキからバインダーにカードインベントリを移す
        public static function deckToBinder(cci:WeaponCardInventory):void
        {
            decks[cci.index].removeWeaponCardInventory(cci);
            binder.addWeaponCardInventory(cci);
        }

        // デッキを削除する
        public static function deleteDeck(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = decks[index].cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderWeaponCard(decks[index].cardInventories[0]);
            }
            // デッキを削除
            decks.splice(index, 1);
            // 後ろにあるデッキのカードインベントリを修正する
            for(i = index; i < decks.length; i++)
            {
                decks[i].cardInventories.forEach(function(cci:WeaponCardInventory, index:int, array:Array):void{cci.index = i});
            }
        }

        // デッキを削除する
        public static function allCardDeckToBinder(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = decks[index].cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderWeaponCard(decks[index].cardInventories[0]);
            }
        }

        // カードインベントリ一覧のゲッター
        public static function get binder():WeaponCardDeck
        {
            return decks[0];
        }

        // コンストラクタ
        public function WeaponCardDeck(name:String)
        {
            _name = name;
            decks.push(this);
        }

        // デッキにカードインベントリを追加
        public function addWeaponCardInventory(cci:WeaponCardInventory,charPos:int=0):void
        {
            log.writeLog(log.LV_DEBUG, this, "addWeaponCardInventory",cci,charPos);
            log.writeLog(log.LV_DEBUG, this, "addWeaponCardInventory 1",getPositionCard(charPos).length);
            cci.cardPosition = getPositionCard(charPos).length;
            cci.position = charPos;
            cci.index = WeaponCardDeck.decks.indexOf(this);
            _cardInventories.push(cci);
        }

        // バインダーのカードインベントリを削除
        public function removeWeaponCardInventoryId(invId:int):void
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
        public function removeWeaponCardInventory(cci:WeaponCardInventory):void
        {
            var position:int = _cardInventories.indexOf(cci);
            if(position != -1)
            {
                _cardInventories.splice(position, 1);
            }
            else
            {
                log.writeLog(log.LV_FATAL, this, "undefined position card");
            }
         }

        // デッキからカードを消去
        public function removePositionInventory(position:int):void
        {
            if(position < _cardInventories.length)
            {
                // Binderのデッキ番号(0)を代入
                _cardInventories[position].index = 0;

                // デッキからインベントリを消去
                _cardInventories.splice(position, 1);

                // カードが抜けたポイントからのポジションを修正
                for(var i:int = position; i < _cardInventories.length; i++)
                {
                    _cardInventories[i].position = i;
                }
            }
        }

        // デッキ名のゲッター
        public function get name():String
        {
            return _name;
        }

        // デッキ名のセッター
        public function set name(n:String):void
        {
            _name = n;
        }

        // カードインベントリ一覧のゲッター
        public function get cardInventories():Array
        {
            return _cardInventories;
        }

        // ポジションのカードを配列で返す
        public function getPositionCard(pos:int):Array
        {
            var ret:Array = [];
            var len:int = _cardInventories.length;
            for(var i:int = 0; i < len; i++){
                if (_cardInventories[i].position == pos)
                {ret.push(_cardInventories[i])}
            }
            return ret;
        }

        // 同じcardIDのインベントリを取得
        public function getCardList(cardId:int):Array
        {
            var ret:Array = [];
            var len:int = _cardInventories.length;
            for(var i:int; i < len; i++)
            {
                if(_cardInventories[i].cardId == cardId)
                {
                    ret.push(_cardInventories[i]);
                }
            }
            return ret;
        }

        // カードインベントリにあるカードの枚数
        public function sortWeaponCardId(id:int):int
        {
            var count:int = 0;
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{if(item.card.id == id){count++}});
            return count;
        }

        // キャラカードが取り除かれたとき後ろのインベントリをずらす
        public static function removeCharaCard(index:int, pos:int):void
        {
            // デッキから無くなったキャラカード位置のインベントリを取り出す
            var a:Array = decks[index].getPositionCard(pos);
            // 当該ポジションのカードを取り除く
             for(var i:int = 0; i < a.length; i++){
                 DeckEditor.instance.deckToBinderWeaponCard(a[i]);
             }
             // 当該ポジション以降のカードを一つつめる
             for(var j:int = pos+1; j < 3; j++){
                 a = decks[index].getPositionCard(j);
                 a.forEach(function(item:WeaponCardInventory, index:int, array:Array):void{
                         item.position = item.position-1;
                         log.writeLog(log.LV_FATAL,  "remove card pos",item.cardPosition,item.position);
                         DeckEditor.instance.deckToDeckWeaponCard(item,index,false); // セーブしないで変更（後で順番にセーブされることを期待している）
                             });
             }


        }

        public static function updateWeaponPos(index:int):void
        {
            __decks[index].dispatchEvent(new Event(UPDATE_POS));
        }


        // 総コストのゲッター
        public function get cost():int
        {
            var calc:int = 0
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{calc += item.card.cost});
            return calc;
        }

    }
}