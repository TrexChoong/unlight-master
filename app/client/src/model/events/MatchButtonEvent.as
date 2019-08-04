package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // マッチングのボタンイベント
    public class MatchButtonEvent extends Event
    {
        public static const CREATE:String ='create';
        public static const JOIN:String ='join';
        public static const FRIEND:String ='friend';
        public static const QUICK:String ='quick';

        public function MatchButtonEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("BuffEvent", "type", "bubbles", "cancelable");
        }

    }

 
}