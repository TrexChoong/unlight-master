package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    import view.scene.item.ItemInventoryClip;

    // カードクジを引いたときのイベント
    public class UpdateCardValueEvent extends Event
    {
        public static const PLAYER_UPDATE:String = 'player_card_value_update';

        public var card_id:int;
        public var u_value:int;
        public var b_value:int;
        public var reset:Boolean;

        public function UpdateCardValueEvent(type:String, id:int, uv:int, bv:int, r:Boolean=false, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            card_id = id;
            u_value = uv;
            b_value = bv;
            reset = r;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("DrawLotEvent", "updateCardValueType", "cardId", "uValue", "bValue", "reset", "currentBlankLotCard2Type", "currentBlankLotCard2ID", "bubbles", "cancelable");
        }

    }


}