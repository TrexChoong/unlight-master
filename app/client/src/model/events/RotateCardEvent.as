package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    import model.ActionCard;

    // カードの入れ替えの結果イベント
    public class RotateCardEvent extends Event
    {
        public static const CARD_ROTATE:String ='card_rotate';

        public var up:Boolean;

        public function ReplaceCardEvent(type:String, u:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
        {

            up = u;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("RotateCardEvent", "up", "bubbles", "cancelable"); 
        }

    }

 
}