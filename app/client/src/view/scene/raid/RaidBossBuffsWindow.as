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
    import model.Duel;
    import model.events.BuffEvent;

    import view.scene.BaseScene;
    import view.scene.raid.*;
    import view.image.raid.*;
    import view.*;
    import view.utils.*;


    /**
     * RaidBoss状態異常表示ウィンドウ
     *
     */
    public class RaidBossBuffsWindow extends BaseScene
    {
        private var _container:UIComponent = new UIComponent();

        private var _duel:Duel = Duel.instance;

        private var _buffsButton:RaidBossBuffsButton = new RaidBossBuffsButton();

        private var _buffWindow:RaidBossBuffsWindowBase = new RaidBossBuffsWindowBase();

        public function RaidBossBuffsWindow():void
        {
            _buffsButton.visible = false;
            _buffsButton.mouseEnabled = false;
            _buffsButton.mouseChildren = false;
            _container.addChild(_buffsButton);

            _container.addChild(_buffWindow);

            addChild(_container);
        }

        public override function init():void
        {
            _buffsButton.button.addEventListener(MouseEvent.MOUSE_OVER,buffButtonOverHandler);
            _buffsButton.button.addEventListener(MouseEvent.MOUSE_OUT,buffButtonOutHandler);

            var num:int = _duel.foeEntrant.bossBuffLists.length;
            for (var i:int = 0; i<num; i++) {
                _duel.foeEntrant.bossBuffLists[i].addEventListener(BuffEvent.BOSS_BUFF_UPDATE,updateBuffsHandler);
                _duel.foeEntrant.bossBuffLists[i].addEventListener(BuffEvent.BOSS_BUFF_DELETE,deleteBuffsHandler);
                _duel.foeEntrant.bossBuffLists[i].addEventListener(BuffEvent.BOSS_BUFF_ALL_DELETE,allDeleteBuffsHandler);
            }
        }

        public override function final():void
        {
            _buffsButton.button.removeEventListener(MouseEvent.MOUSE_OVER,buffButtonOverHandler);
            _buffsButton.button.removeEventListener(MouseEvent.MOUSE_OUT,buffButtonOutHandler);

            var num:int = _duel.foeEntrant.bossBuffLists.length;
            for (var i:int = 0; i<num; i++) {
                _duel.foeEntrant.bossBuffLists[i].removeEventListener(BuffEvent.BOSS_BUFF_UPDATE,updateBuffsHandler);
                _duel.foeEntrant.bossBuffLists[i].removeEventListener(BuffEvent.BOSS_BUFF_DELETE,deleteBuffsHandler);
                _duel.foeEntrant.bossBuffLists[i].removeEventListener(BuffEvent.BOSS_BUFF_ALL_DELETE,allDeleteBuffsHandler);
            }
        }

        private function buffButtonOverHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, this, "buffButtonOverHandler");
            _buffWindow.visible = true;
        }

        private function buffButtonOutHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, this, "buffButtonOutHandler");
            _buffWindow.visible = false;
        }

        public function updateBuffsHandler(e:BuffEvent):void
        {
            log.writeLog(log.LV_DEBUG, this, "updateBuffsHandler");
            var buffList:RaidBossBuffList = _duel.foeEntrant.currentBossBuffLists;
            var buffs:Array = buffList.getBuffList();
            if (buffs.length > 0) {
                for ( var i:int=0; i<buffs.length; i++) {
                    _buffWindow.addBuff(buffs[i].buffId,buffs[i].value,buffs[i].turn,buffs[i].limitAt);
                }
                _buffsButton.mouseEnabled = true;
                _buffsButton.mouseChildren = true;
                _buffWindow.setWindow();
            } else {
                _buffsButton.mouseEnabled = false;
                _buffsButton.mouseChildren = false;
            }
        }
        public function deleteBuffsHandler(e:BuffEvent):void
        {
            log.writeLog(log.LV_DEBUG, this, "deleteBuffsHandler");
            _buffWindow.delBuff(e.id,e.value);
            _buffWindow.setWindow();
            var buffList:RaidBossBuffList = _duel.foeEntrant.currentBossBuffLists;
            var buffs:Array = buffList.getBuffList();
            if (buffs.length <= 0) {
                _buffsButton.mouseEnabled = false;
                _buffsButton.mouseChildren = false;
            }
        }

        public function allDeleteBuffsHandler(e:BuffEvent):void
        {
            _buffWindow.allDelBuff();
            _buffsButton.mouseEnabled = false;
            _buffsButton.mouseChildren = false;
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_buffsButton, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }

        // 実画面から隠すスレッドを返す
        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_buffsButton, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_buffWindow, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new ClousureThread(panelDelete));
            return pExec;
        }

        private function panelDelete():void
        {
            _buffWindow.delAllBuff()
        }
    }
}

