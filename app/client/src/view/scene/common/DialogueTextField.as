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
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.MessageLog
    import view.ClousureThread;
    import view.scene.BaseScene;

    /**
     * ダイアログ用TextFieldクラス
     *
     */

    public class DialogueTextField extends TransitionTextField
    {

        private static const _CONTENT_FONT_SIZE:int    = 18;           // 本文のフォントサイズ
        private static const _CONTENT_FONT_COLOR:uint  = 0x000000;     // フォントの色
        private static const _CONTENT_FONT_FACE:String = "minchoB";    // フォント種
        private static const _LEADING:int              = 5;            // 文章の間隔
        private static const _LETTER_SPACE:int         = 2;            // 文字の間隔

        /**
         * コンストラクタ
         *
         */
        public function DialogueTextField()
        {

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

        // 文字トランジションのスレッド。フィールドの文字インデクスを指定。
        public override function getTransitSentenceThread(begin:int, end:int ):Thread
        {
            return new TransitionThread(_maskBitmapData, _textAreaBitmapData, begin,end,this)
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

import view.scene.common.TransitionTextField;

class TransitionThread extends Thread
{
    private var _source:BitmapData;
    private var _mask:BitmapData;
    private var _start:Point;
    private var _begin:uint;
    private var _end:uint;
    private var _count:uint;
    private var _tf:TransitionTextField;
    private var _filter:BitmapFilter;

    public function TransitionThread(m:BitmapData, s:BitmapData, begin:int, end:int, tf:TransitionTextField )
    {
        _mask = m;
        _source = s;
        _begin = begin;
        _count = begin;
        _end = end-1;
        _tf = tf;
//        _filter = new GlowFilter(0x000000);
        _filter = new BlurFilter();
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

//        log.writeLog(log.LV_FATAL, this, "burningr",_count, _end);
        if (_count >= _end)
        {
        var r:Rectangle = _tf.getCharBoundaries(_count);
            log.writeLog(log.LV_FATAL, this, "burningr",r,_count);
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
