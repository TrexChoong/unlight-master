package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class AvatarPartEvent extends Event
    {
        public static const GET_PART:String = 'get_part';
        public static const EQUIP_PART:String = 'equip_part';
        public static const VANISH_PART:String = 'vanish_part';

        public var id:int;

        public function AvatarPartEvent(type:String, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("AvatarPartEvent", "type", "id", "bubbles", "cancelable"); 
        }

    }

 
}