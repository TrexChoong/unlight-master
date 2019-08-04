package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // ダメージイベント
    public class ConstraintEvent extends Event
    {
        public static const CONSTRAINT:String = 'constraint';
        public static const CONSTRAINT_FORWARD:uint = 1;
        public static const CONSTRAINT_BACKWARD:uint = 2;
        public static const CONSTRAINT_STAY:uint = 4;
        public static const CONSTRAINT_CHARA_CHANGE:uint = 8;
        private var _flag:uint;

        public function ConstraintEvent(type:String, flag:uint, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            _flag = flag;
            super(type, bubbles, cancelable);
        }

        // enabled:0, disabled:2 ... move_buttonのフレームに対応
        public function isEnabled(kind:uint):int
        {
            var ret:int = 0;
            if ((_flag & kind) == kind) ret = 2;

            return ret;
        }

        public override function toString():String { 
            return formatToString("ConstraintEvent", "type", "flag", "bubbles", "cancelable");
        }

    }

 
}