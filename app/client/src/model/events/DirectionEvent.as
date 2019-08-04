package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 方向決定
    public class DirectionEvent extends Event
    {
        public static const UPDATE:String = 'update';

        public var dir:int;

        public function DirectionEvent(type:String, d:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            dir = d;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("DirectionEvent", "type", "dir", "bubbles", "cancelable"); 
        }

    }

 
}