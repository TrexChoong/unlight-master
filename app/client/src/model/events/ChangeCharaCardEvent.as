package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class ChangeCharaCardEvent extends Event
    {
        public static const PLAYER:String = 'player_ch';
        public static const FOE:String = 'foe_ch';

        public var id:int;

        public function ChangeCharaCardEvent(type:String, i:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            log.writeLog(log.LV_DEBUG, this , "|||||||| ChangeCharaCardEvent ||||||||||||||||||||||",i);
            id = i;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("ChangeCharaCardEvent", "type", "actionCards", "bubbles", "cancelable"); 
        }

    }

 
}