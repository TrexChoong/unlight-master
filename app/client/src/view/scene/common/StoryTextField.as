package view.scene.common
{

    import flash.display.*;
    import flash.text.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.filters.*;

    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.core.UIComponent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.tweener.TweenerThread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import com.formatlos.as3.lib.display.BitmapDataUnlimited;
    import com.formatlos.as3.lib.display.events.BitmapDataUnlimitedEvent;

    import model.MessageLog
    import view.ClousureThread;
    import view.scene.BaseScene;


    /**
     * ストーリーTextFieldクラス
     *
     */

    public class StoryTextField extends TransitionTextField
    {
        private static const _CONTENT_FONT_SIZE:int = 20;    // 本文のフォントサイズ
        private static const _CONTENT_FONT_COLOR:uint = 0xFFFFFF;
//        private static const _CONTENT_FONT_FACE:String = "mincho";

        CONFIG::LOCALE_JP
        private static const _CONTENT_FONT_FACE:String = "mincho";
        CONFIG::LOCALE_EN
        private static const _CONTENT_FONT_FACE:String = "mincho";
        CONFIG::LOCALE_TCN
        private static const _CONTENT_FONT_FACE:String = "mincho";
        CONFIG::LOCALE_SCN
        private static const _CONTENT_FONT_FACE:String = "mincho";
        CONFIG::LOCALE_KR
        private static const _CONTENT_FONT_FACE:String = "mincho";
        CONFIG::LOCALE_FR
        private static const _CONTENT_FONT_FACE:String = "mincho";
        CONFIG::LOCALE_ID
        private static const _CONTENT_FONT_FACE:String = "mincho";
        CONFIG::LOCALE_TH
        private static const _CONTENT_FONT_FACE:String = "sans-serif";

        CONFIG::LOCALE_JP
        private static const _LETTER_SPACE:int = 4;           // 文字の間隔
        CONFIG::LOCALE_EN
        private static const _LETTER_SPACE:int = 2;           // 文字の間隔
        CONFIG::LOCALE_TCN
        private static const _LETTER_SPACE:int = 4;           // 文字の間隔
        CONFIG::LOCALE_SCN
        private static const _LETTER_SPACE:int = 4;           // 文字の間隔
        CONFIG::LOCALE_KR
        private static const _LETTER_SPACE:int = 4;           // 文字の間隔
        CONFIG::LOCALE_FR
        private static const _LETTER_SPACE:int = 2;           // 文字の間隔
        CONFIG::LOCALE_ID
        private static const _LETTER_SPACE:int = 2;           // 文字の間隔
        CONFIG::LOCALE_TH
        private static const _LETTER_SPACE:int = 2;           // 文字の間隔

        CONFIG::LOCALE_JP
        private static const _LEADING:int = 4;              // 文章の間隔
        CONFIG::LOCALE_EN
        private static const _LEADING:int = 2;              // 文章の間隔
        CONFIG::LOCALE_TCN
        private static const _LEADING:int = 4;              // 文章の間隔
        CONFIG::LOCALE_SCN
        private static const _LEADING:int = 4;              // 文章の間隔
        CONFIG::LOCALE_KR
        private static const _LEADING:int = 4;              // 文章の間隔
        CONFIG::LOCALE_FR
        private static const _LEADING:int = 2;              // 文章の間隔
        CONFIG::LOCALE_ID
        private static const _LEADING:int = 2;              // 文章の間隔
        CONFIG::LOCALE_TH
        private static const _LEADING:int = 2;              // 文章の間隔

        private var _bitmapReady:int = 0;

        private var _textAreaHugeBitmapData:BitmapDataUnlimited;
        private var _maskHugeBitmapData:BitmapDataUnlimited;

        private var _initFunc:Function;

        private var _titleHtml:String;


        /**
         * コンストラクタ
         *
         */
        public function StoryTextField()
        {

        }

        // HTMLをセット
        public override function set htmlText(t:String):void
        {
            log.writeLog(log.LV_INFO, this, "htmltext",t);
            super.htmlText = t;
//            setAllParagrphs();
            _textAreaHugeBitmapData = new BitmapDataUnlimited();
            _maskHugeBitmapData = new BitmapDataUnlimited();
            _textAreaHugeBitmapData.addEventListener(BitmapDataUnlimitedEvent.COMPLETE, onBmpReady);
            _maskHugeBitmapData.addEventListener(BitmapDataUnlimitedEvent.COMPLETE, onBmpReady);
            _textAreaHugeBitmapData.create(width, textHeight,true,0x00000000);
            _maskHugeBitmapData.create(width, textHeight,true,0x00000000);
        }


        // デフォルトの書式をセット
        protected override function defaultFormatSet():void
        {
            _defaultTextFormat.leading = _LEADING;
            _defaultTextFormat.letterSpacing = _LETTER_SPACE;
            _defaultTextFormat.color = _CONTENT_FONT_COLOR;
            _defaultTextFormat.size = _CONTENT_FONT_SIZE;
            _defaultTextFormat.font = _CONTENT_FONT_FACE;
            super.defaultFormatSet();
        }
        public function setInitFunc(i:Function):void
        {
            _initFunc = i;
        }

        // HugeBitmapDataが用意できた時のイベントハンドラ
        private function onBmpReady(e:Event):void
        {
            if (_bitmapReady == 1)
           {
                createBitmap();
                if (_initFunc != null){_initFunc()}
            }else{
                _bitmapReady+=1;
            }
        }

        // ビットマップを作成
        protected override function setBitmap():void
        {
        }

        // ビットマップを作成
        protected function createBitmap():void
        {
            log.writeLog(log.LV_FATAL, this, "setBitmap",width, textHeight,true,0x00000000);
//             _textAreaBitmapData = new BitmapData(width, textHeight,true,0x00000000);
// //            _textAreaBitmapData = new BitmapData(width, textHeight,true,0xFFFF0000);
//             _maskBitmapData = new BitmapData(width, textHeight,true, 0x00000000);
            _textAreaBitmapData = _textAreaHugeBitmapData.bitmapData;
            _maskBitmapData = _maskHugeBitmapData.bitmapData;
            log.writeLog(log.LV_FATAL, this, _textAreaBitmapData,_maskBitmapData);
            log.writeLog(log.LV_FATAL, this, _textAreaHugeBitmapData, _maskHugeBitmapData);

            log.writeLog(log.LV_FATAL, this, "setBitmap end?");
            _textAreaHugeBitmapData.draw(this);
            _maskBitmap = new Bitmap(_maskBitmapData);
            _textAreaBitmap = new Bitmap(_textAreaBitmapData);
            _maskBitmap.scrollRect = new Rectangle(0,0,width,_visibleHeight)
            log.writeLog(log.LV_FATAL, this, "setBitmap end");
        }

        // 文字トランジションのスレッド。フィールドの文字インデクスを指定。
        public override function getTransitSentenceThread(begin:int, end:int ):Thread
        {
            log.writeLog(log.LV_FATAL, this, "begin end", begin,end);
            _currentPotision = end+getLineLength(0);
            return new TransitionThread(_maskBitmapData,_textAreaBitmapData,begin+getLineLength(0),end+getLineLength(0),this)
        }

        // 文字ポジションからの現在位置を返す
        public function getReadEndPosition():Point
        {
            var r:Rectangle = getCharBoundaries(_currentPotision-1);
            if (r==null){r = getCharBoundaries(_currentPotision-2)}
            var a:Number = getLineMetrics(getLineIndexOfChar(_currentPotision-1)).ascent;
            log.writeLog(log.LV_FATAL, this, "",r,_maskBitmap.scrollRect.y);
            return new Point(r.x,r.y-_maskBitmap.scrollRect.y+a);
        }

        // 特定行までスクロールするスレッド
         public function getScrollLineThread(line:int):Thread
         {
             // 移動量
             var lineNum:int = Math.abs(_infoLines[line][0] - _maskBitmap.scrollRect.y);
             log.writeLog(log.LV_FATAL, this, "Scrolling to ",line,lineNum,_infoLines[line][0]);
             return new TweenerThread(_maskBitmap, {_scrollRect_y: _infoLines[line][0], transition:"easeOutCirc", time:0.0005*lineNum+0.0002})
         }

        // 自動スクロールするスレッド
         public function getAutoScrollThread():Thread
         {

             var visibleEndLine:int = _visibleHeight+_maskBitmap.scrollRect.y;
             log.writeLog(log.LV_FATAL, this, "getAutoScrollThread visibleEndline",_maskBitmap.scrollRect.y);
             var nextLine:int = getLineIndexOfChar(_currentPotision);
             log.writeLog(log.LV_FATAL, this, "getAutoScrollThread nextLine",_maskBitmap.scrollRect.y);
             var currentPara:int = _infoLines[nextLine][1];
             log.writeLog(log.LV_FATAL, this, "getAutoScrollThread currentpara",_infoLines);

              if (_infoParagraphs[_infoLines[nextLine][1]][3] > _currentPage)
              {
                  _currentPage+=1;
                  return getScrollLineThread(_infoParagraphs[_infoLines[nextLine][1]][1]);
              }else{
                  return new Thread();
              }

         }

        // エンドマークを移動する
        public function getSetEndMarkThread(d:DisplayObject,offsetX:int,offsetY:int):Thread
         {
             return new SetReadMarkThread(d, offsetX, offsetY,this);
         }

        public function setPage(no:int):void
        {
        }


    }
}

