package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * HP表示クラス
     *
     */


    public class HPImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/game/life_base.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function HPImage()
        {
            alpha = 0;
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            x = X;
            y = Y;
        }



    }

}
