package view.image.game
{

    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;

    import flash.events.Event;
    import org.libspark.thread.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import model.Duel;

    /**
     * BG表示クラス
     *
     */


    public class FarBG extends BG
    {
        // OKボタン 表示元SWF
        [Embed(source="../../../../data/image/bg/bg_btl00a_far.swf")]
        private static var _castle:Class;
        [Embed(source="../../../../data/image/bg/bg_btl01a.swf")]
        private static var _forest:Class;
        [Embed(source="../../../../data/image/bg/bg_btl00a_far.swf")]
        private static var _road:Class;
        [Embed(source="../../../../data/image/bg/bg_btl03a.swf")]
        private static var _lakeside:Class;
        [Embed(source="../../../../data/image/bg/bg_btl04a.swf")]
        private static var _grave:Class;
        [Embed(source="../../../../data/image/bg/bg_btl05a.swf")]
        private static var _village:Class;
        [Embed(source="../../../../data/image/bg/bg_btl06a.swf")]
        private static var _wild:Class;
        [Embed(source="../../../../data/image/bg/bg_btl07a.swf")]
        private static var _ruin:Class;
        [Embed(source="../../../../data/image/bg/bg_btl08a.swf")]
        private static var _town:Class;
        [Embed(source="../../../../data/image/bg/bg_btl09a_cloud.swf")]
        private static var _mountain:Class;
        [Embed(source="../../../../data/image/bg/bg_btl10a_far.swf")]
        private static var _mlCastle:Class;
        [Embed(source="../../../../data/image/bg/bg_btl11a.swf")]
        private static var _moor:Class;
        [Embed(source="../../../../data/image/bg/bg_btl03b.swf")]
        private static var _ubos:Class;
        [Embed(source="../../../../data/image/bg/bg_btl12a.swf")]
        private static var _stone:Class;
        [Embed(source="../../../../data/image/bg/bg_btl50a.swf")]
        private static var _gate:Class;
        [Embed(source="../../../../data/image/bg/bg_btl99a_far.swf")]
        private static var _throne:Class;
        [Embed(source="../../../../data/image/bg/bg_btl99b_far.swf")]
        private static var _throne2:Class;


        // 背景タイプの列挙配列
        //                                    0:城ステージ，1:森ステージ,2:街道, 3:湖畔, 4:墓場,  5:村, 6:荒野, 7:遺跡, 8:街, 9:山,10:
        private static var ClassArray:Array = [_castle, // 0
                                               _forest, // 1
                                               _road,   // 2
                                               _lakeside, // 3
                                               _grave,    // 4
                                               _village,  // 5
                                               _wild,     // 6
                                               _ruin,     // 7
                                               _town,     // 8
                                               _mountain, // 9
                                               _mlCastle, // 10
                                               _moor,     // 11
                                               _ubos,     // 12
                                               _stone,    // 13
                                               _gate,     // 14
                                               _castle,   // 15
                                               _castle   // 16
            ];
        private static var bgExist:Array =    [true,    false,   true,      false,  false,    false, false, false, false, true, true, false, false, false, false, true,true];
        private static var bg2Exist:Array =   [false,   false,   false,     false,  false,    false, false, false, false, true, false, false, false, false, false, false,false];
        private static var yOffset:Array =    [0,       0,   0,     0,  0,    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 263, 263];
        private static var dirSet:Array =     [1,       1,   1,     1,  1,    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, -1, -1];

        private var _bgBitmapData:BitmapData = new BitmapData(760,350, true, 0x00FF0000);

        private var _bgBitmap:Bitmap;

        private var _bg:BG;     // メインのBG
        private var _bg2:SecondBG;
        private var _scrollThread:Thread;
        private var _scrolling:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function FarBG(id:int)
        {
            super(id);
            _bg = new BG(id);
            log.writeLog(log.LV_DEBUG,this,"********* BG ",id, _bg);
            _bg2 = new SecondBG(id);
            log.writeLog(log.LV_DEBUG,this,"********* BG2 ",id, _bg2);
        }

        override protected function get Source():Class
        {
            if (ClassArray[_type] != null)
            {
                return ClassArray[_type];
            }else{
                log.writeLog(log.LV_FATAL, this, "NON EXIST BG NO");
                return ClassArray[0];
            }
        }

        override protected function swfinit(event: Event): void
        {
//            log.writeLog(log.LV_FATAL, this, "BG IS COMMING", _type);
            super.swfinit(event);
            if (bgExist[_type])
            {
                _bgBitmapData.draw(this);
                _bgBitmap = new Bitmap(_bgBitmapData);
                _bgBitmap.y = yOffset[_type];
                _root.visible = false;
                removeChild(_mc);
                addChild(_bg);
                addChildAt(_bgBitmap, 0);
            }
            if (bg2Exist[_type])
            {
                addChildAt(_bg2, 0);
            }
        }

        override public function init():void
        {
            if (bgExist[_type])
            {
                if (_scrolling == false)
                {
                    _scrollThread = new ScrollThread(_bgBitmapData,dirSet[_type]);
                    _scrollThread.start();
                    _scrolling = true;
                }
            }

        }

        override public function final():void
        {
            if (_scrolling == true && _scrollThread != null)
            {
                _scrollThread.interrupt();
                _scrolling = false;
            }
        }



    }
}

import flash.display.*;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;


class ScrollThread extends Thread
{
    private var _source:BitmapData;
    private var _clone:BitmapData;
    private var _counter:int;
    private var _w:int;
    private var _h:int;
    private var _rect:Rectangle;
    private var _pointASet:Vector.<Point>;
    private var _pointBSet:Vector.<Point>
        public function ScrollThread(s:BitmapData,dir:int = 1)
    {
        _source = s;
        _clone = s.clone();
        _w =  s.width;
        _counter = 0;
        _h = s.height;
        _rect = new Rectangle(0,0,_w,_h);
        _pointASet = new Vector.<Point >(_w, true);
        _pointBSet = new Vector.<Point >(_w, true);
        if (dir == 1)
        {
            for(var i:int = 0; i < _w; i++){
                _pointASet[i] = new Point(-(i),0);
                _pointBSet[i] = new Point(_w-(i),0);
            }
        }else{
            for(var j:int = 0; j < _w; j++){
                _pointASet[j] = new Point(j,0);
                _pointBSet[j] = new Point(-(_w-(j)),0);
            }
        }
    }

    protected override function run():void
    {
        next(scrolling);
    }

    private function scrolling():void
    {
        if (_counter >= _w)
        {
            _counter = 0;
        }
        _source.copyPixels(_clone,_rect, _pointASet[_counter]);
        _source.copyPixels(_clone,_rect, _pointBSet[_counter]);
        _counter++;
        next(waitFrame);
    }

    private function waitFrame():void
    {
        if (checkInterrupted())
        {
            return;
        }
        next(scrolling);
    }
}