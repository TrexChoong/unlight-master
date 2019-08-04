package view.image.option
{

    import flash.display.*;
    import flash.events.Event;
    import model.DeckEditor;
    import model.events.*;
    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/option/config.swf")]
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
