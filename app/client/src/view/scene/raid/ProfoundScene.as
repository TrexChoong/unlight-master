package view.scene.raid
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.filters.GlowFilter;
    import flash.geom.*;
    import flash.text.TextField;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.ProfoundData;
    import model.Profound;

    import view.scene.BaseScene;
    import view.scene.raid.*;
    import view.image.raid.*;
    import view.*;
    import view.utils.*;


    /**
     * 渦情報クラス
     *
     */
    public class ProfoundScene extends BaseScene
    {
        private var _profound:Profound;
        private var _profoundImage:ProfoundImage;

        private var _clickFunc:Function;
        private var _overFunc:Function;
        private var _outFunc:Function;

        private var _time:Timer;  // 消滅監視用タイマー

        private var _labelSet:Vector.<Label> = Vector.<Label>(
            [
                new Label(),new Label(),new Label(),new Label(),new Label(),new Label(),new Label(),new Label(),new Label(),new Label(),
                ]);
        private var _labelIndexSet:Vector.<Boolean> = Vector.<Boolean>([false,false,false,false,false,false,false,false,false,false]);
        private const _LABEL_SET_IDX_START:int = 5;

        private var _dmgManager:ProfoundDamageManager = new ProfoundDamageManager();

        public function ProfoundScene(prf:Profound,isNew:Boolean,avatarId:int):void
        {
            _profound = prf;
            initImage(isNew,avatarId);

            _dmgManager.start();

            addEventListener(MouseEvent.CLICK,clickHandler);
            addEventListener(MouseEvent.MOUSE_OVER,overHandler);
            addEventListener(MouseEvent.MOUSE_OUT,outHandler);

            _time = new Timer(500);
            _time.addEventListener(TimerEvent.TIMER, updateDuration);
            _time.start();
        }

        private function initImage(isNew:Boolean,avatarId:int):void
        {
            var setImgType:int = ProfoundImage.PRF_IMG_TYPE_NORMAL;
            if (_profound.prfType == ProfoundData.PRF_TYPE_MMO_EVENT) {
                setImgType = ProfoundImage.PRF_IMG_TYPE_EVENT;
            } else if (_profound.finderAvatarId == avatarId) {
                setImgType = ProfoundImage.PRF_IMG_TYPE_NORMAL;
            } else {
                setImgType = ProfoundImage.PRF_IMG_TYPE_ANOTHER;
            }
            _profoundImage = new ProfoundImage(_profound.rarity,_profound.isNearClosed,!isNew,setImgType);
            _profoundImage.finish = _profound.isFinished;
            addChild(_profoundImage);

        }

        private function getLabelSetIndex():int
        {
            for ( var i:int = 0; i < _labelIndexSet.length; i++) {
                if (!_labelIndexSet[i]) {
                    return i;
                }
            }
            return -1;
        }
        public function addLabel(label:Label):int
        {
            var setIdx:int = getLabelSetIndex();
            if (setIdx < 0) return -1;

            addChild(label);
            _labelIndexSet[setIdx] = true;
            return setIdx;
        }
        public function removeLabel(idx:int):void
        {
            _labelIndexSet[idx] = false;
        }

        public override function final():void
        {
            _time.stop();
            _time.removeEventListener(TimerEvent.TIMER, updateDuration);

            removeEventListener(MouseEvent.CLICK,clickHandler);
            removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
            removeEventListener(MouseEvent.MOUSE_OUT,outHandler);

            RemoveChild.apply(_profoundImage);
            _clickFunc = null;
        }

        public function get profoundId():int
        {
            return _profound.id;
        }
        public function set profound(prf:Profound):void
        {
            _profound = prf;
        }
        public function get profound():Profound
        {
            return _profound;
        }
        public function get image():ProfoundImage
        {
            return _profoundImage;
        }
        public function setPosition(p:Point):void
        {
            _profoundImage.x = p.x;
            _profoundImage.y = p.y;
        }
        public function imageHide():void
        {
            _profoundImage.alpha = 0.0;
            _profoundImage.visible = false;
        }
        public function set finish(isFinished:Boolean):void
        {
            _profoundImage.finish = isFinished;
        }
        public function set clickFunc(f:Function):void
        {
            _clickFunc = f;
        }
        private function clickHandler(e:MouseEvent):void
        {
            if (_clickFunc != null) _clickFunc(e.currentTarget.profound);
        }
        public function set overFunc(f:Function):void
        {
            _overFunc = f;
        }
        private function overHandler(e:MouseEvent):void
        {
            if (_overFunc != null) _overFunc(e.currentTarget.profound,image.x,image.y);
        }
        public function set outFunc(f:Function):void
        {
            _outFunc = f;
        }
        private function outHandler(e:MouseEvent):void
        {
            if (_outFunc != null) _outFunc(e.currentTarget.profound,image.x,image.y);
        }
        private function updateDuration(e:Event):void
        {
            if (!_profoundImage.limitIconVisible) {
                if (_profound.isNearClosed) {
                    _profoundImage.limitIconVisible = true;
                }
            }
        }
        public function hitDamage(dmg:int,strData:String,state:int,stateUpdate:Boolean):void
        {
            // log.writeLog(log.LV_FATAL, this, "hitDamage",dmg);
            _dmgManager.setDamage(this,dmg,strData,state,stateUpdate);
        }
        public function set prfButtonVisible(v:Boolean):void
        {
            _profoundImage.profoundButtonVisible = v;
        }
    }
}

