package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import view.image.BaseImage;
    import controller.*;

    /**
     * タイマーのベースクラス
     *
     */


    public class TimeBase extends BaseImage
    {
        // 元SWF
        // ターン表示・タイマー
        [Embed(source="../../../../data/image/game/time_base.swf")]
        private var _Source:Class;


        private static const TIME_BASE:String = "time_base"
        private var _timeBase:MovieClip;

        private var _warning:Boolean = false;

        private var _scaleX:Number = 1;
        /**
         * コンストラクタ
         *
         */
        public function TimeBase()
        {
            x = 0;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _timeBase = MovieClip(_root.getChildByName(TIME_BASE));
            _timeBase.gotoAndStop(0);
            updateGauge();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function setWarning():void
        {
            // s
            if (!_warning)
            {
                _warning = true;
                waitComplete(updateGauge);
            }
        }

        public function setNormal():void
        {
            if (_warning)
            {
                _warning = false;
                waitComplete(updateGauge);
            }
        }

        private function updateGauge():void
        {
            if (_warning)
            {
                _timeBase.gotoAndPlay("warning");
            }else{
                _timeBase.gotoAndStop(1);

            }
        }




    }
}
