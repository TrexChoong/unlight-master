package view.image.title
{

    import flash.display.*;
    import flash.events.Event;
    import flash.filters.GlowFilter;

    import view.image.BaseImage;

    /**
     * HP表示クラス
     *
     */


    public class Logo extends BaseImage
    {

        private static const SCALE:Number = 0.7;
        private static const X:int = 390;
        private static const Y:int = 370;

        // HP表示元SWF
        [Embed(source="../../../../data/image/title/logo.swf")]
//        [Embed(source="../../../../data/image/logo.swf")]
        private var _Source:Class;
        // ロゴの背景（大）
        public var BG1:Shape = new Shape();
        // ロゴの背景（小）
        public var BG2:Shape = new Shape();

        /**
         * コンストラクタ
         *
         */
        public function Logo()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
            _root.alpha = 0.9;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            BG1.graphics.beginFill(0xEEEEEE);
            BG1.graphics.drawRect(0, 0, Unlight.WIDTH, 50);
            BG1.graphics.endFill();
            BG1.y = 340;
            BG1.alpha = 0.0;
            BG1.filters = [new GlowFilter(0xEEEEEE, 1, 0, 110, 4, 1),];


//             BG2.graphics.beginFill(0xDDDDDD);
//             BG2.graphics.drawRect(0, 0, 400, 60);
//             BG2.graphics.endFill();
            BG2.x = 320;
            BG2.y = 440;
            BG2.alpha = 0.0;

            alpha = 0.0;
//           blendMode = BlendMode.INVERT;

        }

        public function resetPosition():void
        {
            scaleX = SCALE;
            scaleY = SCALE;
            x = X;
            y = Y;
        }




    }

}
