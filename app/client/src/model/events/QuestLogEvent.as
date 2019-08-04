package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // チャンネルイベント
    public class QuestLogEvent extends Event
    {
        public static const UPDATE:String ='updatre';
        public static const PAGE_UPDATE:String ='page_update';
        public static const REQ_PAGE:String ='req_page';

        public var id:int;

        public function QuestLogEvent(type:String, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("QuestLogEvent", "type", "id", "bubbles", "cancelable");
        }

    }

 
}