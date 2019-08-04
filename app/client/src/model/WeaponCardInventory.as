package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import controller.LobbyCtrl;
    
    // インベントリつきの武器カードクラス
    public class WeaponCardInventory implements ICardInventory
    {
        private var _inventoryID:int;        // 固有のインベントリID

        private var _weaponCard:WeaponCard;    // キャラカード
        private var _index:int;                // デッキ番号
        private var _deckPosition:int;         // デッキ内位置
        private var _cardPosition:int;         // カード内位置

        private var _prevWeaponCard:WeaponCard;    // 変更前カード

        private var _dirtyFlag:int;      // 書き変えフラグ
        private static var __cards:Array = [];   // Array of WeaponCardInventory

        private static var _ctrl:LobbyCtrl = LobbyCtrl.instance;  // ロビーのコントローラー

        public static function initializeInventory():void
        {
            __cards = []
        }

        public static function get cards():Array
        {
            return __cards;
        }


        // WeaponCardIDでソート
        public static function sortWeaponCardId():void
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
        public static function addWeaponCardInventory(inv_id:int, ec:WeaponCard):void
        {
            new WeaponCardInventory(inv_id, ec, 0, 0, 0);
            _ctrl.getWeaponCardSuccess(ec.id);
        }

        // カードを削除
        public static function deleteWeaponCardInventory(inv_id:int):void
        {
            for(var i:int; i < __cards.length; i++)
            {
                if(__cards[i].inventoryID == inv_id)
                {
                    __cards[i].card.num -=1;
                    __cards.splice(i, 1);
                    i--;
                }
            }
        }

        // カードを取得
        public static function getInventory(inv_id:int):WeaponCardInventory
        {
            var cci:WeaponCardInventory;
            for(var i:int; i < __cards.length; i++)
            {
                if(__cards[i].inventoryID == inv_id)
                {
                    cci = __cards[i];
                    break;
                }
            }
            return cci;
        }

        // コンストラクタ
        public function WeaponCardInventory(inv_id:int, wc:WeaponCard, index:int, deckPosition:int, cardPosition:int)
        {
            _inventoryID = inv_id;
            _weaponCard = wc;
            _index = index;
            _deckPosition = deckPosition;
            _cardPosition = cardPosition;
            _dirtyFlag = 0;
            incrementCard();
        }

        private function incrementCard():void
        {
            __cards.push(this);
            _weaponCard.num +=1;
        }

        // セーブ
        public function save():Boolean
        {
            if (_dirtyFlag >0)
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
            return _weaponCard;
        }
        public function set card(wc:ICard):void
        {
            _weaponCard = WeaponCard(wc);
        }
        // 変更前カードを取得
        public function get prevCard():ICard
        {
            return _prevWeaponCard;
        }
        public function set prevCard(wc:ICard):void
        {
            _prevWeaponCard = WeaponCard(wc);
        }

        // キャラカードIDを取得
        public function get cardId():int
        {
            return _weaponCard.id;
        }
        // 合成使用時のカードIDを取得
        public function get useCombineCardId():int
        {
            var ret:int = _weaponCard.id;
            if (ret >= Const.COMBINE_WEAPON_START_ID) {
                ret = _weaponCard.baseCardId;
            }
            return ret;
        }
        public function get combined():Boolean
        {
            return _weaponCard.combined;
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
            if (_index != index)
            {
                setDirtyFlag();
//                _dirtyFlag = true;
                _index = index;
            }
        }
        // デッキ内位置を設定
        public function set position(deckPosition:int):void
        {

            if (_deckPosition != deckPosition)
            {
                _deckPosition = deckPosition;
                // 0はバインダー
                if(_index != 0)
                {
                    setDirtyFlag();
//                    _dirtyFlag = true;
                }
            }
        }
        // カード内位置を設定
        public function set cardPosition(cardPosition:int):void
        {
            if (_cardPosition != cardPosition)
            {
                _cardPosition = cardPosition;
                setDirtyFlag();
//                _dirtyFlag = true;
            }
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