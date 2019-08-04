package view.image.common
{

    import flash.display.*;
    import flash.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import model.AvatarItem;
    import view.*;
    import view.utils.*;
    import view.image.*;
    import controller.QuestCtrl;

    /**
     * ItemListButton表示クラス
     *
     */


    public class ItemListButton extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/btn_item.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private static const BUTTON_ITEM:String = "btn_map_item"; // 2

        public static const STATE_NONE:int = 0;
        public static const STATE_INPROGRESS:int = 1;

        private var _itemListButton:SimpleButton;

//        private var _ctrl:AvatarView =.instance;

        private var _state:int;

        /**
         * コンストラクタ
         *
         */
        public function ItemListButton()
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
            _itemListButton = SimpleButton(_root.getChildByName(BUTTON_ITEM));
            _itemListButton.addEventListener(MouseEvent.CLICK, itemClickHandler);
        }


        public override function init():void
        {
            log.writeLog(log.LV_DEBUG, "[ItemListButton] init.");
            // _itemListButton.addEventListener(MouseEvent.CLICK,itemClickHandler);
        }

        public  override function final():void
        {
            _itemListButton.removeEventListener(MouseEvent.CLICK,itemClickHandler);

        }


        private function itemClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, "[ItemListButton] itemClickHandler.");
            ItemListView.show();
//            _ctrl.showItem()
         }

        public function setSelectTabIndex( index:int = 0 ):void
        {
            ItemListView.setSelectTabIndex(index);
        }

    }

}

