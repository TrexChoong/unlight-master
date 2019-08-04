package view.image.library
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class CharaCardPageButton extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/library/library_select.swf")]
        private var _Source:Class;

        private static const UNLIGHT_BTN:String = "btn_select_u";
        private static const REBORN_BTN:String  = "btn_select_r";

        private var _ulCardBtn:SimpleButton;
        private var _rbCardBtn:SimpleButton;

        private var _ulCardBtnVisible:Boolean = false;
        private var _rbCardBtnVisible:Boolean = true;

        /**
         * コンストラクタ
         *
         */
        public function CharaCardPageButton()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            _ulCardBtn = SimpleButton(_root.getChildByName(UNLIGHT_BTN));
            _rbCardBtn = SimpleButton(_root.getChildByName(REBORN_BTN));
            _ulCardBtn.visible = _ulCardBtnVisible;
            _rbCardBtn.visible = _rbCardBtnVisible;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function get ulCardBtn():SimpleButton
        {
            return _ulCardBtn;
        }
        public function get rbCardBtn():SimpleButton
        {
            return _rbCardBtn;
        }

        public function btnVisible(ulCardBtnVisible:Boolean,rbCardBtnVisible:Boolean):void
        {
            _ulCardBtnVisible = ulCardBtnVisible;
            _rbCardBtnVisible = rbCardBtnVisible;
            waitComplete(setBtnVisible);
        }
        private function setBtnVisible():void
        {
            _ulCardBtn.visible = _ulCardBtnVisible
            _rbCardBtn.visible = _rbCardBtnVisible
        }
    }

}
