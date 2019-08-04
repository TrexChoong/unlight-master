package view.image
{

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


    public class BasePngImage extends UIComponent implements IViewThread
    {

//         [Embed(source="../../../data/image/*.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private var _bmp:Bitmap;
        protected var _depthAt:int;

        /**
         * コンストラクタ
         *
         */
        public function BasePngImage()
        {
            _bmp = new Source();
            _bmp.smoothing = true;
            addChild(_bmp);
        }


        protected function get Source():Class
        {
            return _Source;
        }

        // 表示用のスレッドを返す
        public function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
//            log.writeLog(log.LV_INFO, this, "atatatata");
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

import view.BaseShowThread;
import view.BaseHideThread;
import view.*;

// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(bi:IViewThread, stage:DisplayObjectContainer)
    {
        super(bi, stage)
    }

    protected override function run():void
    {
        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(bi:IViewThread)
    {
        super(bi);
    }
}
