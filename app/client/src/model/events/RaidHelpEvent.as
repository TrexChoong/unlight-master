package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // レイドヘルプイベント
    public class RaidHelpEvent extends Event
    {
        public static const UPDATE:String = 'raid_help_update';
        public static const ACCEPT:String = 'raid_help_accept';

        public var plId:int;
        public var name:String;
        public var hash:String;

        public function RaidHelpEvent(type:String, i:int, n:String, h:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            plId = i;
            name = n;
            hash = h;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("RaidHelpEvent", "type", "plId", "name", "hash", "bubbles", "cancelable");
        }

    }

 }