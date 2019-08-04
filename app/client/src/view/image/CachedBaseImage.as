package view.image
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;

    import view.image.*;
    import flash.utils.*;

    import org.libspark.thread.*;

    /**
     * キャッシュ済みのイメージの基底クラス
     *
     */

    public class CachedBaseImage extends BaseImage
    {

        public static const CLIP_AREA:Rectangle = new Rectangle(673,30,292,234);
        public static const CASH_BITMAP_DATA:int = 1;
        public static const CASH_BYTE_ARRAY:int = 2;
        public static const LABEL:Array= ["wind"];
        public static var CACHE_TYPE:int = CASH_BYTE_ARRAY;
        public static var _cacheID:int = -1;

        private var _mainBitmapData:BitmapData;
        private var _mainBitmap:Bitmap;
        protected var _animeThread:Thread;

        private var _curerrentFrame:int = 0;
        private var _repeat:Boolean = true;

        /**
         * コンストラクタ
         *
         */
        public function CachedBaseImage()
        {
            _mainBitmapData = new BitmapData(cacheClipArea.width,cacheClipArea.height,true,0x00000000);
            _mainBitmap = new Bitmap(_mainBitmapData);
            _mainBitmap.x = cacheClipArea.x;
            _mainBitmap.y = cacheClipArea.y;
            super();
        }

        // swfを読み込み終わった後の処理
        override protected function swfinit(event: Event): void 
        {
            _root = event.target.content;
            _root.stop();
            _root.visible = false;
            // 描画対象のビットマップデータ
            if (cached == false)
            {
                switch (cacheType)
                {
                case CASH_BYTE_ARRAY:
                    ImageCacheUtl.createByteArrayCache(_root, cacheClipArea, label, cacheOn);
                    break;
                case CASH_BITMAP_DATA:
                    ImageCacheUtl.createBitmapDataCache(_root, cacheClipArea, label, cacheOn);
                    break;
                default:
                }
            }else{
                cacheOn(cacheID)
            }
//            addChild(_mainBitmap);
        }

        // キャッシュをONにする
        private  function cacheOn(id:int):void
        {
            notifyAll();
            cacheID = id;
            _loaded = true;
            gotoAndStop(0);
            removeChild(_mc);
            addChild(_mainBitmap);
       }

        // 今のフレームで再生
        public function play():void
        {
            cacheAnimeStart(currentFrame);
        }

        // 最初から最後まで
        public function goPlay(to:int = -1):void
        {
            cacheAnimeStart(0, to);
        }

        // すぐに止める
        public function stop():void
        {
            cacheAnimeStop();
        }

        // 特定フレームで止める
        public function gotoAndStop(frame:int):void
        {
            cacheAnimeStart(frame, frame)
        }

        // 特定フレームに行ってから止める
        public function gotoAndPlay(frame:int):void
        {
            cacheAnimeStart(frame);
        }

        // キャッシュしたアニメのスタート
        private function cacheAnimeStart(start:int = -1, end:int= -1):void
        {
            if ((_animeThread == null)||(_animeThread.state == ThreadState.TERMINATED))
            {
                switch (cacheType)
                {
                case CASH_BYTE_ARRAY:
                    _animeThread = new LoopByteArrayThread(this, start, end, _mainBitmap);
                    break;
                case CASH_BITMAP_DATA:
                    _animeThread = new LoopBitmapDataThread(this, start, end, _mainBitmap);
                    break;
                default:
                }
                _animeThread.start();
            }
        }

        // キャッシュしたアニメのストップ
        private function cacheAnimeStop():void
        {
            if (_animeThread != null)
            {
//                log.writeLog(log.LV_FATAL, this, "interrupt!!!!!");
                _animeThread.interrupt();
                _animeThread = null;
            }
        }

//         // bitmapのゲッター
//         public function get bitmap():Bitmap
//         {
//             return _mainBitmap;
//         }

        // オーバーライド前提のキャッシュが切り取るエリアのRectangle
        public function get cacheClipArea():Rectangle
        {
            return CLIP_AREA;
        }


        // オーバライド前提のムービーラベル
        protected function get label():Array /* of String */ 
        {
            return LABEL;
        }

        // オーバライド前提のムービーラベル
        protected function get cacheID():int
        {
            return _cacheID;
        }
        // オーバライド前提のムービーラベル
        protected  function set cacheID(i:int):void
        {
            _cacheID = i;
        }

        // オーバライド前提のキャッシュタイプ
        protected  function get cacheType():int
        {
            return CACHE_TYPE;
        }

        // キャッシュ済みかの判定
        public function get cached():Boolean
        {
            if (cacheID == -1)
            {
                return false;
            }else{
                return true;
            }
        }

        // キャッシュデータのゲッター（bitmapData版）
        public function get  bitmapDataVector():Vector.<BitmapData>
        {
            return ImageCacheUtl.CashData[cacheID];
        }

        // キャッシュデータのゲッター（byteArray版）
        public function get  byteArrayVector():Vector.<ByteArray>
        {
            return ImageCacheUtl.CashData[cacheID];
        }

        // 現在のフレーム
        public function get currentFrame():int
        {
            return _curerrentFrame;
        }

        public function set currentFrame(i:int):void
        {
            _curerrentFrame = i;
        }

        // リピートありなのか？
        public function get repeat():Boolean
        {
            return _repeat;
        }

        public function set repeat(b:Boolean):void
        {
            _repeat = b;
        }




    }

}

