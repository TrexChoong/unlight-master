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
    public class ResultImage extends BaseImage
    {

        // result表示元SWF
        [Embed(source="../../../../data/image/game/result/maincall.swf")]
        private var _Source:Class;

        private var _resultMC:Array = [];
        private var _result:int;

        // サーバから送られてくる結果に合わせたIndex
        // Win:0,LOSE:1,DRAW:2,DEAD_END:3,DELETE:4,PO_DELETE:5,TIMEUP:6
        public static const RESULT_IDX:Array = [0,1,2,1,1,1,4];

        private static const INS_NAME:Array = ["win", "lose", "draw", "start", "timeup"]
        private var _winMC:MovieClip;
        private var _loseMC:MovieClip;
        private var _drawMC:MovieClip;
        private var _startMC:MovieClip;
        private var _timeupMC:MovieClip;

        private var _originalParent:DisplayObjectContainer;

        /**
         * コンストラクタ
         *
         */
        public function ResultImage(r:int = 0)
        {
            _resultMC = [_winMC, _loseMC, _drawMC, _startMC, _timeupMC];
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
                // log.writeLog(log.LV_INFO, this, "swfinit!!!!!!!!!!!!!!",_originalParent);
            }
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
            _originalParent.addChildAt(_resultMC[_result],0);
            _resultMC[_result].gotoAndPlay(1);
        }

        public function stopResultMC():void
        {
            waitComplete(setStopResultMC)
        }

        private function  setStopResultMC():void
        {
            // log.writeLog(log.LV_INFO, this, "setStopResultMC!!!!!!!!!!!!!!",_originalParent);
            if ( _originalParent.numChildren > 0 &&_originalParent.getChildAt(0) == _resultMC[_result] ) {
                _originalParent.removeChild(_resultMC[_result]);
            }
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


    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.image.game.ResultImage;
import view.BaseShowThread;
import view.BaseHideThread;


// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{
    private var _ri:ResultImage;

    public function ShowThread(ri:ResultImage, stage:DisplayObjectContainer)
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
        _ri.alpha = 1.0;
        _ri.playResultMC();
        next(waiting);
    }

    // 待機
    private function waiting():void
    {
        sleep(2000)
//        next(hide);
        next(stopResult);
    }

    // // 隠れる
    // public function hide():void
    // {
    //     var resultTweener:Thread = new BeTweenAS3Thread(_ri, {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
    //     resultTweener.join();
    //     resultTweener.start();
    //     next(stopResult);
    // }

    // 隠れる
    public function stopResult():void
    {
//        _ri.stopResultMC();
    }

}
// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    private var _ri:ResultImage;

    public function HideThread(ri:ResultImage)
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
        log.writeLog(log.LV_INFO, this, "ResultImage Hide Thread!!!!!!!!!!!!!!");
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
