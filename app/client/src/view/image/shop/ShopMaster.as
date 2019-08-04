package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ShopItemButton表示クラス
     *
     */


    public class ShopMaster extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/shopmaster00.swf")]
        private var _Source:Class;

        /**
         * コンストラクタ
         *
         */
        public function ShopMaster()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
            mouseEnabled = false;
            mouseChildren = false;
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
