package view.image.requirements
{

    import flash.display.*;
    import flash.events.*;
    import flash.utils.Timer;
    import flash.filters.GlowFilter;

    import mx.core.UIComponent;
    import mx.controls.*

    import model.Player;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * BitSaleButtonImage表示クラス
     *
     */


    public class BitSaleButtonImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/compo/compo_sale.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private const BIT_BTN:String = "btn_bit";
        private const SALE:String = "sale";

        private var _bitBtn:SimpleButton;
        private var _saleMC:MovieClip;

        private var _btnVisible:Boolean = false;
        private var _btnFunc:Function = null;

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

        public function BitSaleButtonImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            _bitBtn = SimpleButton(_root.getChildByName(BIT_BTN));
            _bitBtn.addEventListener(MouseEvent.CLICK,buttonClickHandler);
            buttonVisible = false;
            _saleMC = MovieClip(_root.getChildByName(SALE));
            _saleMC.visible = false;

            _labelContainer.mouseEnabled = false;
            _labelContainer.mouseChildren = false;
            _labelContainer.visible = false;

            _saleDiscountLabel.setStyle("fontSize", 20);
            _saleDiscountLabel.setStyle("textAlign", "left");
            _saleDiscountLabel.setStyle("color",  "#ffffff");
            _saleDiscountLabel.setStyle("fontFamily",  "bradley");
            _saleDiscountLabel.setStyle("letterSpacing",  1);
            _saleDiscountLabel.setStyle("textAlign", "right");
            _saleDiscountLabel.filters = [ new GlowFilter(0x000000, 1, 1, 1, 8, 1) ];
            _saleDiscountLabel.x = 185;
            _saleDiscountLabel.y = 257;
            _saleDiscountLabel.width = _LABEL_WIDTH;
            _saleDiscountLabel.height = _LABEL_HEIGHT;
            _saleDiscountLabel.text = (Const.SALE_DISCOUNT_VALUES[Player.instance.avatar.saleType]*10).toString();
            _saleDiscountLabel.mouseEnabled = false;
            _saleDiscountLabel.mouseChildren = false;
            _labelContainer.addChild(_saleDiscountLabel);

            _saleRestTimeLabel.styleName = "ApRemainArea";
            _saleRestTimeLabel.setStyle("fontSize", 9);
            _saleRestTimeLabel.setStyle("textAlign", "left");
            _saleRestTimeLabel.x = 253;
            _saleRestTimeLabel.y = 262
            _saleRestTimeLabel.width = _TIME_LABEL_WIDTH;
            _saleRestTimeLabel.height = _TIME_LABEL_HEIGHT;
            var lastTime:String = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
            _saleRestTimeLabel.text = _TRANS_AREA_SALE.replace("__SALE_TIME__",lastTime);
            _saleRestTimeLabel.mouseEnabled = false;
            _saleRestTimeLabel.mouseChildren = false;
            _labelContainer.addChild(_saleRestTimeLabel);

            addChild(_labelContainer);

            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER,updateDuration);
            _time.start();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        override public function final():void
        {
            _time.stop();
            _time.removeEventListener(TimerEvent.TIMER, updateDuration);
            _time = null;

            _bitBtn.removeEventListener(MouseEvent.CLICK,buttonClickHandler);
            _btnFunc = null;
        }

        public function set buttonVisible(v:Boolean):void
        {
            _btnVisible = v;
            waitComplete(setButtonVisible);
        }
        private function setButtonVisible():void
        {
            _bitBtn.visible = _btnVisible;
        }
        public function setButtonFunc(f:Function):void
        {
            _btnFunc = f;
        }
        private function buttonClickHandler(e:MouseEvent):void
        {
            if (_btnFunc != null) {
                _btnFunc();
            }
        }

        private function updateDuration(e:Event):void
        {
            setSaleTime();
        }

        public function setViewSaleClipFlag(flag:Boolean=true):void
        {
            _saleMC.visible = flag;
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
