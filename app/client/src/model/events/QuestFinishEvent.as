package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // チャンネルイベント
    public class QuestFinishEvent extends Event
    {
        public static const FINISH:String ='finish';

        public var result:int;

        public function QuestFinishEvent(type:String, i:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            result = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("QuestFinishEvent", "type", "result", "bubbles", "cancelable");
        }

    }

 
}