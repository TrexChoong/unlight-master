package view.scene.lobby
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import view.image.lobby.*;
    import view.utils.RemoveChild;


    /**
     * LobbyBG表示クラス
     *
     */


    public class BG extends BaseScene
    {
        private var _bg:EntranceBG = new EntranceBG();

        /**
         * コンストラクタ
         *
         */
        public function BG()
        {
        }

        public override function init():void
        {
            alpha = 0.0;
            addChild(_bg);
        }
        public override function final():void
        {
            RemoveChild.apply(_bg);
        }
        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(super.getShowThread(stage, at));
            // var pExec:ParallelExecutor = new ParallelExecutor();
            // pExec.addThread(getShowSaleMCThread());
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            //sExec.addThread(pExec);
            return sExec;
        }
        public override  function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            sExec.addThread(super.getHideThread());
            return sExec;
        }



    }

}
