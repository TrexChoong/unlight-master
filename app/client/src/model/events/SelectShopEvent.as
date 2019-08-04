package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    import view.scene.shop.ShopItemInventoryClip;

    // カードの入れ替えの結果イベント
    public class SelectShopEvent extends Event
    {
        public static const ITEM_CHANGE:String ='item_change';
        public static const SLOT_CARD_CHANGE:String ='slot_card_change';

        public var item:*;

        public function SelectShopEvent(type:String, i:*, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            item = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("SelectShopEvent", "item", "bubbles", "cancelable"); 
        }

    }

 
}