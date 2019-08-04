package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import mx.core.UIComponent;

    import view.image.BaseImage;
    import controller.*;

    /**
     * 結果表示クラス
     *
     */
    public class ResultRollImage extends BaseImage
    {

        // result表示元SWF
        [Embed(source="../../../../data/image/game/result/result_roll.swf")]
        private var _Source:Class;

        private var _resultMC:Array = [];
        private var _result:int;



        private static const INS_NAME:Array = ["roll_suc", "roll_fail"]
        private var _successMC:MovieClip;
        private var _failedMC:MovieClip;

        private var _originalParent:DisplayObjectContainer;

        /**
         * コンストラクタ
         *
         */
        public function ResultRollImage(r:int = 0)
        {
            _resultMC = [_successMC, _failedMC];
            _result = r;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);

            for(var i:int = 0; i < INS_NAME.length; i++)
            {
                _resultMC[i] = MovieClip(_root.getChildByName(INS_NAME[i]));
                _resultMC[i].gotoAndStop(0);
                _originalParent = _resultMC[i].parent;
                _originalParent.removeChild(_resultMC[i]);
            };
        }
        private function set result(r:int):void
        {
            _result = r;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public  function playResultMC():void
        {
            waitComplete(setPlayResultMC)
        }

        private  function  setPlayResultMC():void
        {
            _originalParent.addChild(_resultMC[_result]);
            frameStop(_resultMC[_result], _resultMC[_result].totalFrames-1);
            _resultMC[_result].gotoAndPlay(1);

        }

        public function stopResultMC():void
        {
            waitComplete(setStopResultMC)
        }

        private function  setStopResultMC():void
        {
            for(var i:int = 0; i < INS_NAME.length; i++)
            {
                if (_resultMC[i].stage != null) {
                    _originalParent.removeChild(_resultMC[i]);
                }
            };
        }

        public function getSuccessThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            result = 0;
            return getShowThread(stage, at, type);
        }

        public function getFailedThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            result = 1;
            return getShowThread(stage, at, type);
        }


        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return  new ShowThread(this, stage);
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(text:String=""):Thread
        {
            return  new HideThread(this);
        }

        // 透明度操作用のスレッドを返す
        public function getTempHideThread(alpha:Number):Thread
        {
            return  new TempHideThread(this, alpha);
        }
    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.image.game.ResultRollImage;
import view.BaseShowThread;
import view.BaseHideThread;


// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{
    private var _ri:ResultRollImage;
    private static const _RESULT_ROLL_SPEED:int = Unlight.SPEED + 5;

    public function ShowThread(ri:ResultRollImage, stage:DisplayObjectContainer)
    {
        _ri = ri;
        super(ri, stage);
    }

    protected override function run():void
    {
        // ロードを待つ
        if (_ri.loaded == false)
        {
            _ri.wait();
        }
        next(close);
    }


    protected override function close():void
    {
        _view.init();
        addStageAt();
        next(showResult);

    }

    private function showResult():void
    {
        stopResult();
        _ri.alpha = 1.0;
        _ri.playResultMC();
        next(waiting);
    }

    // 待機
    private function waiting():void
    {
        sleep(2000 / _RESULT_ROLL_SPEED);
        // next(hide);
    }

    // 隠れる
    public function hide():void
    {
        var resultTweener:Thread = new BeTweenAS3Thread(_ri, {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        resultTweener.join();
        resultTweener.start();
    }

    // 隠れる
    public function stopResult():void
    {
        _ri.stopResultMC();
    }

}
// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    private var _ri:ResultRollImage;

    public function HideThread(ri:ResultRollImage)
    {
        _ri = ri;
        super(ri);
    }

    protected override function run():void
    {
        next(hideResult);
    }

    private function hideResult():void
    {
        next(hide);
    }

    // 隠れる
    public function hide():void
    {
        log.writeLog(log.LV_INFO, this, "ResultRollImage Hide Thread!!!!!!!!!!!!!!");
        var resultTweener:Thread = new BeTweenAS3Thread(_ri, {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
        resultTweener.join();
        resultTweener.start();
        next(stopResult);
    }

    // 隠れる
    public function stopResult():void
    {
        _ri.stopResultMC();
    }

}

// 一時的なHideスレッド
class TempHideThread extends BaseHideThread
{
    private var _ri:ResultRollImage;
    private var _alpha:Number;
    public function TempHideThread(ri:ResultRollImage, alpha:Number)
    {
        _ri = ri;
        _alpha = alpha;
        super(ri);
    }

    protected override function run():void
    {
        next(hideResult);
    }

    private function hideResult():void
    {
        next(hide);
    }

    // 隠れる
    public function hide():void
    {
        log.writeLog(log.LV_INFO, this, "ResultRollImage Hide Thread!!!!!!!!!!!!!!");
        var resultTweener:Thread = new BeTweenAS3Thread(_ri, {alpha:_alpha}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        resultTweener.join();
        resultTweener.start();
    }
}

