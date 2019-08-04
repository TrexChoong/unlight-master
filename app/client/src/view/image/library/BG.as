package view.image.library
{

    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    import model.DeckEditor;
    import model.events.*;
    import view.image.BaseImage;
    import view.utils.*;

    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {

        // HP表示元SWF
        CONFIG::CHARA_COST_DRAW_ON {
            [Embed(source="../../../../data/image/library/library_cost.swf")]
            private var _Source:Class;
        }
        CONFIG::CHARA_COST_DRAW_OFF {
            [Embed(source="../../../../data/image/library/library.swf")]
            private var _Source:Class;
        }

        private var _ct:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
        private var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーン元にに
        private static const X:int = 0;
        private static const Y:int = 0;

        // 定数
        private static const QUEST_TAB       :String = "tab_queststory";
        private static const CHARA_STORY_TAB :String = "tab_charastory";
        private static const CHARA_CARD_TAB  :String = "tab_characard";
        private static const MONSTAR_TAB     :String = "tab_monstercard";

        private static const BACK_BTN        :String = "btn_back";
        private static const NEXT_BTN        :String = "btn_next";
        private static const STORY_BTN       :String = "btn_story";

        private static const UN_CARD_BTN       :String = "btn_select_u";
        private static const RB_CARD_BTN       :String = "btn_select_r";

        private static const QUEST_TAB_INDEX:int       = 0;
        private static const CHARA_STORY_TAB_INDEX:int = 1;
        private static const CHARA_CARD_TAB_INDEX:int  = 2;
        private static const MONSTAR_TAB_INDEX:int     = 3;

        private static const CHARA_CARD_MODE_UNLIGHT:int = 0;
        private static const CHARA_CARD_MODE_REBORN:int = 1;
        private static const CHARA_CARD_ADD_INDEX:Array = [0,2];

        private var _questTab:SimpleButton;
        private var _charaStoryTab:SimpleButton;
        private var _charaCardTab:SimpleButton;
        private var _monstarTab:SimpleButton;
        private var _backButton:SimpleButton;
        private var _nextButton:SimpleButton;
        private var _storyButton:SimpleButton;

        private var _tabClickFunc:Function;
        private var _nextClickFunc:Function;
        private var _backClickFunc:Function;

        private var _num:int;
        private var _currentNum:int;
        private var _charaCardMode:int = CHARA_CARD_MODE_UNLIGHT;

        private var _tabSet:Vector.<SimpleButton> = new Vector.<SimpleButton>();

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
            _questTab = SimpleButton(_root.getChildByName(QUEST_TAB));
            _questTab.addEventListener(MouseEvent.CLICK, tabClickHandler)
            _tabSet.push(_questTab);
            _questTab.mouseEnabled = false;
            _questTab.transform.colorTransform = _ct;

            _charaStoryTab = SimpleButton(_root.getChildByName(CHARA_STORY_TAB));
            _charaStoryTab.addEventListener(MouseEvent.CLICK, tabClickHandler)
            _tabSet.push(_charaStoryTab);

            _charaCardTab = SimpleButton(_root.getChildByName(CHARA_CARD_TAB));
            _charaCardTab.addEventListener(MouseEvent.CLICK, tabClickHandler);
            _tabSet.push(_charaCardTab);

            _monstarTab = SimpleButton(_root.getChildByName(MONSTAR_TAB));
            _monstarTab.addEventListener(MouseEvent.CLICK, tabClickHandler);
            _tabSet.push(_monstarTab);

            _backButton       = SimpleButton(_root.getChildByName(BACK_BTN));
            _nextButton       = SimpleButton(_root.getChildByName(NEXT_BTN));

            _backButton.addEventListener(MouseEvent.CLICK, backClickHandler);
            _nextButton.addEventListener(MouseEvent.CLICK, nextClickHandler);

            _storyButton      = SimpleButton(_root.getChildByName(STORY_BTN));

            _storyButton.visible = false;
            _nextButton.visible = false;
            _backButton.visible = false;

            _charaCardMode = CHARA_CARD_MODE_UNLIGHT;

            changeTab(CHARA_CARD_TAB_INDEX);
            //changeTab(5);

            //_root.gotoAndStop(1);
        }

        private function changeTab(index:int):void
        {
            for(var i:int = 0; i < _tabSet.length; i++){
                if (i == index)
                {
                    _tabSet[i].visible = false;
                }else{
                    _tabSet[i].visible = true;
                }
            }
            var setTab:int = index;
            if (index == CHARA_CARD_TAB_INDEX) setTab += CHARA_CARD_ADD_INDEX[_charaCardMode];
            _root.gotoAndStop(setTab+1);
            log.writeLog(log.LV_INFO, this, "changeTab", _tabClickFunc);
            if(_tabClickFunc != null)
            {
                _tabClickFunc.apply(this,[setTab]);
            }
        }

        public function setTabFunc(func:Function,next:Function,back:Function):void
        {
            _tabClickFunc = func;
            _nextClickFunc = next;
            _backClickFunc = back;
        }

        private function tabClickHandler(e:MouseEvent):void
        {
            changeTab(_tabSet.indexOf(e.currentTarget));
        }

        private function backClickHandler(e:MouseEvent):void
        {
            if(_backClickFunc != null)
            {
                _backClickFunc.apply(this);
            }

        }

        private function nextClickHandler(e:MouseEvent):void
        {
            if(_nextClickFunc != null)
            {
                _nextClickFunc.apply(this);
            }

        }

        override public  function final():void
        {
            _tabClickFunc = null;
            _backClickFunc = null;
            _nextClickFunc = null;
            log.writeLog(log.LV_INFO, this, "final");
        }


        override protected function get Source():Class
        {
            return _Source;
        }


        public function get back():SimpleButton
        {
            return _backButton;
        }
        public function get next():SimpleButton
        {
            return _nextButton;
        }

        public function get story():SimpleButton
        {
                return _storyButton;
        }

        public function isCharaPage(index:int):Boolean
        {
            return (CHARA_CARD_TAB_INDEX == index || CHARA_CARD_TAB_INDEX+2 == index);
        }

        public function setCharaParameter():void
        {
            waitComplete(setCharaParameterComplete);
        }

        public function setCharaParameterComplete():void
        {
            MovieClip(_root.getChildByName("parameter")).gotoAndStop("chara");
        }


        public function get isCharaPageReborn():Boolean
        {
            return (_charaCardMode == CHARA_CARD_MODE_REBORN);
        }
        public function set charaCardRebornMode(isRebornMode:Boolean):void
        {
            if (isRebornMode) {
                _charaCardMode = CHARA_CARD_MODE_REBORN;
            } else {
                _charaCardMode = CHARA_CARD_MODE_UNLIGHT;
            }
            changeTab(CHARA_CARD_TAB_INDEX);
        }


    }

}
