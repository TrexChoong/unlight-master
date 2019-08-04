package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // マッチング時のイベント
    public class MatchRoomFriendEvent extends Event
    {
        public static const UPDATE:String = 'update_room_friend_info';

        public var roomId:String;
        public var hostIsFriend:Boolean;
        public var guestIsFriend:Boolean;

        public function MatchRoomFriendEvent(type:String, i:String, h:Boolean, g:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            roomId = i;
            hostIsFriend = h;
            guestIsFriend = g;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("MatchRoomFriendEvent", "type", "id", "host_is_friend", "guest_is_friend", "bubbles", "cancelable"); 
        }

    }

 
}