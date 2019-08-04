
package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import controller.LobbyCtrl;

    // インベントリつきの装備カードクラス
    public class EquipCardInventory implements ICardInventory
    {
        private var _inventoryID:int;        // 固有のインベントリID

        private var _equipCard:EquipCard;    // キャラカード
        private var _index:int;                // デッキ番号
        private var _deckPosition:int;         // デッキ内位置
        private var _cardPosition:int;         // カード内位置

        private var _dirtyFlag:int;      // 書き変えフラグ
        private static var __cards:Array = [];   // Array of EquipCardInventory

        private static var _ctrl:LobbyCtrl = LobbyCtrl.instance;  // ロビーのコントローラー

        public static function initializeInventory():void
        {
            __cards = []
        }

        public static function get cards():Array
        {
            return __cards;
        }


        // EquipCardIDでソート
        public static function sortEquipCardId():void
        {
            __cards.sortOn("cardId", Array.NUMERIC);
        }

        // ポジションをソート
        public static function sortDeckPosition():void
        {
            __cards.sortOn("deckPosition", Array.NUMERIC);
        }

        // ポジションをソート
        public static function sortCardPosition():void
        {
            __cards.sortOn("cardPosition", Array.NUMERIC);
        }

        // セーブフラグをソート
        public static function sortDirtyFlag():void
        {
            __cards.sortOn("dirtyFlag", Array.NUMERIC);
        }

        // カードを追加
        public static function addEquipCardInventory(inv_id:int, ec:EquipCard):void
        {
            new EquipCardInventory(inv_id, ec, 0, 0, 0);
            _ctrl.getEquipCardSuccess(ec.id);
        }

        // カードを削除
        public static function deleteEquipCardInventory(inv_id:int):void
        {
            for(var i:int; i < __cards.length; i++)
            {
                if(__cards[i].inventoryID == inv_id)
                {
                    __cards[i].equipCard.num -=1;
                    __cards.splice(i, 1);
                    i--;
                }
            }
        }


        // カードを取得
        public static function getInventory(inv_id:int):EquipCardInventory
        {
            var cci:EquipCardInventory
            for(var i:int; i < __cards.length; i++)
            {
                if(__cards[i].inventoryID == inv_id)
                {
                    cci = __cards[i];
                    break;
                }
            }
            return __cards[i];
        }


        // コンストラクタ
        public function EquipCardInventory(inv_id:int, wc:EquipCard, index:int, deckPosition:int, cardPosition:int)
        {
            _inventoryID = inv_id;
            _equipCard = wc;
            _index = index;
            _deckPosition = deckPosition;
            _cardPosition = cardPosition;
            _dirtyFlag = 0;
            incrementCard();
        }

        private function incrementCard():void
        {
            __cards.push(this);
            _equipCard.num +=1;
        }

        // セーブ
        public function save():Boolean
        {
            if (_dirtyFlag > 0)
            {
                _dirtyFlag = 0;
                return true;
            }
            else
            {
                return false;
            }
        }

        // インベントリIDを取得
        public function get inventoryID():int
        {
            return _inventoryID;
        }

        // キャラカードを取得
        public function get card():ICard
        {
            return _equipCard;
        }

        // キャラカードIDを取得
        public function get cardId():int
        {
            return _equipCard.id;
        }

        // デッキ番号を取得
        public function get index():int
        {
            return _index;
        }

        // デッキ内位置を取得
        public function get position():int
        {
            return _deckPosition;
        }

        // カードデッキ内位置を取得
        public function get cardPosition():int
        {
            return _cardPosition;
        }

        // 書き換えフラグを取得
        public function get dirtyFlag():int
        {
            return _dirtyFlag;
        }

        // デッキ番号を設定
        public function set index(index:int):void
        {
            _index = index;
            setDirtyFlag();
//            _dirtyFlag = true;
        }
        // デッキ内位置を設定
        public function set position(deckPosition:int):void
        {
            _deckPosition = deckPosition;
            // 0はバインダー
            if(_index != 0)
            {
                setDirtyFlag();
//                _dirtyFlag = true;
            }
        }
        // カード内位置を設定
        public function set cardPosition(cardPosition:int):void
        {
            _cardPosition = cardPosition;
            setDirtyFlag();

//            _dirtyFlag = true;
        }
        // フラグをセットする
        private function setDirtyFlag():void
        {
            var flag:int = 0
            for(var i:int = 0; i < __cards.length; i++)
            {
                flag < __cards[i].dirtyFlag ? flag = __cards[i].dirtyFlag : flag = flag;
            }
            _dirtyFlag = flag+1
        }


    }
}