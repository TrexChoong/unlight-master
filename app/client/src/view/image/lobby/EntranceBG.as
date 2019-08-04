package view.image.lobby
{

    import flash.display.*;
    import flash.events.Event;
    import mx.core.*

    import view.image.BaseImage;
    import view.utils.*;
    /**
     * BG表示クラス
     *
     */


    public class EntranceBG extends BaseImage
    {

        [Embed(source="../../../../data/image/lobby/entrance_bg.swf")]
        private var _Source:Class;

        /**
         * コンストラクタ
         *
         */
        public function EntranceBG()
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

