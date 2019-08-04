package view.scene.edit
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.edit.DeckCase;
    import view.image.requirements.GrowthDetailImage;
    import view.image.requirements.GrowthDetailNumImage;
    import view.scene.BaseScene;
    import view.scene.common.WeaponCardClip;
    import view.scene.common.ICardClip;

    import model.*;
    import model.events.*;

    /**
     * 合成候補表示クラス
     *
     */
    public class CombineSetClip extends BaseDeckClip
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "所持数×";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Own * ";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "所持數x";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "持有数x";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "소지수 * ";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Possession * ";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "所持数×";

        CONFIG::LOCALE_TH
        private static const _TRANS :String = "จำนวนที่ครอบครองอยู่ x ";

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_DECK	:String = "合成に使用するカードリストです";

        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_DECK	:String = "Crafting cards list";

        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_DECK	:String = "合成卡片用的清單。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_DECK	:String = "合成卡片用的清单。";

        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_DECK	:String = "合成に使用するカードリストです";

        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_DECK	:String = "Voici la liste des cartes à combiner.";

        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_DECK	:String = "合成に使用するカードリストです";

        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_DECK   :String = "合成に使用するカードリストです";

        private static const _CARD_X:int = 23;                      // カードのX基本位置
        private static const _CARD_Y:int = 103;                         // カードのY基本位置
        private static const _CARD_OFFSET_X:int = 100;                // カードのXズレ
        private static const _CARD_SCALE:Number = 0.50;             // カード表示サイズ

        private static const _BINDER_X:int = 5;                    // バインダーの開始X
        private static const _BINDER_Y:int = 42;                      // バインダーの開始Y
        private static const _BINDER_X2:int = 657;                     // バインダーの終端X
        private static const _BINDER_Y2:int = 424;                     // バインダーの終端Y

        private static const _SET_LIST_X:int = 0;
        private static const _SET_LIST_Y:int = 0;

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

