package view.image.library
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class StoryTitle extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/library/story_title.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private var _charaId:int = 1;

        /**
         * コンストラクタ
         *
         */
        public function StoryTitle( id:int=1 )
        {
            super();
            _charaId = id;
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
            _root.gotoAndStop(_charaId);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
        }

        public function changeCharaFace(id:int):void
        {
            _charaId = id;
            if (_root) _root.gotoAndStop(0);
        }

    }

}
