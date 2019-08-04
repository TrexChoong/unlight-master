package view.image.edit
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * CardStock表示クラス
     *
     */


    public class CardStock extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/edit/cardstock.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function CardStock()
        {
            super();
            mouseEnabled = false;
            mouseChildren = false;
            scaleX = 1.08;
            x -= 8;
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
        }


    }

}
