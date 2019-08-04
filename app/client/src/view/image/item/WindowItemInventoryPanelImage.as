package view.image.item
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;

    import view.image.BaseImage;
    import view.utils.*;
    import view.*;

    import model.events.SelectTabEvent;

    /**
     * WindowItemInventoryBaseImage表示クラス
     *
     */


    public class WindowItemInventoryPanelImage extends BasePanelImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/item/itemwindow.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        public static const USE_ITEM:String = "use_item";


        public static const PAGE_NEXT:String = "page_next";
        public static const PAGE_BACK:String = "page_back";

        private static const USE_BUTTON:String = "btn_use"
        private static const CLOSE_BUTTON:String = "btn_close"
//        private static const SCROLL_BAR_BASE:String = "item_sclguide"
        private static const _BTN_BACK:String = "btn_back";
        private static const _BTN_NEXT:String = "btn_next";

        private var _useButton:SimpleButton;
        private var _closeButton:SimpleButton;
//        private var _scrollBase:MovieClip;
        private var _pageNextButton:SimpleButton;
        private var _pageBackButton:SimpleButton;

        private var _backButtonEnabled:Boolean = false;
        private var _nextButtonEnabled:Boolean = false;

        private var _onceClick:Boolean = false;

        private var _closeFunc:Function;

        /**
         * コンストラクタ
         *
         */
        public function WindowItemInventoryPanelImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
//            SwfNameInfo.toLog(_root);
            _useButton = SimpleButton(_root.getChildByName(USE_BUTTON));
            _closeButton = SimpleButton(_root.getChildByName(CLOSE_BUTTON));
            //           _scrollBase = MovieClip(_root.getChildByName(SCROLL_BAR_BASE));
            _pageNextButton= SimpleButton(_root.getChildByName(_BTN_NEXT));
            _pageBackButton = SimpleButton(_root.getChildByName(_BTN_BACK));

            _useButton.visible = false;
//            _closeButton.visible = true;
//            _scrollBase.visible = false;

            _useButton.addEventListener(MouseEvent.CLICK, useClickHandler);
            _useButton.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler);
            _pageNextButton.addEventListener(MouseEvent.CLICK, nextButtonClickHandler);
            _pageBackButton.addEventListener(MouseEvent.CLICK, backButtonClickHandler);
            backButtonsEnableSet();
            nextButtonsEnableSet();

        }

        public override function final():void
        {
            _useButton.removeEventListener(MouseEvent.CLICK, useClickHandler);
            _useButton.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _closeButton.removeEventListener(MouseEvent.CLICK, closeClickHandler);
            _pageNextButton.removeEventListener(MouseEvent.CLICK, nextButtonClickHandler);
            _pageBackButton.removeEventListener(MouseEvent.CLICK, backButtonClickHandler);

        }


        override protected function get Source():Class
        {
            return _Source;
        }

        override public function onUse():void
        {
            waitComplete(onUseComplete);
        }

        private function onUseComplete():void
        {
            _useButton.visible = true;
        }

        override public function offUse():void
        {
            waitComplete(offUseComplete);
        }

        private function offUseComplete():void
        {
            _useButton.visible = false;
        }

        private function useClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "mouseClick");
            if (!_onceClick)
            {
                dispatchEvent(new Event(USE_ITEM));
                _useButton.removeEventListener(MouseEvent.CLICK, useClickHandler);
                _onceClick = true;
                new WaitThread(2000, enableClick).start();
            }
        }
        private function enableClick():void
        {
            _useButton.addEventListener(MouseEvent.CLICK, useClickHandler);
        }


        private function mouseOutHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "mouseout");
            _onceClick = false;
        }

        override public function backButtonsEnable(b:Boolean):void
        {
             _backButtonEnabled = b;
             waitComplete(backButtonsEnableSet);

        }

        override  public function nextButtonsEnable(b:Boolean):void
        {
             _nextButtonEnabled = b;
             waitComplete(nextButtonsEnableSet);

        }

        private function backButtonsEnableSet():void
        {
//             _pageFirstButton.visible = _backButtonEnabled;
             _pageBackButton.visible = _backButtonEnabled;
        }

        public function nextButtonsEnableSet():void
        {
             _pageNextButton.visible = _nextButtonEnabled;
//             _pageEndButton.visible = _nextButtonEnabled;
        }
        private function nextButtonClickHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(PAGE_NEXT));
        }
        private function backButtonClickHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(PAGE_BACK));
        }

        public function setCloseHandler(handler:Function):void
        {
            _closeFunc = handler;
        }

        public function closeClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "closeClick");
            if ( _closeFunc != null ) {
                _closeFunc();
            }
        }

    }

}
