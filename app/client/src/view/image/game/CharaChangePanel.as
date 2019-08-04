package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import model.Duel;
    import view.image.BaseImage;

    /**
     * キャラチェンジパネル
     *
     */


    public class CharaChangePanel extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/game/panel_change.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private var _okAButton   :SimpleButton;
        private var _okBButton   :SimpleButton;
        private var _closeButton :SimpleButton;

        /**
         * コンストラクタ
         *
         */
        public function CharaChangePanel()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _okAButton   = SimpleButton(_root.getChildByName("ok_a"));
            _okBButton   = SimpleButton(_root.getChildByName("ok_b"));
            _closeButton = SimpleButton(_root.getChildByName("close"));
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function get leftButton():SimpleButton
        {
            return _okAButton;
       }

        public function get rightButton():SimpleButton
        {
            return _okBButton;
        }

        public function get closeButton():SimpleButton
        {
            return _closeButton;
        }

    }

}
