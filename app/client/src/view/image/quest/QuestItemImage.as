package view.image.quest
{

    import flash.display.*;
    import flash.events.Event;

    import model.Quest;
    import view.image.BaseImage;
    import view.utils.*;


    /**
     * QuestItemImage表示クラス
     *
     */


    public class QuestItemImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/list.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const BLANK:String   ="blank";
        private static const NEW:String     ="new";
        private static const ACT:String     ="act";
        private static const PRESENT:String ="present";
        private static const WAIT:String     ="wait";

        private static const DISABLE:String  ="dis";
        private static const ENABLE:String ="en";

        private static const ADVENTURE:String  ="adv";
        private static const TRESURE:String ="tre";
        private static const BOSS:String ="boss";
        private static const STATE:String   = "list_state";
        private static const SELECT:String  = "list_select";
        private static const TYPE:String  = "list_type";

//        private static const 

        private static const STATE_SET:Array = [NEW, BLANK, ACT, BLANK, WAIT,BLANK, PRESENT]; /* of  string */ 
        private static const TYPE_SET:Array = [ADVENTURE, TRESURE, BOSS]; /* of  string */ 

        private var _stateMC:MovieClip;
        private var _selectMC:MovieClip;
        private var _typeMC:MovieClip;

        private var _state:int = Const.QS_NEW;
        private var _select:Boolean = false;
        private var _type:int = Const.QT_ADVENTURE;


        /**
         * コンストラクタ
         *
         */
        public function QuestItemImage()
        {
            super();
            mouseEnabled = false;
            mouseChildren = false;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            initializePos();
            _stateMC = MovieClip(_root.getChildByName(STATE));
            _selectMC = MovieClip(_root.getChildByName(SELECT));
            _typeMC = MovieClip(_root.getChildByName(TYPE));
            changeState(Const.QS_NEW);
            changeSelect(_select);
            changeType(_type);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            
        }

        public function changeState(state:int):void
        {
            _state = state;
            waitComplete(changeStateImage)
        }

        private function changeStateImage():void
        {
            
            _stateMC.gotoAndStop(STATE_SET[_state])
        }

        public function changeSelect(select:Boolean):void
        {
            _select = select;
            waitComplete(changeSelectImage)
        }

        private function changeSelectImage():void
        {
            _select ? _selectMC.gotoAndStop("en") : _selectMC.gotoAndStop("dis")
        }


        public function changeType(type:int):void
        {
            _type = type;
            waitComplete(changeTypeImage)
        }

        private function changeTypeImage():void
        {
            
            _typeMC.gotoAndStop(TYPE_SET[_type])
        }





    }

}
