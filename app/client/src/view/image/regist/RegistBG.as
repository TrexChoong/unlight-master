package view.image.regist
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * HP表示クラス
     *
     */

    public class RegistBG extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/regist/make_bg.swf")]
        private var _Source:Class;
        private static const SCALE:Number = 1.0;
        private static const X:int = 0;
        private static const Y:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function RegistBG()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            scaleX = SCALE;
            scaleY = SCALE;
            x = X;
            y = Y;
            alpha = 0.0;
        }

        public override function init():void
        {

//            var bgTween:Thread = new TweenerThread(this, { alpha: 1.0, transition:"easeOutSine", time: 3.0, show: true });
            var bgTween:Thread = new BeTweenAS3Thread(this, {alpha:1.0}, null, 3.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
            bgTween.start();

        }

    }

}

