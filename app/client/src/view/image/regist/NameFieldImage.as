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
     * 名前入力背景
     *
     */

    public class NameFieldImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/regist/make_1name.swf")]
        private var _Source:Class;

        private static const SCALE:Number = 1.0;
        private static const X:int = 0;
        private static const Y:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function NameFieldImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _root.gotoAndStop(1);
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
            alpha = 1.0;
        }

    }

}

