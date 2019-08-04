package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ShopCardButton表示クラス
     *
     */


    public class ShopCardButton extends ShopItemButton
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/btn_card.swf")]
        private var _Source:Class;
        private static const BUTTON:String = "btn_e";

        /**
         * コンストラクタ
         *
         */
        public function ShopCardButton(index:int = 1)
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
