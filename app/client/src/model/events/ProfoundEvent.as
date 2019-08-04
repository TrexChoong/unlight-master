package model.events
{
    import flash.utils.ByteArray;
    import flash.events.Event;

    import model.Profound;

    // 渦情報イベント
    public class ProfoundEvent extends Event
    {
        public static const SELECT:String     = "select";     // 渦を選択
        public static const UNSELECT:String   = "unselect";   // 渦の選択を解除
        public static const ADD_PRF:String    = "add_prf";    // 渦が追加された
        public static const UPDATE_PRF:String = "update_prf"; // 渦のState変化
        public static const FINISH_PRF:String = "finish_prf"; // 渦の戦闘終了
        public static const VANISH_PRF:String = "vanish_prf"; // 渦が消滅した
        public static const MOUSE_OVER:String = "mouse_over"; // 渦上にカーソルが移動
        public static const MOUSE_OUT:String  = "mouse_out";  // 渦上からカーソルが移動
        public static const GET_HASH:String   = "get_hash";   // hashを取得

        public var prf:Profound;
        public var posX:int;
        public var posY:int;
        public var hash:String;

        public function ProfoundEvent(type:String,  p:Profound = null, x:int = 0, y:int = 0, h:String = "", bubbles:Boolean = false, cancelable:Boolean = false)
        {
            prf = p;
            posX = x;
            posY = y;
            hash = h;
            super(type, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("MessageEvent", "type", "prf", "posX", "posY", "hash", "bubbles", "cancelable");
        }

    }

 
}