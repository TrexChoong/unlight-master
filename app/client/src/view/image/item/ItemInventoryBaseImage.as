package view.image.item
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ItemInventoryImage表示クラス
     *
     */


    public class ItemInventoryBaseImage extends BaseImage  implements IItemBase
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/item/item_base.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function ItemInventoryBaseImage()
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
            waitComplete(onEquipComplete);
        }

        private function onEquipComplete():void
        {
            _root.getChildByName("equip").visible = true;
        }

        public function offEquip():void
        {
            waitComplete(offEquipComplete);
        }

        private function offEquipComplete():void
        {
            _root.getChildByName("equip").visible = false;
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
