package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.ClousureThread;
    import view.SleepThread;
    import view.image.BaseImage;

    /**
     * 会話部分の表示枠クラス
     *
     */
    public class OpeningName extends BaseImage
    {
        // result表示元SWF
        [Embed(source="../../../../data/image/game/opening/op_name.swf")]
        private var _Source:Class;

        // ラベル
        private static const Nums:Array = ["1on1","3on3"]
        private var _num:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function OpeningName(num:int)
        {
            _num = num;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function getAnimeThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new GoToPlayThread(_root, Nums[_num]));
//            _root.gotoAndPlay(Nums[_num]);

            return pExec;
        }
    }
}

import flash.display.*
import flash.events.Event;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

class GoToPlayThread extends Thread
{
    private var _mc:MovieClip;
    private var _str:String;

    public function GoToPlayThread(mc:MovieClip, str:String)
    {
        _str = str;
        _mc = mc;
    }

    protected override function run():void
    {
        _mc.gotoAndPlay(_str);
        _mc.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function enterFrameHandler(e:Event):void
    {
        if (_mc.currentFrame == _mc.totalFrames-1)
        {
            _mc.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            _mc.stop();
        }
    }
}
