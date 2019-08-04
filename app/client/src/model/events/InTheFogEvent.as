package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class InTheFogEvent extends Event
    {
        public static const PLAYER:String = 'player_range';
        public static const FOE:String = 'foe_range';

        public var range:Array;

        public function InTheFogEvent(type:String, r:Array, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            range = r;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("InTheFogEvent", "alpha", "enabled", "distance", "truth_distance", "bubbles", "cancelable");
        }
    }
}