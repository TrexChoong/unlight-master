package view
{
    import org.libspark.thread.*;
    import view.utils.TopView;

// もらったクロージャを一定スリープ語実行するだけのスレッド
    public class WaitThread extends Thread
    {
        private var _func:Function;
        private var _wait:int;
        private var _args:Array;
        private var _stop:Boolean;

        public function WaitThread(wait:int,func:Function,args:Array =null,stop:Boolean = false)
        {
            // Unlight.GCWatch(this);
            _func = func;
            _args = args;
            _wait = wait;
            _stop = stop;
        }

        protected override function run():void
        {
            if (_stop){TopView.enable(false);}
            sleep(_wait);
            next(funcDo);
            interrupted(waitInterrupted);
        }

        private function waitInterrupted():void
        {
            _func =null;
            log.writeLog(log.LV_WARN, this, "interruptd");
        }


        private function funcDo():void
        {
            if (_func != null)
            {
//            log.writeLog(log.LV_WARN, this, "clousur", _func,_args);
             if(null != _args && _args.length>0)
             {
                 _func.apply(this, _args);
                 _func =null;
             }else{
                _func();
                _func =null;
             }
            }
            if (_stop){TopView.enable(true);}


        }

    }

}

