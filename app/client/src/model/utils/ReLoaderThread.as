package model.utils
{
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import model.BaseModel;

// CharaCardのロードを待つスレッド
    public class ReLoaderThread extends Thread
    {
        protected var _loader:Function;
        protected var _bm:BaseModel;
        protected var _time:int = 0;
        protected var _reloadSec:int = 100000;

        public function ReLoaderThread(func:Function, bm:BaseModel,reloadSec:int = Const.RELOAD_INT)
        {
            _loader = func;
            _bm = bm;
            _reloadSec =reloadSec

        }

        protected override function run():void
        {
            if (_bm.loaded)
            {
                return;
            }else{
                _loader(_bm.id);
                next(waitingTimer);
            }
        }

        protected function waitingTimer ():void
        {
            sleep(_reloadSec);
            next(check)
        }
        private function check():void
        {
            if (_time < Const.RELOAD_LIMIT)
            {
                _time +=1;
                next(reload);
            }else{
                return;
            }

        }
        protected function reload():void
        {
            if (_bm.loaded == false)
            {
                _loader(_bm.id);
                next(waitingTimer);
                log.writeLog(log.LV_WARN, "model" ,"load Fail ReLoad!!",_bm,_reloadSec);
            }
        }


    }
}