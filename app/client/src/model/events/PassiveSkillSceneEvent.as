package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 必殺技表示のイベント
    public class PassiveSkillSceneEvent extends Event
    {
        public static const PLAYER_PASSIVE_SKILL_USE:String ='player_passive_use';
        public static const FOE_PASSIVE_SKILL_USE:String ='foe_passive_use';

        public var id:int;

        public function PassiveSkillSceneEvent(type:String, i:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("PassiveSkillSceneEvent", "type", "actionCards", "bubbles", "cancelable");
        }
    }
}