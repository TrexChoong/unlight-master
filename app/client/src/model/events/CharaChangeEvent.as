package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // キャラチェンジイベント
    public class CharaChangeEvent extends Event
    {
        public static const CHARA_CHANGE:String = 'chara_change';
        public static const UPDATE_WEAPON_BONUS:String = 'update_weapon_bonus';
        public static const SUCCESS:String = 'SUCCESS';

        public var index:int;

        public function CharaChangeEvent(type:String, i:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            index = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("CharaChangeEvent", "type", "index", "bubbles", "cancelable"); 
        }

    }

 
}