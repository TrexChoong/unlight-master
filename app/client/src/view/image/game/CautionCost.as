package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.ClousureThread;
    import view.image.BaseImage;
    import controller.*;

    /**
     * 結果表示枠クラス
     *
     */
    public class CautionCost extends BaseImage
    {
        // result表示元SWF
        [Embed(source="../../../../data/image/edit/caution_cost.swf")]
        private var _Source:Class;

        // インスタンス定数
        private static const INS_NAME:Array = ["a","b"];
        private var _cautions:Array = [];
        // インスタンス定数
        private var _lv_a:int = 0;
        private var _lv_b:int = 0;
        private var _frameNums:Array = [];

        /**
         * コンストラクタ
         *
         */
        public function CautionCost(lv_a:int, lv_b:int)
        {
            _lv_a = lv_a;
            _lv_b = lv_b;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            waitComplete(initCautionComplete);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // MC 初期化
        public function initCautionComplete():void
        {
            lvToFrameNums();
            for (var i:int=0; i < _frameNums.length; i++)
            {
                _cautions.push(MovieClip(_root.getChildByName(INS_NAME[i])));
                _cautions[i].x *= 2;
                _cautions[i].y *= 2;
                _cautions[i].scaleX = 2;
                _cautions[i].scaleY = 2.4;
            }

            setFrame();
        }

        // set
        public function setCaution(lv_a:int, lv_b:int):void
        {
            _lv_a = lv_a;
            _lv_b = lv_b;
            lvToFrameNums();
            setFrame();
        }

        private function lvToFrameNums():void
        {
            var lvs:Array = [_lv_a, _lv_b];
            if (!_lv_a && _lv_b)
            {
                _frameNums = [_lv_b, 0];
            }
            else
            {
                _frameNums = lvs;
            }
        }

        private function setFrame():void
        {
            for (var i:int=0; i < _frameNums.length; i++)
            {
                if (_cautions.length > 0)
                {
                    if (_frameNums[i])
                    {
                        _cautions[i].gotoAndStop(_frameNums[i]);
                        _cautions[i].visible = true;
                    }
                    else
                    {
                        _cautions[i].visible = false;
                    }
                }
            }
        }
    }
}
