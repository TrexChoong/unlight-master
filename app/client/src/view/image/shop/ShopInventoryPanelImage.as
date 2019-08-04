package view.image.shop
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;

    import view.image.item.ItemInventoryPanelImage;

    import model.events.SelectTabEvent;

    /**
     * ShopInventoryBaseImage表示クラス
     *
     */


    public class ShopInventoryPanelImage extends ItemInventoryPanelImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/shopitem_panel.swf")]
        private var _Source:Class;


        private static const X:int = 0;
        private static const Y:int = 0;

        public static const BUY_ITEM:String = "buy_item";

        private static const _BTN_BUY:String = "btn_buy";

        /**
         * コンストラクタ
         *
         */
        public function ShopInventoryPanelImage(tabs:Array)
        {
            super(tabs);
        }

        protected override function setOptionButton():void
        {
        }

        protected override function createButton():void
        {
            _root.getChildByName(buttonName).visible = false;
            _root.getChildByName(buttonName).addEventListener(MouseEvent.CLICK, useClickHandler);
        }

        protected override function removeButton():void
        {
            _root.getChildByName(buttonName).removeEventListener(MouseEvent.CLICK, useClickHandler);
//            _root.getChildByName(_BTN_REMOVE).removeEventListener(MouseEvent.CLICK, removeClickHandler);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        protected override function get buttonName():String
        {
            return _BTN_BUY;
        }

        protected override function useClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "aaaaaa");
            dispatchEvent(new Event(BUY_ITEM));
        }

        public override function offRemove():void
        {
//            waitComplete(offRemoveComplete);
        }

        public override function onRemove():void
        {
//            waitComplete(onRemoveComplete);
        }


    }

}
