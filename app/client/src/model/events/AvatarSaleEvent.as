package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // 決定
    public class AvatarSaleEvent extends Event
    {
        public static const SALE_START:String = 'sale_start';
        public static const SALE_FINISH:String = 'sale_finish';

        public var id:int;

        public function AvatarSaleEvent(type:String, i:int=0, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            log.writeLog(log.LV_INFO, "AvatarSaleEvent", "AvatarSaleEvent type",type);
            id = i
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("AvatarSaleEvent", "type", "id", "bubbles", "cancelable");
        }

    }

 
}