package view.image.lot
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * LotInfoImage表示クラス
     *
     */


    public class LotInfoImage extends BaseImage
    {

//         // Lotinfoimage表示元SWF
//         [Embed(source="../../../../data/image/ok.swf")]
        // Lotinfoimage表示元SWF
        [Embed(source="../../../../data/image/lot/gacha_prob.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function LotInfoImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {

            super.swfinit(event);
            x += -142;
            y += -470;

            // x += -188;
            // y += -360;

        }

        override protected function get Source():Class
        {
            return _Source;
        }
    }

}
