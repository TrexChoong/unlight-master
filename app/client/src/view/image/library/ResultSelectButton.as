package view.image.library
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import view.image.BaseImage;

    /**
     * リザルトマーク表示クラス
     *
     */


    public class ResultSelectButton extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/library/btn_deco_result.swf")]
        private var _Source:Class;

        private static const BTN_A:String = "btn_deco_result_a";
        private static const BTN_B:String = "btn_deco_result_b";
        private static const BTN_C:String = "btn_deco_result_c";

        public static const BTN_STATE_A:int = 0;
        public static const BTN_STATE_B:int = 1;
        public static const BTN_STATE_C:int = 2;

        private var _button_state:int = BTN_STATE_A;
        private static const MAX_STATE:int = 1;

        private var _button_a:SimpleButton;
        private var _button_b:SimpleButton;
        private var _button_c:SimpleButton;
        private var _clickFunc:Function;
        private var _buttonVisible:Boolean = false;


        /**
         * コンストラクタ
         *
         */
        public function ResultSelectButton()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            _button_a = SimpleButton(_root.getChildByName(BTN_A));
            _button_b = SimpleButton(_root.getChildByName(BTN_B));
            _button_c = SimpleButton(_root.getChildByName(BTN_C));
            _button_a.addEventListener(MouseEvent.CLICK,clickHandler);
            _button_b.addEventListener(MouseEvent.CLICK,clickHandler);
            _button_c.addEventListener(MouseEvent.CLICK,clickHandler);
            buttonVisible();
        }

        public function setNextImage():int
        {
            if (_button_state == MAX_STATE)
            {
                _button_state = 0;
            }
            else
            {
                _button_state += 1;
            }
            buttonVisible();
            return _button_state;
        }

        public function setButtonState(state:int):void
        {
            _button_state = state;
            buttonVisible();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function get button_a():SimpleButton
        {
            return _button_a;
        }

        public function get button_b():SimpleButton
        {
            return _button_b;
        }

        public function get button_c():SimpleButton
        {
            return _button_c;
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

        public function buttonVisible():void
        {
            waitComplete(setButtonVisible);
        }

        private function setButtonVisible():void
        {
            switch (_button_state) {
            case BTN_STATE_A:
                _button_a.visible = true;
                _button_b.visible = false;
                _button_c.visible = false;
                break;
            case BTN_STATE_B:
                _button_a.visible = false;
                _button_b.visible = true;
                _button_c.visible = false;
                break;
            case BTN_STATE_C:
                _button_a.visible = false;
                _button_b.visible = false;
                _button_c.visible = true;
                break;
            }

        }
    }

}
