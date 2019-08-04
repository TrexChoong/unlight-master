
package view.image.game
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
     * ターン表示クラス
     *
     */

    public class HPGauge extends Sprite
    {
        private static const COLOR_A_TIME:Number = 0.6; // カラーAになるタイミング
        private static const COLOR_B_TIME:Number = 0.3; // カラーBになるタイミング

        private static const _SCALE_MIM:Number = 0.005;
        private static const _CALC_HP_MAX:int = 10000;

        private var LEFT_X:int = 760;

        private static const _X:int = 0;
        private static const _Y:int = 436;

        private static const _W:int = 354;
        private static const _H:int = 3;

        protected var _scaleX:Number = 1;

        protected var _gauge:Shape = new Shape();
        protected var _color:ColorTransform = new ColorTransform(1,1,1,1,255,0,0);
        protected var _tween:ITween;
        protected var _maxHp:int;
        protected var _hp:int;
        protected var _enemy:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function HPGauge(enemy:Boolean = false)
        {
             x = _X;
             y = _Y;
             _enemy = enemy;
            super();
            if(enemy)
            {
                x = x+LEFT_X;
                _scaleX = -1;
            }else{

            }
            initGauge();
            addChild(_gauge);
            scale(0);
        }

        protected function initGauge():void
        {
            _gauge.graphics.clear();
            _gauge.graphics.lineStyle(0, 0x000000,0);
            _gauge.graphics.beginFill(0x000000);
            _gauge.graphics.drawRect(0,0,_W,_H);
            _gauge.transform.colorTransform = _color;
        }


       public function scale(num:Number):void
        {
            scaleX = num*_scaleX;
        }

        public function startAnime():void
        {
            visible =true;
            BetweenAS3.tween(this,
                             {scaleX:1*_scaleX*(_hp/_maxHp)},
                             {scaleX:0},
                             2
                        ).play()

        }

        public function setHP(hp:int, maxHP:int):void
        {
            log.writeLog(log.LV_FATAL, this, "sethp",hp,maxHP);
            _maxHp = maxHP;
            _hp = hp;
        }

        public function getUpdateHPThread(hp:int):Thread
        {
            _hp = hp;
            var nowScale:Number = Math.abs(_scaleX);
            nowScale = 1*nowScale*(_hp/_maxHp);
            if (nowScale > 0 && nowScale <= _SCALE_MIM) {
                nowScale = _SCALE_MIM;
            } else if (nowScale < 0) {
                nowScale = 0;
            }
            if (_enemy) {
                nowScale *= -1;
            }
            return new BeTweenAS3Thread(this,
                                        {scaleX:nowScale},
                                        null,
                                        0.1,
                                        BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true)

        }



    }

}
