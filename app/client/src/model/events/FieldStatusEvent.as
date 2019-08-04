package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // ダメージイベント
    public class FieldStatusEvent extends Event
    {
        public static const SET:String = 'status_set';

        public static const FOG:int = 1;

        public var kind:int;
        public var pow:int;
        public var turn:int;

        public function FieldStatusEvent(type:String, k:int, p:int, t:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            kind = k;
            pow = p;
            turn = t;

            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("TrapActionEvent", "type", "kind", "pow", "turn", "bubbles", "cancelable");
        }

    }
}