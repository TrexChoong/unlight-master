package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // チャンネルイベント
    public class QuestMapEvent extends Event
    {
        public static const UPDATE:String ='update';

        public var ids:Array = [];

        public function QuestMapEvent(type:String, i:Array, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            ids = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("QuestMapEvent", "type", "ids", "bubbles", "cancelable");
        }

    }

 
}