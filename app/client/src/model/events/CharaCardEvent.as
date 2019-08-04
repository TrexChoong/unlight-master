package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class CharaCardEvent extends Event
    {
        public static const GET_CHARA_CARD:String = 'get_chara_card';
        public static const COPY_CHARA_CARD:String = 'copy_chara_card';

        public var id:int;

        public function CharaCardEvent(type:String, i:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("CharaCardEvent", "type", "id", "bubbles", "cancelable"); 
        }

    }

 
}