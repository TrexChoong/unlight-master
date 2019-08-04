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
    import model.events.BuffEvent;

    import view.scene.BaseScene;
    import view.scene.raid.*;
    import view.image.raid.*;
    import view.*;
    import view.utils.*;


    /**
     * ボス状態異常管理クラス
     *
     */
    public class RaidBossBuffList extends BaseScene
    {
        private static var _buffList:Array = [];

        public function RaidBossBuffList():void
        {
        }

        private function buffFinFunc(rbb:RaidBossBuff):void
        {
            log.writeLog(log.LV_DEBUG, this, "buffFinFunc",rbb.buffId,rbb.value,rbb.limitAt);
            delBuff(rbb.buffId,rbb.value);
        }

        public function addBuff(id:int,value:int,turn:int,limit:int):void
        {
            var newBuff:Boolean = false;
            var buff:RaidBossBuff = getBuff(id,value);
            if (buff == null) {
                buff = new RaidBossBuff();
                newBuff = true;
            }
            buff.setBuff(id,value,turn,limit,buffFinFunc);
            if (newBuff) {
                _buffList.push(buff);
            }
            log.writeLog(log.LV_DEBUG, this, "BuffList",buffIdList());
            if (buff&&buff.limitAt) {
                dispatchEvent(new BuffEvent(BuffEvent.BOSS_BUFF_UPDATE));
            }
        }

        public function getBuff(id:int,v:int):RaidBossBuff
        {
            var ret:RaidBossBuff = null;
            for ( var i:int=0; i < _buffList.length; i++ ) {
                if (_buffList[i].checkSameBuff(id,v)) {
                    ret = _buffList[i];
                }
            }
            return ret;
        }

        public function delBuff(id:int,v:int):void
        {
            var tmpArray:Array = [];
            for ( var i:int=0; i < _buffList.length; i++ ) {
                if (_buffList[i].checkSameBuff(id,v)) {
                    tmpArray = _buffList.splice(_buffList.indexOf(_buffList[i]),1);
                    tmpArray[0] = null;
                    break;
                }
            }
            dispatchEvent(new BuffEvent(BuffEvent.BOSS_BUFF_DELETE,id,v));
        }

        public function allDelBuff():void
        {
            var temp:RaidBossBuff = null;
            while (_buffList.length > 0) {
                temp = _buffList.pop();
                temp = null;
            }
            dispatchEvent(new BuffEvent(BuffEvent.BOSS_BUFF_ALL_DELETE));
        }

        public function getBuffList():Array
        {
            return _buffList;
        }

        private function buffIdList():Array
        {
            var ret:Array = [];
            for ( var i:int=0; i < _buffList.length; i++ ) {
                ret.push(_buffList[i].buffId);
            }
            return ret;
        }

    }
}
