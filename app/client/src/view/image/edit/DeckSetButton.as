package view.image.edit
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * DeckSetButton表示クラス
     *
     */


    public class DeckSetButton extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/edit/deck_set.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function DeckSetButton()
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

//            return SimpleButton(_root.getChildByName(BINDER_PREV));

    }

}
