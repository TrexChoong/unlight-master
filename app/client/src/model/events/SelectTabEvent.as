package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    import model.ActionCard;

    // カードの入れ替えの結果イベント
    public class SelectTabEvent extends Event
    {
        public static const TAB_CHANGE:String ='tab_change';

        public var index:int;

        public function SelectTabEvent(type:String, i:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            index = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("SelectTabEvent", "index", "bubbles", "cancelable"); 
        }

    }

 
}