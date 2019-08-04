package view.image.raid
{

    import flash.display.*;
    import flash.events.*;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * RaidInfoImage表示クラス
     *
     */


    public class RaidInfoImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/raid/raid_info.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const BACK_BUTTON  :String  ="btn_back";
        private static const NEXT_BUTTON  :String  ="btn_next";
        private static const START_BUTTON :String  ="btn_b_start";
        private static const GIVE_BUTTON  :String  ="btn_b_give";
        private static const DROP_BUTTON  :String  ="btn_b_drop";
        private static const URL_BUTTON   :String  ="btn_url";
        private static const TIME_LIMIT   :String  ="timelimit";

        private var _backButton:SimpleButton;
        private var _nextButton:SimpleButton;
        private var _startButton:SimpleButton;
        private var _giveButton:SimpleButton;
        private var _dropButton:SimpleButton;
        private var _urlButton:SimpleButton;
        private var _nextFunc:Function;
        private var _backFunc:Function;
        private var _startFunc:Function;
        private var _giveFunc:Function;
        private var _urlFunc:Function;
        private var _nextVisible:Boolean = false;
        private var _backVisible:Boolean = false;

        private var _limit:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function RaidInfoImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _backButton = SimpleButton(_root.getChildByName(BACK_BUTTON));
            _nextButton = SimpleButton(_root.getChildByName(NEXT_BUTTON));
            _startButton = SimpleButton(_root.getChildByName(START_BUTTON));
            _giveButton = SimpleButton(_root.getChildByName(GIVE_BUTTON));
            _dropButton = SimpleButton(_root.getChildByName(DROP_BUTTON));
            _urlButton = SimpleButton(_root.getChildByName(URL_BUTTON));

            _backButton.addEventListener(MouseEvent.CLICK, backButtonHandler);
            _nextButton.addEventListener(MouseEvent.CLICK, nextButtonHandler);
            _startButton.addEventListener(MouseEvent.CLICK, startButtonHandler);
            _giveButton.addEventListener(MouseEvent.CLICK, giveButtonHandler);
            _urlButton.addEventListener(MouseEvent.CLICK, urlButtonHandler);

            _limit   = MovieClip(_root.getChildByName(TIME_LIMIT));

            _backButton.visible = false;
            _nextButton.visible = false;
            _startButton.visible = false;
            _giveButton.visible = false;
            _dropButton.visible = false;
            _urlButton.visible = false;

            _limit.visible = false;
        }

        override public function final():void
        {
            _backButton.removeEventListener(MouseEvent.CLICK, backButtonHandler);
            _nextButton.removeEventListener(MouseEvent.CLICK, nextButtonHandler);
            _startButton.removeEventListener(MouseEvent.CLICK, startButtonHandler);
            _giveButton.removeEventListener(MouseEvent.CLICK, giveButtonHandler);
            _urlButton.removeEventListener(MouseEvent.CLICK, urlButtonHandler);
            _nextFunc = null;
            _backFunc = null;
            _startFunc = null;
            _giveFunc = null;
            _urlFunc = null;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function backButtonHandler(e:Event):void
        {
            if(_backFunc != null){_backFunc()}
        }

        private function nextButtonHandler(e:Event):void
        {
            if(_nextFunc != null){_nextFunc()}
        }

        private function startButtonHandler(e:Event):void
        {
            if(_startFunc != null){_startFunc()}
        }

        private function giveButtonHandler(e:Event):void
        {
            if(_giveFunc != null){_giveFunc()}
        }

        private function urlButtonHandler(e:Event):void
        {
            if(_urlFunc != null){_urlFunc()}
        }

        public function setBossButtonFunc(sFunc:Function, gFunc:Function, uFunc:Function):void
        {
            _startFunc = sFunc;
            _giveFunc  = gFunc;
            _urlFunc   = uFunc;
        }

        public function setRankButtonFunc(bFunc:Function, nFunc:Function):void
        {
            _nextFunc  = nFunc;
            _backFunc  = bFunc;
        }

        public function setPage(currentPage:int, maxPage:int):void
        {
            log.writeLog(log.LV_FATAL, this,"currentPage", currentPage, "maxPage", maxPage);
            // ページが一ページしかないときはなにも出さない
            if (maxPage == 1)
            {
                _backVisible = false;
                _nextVisible = false;
            }else if (currentPage == 1) // ページが２ページ以上あり今のページが１ページ目の時バックボタンだけ消す
            {
                _backVisible = false;
                _nextVisible = true;
            }else if (currentPage == maxPage) // ページが２ページ以上ありかつ、今のページと最大ページが同じ時nextボタンを消す
            {
                _backVisible = true;
                _nextVisible = false;
            }else{
                _backVisible = true;
                _nextVisible = true;
            }
            waitComplete(setButtonVisibleFunc);

        }
        private function setButtonVisibleFunc():void
        {
            _backButton.visible = _backVisible;
            _nextButton.visible = _nextVisible;
        }

        public function set bossDuelButtonVisible(v:Boolean):void
        {
            _startButton.visible = v;
            _giveButton.visible  = v;
            _urlButton.visible   = v;
        }

        public function set limit(f:Boolean):void
        {
            _limit.visible = f;
        }

    }

}
