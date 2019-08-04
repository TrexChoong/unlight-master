package view.image.raid
{

    import flash.display.*;
    import flash.filters.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.text.*;
    import mx.controls.Label;

    import mx.core.UIComponent;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import view.scene.*;
    import view.utils.*;
    import view.scene.game.BuffClip;
    import controller.*;

    /**
     * RaidBoss状態異常表示パネル
     *
     */
    public class RaidBossBuffPanel extends BaseScene
    {
        CONFIG::LOCALE_JP
        private const _TRANS_MSG:String = "今ターンで消滅";
        CONFIG::LOCALE_EN
        private const _TRANS_MSG:String = "Annihilate on this turn";
        CONFIG::LOCALE_TCN
        private const _TRANS_MSG:String = "在這回合消滅";
        CONFIG::LOCALE_SCN
        private const _TRANS_MSG:String = "在本回合失效";
        CONFIG::LOCALE_KR
        private const _TRANS_MSG:String = "";
        CONFIG::LOCALE_FR
        private const _TRANS_MSG:String = "Disparition du Vortex durant ce Tour.";
        CONFIG::LOCALE_ID
        private const _TRANS_MSG:String = "";
        CONFIG::LOCALE_TH
        private const _TRANS_MSG:String = "ออกจากเทิร์นนี้"; //

        public static const PANEL_H:int = 30;

        private var _container:UIComponent = new UIComponent();

        private var _buffId:int   = 0;
        private var _value:int    = 0;
        private var _turn:int     = 0;
        private var _limitAt:Date = null;
        private var _startAt:Date = null;

        private var _buffClip:BuffClip;
        private var _limitLabel:Label = new Label();
        private var _timeGauge:TimeGauge;

        private const _LABEL_W:int = 160;
        private const _LABEL_H:int = 20;

        private const _LABEL_X:int = 10;
        private const _CLIP_X:int  = 15;
        private const _GAUGE_X:int = 50;
        private const _LABEL_Y_DIFF:int = 3;
        private const _GAUGE_Y_DIFF:int = 15;

        private var _time:Timer;

        /**
         * コンストラクタ
         *
         */
        public function RaidBossBuffPanel(buffId:int,value:int,turn:int,limitAt:Date,container:UIComponent)
        {
            super();

            _buffId = buffId;
            if (_buffId > 20) _buffId = 20;
            _value = value;
            _turn = turn;
            _limitAt = limitAt;
            _startAt = new Date(_limitAt.getTime() - _turn*60*1000);
            log.writeLog(log.LV_DEBUG, this, "const"," start",_startAt," limit",_limitAt);

            _limitLabel.x      = _LABEL_X;
            _limitLabel.width  = _LABEL_W;
            _limitLabel.height = _LABEL_H;
            _limitLabel.setStyle("textAlign", "center");
            _limitLabel.setStyle("color", "0x000000");
            _limitLabel.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _limitLabel.text = "";
            _container.addChild(_limitLabel);

            _buffClip = new BuffClip(buffId,value,1,false);
            _buffClip.x = _CLIP_X;
            _buffClip.getShowThread(_container).start();

            _timeGauge = new TimeGauge(limitTime,_limitAt.getTime() - _startAt.getTime());
            _timeGauge.x = _GAUGE_X;
            _container.addChild(_timeGauge);

            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER, updateDuration);
            _time.start();

            container.addChild(_container);

            timeUpdate();
        }

        public override function final():void
        {
            RemoveChild.apply(_container);

            _buffClip.getHideThread().start();

            _time.stop();
            _time.removeEventListener(TimerEvent.TIMER, updateDuration);
        }

        public function get no():int
        {
            return _buffClip.no;
        }
        public function get buffId():int
        {
            return _buffId;
        }
        public function get value():int
        {
            return _value;
        }
        public function get turn():int
        {
            return _turn;
        }
        public function get limitTime():Number
        {
            var ret:Number =0;

            if (_limitAt != null)
            {
                var now:Date = new Date();
                ret = _limitAt.getTime()-now.getTime();
            }
            if (ret<0)
            {
                return 0;
            }else{
                return ret;
            }
        }

        private function updateDuration(e:Event):void
        {
            timeUpdate();
        }
        private function timeUpdate():void
        {
            var limit:Number = limitTime;
            if (limit > 0) {
                _limitLabel.text = TimeFormat.toString(limit);
            } else {
                _limitLabel.text = _TRANS_MSG;
            }
            _timeGauge.update(limitTime);
        }

        public function setYPos(y:int):void
        {
            _buffClip.y = y;
            _limitLabel.y = y - _LABEL_Y_DIFF;
            _timeGauge.y = y + _GAUGE_Y_DIFF;
        }

        public function updateLimitAt(turn:int,limitAt:Date):void
        {
            _turn = turn;
            _limitAt = limitAt;
            if (_limitAt) {
                _startAt = new Date(_limitAt.getTime() - _turn*60*1000);
                _timeGauge.reset(limitTime,_limitAt.getTime() - _startAt.getTime());
            } else {
                _timeGauge.clear();
            }
            timeUpdate();
        }
    }

}

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.utils.*;

