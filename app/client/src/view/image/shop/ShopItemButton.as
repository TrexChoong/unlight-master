package view.image.shop
{
    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ShopItemButton表示クラス
     *
     */


    public class ShopItemButton extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/btn_item.swf")]
        private var _Source:Class;
        private static const X:int = 96;
        private static const Y:int = 32;
        private static const BUTTON:String = "btn_a";

        private var _chAButton :SimpleButton;
        protected var _button:SimpleButton;
        private var _index:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function ShopItemButton(index:int =0 )
        {
            super();
            _index = index;
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
            _button = SimpleButton(_root.getChildByName(buttonName));

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        protected function get buttonName():String
        {
            return BUTTON;
        }


        public function initializePos():void
        {
            x = X*_index;
            y = Y;
        }
        public function onButton():void
        {
            waitComplete(setOnButton);
        }
        public function offButton():void
        {
            waitComplete(setOffButton);
        }

        private function setOnButton():void
        {
            _button.visible = false;
        }

        private function setOffButton():void
        {
            _button.visible = true;
        }

    }

}
