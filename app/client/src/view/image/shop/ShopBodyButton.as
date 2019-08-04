package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ShopItemButton表示クラス
     *
     */


    public class ShopBodyButton extends ShopItemButton
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/btn_body.swf")]
        private var _Source:Class;
        private static const BUTTON:String = "btn_b";

        /**
         * コンストラクタ
         *
         */
        public function ShopBodyButton(index:int = 2)
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
