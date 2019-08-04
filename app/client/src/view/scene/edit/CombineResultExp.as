package view.scene.edit
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Text;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.ClousureThread;
    import view.SleepThread;
    import view.scene.BaseScene;
    import view.image.requirements.CombineResultImage;
    import view.image.requirements.CombineResultMarkImage;
    import view.image.requirements.ExpGauge;
    import view.image.requirements.CombineLevelUpImage;
    import view.utils.RemoveChild;

    /**
     * 合成結果経験値表示クラス
     *
     */
    public class CombineResultExp extends BaseScene
    {
        private const _REDUCTION_FRM_CNT:int = 50; // 減少時の合計フレーム
        //private const _REDUCTION_FRM_CNT:int = 1000; // 減少時の合計フレーム

        CONFIG::LOCALE_JP
        private const _TRANS_EXP_BASE:String = "残り:";
        CONFIG::LOCALE_EN
        private const _TRANS_EXP_BASE:String = "Remainder :";
        CONFIG::LOCALE_TCN
        private const _TRANS_EXP_BASE:String = "剩餘:";
        CONFIG::LOCALE_SCN
        private const _TRANS_EXP_BASE:String = "剩余:";
        CONFIG::LOCALE_FR
        private const _TRANS_EXP_BASE:String = "Restant :";
        CONFIG::LOCALE_KR
        private const _TRANS_EXP_BASE:String = "残り:";
        CONFIG::LOCALE_ID
        private const _TRANS_EXP_BASE:String = "残り:";
        CONFIG::LOCALE_TH
        private const _TRANS_EXP_BASE:String = "残り:";

        private var _combine:Combine = Combine.instance;

        private var _container:UIComponent = new UIComponent();

        private var _discThread:SerialExecutor;
        private var _discThreads:Array;

        private var _newWc:WeaponCard;

        private var _prevExp:Number      = 0.0;
        private var _nowExp:Number       = 0.0;
        private var _nextExp:Number      = 0.0;
        private var _lastExp:Number      = 0.0;
        private var _remainExp:Number    = 0.0;
        private var _prevRemainExp:Number = 0.0;
        private var _startRemainExp:Number = 0.0;
        private var _prevLv:int          = 0;
        private var _nowLv:int           = 0;
        private var _lastLv:int          = 0;
        private var _upLv:int            = 0;
        private var _reductionPrm:Number = 0.0;

        private var _moveStart:Boolean = false;

        // レベル＆EXP
        private var _levelBase:Label = new Label();
        private var _level:Label = new Label();
        private var _levelDiff:Label = new Label();
        private var _levelMark:CombineResultMarkImage = new CombineResultMarkImage();
        private var _expBase:Label = new Label();
        private var _exp:Label = new Label();
        private var _expDiff:Label = new Label();
        private var _expMark:CombineResultMarkImage = new CombineResultMarkImage();
        private var _expGauge:ExpGauge = new ExpGauge();
        private var _lvUpImage:CombineLevelUpImage = new CombineLevelUpImage();

        private const _PARAM_Y:int        = 150;
        private const _PARAM_W:int        = 100;
        private const _PARAM_H:int        = 60;
        private const _PARAM_SIZE:int     = 24;
        private const _PARAM_INTERVAL:int = 25;

        private const _EXP_BASE_X:int = 325;
        private const _EXP_BASE_Y:int = 100;
        private const _LV_X:int = 60;
        private const _EXP_X:int = 435;
        private const _LV_DIFF_X:int = _LV_X+100;
        private const _EXP_DIFF_X:int = 355;
        private const _LV_Y:int = 100;
        private const _EXP_Y:int = 95;
        private const _LVEXP_W:int = 350;
        private const _LV_SIZE:int = 32;
        private const _EXP_SIZE:int = 20;
        private const _EXP_BASE_SIZE:int = 10;

        // クリック範囲
        private const _CLICK_X:int = 0;
        private const _CLICK_Y:int = 30;
        private const _CLICK_W:int = 570;
        private const _CLICK_H:int = 630;
        private var _panel:Shape = new Shape();
        private var _color:ColorTransform = new ColorTransform(1,1,1,1,0,255,0,0);

        private const _EXP_GAUGE_X:int = 285;
        private const _EXP_GAUGE_Y:int = 121;

        private const _LV_IMG_X:int = -100;
        private const _LV_IMG_Y:int = 0;

        // ExpSpeed
        private const _EXP_SPEED_LOW:int = 1.0;
        private const _EXP_SPEED_LOW_PRM:int = 50;
        private const _EXP_SPEED_MID:int = 2.0;
        private const _EXP_SPEED_MID_PRM:int = 100;
        private const _EXP_SPEED_HIGH:int = 3.0;
        private const _EXP_SPEED_HIGH_PRM:int = 200;

        // レベル上限の場合のExp表示
        private const _EXP_HIDE_STR:String = "------";

        /**
         * コンストラクタ
         *
         */
        public function CombineResultExp()
        {
            super();
        }

        public override function init():void
        {
            _moveStart = false;
            allLabelInit();
            initGauge();
            _lvUpImage.x = _LV_IMG_X;
            _lvUpImage.y = _LV_IMG_Y;
            _container.addChild(_lvUpImage);
            initPanel();
            addChild(_container);
        }

        public override function final():void
        {
            RemoveChild.all(_container);
            RemoveChild.apply(_container);
        }

        private function allLabelInit():void
        {
            labelInit(_level,_LV_X,_LV_Y,_PARAM_W,_PARAM_H,"left",_LV_SIZE,"ResultLabel");
            labelInit(_exp,_EXP_X,_EXP_Y,_PARAM_W,_PARAM_H,"right",_EXP_SIZE,"ResultLabel");
            labelInit(_expDiff,_EXP_DIFF_X,_EXP_Y,_PARAM_W,_PARAM_H,"left",_EXP_SIZE,"ResultLabel");
            labelInit(_expBase,_EXP_BASE_X,_EXP_BASE_Y,_PARAM_W,_PARAM_H,"left",_EXP_BASE_SIZE,"ResultNameLabel",null,"#FFFFFF");
        }

        private function labelInit(l:Label,x:int,y:int,w:int,h:int,align:String,size:int,style:String,filters:Array=null,color:String=""):void
        {
            l.x = x;
            l.y = y;
            l.width = w;
            l.height = h;
            if (style != "") {
                l.styleName = style;
            }
            if (filters) {
                l.filters = filters;
            }
            l.setStyle("textAlign",align);
            l.setStyle("fontSize",size);
            if (color != "") {
                l.setStyle("color",color);
            }
            l.mouseEnabled = false;
            l.mouseChildren = false;
            _container.addChild(l);
        }
        private function textInit(t:Text,x:int,y:int,w:int,h:int,align:String,size:int,style:String,filters:Array=null):void
        {
            t.x = x;
            t.y = y;
            t.width = w;
            t.height = h;
            if (style != "") {
                t.styleName = style;
            }
            if (filters) {
                t.filters = filters;
            }
            t.setStyle("textAlign",align);
            t.setStyle("fontSize",size);
            t.mouseEnabled = false;
            t.mouseChildren = false;
            _container.addChild(t);
        }
        private function markInit(mark:CombineResultMarkImage,x:int,y:int):void
        {
            mark.x = x;
            mark.y = y;
            mark.visible = false;
            mark.mouseEnabled = false;
            mark.mouseChildren = false;
            _container.addChild(mark);
        }
        private function initPanel():void
        {
            _panel.graphics.clear();
            _panel.graphics.lineStyle(0, 0x000000,0);
            _panel.graphics.beginFill(0x000000);
            _panel.graphics.drawRect(_CLICK_X,_CLICK_Y,_CLICK_W,_CLICK_H);
            _panel.transform.colorTransform = _color;
            _panel.alpha = 0.0;
            _container.addChild(_panel);
        }
        private function initGauge():void
        {
            _expGauge.x = _EXP_GAUGE_X;
            _expGauge.y = _EXP_GAUGE_Y;
            _expGauge.setGauge(0);
            _container.addChild(_expGauge);
        }

        // 表示設定
        public function setLabel():void
        {
            _newWc = WeaponCard(WeaponCardInventory.getInventory(Combine.instance.resultCardInvId).card);

            _prevExp = Number(_combine.prevExp);
            _nowExp = Number(_combine.prevExp);
            _lastExp = Number(_newWc.exp);
            _remainExp = _lastExp - _prevExp;
            _prevRemainExp = _lastExp - _prevExp;
            _startRemainExp = _lastExp - _prevExp;
            _nextExp = getNextLvExp(_nowExp);
            _reductionPrm = Math.floor(_remainExp/_REDUCTION_FRM_CNT);
            if (_reductionPrm <= 0) {
                _reductionPrm = 1;
            }
//                _reductionPrm = 1;
            _prevLv = _combine.prevLevel;
            _nowLv = _combine.prevLevel;
            _lastLv = _newWc.level;
            _upLv = 0;
            setGauge();

            log.writeLog(log.LV_DEBUG, this, "setLabel", "prevExp",_prevExp,"nowExp",_nowExp,"lastExp",_lastExp,"remainExp",_remainExp);

            _levelBase.text = "Lv.         (             )";
            _level.text = _nowLv.toString();
            _levelDiff.text = _upLv.toString();
            markCheck(_levelMark,_prevLv,_nowLv);
            _expBase.text = _TRANS_EXP_BASE;
            _exp.text = _remainExp.toString();
            _expDiff.text = getNextExpStr();
            markCheck(_expMark,_combine.prevExp,_newWc.exp);

            _lvUpImage.resetAnime();
        }
        private function getNextExpStr():String
        {
            if (_newWc.level >= Const.SC_LEVEL_MAX) {
                return _EXP_HIDE_STR;
            }
            return Math.ceil(_nextExp).toString();
        }
        private function markCheck(mark:CombineResultMarkImage,prevParam:int,newParam:int,isPassive:Boolean=false):void
        {
            var diff:int = newParam - prevParam;
            mark.visible = true;
            if (isPassive) {
                if (diff > 0) {
                    mark.type = CombineResultMarkImage.MARK_TYPE_PLUS;
                } else {
                    mark.visible = false;
                }
            } else {
                if (diff > 0) {
                    mark.type = CombineResultMarkImage.MARK_TYPE_UP;
                } else if (diff < 0) {
                    mark.type = CombineResultMarkImage.MARK_TYPE_DOWN;
                } else {
                    mark.visible = false;
                }
            }
        }

        public function getNextLvExp(exp:Number):Number
        {
            var nextExp:Number = 0;
            var expTable:Array = Const.SC_LEVEL_EXP_TABLE;
            var expTableLen:int = expTable.length;
            for (var i:int = 0; i < expTableLen; i++) {
                if (exp < expTable[i]) {
                    nextExp = expTable[i] - exp;
                    break;
                }
            }
            return nextExp;
        }
        public function getNowPercent():Number
        {
            var prevLvUpExp:Number = 0.0;
            var nextLvUpExp:Number = 0.0;
            var expTable:Array = Const.SC_LEVEL_EXP_TABLE;
            var expTableLen:int = expTable.length;
            for (var i:int = 1; i < expTableLen; i++) {
                if (_nowExp < expTable[i]) {
                    prevLvUpExp = Number(expTable[i-1]);
                    nextLvUpExp = Number(expTable[i]);
                    break;
                }
            }
            var nowParam:Number = _nowExp - prevLvUpExp;
            var totalParam:Number = nextLvUpExp - prevLvUpExp;
            log.writeLog(log.LV_FATAL, this, "getNowPercent","_nowExp",_nowExp,"prevLvUpExp",prevLvUpExp,"nextLvUpExp",nextLvUpExp,"nowParam",nowParam,"totalParam",totalParam,"percent",(Number(nowParam)/Number(totalParam) * 100));
            return (nowParam/totalParam * 100);
        }
        private function setGauge():void
        {
            var setPercent:Number = 0.0;
            if (_newWc.level >= Const.SC_LEVEL_MAX) {
                setPercent = 100.0;
            } else {
                setPercent = getNowPercent();
            }
            _expGauge.setGauge(setPercent);
        }

        public function expUpdate():Boolean
        {
            if (_remainExp > 0) {
                _nowExp += _prevRemainExp - _remainExp;
                _nextExp -= _prevRemainExp - _remainExp;
                _prevRemainExp = _remainExp;
            }

            // レベルアップ
            if (_nextExp < 0 && _remainExp > 0) {
                _nextExp = getNextLvExp(_nowExp);
                _nowLv += 1;
                _upLv += 1;
                _lvUpImage.onAnime();
            }

            if (_remainExp <= 0) {
                _remainExp = 0;
                _nowExp = _lastExp;
                _nextExp = getNextLvExp(_nowExp);
                _nowLv = _lastLv;
                _upLv = _lastLv - _prevLv;
            }

            log.writeLog(log.LV_DEBUG, this, "expUpdate","_remainExp",_remainExp,"_nowExp",_nowExp,"_nextExp",_nextExp);

            _exp.text = Math.ceil(_remainExp).toString();
            _expDiff.text = getNextExpStr();
            _level.text = _nowLv.toString();
            _levelDiff.text = _upLv.toString();
            markCheck(_levelMark,_prevLv,_nowLv);
            setGauge();

            return (_remainExp <= 0);
        }

        public function eventSetting(isSet:Boolean):void
        {
            log.writeLog(log.LV_DEBUG, this, "eventSetting",isSet);
            if (isSet) {
                _container.mouseEnabled = true;
                _container.mouseChildren = true;
                _panel.visible = true;
                _container.addEventListener(MouseEvent.CLICK,clickHandler);
            } else {
                _container.mouseEnabled = false;
                _container.mouseChildren = false;
                _panel.visible = false;
                _container.removeEventListener(MouseEvent.CLICK,clickHandler);
            }
        }

        private function get expSpeed():Number
        {
            if (_remainExp >= _EXP_SPEED_HIGH_PRM) {
                return _EXP_SPEED_HIGH;
            } else if (_remainExp >= _EXP_SPEED_MID_PRM) {
                return _EXP_SPEED_MID;
            } else {
                return _EXP_SPEED_LOW;
            }
        }

        public function getMoveThread():Thread
        {
            log.writeLog(log.LV_DEBUG, this, "getMoveThread","_remainExp",_remainExp);
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new ClousureThread(eventSetting,[true]));
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new CombineResultExpMoveThread(this));
            _discThread = new SerialExecutor();
            _discThread.addThread(new BeTweenAS3Thread(this,{remainExp:0},null,expSpeed,BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(_discThread);
            sExec.addThread(pExec);

            return sExec;
        }

        private function clickHandler(event:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, this, "clickHandler");
            if (_discThread != null && _discThread.state != ThreadState.TERMINATED)
            {
                _discThread.interrupt();
            }
            _remainExp = 0;
            _nowExp = _lastExp;
            _nextExp = getNextLvExp(_nowExp);
            _nowLv = _lastLv;
            _upLv = _lastLv - _prevLv;
            if (_upLv > 0) {
                _lvUpImage.onAnime();
            }
        }

        public function get remainExp():Number
        {
            return _remainExp;
        }
        public function set remainExp(v:Number):void
        {
            _remainExp = v;
        }

        public function hideLvUpImage():void
        {
            _lvUpImage.resetAnime();
        }
    }
}

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import org.libspark.thread.utils.*;
import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.BaseScene;
import view.scene.edit.CombineResultExp;

class CombineResultExpMoveThread extends Thread
{
    private const _REDUCTION_FRM:int = 2; // 減少スピード

    private var _expScene:CombineResultExp;
    private var _count:int = 0;

    public function CombineResultExpMoveThread(expScene:CombineResultExp)
    {
        _expScene = expScene;
    }

    override protected function run():void
    {
        _count = 0;
        next(reduction);
    }

    private function reduction():void
    {
        var isNext:Boolean = false;
        if (_count == 0 || _count % _REDUCTION_FRM == 0) {
            isNext = _expScene.expUpdate();
        }
        if (isNext) {
            next(finish);
        } else {
            next(reduction);
            _count++;
        }
    }

    private function finish():void
    {
        _expScene.eventSetting(false);
    }
}

