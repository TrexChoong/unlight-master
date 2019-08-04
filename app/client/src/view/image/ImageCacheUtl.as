package view.image
{
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.utils.*;


    public class ImageCacheUtl
    {
        // キャッシュされたByteArrayを保存
        static public var CashData:Array = []; /* of Vector */
//        static public var CashData:Vector.<BitmapData> = new Vector.<BitmapData>;
        // キャッシュが有効かを返す
        static public var CashReady:Vector.<Boolean> = new Vector.<Boolean>();

        // キャッシュ済みのクラス名とキャッシュIDを保存する
        static public var CachedClass:Object = new Object;

        static public function createCache(mc:MovieClip, r:Rectangle, name:String):void
        {
        }

        static public function createBitmapDataCache(mc:MovieClip, r:Rectangle, nameArray:Array, setIDFunc:Function):void
        {
//             var m:MovieClip = MovieClip(mc.getChildByName(name));
            var m:MovieClip = getChildMC(mc, nameArray);
            m.stop();
            new LoadingBitmapDataThread(mc, m, r, setIDFunc).start();
        }

        static public function createByteArrayCache(mc:MovieClip, r:Rectangle, nameArray:Array , setIDFunc:Function):void
        {
//             var m:MovieClip = MovieClip(mc.getChildByName(name));
            var m:MovieClip = getChildMC(mc, nameArray);
//            var m:MovieClip = getChildMC(mc.getChildByName("Shadow"));
            
//            log.writeLog(log.LV_FATAL, "utl", "create mc from name", nameArray, m);
            m.stop();
            new LoadingByteArrayThread(mc, m, r, setIDFunc).start();

        }

        static private function getChildMC(_r:MovieClip, name:Array):MovieClip
        {
//            log.writeLog(log.LV_FATAL, "mc loder mc", _r);
            var t:MovieClip;
            if (name.length == 0)
            {
                t =_r
            }else{
            name.forEach(function(item:*, index:int, array:Array):void
                         {
                             var m:MovieClip = MovieClip(_r.getChildByName(item));
                             if (m ==null){t = MovieClip(t.getChildAt(0))}else{t = m}
//                             log.writeLog(log.LV_FATAL, "mc loder", t);
//                             t.gotoAndStop(3);
                         });
            }
            return t;
        }


    }

}



import flash.display.*;
import flash.events.Event;
import flash.geom.*;
import flash.utils.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.image.BaseImage;
import view.BaseShowThread;
import view.BaseHideThread;

import view.image.ImageCacheUtl;


 class LoadingByteArrayThread extends Thread
 {
     private var _i:int = 0;
     private var _vector:Vector.<ByteArray>; /* of BitmapData */
     private var _tmpBa:ByteArray = new ByteArray;
     private var _root:MovieClip;
     private var _mc:MovieClip;
     private var _tmpBitmapData:BitmapData;
     private var _totalFrames:int = 0;
     private var _rect:Rectangle;
     private var _setIDFunc:Function;
     private var _p:Point = new Point (0,0);
     private var _copyRect:Rectangle;
     private var _m:Matrix;
     private var _h:int;
     private var _w:int;


     public function LoadingByteArrayThread(root:MovieClip, mc:MovieClip, r:Rectangle, func:Function)
     {
         _root = root;
         _mc = mc;
         _rect = r;
         _setIDFunc = func;
         _tmpBitmapData = new BitmapData(_rect.width, _rect.height,true,0x00000000);
         _totalFrames = _mc.totalFrames;
//         log.writeLog(log.LV_FATAL, this, "frame num ", _totalFrames, _rect);
         _vector = new Vector.<ByteArray>(_totalFrames);
         _m = new Matrix (1,0,0,1,r.x*-1,r.y*-1);
         _copyRect = new Rectangle(0,0, 292, 234);
         _h = r.height;
         _w = r.width;
    }

    protected override function run():void
    {
        next(loop);
//        log.writeLog(log.LV_FATAL, this, "start", getTimer());
    }

     private function loop():void
     {
         _tmpBitmapData.lock()
         _mc.gotoAndStop(_i);
         // ビットマップデータを新規に作る
         _tmpBitmapData = new BitmapData(_w, _h,true,0x00000000);
         _tmpBitmapData.draw(_root, _m, null, null, _copyRect, true);
         // ビットマップデータに描く
         _tmpBa.position = 0;
         _tmpBa.writeBytes(_tmpBitmapData.getPixels(_copyRect));
         _tmpBa.compress();
         _vector[_i] = new ByteArray();
         _vector[_i].writeBytes(_tmpBa);
         _i +=1;
         if (_totalFrames==_i)
         {
             next(finish);
         }else{
             next(loop);
         }
         _tmpBitmapData.unlock()
     }

     private function finish():void
     {
//        log.writeLog(log.LV_FATAL, this, "end", getTimer());
         // Vectorをキャッシュに保存し、IDをクラスに登録する。
         _setIDFunc(ImageCacheUtl.CashData.push(_vector)-1);
     }


 }

 class LoadingBitmapDataThread extends Thread
 {
     private var _i:int = 0;
     private var _vector:Vector.<BitmapData>; /* of BitmapData */
     private var _root:MovieClip;
     private var _mc:MovieClip;
     private var _tmpBitmapData:BitmapData;
     private var _totalFrames:int = 0;
     private var _rect:Rectangle;
     private var _setIDFunc:Function;
     private var _p:Point = new Point (0,0);
     private var _copyRect:Rectangle;
     private var _m:Matrix;

     public function LoadingBitmapDataThread(root:MovieClip, mc:MovieClip, r:Rectangle, func:Function)
     {
         _root = root;
         _mc = mc;
         _rect = r;
         _setIDFunc = func;
         _tmpBitmapData = new BitmapData(mc.width, mc.height,true,0x00000000);;
         _totalFrames = _mc.totalFrames;
         _vector = new Vector.<BitmapData>(_totalFrames);
         _m = new Matrix (1,0,0,1,r.x*-1,r.y*-1)
        _copyRect = new Rectangle(0,0, 292, 234);
    }

    protected override function run():void
    {
        next(loop);
//        log.writeLog(log.LV_FATAL, this, "start", getTimer());
    }

     private function loop():void
     {
         // ムービーを止める
         _mc.gotoAndStop(_i);
         // ビットマップデータを新規に作る
         _tmpBitmapData = new BitmapData(_rect.width, _rect.height,true,0x00000000);
         // ビットマップデータに描く
         _tmpBitmapData.draw(_root, _m, null, null,_copyRect, true);
         _vector[_i] = new BitmapData(_rect.width,_rect.height,true,0xFF0000FF);
         _vector[_i].copyPixels(_tmpBitmapData, _copyRect, _p);
         _i +=1;

         if (_totalFrames==_i)
         {
             next(finish);
         }else{
             next(loop);
         }
     }

     private function finish():void
     {
//        log.writeLog(log.LV_FATAL, this, "end", getTimer());
         // Vectorをキャッシュに保存し、IDをクラスに登録する。
         _setIDFunc(ImageCacheUtl.CashData.push(_vector)-1);
     }


 }

