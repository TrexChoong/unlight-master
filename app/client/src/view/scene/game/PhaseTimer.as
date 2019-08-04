package view.scene.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.*;

    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import controller.*;
    import view.image.game.*;


    /**
     * フェイズのタイマー表示
     *
     */

    public class PhaseTimer extends BaseScene
    {

        // ゲームのコントローラ

        /**
         * タイマーが終わった
         *
         */
        public static const TIME_UP:String = 'time_up';

        private static const WARN_TIME:Number = 0.33; // 警告の出る残りゲージの割合

        public static const X:int = 0;
        public static const Y:int = 0;
        public static const WAIT_TIME:Number = 30*1000;

        private var _time:Number;

        private var _waitTime:Number;

        private var _base:TimeBase = new TimeBase();
        private var _rGauge:TimeGauge = new TimeGauge();
        private var _lGauge:TimeGauge = new TimeGauge(true);

        private var _isWatch:Boolean = false;


        /**
         * コンストラクタ
         *
         */
        public function PhaseTimer(w:Number)
        {
            super();
            x = X;
            y = Y;
            alpha = 0.0;
            _waitTime = w * 1000;

            _base.getShowThread(this,0).start();
            addChild(_rGauge);
            addChild(_lGauge);
        }

        public override function init():void
        {
            

        }

        public override function final():void
        {
            removeEventListener(Event.ENTER_FRAME,nextGauge);
        }

        // 移動カードドロップフェイズモードへの変更スレッド
        public function getSetMoveCardDropPhaseThread():Thread
        {
            _base.setNormal();
            return new OnMoveCardDropPhaseThread(this);
        }
        // Battleモードへの変更スレッド
        public function getSetBattlePhaseThread():Thread
        {
            _base.setNormal();
            return new OnBattleThread(this);
        }

        // MovePhaseへの変更スレッド
        public function getSetOnMovePhaseThread():Thread
        {
            _base.setNormal();
            return new OnMoveCardDropPhaseThread(this);
        }


        // イニシアチブ決定モードの遷移スレッドを返す
        public override function getHideThread(type:String = ""):Thread
        {
            _base.setNormal();
            return new HideThread(this);
        }

        // 攻撃フェイズに変更
        public function onAttack():void
        {
        }


        // 移動フェイズに変更
        public function onMove():void
        {
        }



        // タイマーをスタート
        public function onTimerStart():void
        {
            gaugeReset();
            if ( !_isWatch ) {
                _time = getTimer();
                gaugeColorChangeStart(_waitTime/1000);
                addEventListener(Event.ENTER_FRAME,nextGauge);
            }
        }

        private function nextGauge(e:Event):void
        {
            var t:Number, u:Number;
            t = getTimer()-_time;
            if (t>_waitTime)
            {
                _base.setNormal();
                removeEventListener(Event.ENTER_FRAME, nextGauge);
                dispatchEvent(new Event(TIME_UP));
            }
            else
            {
                u = 1.0 - t/_waitTime;
                gaugeScaleUpdate(u);
                if (u < WARN_TIME)
                {
                    _base.setWarning();
                }
            }
       }

        // ゲージの更新
        private function gaugeScaleUpdate(num:Number):void
        {
            _lGauge.scale(num);
            _rGauge.scale(num);
        }

        // ゲージのカラーチェンジスタート
        private function gaugeColorChangeStart(_timer:Number):void
        {
            _lGauge.colorChangeStart(_timer);
            _rGauge.colorChangeStart(_timer);
        }

        // ゲージのカラーチェンジストップ
        private function gaugeColorChangeStop():void
        {
            _lGauge.colorChangeStop();
            _rGauge.colorChangeStop();
        }

        // ゲージのリセット
        private function gaugeReset():void
        {
            _lGauge.reset();
            _rGauge.reset();
            gaugeScaleUpdate(1.0);
        }


        // タイマーをストップ
        public function onTimerStop():void
        {
            _base.setNormal();
            removeEventListener(Event.ENTER_FRAME, nextGauge);
        }

        // タイマーをリセット
        public function timerReset():void
        {
            gaugeReset();
            _base.setNormal();
        }
        // 実画面から消去するスレッドを返す
        public function getBringOffThread():Thread
        {
//            return new TweenerThread(this, { alpha: 0.0, transition:"easeOutSine", time: 0.5, hide:true} );
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
        }

        public function set isWatch(isWatch:Boolean):void
        {
            _isWatch = isWatch;
        }



    }

}

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.scene.game.PhaseTimer;

// 移動カードドロップフェイズモードへ
class OnMoveCardDropPhaseThread extends Thread
{
    protected var _circleGraph:PhaseTimer;
    private static var _TIME:Number = 0.3;

    public function OnMoveCardDropPhaseThread(cg:PhaseTimer)
    {
        _circleGraph = cg;
        _circleGraph.timerReset();

    }

    protected override function run():void
    {
//        var thread:Thread = new TweenerThread(_circleGraph, { alpha: 1.0, transition:"easeOutSine", time: _TIME, show: true});
        var thread:Thread = new BeTweenAS3Thread(_circleGraph, {alpha:1.0}, null, _TIME, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();
        next(onMove);
    }

    protected function onMove():void
    {
        _circleGraph.onMove();
        _circleGraph.onTimerStart();
    }

}

// 戦闘カードドロップフェイズへモードへ
class OnBattleThread extends OnMoveCardDropPhaseThread
{
    public function OnBattleThread(cg:PhaseTimer)
    {
        super(cg)
    }

    protected override function onMove():void
    {
        _circleGraph.onAttack();
        _circleGraph.onTimerStart();
    }

}
// 一時的に隠す
class HideThread extends Thread
{
    private var _circleGraph:PhaseTimer;
    private static var _TIME:Number = 0.2;

    public function HideThread(cg:PhaseTimer)
    {
        _circleGraph = cg;
        name = "phase area thread"
    }

    protected override function run():void
    {
        if (_circleGraph.alpha == 1.0)
        {
//            var thread:Thread = new TweenerThread(_circleGraph, { alpha: 0.0, transition:"easeOutSine", time: _TIME, hide: true});
            var thread:Thread = new BeTweenAS3Thread(_circleGraph, {alpha:0.0}, null, _TIME, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
            thread.start();
            thread.join();
        }
        next(hide);
    }

    private function hide():void
    {
        _circleGraph.onTimerStop();
        _circleGraph.timerReset();
    }
}
