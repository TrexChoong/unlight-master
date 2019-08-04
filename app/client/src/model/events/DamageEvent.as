package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // ダメージイベント
    public class DamageEvent extends Event
    {
        public static const DAMAGE:String = 'damage';
        public static const HEAL:String ='HEAL';
        public static const PARTY_HEAL:String ='PARTY_HEAL';
        public static const PARTY_DAMAGE:String ='PARTY_DAMAGE';
        public static const CHANGE:String = 'CHANGE';
        public static const REVIVE:String = 'REVIVE';

        public var point:int;
        public var index:int;
        public var is_not_hostile:Boolean;

        public function DamageEvent(type:String, pt:int, idx:int = 0, isnt_hostile:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            index = idx;
            point = pt;
            is_not_hostile = isnt_hostile;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("DamageEvent", "type", "point", "index", "is_not_hostile", "bubbles", "cancelable"); 
        }

    }

 
}