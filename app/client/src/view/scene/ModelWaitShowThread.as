package view.scene
{
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import org.libspark.thread.Thread;

    import model.BaseModel;

    import view.BaseShowThread;
    import view.IViewThread;
    import view.scene.common.AvatarClip;

    public class ModelWaitShowThread extends BaseShowThread
    {
        private var _m:BaseModel;
        public function ModelWaitShowThread(view:IViewThread, stage:DisplayObjectContainer, m:BaseModel)
        {
            _m = m;
            super(view, stage);
        }

        protected override function run():void
        {
//            log.writeLog(log.LV_INFO, this, "run?");
           if (_m.loaded == false)
            {
                log.writeLog(log.LV_INFO, this, "waiting?",_m,_m.id);
                _m.wait();
            }
            next(close);
        }
    }
}
