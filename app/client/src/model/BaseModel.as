package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import org.libspark.thread.*;

    /**
     * モデルのベースクラス
     * Monitorクラスを委譲させている。
     *
     */
    public class BaseModel  extends EventDispatcher implements IMonitor
    {

        private var _monitor:Monitor;
        protected var _id:int;
        protected var _loaded:Boolean = false;

        // コンストラクタ
        public function BaseModel()
        {
            _monitor = new Monitor();
        }

        public function wait(timeout:uint = 0):void
        {
            _monitor.wait(timeout);
        }
        public function notify():void
        {
            _monitor.notify();
        }
        public function notifyAll():void
        {
            _monitor.notifyAll();
        }
        public function leave(thread:Thread):void
        {
            _monitor.leave(thread);
        }

        public function get loaded():Boolean
        {
            return _loaded;
        }

        public function get id():int
        {
            return _id;
        }

    }
}