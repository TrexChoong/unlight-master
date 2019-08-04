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
     * トランジション用TextFieldクラス
     *
     */

    public class TransitionTextField extends TextField
    {

        protected var _defaultTextFormat:TextFormat = new TextFormat();

        // パラグラフ情報
        protected var _infoParagraphs:Array = []; /* of [charIndex, lineNo, num, pageNo] */

        // ページ情報
        protected var _infoPages:Array = [];      /* of [charIndex, endIndex, startParagraph] */

        // 行の情報
        protected var _infoLines:Array        = []; /* of [y, paragraphNo] */

        private var _maxPage:int = 0;

        // テクストエリアのビットマップデータ
        protected var _textAreaBitmapData:BitmapData;
        protected var _maskBitmapData:BitmapData;
        protected var _textAreaBitmap:Bitmap;
        protected var _maskBitmap:Bitmap;

        // 見える範囲の高さ
        protected var _visibleHeight:int   = 0;

        // 現在の位置
        protected var _currentPotision:int = 0;
        protected var _currentPage:int     = 1;



        /**
         * コンストラクタ
         *
         */
        public function TransitionTextField()
        {
            // Tweenerの初期化（念のため）
            defaultFormatSet();
        }

        // デフォルトの書式をセット
        protected function defaultFormatSet():void
        {
            autoSize = "right";
            condenseWhite = true;
            embedFonts = true;
            multiline = true;
            wordWrap = true;
            defaultTextFormat = _defaultTextFormat;
        }


        // HTMLをセット
        public override function set htmlText(t:String):void
        {
            super.htmlText =t;
            setAllParagrphs();
            setBitmap();
        }

        // heightをセット
        public override function set height(i:Number):void
        {
            _visibleHeight = i;
            super.height = i;
        }

        // 特定行を表示する。
        public function showLine(line:int):void
        {
             var r1:Rectangle;
             r1 =  new Rectangle(0, _infoLines[line][0], width, getLineMetrics(line).height);
             _maskBitmapData.copyPixels(_textAreaBitmapData, r1, r1.topLeft);
        }


        // パラグラフの情報をまとめて設定
        protected function setAllParagrphs():void
        {
            // 行数
            var n:int = numLines;
            // パラグラフの最初の文字位置
            var firstChar:int = -1;
            // 前のパラグラフの文字位置
            var beforeFirstChar:int = -1;
            // 今の行のY位置
            var lineY:Number = 0;
            // 現在のページ
            var currentPage:int = 1;
            // 現在のパラグラフ
            var currentPara:int = -1;
            // 見えている高さ
            var nextEndline:int = _visibleHeight;
            for(var i:int = 0; i < n; i++)
            {
                // すべての行の段落の最初の文字インデクスをとる
                firstChar = getFirstCharInParagraph(getLineOffset(i));
                // すべての行の左上を保存
                _infoLines.push([lineY,0]);
                // もしその文字インデクスが初出ならば段落情報を作る
                if (firstChar != beforeFirstChar)
                {
                    // その文字インデクスの段落位置がページをまたぐようだったらページをインクリメントする
                    if(lineY >= nextEndline){
                        currentPage+=1;
                        // 前のパラグラフを次ページにずらす。
                        _infoParagraphs[currentPara][3] = currentPage;
                        // 前のパラグラフの先頭行がページ先頭したときのページ範囲を計算する
                        nextEndline = _infoLines[_infoParagraphs[currentPara][1]][0]+_visibleHeight;
                    }
                    // パラグラフ情報を作る。
                    _infoParagraphs.push([firstChar,i,getParagraphLength(firstChar)-1,currentPage]);
                    currentPara+=1;
                }
                // 今の高さを足して次の行の左上の高さをずらす
                lineY+= getLineMetrics(i).height;
                _infoLines[i][1] = currentPara;
                beforeFirstChar = firstChar;
            }
            _maxPage = currentPage;
            log.writeLog(log.LV_FATAL, this, "set all Paragraphs ", _infoParagraphs," lineInfo",_infoLines);
        }


        // ビットマップを作成
        protected function setBitmap():void
        {
//            _textAreaBitmapData = new BitmapData(width, textHeight,true,0xFFFF0000);
            _textAreaBitmapData = new BitmapData(width, textHeight,true,0x00000000);

        CONFIG::LOCALE_TCN
        {
            _textAreaBitmapData = new BitmapData(width, textHeight+10,true,0x00000000);
        }
        CONFIG::LOCALE_SCN
        {
            _textAreaBitmapData = new BitmapData(width, textHeight+10,true,0x00000000);
        }
        _textAreaBitmapData.draw(this);

          _maskBitmapData = new BitmapData(width, _visibleHeight*2,true, 0x0000000);
          _maskBitmap = new Bitmap(_maskBitmapData);
          _textAreaBitmap = new Bitmap(_textAreaBitmapData);
          _maskBitmap.scrollRect = new Rectangle(0,0,width,_visibleHeight);
          _maskBitmap.x = x;
          _maskBitmap.y = y;

        }


        // 自動トランジション。
        public function getAutoTransitSentenceThread():Thread
        {
            log.writeLog(log.LV_FATAL, this, "html Text", htmlText,"length",_infoParagraphs[0][2]);

            return getTransitSentenceThread(0, _infoParagraphs[0][2]+1);
        }

        // 文字トランジションのスレッド。フィールドの文字インデクスを指定。
        public function getTransitSentenceThread(begin:int, end:int ):Thread
        {
            return new TransitionThread(_maskBitmapData,_textAreaBitmapData,begin,end,this)
        }

        // 表示ビットマップを渡す
        public function get transionBitmap():Bitmap
        {
            return _maskBitmap;
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
        _filter = new GlowFilter(0x000000,1,1,1,0.2);
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
