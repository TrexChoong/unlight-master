package view.image.quest
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

    public class QuestGauge extends UIComponent
    {


        private static const COLOR_A_TIME:Number = 0.6; // カラーAになるタイミング
        private static const COLOR_B_TIME:Number = 0.3; // カラーBになるタイミング

        private var LEFT_X:int = 760;

        private static const _X:int = -26;
        private static const _Y:int = 5;

        private static const _W:int = 64;
        private static const _H:int = 6;

        private var _scaleX:Number = 1;

        private var _gauge:Shape = new Shape();
        private var _gaugeFrame:Shape = new Shape();
        private var _color:ColorTransform = new ColorTransform(1,1,1,1,255,0,0);
        private var _tween:ITween;
        private var _questMapDiff:int;
        private var _clearNum:int;

        /**
         * コンストラクタ
         *
         */
        public function QuestGauge()
        {
             x = _X
             y = _Y;
            initGauge();
            addChild(_gaugeFrame);
            addChild(_gauge);
            //           scale(0.5);
        }

        private function initGauge():void
        {
            _gauge.graphics.clear();
            _gauge.graphics.lineStyle(0, 0x00FF00,0);
            _gauge.graphics.beginFill(0x000000);
            _gauge.graphics.drawRect(0,0,_W,_H);
            _gauge.transform.colorTransform = _color;

            _gaugeFrame.graphics.clear();
            _gaugeFrame.graphics.lineStyle(1, 0xDD0000,1);
            _gaugeFrame.graphics.beginFill(0x000000,0.8);
            _gaugeFrame.graphics.drawRect(0,0,_W,_H);
//            _gaugeFrame.transform.colorTransform = _color;
        }


        private function scale(num:Number):void
        {
            var sx:Number = num*_scaleX;
            _gauge.scaleX = sx>1 ? 1:sx;
        }

        public function setQuestMap(questMapDiff:int):void
        {
            log.writeLog(log.LV_FATAL, this, "setQuestMap");
            _questMapDiff = questMapDiff;

        }

        public function updateQuestClearNum(clearNum:int):void
        {
            _clearNum = clearNum;
//            log.writeLog(log.LV_FATAL, this, "+++++++++++++++++clea num update ", _clearNum, _questMapDiff);
            scale(_clearNum/_questMapDiff);

        }



    }

}
