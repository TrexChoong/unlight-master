package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.*;
    import mx.core.UIComponent;

    import view.image.BaseLoadImage;

    /**
     * CharaCardChara表示クラス
     *
     */


    public class CharaCardChara extends BaseLoadImage
    {


        private var _obverse:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function CharaCardChara(url:String )
        {
            // log.writeLog(log.LV_DEBUG, "[CharaCardChara] Constracta url", url);
            super(url);
        }

        private function clickHandler(e:MouseEvent):void
        {

           if (_obverse==true)
            {
                onReverse();
                _obverse = false;
            }
            else
            {
                onObverse();
                _obverse = true;
            }
        }

        public function onObverse():void
        {
            waitComplete(setObverse)
        }

        private function setObverse():void
        {
            _root.gotoAndStop(1);
        }


        public function onReverse():void
        {
            waitComplete(setReverse);
        }

        private function setReverse():void
        {
            _root.gotoAndStop(2);
        }

        public override function init():void
        {
            _root.cacheAsBitmap = true;
        }

        public function setSepiaEffect():void
        {
            var sepia:ColorMatrixFilter = new ColorMatrixFilter();
            sepia.matrix = [
                0.2,0.38,0.09, 0, -125,
                0.17,0.34,0.08,0,-125,
                0.14,0.27,0.07,0,-125,
                0.000, 0.000, 0.000, 1.000, 0
                ];

            var filters:Array = new Array();

            filters.push(sepia);
            this.filters = filters;
        }

    }

}
