package view.image
{
    import flash.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.URLRequest;

    import mx.core.UIComponent;

    import org.libspark.thread.*;

    import view.IViewThread;
    import view.utils.RemoveChild;

    import flash.utils.ByteArray;
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.hash.IHash;
    import com.hurlant.util.Hex;



//    import flash.net.URLRequest;


//    import flash.events.MouseEvent;

    /**
     * SWFのムービークリップを使用したイメージ基底クラス
     *
     */


    public class BaseLoadImage extends UIComponent implements IMonitor, IViewThread
    {
        private static const RETRY_MAX:int = 10;

        private var _monitor:Monitor;
        protected var _loaded:Boolean = false;
        protected var _loader:Loader;
        protected var _root:MovieClip;
//      protected var _container:UIComponent;
        protected var _loaderInfo:LoaderInfo;
        protected var _depthAt:int;
        private var _url:String;
        private var _errorCount:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function BaseLoadImage(url:String )
        {
            _url = url;
            if ( _url.match( /.swf/ ) != null ) {
                if ( Unlight._IMAGE_MD5_IS_SET ) {
                    var file_md5:String = getFilenameMD5( url.substring( url.lastIndexOf("/")+1, url.lastIndexOf(".") )+Unlight._IMG_HASH_KEY );

                    _url = _url + "." + file_md5;
                    url = _url;
                }
            }
            _monitor = new Monitor();
            var urlReq:URLRequest = new URLRequest(url);
            _loader = new Loader();
            _loader.load(urlReq);
            _loaderInfo = _loader.contentLoaderInfo;
            _loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
//            _loaderInfo.addEventListener(Event.INIT, swfinit);

//            log.writeLog(log.LV_FATAL, this, "a",_loaderInfo.bytesLoaded,_loaderInfo.bytesTotal);
            if (_loaderInfo.bytesTotal==0 || (_loaderInfo.bytesTotal > 0 && _loaderInfo.bytesLoaded < _loaderInfo.bytesTotal)) {
                _loaderInfo.addEventListener(Event.INIT, swfinit);
            } else {
                alreadyLoaded();
            }

            addChild(_loader);
        }

        // ファイル名からMD5を取得
        private function getFilenameMD5(filename:String):String
        {
            var hexStr:String = Hex.fromString(filename);
            var bStr:ByteArray = Hex.toArray(hexStr);
            var hashStr:IHash = Crypto.getHash("md5");
            var bArr:ByteArray = hashStr.hash(bStr);
            var ret:String = Hex.fromArray(bArr);
            return ret;
        }

        // MovieClipのルートをとる関数
        protected function swfinit(event: Event):void
        {
            _loaderInfo.removeEventListener(Event.INIT, swfinit);
            _loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
            _root = event.target.content;
            _root.stop();
            
            _loaded = true;
            notifyAll();
//             Unlight.GCWatch(_loader);
//             Unlight.GCWatch(_root);
//             Unlight.GCW.watch(_loaderInfo);
//           log.writeLog (log.LV_DEBUG,this,_root);
//            Unlight.GCW.watch(_monitor,getQualifiedClassName(this));
        }

        private function loadError(event:Event):void
        {
            if (_errorCount < RETRY_MAX)
            {
                RemoveChild.apply(_loader);
                _loader.unload();
                _loaderInfo.removeEventListener(Event.INIT, swfinit);
                _loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);

                var urlReq:URLRequest = new URLRequest(_url);
                _loader = new Loader();
                _loader.load(urlReq);
                _loaderInfo = _loader.contentLoaderInfo;
                _loaderInfo.addEventListener(Event.INIT, swfinit);
                _loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
                _errorCount +=1;
            }

        }
        private function alreadyLoaded():void
        {
            _loaderInfo.removeEventListener(Event.INIT, swfinit);
            _loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
            _root = MovieClip(_loader.content);
            _root.stop();
            _loaded = true;
            notifyAll();
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
        public function get  main():DisplayObject
        {
            return _loader.content;
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
                    })
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
            return  new ShowThread(this, stage);
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

        public function get url():String
        {
            return _url;
        }

        public function init():void
        {
        }

        public function final():void
        {
            if ( _loader ) {
                _loader.unload();
                RemoveChild.apply(_loader);
                _loader = null;
            }
        }

    }

}
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.image.BaseLoadImage;

import view.BaseShowThread;
import view.BaseHideThread;



// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{
    private var _bli:BaseLoadImage;

    public function ShowThread(bli:BaseLoadImage, stage:DisplayObjectContainer)
    {

        _bli = bli;
        super (bli, stage)
    }

    protected override function run():void
    {
        // ロードを待つ
        if (_bli.loaded == false)
        {
            _bli.wait();
//            log.writeLog (log.LV_WARN,this,this.id, "wait",_bli);

        }
        next(close);
    }

}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(bi:BaseLoadImage)
    {
        super(bi);
    }

}