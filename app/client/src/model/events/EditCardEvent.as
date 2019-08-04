package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    import model.ICardInventory;

    // カード編集イベント
    public class EditCardEvent extends Event
    {
        public static const BINDER_TO_DECK_CHARA:String ='binder_to_deck_chara';
        public static const DECK_TO_BINDER_CHARA:String ='deck_to_binder_chara';
        public static const BINDER_TO_DECK_WEAPON:String ='binder_to_deck_weapon';
        public static const DECK_TO_BINDER_WEAPON:String ='deck_to_binder_weapon';
        public static const DECK_TO_DECK_WEAPON:String ='deck_to_deck_weapon';
        public static const BINDER_TO_DECK_EQUIP:String ='binder_to_deck_equip';
        public static const DECK_TO_BINDER_EQUIP:String ='deck_to_binder_equip';
        public static const BINDER_TO_DECK_EVENT:String ='binder_to_deck_event';
        public static const DECK_TO_BINDER_EVENT:String ='deck_to_binder_event';
        public static const DECK_TO_DECK_EVENT:String ='deck_to_deck_event';

        public static const BINDER_TO_COMBINE_WEAPON:String ='binder_to_combine_weapon';
        public static const COMBINE_TO_BINDER_WEAPON:String ='combine_to_binder_weapon';
        public static const BINDER_TO_COMBINE_WEAPON_ADD:String ='binder_to_combine_weapon_add';

        public static const SELECT_CARD:String = 'select_card';

        public static const UPDATE_CHARA_CARD:String ='update_chara_card';
        public static const UPDATE_WEAPON_CARD:String ='update_weapon_card';
        public static const UPDATE_EQUIP_CARD:String ='update_equip_card';
        public static const UPDATE_EVENT_CARD:String ='update_event_card';

        public var cci:ICardInventory;
        public var index:int;


        public function EditCardEvent(type:String, c:ICardInventory, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            cci = c;
            index = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("EditCardEvent", "type", "cci", "index", "bubbles", "cancelable"); 
        }

    }

 
}