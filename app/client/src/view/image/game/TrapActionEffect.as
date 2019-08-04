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

    public class TrapActionEffect extends BaseImage
    {
        // 表示元SWF
        [Embed(source="../../../../data/image/game/effect_trap_act.swf")]
        private static var _source:Class;
        private var _effect:MovieClip = null;
        private var _kind:String;
        private var _trapMC:Array = [];
        private static const ACTION_KIND:Array = ["trap_act_a", "trap_act_b", "trap_act_c", "trap_act_d", "trap_act_e"];
        // ゲームのコントローラ

        /**
         * コンストラクタ
         *
         */
        public function TrapActionEffect(kind:String)
        {
            _kind = kind;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            for (var i:int = 0; i < ACTION_KIND.length; i++)
            {
                _trapMC.push(MovieClip(_root.getChildByName(ACTION_KIND[i])));
                _trapMC[i].visible = false;
            }
            _effect = _trapMC[ACTION_KIND.indexOf("trap_act_" + _kind)];
            _effect.alpha = 0.9;
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
            SE.playTrapAction();
            _effect.visible = true;
            //_root.gotoAndPlay(1);
            _effect.play();
//            _root.play();
//            new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ,0.5 ,false).start();
        }
    }
}
