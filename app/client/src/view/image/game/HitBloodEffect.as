package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.*;

    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.*;
    import controller.*;

    /**
     * ヒットエフェクト表示クラス
     *
     */

    public class HitBloodEffect extends  BaseHitEffect
    {
        // 
        [Embed(source="../../../../data/image/game/effect_dmg_blood.swf")]
        private static var _Source:Class;

        public static const CLIP_AREA:Rectangle = new Rectangle(0,0,100,100);

        /**
         * コンストラクタ
         *
         */
        public function HitBloodEffect(pow:int)
        {
            super();
            scaleX =scaleY = Math.random() * 0.7+0.1*pow;
            var i:int = 60*(2/scaleX+0.7/scaleX+0.7);
            x = Math.random() *  i - i/2;
            i = 50*(2/scaleX+0.7/scaleX+0.7);
            y = Math.random()  *  i - i/2;
            rotation = Math.random() * 360;

        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
            _root.visible = false;
            _root.stop();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {

        }

        public function onAnime():void
        {
            waitComplete(onAnimeComplete);
        }

        public function onAnimeComplete():void
        {
            _root.visible = true;
            _root.gotoAndPlay(1);
//            _root.play();
//            SE.getDamageGunSEThread(0).start();
        }

    }
}
