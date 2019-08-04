package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import mx.core.UIComponent;
    import flash.events.MouseEvent;

    import view.image.BaseImage;

    /**
     * PositionEnemy表示クラス
     *
     */


    public class PositionEnemy extends BaseImage
    {

        // PositionEnemy表示元SWF
        [Embed(source="../../../../data/image/position_enemy.swf")]
        private var _Source:Class;

        private var _pawnEnemy:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function PositionEnemy()
        {
            super();
          }


        // 初期化関数
        override protected function swfinit(event: Event): void {
            super.swfinit(event);
            _pawnEnemy = MovieClip( _root.getChildAt(0));
            onRight();
            _pawnEnemy.stop();
        }

        // 
        override protected function get Source():Class
        {
            return _Source;
        }



        public function onLeft():void
        {
            waitComplete(setLeft)
        }

        private function setLeft():void
        {
            _root.gotoAndStop(1);
        }


        public function onRight():void
        {
            waitComplete(setRight);
        }

        private function setRight():void
        {
            _root.gotoAndStop(2);
        }


    }

}
