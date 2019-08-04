package view.image.requirements
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * LevelUpBase表示クラス
     *
     */


    public class LevelUpEffect extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/compo/compo_effect_lvup.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private var _num:int = 0;

        /**
         * コンストラクタ
         *
         */

        public function LevelUpEffect()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _root.gotoAndStop(0);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function onAnime():void
        {
            waitComplete(onAnimeComplete)
        }

        public function onAnimeComplete():void
        {
//            _root.stop();
//            new GoToPlayThread(_root).start();
//            _root.gotoAndPlay(0);
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