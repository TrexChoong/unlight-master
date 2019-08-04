package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // チャンネルイベント
    public class ChannelEvent extends Event
    {
        public static const INIT:String ='init';
        public static const JOIN:String ='join';
        public static const EXIT:String ='exit';

        public var id:int;

        public function ChannelEvent(type:String, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("ChannelEvent", "type", "id", "bubbles", "cancelable");
        }

    }

 
}