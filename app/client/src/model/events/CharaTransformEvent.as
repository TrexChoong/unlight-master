package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class CharaTransformEvent extends Event
    {
        public static const PLAYER:String = 'player_tr';
        public static const FOE:String = 'foe_tr';
        public static const TYPE_STANDARD:int = 0;
        public static const TYPE_CAT:int = 1;

        public var enabled:Boolean;
        public var transformType:int;

        public function CharaTransformEvent(type:String, i:Boolean = false, t:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            enabled = i;
            transformType = t;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("CharaTransformEvent", "enabled", "type", "enabled", "bubbles", "cancelable"); 
        }

    }

 
}