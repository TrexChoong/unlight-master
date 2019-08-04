package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 必殺技表示のイベント
    public class FeatInfoEvent extends Event
    {
        public static const PLAYER_FEAT_ON:String ='player_feat_on';
        public static const PLAYER_FEAT_OFF:String ='player_feat_off';
        public static const PLAYER_FEAT_OFF_ALL:String = 'player_feat_off_all';
        public static const FOE_FEAT_ON:String ='foe_feat_on';
        public static const FOE_FEAT_OFF:String ='foe_feat_off';
        public static const FOE_FEAT_OFF_ALL:String = 'foe_feat_off_all';

        public var id:int;

        public function FeatInfoEvent(type:String, i:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("FeatInfoEvent", "type", "actionCards", "bubbles", "cancelable"); 
        }

    }

 
}