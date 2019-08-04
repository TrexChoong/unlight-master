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
    import view.utils.SwfNameInfo;



    /**
     * FriendListButton表示クラス
     *
     */

    public class FriendListImage extends BaseImage
    {

        // 表示元SWF
        {
            [Embed(source="../../../../data/image/friend/friendlist.swf")]
                private var _Source:Class;
        }

        private static const TAB_FRIEND:int  = 0;
        private static const TAB_WAITING:int = 1;
        private static const TAB_BLOCKING:int= 2;
        private static const TAB_SEARCH:int  = 3;
        private static const TAB_SIZE:int    = 4;

        private static const CLOSE:String = "btn_close"
//         private static const CHECK_ALL:String = "btn_checkall"
//         private static const CHECK_OFF:String = "btn_checkoff"
        private static const BTN_BACK:String = "btn_back"
        private static const BTN_NEXT:String = "btn_next"
        private static const BTN_A:String = "tab_a"
        // private static const BTN_B:String = "tab_b"
        private static const BTN_C:String = "tab_c"
        private static const BTN_D:String = "tab_d"
        private static const BTN_E:String = "tab_f"

        private var _closeButton:SimpleButton;
        private var _joinButton:SimpleButton;
        private var _tabSet:Vector.<SimpleButton> = new Vector.<SimpleButton>();
        private var _nextButton:SimpleButton;
        private var _prevButton:SimpleButton;

        private var _frinedOnly:Boolean = false;

        private var _closeFunc:Function;
        private var _tabFunc:Function;
        private var _nextFunc:Function;
        private var _prevFunc:Function;

        private var _nextVisible:Boolean = false;
        private var _prevVisible:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function FriendListImage()
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


            _tabSet.push(SimpleButton(_root.getChildByName(BTN_A)));
            _tabSet[TAB_FRIEND].addEventListener(MouseEvent.CLICK, tabClickHandler);
            _tabSet[TAB_FRIEND].visible = false;

            // _tabSet.push(SimpleButton(_root.getChildByName(BTN_B)));
            // _tabSet[TAB_SNS].addEventListener(MouseEvent.CLICK, tabClickHandler);
            // _tabSet[TAB_SNS].visible = true;
            // // _tabSet[TAB_SNS].visible = false;
            // _tabSet[TAB_SNS].enabled = false;
            // _tabSet[TAB_SNS].mouseEnabled = false;

            _tabSet.push(SimpleButton(_root.getChildByName(BTN_C)));
            _tabSet[TAB_WAITING].addEventListener(MouseEvent.CLICK, tabClickHandler);
            _tabSet[TAB_WAITING].visible = true;

            _tabSet.push(SimpleButton(_root.getChildByName(BTN_D)));
            _tabSet[TAB_BLOCKING].addEventListener(MouseEvent.CLICK, tabClickHandler);
            _tabSet[TAB_BLOCKING].visible = true;

            _tabSet.push(SimpleButton(_root.getChildByName(BTN_E)));
            _tabSet[TAB_SEARCH].addEventListener(MouseEvent.CLICK, tabClickHandler);
            _tabSet[TAB_SEARCH].visible = true;
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
            if(!_frinedOnly)
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
        }

        public function tabReset():void
        {
            for(var i:int = 0; i < _tabSet.length; i++){
                _tabSet[i].visible = (i!= 0);
            }
        }

        public function setTabEnableFriedOnly(b:Boolean):void
        {
            log.writeLog(log.LV_WARN, this,"FRIEND ONLY",b);
            _frinedOnly = b;
            waitComplete(tabEnableFriendOnly);
        }
        private function tabEnableFriendOnly():void
        {
            if (_frinedOnly)
            {
                _tabSet[0].visible = false;
                _tabFunc(0);
                _frinedOnly = true;
                for(var i:int = 1; i < TAB_SIZE; i++){
                    _tabSet[i].enabled = false;
                    _tabSet[i].visible = true;
                }
            }else{
                _tabFunc(0);
                _frinedOnly = false;
                for(var j:int = 1; j < TAB_SIZE; j++){
                    _tabSet[j].enabled = true;
                }
            }
        }

        public function set nextVisible(f:Boolean):void
        {
            _nextVisible = f;
            waitComplete(setNextVisible);
        }
        private function setNextVisible():void
        {
            _nextButton.visible = _nextVisible;
        }
        public function set prevVisible(f:Boolean):void
        {
            _prevVisible = f;
            waitComplete(setPrevVisible);
        }
        private function setPrevVisible():void
        {
            _prevButton.visible = _prevVisible;
        }


    }

}
