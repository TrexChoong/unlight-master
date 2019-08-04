package view.scene.raid
{

    import flash.events.*;
    import flash.utils.*;

    import org.libspark.thread.*;

    import view.WaitThread;

    import view.scene.BaseScene;

    /**
     * ボス状態異常クラス
     *
     */
    public class RaidBossBuff extends BaseScene
    {
        private var _buffId:int = 0;
        private var _value:int = 0;
        private var _turn:int = 0;
        private var _limitAtTime:int = 0;
        private var _limitAt:Date = null;
        private var _finFunc:Function = null;
        private var _waitThread:Thread;

        public function RaidBossBuff():void
        {
        }

        public function setBuff(id:int,value:int,turn:int,limit:int,finFunc:Function):void
        {
            _buffId = id;
            _value = value;
            _turn = turn;
            _limitAtTime = limit;
            if (limit > 0) {
                var now:Date = new Date();
                _limitAt = new Date(now.getTime()+_limitAtTime*1000);

                // 待ちThreadを起動させる
                var delay:int = _limitAt.getTime() - now.getTime();
                if (_waitThread != null && _waitThread.state != ThreadState.TERMINATED)
                {
                    _waitThread.interrupt();
                }
                _waitThread = new WaitThread(delay+1500, finishHandler);
                _waitThread.start();
                log.writeLog(log.LV_DEBUG, this, "addBuff",id,value,limit,now,_limitAt);
            } else {
                if (_waitThread != null && _waitThread.state != ThreadState.TERMINATED)
                {
                    _waitThread.interrupt();
                }
                _limitAt = null;
            }
            _finFunc = finFunc;
        }

        public override function final():void
        {
            if (_waitThread != null && _waitThread.state != ThreadState.TERMINATED)
            {
                _waitThread.interrupt();
            }
            _waitThread = null;
            _limitAt = null;
            _finFunc = null;
        }

        private function finishHandler():void
        {
            if (_finFunc!=null) {
                _finFunc(this);
            }
        }

        public function checkSameBuff(id:int,value:int):Boolean
        {
            return (_buffId==id&&_value==value);
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
        public function get limitAt():Date
        {
            return _limitAt;
        }
    }

}