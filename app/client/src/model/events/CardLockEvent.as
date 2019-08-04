package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // ダメージイベント
    public class CardLockEvent extends Event
    {
        public static const LOCK:String = 'lock_card';
        public static const UNLOCK:String ='unlock_card';

        public var id:int;

        public function CardLockEvent(type:String, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("CardLockEvent", "type", "id", "bubbles", "cancelable");
        }

    }

 
}