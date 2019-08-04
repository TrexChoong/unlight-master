package view.image.lobby
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.core.*

    import view.image.BaseImage;
    import view.utils.*;
    /**
     * EventInfo表示クラス
     *
     */


    public class EventInfoPanelImage extends BaseImage
    {

        [Embed(source="../../../../data/image/lobby/entrance_info.swf")]
        private var _Source:Class;

        private static const CLOSE:String = "btn_close";

        private var _closeSB:SimpleButton;
        private var _closeFunc:Function = null;

        /**
         * コンストラクタ
         *
         */
        public function EventInfoPanelImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _closeSB = SimpleButton(_root.getChildByName(CLOSE));
            _closeSB.addEventListener(MouseEvent.CLICK, buttonHandler);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function setCloseFunc(f:Function):void
        {
            log.writeLog (log.LV_DEBUG,this,"!!!Set Close Func!",f);
            _closeFunc = f;
        }

        private function buttonHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_DEBUG,this,"Info Close Click!",_closeFunc);
            if (_closeFunc != null) {
                _closeFunc();
            }
        }

    }

}

