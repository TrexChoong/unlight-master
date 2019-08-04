package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.utils.*;

    import mx.core.UIComponent;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;

    import view.image.BaseImage;
    import controller.*;

    /**
     * ターン表示クラス
     *
     */


    public class TimeGauge extends Sprite
    {


        private static const COLOR_A_TIME:Number = 0.6; // カラーAになるタイミング
        private static const COLOR_B_TIME:Number = 0.3; // カラーBになるタイミング


        private var LEFT_X:int = -50;

        private static const _X:int = 405;
        private static const _Y:int = 338;

        private static const _W:int = 353;
        private static const _H:int = 2;

        private var _scaleX:Number = 1;

        private var _gauge:Shape = new Shape();
        private var _color:ColorTransform = new ColorTransform(1,1,1,1,100,255,50);
        private var _tween:ITween;

        /**
         * コンストラクタ
         *
         */
        public function TimeGauge(left:Boolean = false)
        {
             x = _X;
             y = _Y;
            super();
            if(left)
            {
                x = x+LEFT_X;
                _scaleX = -1;
            }else{

            }
            initGauge();
            addChild(_gauge);
        }

        private function initGauge():void
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

        public function colorChangeStart(time:Number):void
        {
            var aTime:Number = time*COLOR_A_TIME;
            var bTime:Number = time*COLOR_B_TIME;

             _tween = BetweenAS3.serial
                (
                    BetweenAS3.tween(_gauge,
                                     { transform: {colorTransform: { redOffset:255, greenOffset:205, blueOffset:50}}},
                                     {transform: { colorTransform: { redOffset:100, greenOffset:255, blueOffset:50}}},
                                     aTime
                        ),
                    BetweenAS3.tween(_gauge,
                                     { transform: {colorTransform: { redOffset:255, greenOffset:0, blueOffset:0}}},
                                     {transform: { colorTransform: { redOffset:255, greenOffset:205, blueOffset:50}}},
                                     bTime
                    )
                    );
//.play();
             _tween.play();
        }

        public function colorChangeStop():void
        {
            if (_tween!=null)
            {
                _tween.stop();
            }
        }

        public function reset():void
        {
            _gauge.transform.colorTransform = _color;
        }


    }

}
