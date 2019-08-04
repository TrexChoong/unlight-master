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

    import controller.RaidCtrl;

    import model.ProfoundData;
    import model.Profound;

    import view.scene.BaseScene;
    import view.scene.raid.*;
    import view.image.raid.*;
    import view.*;
    import view.utils.*;

    /**
     * 渦のダメージ演出管理
     *
     */
    public class ProfoundDamageManager extends Thread
    {
        private var _threads:Array = [];
        private var _nowObj:ProfoundDamageThread = null;
        private var _actObjs:Array = [];
        private var _checkTime:Date;

        private const _ACT_MAX:int = 10;
        private const _NEXT_RAG:int = 500;

        public function ProfoundDamageManager():void
        {
            log.writeLog(log.LV_FATAL, this, "ProfoundDamageManager");
        }

        protected override function run():void
        {
            next(waiting);
        }

        private function isStock():Boolean
        {
            return (_threads.length > 0&&_actObjs.length < _ACT_MAX);
        }
        private function isNextPush(now:Date):Boolean
        {
            return (_checkTime == null || _checkTime.getTime() < now.getTime());
        }
        private function waiting():void
        {
             if (isStock()) {
                next(threadPush);
            } else {
                next(waiting);
            }
        }

        private function threadPush():void
        {
            var now:Date = new Date();
            log.writeLog(log.LV_DEBUG, this, "threadPush",_threads.length,_checkTime,now);
            if (isStock() && isNextPush(now)) {
                var obj:ProfoundDamageThread = _threads.shift();
                obj.isStart = true;
                _actObjs.push(obj);
                _checkTime = new Date(now.getTime() + _NEXT_RAG);
                if (isStock()) {
                    next(threadPush);
                } else {
                    next(finishCheck);
                }
            } else {
                if (isStock()) {
                    next(threadPush);
                } else if (_actObjs.length > 0) {
                    next(finishCheck);
                } else {
                    next(waiting);
                }
            }
        }

        private function finishCheck():void
        {
            log.writeLog(log.LV_DEBUG, this, "finishCheck",_actObjs.length,_threads.length);
            if (_actObjs.length > 0) {
                var finObjs:Array = [];
                for (var i:int = 0; i < _actObjs.length; i++) {
                    if (_actObjs[i].isFin) {
                        var finObj:ProfoundDamageThread = _actObjs[i];
                        finObjs.push(finObj);
                    }
                }

                if (finObjs.length > 0) {
                    for (var x:int = 0; x < finObjs.length; x++) {
                        var popObjs:Array = _actObjs.splice(_actObjs.indexOf(finObjs[i]),1);
                        popObjs[0] = null;
                    }
                    if (isStock()) {
                        next(threadPush);
                    } else {
                        next(waiting);
                    }
                } else {
                    next(finishCheck);
                }
            } else {
                next(waiting);
            }
        }

        public function setDamage(ps:ProfoundScene,dmg:int,strData:String,state:int,stateUpdate:Boolean):void
        {
            log.writeLog(log.LV_FATAL, this, "setDamage",dmg);
            var thread:ProfoundDamageThread = new ProfoundDamageThread(ps,dmg,strData,state,stateUpdate);
            thread.start();
            _threads.push(thread);
        }

    }


}


import flash.display.*;
import flash.events.*;
import flash.utils.*;
import flash.filters.GlowFilter;
import flash.geom.*;
import flash.text.TextField;

import org.libspark.thread.threads.between.BeTweenAS3Thread;

import mx.core.UIComponent;
import mx.controls.*;

import org.libspark.thread.*;
import org.libspark.thread.utils.*;

import controller.RaidCtrl;
import controller.RaidChatCtrl;
import controller.RaidDataCtrl;

import model.Profound;
import model.ProfoundMessage;
import view.*;
import view.scene.raid.*;

class ProfoundDamageThread extends Thread
{
    private const _STR_DATA_MSG_TYPE_IDX:int = 1; // StringデータのMsgTypeが保管されているIndex

    private const _VIB_ST_MOVE:int   = 0;
    private const _VIB_ST_RESET:int  = 1;
    private const _VIB_ST_WAIT:int   = 2;
    private const _VIB_ST_FINISH:int = 3;

    private const _COUNT_MAX:int = 15;

    private var _prfScene:ProfoundScene;

    private var _defPos:Point = new Point(0,0);
    private var _state:int = _VIB_ST_MOVE;
    private var _count:int = 0;
    private var _isStart:Boolean = false;
    private var _isFin:Boolean = false;

    private var _damage:int = 0;
    private var _dmgLabel:Label = new Label();
    private var _labelIndex:int = -1;
    private var _strData:String = "";
    private var _msgType:int = ProfoundMessage.PRF_MSGDLG_DAMAGE;
    private var _prfState:int = Profound.PRF_ST_UNKNOWN;
    private var _prfStateUpdate:Boolean = false;
    private var _labelThread:SerialExecutor = new SerialExecutor();

