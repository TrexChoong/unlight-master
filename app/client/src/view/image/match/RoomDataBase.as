package view.image.match
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class RoomDataBase extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/match/b_lobby_list_detail.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function RoomDataBase()
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
        }
    }

}
