package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import controller.*;

    /**
     * ヒットエフェクト表示クラス
     *
     */

    public class HitSlashEffect extends BaseHitEffect
    {
        // atkダイス表示元SWF
        [Embed(source="../../../../data/image/game/effect_hit_slash.swf")]
        private static var _source:Class;
        // ゲームのコントローラ

        /**
         * コンストラクタ
         *
         */
        public function HitSlashEffect()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _root.visible = false;
        }

        override protected function get Source():Class
        {
            return _source;
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
            SE.getDamageSwordSEThread(0).start();
//            new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ,0.5 ,false).start();
        }
    }
}
