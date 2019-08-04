package view.image.requirements
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
    import controller.*;

    /**
     * Expゲージ表示クラス
     *
     */

    public class ExpGauge extends Sprite
    {
        public static const TYPE_RESULT:int = 0;
        public static const TYPE_FRAME:int = 1;

        private static const COLOR_A_TIME:Number = 0.6; // カラーAになるタイミング
        private static const COLOR_B_TIME:Number = 0.3; // カラーBになるタイミング

        private static const _SCALE_MIM:Number = 0.005;
        private static const _CALC_HP_MAX:int = 10000;
        private static const _MAX:Number = 100.0;

        private var LEFT_X:int = 760;

        private static const _X:int = 0;
        private static const _Y:int = 0;

        private const _BAR_X:int = 0;
        private const _BAR_Y:int = 0;
        private const _BAR_R_W:int = 258;
        private const _BAR_R_H:int = 7;
        private const _BAR_F_W:int = 121;
        private const _BAR_F_H:int = 1;
        private const _BAR_W:Array = [_BAR_R_W,_BAR_F_W];
        private const _BAR_H:Array = [_BAR_R_H,_BAR_F_H];
        private static const _W:int = 250;
        private static const _H:int = 3;

        protected var _scaleX:Number = 1;

        protected var _gauge:Shape = new Shape();
        protected var _gaColor:ColorTransform = new ColorTransform(1,1,1,1,236,157,3);
        protected var _tween:ITween;
        protected var _expPercent:Number;

        private var _type:int = TYPE_RESULT;

        /**
         * コンストラクタ
         *
         */
        public function ExpGauge(type:int = TYPE_RESULT)
        {
            _type = type;
            x = _X;
            y = _Y;
            super();
            initGauge();
            addChild(_gauge);
            scale(0);
        }

        protected function initGauge():void
        {
            _gauge.graphics.clear();
            _gauge.graphics.lineStyle(0, 0x000000,0);
            _gauge.graphics.beginFill(0x000000);
            _gauge.graphics.drawRect(_BAR_X,_BAR_Y,_BAR_W[_type],_BAR_H[_type]);
            _gauge.transform.colorTransform = _gaColor;
        }


        public function scale(num:Number):void
        {
            _gauge.scaleX = num*_scaleX;
        }

        public function setGauge(percent:Number):void
        {
            // log.writeLog(log.LV_FATAL, this, "setGauge",percent);
            _expPercent = percent;
            _scaleX = (_expPercent/_MAX);
            if (_scaleX > 0 && _scaleX <= _SCALE_MIM) {
                _scaleX = _SCALE_MIM;
            } else if (_scaleX < 0) {
                _scaleX = 0;
            }
            // log.writeLog(log.LV_FATAL, this, "setGauge 1",_scaleX);
            _gauge.scaleX = _scaleX;
        }


    }

}
