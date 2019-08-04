package view.image.raid
{

    import flash.display.*;
    import flash.events.*;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * RaidListImage表示クラス
     *
     */


    public class RaidListImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/raid/raid_list_panel.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const _BTN_SORT_TIME:String = "btn_sort_time";
        private static const _BTN_SORT_NAME:String = "btn_sort_name";
        private static const _BTN_SORT_RARE:String = "btn_sort_rare";
        private static const _BTN_NEXT:String = "btn_next";
        private static const _BTN_BACK:String = "btn_back";

        private var _sortTimeButton:SimpleButton;
        private var _sortNameButton:SimpleButton;
        private var _sortRareButton:SimpleButton;
        private var _backButton:SimpleButton;
        private var _nextButton:SimpleButton;

        private var _sortTimeFunc:Function;
        private var _sortNameFunc:Function;
        private var _sortRareFunc:Function;
        private var _nextFunc:Function;
        private var _backFunc:Function;


        /**
         * コンストラクタ
         *
         */
        public function RaidListImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _sortTimeButton = SimpleButton(_root.getChildByName(_BTN_SORT_TIME));
            _sortNameButton = SimpleButton(_root.getChildByName(_BTN_SORT_NAME));
            _sortRareButton = SimpleButton(_root.getChildByName(_BTN_SORT_RARE));
            _backButton = SimpleButton(_root.getChildByName(_BTN_NEXT));
            _nextButton = SimpleButton(_root.getChildByName(_BTN_BACK));

            _sortTimeButton.addEventListener(MouseEvent.CLICK, sortTimeButtonHandler);
            _sortNameButton.addEventListener(MouseEvent.CLICK, sortNameButtonHandler);
            _sortRareButton.addEventListener(MouseEvent.CLICK, sortRareButtonHandler);
            _nextButton.addEventListener(MouseEvent.CLICK, nextButtonHandler);
            _backButton.addEventListener(MouseEvent.CLICK, backButtonHandler);
        }

        override public function final():void
        {
            _sortTimeButton.removeEventListener(MouseEvent.CLICK, sortTimeButtonHandler);
            _sortNameButton.removeEventListener(MouseEvent.CLICK, sortNameButtonHandler);
            _sortRareButton.removeEventListener(MouseEvent.CLICK, sortRareButtonHandler);
            _nextButton.removeEventListener(MouseEvent.CLICK, nextButtonHandler);
            _backButton.removeEventListener(MouseEvent.CLICK, backButtonHandler);

            _sortTimeFunc = null;
            _sortNameFunc = null;
            _sortRareFunc = null;
            _nextFunc = null;
            _backFunc = null;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function sortTimeButtonHandler(e:Event):void
        {
            if(_sortTimeFunc != null){_sortTimeFunc()}
        }
        private function sortNameButtonHandler(e:Event):void
        {
            if(_sortNameFunc != null){_sortNameFunc()}
        }
        private function sortRareButtonHandler(e:Event):void
        {
            if(_sortRareFunc != null){_sortRareFunc()}
        }
        private function nextButtonHandler(e:Event):void
        {
            if(_nextFunc != null){_nextFunc()}
        }
        private function backButtonHandler(e:Event):void
        {
            if(_backFunc != null){_backFunc()}
        }

        public function set sortTimeFunc(f:Function):void
        {
            _sortTimeFunc = f;
        }
        public function set sortNameFunc(f:Function):void
        {
            _sortNameFunc = f;
        }
        public function set sortRareFunc(f:Function):void
        {
            _sortRareFunc = f;
        }
        public function set backFunc(f:Function):void
        {
            _nextFunc = f;
        }
        public function set nextFunc(f:Function):void
        {
            _backFunc = f;
        }

        public function get nextBtn():SimpleButton
        {
            return _backButton;
        }
        public function get backBtn():SimpleButton
        {
            return _nextButton;
        }

    }

}
