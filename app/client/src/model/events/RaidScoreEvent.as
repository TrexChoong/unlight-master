package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 方向決定
    public class RaidScoreEvent extends Event
    {
        public static const UPDATE:String = 'raid_score_update';

        public var value:int;

        public function RaidScoreEvent(type:String, v:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            value = v;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("RaidScoreEvent", "type","value", "bubbles", "cancelable"); 
        }

    }

 }