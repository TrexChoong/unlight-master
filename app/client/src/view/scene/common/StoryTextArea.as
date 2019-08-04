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

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;


    import model.MessageLog
    import view.scene.BaseScene;
    import view.ClousureThread;

    /**
     * ストーリー表示sceneクラス
     *
     */

    public class StoryTextArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_FONT	:String = "minchoB"

        CONFIG::LOCALE_EN
        private static const _TRANS_FONT	:String = "minchoB"

        CONFIG::LOCALE_TCN
        private static const _TRANS_FONT	:String = "minchoB"

        CONFIG::LOCALE_SCN
        private static const _TRANS_FONT	:String = "minchoB"

        CONFIG::LOCALE_FR
        private static const _TRANS_FONT	:String = "minchoB"

        CONFIG::LOCALE_ID
        private static const _TRANS_FONT	:String = "minchoB"

        CONFIG::LOCALE_TH
        private static const _TRANS_FONT	:String = "sans-serif"


        private static const _CONTENT_AREA_X:int = 38;
        private static const _CONTENT_AREA_Y:int = 113;

        private static const _CONTENT_AREA_WIDTH:int = 695;
        private static const _CONTENT_AREA_HEIGHT:int = 475;

        private var _title:String;
        private var _content:String;
        private var _textArea:StoryTextField = new StoryTextField();
        private var _sentences:Array;               /* of String */
        private var _paragraphs:Array        = [];  /* of [Num of Sentence, WhiteSpace] */
        private var _rubies:Array            = [];  /* of String*/
        private var _contextLineHeight:Array = [];  /* of Number*/

        private var _trasiting:Boolean = false;
        private var _transition:Thread;

        private var _updateHandler:Function;

        private var _currentPotision:int = 0;
        private var _currentSentence:int = 0;
        private var _currentParagraph:int = 0;
        private var _currentPage:int = 0;
        private var _currentScroll:int = 0;

        private var _readMark:DisplayObject;

        /**
         * コンストラクタ
         *
         */
        public function StoryTextArea()
        {
            x = _CONTENT_AREA_X;
            y = _CONTENT_AREA_Y;
            width = _CONTENT_AREA_WIDTH;
            height =_CONTENT_AREA_HEIGHT;

            _textArea.width = _CONTENT_AREA_WIDTH;
            _textArea.height = _CONTENT_AREA_HEIGHT;
            _updateHandler = update;
            _textArea.setInitFunc(initTextField);
        }


        public  function setData(title:String,content:String):void
        {
            _title = "<p align=\"center\"> <font face = \"minchoB\" size = \"25\" color = \"#FFFFFF\" >"+title+"</font></p>";
//            _title = "<p align=\"center\"> <font face = \_TRANS_FONT size = \"32\" color = \"#FFFFFF\" >"+title+"</font></p>";
            convertHtml(content);
            start();
        }

        private function convertHtml(s:String):void
        {
            _content = s;
            var sent:String;
            // 文を作る
            // htmlタグを取り除く
            // 文ごとにマークをいれる。
            sent = s.replace(/<p>|<br>|<\/p>/g,"");
            sent= sent.replace(/(。)([^　])/g,"$1xxxxx$2");
            sent= sent.replace(/(』)([^」])/g,"$1xxxxx$2");
            sent= sent.replace(/(？)([^」])/g,"$1xxxxx$2");
            sent= sent.replace(/(！)([^」])/g,"$1xxxxx$2");
            sent= sent.replace(/(）)([^」])/g,"$1xxxxx$2");
            sent= sent.replace(/(」)/g,"$1xxxxx");
	        CONFIG::LOCALE_EN
        {
            sent= sent.replace(/(\.)([^ ])/g,"$1xxxxx$2");
            sent= sent.replace(/(»)/g,"$1xxxxx");
        }
        CONFIG::LOCALE_FR
        {
            sent= sent.replace(/(\.)([^ ])/g,"$1xxxxx$2");
            sent= sent.replace(/(»)/g,"$1xxxxx");
        }
        CONFIG::LOCALE_SCN
        {
            sent= sent.replace(/(。)([^ ])/g,"$1xxxxx$2");
            sent= sent.replace(/(”)/g,"$1xxxxx");
        }
        CONFIG::LOCALE_ID
        {
            sent= sent.replace(/(\.)([^ ])/g,"$1xxxxx$2");
            sent= sent.replace(/(»)/g,"$1xxxxx");
        }
        CONFIG::LOCALE_TH
        {
            sent= sent.replace(/(\t)([^ ])/g,"$1xxxxx$2");
            sent= sent.replace(/(»)/g,"$1xxxxx");
        }
            // 文ごとに分ける
            _sentences = sent.split(/xxxxx/);
            // log.writeLog(log.LV_INFO, this, "sentence", _sentences);
            //ページを作る
            _content = s;
            // log.writeLog(log.LV_INFO, this, "content", _content);
        }

    public function initTextField():void
    {
//        log.writeLog(log.LV_INFO, this, "init!!!");
        _textArea.showLine(0);
        addChild(_textArea.transionBitmap);
    }

    public function start():void
        {
//            _textArea.title = _title;
            _textArea.htmlText = _title+_content;
        }

    public function clickHandler(e:MouseEvent):void
    {
        log.writeLog(log.LV_INFO, this, "click");
        _updateHandler();
    }

    public function setReadMarkImage(image:DisplayObject):void
    {
        _readMark = image;
    }

    // マークを消す
    private function readMarkOff():void
    {
        if (_readMark != null)
        {
            _readMark.visible = false;
        }
    }
    // ハンドラを復活させる
    private function handlerOn():void
    {
        _updateHandler = update;
    }

    private function noUpdate():void
    {
        if (_trasiting)
        {
            _transition.interrupt();
        }

    }
    // 画面を進める
    public function update():void
    {
        _updateHandler = noUpdate;
        _trasiting = true;
        var sExec:SerialExecutor = new SerialExecutor();
        // 行送り
//        log.writeLog(log.LV_INFO, this, "sentence", _sentences[_currentSentence]);
        _sentences[_currentSentence] = _sentences[_currentSentence].replace(/\r\n/gm, "\n").replace(/\r/gm, "\n").replace(/^\r/gm,"")
        var begin:int = _currentPotision;
        var end:int = _currentPotision+_sentences[_currentSentence].length;
        log.writeLog(log.LV_INFO, this, "current sentence len",_sentences[_currentSentence],_sentences[_currentSentence].length);
        _transition = _textArea.getTransitSentenceThread(begin, end);
        _currentPotision+=_sentences[_currentSentence].length;
        _currentSentence +=1;
        readMarkOff();
//            readMarkPositionUpdate(_textArea.stringIndexPosition(end));
//            sExec.addThread(new ClousureThread(readMarkOff));
        sExec.addThread(_textArea.getAutoScrollThread());            // ページ送り
        sExec.addThread(_transition);
        sExec.addThread(_textArea.getSetEndMarkThread(_readMark,x,y));
        sExec.addThread(new ClousureThread(transitFinish));
        sExec.start();
    }

    public function get transiting():Boolean
    {
        return _trasiting;
    }
    public function transitFinish():void
    {
        _readMark.visible =true;
        _trasiting = false;
        _updateHandler = update;
    }


    }

}