import flash.display.*;
import flash.geom.*;
import flash.text.*;
import flash.filters.*;
import flash.geom.*;
import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.scene.common.StoryTextField;

class TransitionThread extends Thread
{
    private var _source:BitmapData;
    private var _mask:BitmapData;
    private var _start:Point;
    private var _begin:uint;
    private var _end:uint;
    private var _count:uint;
    private var _tf:StoryTextField;
    private var _filter:GlowFilter;

    public function TransitionThread(m:BitmapData, s:BitmapData, begin:int, end:int, tf:StoryTextField )
    {
        _mask = m;
        _source = s;
        _begin = begin;
        _count = begin;
        _end = end-1;
        _tf = tf;
        CONFIG::LOCALE_JP
        {
            _filter = new GlowFilter(0xFFFFAA);
        }
        CONFIG::LOCALE_EN
        {
        _filter = new GlowFilter(0xFFFFAA,3.2,3.2,3.2,1.8);
        }
        CONFIG::LOCALE_TCN
        {
        _filter = new GlowFilter(0xFFFFAA,3.2,3.2,3.2,1.8);
        }
        CONFIG::LOCALE_SCN
        {
        _filter = new GlowFilter(0xFFFFAA,3.2,3.2,3.2,1.8);
        }
        CONFIG::LOCALE_KR
        {
        _filter = new GlowFilter(0xFFFFAA);
        }
        CONFIG::LOCALE_FR
        {
        _filter = new GlowFilter(0xFFFFAA,3.2,3.2,3.2,1.8);
        }
        CONFIG::LOCALE_ID
        {
        _filter = new GlowFilter(0xFFFFAA,3.2,3.2,3.2,1.8);
        }
        CONFIG::LOCALE_TH
        {
        _filter = new GlowFilter(0xFFFFAA,3.2,3.2,3.2,1.8);
        }
    }
    protected override function run():void
    {
        next(burning);
    }


