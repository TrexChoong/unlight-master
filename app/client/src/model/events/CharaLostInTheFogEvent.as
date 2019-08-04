package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class CharaLostInTheFogEvent extends Event
    {
        public static const PLAYER:String = 'player_tp';
        public static const FOE:String = 'foe_tp';

        public var enabled:Boolean;
        public var distance:int;
        public var truth_distance:int;

        public function CharaLostInTheFogEvent(type:String, e:Boolean, d:int=4, t:int=0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            enabled = e;
            distance = d;
            truth_distance = t;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("CharaLostInTheFogEvent", "alpha", "enabled", "distance", "truth_distance", "bubbles", "cancelable");
        }
    }
}