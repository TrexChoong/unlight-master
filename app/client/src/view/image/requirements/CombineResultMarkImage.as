package view.image.requirements
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * CombineResultMarkImage表示クラス
     *
     */


    public class CombineResultMarkImage extends BaseImage
    {
        public static const MARK_TYPE_UP:int   = 1;
        public static const MARK_TYPE_DOWN:int = 2;
        public static const MARK_TYPE_PLUS:int = 3;

        // HP表示元SWF
        [Embed(source="../../../../data/image/compo/compo_result_mark.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private var _type:int = MARK_TYPE_UP;

        /**
         * コンストラクタ
         *
         */

        public function CombineResultMarkImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _root.gotoAndStop(_type);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function set type(t:int):void
        {
            _type = t;
            waitComplete(setMarkType);
        }
        private function setMarkType():void
        {
            _root.gotoAndStop(_type);
        }

    }

}
