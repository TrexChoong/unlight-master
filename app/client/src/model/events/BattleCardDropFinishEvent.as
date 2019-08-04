package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 攻撃カードが決定されたときのイベント
    public class BattleCardDropFinishEvent extends Event
    {
        public static const BATTLE_CARD_DROP_PHASE_FINISH:String ='battle_card_drop_phase_finish';

        private var _lock:Boolean;

        public function BattleCardDropFinishEvent(lock:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            _lock = lock
            super(type, bubbles, cancelable);
        }

        public function locked():Boolean
        {
            return _lock;
        }

        public override function toString():String {
            return formatToString("SweepCardEvent", "type", "lock", "actionCards", "bubbles", "cancelable"); 
        }

    }

}