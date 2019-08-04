package view.image.quest
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.*;
    import view.utils.*;
    import view.image.*;

    import controller.QuestCtrl;

    /**
     * MapDataImage表示クラス
     *
     */


    public class MapDataImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/map_data.swf")]
        private var _Source:Class;
//         private static const DROP_BUTTON:String  ="btn_map_drop";
//         private static const PRESENT_BUTTON:String  ="btn_map_pres";
        private static const X:int = 0;
        private static const Y:int = 0;
        public static const TYPE_FRAME:int  = 1;
        public static const TYPE_PASS:int   = 2;
        public static const TYPE_END:int    = 3;
        public static const TYPE_START:int  = 4;

        public static const STATE_NONE:int = 0;
        public static const STATE_INPROGRESS:int = 1;

        private var _dataMC:MovieClip;
        private var _type:int;

//         private var _dropButton:SimpleButton;
//         private var _presentButton:SimpleButton;
        
        private var _ctrl:QuestCtrl = QuestCtrl.instance;
        private var _state:int;


        /**
         * コンストラクタ
         *
         */
        public function MapDataImage()
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
//             _dropButton = SimpleButton(_root.getChildByName(DROP_BUTTON));
//             _presentButton = SimpleButton(_root.getChildByName(PRESENT_BUTTON));
        }

//         public function get drop():SimpleButton
//         {
//             return SimpleButton(_root.getChildByName(DROP_BUTTON));
//         }

        public override function init():void
        {
            _ctrl.addEventListener(QuestCtrl.QUEST_INPROGRESS, improgressHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_SOLVED, solevedHandler);
        }

        public  override function final():void
        {
            _ctrl.removeEventListener(QuestCtrl.QUEST_INPROGRESS, improgressHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_SOLVED, solevedHandler);

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
//                   _dropButton.visible = true;
//                   _presentButton.visible = true;
                  break;
            case STATE_INPROGRESS:
//                   _dropButton.visible = false;
//                   _presentButton.visible = false;
                break;
            default:
            }

        }

    }

}

