package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // カードが配られるイベント
    public class DealCardEvent extends Event
    {
        public static const DEAL:String ='deal';
        public static const GRAVE_DEAL:String ='grave_deal';
        public static const STEAL_DEAL:String ='steal_deal';

        public var plACArray:Array;
        public var foeACNum:int;
        public var isEventCard:Boolean;

        public function DealCardEvent(type:String, a:Array,i:int, e:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            plACArray = a;
            foeACNum = i;
            isEventCard = e;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("DealCardEvent", "type", "plACArray","foeACNum", "isEventCard","bubbles", "cancelable");
        }

    }

 
}