package view.scene.edit
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.filters.GlowFilter;

    import mx.core.UIComponent;
    import mx.controls.Text;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.utils.*;

    import controller.LobbyCtrl;

    import model.*;
    import model.events.*;
    import model.utils.*;

    /**
     * エディット画面のデータ部分のクラス
     *
     */
    public class CombineDataArea extends BaseScene
    {
        // model
        private var _deckEditor:DeckEditor = DeckEditor.instance;

        // 実体
        private var _ccc:*;                       // 選択中のカード

        // 定数
        private static const _CARD_X:int = 580;          // カードの初期位置X
        private static const _CARD_Y:int = 38;           // カードの初期位置Y
        private static const _STATE_WIDTH:int = 125;     // テキストの縦幅
        private static const _STATE_HEIGHT:int = 170;    // テキストの横幅

        // コントローラ
        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;

        private var _cccDic:Dictionary;                  // Dictionary of CCC Key:CharaCard
        private var _selectCardInventory:ICardInventory;  // 選択したカードのインベントリ


        // デッキエリアのタイプ
        private var _type:int;

        public static function getCharaCardData():CombineDataArea
        {
            log.writeLog(log.LV_INFO, "chara card data");
            return new CombineDataArea(InventorySet.TYPE_CHARA);
        }
        public static function getWeaponCardData():CombineDataArea
        {
            log.writeLog(log.LV_INFO, "weapon card data");
            return new CombineDataArea(InventorySet.TYPE_WEAPON);
        }
        public static function getEquipCardData():CombineDataArea
        {
            log.writeLog(log.LV_INFO,  "equip card data");
            return new CombineDataArea(InventorySet.TYPE_EQUIP);
        }
        public static function getEventCardData():CombineDataArea
        {
            log.writeLog(log.LV_INFO,  "equip card data");
            return new CombineDataArea(InventorySet.TYPE_EVENT);
        }
        public static function getMonsterCardData():CombineDataArea
        {
            log.writeLog(log.LV_INFO, "monster card data");
            return new CombineDataArea(InventorySet.TYPE_MONSTER);
        }
        public static function getOtherCardData():CombineDataArea
        {
            log.writeLog(log.LV_INFO, "other card data");
            return new CombineDataArea(InventorySet.TYPE_OTHER);
        }


        /**
         * コンストラクタ
         *
         */
        public function CombineDataArea(type:int)
        {
            _type = type;
        }

        // 初期化
        public override function init():void
        {
            _cccDic = new Dictionary();
            visible = false;
            _deckEditor.addEventListener(EditCardEvent.SELECT_CARD, selectCardHandler);
            Combine.instance.addEventListener(CombineEvent.COMBINE_SUCCESS, combineSuccessHandler);

            log.writeLog(log.LV_INFO, this, "Combine Data Area init!!");
        }

        // 後処理
        public override function final():void
        {
            _deckEditor.removeEventListener(EditCardEvent.SELECT_CARD, selectCardHandler);
            Combine.instance.removeEventListener(CombineEvent.COMBINE_SUCCESS, combineSuccessHandler);

            for (var key:Object in _cccDic)
            {
                _cccDic[key].getHideThread().start();
                delete _cccDic[key];
            }
            _cccDic = null;

            log.writeLog(log.LV_INFO, this, "Combine Data Area final!!");
        }

        // DicにCharaCardClipを格納
        // ICardに変更
        private function setCCC(cc:ICard):void
        {
            var forceReload:Boolean = false;
            if (_type == InventorySet.TYPE_WEAPON) {
                forceReload = WeaponCard(cc).forceReload;
            }
            if (_cccDic[cc] ==null || forceReload)
            {
                // ここはタイプで分ける
                switch (_type)
                {
                case InventorySet.TYPE_CHARA:
                case InventorySet.TYPE_MONSTER:
                case InventorySet.TYPE_OTHER:
                    _cccDic[cc] = new CharaCardClip(CharaCard(cc));
                    break;
                case InventorySet.TYPE_WEAPON:
                    _cccDic[cc] = new WeaponCardClip(WeaponCard(cc));
                    break;
                case InventorySet.TYPE_EQUIP:
                    _cccDic[cc] = new EquipCardClip(EquipCard(cc));
                    break;
                case InventorySet.TYPE_EVENT:
                    _cccDic[cc] = new EventCardClip(EventCard(cc));
                    break;
                }
                _cccDic[cc].getShowThread(this).start();
                _cccDic[cc].visible = true;
//                 Unlight.GCW.watch(_cccDic[cc]);
            }
            else
            {
                _cccDic[cc].visible = false;
            }
        }

        // カード選択
        protected function selectCardHandler(e:EditCardEvent):void
        {
            if(_deckEditor.substanceEditType() == _type)
            {
                if(_ccc !=null)
                {
                    hideCard();
                }
                // ここはタイプで分ける
                switch (_type)
                {
                case InventorySet.TYPE_CHARA:
                case InventorySet.TYPE_MONSTER:
                case InventorySet.TYPE_OTHER:
                    loadCard(CharaCard.ID(e.index));
                    break;
                case InventorySet.TYPE_WEAPON:
                    loadCard(WeaponCard.ID(e.index));
                    break;
                case InventorySet.TYPE_EQUIP:
                    loadCard(EquipCard.ID(e.index));
                    break;
                case InventorySet.TYPE_EVENT:
                    loadCard(EventCard.ID(e.index));
                    break;
                }
                // 選択したインベントリを保持
                _selectCardInventory = e.cci;
                showCard();
            }
        }

        private function checkTypeChara(not:Boolean=false):Boolean
        {
            var check:Boolean = false;
            if (not) {
                check = (_type != InventorySet.TYPE_CHARA && _type != InventorySet.TYPE_MONSTER && _type != InventorySet.TYPE_OTHER);
            } else {
                check = (_type == InventorySet.TYPE_CHARA || _type == InventorySet.TYPE_MONSTER || _type == InventorySet.TYPE_OTHER);
            }
            return check;
        }

        private function combineSuccessHandler(e:CombineEvent):void
        {
            hideCard();
            var wci:WeaponCardInventory = WeaponCardInventory.getInventory(Combine.instance.resultCardInvId);
            // 一度削除する
            if (_cccDic[wci.card]) {
                _cccDic[wci.card].getHideThread().start();
                delete _cccDic[wci.card];
            }
            setCCC(wci.card);
            _ccc = _cccDic[wci.card];
            _ccc.x = _CARD_X;
            _ccc.y = _CARD_Y;
        }

        // カードをロードする
        private function loadCard(cc:ICard):void
        {
            setCCC(cc);
            _ccc = _cccDic[cc];
            _ccc.x = _CARD_X;
            _ccc.y = _CARD_Y;
        }

        // カードの表示を隠す
        public function hideCard():void
        {
            if(_ccc!=null)
            {
                _ccc.visible = false;
                log.writeLog(log.LV_INFO, this, "HIDE CARD",_type);
            }
        }

        // カードを表示する
        public function showCard():void
        {
            if(_ccc!=null)
            {
                log.writeLog(log.LV_INFO, this, "SHOW CARD",checkTypeChara());
                _ccc.visible = true;
            }
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage);
        }

        public function get ccc():CharaCardClip
        {
            return _ccc;
        }

        public function clearCard():void
        {
            _ccc.getEditHideThread().start();
            _ccc = new CharaCardClip(CharaCard.ID(0));
            _ccc.visible = false;
        }

        public function resetCard():void
        {
            _ccc.visible = false;
        }

        public function get selectInventory():ICardInventory
        {
            return _selectCardInventory;
        }

    }
}



import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.scene.edit.CombineDataArea;
import view.BaseShowThread;
import view.BaseHideThread;

// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(da:CombineDataArea, stage:DisplayObjectContainer)
    {
        super(da, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(da:CombineDataArea)
    {
        super(da);
    }
}
