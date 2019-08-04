package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 必殺技表示のイベント
    public class StuffedToysSetEvent extends Event
    {
        public static const PLAYER_SET:String ='player_stuffed_toys_set';
        public static const FOE_SET:String ='foe_stuffed_toys_set';

        public var num:int;

        public function StuffedToysSetEvent(type:String, n:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            num = n;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("StuffedToysSetEvent", "num", "bubbles", "cancelable");
        }

    }

}