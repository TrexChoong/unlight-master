package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

//    import model.ActionCard;

    // ステータス付加イベント
    public class BuffEvent extends Event
    {
        public static const PLAYER:String ='player';
        public static const FOE:String ='foe';
        public static const PLAYER_OFF:String ='player_off';
        public static const FOE_OFF:String ='foe_off';
        public static const PLAYER_OFF_ALL:String ='player_off_all';
        public static const FOE_OFF_ALL:String ='foe_off_all';
        public static const PLAYER_UPDATE:String ='player_update';
        public static const FOE_UPDATE:String ='foe_update';
        public static const PLAYER_IDX:String ='player_idx';
        public static const FOE_IDX:String ='foe_idx';
        public static const BOSS:String ='boss';
        public static const BOSS_BUFF_UPDATE:String ='boss_buff_update';
        public static const BOSS_BUFF_DELETE:String ='boss_buff_delete';
        public static const BOSS_BUFF_ALL_DELETE:String ='boss_buff_all_delete';

        public var id:int;
        public var value:int;
        public var turn:int;
        public var index:int;
        public var limit:int;

        public function BuffEvent(type:String, i:int = 0, v:int = 0, t:int = 0, idx:int = 0, l:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            value = v;
            turn = t;
            index = idx;
            limit = l;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("BuffEvent", "type", "id", "value", "turn", "index", "limit", "bubbles", "cancelable");
        }

    }

 
}