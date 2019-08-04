package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import model.Duel;
    import view.image.BaseLoadImage;
    import controller.*;

    /**
     * FeatImage表示クラス
     *
     */


    public class PassiveSkillImage extends BaseLoadImage
    {

        // ゲームのコントローラ

        /**
         * コンストラクタ
         *
         */
        public function PassiveSkillImage(url:String)
        {
            super(url);
        }


        override protected function swfinit(event: Event): void
        {

            super.swfinit(event);
            _root.gotoAndStop(0);
        }

        public function plAnime():void
        {
            waitComplete(plAnimation);
        }

        public function foeAnime():void
        {
            waitComplete(foeAnimation);
        }

        private function plAnimation():void
        {
            x = 0;
            scaleX = 1;
            SE.getFeatInsertSEThread(0).start();
            _root.gotoAndPlay(1);
        }

        private function foeAnimation():void
        {
            x = Unlight.WIDTH;
            scaleX = -1;
            SE.getFeatInsertSEThread(0).start();
            _root.gotoAndPlay(1);
        }
    }
}
