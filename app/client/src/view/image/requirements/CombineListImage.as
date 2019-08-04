package view.image.requirements
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * CombineListImage表示クラス
     *
     */


    public class CombineListImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/compo/compo_stock.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */

        public function CombineListImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

    }

}
