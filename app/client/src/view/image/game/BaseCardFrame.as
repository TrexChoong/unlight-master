package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;

    import model.Duel;
    import view.image.BaseImage;
    import view.utils.*;
    import view.ClousureThread;
    import controller.*;


    /**
     * 枠クラス
     *
     */


    public class BaseCardFrame extends BaseImage
    {
                    // ゲームのコントローラー

        // デュエルインスタンス
//        private var _duel:Duel;


        // 枠表示元SWF
        [Embed(source="../../../../data/image/game/base.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private static const TURN:String = "turn"
        private static const TURN_RAID:String = "turn_raid"
        private var _turnMC:MovieClip;
        private var _endTurnMC:MovieClip;
        private var _turn:int;
        private var _endTurn:int;


        /**
         * コンストラクタ
         *
         */

        public function BaseCardFrame()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _turnMC = MovieClip(_root.getChildByName(TURN));
            _endTurnMC = MovieClip(_root.getChildByName(TURN_RAID));
            _endTurnMC.visible = false
            initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
//             x = X;
//             y = Y;
            alpha = 1.0;
            setTurn(1);
        }


        public override function init():void
        {
        }
        public override function final():void
        {
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            return new BeTweenAS3Thread(this, {alpha:1.0}, {alpha:0.0}, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
        }

        // 実画面から消去するスレッドを返す
        public function getBringOffThread():Thread
        {
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
        }

        // 隠すスレッドを返す
        public override function getHideThread(type:String = ""):Thread
        {
            log.writeLog(log.LV_WARN, this, "hide");
            alpha = 0;
            visible = false;
            return super.getHideThread(type);
        }

        public function setTurn(i:int):void
        {
            _turn = i;
            waitComplete(gotoTurn)
        }

        private function gotoTurn():void
        {
            _turnMC.gotoAndStop(_turn);
        }

        public function setEndTurn(i:int):void
        {
            _endTurnMC.visible = true;
            _endTurn = i;
            waitComplete(gotoEndTurn);
        }

        private function gotoEndTurn():void
        {
            _endTurnMC.gotoAndStop(_endTurn);
        }

        public function get turn():MovieClip
        {
            return _turnMC;
        }
        public function get endTurn():MovieClip
        {
            return _endTurnMC;
        }
    }

}
