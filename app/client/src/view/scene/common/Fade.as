package view.scene.common
{
    import flash.display.*;
    import flash.geom.*;

    import mx.core.UIComponent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;

    /**
     * フェード表示クラス
     *
     */

    public class Fade extends BaseScene
    {
        // フェード本体
        private var _shape:Shape = new Shape();

        // フェード全体の長さ
        private var _time:Number;

        // フェードの濃さ
        private var _alpha:Number;

        /**
         * コンストラクタ
         *
         */
        public function Fade(time:Number = 1.0, alpha:Number = 0.5)
        {
            _time = time;
            _alpha = alpha;

            _shape.alpha = 0;
            _shape.graphics.beginFill(0x000000);
            _shape.graphics.drawRect(0, 0, 1024, 768);

        }

        public override function init():void
        {
            addChild(_shape);
//            var thread:Thread = new TweenerThread(_shape, {alpha:_alpha, transition:"easeOutSine", time:_time, show:true});
            var thread:Thread = new BeTweenAS3Thread(_shape, {alpha:_alpha}, null, _time, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
            thread.start();
        }

        public override function final():void
        {
            removeChild(_shape);
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 非表示スレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }
    }

}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.common.Fade;

class ShowThread extends BaseShowThread
{
    public function ShowThread(f:Fade, stage:DisplayObjectContainer, at:int)
    {
        super(f, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(f:Fade)
    {
        super(f);
    }
}
