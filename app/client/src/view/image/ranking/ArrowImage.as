package view.image.ranking
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * キャラチェンジ中アイコン
     *
     */


    public class ArrowImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/ranking/rankarrow.swf")]
        private var _Source:Class;
        private var _dir:int = 0;
        private static const _DIRECTIN_FRAME:Array = [-1,1,3,4,5]; /* of int */ 

        /**
         * コンストラクタ
         *
         */
        public function ArrowImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function setDirection(i:int):void
        {
            _dir = _DIRECTIN_FRAME[i];
            waitComplete(direction);
        }

        public function direction():void
        {
            if (_dir >0)
            {
                visible = true;
                _root.gotoAndStop(_dir);
            }else{
                visible = false;
            }
        }

    }

}
