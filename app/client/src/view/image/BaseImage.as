package view.image
{

    import flash.utils.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.core.UIComponent;

    import org.libspark.thread.*;

    import view.IViewThread;
    /**
     * SWFのムービークリップを使用したイメージ基底クラス
     *
     */


    public class BaseImage extends UIComponent implements IMonitor, IViewThread
    {

//         [Embed(source="../../../data/image/*.swf")]
        private var _Source:Class;
        private var _monitor:Monitor;
        protected var _loaded:Boolean = false;
        protected var _mc:MovieClip;
        protected var _root:MovieClip;
        protected var _container:UIComponent;
        protected var _loaderInfo:LoaderInfo;
        protected var _depthAt:int;

        /**
         * コンストラクタ
         *
         */
        public function BaseImage()
        {
            _monitor = new Monitor();
            var mc:MovieClip = new Source();
            _loaderInfo = Loader(mc.getChildAt(0)).contentLoaderInfo;
            _loaderInfo.addEventListener(Event.INIT, swfinit);

//             log.writeLog(log.LV_FATAL, this, "a",_loaderInfo.bytesLoaded,_loaderInfo.bytesTotal);
//             if (_loaderInfo.bytesTotal==0 || (_loaderInfo.bytesTotal > 0 && _loaderInfo.bytesLoaded < _loaderInfo.bytesTotal)) {
//                 _loaderInfo.addEventListener(Event.INIT, swfinit);
//             } else {
//                 alreadyLoaded();
//             }

            _mc = mc;
            addChild(_mc);
        }

        // MovieClipのルートをとる関数
        CONFIG::DEBUG
        protected function swfinit(event: Event): void
        {
            _loaderInfo.removeEventListener(Event.INIT, swfinit);
            _root = event.target.content;
            _root.stop();
            _loaded = true;
            notifyAll();

//            Unlight.GCW.watch(_monitor,getQualifiedClassName(this));

        }

        CONFIG::RELEASE
        protected function swfinit(event: Event): void
        {
            _loaderInfo.removeEventListener(Event.INIT, swfinit);
            _root = event.target.content;
            _root.stop();
            _loaded = true;
            notifyAll();
        }

        private function alreadyLoaded():void
        {
            _loaderInfo.removeEventListener(Event.INIT, swfinit);
            var mc:MovieClip = new Source();
//            _root = MovieClip(mc.getChildAt(0));
             _root = MovieClip(_loaderInfo.content);
            _root.stop();
            _loaded = true;
            notifyAll();
        }

        // オーバライド前提のソースクラスゲッター()
        protected function get Source():Class
        {
            return _Source;
        }

        /**
         * ルートを返す
         *
         */
        public function get MCRoot():MovieClip
        {
            return _root;
        }

        /**
         * 本体のムービークリップ
         *
         */
        public function get  main():MovieClip
        {
            return _mc;
        }

        // 特定フレームで停止させるイベントハンドラを返す関数
        private function stopFunc(num:int):Function
        {
            var func:Function;
            func =  function(e:Event):void
            {
                if (e.target.currentFrame == num)
                {
                    e.target.stop();
                    e.target.removeEventListener(Event.ENTER_FRAME,func);
                }
            }
            return func;

        }

        // ムービークリップを特定のフレームで止める関数
        protected function frameStop(mc:MovieClip, num:int):void
        {
            mc.addEventListener(Event.ENTER_FRAME,stopFunc(num));
        }

        // ロード前に_rootにさわれないようにする。
        protected function waitComplete(func:Function):void
        {
            if (_root == null)
            {
                _loaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{
                        func();
                        _loaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
                    }
                    );
            }
            else
            {
                func();
            }

        }
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
            return  new ShowThread(this, stage, at);
        }

        // 表示用のスレッドを返す
        public function getHideThread(type:String=""):Thread
        {
            return  new HideThread(this);
        }

        public function get depthAt():int
        {
            return _depthAt;
        }

        public function set depthAt(d:int):void
        {
            _depthAt = d;
        }

        public function final():void
        {

        }

        public function init():void
        {

        }

    }

}
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.image.BaseImage;
import view.BaseShowThread;
import view.BaseHideThread;


// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{
    private var _bi:BaseImage;
    private var _at:int;

    public function ShowThread(bi:BaseImage, stage:DisplayObjectContainer, at:int)
    {
        _bi = bi;
        _at = at;
        super(bi, stage)
    }

    protected override function run():void
    {
        // ロードを待つ
        if (_bi.loaded == false)
        {
            _bi.wait();
        }
        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(bi:BaseImage)
    {
        super(bi);
    }
}
