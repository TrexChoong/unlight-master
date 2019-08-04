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
    public class OpeningDown extends BaseImage
    {
        // result表示元SWF
        [Embed(source="../../../../data/image/game/opening/op_down.swf")]
        private var _Source:Class;

        private const _BLD_P:String = "blood_p";
        private const _BLD_E:String = "blood_e";

        private var _bldPlayer:MovieClip;
        private var _bldEnemy:MovieClip;
        private var _playerVisible:Boolean = true;
        private var _enemyVisible:Boolean = true;

        /**
         * コンストラクタ
         *
         */
        public function OpeningDown()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _bldPlayer = MovieClip(_root.getChildByName(_BLD_P));
            _bldEnemy = MovieClip(_root.getChildByName(_BLD_E));
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function getAnimeThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new GoToPlayThread(_root));
            return pExec;
        }

        public function set playerVisible(f:Boolean):void
        {
            _playerVisible = f;
            waitComplete(setPlayerVisible);
        }
        private function setPlayerVisible():void
        {
            _bldPlayer.visible = _playerVisible;
        }
        public function set enemyVisible(f:Boolean):void
        {
            _enemyVisible = f;
            waitComplete(setEnemyVisible);
        }
        private function setEnemyVisible():void
        {
            _bldEnemy.visible = _enemyVisible;
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
