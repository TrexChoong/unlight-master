package view.scene.edit
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.edit.DeckCase;
    import view.scene.BaseScene;
    import view.scene.common.EventCardClip;
    import view.scene.common.ICardClip;

    import model.*;
    import model.events.*;

    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class EventCardDeckClip extends BaseDeckClip
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_DECK	:String = "所持しているデッキです。\nデッキに存在するカードが表示されます。";

        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_DECK	:String = "Your deck.\nThis shows which cards your deck is composed of.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_DECK	:String = "所擁有的牌組。\n顯示牌組中的卡片。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_DECK	:String = "所持有的卡组。\n显示卡组的卡片。";

        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_DECK	:String = "소지하고 있는 덱입니다. \n덱에 존재하는 카드가 표시됩니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_DECK	:String = "Pioche\ncartes de la pioche";

        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_DECK	:String = "所持しているデッキです。\nデッキに存在するカードが表示されます。";

        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_DECK   :String = "สำรับที่ท่านครอบครองอยู่\nการ์ดที่มีอยู่ในสำรับจะถูกแสดงให้เห็น";


        private static const _CARD_X:int = -64;                      // カードのX基本位置
        private static const _CARD_Y:int = 37;                         // カードのY基本位置
        private static const _CARD_OFFSET_X:int = 30;                // カードのXズレ
        private static const _CARD_OFFSET_Y:int = 65;                // カードのYズレ
        private static const _CARD_SCALE:Number = 0.5;             // カード表示サイズ
        private static const _POS_OFFSET_X:int = 89;                // カードのXズレ

        private static const _BINDER_X:int = 5;                    // バインダーの開始X
        private static const _BINDER_Y:int = 42;                      // バインダーの開始Y
        private static const _BINDER_X2:int = 657;                     // バインダーの終端X
        private static const _BINDER_Y2:int = 424;                     // バインダーの終端Y

        // 位置を覚えておく辞書
        private var _slotDic:Dictionary = new Dictionary();             // Dictionary of positonNum, key :CardClip

        private var _eventCardDeck:EventCardDeck;

        private var _eventCardSlot:EventCardSlotScene = new EventCardSlotScene();


//        private var _slotDataSet:Array;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["所持しているデッキです。\nデッキに存在するカードが表示されます。"],
                [_TRANS_HELP_DECK],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _EDIT_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function EventCardDeckClip(eventCardDeck:IDeck)
        {
            super(eventCardDeck);
            _eventCardDeck = EventCardDeck(eventCardDeck);
            _deckCase.alpha = 0.5;
//            Unlight.GCW.watch(_slotDic);
//            Unlight.GCW.watch(_eventCardSlot);

        }

        public override function init():void
        {
            super.init();
            _container.addChild(_eventCardSlot);
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_EVENT, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_EVENT, binderToDeckHandler);
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_DECK_EVENT, deckToDeckHandler);
            _eventCardDeck.addEventListener(EventCardDeck.SLOT_UPDATE, slotUpdateHandler);
            _eventCardDeck.addEventListener(EventCardDeck.REMOVE_CHARA, removeCharaHandler);
