package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import mx.core.UIComponent;

    import flash.events.MouseEvent;
    import view.image.BaseImage;

    /**
     * ActionCardFrame表示クラス
     *
     */


    public class ActionCardFrame extends BaseImage
    {

        // ActionCardFrame表示元SWF
        [Embed(source="../../../../data/image/game/acframe.swf")]
        private var _Source:Class;


        /**
         * コンストラクタ
         *
         */
        public function ActionCardFrame()
        {
            super();
//            addEventListener(MouseEvent.CLICK,clickHandler);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function clickHandler(e:MouseEvent):void
        {
//           log.writeLog (log.LV_FATAL,this,"click !!!!!!!!!!!!!");

//            onDown();

        }

        public function onObverse():void
        {
            waitComplete(setObverse)
        }

        private function setObverse():void
        {
            _root.gotoAndStop(2);
        }

        public function onReverse():void
        {
            waitComplete(setReverse);
        }

        private function setReverse():void
        {
            _root.gotoAndStop(0);
        }

        public function onLReverse():void
        {
            waitComplete(setLReverse);
        }

        private function setLReverse():void
        {
            _root.gotoAndStop(3);
        }

        public function lock():void
        {
            _root.gotoAndStop(4);
        }

        public function lLock():void
        {
            _root.gotoAndStop(5);
        }
    }

}
