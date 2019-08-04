package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class SlotCardEvent extends Event
    {
        public static const GET_EVENT_CARD:String = 'get_event_card';
        public static const GET_EQUIP_CARD:String = 'get_equip_card';
        public static const GET_WEAPON_CARD:String = 'get_weapon_card';

        public var id:int;

        public function SlotCardEvent(type:String, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("SlotCardEvent", "type", "id", "bubbles", "cancelable"); 
        }

    }

 
}