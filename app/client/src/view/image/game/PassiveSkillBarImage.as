package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;
    import view.utils.*;


    /**
     * 表示クラス
     *
     */

    public class PassiveSkillBarImage extends BaseImage
    {
        [Embed(source="../../../../data/image/game/skill_passive.swf")]
        private var _Source:Class;

        private static const _PASSIVE:String = "passive";
        private var _passive:MovieClip;

        public static const STATE_OFF:String = "dis";
        public static const STATE_ON:String = "en";
        public static const STATE_MOTION:String = "motion";


        /**
         * コンストラクタ
         *
         */
        public function PassiveSkillBarImage()
        {
            super();
        }
        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            _passive = MovieClip(_root.getChildByName(_PASSIVE));
            _passive.gotoAndStop("dis");
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function changeState(state:String):void
        {
            _passive.gotoAndStop(state);
        }

        public function getState():String
        {
            return _passive.currentLabel;
        }

    }

}
