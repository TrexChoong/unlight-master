package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * 観戦待ちImage
     *
     */


    public class WatchWaitImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/game/think_watch.swf")]
        private var _Source:Class;
        private static const X:int = 380;
        private static const Y:int = 250;


        /**
         * コンストラクタ
         *
         */
        public function WatchWaitImage()
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
            x = X;
            y = Y;
            alpha = 1.0;
        }



    }

}
