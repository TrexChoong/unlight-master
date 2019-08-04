package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * キャラチェンジ中アイコン
     *
     */


    public class CharaChangeThinkImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/game/think.swf")]
        private var _Source:Class;
        private static const Y:int = 250;


        /**
         * コンストラクタ
         *
         */
        public function CharaChangeThinkImage()
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
            y = Y;
        }



    }

}
