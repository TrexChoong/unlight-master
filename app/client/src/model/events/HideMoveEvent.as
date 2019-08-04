package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class HideMoveEvent extends Event
    {
        public static const HIDE_MOVE:String = 'hide_move';

        public var distance:int;

        public function HideMoveEvent(type:String, d:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            distance = d;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("InTheFogEvent", "distance", "bubbles", "cancelable");
        }
    }
}