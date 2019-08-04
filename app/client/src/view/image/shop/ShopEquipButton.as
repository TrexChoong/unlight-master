package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ShopItemButton表示クラス
     *
     */


    public class ShopEquipButton extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/fit_reset.swf")]
        private var _Source:Class;


        /**
         * コンストラクタ
         *
         */
        public function ShopEquipButton()
        {
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
        }

    }

}
