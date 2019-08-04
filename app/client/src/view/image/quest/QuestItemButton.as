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
     * ItemButton表示クラス
     *
     */


    public class QuestItemButton extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/btn_item.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private static const BUTTON_ITEM:String = "btn_map_item"; // 2

        public static const STATE_NONE:int = 0;
        public static const STATE_INPROGRESS:int = 1;

        private var _questItemButton:SimpleButton;

        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        private var _state:int;

        /**
         * コンストラクタ
         *
         */
        public function QuestItemButton()
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
            _questItemButton = SimpleButton(_root.getChildByName(BUTTON_ITEM));

        }


        public override function init():void
        {
//            log.writeLog(log.LV_FATAL, this, _questStartButton.name,_questQuitButton.name);
            _questItemButton.addEventListener(MouseEvent.CLICK,itemClickHandler);

        }

        public  override function final():void
        {
            _questItemButton.removeEventListener(MouseEvent.CLICK,itemClickHandler);

        }


        private function itemClickHandler(e:MouseEvent):void
        {
             _ctrl.showItem()
         }


    }

}

