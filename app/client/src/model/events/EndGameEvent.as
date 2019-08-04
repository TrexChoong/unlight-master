package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    // ゲームの終了
    public class EndGameEvent extends Event
    {
        public static const GAME_END:String = 'game_end';

        public var result:int;
        public var gems:int;
        public var exp:int;
        public var expBonus:int;
        public var gemsPow:int;
        public var expPow:int;
        public var totalGems:int;
        public var totalExp:int;

        public function EndGameEvent(type:String, r:int, g:int, e:int, eBonus:int, gPow:int, ePow:int, tGems:int, tExp:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            result =r;
            gems = g;
            exp = e;
            expBonus = eBonus;
            gemsPow = gPow;
            expPow = ePow;
            totalGems = tGems;
            totalExp = tExp;
            super(type, bubbles, cancelable);
        }

        public override function toString():String { 
            return formatToString("DamageEvent", "type", "result", "gems", "exp", "expBonus", "gemsPow", "expPow", "totalGems", "totalExp", "bubbles", "cancelable"); 
        }

    }

 
}