package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ShopItemButton表示クラス
     *
     */


    public class ShopAccButton extends ShopItemButton
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/btn_acc.swf")]
        private var _Source:Class;
        private static const BUTTON:String = "btn_d";

        /**
         * コンストラクタ
         *
         */
        public function ShopAccButton(index:int = 4)
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

