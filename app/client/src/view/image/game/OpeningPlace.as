package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.SleepThread;
    import view.image.BaseImage;

    /**
     * 場所部分の表示枠クラス
     *
     */
    public class OpeningPlace extends BaseImage
    {
        // レーデンベルグ城中庭
        [Embed(source="../../../../data/image/game/opening/op_place00a.swf")]
        private static var _castle:Class;
        // 森
        [Embed(source="../../../../data/image/game/opening/op_place00a.swf")]
        private static var _forest:Class;

        // 条件チップの配列
        private static var ClassArray:Array = [_castle, _forest];

        // 表示タイプ
        private var _type:int;

        /**
         * コンストラクタ
         *
         */
        public function OpeningPlace(id:int)
        {
            _type = id;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return ClassArray[_type];
        }

        public function getAnimeThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new GoToPlayThread(_root));
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

    public function GoToPlayThread(mc:MovieClip)
    {
        _mc = mc;
    }

    protected override function run():void
    {
        _mc.gotoAndPlay(1);
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
