package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // マッチング時のイベント
    public class MatchingRoomEvent extends Event
    {
        public static const UPDATE:String = "update";
        public static const ADD_ROOM:String = 'add_room';
        public static const ROOM_JOIN:String = 'join_room'

        public function MatchingRoomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("MatchingRoomEvent", "type", "bubbles", "cancelable"); 
        }

    }

 
}