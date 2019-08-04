package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 方向決定
    public class DuelBonusEvent extends Event
    {
        public static const GET:String = 'get';

        public var kind:int;
        public var value:int;

        public function DuelBonusEvent(type:String, k:int,v:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            kind = k;
            value = v;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("DuelBonusEvent", "type", "kind", "value", "bubbles", "cancelable"); 
        }

    }

 }