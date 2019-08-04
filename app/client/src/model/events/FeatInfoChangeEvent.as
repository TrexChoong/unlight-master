package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 必殺技表示のイベント
    public class FeatInfoChangeEvent extends Event
    {
        public static const PLAYER_FEAT_CHANGE:String ='player_change_feat';
        public static const FOE_FEAT_CHANGE:String ='foe_change_feat';

        public var chara_index:int;
        public var feat_index:int;
        public var feat_id:int;
        public var feat_no:int;

        public function FeatInfoChangeEvent(type:String, cidx:int, fidx:int, fid:int, fno:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            chara_index = cidx;
            feat_index = fidx;
            feat_id = fid;
            feat_no = fno;

            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("FeatInfoChangeEvent", "type", "chara_index","feat_index", "feat_id", "feat_no", "bubbles", "cancelable"); 
        }

    }

 
}