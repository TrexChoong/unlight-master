package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // カードがオープンされるイベント
    public class OpenTableCardsEvent extends Event
    {
        public static const OPEN_MOVE_CARDS:String ='open_move_cards';
        public static const OPEN_BATTLE_CARDS:String ='open_battle_cards';
        public static const OPEN_EVENT_CARDS:String ='open_event_cards';
        public static const OPEN_DISCARD_CARDS:String ='open_discard_cards';
        public static const CLOSE_DISCARD_CARDS:String ='close_discard_cards';

        public var ACArray:Array /* of ActioCard */ ;
        public var DirArray:Array/* of Boolean */;
        public var Locked:Boolean;

        public function OpenTableCardsEvent(type:String, a:Array, d:Array, l:Boolean=false, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            ACArray = a.slice();
            DirArray = d.slice();
            Locked = l;
            super(type, bubbles, cancelable);
        }

        public override function toString():String 
        {
            return formatToString("OpenTableCardsEvent", "type", "ACArray", "DirArray", "bubbles", "cancelable"); 
        }

    }

 
}