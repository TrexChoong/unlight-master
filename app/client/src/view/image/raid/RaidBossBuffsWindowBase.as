package view.image.raid
{
    import flash.display.*;
    import flash.events.Event;
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
    import view.scene.BaseScene;
    import view.scene.game.BuffClip;
    import controller.*;

    /**
     * RaidBoss状態異常表示ウィンドウベース
     *
     */
    public class RaidBossBuffsWindowBase extends BaseScene
    {
        private var _container:UIComponent = new UIComponent();

        private var _window:WindowBase = new WindowBase();

        private var _panels:Array = [];

        // private static const _X:int = 450;
        // private static const _Y:int = 90;
        private static const _X:int = 550;
        private static const _Y:int = 110;

        private static const _PANEL_START_Y:int = 5;

        /**
         * コンストラクタ
         *
         */
        public function RaidBossBuffsWindowBase()
        {
            super();
            x = _X;
            y = _Y;
            addChild(_window);

            addChild(_container)
        }

        public function addBuff(id:int,val:int,turn:int,limit:Date):void
        {
            var panel:RaidBossBuffPanel = getPanel(id,val);
            if (panel) {
                panel.updateLimitAt(turn,limit);
            } else {
                panel = new RaidBossBuffPanel(id,val,turn,limit,_container);
                panel.x = _X + 5;
                panel.y = _Y;
                //panel.setYPos(_PANEL_START_Y + RaidBossBuffPanel.PANEL_H * _panels.length);
                log.writeLog(log.LV_DEBUG, this, "addBuff",_Y,RaidBossBuffPanel.PANEL_H,_panels.length,panel.y);
                _panels.push(panel);
            }
            updatePanelPostion();
        }

        public function delBuff(id:int,val:int):void
        {
            var del:RaidBossBuffPanel = null;
            var idx:int = 0;
            var tmpArray:Array;
            for (var i:int=0; i<_panels.length; i++) {
                if ( _panels[i].buffId == id && _panels[i].value == val ) {
                    tmpArray = _panels.splice(_panels.indexOf(_panels[i]),1);
                    tmpArray[0].visible = false;
                    tmpArray[0].getHideThread().start();
                    break;
                }
            }
            updatePanelPostion();
        }

        public function allDelBuff():void
        {
            var del:RaidBossBuffPanel = null;
            while (_panels.length > 0) {
                del = _panels.pop();
                del.visible = false;
                del.getHideThread().start();
            }
            updatePanelPostion();
        }

        private function updatePanelPostion():void
        {
            for (var i:int=0; i<_panels.length; i++) {
                _panels[i].setYPos(_PANEL_START_Y + RaidBossBuffPanel.PANEL_H * i);
            }
        }

        public function setWindow():void
        {
            var num:int = _panels.length;
            if (num <= 0) {num=1;}
            _window.makeWindow(num*RaidBossBuffPanel.PANEL_H);
            alpha = 0.8;
            visible = false;
        }

        private function getPanel(id:int,val:int):RaidBossBuffPanel
        {
            var ret:RaidBossBuffPanel = null;
            for (var i:int=0; i<_panels.length; i++) {
                if ( _panels[i].buffId == id && _panels[i].value == val ) {
                    ret = _panels[i];
                    break;
                }
            }
            return ret;
        }

        public function delAllBuff():void
        {
            var tmp:RaidBossBuffPanel;
            while ( _panels.length > 0 )
            {
                tmp = _panels.shift();
                tmp.visible = false;
                tmp.getHideThread().start();
            }
        }
    }

}

import flash.display.*;
import flash.events.Event;
import flash.geom.*;
import flash.utils.*;
import flash.text.*;
import mx.controls.Label;

class WindowBase extends Sprite
{
    private const _W:int = 150;

    private var _base:Shape = new Shape();

    /**
     * コンストラクタ
     *
     */
    public function WindowBase()
    {
        super();
        addChild(_base);
    }

    public function makeWindow(h:int):void
    {
        _base.graphics.clear();
        _base.graphics.lineStyle(0, 0x000000,1);
        _base.graphics.beginFill(0x000000);
        // _base.graphics.beginFill(0x708090);
        _base.graphics.drawRect(0,0,_W,h);
    }
}