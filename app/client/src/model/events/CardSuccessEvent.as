package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class CardSuccessEvent extends Event
    {
        public static const MOVE_ADD:String = 'move_add';
        public static const MOVE_REMOVE:String = 'move_remove';
        public static const BATTLE_ADD:String = 'battle_add';
        public static const BATTLE_REMOVE:String = 'battle_remove';


        public var id:int;
        public var index:int;
        public var dir:Boolean;

        public function CardSuccessEvent(type:String, i:int, idx:int, d:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            index = idx;
            dir = d;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("TableCardEvent", "type", "id", "index", "dir", "bubbles", "cancelable"); 
        }

    }

 
}