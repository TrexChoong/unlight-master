package view.image.match
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class RoomDataStageBase extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/match/b_lobby_list_detail_stage00.swf")]
        private static var _stg0:Class;

        private static var ClassArray:Array = [_stg0];
        private var _type:int;

        /**
         * コンストラクタ
         *
         */
        public function RoomDataStageBase(type:int = 0)
        {
            _type = type
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
        }

        override protected function get Source():Class
        {
            return ClassArray[_type];
        }

        public function initializePos():void
        {
        }
    }

}
