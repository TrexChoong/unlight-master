package view.image.requirements
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * CombineLevelUpImage表示クラス
     *
     */


    public class CombineLevelUpImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/compo/compo_lvup.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */

        public function CombineLevelUpImage()
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
            _root.gotoAndPlay(0);
        }

        public function resetAnime():void
        {
            waitComplete(resetAnimeComplete)
        }

        public function resetAnimeComplete():void
        {
            _root.gotoAndStop(0);
        }
    }

}
