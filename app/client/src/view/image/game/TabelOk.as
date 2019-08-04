package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * StageOk表示クラス
     *
     */


    public class StageOk extends BaseImage
    {

//         // StageOk表示元SWF
//         [Embed(source="../../../../data/image/ok.swf")]
        // StageOk表示元SWF
        [Embed(source="../../../../data/image/game/ok.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function BG()
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
