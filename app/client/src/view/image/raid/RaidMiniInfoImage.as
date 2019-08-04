package view.image.raid
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;
    import view.utils.*;


    /**
     * RaidMiniInfo表示クラス
     *
     */

    public class RaidMiniInfoImage extends BaseImage
    {
        [Embed(source="../../../../data/image/raid/raid_info_mini.swf")]
        private var _Source:Class;

        private static const MONSTER      :String  ="monster";

        private var _monster:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function RaidMiniInfoImage()
        {
            super();
        }
        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            _monster = MovieClip(_root.getChildByName(MONSTER));
            _monster.visible = false;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function set monsterId(id:int):void
        {
            // if (id == 0) {
            //     _monster.visible = false;
            // } else {
            //     _monster.gotoAndStop(id);
            //     _monster.visible = true;
            // }
        }



    }

}
