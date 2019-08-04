package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import org.libspark.thread.*;

    import model.events.*;

    /**
     * ゲームの報酬クラス
     *
     */
    public class Reward extends BaseModel
    {
        // 受信イベント
        public static const START:String = "start";
        public static const UPDATE_BOTTOM_DICE:String = "update_bottom_dice";
        public static const HIGH_LOW_WIN:String = "high_low_win";
        public static const HIGH_LOW_LOSE:String = "high_low_lose";
        public static const UPDATE_RESULT_DICE:String = "update_result_dice";
        public static const FINAL_RESULT:String = "final_result";

        // 送信イベント
        public static const UP:String = "up";
        public static const DOWN:String = "down";
        public static const CANCEL:String = "cancel";
        public static const RETRY:String = "retry";

        // 
        private var _cards1:Array; /* of int */ 
        private var _cards2:Array; /* of int */ 
        private var _cards3:Array; /* of int */ 
        private var _bottomDice:Array; /* of int */ 
        private var _resultDice:Array; /* of int */ 
        private var _bonus:int = 1;
        private var _gettedCards:Array; /* of int */ 
        private var _totalGems:int = 0;
        private var _totalExp:int = 0;
        private var _addPoint:int = 0;

        // 取得物の種類定数
        public static const EXP:int = 0;
        public static const GEM:int = 1;
        public static const ITEM:int = 2;
        public static const CARD:int = 3;
        public static const RANDOM:int = 4;
        public static const RARE:int = 5;
        public static const EVENT_CARD:int = 6;
        public static const WEAPON_CARD:int = 7;

        // コンストラクタ
        public function Reward()
        {
        }
        //スタート
        /**
         * @param cards1
         * ActionCardのID配列
         */
        public function start(cards1:Array, cards2:Array, cards3:Array, cards4:Array,startBonus:int):void
        {
            _bonus = startBonus;
            _gettedCards = cards1;
            _cards1 = cards2;
            _cards2 = cards3;
            _cards3 = cards4;
            dispatchEvent(new Event(START));
        }

        public function setBottomDice(bottomDice:Array):void
        {
            _bottomDice = bottomDice;
            dispatchEvent(new Event(UPDATE_BOTTOM_DICE));
        }

        public function highLowResult(win:Boolean, gettedCards:Array, nextCards:Array, bonus:int):void
        {
            _bonus = bonus;
            if (win)
            {
                _gettedCards = gettedCards;
                _cards1 = cards2;
                _cards2 = cards3;
                _cards3 = nextCards;
                dispatchEvent(new Event(HIGH_LOW_WIN));
            }
            else
            {
                dispatchEvent(new Event(HIGH_LOW_LOSE));
            }
        }

        public function setResultDice(resultDice:Array):void
        {
            _resultDice = resultDice;
            dispatchEvent(new Event(UPDATE_RESULT_DICE));
        }

        public function finalResult(gettedCards:Array,totalGems:int,totalExp:int,addPoint:int):void
        {
            _gettedCards = gettedCards;
            _totalGems = totalGems;
            _totalExp = totalExp;
            _addPoint = addPoint;
            dispatchEvent(new Event(FINAL_RESULT));
        }

        public function get cards1():Array /* of int */
        {
            return _cards1;
        }

        public function get cards2():Array /* of int */
        {
            return _cards2;
        }

        public function get cards3():Array /* of int */
        {
            return _cards3;
        }

        public function get bottomDice():Array /* of int */
        {
            return _bottomDice;
        }

        public function get resultDice():Array /* of int */
        {
            return _resultDice;
        }

        public function get gettedCards():Array /* of int */
        {
            return _gettedCards;
        }

        public function get bonus():int /* of int */
        {
            return _bonus;
        }

        public function get totalGems():int /* of int */
        {
            return _totalGems;
        }

        public function get totalExp():int /* of int */
        {
            return _totalExp;
        }

        public function get addPoint():int /* of int */
        {
            return _addPoint;
        }

        public function up():void
        {
            dispatchEvent(new Event(UP));
        }

        public function down():void
        {
            dispatchEvent(new Event(DOWN));
        }

        public function cancel():void
        {
            dispatchEvent(new Event(CANCEL));
        }

        public function retry():void
        {
            dispatchEvent(new Event(RETRY));
        }
    }
}
