package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // チャンネルイベント
    public class QuestTreasureEvent extends Event
    {
        public static const GET:String ='get';

        public var genre:int;
        public var cType:int;
        public var val:int;

        public function QuestTreasureEvent(type:String, g:int, ct:int, v:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            genre =g;
            cType = ct;
            val = v;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("QuestTreasureEvent", "type", "genre", "cType", "val", "bubbles", "cancelable");
        }

    }

 
}