//             _eventCardDeck.updateCaseSlot();
            _eventCardDeck.initSlot();
            _eventCardSlot.updateSlots(_eventCardDeck.slotsSet, _deckEditor.getCharaNum(_eventCardDeck.myIndex));
            log.writeLog(log.LV_FATAL, this, "SLOT MARK INIT",_eventCardDeck.slotsSet, _deckEditor.getCharaNum(_eventCardDeck.myIndex));
        }

        // 後始末処理
        public override function final():void
        {
            super.final();
            _container.removeChild(_eventCardSlot);
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_EVENT, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_EVENT, binderToDeckHandler);
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_DECK_EVENT, deckToDeckHandler);
            _eventCardDeck.removeEventListener(EventCardDeck.SLOT_UPDATE, slotUpdateHandler);
            _eventCardDeck.removeEventListener(EventCardDeck.REMOVE_CHARA, removeCharaHandler);
            _eventCardSlot.final();
            _eventCardSlot = null;
            _eventCardDeck = null;
        }

        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }


        // クリップの初期化
        protected override function clipInitialize(cci:ICardInventory):void
        {
            var ec:EventCard = EventCard(cci.card);
//            var slot:int = _slotDataSet[cci.position].useSlot(0);
            if (_cccDic[cci] == null)
            {
                var cc:EventCardClip = new EventCardClip(ec);
                cc.cardInventory = cci;
//                _slotDic[cci] = slot;
                _cccDic[cci] =cc;
//                Unlight.GCW.watch(cc);
//                log.writeLog(log.LV_FATAL, this, "------------- EVentClipNo", cci.card.id);
            }

//            log.writeLog(log.LV_FATAL, this, "pos!!!!!!!",ec.color,cci.position,cci.cardPosition);

//            cc.x = _CARD_X + _CARD_OFFSET_X * EventCardInventory(cc.cardInventory).position;
//            log.writeLog(log.LV_FATAL, this, "init pos!!!!!!!",cci.cardPosition, cci.position, cci.cardId);
            _cccDic[cci].x = _CARD_X + getXFromSlot(cci.cardPosition,cci.position);
            _cccDic[cci].y = _CARD_Y + getYFromSlot(cci.cardPosition);
            _cccDic[cci].scaleX = _CARD_SCALE;
            _cccDic[cci].scaleY = _CARD_SCALE;
            _cccDic[cci].getDeckShowThread(_container).start();

        }
        // クリップの後始末処理
        protected  override function clipFinalize(cc:ICardClip):void
        {
//            EventCardClip(cc).getEditHideThread().start();
//            _slotDataSet[cc.cardInventory.position].resetSlot(_slotDic[cc.cardInventory] )
            EventCardClip(cc).getHideThread().start();
        }


        // クリップの更新
        protected override function clipUpdate(cc:ICardClip):void
        {
//            log.writeLog(log.LV_FATAL, this, "update pos!!!!!!!",cc.cardInventory.cardPosition, cc.cardInventory.position, cc.cardInventory.cardId);
            new BeTweenAS3Thread(cc, {x:_CARD_X + getXFromSlot(cc.cardInventory.cardPosition, cc.cardInventory.position) ,y:_CARD_Y + getYFromSlot(cc.cardInventory.cardPosition)}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE).start();
//             DisplayObject(cc).x = _CARD_X + getXFromSlot(cc.cardInventory.cardPosition, cc.cardInventory.position);
//             DisplayObject(cc).y = _CARD_Y+getYFromSlot(cc.cardInventory.cardPosition);
        }

        protected override function clipUpdateNow(cc:ICardClip):void
        {
            DisplayObject(cc).x = _CARD_X + getXFromSlot(cc.cardInventory.cardPosition, cc.cardInventory.position);
            DisplayObject(cc).y = _CARD_Y+getYFromSlot(cc.cardInventory.cardPosition);

        }
        private function getXFromSlot(slot:int, pos:int):int
        {
            return _CARD_OFFSET_X*(slot%3) + _POS_OFFSET_X*pos;
        }

        private function getYFromSlot(slot:int):int
        {
            return  _CARD_OFFSET_Y * (int(slot/3));
        }

        // カードを消す
        protected override function removeCard(cc:ICardClip):void
        {
            _deckEditor.deckToBinderEventCard(EventCardInventory(cc.cardInventory));
        }


        // カードが追加される
        public override function binderToDeckHandler(e:EditCardEvent):void
        {
            if(EventCardDeck.decks[e.cci.index] == _deck)
            {
                addCard(e.cci);
            }
        }


        // カードが瞬時追加される
        public override function deckToDeckHandler(e:EditCardEvent):void
        {
            if(EventCardDeck.decks[e.cci.index] == _deck)
            {
                addCardNow(e.cci);
            }
        }


        private function slotUpdateHandler(e:Event):void
        {
            _eventCardSlot.updateSlots(_eventCardDeck.slotsSet, _deckEditor.getCharaNum(_eventCardDeck.myIndex));
        }

        private function removeCharaHandler(e:Event):void
        {
            update();
        }


        public function get eventCardDeck():EventCardDeck
        {
            return EventCardDeck(_deck);
        }
    }
}

