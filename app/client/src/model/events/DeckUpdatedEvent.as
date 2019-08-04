package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    // 決定
    public class DeckUpdatedEvent extends Event
    {
        public static const UPDATED_CHARA_CARD:String = 'updated_cc';

        public var charactors:Array = [];
        public var parents:Array = [];
        public var costs:Array = [];

        public function DeckUpdatedEvent(type:String, ch:Array, pa:Array, co:Array, bubbles:Boolean = true, cancelable:Boolean = false)
        {
            charactors = ch;
            parents = pa;
            costs = co;
            super(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("CharaCardEvent", "ch", "pa", "co", "bubbles", "cancelable");
        }
    }
}