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
     * BG表示クラス
     *
     */


    public class QuestBG extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/quest_base.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
//         private static const BUTTON_START:String = "btn_deck_start";
//         private static const BUTTON_QUIT:String = "btn_deck_giveup";
//         private static const BUTTON_SUSPEND:String = "btn_deck_suspend";
        private static const BUTTON_NEXT_DECK:String = "btn_deck_next";
        private static const BUTTON_BACK_DECK:String = "btn_deck_back";
//         private static const BUTTON_ITEM:String = "btn_deck_item";
        private static const SELECT_MAP:String = "selectmap";

        public static const STATE_NONE:int = 0;
        public static const STATE_INPROGRESS:int = 1;


//         private var _questStartButton:SimpleButton;
//         private var _questQuitButton:SimpleButton;
//         private var _questSuspendButton:SimpleButton;
        private var _backDeckButton:SimpleButton;
        private var _nextDeckButton:SimpleButton;
//         private var _questItemButton:SimpleButton;
        private var _selectMapButtom:SimpleButton;

        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        private var _state:int;

        /**
         * コンストラクタ
         *
         */
        public function QuestBG()
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
//             _questStartButton = SimpleButton(_root.getChildByName(BUTTON_START));
//             _questQuitButton = SimpleButton(_root.getChildByName(BUTTON_QUIT));
//             _questSuspendButton = SimpleButton(_root.getChildByName(BUTTON_SUSPEND));
//             _questItemButton = SimpleButton(_root.getChildByName(BUTTON_ITEM));
            _backDeckButton = SimpleButton(_root.getChildByName(BUTTON_BACK_DECK));
            _nextDeckButton = SimpleButton(_root.getChildByName(BUTTON_NEXT_DECK));
            _selectMapButtom = SimpleButton(_root.getChildByName(SELECT_MAP));

//            RemoveChild.apply(_questSuspendButton);
            changeStateImage();
        }


        public override function init():void
        {
//            log.writeLog(log.LV_FATAL, this, _questStartButton,_questQuitButton);
//             _questStartButton.addEventListener(MouseEvent.CLICK,startClickHandler);
//             _questQuitButton.addEventListener(MouseEvent.CLICK,quitClickHandler);
//             _questItemButton.addEventListener(MouseEvent.CLICK,itemClickHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_INPROGRESS, improgressHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_SOLVED, solevedHandler);
        }

        public  override function final():void
        {
//             _questStartButton.removeEventListener(MouseEvent.CLICK,startClickHandler);
//             _questQuitButton.removeEventListener(MouseEvent.CLICK,quitClickHandler);
//             _questItemButton.removeEventListener(MouseEvent.CLICK,itemClickHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_INPROGRESS, improgressHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_SOLVED, solevedHandler);

        }

        public function get back():SimpleButton
        {
            return _backDeckButton;
        }
        public function get next():SimpleButton
        {
            return _nextDeckButton;
        }
        public function get selectMap():SimpleButton
        {
            return _selectMapButtom;
        }

        private function startClickHandler(e:MouseEvent):void
        {
            _ctrl.startQuest()
        }

        private function quitClickHandler(e:MouseEvent):void
        {
            _ctrl.quitQuest()
        }

        private function itemClickHandler(e:MouseEvent):void
        {
            _ctrl.showItem()
        }

        private function improgressHandler(e:Event):void
        {
            changeState(STATE_INPROGRESS);
        }

        private function solevedHandler(e:Event):void
        {
            changeState(STATE_NONE);
        }


        public function changeState(i:int):void
        {
            _state = i;
            waitComplete(changeStateImage);
        }


        private function changeStateImage():void
        {
            switch (_state)
            {
              case STATE_NONE:
//                   _questQuitButton.visible = false;
//                   _questItemButton.visible = true;
//                   _questStartButton.visible = true;
                  _backDeckButton.visible = true;
                  _nextDeckButton.visible = true;
                  break;
            case STATE_INPROGRESS:
//                 _questQuitButton.visible = true;
//                 _questItemButton.visible = true;
//                 _questStartButton.visible = false;
                _backDeckButton.visible = false;
                _nextDeckButton.visible = false;
                break;
            default:
                   
            }
        }


    }

}

