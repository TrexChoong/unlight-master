package view.image.raid
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.utils.*;

    import mx.core.UIComponent;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import view.image.game.HPGauge;
    import controller.*;

    /**
     * 時間制限ゲージ表示クラス
     *
     */

    public class TimeLimitGauge extends Sprite
    {
        private static const _X:int = 73;
        private static const _Y:int = 80;

        private static const _W:int = 198;
        private static const _H:int = 3;

        private var _scaleX:Number = 1;
        private var _gauge:Shape = new Shape();
        private var _now:int = 0;
        private var _max:int = 0;

        // ゲージ点滅を開始する長さ
        private const _LIMIT_ALERT_SCALE:Number = 0.25;

        /**
         * コンストラクタ
         *
         */
        public function TimeLimitGauge()
        {
            x = _X;
            y = _Y;
            super();
            addChild(_gauge);
            initGauge();
            addChild(_gauge);
            scale(0);
        }

        private function initGauge():void
        {
            _gauge.graphics.clear();
            _gauge.graphics.lineStyle(0, 0x000000,0);
            _gauge.graphics.beginFill(0x000000);
            _gauge.graphics.drawRect(0,0,_W,_H);
            _gauge.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,255);
        }

        public function scale(num:Number):void
        {
            scaleX = num*_scaleX;
        }

        public function setTime(now:int, max:int):void
        {
            _max = max;
            _now = now;
        }

        public function getUpdateTimeThread(now:int):Thread
        {
            _now = now;
            var scale:Number = 1*_scaleX*(_now/_max);
            if (scale <= 0.0) {scale = 0.0;}
            return new BeTweenAS3Thread(this,
                                        {scaleX:scale},
                                        null,
                                        0.1,
                                        BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true)

        }

        public function get timeLimitAlert():Boolean
        {
            return (scaleX < _LIMIT_ALERT_SCALE && scaleX > 0.0);
        }

    }

}
