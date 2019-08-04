package view.scene.edit
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.edit.DeckCase;
    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;
    import view.scene.common.ICardClip;
    import view.ClousureThread;

    import model.*;
    import model.events.*;


    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class CharaCardDeckClip extends BaseDeckClip
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


        private var _kind:int;
        private static const _CARD_X:int = -72;                      // カードのX基本位置
        private static const _CARD_Y:int = 20;                         // カードのY基本位置
        private static const _CARD_OFFSET_X:int = 89;                // カードのXズレ
        private static const _CARD_SCALE:Number = 0.50;             // カード表示サイズ

        private static const _BINDER_X:int = 5;                    // バインダーの開始X
        private static const _BINDER_Y:int = 42;                      // バインダーの開始Y
        private static const _BINDER_X2:int = 657;                     // バインダーの終端X
        private static const _BINDER_Y2:int = 424;                     // バインダーの終端Y

        private var _ccd:CharaCardDeck;
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
        public function CharaCardDeckClip(charaCardDeck:IDeck)
        {
            _ccd = CharaCardDeck(charaCardDeck);
            _kind = _ccd.kind;
            _ccd.addEventListener(CharaCardDeck.UPDATE, updateHandler);
            super(charaCardDeck);
        }


        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }
        public override function init():void
        {
            super.init();

            // デッキがクエストデッキなら色を変える
            if (_kind == Const.CDT_QUEST)
            {
                log.writeLog(log.LV_FATAL, this, "ccdclip", _kind,_deckCase);
                _deckCase.transform.colorTransform  = new ColorTransform(0.8,1.2,0.8);
            }
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_CHARA, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_CHARA, binderToDeckHandler);

            _ccd.addEventListener(CharaCardDeck.UPDATE_POS, updatePosHandler);
        }

        // 後始末処理
        public override function final():void
        {
            super.final();
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_CHARA, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_CHARA, binderToDeckHandler);
            _ccd.removeEventListener(CharaCardDeck.UPDATE, updateHandler);

            _ccd.removeEventListener(CharaCardDeck.UPDATE_POS, updatePosHandler);
        }


        // クリップの初期化
        protected override function clipInitialize(cci:ICardInventory):void
        {
            if (_cccDic[cci] == null)
            {
                var cc:CharaCardClip = new CharaCardClip(CharaCard(cci.card));
                cc.cardInventory = cci;
                _cccDic[cci] =cc;
//                Unlight.GCW.watch(cc);
            }
            _cccDic[cci].x = _CARD_X + _CARD_OFFSET_X * CharaCardInventory(_cccDic[cci].cardInventory).position;
            _cccDic[cci].y = _CARD_Y;
            _cccDic[cci].scaleX = _CARD_SCALE;
            _cccDic[cci].scaleY = _CARD_SCALE;
            var sExec:SerialExecutor = new SerialExecutor();
            //_cccDic[cci].getEditShowThread(_container).start();
            sExec.addThread(_cccDic[cci].getEditShowThread(_container));
            sExec.addThread(new ClousureThread(function():void{updateHP()}));
            sExec.start();
        }
        // クリップの後始末処理
        protected  override function clipFinalize(cc:ICardClip):void
        {
            CharaCardClip(cc).getEditHideThread().start();
        }


        // クリップの更新
        protected override function clipUpdate(cc:ICardClip):void
        {
//            new TweenerThread(cc, {x:_CARD_X + _CARD_OFFSET_X * cc.charaCardInventory.position, y:_CARD_Y, transition:"easeOutSine", time:0.20}).start();
            new BeTweenAS3Thread(cc, {x:_CARD_X+_CARD_OFFSET_X*CharaCardInventory(cc.cardInventory).position ,y:_CARD_Y}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE).start();
        }

        // カードを消す
        protected override function removeCard(cc:ICardClip):void
        {
            _deckEditor.deckToBinderCharaCard(CharaCardInventory(cc.cardInventory));
        }

        protected override function changePosCard(index:int):void
        {
            _deckEditor.deckToDeckCharaCard(index);
        }


        // カードが追加される
        public override function binderToDeckHandler(e:EditCardEvent):void
        {
            if(CharaCardDeck.decks[e.cci.index] == _deck)
            {
                addCard(e.cci);
            }
        }

        // キャラHPを更新
        private function updateHP():void
        {
            var p:int;
            var ccc:CharaCardClip;
            for (var key:Object in _cccDic)
            {
                ccc  = _cccDic[key]
                p = ccc.cardInventory.position;
                if (_ccd.damages[p]!=null)
                {
                    ccc.hp = ccc.charaCard.hp - _ccd.damages[p];
                }
            }
        }

        // デッキデータアップデートのハンドラ
        private function updateHandler(e:Event):void
        {
            updateHP();
        }

        private function updatePosHandler(e:Event):void
        {
            update();
        }


        public function get charaCardDeck():CharaCardDeck
        {
            return CharaCardDeck(_deck);
        }
    }
}


