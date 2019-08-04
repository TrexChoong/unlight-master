package view
{
    import org.libspark.thread.*;
    import flash.utils.getQualifiedClassName;

// もらったクロージャを実行するだけのスレッド
    public class ClousureThread extends Thread
    {
        private var _func:Function;
        private var _args:Array;

        public function ClousureThread(func:Function, args:Array =null)
        {
            _func = func;
            _args = args;
        }

        protected override function run():void
        {
//            log.writeLog(log.LV_WARN, this, "clousur", _func,_args);
             if(null != _func)
             {
//                _func();
                 _func.apply(this, _args);
                 _func =null;
             }
        }

    }

}