//        private var _backContainer:UIComponent = new UIComponent();       // 表示コンテナ
//        private var _frontContainer:UIComponent = new UIComponent();       // 表示コンテナ
        // 前回のキャラカードクリップ
        private var _growthDetailImage:GrowthDetailImage = new GrowthDetailImage(GrowthDetailImage.TYPE_WEAPON);
        private var _growthDetailNumImage:GrowthDetailNumImage = new GrowthDetailNumImage();

        // label
        private var _useCntLabel:Array = [];
        private var _haveCntLabel:Array = [];

        private static const _NUM_10UPDOWN:int = 10;
        private static const _NUM_1UPDOWN:int  = 1;

        private static const _LOW_LABEL_X:int = 40;               // 開始X
        private static const _LOW_LABEL_Y:int = 45;                // 開始Y
        private static const _LOW_LABEL_NUM_X:int = 12;           // 開始X
        private static const _LOW_LABEL_NUM_Y:int = 208;           // 開始Y
        private static const _LOW_LABEL_OFFSET_X:int = 100;        // 開始X

        private static const _LABEL_WIDTH:int = 50;            // ラベルの横幅
        private static const _LABEL_HEIGHT:int = 50;           // ラベルの縦幅
        private static const _LOW_LABEL_WIDTH:int = 100;            // ラベルの横幅
        private static const _LOW_LABEL_HEIGHT:int = 15;           // ラベルの縦幅

        /**
         * コンストラクタ
         *
         */
        public function CombineSetClip(deck:IDeck)
        {
            super(deck);
            _deckCase.visible = false;
        }

        public override function init():void
        {
            _backContainer.x = _SET_LIST_X;
            _backContainer.y = _SET_LIST_Y;
            _frontContainer.x = _SET_LIST_X;
            _frontContainer.y = _SET_LIST_Y;

//            addChild(_backContainer);
            super.init();
            _growthDetailImage.resetBtn.visible = true;
            _backContainer.addChild(_growthDetailImage);
            _frontContainer.addChild(_growthDetailNumImage);
            initLabel();
            _deckEditor.addEventListener(EditCardEvent.COMBINE_TO_BINDER_WEAPON, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_COMBINE_WEAPON, binderToDeckHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_COMBINE_WEAPON_ADD, binderToDeckAddHandler);
            _growthDetailImage.resetBtn.addEventListener(MouseEvent.CLICK,resetHandler);
            _growthDetailImage.setNumBtnFunc(btn10upClick,btn10downClick,btn1upClick,btn1downClick);
            Combine.instance.addEventListener(CombineEvent.COMBINE_SUCCESS, combineSuccessHandler);

        }

        // 後始末処理
        public override function final():void
        {
            _useCntLabel.forEach(function(item:*, index:int, array:Array):void{_container.removeChild(item)});
            super.final();
            _deckEditor.removeEventListener(EditCardEvent.COMBINE_TO_BINDER_WEAPON, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_COMBINE_WEAPON, binderToDeckHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_COMBINE_WEAPON_ADD, binderToDeckAddHandler);
            _growthDetailImage.resetBtn.removeEventListener(MouseEvent.CLICK,resetHandler);
            Combine.instance.removeEventListener(CombineEvent.COMBINE_SUCCESS, combineSuccessHandler);
        }

        public function initLabel():void
        {
            for (var i:int = 0; i < CombineEditDeck.LIST_MAX; i++) {
                _useCntLabel.push(new Label());
                _useCntLabel[i].x = _LOW_LABEL_X + _LOW_LABEL_OFFSET_X * i;
                _useCntLabel[i].y = _LOW_LABEL_Y;
                _useCntLabel[i].width = _LABEL_WIDTH;
                _useCntLabel[i].height = _LABEL_HEIGHT;
                _useCntLabel[i].filters = [new GlowFilter(0x000000, 1, 3, 3, 16, 1)];
                _useCntLabel[i].text = "";
                _useCntLabel[i].styleName = "UnlockCharaCardLabel";
                _useCntLabel[i].setStyle("fontSize",48);
                _useCntLabel[i].mouseEnabled = false;
                _useCntLabel[i].mouseChildren = false;

                _container.addChild(_useCntLabel[i]);

                _haveCntLabel.push(new Label());
                _haveCntLabel[i].x = _LOW_LABEL_NUM_X + _LOW_LABEL_OFFSET_X * i;
                _haveCntLabel[i].y = _LOW_LABEL_NUM_Y;
                _haveCntLabel[i].width = _LOW_LABEL_WIDTH;
                _haveCntLabel[i].height = _LOW_LABEL_HEIGHT;
                _haveCntLabel[i].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
                _haveCntLabel[i].text = "";
                _haveCntLabel[i].styleName = "UnlockCharaCardNumLabel";
                _haveCntLabel[i].mouseEnabled = false;
                _haveCntLabel[i].mouseChildren = false;

                _frontContainer.addChild(_haveCntLabel[i]);
            }
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
//            log.writeLog(log.LV_FATAL, this, "clip initialize weapon!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            if (_cccDic[cci] == null)
            {
                var cc:WeaponCardClip = new WeaponCardClip(WeaponCard(cci.card));
                cc.cardInventory = cci;
                _cccDic[cci] =cc;
            }

            _cccDic[cci].x = _CARD_X + _CARD_OFFSET_X * CombineEditDeck.deck.getCardIdList().indexOf(cci.cardId);
            _cccDic[cci].y = _CARD_Y;
            _cccDic[cci].scaleX = _CARD_SCALE;
            _cccDic[cci].scaleY = _CARD_SCALE;
            _cccDic[cci].getEditShowThread(_container).start();
        }
        // クリップの後始末処理
        protected  override function clipFinalize(cc:ICardClip):void
        {
            log.writeLog(log.LV_FATAL, this, "clipFinalize");
            WeaponCardClip(cc).getHideThread().start();
        }


        // クリップの更新
        protected override function clipUpdate(cc:ICardClip):void
        {
            var cardIndex:int = CombineEditDeck.deck.getCardIdList().indexOf(cc.cardInventory.cardId);
            new BeTweenAS3Thread(cc, {x:_CARD_X+_CARD_OFFSET_X*cardIndex,y:_CARD_Y}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE).start();
            setNumBtnVisible();
            labelUpdate();
        }

        // カードを消す
        protected override function removeCard(cc:ICardClip):void
        {
            _deckEditor.deckToBinderWeaponCard(WeaponCardInventory(cc.cardInventory));
            setNumBtnVisible();
            labelUpdate();
        }

        // 数値の更新
        private function labelUpdate():void
        {
            for (var i:int = 0;i < CombineEditDeck.LIST_MAX; i++) {
                // 一度リセット
                _useCntLabel[i].text = "";
                _haveCntLabel[i].text = "";

                // デッキにセットされてるもののみ設定
                var ci:WeaponCardInventory = CombineEditDeck.deck.cardInventories[i];
                if (ci != null) {
                    _useCntLabel[i].text = CombineEditDeck.deck.getUseNum(i);
                    _haveCntLabel[i].text = _TRANS + ci.card.num;
                }
            }
        }
        // 数値設定ボタン表示
        private function setNumBtnVisible():void
        {
            log.writeLog(log.LV_DEBUG, this, "setNumBtnVisible");
            // 一度リセット
            _growthDetailImage.numBtnHide();

            for (var i:int = 0;i < CombineEditDeck.LIST_MAX; i++) {
                // デッキにセットされてるもののみ設定
                var ci:WeaponCardInventory = CombineEditDeck.deck.cardInventories[i];
                if (ci != null) {
                    // ベースカードは数の増減は出来ない
                    if (i==0) {
                        CombineEditDeck.deck.setUseNum(i,1);
                        _growthDetailImage.numBtnShow(i,1,1);
                    } else {
                        // 最大値のチェック
                        var wc:WeaponCard = WeaponCard(ci.card);
                        var maxNum:int = CombineEditDeck.deck.getNowUseMaxNum(i);
                        if (maxNum > wc.materialUseMaxNum) {
                            maxNum = wc.materialUseMaxNum;
                        }
                        if (maxNum > wc.num) {
                            maxNum = wc.num;
                        }
                        log.writeLog(log.LV_DEBUG, this, "setNumBtnVisible",maxNum,wc.num,wc.materialUseMaxNum);


                        // ボタンの更新
                        var newUseNum:int = CombineEditDeck.deck.getUseNum(i);
                        _growthDetailImage.numBtnShow(i,newUseNum,maxNum);
                    }
                }
            }
        }


        // カードが追加される
        public override function binderToDeckHandler(e:EditCardEvent):void
        {
            addCard(e.cci);
        }

        // リセット
        private function resetHandler(e:MouseEvent):void
        {
            resetData();
        }

        // 数値更新関数
        private function useNumUpdate(idx:int,num:int,allUpdate:Boolean = true):void
        {
            log.writeLog(log.LV_DEBUG, this, "setNumBtnVisible");
            // デッキにセットされてるもののみ設定
            var ci:WeaponCardInventory = CombineEditDeck.deck.cardInventories[idx];
            if (ci != null) {
                // ベースカードは数の増減は出来ない
                if (idx == 0) {
                    CombineEditDeck.deck.setUseNum(idx,1);
                    _growthDetailImage.numBtnShow(idx,1,1);
                    _useCntLabel[idx].text = 1;
                } else {
                    // 最大値のチェック
                    var wc:WeaponCard = WeaponCard(ci.card);
                    var maxNum:int = CombineEditDeck.deck.getNowUseMaxNum(idx);
                    if (maxNum > wc.materialUseMaxNum) {
                        maxNum = wc.materialUseMaxNum;
                    }
                    if (maxNum > wc.num) {
                        maxNum = wc.num;
                    }

                    // 増減
                    var newUseNum:int = 0;
                    if (num != 0) {
                        if (num > maxNum) {
                            num = maxNum;
                            newUseNum = CombineEditDeck.deck.setUseNum(idx,num);
                        } else {
                            newUseNum = CombineEditDeck.deck.addUseNum(idx,num);
                        }
                    } else {
                        // 0の場合は最大値の更新のみの為、現在数値を渡す
                        newUseNum = CombineEditDeck.deck.getUseNum(idx);
                    }

                    // ラベル、ボタンの更新
                    _useCntLabel[idx].text = newUseNum;
                    _growthDetailImage.numBtnShow(idx,newUseNum,maxNum);
                }

                if (allUpdate) {
                    // 他のカードの最大値を調整
                    var listNum:int = CombineEditDeck.deck.getCardIdList().length;
                    for (var i:int = 0; i < listNum; i++) {
                        if (i != 0 && i != idx) {
                            useNumUpdate(i,0,false);
                        }
                    }
                }
            }
        }
        private function btn10upClick(idx:int):void
        {
            useNumUpdate(idx,_NUM_10UPDOWN);
        }
        private function btn10downClick(idx:int):void
        {
            useNumUpdate(idx,-_NUM_10UPDOWN);
        }
        private function btn1upClick(idx:int):void
        {
            useNumUpdate(idx,_NUM_1UPDOWN);
        }
        private function btn1downClick(idx:int):void
        {
            useNumUpdate(idx,-_NUM_1UPDOWN);
        }

        private function binderToDeckAddHandler(e:EditCardEvent):void
        {
            var cardIdList:Array = CombineEditDeck.deck.getCardIdList();
            var idx:int = cardIdList.indexOf(e.cci.cardId);
            if (idx != -1) {
                var ci:WeaponCardInventory = CombineEditDeck.deck.cardInventories[idx];
                // 最大値のチェック
                var wc:WeaponCard = WeaponCard(ci.card);
                var maxNum:int = CombineEditDeck.deck.getNowUseMaxNum(idx);
                if (maxNum > wc.materialUseMaxNum) {
                    maxNum = wc.materialUseMaxNum;
                }
                if (maxNum > wc.num) {
                    maxNum = wc.num;
                }
                var nowNum:int = CombineEditDeck.deck.getUseNum(idx);
                // 加算時に最大値を超えない場合のみ処理
                if (nowNum+1 <= maxNum) {
                    useNumUpdate(idx,_NUM_1UPDOWN);
                }
            }
        }

        // 合成に成功した時のイベント
        private function combineSuccessHandler(e:CombineEvent):void
        {
            labelUpdate();
            setNumBtnVisible();
        }

        public function resetData():void
        {
            log.writeLog(log.LV_FATAL, this, "reset set data");
            CombineEditDeck.deleteDeck();
            labelUpdate();
            setNumBtnVisible();
        }

        public function get charaCardDeck():WeaponCardDeck
        {
            return WeaponCardDeck(_deck);
        }
    }
}


