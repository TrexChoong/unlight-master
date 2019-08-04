package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class FeatConditionEvent extends Event
    {
        public static const PLAYER_UPDATE:String = 'player_condition_update';
        public static const FOE_UPDATE:String = 'foe_condition_update';

        public var chara_index:int;
        public var feat_index:int;
        public var condition:String;

        public function FeatConditionEvent(type:String, charaIndex:int, featIndex:int, cond:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            chara_index = charaIndex;
            feat_index = featIndex;
            condition = cond;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("FeatConditionEvent", "alpha", "enabled", "distance", "truth_distance", "bubbles", "cancelable");
        }
    }
}