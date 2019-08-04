package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * リザルトのOKボタン
     *
     */

    public class ResultButton extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/game/result/result_ok.swf")]
        private var _Source:Class;
        private static const _X:int = 180;
        private static const _Y:int = 435;
        private var _butonDownFunc:Function;
        private var _buttonEnabled:Boolean;

        /**
         * コンストラクタ
         *
         */
        public function ResultButton()
        {
            super();
            x = _X;
            y = _Y;
            mouseEnabled = false;
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
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
            }
            waitComplete(func);
        }
    }

}
