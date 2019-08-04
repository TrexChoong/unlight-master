package view.image.edit
{

    import flash.display.*;
    import flash.events.Event;
    import model.DeckEditor;
    import model.events.*;
    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {
        // HP表示元SWF
        CONFIG::CHARA_COST_DRAW_ON {
            [Embed(source="../../../../data/image/edit/edit_deck_base_cost.swf")]
            private var _Source:Class;
        }
        CONFIG::CHARA_COST_DRAW_OFF {
            [Embed(source="../../../../data/image/edit/edit_deck_base.swf")]
            private var _Source:Class;
        }

        private static const X:int = 0;
        private static const Y:int = 0;

        // 定数
        private static const DECK_DELETE   :String = "deckdelete";
        private static const BACK          :String = "back";
        private static const NEXT          :String = "next";
        private static const DECK_VOL      :String = "deck_vol";
        private static const DECK_VOL_POSI :String = "deck_vol_posi";
        private static const BINDER_NEXT   :String = "binder_next";
        private static const BINDER_PREV   :String = "binder_prev";
        private static const STORY         :String = "story";
        private static const COMPO         :String = "compo";
        private static const DUPE          :String = "btn_dupe";
        private static const SEARCH        :String = "search";

        private static const BOOK_CHARA      :String = "btn_bookchara";
        private static const BOOK_EQUIP      :String = "btn_bookequip";
        private static const BOOK_EVENT      :String = "btn_bookevent";
        private static const BOOK_MONSTER    :String = "btn_bookmon";
        private static const BOOK_OTHER      :String = "btn_bookother";

        private var _deckDeletebutton:SimpleButton;
        private var _backButton:SimpleButton;
        private var _nextButton:SimpleButton;
        private var _binderPrevButton:SimpleButton;
        private var _binderNextButton:SimpleButton;
        private var _storyButton:SimpleButton;
        private var _compoButton:SimpleButton;
        private var _dupeButton:SimpleButton;
        private var _bookEventButton:SimpleButton;
        private var _bookEquipButton:SimpleButton;
        private var _bookCharaButton:SimpleButton;
        private var _bookMonsterButton:SimpleButton;
        private var _bookOtherButton:SimpleButton;

        private var _deckVol:MovieClip;
        private var _deckVolPosi:MovieClip;
        private var _searchMC:MovieClip;
        private var _searchVisible:Boolean = false;

        private var _num:int;
        private var _currentNum:int;
        // エディットインスタンス
        private var _deckEdit:DeckEditor = DeckEditor.instance;

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
            _root.getChildByName(STORY).visible=false;
            _root.getChildByName(COMPO).visible=false;
            _root.getChildByName(DUPE).visible=false;
            initializePos();
            _deckVol = MovieClip(_root.getChildByName("deck_vol"));
            _deckVolPosi = MovieClip(_root.getChildByName("deck_vol_posi"));
            _deckEdit.addEventListener(DeckEditor.INDEX_CHANGE, deckChangeHandler);

            _searchMC = MovieClip(_root.getChildByName(SEARCH));
            _searchMC.visible = _searchVisible;

            _deckDeletebutton  = SimpleButton(_root.getChildByName(DECK_DELETE));
            _backButton        = SimpleButton(_root.getChildByName(BACK));
            _nextButton        = SimpleButton(_root.getChildByName(NEXT));
            _binderPrevButton  = SimpleButton(_root.getChildByName(BINDER_PREV));
            _binderNextButton  = SimpleButton(_root.getChildByName(BINDER_NEXT));
            _storyButton       = SimpleButton(_root.getChildByName(STORY));
            _dupeButton        = SimpleButton(_root.getChildByName(DUPE));
            _compoButton       = SimpleButton(_root.getChildByName(COMPO));
            _bookEventButton   = SimpleButton(_root.getChildByName(BOOK_EVENT));
            _bookEquipButton   = SimpleButton(_root.getChildByName(BOOK_EQUIP));
            _bookCharaButton   = SimpleButton(_root.getChildByName(BOOK_CHARA));
            _bookMonsterButton = SimpleButton(_root.getChildByName(BOOK_MONSTER));
            _bookOtherButton   = SimpleButton(_root.getChildByName(BOOK_OTHER));

        }
        override public  function final():void
        {
            _deckEdit.removeEventListener(DeckEditor.INDEX_CHANGE, deckChangeHandler)


        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
        }

        public function get deckDelete():SimpleButton
        {
            return _deckDeletebutton;
        }
        public function get back():SimpleButton
        {
            return _backButton;
        }
        public function get next():SimpleButton
        {
            return _nextButton;
        }
        public function get binderNext():SimpleButton
        {
            return _binderPrevButton;
        }
        public function get binderPrev():SimpleButton
        {
            return _binderNextButton;
        }
        public function get compo():SimpleButton
        {
            return _compoButton;
        }

        public function get tabEvent():SimpleButton
        {
            return _bookEventButton;
        }
        public function get tabEquip():SimpleButton
        {
            return _bookEquipButton;
        }
        public function get tabChara():SimpleButton
        {
            return _bookCharaButton;
        }
        public function get tabMonster():SimpleButton
        {
            return _bookMonsterButton;
        }
        public function get tabOther():SimpleButton
        {
            return _bookOtherButton;
        }

        public function set deckNum(i:int):void
        {
            _num = i;
            waitComplete(deckPosUpdate);
        }
        public function get story():SimpleButton
        {
                return _storyButton;
        }
        public function get dupe():SimpleButton
        {
                return _dupeButton;
        }


        public function set currentNum(i:int):void
        {
            _currentNum = i;
            waitComplete(deckPosUpdate)
        }

        public function setCharaParameter():void
        {
            waitComplete(setCharaParameterComplete);
        }

        public function setCharaParameterComplete():void
        {
            MovieClip(_root.getChildByName("parameter")).gotoAndStop("chara");
        }

        public function setEquipParameter():void
        {
            waitComplete(setEquipParameterComplete);
        }

        public function setEquipParameterComplete():void
        {
            MovieClip(_root.getChildByName("parameter")).gotoAndStop("equip");
        }

        public function setEventParameter():void
        {
            waitComplete(setEventParameterComplete);
        }

        public function setEventParameterComplete():void
        {
            MovieClip(_root.getChildByName("parameter")).gotoAndStop("event");
        }

        public function setMonsterParameter():void
        {
            waitComplete(setMonsterParameterComplete);
        }

        public function setMonsterParameterComplete():void
        {
            MovieClip(_root.getChildByName("parameter")).gotoAndStop("chara");
        }

        public function setOtherParameter():void
        {
            waitComplete(setOtherParameterComplete);
        }

        public function setOtherParameterComplete():void
        {
            MovieClip(_root.getChildByName("parameter")).gotoAndStop("chara");
        }


        private function deckPosUpdate():void
        {
            _deckVol.gotoAndStop(_num-1);
            _deckVolPosi.gotoAndStop(_currentNum);
        }

        private function deckChangeHandler(e:Event):void
        {
            _num = _deckEdit.deckNum;
            _currentNum = _deckEdit.selectIndex;
            waitComplete(deckPosUpdate)
        }

        public function set search(f:Boolean):void
        {
            _searchVisible = f;
            waitComplete(setSearchVisible);
        }
        private function setSearchVisible():void
        {
            _searchMC.visible = _searchVisible;
        }

    }

}
