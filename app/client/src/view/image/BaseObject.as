package view.image
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.core.UIComponent;

    import org.papervision3d.events.FileLoadEvent;
    import org.papervision3d.objects.parsers.DAE;
    import org.libspark.thread.*;


    import view.IViewThread;

    /**
     * DAEファイルを使用したオブジェクトの基底クラス
     *
     */
    public class BaseObject extends Sprite implements IMonitor, IViewThread
    {
        private var _monitor:Monitor;
        protected var _loaded:Boolean = false;
        protected var _object:DAE;
        protected var _container:UIComponent;
        protected var _depthAt:int;

        /**
         * コンストラクタ
         *
         */
        public function BaseObject()
        {
            _monitor = new Monitor();
            _object = new DAE();

            //FileLoadEventでColladaの読み込みを監視
            _object.addEventListener(FileLoadEvent.LOAD_COMPLETE, initObject);
        }

        // オブジェクトの初期化をする仮想関数
        protected function initObject(event:FileLoadEvent):void
        {
            _loaded = true;
        }

        /**
         * オブジェクト本体
         *
         */
        public function get getObject():DAE
        {
            return _object;
        }

        // 特定フレームで停止させるイベントハンドラを返す関数
        private function stopFunc(num:int):Function
        {
            var func:Function;
            func = function(e:Event):void
            {
                if (e.target.currentFrame == num)
                {
                    e.target.stop();
                    e.target.removeEventListener(Event.ENTER_FRAME,func);
                }
            }
            return func;
        }

        // オブジェクトを特定のフレームで止める関数
        protected function frameStop(object:DAE, num:int):void
        {
            object.addEventListener(Event.ENTER_FRAME,stopFunc(num));
        }

        // ローディング状態を返す
        public function get loaded():Boolean
        {
            return _loaded;
        }

        // Monitorクラスの委譲用関数
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

        // 表示用のスレッドを返す
        public function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return  new ShowThread(this, stage);
        }

        // 非表示用のスレッドを返す
        public function getHideThread(type:String=""):Thread
        {
            return  new HideThread(this);
        }

        public function get depthAt():int
        {
            return _depthAt;
        }

        public function init():void
        {
        }

        public function final():void
        {
            _object.removeEventListener(FileLoadEvent.LOAD_COMPLETE, initObject);
        }

    }
}

import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.image.BaseObject;
import view.BaseShowThread;
import view.BaseHideThread;


// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{
    private var _bo:BaseObject;

    public function ShowThread(bo:BaseObject, stage:DisplayObjectContainer)
    {
        _bo = bo;
        super(bo, stage)
    }

    protected override function run():void
    {
        // ロードを待つ
        if (_bo.loaded == false)
        {
            _bo.wait();
        }
        next(close);
    }

}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
   public function HideThread(bo:BaseObject)
    {
        super(bo);
    }

}













