package view.image.quest
{

    import flash.display.*;
    import flash.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.*;
    import view.utils.*;
    import view.image.*;
    import controller.QuestCtrl;

    /**
     * SelectMapWindow表示クラス
     *
     */


    public class SelectMapWindowImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/select_map.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private static const CLOSE_BTN:String = "btn_close";
        private static const BACK_BTN:String = "btn_back";
        private static const NEXT_BTN:String = "btn_next";

        private static const NORMAL_MAP_BTN_ARR:Array = [
            "btn_map1",
            "btn_map2",
            "btn_map3",
            "btn_map4",
            "btn_map5",
            "btn_map6",
            ];
        private static const EVENT_MAP_BTN_ARR:Array = [
            "btn_event1",
            ];
        private static const TUTORIAL_MAP_BTN_ARR:Array = [
            "btn_map0",
            ];
        private static const CHARA_VOTE_MAP_BTN_ARR:Array = [
            "btn_vote",
            ];

        private var _closeButton:SimpleButton;
        private var _backButton:SimpleButton;
        private var _nextButton:SimpleButton;

        private var _normalMapButtonList:Vector.<SimpleButton> = new Vector.<SimpleButton>();
        private var _eventMapButtonList:Vector.<SimpleButton> = new Vector.<SimpleButton>();
        private var _tutorialMapButtonList:Vector.<SimpleButton> = new Vector.<SimpleButton>();
        private var _charaVoteMapButtonList:Vector.<SimpleButton> = new Vector.<SimpleButton>();

        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        private var _normalMapClickFunc:Function;
        private var _eventMapClickFunc:Function;
        private var _tutorialMapClickFunc:Function;
        private var _charaVoteMapClickFunc:Function;

        /**
         * コンストラクタ
         *
         */
        public function SelectMapWindowImage()
        {
            super();
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);

            _closeButton = SimpleButton(_root.getChildByName(CLOSE_BTN));
            _backButton  = SimpleButton(_root.getChildByName(BACK_BTN));
            _nextButton  = SimpleButton(_root.getChildByName(NEXT_BTN));
            _backButton.visible = false;
            _nextButton.visible = false;

            var i:int;
            for ( i = 0; i < NORMAL_MAP_BTN_ARR.length; i++ ) {
                var setButtom:SimpleButton = SimpleButton(_root.getChildByName(NORMAL_MAP_BTN_ARR[i]));
                setButtom.visible = false;
                _normalMapButtonList.push(setButtom);
            }
            for ( i = 0; i < EVENT_MAP_BTN_ARR.length; i++ ) {
                var setEventButtom:SimpleButton = SimpleButton(_root.getChildByName(EVENT_MAP_BTN_ARR[i]));
                setEventButtom.visible = false;
                _eventMapButtonList.push(setEventButtom);
            }
            for ( i = 0; i < TUTORIAL_MAP_BTN_ARR.length; i++ ) {
                var setTutorialButtom:SimpleButton = SimpleButton(_root.getChildByName(TUTORIAL_MAP_BTN_ARR[i]));
                setTutorialButtom.visible = false;
                _tutorialMapButtonList.push(setTutorialButtom);
            }
            for ( i = 0; i < CHARA_VOTE_MAP_BTN_ARR.length; i++ ) {
                var setCharaVoteButtom:SimpleButton = SimpleButton(_root.getChildByName(CHARA_VOTE_MAP_BTN_ARR[i]));
                setCharaVoteButtom.visible = false;
                _charaVoteMapButtonList.push(setCharaVoteButtom);
            }
        }


        public override function init():void
        {
            log.writeLog(log.LV_DEBUG, this, "init");
        }

        public  override function final():void
        {
        }

        public function get close():SimpleButton
        {
            return _closeButton;
        }

        public function setClickFunc(normalFunc:Function,eventFunc:Function,tutorialFunc:Function,charaVoteFunc:Function):void
        {
            _normalMapClickFunc = normalFunc;
            _eventMapClickFunc = eventFunc;
            _tutorialMapClickFunc = tutorialFunc;
            _charaVoteMapClickFunc = charaVoteFunc;
        }
        public function setButtonVisible(normalFlag:int,eventFlag:int=0):void
        {
            var  i:int;
            for( i = 0; i <= normalFlag; i++)
            {
                _normalMapButtonList[i].visible = true;
                _normalMapButtonList[i].addEventListener(MouseEvent.CLICK,normalMapClickHandler);
            }
            CONFIG::QUEST_EVENT_ON
            {
                for( i = 0; i <= eventFlag; i++)
                {
                    _eventMapButtonList[i].visible = true;
                    _eventMapButtonList[i].addEventListener(MouseEvent.CLICK,eventMapClickHandler);
                }
            }
            for ( i = 0; i < TUTORIAL_MAP_BTN_ARR.length; i++ ) {
                _tutorialMapButtonList[i].visible = true;
                _tutorialMapButtonList[i].addEventListener(MouseEvent.CLICK,tutorialMapClickHandler);
            }
            CONFIG::QUEST_CHARA_VOTE_ON
            {
                for ( i = 0; i < CHARA_VOTE_MAP_BTN_ARR.length; i++ ) {
                    _charaVoteMapButtonList[i].visible = true;
                    _charaVoteMapButtonList[i].addEventListener(MouseEvent.CLICK,charaVoteMapClickHandler);
                }
            }
        }

        private function normalMapClickHandler(e:MouseEvent):void
        {
            var idx:int = _normalMapButtonList.indexOf(e.target);
            log.writeLog(log.LV_DEBUG, this, "map icon click!!!!!!!!!!!!!!!!!!!!!!!!!", idx);
            if (_normalMapClickFunc != null) {
                _normalMapClickFunc(idx);
            }
        }
        private function eventMapClickHandler(e:MouseEvent):void
        {
            var idx:int = _eventMapButtonList.indexOf(e.target);
            log.writeLog(log.LV_DEBUG, this, "event map icon click!!!!!!!!!!!!!!!!!!!!!!!!!", idx);
            if (_eventMapClickFunc != null) {
                _eventMapClickFunc(idx);
            }
        }
        private function tutorialMapClickHandler(e:MouseEvent):void
        {
            var idx:int = _tutorialMapButtonList.indexOf(e.target);
            log.writeLog(log.LV_DEBUG, this, "tutorial map icon click!!!!!!!!!!!!!!!!!!!!!!!!!", idx);
            if (_tutorialMapClickFunc != null) {
                _tutorialMapClickFunc(idx);
            }
        }
        private function charaVoteMapClickHandler(e:MouseEvent):void
        {
            var idx:int = _charaVoteMapButtonList.indexOf(e.target);
            log.writeLog(log.LV_DEBUG, this, "charaVote map icon click!!!!!!!!!!!!!!!!!!!!!!!!!", idx);
            if (_charaVoteMapClickFunc != null) {
                _charaVoteMapClickFunc(idx);
            }
        }


    }

}

