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

    public class HitDamageStr extends BaseImage
    {
        // atkダイス表示元SWF
        [Embed(source="../../../../data/image/game/text_damage.swf")]
        private static var _source:Class;
        // ゲームのコントローラ

        /**
         * コンストラクタ
         *
         */
        public function HitDamageStr()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _source;
        }
    }
}
