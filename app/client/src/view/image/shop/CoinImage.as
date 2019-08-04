package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ShopItemButton表示クラス
     *
     */


    public class CoinImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/coin_price.swf")]
        private var _Source:Class;
        /**
         * コンストラクタ
         *
         */
        public function CoinImage()
        {
            super();
        }
        override protected function get Source():Class
        {
            return _Source;
        }


    }

}

