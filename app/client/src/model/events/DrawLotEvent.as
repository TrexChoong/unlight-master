package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    import view.scene.item.ItemInventoryClip;

    // カードクジを引いたときのイベント
    public class DrawLotEvent extends Event
    {
        public static const SUCCESS:String ='success';

        public var currentGotLotCardType   :int;
        public var currentGotLotCardID     :int;
        public var currentGotLotCardNum     :int;
        public var currentBlankLotCard1Type :int;
        public var currentBlankLotCard1ID   :int;
        public var currentBlankLotCard1Num   :int;
        public var currentBlankLotCard2Type :int;
        public var currentBlankLotCard2ID   :int;
        public var currentBlankLotCard2Num   :int;

        public function DrawLotEvent(type:String, lotType:int, lotID:int, lotNum:int, blank1Type:int, blank1ID:int, blank1Num:int, blank2Type:int, blank2ID:int, blank2Num:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {

            currentGotLotCardType = lotType;
            currentGotLotCardID = lotID;
            currentGotLotCardNum = lotNum;
            currentBlankLotCard1Type = blank1Type;
            currentBlankLotCard1ID = blank1ID;
            currentBlankLotCard1Num = blank1Num;
            currentBlankLotCard2Type = blank2Type;
            currentBlankLotCard2ID = blank2ID;
            currentBlankLotCard2Num = blank2Num;
            super(type, bubbles, cancelable);
        }

        public override function toString():String 
        {
            return formatToString("DrawLotEvent", "currentGotLotCardType", "currentGotLotCardID", "currentBlankLotCard1Type", "currentBlankLotCard1ID","currentBlankLotCard2Type", "currentBlankLotCard2ID", "bubbles", "cancelable"); 
        }

    }


}