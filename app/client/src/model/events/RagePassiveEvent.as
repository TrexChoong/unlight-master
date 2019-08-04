package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 方向決定
    public class RagePassiveEvent extends Event
    {
        public static const ON:String = 'rage_passive_on';
      public static const OFF:String = 'rage_passive_off';

        public var charaSet:Array; /* of int */ ;

        public function RagePassiveEvent(type:String, cs:Array, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            charaSet = cs;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("RagePassiveEvent", "type","charaSet", "bubbles", "cancelable"); 
        }

    }

 }