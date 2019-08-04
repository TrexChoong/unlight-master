package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * WatchResultPanel表示クラス
     *
     */


    public class WatchResultPanel extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/game/result_watch.swf")]
        private var _Source:Class;

        /**
         * コンストラクタ
         *
         */
        public function WatchResultPanel()
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