import org.libspark.betweenas3.BetweenAS3;
import org.libspark.betweenas3.tweens.ITween;
import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.scene.BaseScene;

class TimeGauge extends BaseScene
{
    private static const _W:int = 100;
    private static const _H:int = 3;

    private var _back:GaugeBack;
    private var _front:GaugeFront;

    public function TimeGauge(now:int,max:int)
    {
        _back = new GaugeBack(_W,_H);
        addChild(_back);

        _front = new GaugeFront(_W,_H,now,max);
        addChild(_front);
    }

    public function update(now:int):void
    {
        _front.updateGauge(now);
    }

    public function reset(now:int,max:int):void
    {
        _front.resetGauge(now,max)
    }

    public function clear():void
    {
        _front.resetGauge(0,1)
    }
}

class GaugeFront extends Sprite
{
    private var _gauge:Shape = new Shape();
    private var _color:ColorTransform = new ColorTransform(1,1,1,1,0,255,0);

    private var _scaleX:Number = 1;

    private var _nowTime:int = 0;
    private var _maxTime:int = 0;

    public function GaugeFront(w:int,h:int,now:int,max:int)
    {
        super();

        _nowTime = now;
        _maxTime = max;

        initGauge(w,h);
        addChild(_gauge);

        scaleX = 1*_scaleX*(_nowTime/_maxTime);
    }

    private function initGauge(w:int,h:int):void
    {
        _gauge.graphics.clear();
        _gauge.graphics.lineStyle(0, 0x000000,0);
        _gauge.graphics.beginFill(0x000000);
        _gauge.graphics.drawRect(0,0,w,h);
        _gauge.transform.colorTransform = _color;
    }

    private function scale(num:Number):void
    {
        scaleX = num * _scaleX;
    }
    public function updateGauge(now:int):void
    {
        _nowTime = now;
        var num:Number;
        if (_nowTime > 0) {
            num = (_nowTime/_maxTime);
        } else {
            num = 0;
        }
        new BeTweenAS3Thread(this,
                             {scaleX:1*_scaleX*num},
                             null,
                             0.1,
                             BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true).start();
    }

    public function resetGauge(now:int,max:int):void
    {
        _nowTime = now;
        _maxTime = max;
        scaleX = 1*_scaleX*(_nowTime/_maxTime);
    }
}

class GaugeBack extends Sprite
{
    private var _base:Shape = new Shape();

    public function GaugeBack(w:int,h:int)
    {
        super();

        initBase(w,h);
        addChild(_base);
    }

    private function initBase(w:int,h:int):void
    {
        _base.graphics.clear();
        _base.graphics.lineStyle(1, 0x000000);
        _base.graphics.beginFill(0x000000);
        _base.graphics.drawRect(0,0,w,h);
    }
}