package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    import model.ActionCard;

    // カードの入れ替えの結果イベント
    public class ReplaceCardEvent extends Event
    {
        public static const ADD_MOVE_TABLE:String ='add_move_table';
        public static const REMOVE_MOVE_TABLE:String ='remove_move_table';

        public static const ADD_ATTACK_BATTLE_TABLE:String ='add_attack_battle_table';
        public static const REMOVE_ATTACK_BATTLE_TABLE:String ='remove_attack_battle_table';

        public static const ADD_DEFFENCE_BATTLE_TABLE:String ='add_deffence_battle_table';
        public static const REMOVE_DEFFNCE_BATTLE_TABLE:String ='remove_deffence_battle_table';

        public static const ADD_BATTLE_TABLE:String ='add_battle_table';
        public static const REMOVE_BATTLE_TABLE:String ='remove_battle_table';

        public static const ROTATE:String ='rotate';

        public var index:int;
        public var table:int;
        public var ac:ActionCard;
        
        public function ReplaceCardEvent(type:String, a:ActionCard,i:int, t:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {

            index = i;
            ac = a;
            table = t;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("ReplaceCardEvent", "type", "ac", "table","index", "bubbles", "cancelable"); 
        }

    }

 
}