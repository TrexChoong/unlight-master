package view
{
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.events.*;
    import org.libspark.thread.Thread;

    import model.BaseModel;

    import view.BaseShowThread;
    import view.IViewThread;
    import view.scene.common.AvatarClip;

    import org.libspark.thread.*;

// もらったクロージャを一定スリープ語実行するだけのスレッド
    public class ModelWaitThread extends Thread
    {
        private var _func:Function;
        private var _args:Array;
        private var _m:BaseModel;

        public function ModelWaitThread(m:BaseModel,func:Function, args:Array =null)
        {
            _m = m;
            _func = func;
            _args = args;

        }

        protected override function run():void
        {
//            log.writeLog(log.LV_INFO, this, "run?");
            if (_m.loaded == false)
            {
                log.writeLog(log.LV_INFO, this, "waiting?",_m,_m.id);
                _m.wait();
            }
            next(callFunc);
        }

        private function callFunc():void
        {
            _func.apply(this, _args);
        }
    }
}