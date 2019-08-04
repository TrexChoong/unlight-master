package view.image.shop
{

    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Player;
    import view.image.BaseImage;

    /**
     * ShopInventoryImage表示クラス
     *
     */


    public class ShopInventoryImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/shop.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private var _saleMC:MovieClip;

        private var _saleRestTimeLabel:Label = new Label();
        private static const _SALE_TIME_LABEL_X:int = 620;
        private static const _SALE_TIME_LABEL_Y:int = 57;
        private static const _TIME_LABEL_WIDTH:int  = 100;
        private static const _TIME_LABEL_HEIGHT:int = 30;

        private var _time:Timer;  // セール監視用タイマー

        /**
         * コンストラクタ
         *
         */
        public function ShopInventoryImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            _saleMC = MovieClip(_root.getChildByName("sale"));
            _saleMC.visible = false;

            _saleRestTimeLabel.styleName = "ResultLabel";
            _saleRestTimeLabel.setStyle("fontSize", 24);
            _saleRestTimeLabel.setStyle("textAlign", "left");
            _saleRestTimeLabel.x = _SALE_TIME_LABEL_X;
            _saleRestTimeLabel.y = _SALE_TIME_LABEL_Y;
            _saleRestTimeLabel.width = _TIME_LABEL_WIDTH;
            _saleRestTimeLabel.height = _TIME_LABEL_HEIGHT;
            _saleRestTimeLabel.filters  = [new GlowFilter(0x000000, 1, 1, 1, 8, 1),
                                           new DropShadowFilter(8, 270, 0x000000, 0.1, 4, 4, 1, 1, true),
                                           new DropShadowFilter(2, 45, 0x000000, 0.5, 1, 1, 1, 1, false),];
            _saleRestTimeLabel.text = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
            _saleRestTimeLabel.visible = false;
            _saleRestTimeLabel.mouseEnabled = false;
            addChild(_saleRestTimeLabel);

            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER, updateDuration);
            _time.start();

            initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
        }

        private function updateDuration(e:Event):void
        {
            _saleRestTimeLabel.text = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
        }

        public function setSaleMCVisibleFlag(flag:Boolean=true):void
        {
            _saleMC.visible = flag;
            _saleRestTimeLabel.visible = flag;
        }

        public function getHideSaleMCThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_saleMC, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_saleRestTimeLabel, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            return pExec
        }

    }

}
