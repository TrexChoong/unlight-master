package view.image.common
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.Text;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * AchievementButton表示クラス
     *
     */

    public class AchievementListImage extends BaseImage
    {
        [Embed(source="../../../../data/image/achievement/achievement.swf")]
        private var _Source:Class;


        private static const TAB_AVATAR:int  = 0;
        private static const TAB_DUEL:int    = 1;
        private static const TAB_QUEST:int   = 2;
        private static const TAB_EVENT:int   = 3;
        private static const TAB_FRIENDS:int = 4;
        private static const TAB_SIZE:int    = 2;

        private static const CLOSE:String = "btn_close"
        private static const BTN_BACK:String = "btn_back"
        private static const BTN_NEXT:String = "btn_next"

        private static const BTN_A:String = "tab_a"
        private static const BTN_B:String = "tab_b"
        private static const BTN_C:String = "tab_c"
        private static const BTN_D:String = "tab_d"
        private static const BTN_E:String = "tab_e"

        private var _closeButton:SimpleButton;
        private var _joinButton:SimpleButton;
        private var _tabSet:Vector.<SimpleButton> = new Vector.<SimpleButton>();
        private var _nextButton:SimpleButton;
        private var _prevButton:SimpleButton;

        private var _recordName:MovieClip;

        private var _closeFunc:Function;
        private var _tabFunc:Function;
        private var _nextFunc:Function;
        private var _prevFunc:Function;

        private var _max:int;
        private var _page:int;

        /**
         * コンストラクタ
         *
         */
        public function AchievementListImage()
        {
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            _closeButton = SimpleButton(_root.getChildByName(CLOSE));
            _closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
            _nextButton = SimpleButton(_root.getChildByName(BTN_NEXT));
            _prevButton = SimpleButton(_root.getChildByName(BTN_BACK));

            _nextButton.addEventListener(MouseEvent.CLICK, nextHandler);
            _prevButton.addEventListener(MouseEvent.CLICK, prevHandler);

            _recordName = MovieClip(_root.getChildByName("recordname"));
            _recordName.gotoAndStop(TAB_AVATAR);


            _tabSet.push(SimpleButton(_root.getChildByName(BTN_A)));
            _tabSet[TAB_AVATAR].addEventListener(MouseEvent.CLICK, tabClickHandler);
            _tabSet[TAB_AVATAR].visible = false;

            _tabSet.push(SimpleButton(_root.getChildByName(BTN_B)));
            _tabSet[TAB_DUEL].addEventListener(MouseEvent.CLICK, tabClickHandler);
            _tabSet[TAB_DUEL].visible = true;

            // _tabSet.push(SimpleButton(_root.getChildByName(BTN_C)));
            // _tabSet[TAB_QUEST].addEventListener(MouseEvent.CLICK, tabClickHandler);
            // _tabSet[TAB_QUEST].visible = true;

            // _tabSet.push(SimpleButton(_root.getChildByName(BTN_E)));
            // _tabSet[TAB_EVENT].addEventListener(MouseEvent.CLICK, tabClickHandler);
            // _tabSet[TAB_EVENT].visible = true;

            // _tabSet.push(SimpleButton(_root.getChildByName(BTN_D)));
            // _tabSet[TAB_FRIENDS].addEventListener(MouseEvent.CLICK, tabClickHandler);
            // _tabSet[TAB_FRIENDS].visible = true;

        }

        override public function final():void
        {
            _closeButton.removeEventListener(MouseEvent.CLICK, closeHandler);

            _closeFunc = null;
        }
        public function  setCloseHandler(handler:Function):void
        {
             _closeFunc = handler;
        }

        public function  setTabHandler(handler:Function):void
        {
             _tabFunc = handler;
        }

        public function  setPrevHandler(handler:Function):void
        {
             _prevFunc = handler;
        }
        public function  setNextHandler(handler:Function):void
        {
             _nextFunc = handler;
        }

        override protected function get Source():Class
       {
            return _Source;

        }

        public function closeHandler(e:MouseEvent):void
        {
            if (_closeFunc !=null)
            {
                _closeFunc();
            }

        }

        public function nextHandler(e:MouseEvent):void
        {
            if (_nextFunc !=null)
            {
                _nextFunc();
            }

        }

        public function prevHandler(e:MouseEvent):void
        {
            if (_prevFunc !=null)
            {
                _prevFunc();
            }

        }

        // タブをクリック
        private function tabClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_WARN, this, _tabSet.indexOf(SimpleButton(e.target)));

            for(var i:int = 0; i < TAB_SIZE; i++){
                _tabSet[i].visible = (i!=_tabSet.indexOf(SimpleButton(e.target)));
            }

            if (_tabFunc !=null)
            {
                _tabFunc(_tabSet.indexOf(SimpleButton(e.target)));
            }
        }
        public function pageButtonVisible(max:int , page:int):void
        {
            _max = max;
            _page = page;

            waitComplete(setPageButtonVisible);
        }

        public function setPageButtonVisible():void
        {
            if (_max == 1)
            {
                _nextButton.visible = false;
                _prevButton.visible = false;
            }
            else if (_max <= _page)
            {
                _nextButton.visible = false;
                _prevButton.visible = true;
            }else if(_page == 1)
            {
                _nextButton.visible = true;
                _prevButton.visible = false;
            }else{
                _nextButton.visible = true;
                _prevButton.visible = true;
            }

        }

        public function setRecordNameBG(type:int = 0):void
        {
            _recordName.gotoAndStop(type+1);
        }

    }

}
