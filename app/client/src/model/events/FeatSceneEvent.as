package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 必殺技表示のイベント
    public class FeatSceneEvent extends Event
    {
        public static const PLAYER_FEAT_USE:String ='player_feat_use';
        public static const FOE_FEAT_USE:String ='foe_feat_use';

        public var id:int;

        public function FeatSceneEvent(type:String, i:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("FeatSceneEvent", "type", "actionCards", "bubbles", "cancelable"); 
        }

    }

 
}