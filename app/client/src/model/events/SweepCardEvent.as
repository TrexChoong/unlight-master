package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // カードが捨てられるイベント
    public class SweepCardEvent extends Event
    {
        public static const SWEEP_ALL_PLAYER:String ='sweep_all_player';
        public static const SWEEP_ALL_FOE:String ='sweep_all_foe';
        public static const SWEEP_PLAYER:String ='sweep_player';
        public static const SWEEP_FOE:String ='sweep_foe';
        public static const DISCARD_PLAYER:String ='discard_player';
        public static const DISCARD_FOE:String ='discad_foe';
        public static const STEAL_DISCARD_PLAYER:String ='steal_discard_player';
        public static const STEAL_DISCARD_FOE:String ='steal_discad_foe';


        public var actionCards:Array;

        public function SweepCardEvent(type:String, a:Array, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            actionCards = a;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("SweepCardEvent", "type", "actionCards", "bubbles", "cancelable"); 
        }

    }

 
}