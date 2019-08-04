package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 移動決定
    public class DetermineMoveEvent extends Event
    {
        public static const UPDATE:String = 'update';

        public var pow:int;
        public var foePow:int;

        public function DetermineMoveEvent(type:String, p:int, fp:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            pow = p;
            foePow = fp;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("DetermineMoveEvent", "type", "pow","foePow", "bubbles", "cancelable");
        }

    }

 
}