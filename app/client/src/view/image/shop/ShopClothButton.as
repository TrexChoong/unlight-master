package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ShopItemButton表示クラス
     *
     */


    public class ShopClothButton extends ShopItemButton
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/btn_cloth.swf")]
        private var _Source:Class;
        private static const BUTTON:String = "btn_c";

        /**
         * コンストラクタ
         *
         */
        public function ShopClothButton(index:int = 3)
        {
            super(index);
        }
        override protected function get Source():Class
        {
            return _Source;
        }


        override protected function get buttonName():String
        {
            return BUTTON;
        }

    }

}
