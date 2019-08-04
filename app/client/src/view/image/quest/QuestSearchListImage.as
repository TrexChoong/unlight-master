package view.image.quest
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * QuestListImage表示クラス
     *
     */


    public class QuestSearchListImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/questsearch.swf")]
        private var _Source:Class;
        private static const CLOSE_BUTTON:String = "btn_close"
        private static const X:int = 0;
        private static const Y:int = 0;

        private var _closeButton:SimpleButton;
        /**
         * コンストラクタ
         *
         */
        public function QuestSearchListImage()
        {
            super();
//             mouseEnabled = false;
//             mouseChildren = false;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            initializePos();
            _closeButton = SimpleButton(_root.getChildByName(CLOSE_BUTTON));
            RemoveChild.apply(_root.getChildByName("sclbar_list"));
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
        }


        public function get closeButton():SimpleButton
        {
            return _closeButton;
        }

    }

}
