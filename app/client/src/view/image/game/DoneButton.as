package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * OKボタン
     *
     */


    public class DoneButton extends BaseImage
    {

//         // OKボタン 表示元SWF
//         [Embed(source="../../../../data/image/ok.swf")]
        // OKボタン 表示元SWF
        [Embed(source="../../../../data/image/game/ok.swf")]
        private var _Source:Class;
        private static const _X:int = 0;
        private static const _Y:int = 0;
        private var _butonDownFunc:Function;
        private var _buttonEnabled:Boolean;
        private var _buttunOk:SimpleButton;

        /**
         * コンストラクタ
         *
         */
        public function DoneButton()
        {
            super();
            x = _X;
            y = _Y;
            mouseEnabled = false;
        }

        override protected function swfinit(event: Event): void 
        {

            super.swfinit(event);
            _buttunOk = SimpleButton(_root.getChildByName("button_ok"));
            _root.enabled =false;
            _root.mouseEnabled = false;
        }

        override protected function get Source():Class
        {
            return _Source;
        }


        public function set buttonEnabled(b:Boolean):void
        {
            _buttonEnabled = b;
            var func:Function;
            func =  function():void
            {
                _root.enabled = b;
                mouseChildren = b;
                _buttunOk.visible = b;
            }
            waitComplete(func);
        }

        public function get buttonEnabled():Boolean
        {
            return _buttonEnabled;
        }

    }

}
