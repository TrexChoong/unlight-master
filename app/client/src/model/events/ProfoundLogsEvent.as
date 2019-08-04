package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 
    public class ProfoundLogsEvent extends Event
    {
        // ログの更新
        public static const UPDATE:String     = "update";
        // 何か話した
        public static const SPEAK_COMMENT:String  = "speak_comment";

        public var prfId:int;
        public var str:String;
        public var lastId:int;

        public function ProfoundLogsEvent(type:String, pid:int = -1, s:String= "", lid:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            prfId = pid;
            str = s;
            lastId = lid;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("ProfoundLogsEvent", "type","prfId","str", "lastId", "bubbles", "cancelable");
        }

    }

 
}