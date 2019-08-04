package view.scene.common
{

    import flash.display.*;
    import flash.text.*;
    import flash.events.*;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.core.UIComponent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;

    import model.MessageLog
    import view.ClousureThread;
    import view.scene.BaseScene;


    /**
     * トランジション専用クラス
     *
     */

    public class Transition extends UIComponent
    {
        protected static var __instance:Transition; // シングルトン保存用
        private var _beforeBitmapData:BitmapData = new BitmapData(Unlight.WIDTH, Unlight.HEIGHT);
        private var _transitionBitMap:Bitmap;
        private var _maskBitmapData:BitmapData = new BitmapData(Unlight.WIDTH, Unlight.HEIGHT);
        private var _stage:DisplayObjectContainer;
        private static const  __RDM:int = Math.floor(Math.random()*10000);
        
        /**
         * コンストラクタ
         *
         */
        public function Transition(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor."); 
            createMask();
  
        }

        private static function createInstance():Transition
        {
            return new Transition(arguments.callee);
        }

        public static function get instance():Transition
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }

        public function setTransionImage(writer:UIComponent,stage:DisplayObjectContainer):void
        {
            _stage = stage;
            _beforeBitmapData.draw(writer);
//            createMask();
            _transitionBitMap = new Bitmap(_beforeBitmapData);
            _stage.addChild(_transitionBitMap);

        }

        private function createMask():void
        {
            _maskBitmapData.perlinNoise(100, 100, 5, __RDM, false, true, 1, true);
        }

        public function getBurnigTransitionThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor()

            sExec.addThread(new BurnTransitionThread(_beforeBitmapData, _maskBitmapData));
            sExec.addThread( new ClousureThread(function():void{ _stage.removeChild(_transitionBitMap)}));
            return sExec;
        }



    }
}

import flash.display.*;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;


class BurnTransitionThread extends Thread
{
    private var _source:BitmapData;
    private var _mask:BitmapData;
    private var _threshold:uint;

    public function BurnTransitionThread(m:BitmapData, s:BitmapData)
    {
        _mask = m;
        _source = s;
        _threshold = 0x000000;
    }

    protected override function run():void
    {
        next(burning);
    }


    private function burning():void
    {
        if (_threshold > 0xDFFFFF)
        {
            next(fin);
        }else{
            _threshold += (0xFFFFFF-_threshold)*0.06;
            _mask.threshold(_source, _source.rect, new Point(0, 0), "<=", _threshold, 0, 0x00FFFFFF , false);
            next(burning);
//            log.writeLog(log.LV_FATAL, this, "th",_threshold);
        }
    }

    private function fin():void
    {
        
    }



}
