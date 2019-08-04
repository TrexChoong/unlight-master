package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // ダイスの結果イベント
    public class RollResultEvent extends Event
    {
        public static const PLAYER_ATTACK:String ='player_attack';
        public static const FOE_ATTACK:String ='foe_attack';
        private static const DICE_COVERT:Array = [2,3,4,5,6,1,7,2];
        public var atkDice:Array;
        public var defDice:Array;

        public function RollResultEvent(type:String, atk:Array, def:Array, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            atkDice = convertResult(atk);
            defDice = convertResult(def);
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("RollResultEvent", "type", "atkDice","defDice", "bubbles", "cancelable"); 
        }

        private function convertResult(a:Array):Array
        {
            var r:Array = []
            for(var i:int; i < a.length; i++)
            {
                r[i] = DICE_COVERT[a[i]];
            }
            return r

        }

    }

 
}