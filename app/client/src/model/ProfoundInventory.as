package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import flash.events.IEventDispatcher;

    import flash.utils.ByteArray;

    import view.*;
    import controller.*;

    // 渦インベントリクラス
    public class ProfoundInventory extends BaseModel
    {
        // 渦インベントリの状態定数
        public static const  PRF_INV_ST_NEW:int        = 0; // 新規
        public static const  PRF_INV_ST_UNSOLVE:int    = 1; // 未解決
        public static const  PRF_INV_ST_INPROGRESS:int = 2; // 進行中
        public static const  PRF_INV_ST_SOLVED:int     = 3; // 解決
        public static const  PRF_INV_ST_PENDING:int    = 4; // 未決（まだ見つけてない）
        public static const  PRF_INV_ST_FAILED:int     = 5; // 失敗
        public static const  PRF_INV_ST_PRESENTED:int  = 6; // プレゼントされた
        public static const  PRF_INV_ST_GIVE_UP:int    = 7; // ギブアップ

        // 渦インベントリの戦闘中渦の最大所持数
        public static const PRF_MAX_BTL_CNT:int = 10;

        private var _profound:Profound;    // 渦情報
        private var _profoundId:int;       // 渦情報ID
        private var _deckIdx:int           // 使用デッキINDEX
        private var _charaCardDamage1:int; // キャラダメージ1
        private var _charaCardDamage2:int; // キャラダメージ2
        private var _charaCardDamage3:int; // キャラダメージ3
        private var _damageCount:int;      // 与ダメージ数
        private var _state:int;            // 状態

        private static var __items:Array = [];      // Array of ProfoundInventory

        private static var _ctrl:RaidCtrl = RaidCtrl.instance;  // レイドのコントローラー


        public static function initializeProfoundInventory():void
        {
            __items = []
        }

        public static function get items():Array
        {
            return __items;
        }

        // 戦闘中の渦の個数を取得
        public static function get battleProfoundCount():int
        {
            var ret:int = 0;
            for(var i:int; i < __items.length; i++)
            {
                if (!__items[i].profound.isFinished && !__items[i].profound.isVanished && __items[i].state != PRF_INV_ST_GIVE_UP)
                {
                    ret++;
                }
            }
            return ret;
        }

        // GiveUpしたかの判定
        public static function isGiveUp(prfId:int,state:int):Boolean
        {
            var pi:ProfoundInventory = getProfoundInventoryForPrfId(prfId);

            if (state == PRF_INV_ST_GIVE_UP && pi) {
                if (pi.state != PRF_INV_ST_SOLVED && pi.state != PRF_INV_ST_FAILED && pi.state != PRF_INV_ST_GIVE_UP) return true;
            }

            return false;
        }

        // 選択したデッキは使用可能か
        public static function isCanUseDeck(selPrfId:int,deckIdx:int):Boolean
        {
            var prfInv:ProfoundInventory = getProfoundInventoryForPrfId(selPrfId);
            if (prfInv) {
                if (prfInv.deckIdx == 0 && getUsedDeckInvId(deckIdx) == 0) {
                    return true;
                } else if (prfInv.deckIdx == deckIdx) {
                    return true;
                }
            }
            return false;
        }

        // デッキを使用しているinvIDを取得
        public static function getUsedDeckInvId(deckIdx:int):int
        {
            var ret:int = 0
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].deckIdx == deckIdx)
                {
                    ret = __items[i].profoundId;
                    break;
                }
            }
            return ret;
        }

        public static function getProfoundInventoryForId(id:int):ProfoundInventory
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].id == id)
                {
                    return __items[i];
                }
            }
            return null;
        }

        public static function getProfoundInventoryForPrfId(id:int):ProfoundInventory
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].profoundId == id)
                {
                    return __items[i];
                }
            }
            return null;
        }
        public static function getProfoundInventoryIdForPrfId(id:int):int
        {
            var inv:ProfoundInventory = getProfoundInventoryForPrfId(id);
            return (inv != null) ? inv.id : 0;
        }

        public static function getUseDeckDamaged(deckIdx:int):Array
        {
            if (deckIdx != 0) {
                for(var i:int; i < __items.length; i++)
                {
                    if(__items[i].deckIdx != 0 && __items[i].deckIdx == deckIdx)
                    {
                        var ret:Array = [];
                        ret.push(__items[i].charaCardDamage1);
                        ret.push(__items[i].charaCardDamage2);
                        ret.push(__items[i].charaCardDamage3);
                        return ret;
                    }
                }
            }
            return null;
        }

        public static function resetUseDeckFromPrfId(id:int):int
        {
            var ret:int = 0;
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].profoundId == id)
                {
                    ret = __items[i].deckIdx;
                    __items[i].deckIdx = 0;
                    __items[i].charaCardDamage1 = 0;
                    __items[i].charaCardDamage2 = 0;
                    __items[i].charaCardDamage3 = 0;
                }
            }
            return ret;
        }

        public static function updateProfoundInventory(invId:int,prfId:int,deckIdx:int,charaCardDmg1:int,charaCardDmg2:int,charaCardDmg3:int,damageCount:int,state:int):ProfoundInventory
        {
            var ret:ProfoundInventory = null;
            for(var i:int; i < __items.length; i++)
            {
                if (__items[i].id == invId)
                {
                    __items[i]._deckIdx = deckIdx;
                    __items[i]._charaCardDamage1 = charaCardDmg1;
                    __items[i]._charaCardDamage2 = charaCardDmg2;
                    __items[i]._charaCardDamage3 = charaCardDmg3;
                    __items[i]._damageCount = damageCount;
                    __items[i]._state = state;
                    ret = __items[i];
                }
            }
            if ( ret == null ) {
                ret = new ProfoundInventory(invId,prfId,deckIdx,charaCardDmg1,charaCardDmg2,charaCardDmg3,damageCount,state);
            }
            return ret;
        }

        // コンストラクタ
        public function ProfoundInventory(invId:int,prfId:int,deckIdx:int,charaCardDmg1:int,charaCardDmg2:int,charaCardDmg3:int,damageCount:int,state:int)
        {
            log.writeLog(log.LV_FATAL, this,"const", invId,prfId,deckIdx,charaCardDmg1,charaCardDmg2,charaCardDmg3,damageCount,state);
            _profound = Profound.getProfoundForId(prfId);
            _id               = invId;
            _profoundId       = prfId;
            _deckIdx          = deckIdx;
            _charaCardDamage1 = charaCardDmg1;
            _charaCardDamage2 = charaCardDmg2;
            _charaCardDamage3 = charaCardDmg3;
            _damageCount      = damageCount;
            _state            = state;
            __items.push(this);
            __items.sort();
        }

        // 渦情報を取得
        public function get profound():Profound
        {
            return _profound;
        }
        // 渦情報IDを取得
        public function get profoundId():int
        {
            return _profoundId;
        }
        // デッキIDを取得
        public function get deckIdx():int
        {
            return _deckIdx;
        }
        // デッキIDを設定
        public function set deckIdx(deckId:int):void
        {
            _deckIdx = deckIdx;
        }
        // キャラダメージ値を取得1
        public function get charaCardDamage1():int
        {
            return _charaCardDamage1;
        }
        // キャラダメージ値を設定1
        public function set charaCardDamage1(damage:int):void
        {
            _charaCardDamage1 = damage;
        }
        // キャラダメージ値を取得2
        public function get charaCardDamage2():int
        {
            return _charaCardDamage2;
        }
        // キャラダメージ値を設定2
        public function set charaCardDamage2(damage:int):void
        {
            _charaCardDamage2 = damage;
        }
        // キャラダメージ値を取得3
        public function get charaCardDamage3():int
        {
            return _charaCardDamage3;
        }
        // キャラダメージ値を設定3
        public function set charaCardDamage3(damage:int):void
        {
            _charaCardDamage3 = damage;
        }
        // 与ダメージを取得
        public function get daamageCount():int
        {
            return _damageCount;
        }
        // 与ダメージを設定
        public function set damageCount(damage:int):void
        {
            _damageCount = damage;
        }
        // 状態を取得
        public function get state():int
        {
            return _state;
        }
        // 状態を設定
        public function set state(state:int):void
        {
            _state = state;
        }
        public function get viewCheck():Boolean
        {
            return (_state != PRF_INV_ST_FAILED && _state != PRF_INV_ST_GIVE_UP);
        }

    }
}