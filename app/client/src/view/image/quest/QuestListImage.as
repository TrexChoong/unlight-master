package view.image.quest
{

    import flash.display.*;
    import flash.utils.Timer;
    import flash.events.*;
    import flash.filters.GlowFilter;

    import mx.core.UIComponent;
    import mx.controls.*

    import model.Player;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * QuestListImage表示クラス
     *
     */


    public class QuestListImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/questlist.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const BACK_BUTTON:String  ="back";
        private static const NEXT_BUTTON:String  ="next";
        private static const SALE:String  ="sale";
        private static const SHOP_SKIP_BUTTON:String  ="shop_a";
        private static const SHOP_GET_BUTTON:String  ="shop_b";
        private static const SHOP_USEFUL_BUTTON:String  ="shop_c";
        private var _maxLength:int = 0;
        private var _length:int = 0;
        private var _page:int = 0;

        private var _backButton:SimpleButton;
        private var _nextButton:SimpleButton;
        private var _sale:MovieClip;
        private var _shopSkipButton:SimpleButton;
        private var _shopGetButton:SimpleButton;
        private var _shopUsefulButton:SimpleButton;
        private var _nextFunc:Function;
        private var _backFunc:Function;
        private var _shopSkipFunc:Function;
        private var _shopGetFunc:Function;
        private var _shopUsefulFunc:Function;
        private var _nextVisible:Boolean = false;
        private var _backVisible:Boolean = false;
        private var _shopSkipVisible:Boolean = false;
        private var _shopGetVisible:Boolean = false;
        private var _shopUsefulVisible:Boolean = false;

        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_SALE           :String = "残り[__SALE_TIME__]";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_SALE           :String = "[__SALE_TIME__]";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_SALE           :String = "剩餘 [__SALE_TIME__]";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_SALE           :String = "剩余 [__SALE_TIME__]";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_SALE           :String = "残り[__SALE_TIME__]";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_SALE           :String = "Reste [__SALE_TIME__]";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_SALE           :String = "残り[__SALE_TIME__]";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_SALE           :String = "เวลาที่เหลือ[__SALE_TIME__]";

        private var _saleDiscountLabel:Label = new Label();
        private static const _LABEL_WIDTH:int  = 40;
        private static const _LABEL_HEIGHT:int = 50;
        // セール表示用ラベル
        private var _saleRestTimeLabel:Label = new Label();
        private static const _TIME_LABEL_WIDTH:int  = 100;
        private static const _TIME_LABEL_HEIGHT:int = 20;

        // 描画コンテナ
        private var _labelContainer:UIComponent = new UIComponent();

        private var _time:Timer;

        /**
         * コンストラクタ
         *
         */
        public function QuestListImage()
        {
            super();
//            mouseEnabled = false;
//            mouseChildren = false;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            initializePos();
            _backButton = SimpleButton(_root.getChildByName(BACK_BUTTON));
            _nextButton = SimpleButton(_root.getChildByName(NEXT_BUTTON));
            _sale = MovieClip(_root.getChildByName(SALE));
            _shopSkipButton = SimpleButton(_root.getChildByName(SHOP_SKIP_BUTTON));
            _shopGetButton = SimpleButton(_root.getChildByName(SHOP_GET_BUTTON));
            _shopUsefulButton = SimpleButton(_root.getChildByName(SHOP_USEFUL_BUTTON));


            _backButton.addEventListener(MouseEvent.CLICK, backButtonHandler);
            _nextButton.addEventListener(MouseEvent.CLICK, nextButtonHandler);
            _shopSkipButton.addEventListener(MouseEvent.CLICK, shopSkipButtonHandler);
            _shopGetButton.addEventListener(MouseEvent.CLICK, shopGetButtonHandler);
            _shopUsefulButton.addEventListener(MouseEvent.CLICK, shopUsefulButtonHandler);

            _sale.visible = false;
            //_shopSkipButton.visible = false;
            //_shopGetButton.visible = false;
            //_shopUsefulButton.visible = false;

            _labelContainer.mouseEnabled = false;
            _labelContainer.mouseChildren = false;
            _labelContainer.visible = false;

            // _saleDiscountLabel.styleName = "ApRemainArea";
            _saleDiscountLabel.setStyle("fontSize", 20);
            _saleDiscountLabel.setStyle("textAlign", "left");
            _saleDiscountLabel.setStyle("color",  "#ffffff");
            _saleDiscountLabel.setStyle("fontFamily",  "bradley");
            _saleDiscountLabel.setStyle("letterSpacing",  1);
            _saleDiscountLabel.setStyle("textAlign", "right");
            _saleDiscountLabel.filters = [ new GlowFilter(0x000000, 1, 1, 1, 8, 1) ];
            _saleDiscountLabel.x = 530;
            _saleDiscountLabel.y = 260;
            _saleDiscountLabel.width = _LABEL_WIDTH;
            _saleDiscountLabel.height = _LABEL_HEIGHT;
            _saleDiscountLabel.text = (Const.SALE_DISCOUNT_VALUES[Player.instance.avatar.saleType]*10).toString();
            _saleDiscountLabel.mouseEnabled = false;
            _saleDiscountLabel.mouseChildren = false;
            //addChild(_saleDiscountLabel);
            _labelContainer.addChild(_saleDiscountLabel);

            _saleRestTimeLabel.styleName = "ApRemainArea";
            _saleRestTimeLabel.setStyle("fontSize", 9);
            _saleRestTimeLabel.setStyle("textAlign", "left");
            _saleRestTimeLabel.x = 600;
            _saleRestTimeLabel.y = 263;
            _saleRestTimeLabel.width = _TIME_LABEL_WIDTH;
            _saleRestTimeLabel.height = _TIME_LABEL_HEIGHT;
            var lastTime:String = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
            _saleRestTimeLabel.text = _TRANS_AREA_SALE.replace("__SALE_TIME__",lastTime);
            _saleRestTimeLabel.mouseEnabled = false;
            _saleRestTimeLabel.mouseChildren = false;
            // // 作ったラベルをトップビューに突っ込む
            // Unlight.INS.topContainer.parent.addChild(_saleRestTimeLabel);
            //addChild(_saleRestTimeLabel);
            _labelContainer.addChild(_saleRestTimeLabel);

            addChild(_labelContainer);

            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER,updateDuration);
            _time.start();
        }

        override public function final():void
        {
            _time.stop();
            _time.removeEventListener(TimerEvent.TIMER, updateDuration);
            _time = null;

            _backButton.removeEventListener(MouseEvent.CLICK, backButtonHandler);
            _nextButton.removeEventListener(MouseEvent.CLICK, nextButtonHandler);
            _shopSkipButton.removeEventListener(MouseEvent.CLICK, shopSkipButtonHandler);
            _shopGetButton.removeEventListener(MouseEvent.CLICK, shopGetButtonHandler);
            _shopUsefulButton.removeEventListener(MouseEvent.CLICK, shopUsefulButtonHandler);
            _nextFunc = null;
            _backFunc = null;
            _shopSkipFunc = null;
            _shopGetFunc = null;
            _shopUsefulFunc = null;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {

        }

        private function backButtonHandler(e:Event):void
        {
            if(_backFunc != null){_backFunc()}
        }
        private function nextButtonHandler(e:Event):void
        {
            if(_nextFunc != null){_nextFunc()}
        }
        private function shopSkipButtonHandler(e:Event):void
        {
            if(_shopSkipFunc != null){_shopSkipFunc()}
        }
        private function shopGetButtonHandler(e:Event):void
        {
            if(_shopGetFunc != null){_shopGetFunc()}
        }
        private function shopUsefulButtonHandler(e:Event):void
        {
            if(_shopUsefulFunc != null){_shopUsefulFunc()}
        }


        public function setButtonFunc(bFunc:Function, nFunc:Function):void
        {
            _nextFunc = nFunc;
            _backFunc = bFunc;
        }
        public function setShopButtonFunc(sFunc:Function, gFunc:Function, uFunc:Function):void
        {
            _shopSkipFunc = sFunc;
            _shopGetFunc = gFunc;
            _shopUsefulFunc = uFunc;
        }

        public function setMaxLength(i:int):void
        {
            _maxLength = i;
            waitComplete(setMaxLengthFunc);

        }
        private function setMaxLengthFunc():void
        {
            _root.gotoAndStop(_maxLength);

        }

        public function setPage(currentPage:int, maxPage:int):void
        {
            log.writeLog(log.LV_FATAL, this,"currentPage", currentPage, "maxPage", maxPage);
            // ページが一ページしかないときはなにも出さない
            if (maxPage == 1)
            {
                _backVisible = false;
                _nextVisible = false;
            }else if (currentPage == 1) // ページが２ページ以上あり今のページが１ページ目の時バックボタンだけ消す
            {
                _backVisible = false;
                _nextVisible = true;
            }else if (currentPage == maxPage) // ページが２ページ以上ありかつ、今のページと最大ページが同じ時nextボタンを消す
            {
                _backVisible = true;
                _nextVisible = false;
            }else{
                _backVisible = true;
                _nextVisible = true;
            }
            waitComplete(setButtonVisibleFunc);

        }
        private function setButtonVisibleFunc():void
        {
            _backButton.visible = _backVisible;
            _nextButton.visible = _nextVisible;
        }
        public function shopButtonVisible(f:Boolean):void
        {
            _shopSkipVisible = f;
            _shopGetVisible = f;
            _shopUsefulVisible = f;
            waitComplete(setShopButtonVisible);
        }
        private function setShopButtonVisible():void
        {
            _shopSkipButton.visible = _shopSkipVisible;
            _shopGetButton.visible = _shopGetVisible;
            _shopUsefulButton.visible = _shopUsefulVisible;
        }

        private function updateDuration(e:Event):void
        {
            setSaleTime();
        }

        public function setViewSaleClipFlag(flag:Boolean=true):void
        {
            _sale.visible = flag;
            _labelContainer.visible = flag;
        }

        private function setSaleTime():void
        {
            _saleDiscountLabel.text = (Const.SALE_DISCOUNT_VALUES[Player.instance.avatar.saleType]*10).toString();
            var lastTime:String = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
            _saleRestTimeLabel.text = _TRANS_AREA_SALE.replace("__SALE_TIME__",lastTime);
        }

    }

}