    private function burning():void
    {
        var st:int;
        var fn:int;
        var r1:Rectangle;
        var r2:Rectangle;
        var r3:Rectangle;

      // 割り込まれていた場合残りの行をすべて一気にペーストする
        if (checkInterrupted())
        {
            var beginLine:int = _tf.getLineIndexOfChar(_begin);
            var endLine:int = _tf.getLineIndexOfChar(_end);
            var beginRect:Rectangle;
            var endRect:Rectangle;
            beginRect = _tf.getCharBoundaries(_begin);
            if (beginRect==null){beginRect = _tf.getCharBoundaries(_begin+1)}
            endRect = _tf.getCharBoundaries(_end);;
            if (endRect==null){endRect = _tf.getCharBoundaries(_end-1)}

            log.writeLog(log.LV_FATAL, this, "interrupt", beginLine, endLine);
            // 1行のみなら。
            if (beginLine == endLine)
            {
                r1 = beginRect.clone();
                r2 = endRect.clone();
                r3 = r1.union(r2);
                log.writeLog(log.LV_FATAL, this, "end", r3);
                _mask.copyPixels(_source, r3, r3.topLeft);
            }else{
                // 2行以上なら
                for(var i:int = beginLine; i <= endLine; i++)
                {
                    switch (i)
                    {
                    case beginLine:  // 最初の行
                        r1 =  new Rectangle(0,beginRect.y,_tf.getLineMetrics(i).width,_tf.getLineMetrics(i).height);
                        log.writeLog(log.LV_FATAL, this, "begin",r1);
                        _mask.copyPixels(_source, r1, r1.topLeft);
                        break;
                    case endLine:   // 最後の行
                        r1 =  new Rectangle(0,endRect.y,1,1);
                        r2 = endRect.clone();
                        r3 = r1.union(r2);
                        log.writeLog(log.LV_FATAL, this, "end", r3);
                        _mask.copyPixels(_source, r3, r3.topLeft);
                        break;
                    default:        // 中間行
                        r1 =  new Rectangle(0,_tf.getCharBoundaries(_tf.getLineOffset(i)).y,_tf.getLineMetrics(i).width,_tf.getLineMetrics(i).height);
                        log.writeLog(log.LV_FATAL, this, "other", r1);
                        _mask.copyPixels(_source, r1, r1.topLeft);
                    }
                }
            }
            return;
        }

//        log.writeLog(log.LV_FATAL, this, "burningr",_count, _end);
        // カウントが最後までいくまで
        if (_count >= _end)
        {
        var r:Rectangle = _tf.getCharBoundaries(_count);
//            log.writeLog(log.LV_FATAL, this, "burningr",r,_count);
            if (r!=null)
            {
                _mask.copyPixels(_source, r, r.topLeft);
            }
            next(fin);
        }else{
            _count +=1;
            r1 = _tf.getCharBoundaries(_count);

            if (r1!=null)
            {
                r1 = r1.clone();
                //              log.writeLog(log.LV_FATAL, this, "burningr",r1, _count);
                r1.width-=5;
//                _mask.applyFilter(_source,r1, r1.topLeft, new GlowFilter(0xFFFFAA));
                _mask.applyFilter(_source,r1, r1.topLeft, _filter);
            }

            r2 = _tf.getCharBoundaries(_count-1);
//            log.writeLog(log.LV_FATAL, this, "burningr",r2, _count);

            if (r2!=null)
            {
                _mask.copyPixels(_source, r2, r2.topLeft);
            }
            next(burning);
        }

    }

    private function fin():void
    {

    }



}


class SetReadMarkThread extends Thread
{
    private var _d:DisplayObject;
    private var _offsetX:int;
    private var _offsetY:int;
    private var _tf:StoryTextField;

    public function SetReadMarkThread(d:DisplayObject, offsetX:int, offsetY:int, tf:StoryTextField)
    {
        _d = d;
        _offsetX = offsetX;
        _offsetY = offsetY;
        _tf = tf;
    }

    protected override function run():void
    {
        var p:Point = _tf.getReadEndPosition();
        _d.x = p.x+_offsetX;
        _d.y = p.y+_offsetY;
    }



}
