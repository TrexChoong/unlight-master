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
     * トラップ表示クラス
     *
     */

    public class TrapEffect extends BaseImage
    {
        // 表示元SWF
        [Embed(source="../../../../data/image/game/effect_trap.swf")]
        private static var _source:Class;
        private var _effect:MovieClip = null;
        private var _kind:String;
        private var _turn:int;
        private var _xpos:int;
        private var _trapMC:Array = [];
        private static const MAX_TURN:int = 2;
        private static const TRAP_KIND:Array = ["trap_a", "trap_b", "trap_c", "trap_d", "trap_e"];

        /**
         * コンストラクタ
         *
         */
        public function TrapEffect(kind:String)
        {
            _kind = kind;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            for (var i:int = 0; i < TRAP_KIND.length; i++)
            {
                _trapMC.push(MovieClip(_root.getChildByName(TRAP_KIND[i])));
                _trapMC[i].visible = false;
            }
            _effect = _trapMC[TRAP_KIND.indexOf("trap_" + _kind)];
            _effect.alpha = 1.0;
        }

        override protected function get Source():Class
        {
            return _source;
        }

        public function onAnime(xpos:int, turn:int):void
        {
            _xpos = xpos;
            _turn = turn;
            waitComplete(onAnimeComplete);
        }

        public function get Turn():int
        {
            return _turn;
        }

        public function get Xpos():int
        {
            return _xpos;
        }

        public function get Visible():Boolean
        {
            return _effect.visible;
        }

        public function onAnimeComplete():void
        {
            if (0 < _turn && _turn < 3)
            {
                _effect.x = _xpos;
                _effect.gotoAndStop(MAX_TURN - _turn + 1); //残りターン1のときフレーム2、残りターン2のときフレーム1
                _effect.visible = true;
            }
            else if (_turn < 1)
            {
                _effect.visible = false;
            }
        }
    }
}
