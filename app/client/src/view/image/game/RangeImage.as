package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Duel;
    import view.image.BaseImage;

    /**
     * 距離感表示クラス
     *
     */


    public class RangeImage extends BaseImage
    {
        // Range表示元SWF
        [Embed(source="../../../../data/image/game/range.swf")]
        private var _Source:Class;

        /**
         * コンストラクタ
         *
         */
        public function RangeImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            onMiddle();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function initInstance():void
        {
            MovieClip(_root.getChildByName("short")).visible = false;
            MovieClip(_root.getChildByName("middle")).visible = false;
            MovieClip(_root.getChildByName("long")).visible = false;
            MovieClip(_root.getChildByName("hiding")).visible = false;
        }

        public function onShort():void
        {
            waitComplete(initInstance);
            waitComplete(setShort);
        }
        public function onMiddle():void
        {
            waitComplete(initInstance);
            waitComplete(setMiddle);
        }
        public function onLong():void
        {
            waitComplete(initInstance);
            waitComplete(setLong);
        }
        public function onHiding():void
        {
            waitComplete(initInstance);
            waitComplete(setHiding);
        }

        private function setShort():void
        {
            MovieClip(_root.getChildByName("short")).visible = true;
            MovieClip(_root.getChildByName("short")).gotoAndPlay(1);
            new GoToPlayThread(MovieClip(_root.getChildByName("short")), 1).start();
        }
        private function setMiddle():void
        {
            MovieClip(_root.getChildByName("middle")).visible = true;
            MovieClip(_root.getChildByName("middle")).gotoAndPlay(1);
            new GoToPlayThread(MovieClip(_root.getChildByName("middle")), 17).start();
        }
        private function setLong():void
        {
            MovieClip(_root.getChildByName("long")).visible = true;
            MovieClip(_root.getChildByName("long")).gotoAndPlay(1);
            //   new GoToPlayThread(MovieClip(_root.getChildByName("long")), 33).start();
            new GoToPlayThread(MovieClip(_root.getChildByName("long")), 17).start();
        }
        private function setHiding():void
        {
            MovieClip(_root.getChildByName("hiding")).visible = true;
            MovieClip(_root.getChildByName("hiding")).gotoAndPlay(1);
            new GoToPlayThread(MovieClip(_root.getChildByName("hiding")), 17).start();
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
    private static var _frame:int;

    public function GoToPlayThread(mc:MovieClip, frame:int)
    {
        _mc = mc;
        _frame = frame;
    }

    protected override function run():void
    {
        if(_mc.currentFrame < _frame)
        {
            _mc.nextFrame();
            next(run);
        }
        else if(_mc.currentFrame > _frame)
        {
            _mc.prevFrame();
            next(run);
        }
    }
}
