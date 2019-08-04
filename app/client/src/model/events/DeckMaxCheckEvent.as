package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class DeckMaxCheckEvent extends Event
    {
        public static const RESULT:String = 'deck_max_check_result';

        public var ok:Boolean;

        public function DeckMaxCheckEvent(type:String, o:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            ok = o;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("DeckMaxCheckEvent", "type", "ok", "bubbles", "cancelable"); 
        }

    }

 
}