package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // カード合成イベント
    public class ExchangeEvent extends Event
    {
        public static const EXCHANGE:String ='exchange';
        public static const EXCHANGE_INFO:String ='exchange_info';
        public static const EXCHANGE_SUCCESS:String = 'exchange_success';

        public var id:int;
        public var cid:int;

        public function ExchangeEvent(type:String, i:int = 0, ci:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            cid = ci;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("EditCardEvent", "type", "id", "cid", "bubbles", "cancelable"); 
        }

    }

 
}