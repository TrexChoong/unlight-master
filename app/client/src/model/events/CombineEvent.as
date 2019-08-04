package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // カード合成イベント
    public class CombineEvent extends Event
    {
        public static const COMBINE:String ='combine';
        public static const COMBINE_SUCCESS:String = 'combine_success';

        public var invIds:String;

        public function CombineEvent(type:String, i:String = "", bubbles:Boolean = false, cancelable:Boolean = false)
        {
            invIds = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("CombineEvent", "type", "invIds", "bubbles", "cancelable"); 
        }

    }

 
}