package view.image.item
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * PanelItemInventoryImage表示クラス
     *
     */


    public class WindowItemInventoryBaseImage extends BaseImage implements IItemBase
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/item/itemwin_itembase.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function WindowItemInventoryBaseImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function onEquip():void
        {
        }

        private function onEquipComplete():void
        {
        }

        public function offEquip():void
        {
        }

        private function offEquipComplete():void
        {
        }

        public function onSelect():void
        {
            waitComplete(onSelectComplete);
        }

        private function onSelectComplete():void
        {
            _root.getChildByName("btn_base").visible = false;
        }

        public function offSelect():void
        {
            waitComplete(offSelectComplete);
        }

        private function offSelectComplete():void
        {
            _root.getChildByName("btn_base").visible = true;
        }

    }
}
