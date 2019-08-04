package view.image.library
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import view.image.BaseImage;

    /**
     * お気に入りマーク表示クラス
     *
     */


    public class FavoriteMark extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/library/btn_deco.swf")]
        private var _Source:Class;

        private static const BTN:String = "btn_deco";

        private var _button:SimpleButton;
        private var _clickFunc:Function;
        private var _buttonVisible:Boolean = true;


        /**
         * コンストラクタ
         *
         */
        public function FavoriteMark()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            _button = SimpleButton(_root.getChildByName(BTN));
            _button.addEventListener(MouseEvent.CLICK,clickHandler);
            _button.visible = _buttonVisible;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function get button():SimpleButton
        {
            return _button;
        }

        public function set clickFunc(f:Function):void
        {
            _clickFunc = f;
        }

        private function clickHandler(e:MouseEvent):void
        {
            if (_clickFunc != null) {
                _clickFunc();
            }
        }

        public function set buttonVisible(v:Boolean):void
        {
            _buttonVisible = v;
            waitComplete(setButtonVisible);
        }

        public function setButtonVisible():void
        {
            _button.visible = _buttonVisible;
        }
    }

}
