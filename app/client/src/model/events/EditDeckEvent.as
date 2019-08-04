package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // カード編集イベント
    public class EditDeckEvent extends Event
    {
        public static const RENAME_DECK:String = 'rename_deck';
        public static const CREATE_DECK:String = 'create_deck';
        public static const CREATE_DECK_SUCCESS:String = 'create_deck_success';
        public static const DELETE_DECK:String = 'delete_deck';
        public static const DELETE_DECK_SUCCESS:String = 'delete_deck_success';
        public static const SELECT_DECK:String = 'select_deck';
        public static const CHANGE_CURRENT_DECK:String = 'change_current_deck';
        public static const BINDER_SORT:String = 'binder_sort';
        public static const BINDER_SELECT:String = 'binder_select';


        public var index:int;
        public var name:String;

        public function EditDeckEvent(type:String, i:int = 0, n:String = "", bubbles:Boolean = false, cancelable:Boolean = false)
        {
            index = i;
            name = n;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("EditDeckEvent", "type", "index", "name", "bubbles", "cancelable"); 
        }

    }

 
}