package view.image.item
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;

    import view.image.BaseImage;
    import view.utils.*;

    import model.events.SelectTabEvent;

    /**
     * ItemInventoryBaseImage表示クラス
     *
     */


    public class ItemInventoryPanelImage extends BasePanelImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/item/item_panel.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        public static const PAGE_NEXT:String = "page_next";
        public static const PAGE_BACK:String = "page_back";
        public static const PAGE_FIRST:String = "page_first";
        public static const PAGE_END:String = "page_end";


        private var _tabs:Array;
        private var _names:Array = [];

        private static const _TAB_BASE:Array = ["tab_base_a","tab_base_b","tab_base_c","tab_base_d","tab_base_e"];
        private static const _TAB_ON:Array = ["tab_a","tab_b","tab_c","tab_d","tab_e"];

        private static const _BTN_FIRST:String = "btn_p_first";
        private static const _BTN_BACK:String = "btn_p_back";
        private static const _BTN_NEXT:String = "btn_p_next";
        private static const _BTN_END:String = "btn_p_end";

        public static const USE_ITEM:String = "use_item";
        public static const REMOVE_PART:String = "remove_part";
        public static const DROP_PART:String = "drop_part";

        private static const _BTN_USE:String = "btn_use";
        private static const _BTN_REMOVE:String = "btn_remove";
        private static const _BTN_SELL:String = "btn_sell";
        private static const _BTN_DROP:String = "btn_drop";

        private var _onceClick:Boolean = false;

        private var _pageFirstButton:SimpleButton;
        private var _pageEndButton:SimpleButton;
        private var _pageNextButton:SimpleButton;
        private var _pageBackButton:SimpleButton;

        private var _backButtonEnabled:Boolean = false;
        private var _nextButtonEnabled:Boolean = false;

        private var _dropButton:SimpleButton;

        /**
         * コンストラクタ
         *
         */
        public function ItemInventoryPanelImage(tabs:Array)
        {
//             Unlight.GCW.watch(this);
//            log.writeLog(log.LV_FATAL, this, "panel create tab array is", tabs);
            _tabs = tabs;
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializeTab();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializeTab():void
        {
            for(var i:int = 0; i < _TAB_BASE.length; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "panel create tab array is", _tabs,_tabs.length);
                if(i < _tabs.length)
                {
                    _names.push(new Text());
                    _names[i].x = 38 + 96 * i;
                    _names[i].y = 63;
                    _names[i].width = 80;
                    _names[i].height = 30;

                    _names[i].text = _tabs[i];
                    _names[i].styleName = "ItemListPanelTabLabel";

                    _names[i].mouseChildren = false;
                    _names[i].mouseEnabled = false;

                    log.writeLog(log.LV_INFO, this, "names", _names[i].text);
                    addChild(_names[i]);

//                    _root.getChildByName(_TAB_BASE[i]).addEventListener(MouseEvent.CLICK, tabClickHandler);
                    _root.getChildByName(_TAB_ON[i]).addEventListener(MouseEvent.CLICK, tabClickHandler);
                }
                else
                {
                    _root.getChildByName(_TAB_BASE[i]).visible = false;
                    _root.getChildByName(_TAB_ON[i]).visible = false;
                }
            }
            setOptionButton();

            _pageFirstButton = SimpleButton(_root.getChildByName(_BTN_FIRST));
            _pageEndButton = SimpleButton(_root.getChildByName(_BTN_END));
            _pageNextButton= SimpleButton(_root.getChildByName(_BTN_NEXT));
            _pageBackButton = SimpleButton(_root.getChildByName(_BTN_BACK));

            _pageFirstButton.addEventListener(MouseEvent.CLICK, firstButtonClickHandler);
            _pageEndButton.addEventListener(MouseEvent.CLICK, endButtonClickHandler);
            _pageNextButton.addEventListener(MouseEvent.CLICK, nextButtonClickHandler);
            _pageBackButton.addEventListener(MouseEvent.CLICK, backButtonClickHandler);

            backButtonsEnableSet();
            nextButtonsEnableSet();
            createButton();
            _root.getChildByName(_TAB_ON[0]).visible = false;

//            log.writeLog(log.LV_FATAL, this, "!!!!!!!!!!!!!!!!!!!!!!!!!!!! length is", _names, _names.length);
        }

        protected function setOptionButton():void
        {
            _dropButton = SimpleButton(_root.getChildByName(_BTN_DROP));
            _root.getChildByName(_BTN_REMOVE).visible = false;
            _root.getChildByName(_BTN_DROP).visible = false;
            _root.getChildByName(_BTN_SELL).visible = false;

        }


        protected function createButton():void
        {
            _root.getChildByName(buttonName).visible = false;
            _root.getChildByName(_BTN_REMOVE).visible = false;
            _root.getChildByName(_BTN_DROP).visible = false;
            _root.getChildByName(buttonName).addEventListener(MouseEvent.CLICK, useClickHandler);
            _root.getChildByName(buttonName).addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _root.getChildByName(_BTN_REMOVE).addEventListener(MouseEvent.CLICK, removeClickHandler);
//            _root.getChildByName(_BTN_REMOVE).addEventListener(MouseEvent.CLICK, mouseOutHandler);
            _dropButton.addEventListener(MouseEvent.CLICK, dropClickHandler);
        }

        public override function final():void
        {
            RemoveChild.all(this);
            for(var i:int = 0; i < _TAB_BASE.length; i++)
            {
                _root.getChildByName(_TAB_ON[i]).removeEventListener(MouseEvent.CLICK, tabClickHandler);
            }
            _tabs = [];
            _pageFirstButton.removeEventListener(MouseEvent.CLICK, firstButtonClickHandler);
            _pageEndButton.removeEventListener(MouseEvent.CLICK, endButtonClickHandler);
            _pageNextButton.removeEventListener(MouseEvent.CLICK, nextButtonClickHandler);
            _pageBackButton.removeEventListener(MouseEvent.CLICK, backButtonClickHandler);

            _tabs = null;
            _names = null;
            removeButton();

        }
        protected function removeButton():void
        {
            _root.getChildByName(buttonName).removeEventListener(MouseEvent.CLICK, useClickHandler);
            _root.getChildByName(buttonName).removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _root.getChildByName(_BTN_REMOVE).removeEventListener(MouseEvent.CLICK, removeClickHandler);
        }

        protected function get buttonName():String
        {
            return _BTN_USE;
        }

        override public function onUse():void
        {
            waitComplete(onUseComplete);
        }

        private function onUseComplete():void
        {
            _root.getChildByName(buttonName).visible = true;
        }

        override public function offUse():void
        {
            waitComplete(offUseComplete);
        }

        private function offUseComplete():void
        {
            _root.getChildByName(buttonName).visible = false;
        }


        public override function onRemove():void
        {
            waitComplete(onRemoveComplete);
        }

        private function onRemoveComplete():void
        {
            _root.getChildByName(_BTN_REMOVE).visible = true;
        }

        public override function offRemove():void
        {
            waitComplete(offRemoveComplete);
        }

        private function offRemoveComplete():void
        {
            _root.getChildByName(_BTN_REMOVE).visible = false;
        }


        public  function onDrop():void
        {
            waitComplete(onDropComplete);
        }

        private function onDropComplete():void
        {
            _root.getChildByName(_BTN_DROP).visible = true;
        }

        public  function offDrop():void
        {
            waitComplete(offDropComplete);
        }

        private function offDropComplete():void
        {
            _root.getChildByName(_BTN_DROP).visible = false;
        }





        protected function useClickHandler(e:MouseEvent):void
        {
//            log.writeLog(log.LV_INFO, this, "aaaaaa");
            if (!_onceClick)
            {
                dispatchEvent(new Event(USE_ITEM));
                _onceClick = true;
            }
        }

        protected function mouseOutHandler(e:MouseEvent):void
        {
            _onceClick = false;
        }

        protected function removeClickHandler(e:MouseEvent):void
        {
//            log.writeLog(log.LV_INFO, this, "aaaaaa");
            dispatchEvent(new Event(REMOVE_PART));
        }

        private function dropClickHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(DROP_PART));
        }

        private function tabClickHandler(e:MouseEvent):void
        {
//            log.writeLog(log.LV_INFO, this, "tab",_names.length);
            for(var i:int = 0; i < _names.length; i++)
            {
//                log.writeLog(log.LV_INFO, this, "tab",_TAB_ON[i]);
                _root.getChildByName(_TAB_ON[i]).visible = true;
                if(e.currentTarget == _root.getChildByName(_TAB_ON[i]))
                {
                    _root.getChildByName(_TAB_ON[i]).visible = false;
                    dispatchEvent(new SelectTabEvent(SelectTabEvent.TAB_CHANGE, i));
                }
            }
        }

        private function firstButtonClickHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(PAGE_FIRST));
        }
        private function endButtonClickHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(PAGE_END));
        }
        private function nextButtonClickHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(PAGE_NEXT));
        }
        private function backButtonClickHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(PAGE_BACK));
        }

        override public function backButtonsEnable(b:Boolean):void
        {
            _backButtonEnabled = b;
            waitComplete(backButtonsEnableSet);

        }

        override public function nextButtonsEnable(b:Boolean):void
        {
            _nextButtonEnabled = b;
            waitComplete(nextButtonsEnableSet);

        }

        private function backButtonsEnableSet():void
        {
            _pageFirstButton.visible = _backButtonEnabled;
            _pageBackButton.visible = _backButtonEnabled;
        }

        public function nextButtonsEnableSet():void
        {
            _pageNextButton.visible = _nextButtonEnabled;
            _pageEndButton.visible = _nextButtonEnabled;
        }

    }

}
