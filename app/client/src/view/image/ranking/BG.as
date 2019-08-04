package view.image.ranking
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */

    public class BG extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/ranking/entrance_rank.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private const RANKING:String = "ranking"

        private var _bg:MovieClip;
        private var _totalDuelTab:SimpleButton;
        private var _weeklyDuelTab:SimpleButton;
        private var _totalQuestTab:SimpleButton;
        private var _weeklyQuestTab:SimpleButton;
        private var _totalEventTab:SimpleButton;
        private var _baseEventTab:SimpleButton;
        private var _tabSet:Array; /* of SimpleButton */ 
        private var _nextButton:SimpleButton;
        private var _prevButton:SimpleButton;
        private var _top:MovieClip;

        private const TOTAL_QUEST_TAB_INDEX:int = 3;
        private const TOTAL_EVENT_TAB_INDEX:int = 4;

//        ranking(btn_bp_all,btn_bp_week,btn_qp_all,btn_qp_week,
//                btn_back,btn_next,top)
        private var _num:int = 0;

        private var _tabFunc:Function;
        private var _nextFunc:Function;
        private var _prevFunc:Function;

        /**
         * コンストラクタ
         *
         */

        public function BG()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _bg = MovieClip(_root.getChildByName(RANKING));

            _weeklyDuelTab = SimpleButton(_bg.getChildByName("btn_bp_week"));
            _totalDuelTab = SimpleButton(_bg.getChildByName("btn_bp_all"));

            _weeklyQuestTab = SimpleButton(_bg.getChildByName("btn_qp_week"));
            _totalQuestTab = SimpleButton(_bg.getChildByName("btn_qp_all"));

            _totalEventTab = SimpleButton(_bg.getChildByName("btn_event"));

            _nextButton = SimpleButton(_bg.getChildByName("btn_next"));
            _prevButton = SimpleButton(_bg.getChildByName("btn_back"));

            _tabSet = [_weeklyDuelTab, _totalDuelTab, _totalQuestTab, _weeklyQuestTab, _totalEventTab];
            _tabSet.forEach(function(item:*, index:int, array:Array):void{item.addEventListener(MouseEvent.CLICK, tabClickHandler)});

            _totalDuelTab.visible = false;

            CONFIG::RANK_EVENT_OFF
            {
                _totalEventTab.mouseEnabled = false;
                //_totalEventTab.mouseChildren = false;
            }
            CONFIG::RANK_EVENT_ON
            {
                _totalDuelTab.visible = true;
                _totalEventTab.visible = false;
            }
            CONFIG::CHARA_VOTE_ON
            {
                _totalDuelTab.visible = true;
                _totalEventTab.visible = false;
                //_totalEventTab.mouseChildren = false;
            }

            _nextButton.addEventListener(MouseEvent.CLICK, nextHandler);
            _prevButton.addEventListener(MouseEvent.CLICK, prevHandler);
            _top = MovieClip(_bg.getChildByName("top"));
        }

        override protected function get Source():Class
        {
            return _Source;
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

        private function tabClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_WARN, this, _tabSet.indexOf(SimpleButton(e.target)),_tabSet.length);

            for(var i:int = 0; i < _tabSet.length; i++){
                _tabSet[i].visible = (i!=_tabSet.indexOf(SimpleButton(e.target)));
            }

            if (_tabFunc !=null)
            {
                _tabFunc(_tabSet.indexOf(SimpleButton(e.target)));
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

        public function setPage(p:int):void
        {
            if(p == 0)
            {
                _top.visible = true;
            }else{
                _top.visible = false;
            }
        }


    }

}
