package view.image.common
{

    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.filters.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;
    import view.ClousureThread;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;


    /**
     * アバター表示クラス
     *
     */


    public class StoryFrameImage extends BaseImage
    {

        // 表示元SWF
        [Embed(source="../../../../data/image/story/story.swf")]
        private var _Source:Class;

        public static const READMARK:String = "readmark"
        public static const BACK:String = "back"
        public static const NEXT:String = "next"
        public static const EXIT:String = "exit"
        public static const TEXT:String = "text"

        public static const CLICK_BACK:String = "click_back"
        public static const CLICK_NEXT:String = "click_next"
        public static const CLICK_EXIT:String = "click_exit"

        private var _readMarkMC:MovieClip;
        private var _readMarkContainer:Sprite = new Sprite();
        private var _backButton:SimpleButton;
        private var _nextButton:SimpleButton;
        private var _exitButton:SimpleButton;

        // リードマークのビットマップデータのカウンタ
        private var _readMarkBitmapDataVector:Vector.<BitmapData> = new Vector.<BitmapData>();
        private var _readMarkDataRectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
        private var _originalReadMCBitmapData:BitmapData;

        private var _readMarkBitmapData:BitmapData;
        private var _readMarkBitmap:Bitmap = new Bitmap();

        private var _readMarkFrameCounter:int; // animeのカウンタ

        private var _renderPoint:Point = new Point();

        private static const _READMARK_FRAME:int = 24;     // 使用フレーム数
        private static const _READMARK_FLASH:int = 12;      // 点滅の間隔
        private static const _READMARK_OFFSET_X:int = 15;  // 
        private static const _READMARK_OFFSET_Y:int = -23;
        private static const _READMARK_MARGIN:int = 8; // グロー用のマージン

        /**
         * コンストラクタ
         *
         */
        public function StoryFrameImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _readMarkMC = MovieClip(_root.getChildByName(READMARK));
            _backButton = SimpleButton(_root.getChildByName(BACK));
            _nextButton = SimpleButton(_root.getChildByName(NEXT));
            _exitButton = SimpleButton(_root.getChildByName(EXIT));
            _readMarkMC.visible = false
            _backButton.visible = false;
            _nextButton.visible = false;

            _backButton.addEventListener(MouseEvent.CLICK,backHandler);
            _nextButton.addEventListener(MouseEvent.CLICK,nextHandler);
            _exitButton.addEventListener(MouseEvent.CLICK,exitHandler);
            _readMarkBitmap.x = _READMARK_OFFSET_X;
            _readMarkBitmap.y = _READMARK_OFFSET_Y;
            drawMarkBitmap();

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {

        }

        private function backHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "buck Button ckick");
            dispatchEvent(new Event(CLICK_BACK));
        }

        private function nextHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "next Button ckick");
            dispatchEvent(new Event(CLICK_NEXT));
        }

        private function exitHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "exit Button ckick");
            dispatchEvent(new Event(CLICK_EXIT));
        }
        public function get readMark():Sprite
        {
            return _readMarkContainer;
        }

        public function get readMarkBitmap():DisplayObject
        {
            return _readMarkBitmap;
        }

        // 
        private function drawMarkBitmap():void
        {

            // 元フレームをつくる
            _originalReadMCBitmapData = new BitmapData(_readMarkMC.width+_READMARK_MARGIN, _readMarkMC.height+_READMARK_MARGIN,true, 0x00000000);
            // 元フレームをまずコピーしてバッファを作る
            _readMarkBitmapData = _originalReadMCBitmapData.clone();
            _readMarkBitmap.bitmapData = _readMarkBitmapData;
            var sExec:SerialExecutor = new SerialExecutor();
            // 元データを作る
            sExec.addThread(new DrawThread(_readMarkMC, _originalReadMCBitmapData, new Matrix(1, 0, 0, 1, 14, 15)));
            // アニメデータを作る
            sExec.addThread(new ClousureThread(createMarkBitmap));
            sExec.start();
        }


        // 元データを元にグローフィルタを書けたアニメBitmapDataを作る
        private function createMarkBitmap():void
        {
            // 指定フレームでアニメを作る
            for(var i:int = 0; i < _READMARK_FRAME; i++)
            {
            // 3フレームでべかべか。。
                var b:BitmapData = _originalReadMCBitmapData.clone();
                var str:Number = i%_READMARK_FLASH/4;
                b.applyFilter(b,b.rect,new Point (0, 0),new GlowFilter(0xFFFFAA, 1.0, 6.0,6.0,str))
                _readMarkBitmapDataVector.push(b)
                _readMarkDataRectangles.push(b.rect)
            }
            for(var j:int = _READMARK_FRAME-1; i <= 0 ; i--)
            {
            // 3フレームでべかべか。。
                b = _originalReadMCBitmapData.clone();
                str = j%_READMARK_FLASH;
                b.applyFilter(b,b.rect,new Point (0, 0),new GlowFilter(0xFFFFAA, 1.0, 6.0,6.0,str))
                _readMarkBitmapDataVector.push(b)
                _readMarkDataRectangles.push(b.rect)
            }
            _readMarkContainer.addChild(_readMarkBitmap);
            addEventListener(Event.ENTER_FRAME, readMarkAnime);

        }


        private function readMarkAnime(e:Event):void
        {
            _readMarkBitmapData.copyPixels(_readMarkBitmapDataVector[_readMarkFrameCounter], _readMarkDataRectangles[_readMarkFrameCounter], _renderPoint )
            _readMarkFrameCounter +=1;
            if (_readMarkFrameCounter >= _readMarkBitmapDataVector.length)
            {
                _readMarkFrameCounter = 0;
            }

        }

    }

}

import flash.display.*;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.image.BaseImage;
import view.BaseShowThread;
import view.BaseHideThread;


// 読み込んだイメージは2フレーム待たないと書けない。クソな仕様。
class DrawThread extends Thread
{

    private var _d:DisplayObject;
    private var _bd:BitmapData;
    private var _offset:Matrix;
    private var _counter:int = 0;
    private static const _WAIT_FRAME:int = 2;

    public function DrawThread(d:DisplayObject, b:BitmapData, offset:Matrix)
    {
        _d = d;
        _bd = b;
        _offset = offset;
    }

    protected override function run():void
    {
        next(draw);
    }

    private function draw():void
    {
        if (_counter > _WAIT_FRAME)
        {
            _bd.draw(_d, _offset);
            return;
        }else{
            _counter +=1;
            next(draw)
        }
    }
}

