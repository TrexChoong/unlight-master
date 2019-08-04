package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class PassiveSkillEvent extends Event
    {
        public static const PLAYER_ON:String = 'player_passive_on';
        public static const PLAYER_OFF:String = 'player_passive_off';
        public static const FOE_ON:String = 'foe_passive_on';
        public static const FOE_OFF:String = 'foe_passive_off';

        public var skillId:int;

        public function PassiveSkillEvent(type:String, id:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            skillId = id;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("PassiveSkillEvent", "type", "skillId", "bubbles", "cancelable"); 
        }

    }

 
}