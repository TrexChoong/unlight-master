package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import flash.events.MouseEvent;

    import view.image.BaseImage;

    /**
     * 空のカードベース
     *
     */


    public class EmptyCardBaseImage extends BaseImage
    {

        // EmptyCardBaseImage表示元SWF
        [Embed(source="../../../../data/image/game/cardempty.swf")]
        private var _Source:Class;


        /**
         * コンストラクタ
         *
         */
        public function EmptyCardBaseImage()
        {
            super();

        }

        override protected function get Source():Class
        {
            return _Source;
        }


        public override function init():void
        {
            onAddCard();
        }        

        public function onAddCard():void
        {
            waitComplete(setAddCard);
        }

        private function setAddCard():void
        {
            _root.gotoAndPlay("add");
        }


    }

}
