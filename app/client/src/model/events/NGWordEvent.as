package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // NGWordの結果を返す
    public class NGWordEvent extends Event
    {
        public static const GET_RESULT:String = 'get_result';

        public var result:Boolean;

        public function NGWordEvent(type:String, r:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            result = r;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("NGWordEvent", "type", "result", "bubbles", "cancelable"); 
        }

    }

 
}