    public function ProfoundDamageThread(ps:ProfoundScene,dmg:int,strData:String,state:int,stateUpdate:Boolean):void
    {
        _prfScene = ps;
        _defPos.x = ps.image.x;
        _defPos.y = ps.image.y;
        _damage = dmg;
        _strData = strData;
        _msgType = parseInt(strData.split(":")[_STR_DATA_MSG_TYPE_IDX]);
        _prfState = state;
        _prfStateUpdate = stateUpdate;
        setLabelThread();
    }

    protected override function run():void
    {
        next(waiting);
    }

    private function waiting():void
    {
        if (_isStart) {
            if (_prfStateUpdate) {
                RaidDataCtrl.instance.updateBossState(_prfScene.profoundId,_prfState);
            }
            _labelThread.start();
            RaidCtrl.instance.setPrfMessageStrData(_strData);
            if (_msgType == ProfoundMessage.PRF_MSGDLG_DAMAGE) {
                RaidDataCtrl.instance.setUpdateBossViewHP(_prfScene.profoundId,_prfScene.profound.viewDamage+_damage);
                next(vibration);
            }else{
                RaidDataCtrl.instance.setUpdateBossViewHP(_prfScene.profoundId,_prfScene.profound.viewDamage-_damage);
                next(moveWait);
            }
        } else {
            next(waiting);
        }
    }

    private function vibration():void
    {
        switch (_state)
        {
        case _VIB_ST_MOVE:
            _prfScene.setPosition(movePos);
            _state = _VIB_ST_RESET;
            break;
        case _VIB_ST_RESET:
            _prfScene.setPosition(_defPos);
            _state = _VIB_ST_MOVE;
            break;
        case _VIB_ST_FINISH:
        default:
        }

        _count++;
        // 振動終了処理
        if (_count >= _COUNT_MAX) {
            _prfScene.setPosition(_defPos);
            _state = _VIB_ST_FINISH;
            next(moveWait);
        } else {
            next(vibration);
        }
    }
    private function moveWait():void
    {
        if (_labelThread.state == ThreadState.TERMINATED) {
            next(close);
        } else {
            next(moveWait);
        }
    }

    private function close():void
    {
        _isFin = true;
    }

    private function get movePos():Point
    {
        var minus:Number;
        var roll:Number = Math.floor( Math.random()*3)+1;
        minus = Math.floor( Math.random()*2)+1;
        // minusが1ならマイナス値
        if (minus == 1) roll = 0-roll;
        var pitch:Number = Math.floor( Math.random()*3)+1;
        minus = Math.floor( Math.random()*2)+1;
        // minusが2ならマイナス値
        if (minus == 2) pitch = 0-pitch;
        return new Point(_defPos.x+roll,_defPos.y+pitch);
    }
    private function setLabelThread():void
    {
        var pExec:ParallelExecutor = new ParallelExecutor();
        _labelThread.addThread(new ClousureThread(labelInit));
        pExec.addThread(new BeTweenAS3Thread(_dmgLabel, {y:_prfScene.image.y-15}, null, 0.7, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
        _labelThread.addThread(pExec);
        _labelThread.addThread(new ClousureThread(labelFin));
    }
    private function labelInit():void
    {
        var roll:Number = Math.floor( Math.random()*10)+1;
        _dmgLabel.x = 100;
        _dmgLabel.y = 100;
        _dmgLabel.width = 20;
        _dmgLabel.height = 30;
        _dmgLabel.styleName = "MyRankLabel";
        _dmgLabel.setStyle("textAlign", "left");
        _dmgLabel.setStyle("fontSize", "14");
        _dmgLabel.text = "";
        _dmgLabel.filters = [new GlowFilter(0xFFFFFF, 1, 1.5, 1.5, 16, 1),];
        _dmgLabel.x = _prfScene.image.x - roll;
        _dmgLabel.y = _prfScene.image.y - 5;
        _dmgLabel.text = _damage.toString();
        _dmgLabel.alpha = 1.0;
        _dmgLabel.visible = true;
        _dmgLabel.mouseEnabled = false;
        _dmgLabel.mouseChildren = false;
        _labelIndex = _prfScene.addLabel(_dmgLabel);
    }
    private function labelFin():void
    {
        _dmgLabel.visible = false;
        _prfScene.removeLabel(_labelIndex);
    }

    public function set isStart(f:Boolean):void
    {
        _isStart = f;
    }
    public function get isFin():Boolean
    {
        return _isFin;
    }
    public function get prfScene():ProfoundScene
    {
        return _prfScene;
    }

}

