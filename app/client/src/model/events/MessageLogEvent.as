package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // マッチングのボタンイベント
    public class MessageLogEvent extends Event
    {
        // ログの更新
        public static const UPDATE:String     = "update";
        // 何か話した
        public static const SPEAKING_CHANNEL:String  = "speaking_channel";
        public static const SPEAKING_DUEL:String     = "speaking_duel";
        public static const SPEAKING_AUDIENCE:String = "speaking_audience";

        public var id:int;
        public var str:String;

        public function MessageLogEvent(type:String,  s:String= "",  i:int = -1, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            str = s;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("MessageEvent", "type","id","str", "bubbles", "cancelable");
        }

    }

 
}