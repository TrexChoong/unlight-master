package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // マッチング時のイベント
    public class MatchEvent extends Event
    {
        public static const INIT:String = 'init';
        public static const EXIT:String = 'exit';
        public static const CREATE_ROOM:String = 'create_room';
        public static const CREATE_CPU_ROOM:String = 'create_cpu_room';
        public static const JOIN_ROOM:String = 'join_room';
        public static const UPDATE_ROOM:String = 'update_room';
        public static const CREATE_SUCCESS:String = 'create_room_success';
        public static const DELETE_ROOM:String = 'delete_room';
        public static const EXIT_ROOM:String = 'exit_room';

        public var id:String;
        public var name:String;
        public var stage:int;
        public var rule:int;

        public function MatchEvent(type:String, i:String = "", n:String = "", s:int = 0, r:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            name = n;
            stage = s;
            rule = r;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("MatchEvent", "type", "id", "name", "stage", "rule", "bubbles", "cancelable"); 
        }

    }

 
}