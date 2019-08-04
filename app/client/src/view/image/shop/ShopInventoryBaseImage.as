package view.image.shop
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    import view.image.item.IItemBase
    /**
     * ShopInventoryImage表示クラス
     *
     */


    public class ShopInventoryBaseImage extends BaseImage  implements IItemBase
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/shop/shopitem_base.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private var _titleMC:MovieClip;
        private var _state:int=0;
        private static const _TITLE_STATE_NAME:Array = [ /* of String */ 
            "",                         // RM_ITEM_STATE_NORMAL
            "new",                      // RM_ITEM_STATE_NEW
            "sale",                     // RM_ITEM_STATE_SALE
            "osusume",                  // RM_ITEM_STATE_RECOMMENDED
            "",                         // RM_ITEM_STATE_NEW_RECOMMENDED
            "",                         // RM_ITEM_STATE_SALE_RECOMMENDED
            ];

        /**
         * コンストラクタ
         *
         */
        public function ShopInventoryBaseImage(state:int=0)
        {
            _state = state;
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _titleMC = MovieClip(_root.getChildByName("title"));
            if ( _TITLE_STATE_NAME[_state] != "" ) {
                _titleMC.gotoAndStop(_TITLE_STATE_NAME[_state]);
                _titleMC.visible = true;
            } else {
                _titleMC.visible = false;
            }
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

        public function onTitle():void
        {
            waitComplete(onTitle);
        }

        private function onTitleComplete():void
        {
            _titleMC.visible = true;
        }

        public function offTitle():void
        {
            waitComplete(offTitle);
        }

        private function offTitleComplete():void
        {
            _titleMC.visible = false;
        }

    }
}
