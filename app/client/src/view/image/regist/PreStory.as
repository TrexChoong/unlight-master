package view.image.regist
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import view.FramePlayThread;
    /**
     * HP表示クラス
     *
     */

    public class PreStory extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/regist/prestory.swf")]
        private var _Source:Class;
        private static const SCALE:Number = 1.0;
        private static const X:int = 0;
        private static const Y:int = 0;

        private static const SKIP:String = "btn_skip";
        private var _skipButton:SimpleButton;

        private var _playThread:FramePlayThread;

        /**
         * コンストラクタ
         *
         */
        public function PreStory()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _skipButton = SimpleButton(_root.getChildByName(SKIP));
            _root.gotoAndStop(0);
            _skipButton.addEventListener(MouseEvent.CLICK,skipButtonHandler);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public override function init():void
        {


        }
        public override function final():void
        {
            _skipButton.removeEventListener(MouseEvent.CLICK,skipButtonHandler);
        }

        private function skipButtonHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "button",_playThread.state);
            if (_playThread != null && _playThread.state==ThreadState.RUNNABLE)
            {
                log.writeLog(log.LV_FATAL, this, "button done",_playThread.state);
                _playThread.interrupt();
            }
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
           _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(super.getShowThread(stage, at, type));
            _playThread =  new FramePlayThread(_root, _root.totalFrames);
            sExec.addThread(_playThread);
            return sExec;
        }

        // 表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            sExec.addThread(super.getHideThread());
            return sExec;
        }



    }

}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import org.libspark.thread.Thread;

import model.Duel;
import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.game.DuelTable;
import org.libspark.thread.utils.*;

class ShowThread extends BaseShowThread
{

    public function ShowThread(dt:DuelTable, stage:DisplayObjectContainer)
    {
        super(dt, stage)
    }

    protected override function run():void
    {
        // デュエルの準備を待つ
        if (Duel.instance.inited == false)
        {
            Duel.instance.wait();
        }
        next(init);
    }


    private function init ():void
    {
        var thread:Thread;
        thread =  DuelTable(_view).tableInitialize(Sprite(_stage));
        thread.start();
        thread.join();
        next(close);
    }

}

