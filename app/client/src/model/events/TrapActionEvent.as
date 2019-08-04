package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // ダメージイベント
    public class TrapActionEvent extends Event
    {
        public static const ACTION:String = 'trap_action';
        public static const UPDATE:String = 'trap_update';

        private static const FEAT_NEUM:int = 276;
        private static const FEAT_TANS:int = 277;
        private static const FEAT_ARLE:int = 278;
        private static const FEAT_INSC:int = 279;
        private static const FEAT_CLAY:int = 395;

        public var kind:String;
        public var distance:int;
        public var turn:int;
        public var visible:Boolean;;

        public function TrapActionEvent(type:String, k:int, d:int, t:int = 2, v:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            distance = d;
            turn = t;
            visible = v;

            switch (k) {
            case FEAT_NEUM :
                kind = "a";
                break;
            case FEAT_TANS :
                kind = "c";
                break;
            case FEAT_ARLE :
                kind = "b";
                break;
            case FEAT_INSC :
                kind = "d";
                break;
            case FEAT_CLAY :
                kind = "e";
                break;
            }
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("TrapActionEvent", "type", "kind", "distance", "turn", "visible", "bubbles", "cancelable");
        }

    }
}