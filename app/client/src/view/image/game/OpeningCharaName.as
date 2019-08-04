package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;


    import flash.events.MouseEvent;

    import view.image.BaseLoadImage;

    /**
     * OpeningUpCharaName表示クラス
     *
     */


    public class OpeningCharaName extends BaseLoadImage
    {
        private var _player:Boolean = true;
        private var _mc:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function OpeningCharaName(player:Boolean, url:String)
        {
            super(url);
            _player = player;
            setPlayer();
        }

        public function setPlayer():void
        {
            waitComplete(setPlayerComplete);
        }

        public function setPlayerComplete():void
        {
            MovieClip(_root.getChildByName("left")).stop();
            MovieClip(_root.getChildByName("right")).stop();
        }

        public function getAnimeThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if(_player)
            {
                pExec.addThread(new GoToPlayThread(MovieClip(_root.getChildByName("left"))));
            }
            else
            {
                pExec.addThread(new GoToPlayThread(MovieClip(_root.getChildByName("right"))));
            }

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
        _mc.play();
    }
}
