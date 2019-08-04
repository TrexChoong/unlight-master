
package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import controller.LobbyCtrl;
    import model.DeckEditor;

    // インベントリつきのキャラカードクラス
    public class CharaCardInventory implements ICardInventory
    {
        public static const CHARA:int   = 0;
        public static const MONSTER:int = 1;
        public static const OTHER:int   = 2;

        private var _inventoryID:int;        // 固有のインベントリID

        private var _charaCard:CharaCard;    // キャラカード
        private var _index:int;              // デッキ番号
        private var _position:int;           // デッキ内位置
        private var _type:int;               // カードの種類

        private var _dirtyFlag:int;      // 書き変えフラグ
        private static var __cards:Array = [];   // Array of CharaCardInventory

        private static var _ctrl:LobbyCtrl = LobbyCtrl.instance;  // ロビーのコントローラー
        private static var _deckEditor:DeckEditor = DeckEditor.instance;

        private static const _REBORN_CHARA_START_ID:int = 4000;
        private static const _ORAN_CHARA_ID1:int = 55;
        private static const _ORAN_CHARA_ID2:int = 56;

        public static function initializeInventory():void
        {
            __cards = [];
        }

        public static function get cards():Array
        {
            return __cards;
        }

        public static function getTypeCards(t:int=CHARA):Array
        {
            // var cards:Array = [];
            // for ( var i:int = 0; i < __cards.length; i++ ) {
            //     if ( __cards[i].type == t ) {
            //         cards.push(__cards[i]);
            //     }
            // }

            var cards:Array = [];
            for ( var i:int = 0; i < __cards.length; i++ ) {
                if ( (__cards[i].type == t && _deckEditor.selectChara == 0) || (__cards[i].type == t && t != CHARA) ) {
                    cards.push(__cards[i]);
                } else if ( __cards[i].type == t && (__cards[i].charaCard.charactor == _deckEditor.selectChara || __cards[i].charaCard.parentID == _deckEditor.selectChara || __cards[i].charaCard.charactor == (_deckEditor.selectChara + _REBORN_CHARA_START_ID)) ) {
                    if (_deckEditor.selectChara == _ORAN_CHARA_ID1 && __cards[i].charaCard.charactor == _ORAN_CHARA_ID2)
                    {
                    }
                    else
                    {
                        cards.push(__cards[i]);
                    }
                }
            }

            return cards;
        }


        // CharaCardIDでソート
        public static function sortCharaCardId():void
        {
            __cards.sortOn("cardId", Array.NUMERIC);
        }

        // ポジションをソート
        public static function sortPosition():void
        {
            __cards.sortOn("position", Array.NUMERIC);
        }

        // セーブフラグをソート
        public static function sortDirtyFlag():void
        {
            __cards.sortOn("dirtyFlag", Array.NUMERIC);
        }

        // セーブフラグが立ってるカードをデッキ番号でソートして返す
        public static function getDirtyFlagCardList():Array
        {
            var ret:Array = [];
            for (var i:int = 0; i < __cards.length; i++) {
                if (__cards[i].save()) {
                    ret.push(__cards[i]);
                }
            }
            ret.sortOn("index",Array.NUMERIC);
            for (var j:int = 0; j < ret.length; j++) {
                log.writeLog(log.LV_INFO, "CharaCardInventory","getDirtyFlagCardList", ret[j].inventoryID, ret[j].index);
            }
            return ret;
        }

        // カードを追加
        public static function addCharaCardInventory(inv_id:int, cc:CharaCard):void
        {
            new CharaCardInventory(inv_id, cc, 0, 0);
            _ctrl.getCharaCardSuccess(cc.id);
        }


        // カードを削除
        public static function deleteCharaCardInventory(inv_id:int):void
        {
            for(var i:int; i < __cards.length; i++)
            {
                if(__cards[i].inventoryID == inv_id)
                {
                    __cards[i].charaCard.num -=1;
                    __cards.splice(i, 1);
                    i--;
                }
            }
        }

        // カードを取得
        public static function getInventory(inv_id:int):CharaCardInventory
        {
            var cci:CharaCardInventory
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
        public function CharaCardInventory(inv_id:int, cc:CharaCard, index:int, position:int)
        {
            _inventoryID = inv_id;
            _charaCard = cc;
            _index = index;
            _position = position;
            _type = getType(cc);
            _dirtyFlag = 0;
            incrementCard();
        }

        private function getType(cc:CharaCard):int
        {
            var type:int = CHARA;

            if ( cc.kind == Const.CC_KIND_CHARA||cc.kind == Const.CC_KIND_REBORN_CHARA)
            {
                type = CHARA;
            } else if (cc.kind == Const.CC_KIND_MONSTAR || cc.kind == Const.CC_KIND_BOSS_MONSTAR || cc.kind == Const.CC_KIND_RARE_MONSTAR || cc.kind == Const.CC_KIND_PROFOUND_BOSS)
            {
                type = MONSTER;

            } else if ( cc.kind == Const.CC_KIND_COIN || cc.kind == Const.CC_KIND_TIPS || cc.kind ==  Const.CC_KIND_EX_COIN || cc.kind == Const.CC_KIND_EX_TIPS||cc.kind == Const.CC_KIND_ORB||cc.kind == Const.CC_KIND_ARTIFACT)
            {
                type = OTHER;
            }
            return type;
        }
        private function incrementCard():void
        {
            __cards.push(this);
            _charaCard.num +=1;
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
            return _charaCard;
        }

        // キャラカードを取得
        public function get charaCard():CharaCard
        {
            return _charaCard;
        }

        // キャラカードIDを取得
        public function get cardId():int
        {
            return _charaCard.id;
        }

        // デッキ番号を取得
        public function get index():int
        {
            return _index;
        }

        // デッキ内位置を取得
        public function get position():int
        {
            return _position;
        }

        // 書き換えフラグを取得
        public function get dirtyFlag():int
        {
            return _dirtyFlag;
        }

        // カード種類を取得
        public function get type():int
        {
            return _type;
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
        // デッキ内位置を取得
        public function set position(position:int):void
        {
            if(_position != position)
            {
                _position = position;
                if(_index != 0)
                {
                    setDirtyFlag();
//                    _dirtyFlag = true;
                }
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


        // カードデッキ内位置を取得(キャラカードは使用していない)
        public function get cardPosition():int
        {
            return 0;
        }
        // カード内位置を設定（キャラカードは使用していない）
        public function set cardPosition(cardPosition:int):void
        {
        }


    }
}