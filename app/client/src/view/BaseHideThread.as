package view
{
    import flash.display.Sprite;
    import flash.utils.getQualifiedClassName;
    import org.libspark.thread.*;

// 基本的なHideスレッド
    public class BaseHideThread extends Thread
    {
        protected var _view:IViewThread;

        CONFIG::DEBUG
        public function BaseHideThread(view:IViewThread)
        {

            name = getQualifiedClassName(view); // debug用

            _view = view;
        }

        CONFIG::RELEASE
        public function BaseHideThread(view:IViewThread)
        {

//            name = getQualifiedClassName(view); // debug用

            _view = view;
        }

        protected override function run():void
        {
            next(exit);
        }

        protected function exit():void
        {
//            log.writeLog(log.LV_FATAL, this, "exit", name);
            if (Sprite(_view).parent != null)
            {
                Sprite(_view).parent.removeChild(Sprite(_view));
//                log.writeLog(log.LV_FATAL, this, "remove", name);
            }
            _view.final();

        }

    }

}
