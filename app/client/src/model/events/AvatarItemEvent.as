package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class AvatarItemEvent extends Event
    {
        public static const GET_ITEM:String = 'get_item';
        public static const USE_ITEM:String = 'use_item';

        public var id:int;

        public function AvatarItemEvent(type:String, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("AvatarItemEvent", "type", "id", "bubbles", "cancelable"); 
        }

    }

 
}