import flash.display.*;
import flash.geom.*;
import flash.utils.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.image.BaseImage;
import view.BaseShowThread;
import view.BaseHideThread;

import view.image.CachedBaseImage;


// キャッシュ形式BitmapDataの場合のアニメスレッド
class LoopBitmapDataThread extends Thread
{
    private var _bi:CachedBaseImage;
    private var _len:int;
    private var _i:int = 0;
    private var _vector:Vector.<BitmapData>;
    private var _bitmap:Bitmap;
    private var _start:int;
    private var _end:int;
    private var _repeat:Boolean;
    private var _loop:Function;

    public function LoopBitmapDataThread(bi:CachedBaseImage, start:int = -1, end:int = -1, bitmap:Bitmap=null)
    {
        _bi = bi;
        _start = start;
        _end =end;
        _bitmap = bitmap;

    }

    protected override function run():void
    {
        // ロードを待つ
        if (_bi.loaded == false)
        {
            _bi.wait();
        }
//        next(_loop);
//        log.writeLog(log.LV_FATAL, this, "start");
        next(loadComp)
    }

    private function loadComp():void
    {
        _vector = _bi.bitmapDataVector;
        _len = _vector.length;
        _loop = repeatAllLoop;

        // もし開始フレームが定義されていたら、開始フレームを設定する
        if (_start > -1)
        {
            _i = _start;
        }

        // もし終了フレームが定義されていたら終了フレームを記憶する
        if (_end >-1)
        {
            _loop = toEndFrameLoop;
            _len = _end;
        }
        // もしリピートが設定されていなければ止める
        if (_bi.repeat == false)
        {
            _loop = toEndFrameLoop;
        }

        next(_loop);

    }

    // すべてをリピートするループ
    private function repeatAllLoop():void
    {
        if (checkInterrupted())
        {
            next(final);
            return;
        }
        _bitmap.bitmapData = _vector[_i];
        _i +=1;
        if (_i == _len){_i = 0}
        next(_loop);
    }

    // endFrameまでアニメする
    private function toEndFrameLoop():void
    {
        if (checkInterrupted())
        {
            next(final);
            return;
        }
        _bitmap.bitmapData = _vector[_i];
        _i +=1;
        if (_i > _len){
            next(final);
        }else{
            next(_loop);
        }
    }

    private function final():void
    {
        _bi.currentFrame = _i;
//        log.writeLog(log.LV_FATAL, this, "end");
    }
}

// キャッシュ形式ByteArrayの場合のアニメスレッド
class LoopByteArrayThread extends Thread
{
    private var _bi:CachedBaseImage;
    private var _len:int;
    private var _i:int = 0;
    private var _rect:Rectangle;
    private var _bitmap:Bitmap;
    private var _start:int;
    private var _end:int;
    private var _repeat:Boolean;
    private var _loop:Function;

    public function LoopByteArrayThread(bi:CachedBaseImage, start:int = -1, end:int = -1,bitmap:Bitmap=null)
    {
//        log.writeLog(log.LV_FATAL, "bi is ", bi);
        _bitmap = bitmap;
        _bi = bi;
        _start = start;
        _end =end;
        _loop = repeatAllLoop;
    }

    protected override function run():void
    {
        // ロードを待つ
        if (_bi.loaded == false)
        {
            _bi.wait();
        }


        next(loadComp)
    }

    private function loadComp():void
    {
        _len =  _bi.byteArrayVector.length;
        _rect = new Rectangle (0,0,_bi.cacheClipArea.width, _bi.cacheClipArea.height);
        _loop = repeatAllLoop;

        // もし開始フレームが定義されていたら、開始フレームを設定する
        if (_start > -1)
        {
            _i = _start;
        }

        // もし終了フレームが定義されていたら終了フレームを記憶する
        if (_end >-1)
        {
            _loop = toEndFrameLoop;
            _len = _end;
        }
        // もしリピートが設定されていなければ止める
        if (_bi.repeat == false)
        {
            _loop = toEndFrameLoop;
        }

        next(_loop);

    }

    // すべてをリピートするループ
    private function repeatAllLoop():void
    {
        if (checkInterrupted())
        {
            next(final);
            return;
        }
        var ba:ByteArray = new ByteArray();
//        _bi.byteArrayVector[_i].position = 0;
        ba.writeBytes(_bi.byteArrayVector[_i]);
//        ba.position =0;
        ba.uncompress();
        _bitmap.bitmapData.setPixels(_rect,ba);
        _i +=1;
        if (_i == _len){_i = 0}
        next(_loop);
    }

    // endFrameまでアニメする
    private function toEndFrameLoop():void
    {
        if (checkInterrupted())
        {
            next(final);
            return;
        }
        var ba:ByteArray = new ByteArray();
//        _bi.byteArrayVector[_i].position = 0;
        ba.writeBytes(_bi.byteArrayVector[_i]);
//        ba.position =0;
        ba.uncompress();
        _bitmap.bitmapData.setPixels(_rect,ba);
        _i +=1;
        if (_i > _len-1){
            next(final);
        }else{
            next(_loop);
        }
    }

    private function final():void
    {
//        log.writeLog(log.LV_FATAL, this, "end");
        _bi.currentFrame = _i;
    }

}

