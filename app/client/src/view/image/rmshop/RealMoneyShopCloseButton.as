package view.image.rmshop
{

    import flash.display.*;
    import flash.events.Event;

    import mx.core.UIComponent;

    import flash.events.MouseEvent;
    import view.image.BaseImage;
    import view.RealMoneyShopView;
    import view.utils.*;


    /**
     * EventCardValue表示クラス
     *
     */

    public class RealMoneyShopCloseButton extends BaseImage
    {
        [Embed(source="../../../../data/image/rmshop/close_shop.swf")]
        private var _Source:Class;
        
        /**
         * コンストラクタ
         *
         */
        public function RealMoneyShopCloseButton()
        {
            super();
        }
        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }



    }

}
