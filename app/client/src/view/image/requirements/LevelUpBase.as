package view.image.requirements
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * LevelUpBase表示クラス
     *
     */


    public class LevelUpBase extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/compo/compo_lvupbase.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private const OK_BUTTON:String = "btn_ok"
        private var _okButton:SimpleButton;

        private var _num:int = 0;

        /**
         * コンストラクタ
         *
         */

        public function LevelUpBase()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _okButton = SimpleButton(_root.getChildByName(OK_BUTTON));
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // ボタンを取得
        public function get ok():SimpleButton
        {
            return _okButton;
        }

    }

}
