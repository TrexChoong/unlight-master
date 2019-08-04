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
    public class EquipCardDeck implements IDeck
    {
        // エディットインスタンス
        private var _deckEdit:DeckEditor = DeckEditor.instance;

        public static const UPDATE:String = 'update';  // 情報がアップデート
        private var _name:String;                      // デッキ名
        private var _cardInventories:Array = [];       // インベントリ付きカード

        private static var __decks:Array = [];            // Array of EquipCardDeck

        public static function initializeDeck():void
        {
            __decks = [];
        }

        public static function get decks():Array
        {
            return __decks;
        }

        // デッキのカードインベントリを初期化
        public static function initEquipCardInventory(cci:EquipCardInventory):void
        {
            decks[cci.index].cardInventories.push(cci);
        }

        // バインダーからデッキにカードインベントリを移す
        public static function binderToDeck(cci:EquipCardInventory, index:int):void
        {
            binder.removeEquipCardInventory(cci);
            decks[index].addEquipCardInventory(cci);
        }

        // デッキからバインダーにカードインベントリを移す
        public static function deckToBinder(cci:EquipCardInventory):void
        {
            decks[cci.index].removeEquipCardInventory(cci);
            binder.addEquipCardInventory(cci);
        }

        // デッキを削除する
        public static function deleteDeck(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = decks[index].cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderEquipCard(decks[index].cardInventories[0]);
            }
            // デッキを削除
            decks.splice(index, 1);
            // 後ろにあるデッキのカードインベントリを修正する
            for(i = index; i < decks.length; i++)
            {
                decks[i].cardInventories.forEach(function(cci:EquipCardInventory, index:int, array:Array):void{cci.index = i});
            }
        }

        // デッキを削除する
        public static function allCardDeckToBinder(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = decks[index].cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderEquipCard(decks[index].cardInventories[0]);
            }
        }

        // カードインベントリ一覧のゲッター
        public static function get binder():EquipCardDeck
        {
            return decks[0];
        }

        // コンストラクタ
        public function EquipCardDeck(name:String)
        {
            _name = name;
            decks.push(this);
        }

        // デッキにカードインベントリを追加
        public function addEquipCardInventory(cci:EquipCardInventory):void
        {
            cci.cardPosition = 0;
            cci.position = _cardInventories.length;
            cci.index = EquipCardDeck.decks.indexOf(this);
            _cardInventories.push(cci);
        }

        // バインダーのカードインベントリを削除
        public function removeEquipCardInventoryId(invId:int):void
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
        public function removeEquipCardInventory(cci:EquipCardInventory):void
        {
            var position:int = _cardInventories.indexOf(cci);
            if(position != -1)
            {
                _cardInventories.splice(position, 1);
                // カードが抜けたポイントからのポジションを修正
                for(var i:int = position; i < _cardInventories.length; i++)
                {
                    _cardInventories[i].position = i;
                }
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

        // カードインベントリにあるカードの枚数
        public function sortEquipCardId(id:int):int
        {
            var count:int = 0;
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{if(item.equipCard.id == id){count++}});
            return count;
        }

        // 指定した位置に存在するカードのゲッター
        public function positionCard(position:int):EquipCardInventory
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
    }
}