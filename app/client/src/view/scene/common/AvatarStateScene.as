package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.Avatar;

    import view.utils.*;
    import view.image.common.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;

    /**
     * AvatarStateのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class AvatarStateScene extends BaseScene
    {
        // イメージ
        private var _expImage      :AvatarStateImage = new AvatarStateImage(AvatarStateImage.EXP_POW);
        private var _gemImage      :AvatarStateImage = new AvatarStateImage(AvatarStateImage.GEM_POW);
        private var _apImage       :AvatarStateImage = new AvatarStateImage(AvatarStateImage.AP_RECOV);
        private var _qincImage     :AvatarStateImage = new AvatarStateImage(AvatarStateImage.INC_QUEST);
        private var _qshortenImage :AvatarStateImage = new AvatarStateImage(AvatarStateImage.SHORTEN_QUEST);;
        private var _stateSet:Array= [_expImage, _gemImage, _apImage, _qincImage, _qshortenImage];
        private var _visibleSet:Array= [];
        private var _unvisibleSet:Array= [];
        public const X:int = 25;
        public const Y:int = -5;
        public const H:int = 32;
        private var _recoveryInterval:int;             // 回復間隔
        private var _questMax:int = 0;
        private var _expPow:int = 100;                    // EXP倍率
        private var _gemsPow:int = 100;                    // GEM倍リス
        private var _questFindPow:int = 100;                    // クエスト時間短縮率
        private var _nextTweenStack:Array = []; /* of ITween */ 
        private var _currentTween:ITween; /* of ITween */ 


        /**
         * コンストラクタ
         *
         */
        public function AvatarStateScene()
        {

        }

        // 初期化
        public override function init():void
        {
            log.writeLog(log.LV_FATAL, this, "init state");
            for(var i:int = 0; i < _stateSet.length; i++){
                _stateSet[i].x = AvatarStateImage.X;
                _stateSet[i].y = AvatarStateImage.Y+AvatarStateImage.H*i;
                addChild(_stateSet[i]);
            }
        }


        // 後処理
        public override function final():void
        {
            for(var i:int = 0; i < _stateSet.length; i++){
                RemoveChild.apply(_stateSet[i]);
            }
        }


        public  function setState(expPow:int, gemPow:int, apRecov:int, qNum:int, qPow:int):void
        {
            log.writeLog(log.LV_FATAL, this, "setSTATE!!!!", expPow, gemPow, apRecov, qNum, qPow);
            _visibleSet = [];
            _unvisibleSet = [];
            // 出すべきもの、僧でないものを調べる
            if (expPow > 100)
            {
                _visibleSet.push(_stateSet[AvatarStateImage.EXP_POW]);
                _stateSet[AvatarStateImage.EXP_POW].setPow(expPow - 100);
            }
            else
            {
                _unvisibleSet.push(_stateSet[AvatarStateImage.EXP_POW]);

            }
            if (gemPow > 100)
            {
                _visibleSet.push(_stateSet[AvatarStateImage.GEM_POW]);
                _stateSet[AvatarStateImage.GEM_POW].setPow(gemPow - 100);
            }
            else
            {
                _unvisibleSet.push(_stateSet[AvatarStateImage.GEM_POW]);
            }

            if (apRecov < Const.AVATAR_RECOVERY_SEC)
            {
                _visibleSet.push(_stateSet[AvatarStateImage.AP_RECOV]);
                _stateSet[AvatarStateImage.AP_RECOV].setPow( (Const.AVATAR_RECOVERY_SEC - apRecov)/60);
            }
            else
            {
                _unvisibleSet.push(_stateSet[AvatarStateImage.AP_RECOV]);
            }

            if (qNum > Const.QUEST_MAX)
            {
                _visibleSet.push(_stateSet[AvatarStateImage.INC_QUEST]);
                _stateSet[AvatarStateImage.INC_QUEST].setPow(qNum - Const.QUEST_MAX);
            }
            else
            {
                _unvisibleSet.push(_stateSet[AvatarStateImage.INC_QUEST]);
            }

            if (qPow < 100)
            {
                _visibleSet.push(_stateSet[AvatarStateImage.SHORTEN_QUEST]);
                _stateSet[AvatarStateImage.SHORTEN_QUEST].setPow(100-qPow);
            }
            else
            {
                _unvisibleSet.push(_stateSet[AvatarStateImage.SHORTEN_QUEST])
            }
            if (_currentTween == null)
            {
                _currentTween = updateTween();
                _currentTween.play();
            }else{
                _nextTweenStack.push(
                    updateTween()
                        );
            }

        }

        private function updateTween():ITween
        {
            return BetweenAS3.serial(
                    vanishTween(),
                    showTween(),
                    alignTween(),
                    BetweenAS3.func(nextTween)
                    );
        }

        private function nextTween():void
        {
            if (_nextTweenStack.length >0)
            {
                _nextTweenStack.shift().play();
            }else{
                _currentTween = null;
            }

        }

        // 整列WEEN
        private function alignTween():ITween
        {
            var tweens:Array = []; /* of ITween */ 
            _visibleSet.forEach(function(item:AvatarStateImage, index:int, array:Array):void{ 
                   log.writeLog(log.LV_FATAL, this, "align tween ", item.type);
                    tweens.push (item.alignTween(index));
                }
                );
                return BetweenAS3.parallelTweens(tweens);

        }

        // 出すTWEEN
        private function showTween():ITween
        {
            var tweens:Array = []; /* of ITween */ 

            for(var i:int = 0; i < _visibleSet.length; i++){
                log.writeLog(log.LV_FATAL, this, "show tween ", _visibleSet[i].type);
                    tweens.push(_visibleSet[i].showTween(this));
            }
                return BetweenAS3.parallelTweens(tweens);
        }

        // 消えるTween
        private function vanishTween():ITween
        {
            var tweens:Array = []; /* of ITween */ 
            _unvisibleSet.forEach(function(item:AvatarStateImage, index:int, array:Array):void{
                    log.writeLog(log.LV_FATAL, this, "vasnish tween ", item.type);
                    tweens.push (item.vanishTween());
                }
                );
            return BetweenAS3.parallelTweens(tweens);
        }


    }

}
