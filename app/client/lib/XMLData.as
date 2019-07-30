/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
{
    import flash.events.Event;
    import flash.utils.Timer;
    import flash.events.*;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import model.BaseModel;
    /**
     * 設定ファイルの情報を扱うクラス
     * 各サーバーの情報や、ニュースのHTMLを読み込む
     */
    public class XMLData extends BaseModel
    {

        /**
         * 設定を読み終わった時のイベント
         *
         */
        public static const COMPLETE:String = 'complete';// 設定を読み終わって準備ＯＫのイベント
        /**
         * 設定更新時のイベント
         *
         */
        public static const UPDATE:String = 'update';    // 設定更新のイベント

        /**
         * 設定のバージョン
         * @default 0
         *
         */
        private static  const __URL : String = "";        //  ファイルの置き場所

        protected var _xml:XML;                           // 読み込んだxmlファイル
        private var _reloadTimer:Timer;                   // 情報更新用タイマ
        private var _url_loader : URLLoader;              // URLローダ

        /**
         * コンストラクタ
         *
         *
         */
        public function XMLData()
        {
            update();
        }
        protected function get url():String
        {
            return __URL;
        }


        // XMLの更新チェック
        protected function update():void
        {
            log.writeLog(log.LV_FATAL, this, "URL is ",url);
            var req:URLRequest = new URLRequest(url + "?" + Math.floor(Math.random() * 100));
            _url_loader = new URLLoader(req); // URLローダ
            _url_loader.addEventListener (Event.COMPLETE,loaderInfoCompleteHandler);
            _url_loader.addEventListener(IOErrorEvent.IO_ERROR, errorCatch);
            _url_loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
            dispatchEvent(new Event(Event.CHANGE));
        }

        private function onProgress(event:ProgressEvent):void
        {
            log.writeLog(log.LV_FATAL, this,event.bytesLoaded + " : " + event.bytesTotal);
        }

        private function errorCatch(e:IOErrorEvent):void
        {
            log.writeLog(log.LV_FATAL, this,"Oh noes! Yous gots no internets!");
        }

        // 読み込み完了時に呼び出されるイベント
        private function loaderInfoCompleteHandler (event:Event):void
        {
            setData(new XML(_url_loader.data));
            if (loaded)
            {
                log.writeLog (log.LV_DEBUG,"XmlData", " update... ");
                dispatchEvent(new Event(UPDATE)); // 設定が更新されていたらイベント創出
            }
            else
            {
                log.writeLog (log.LV_DEBUG,"XmlData", "get data.");
                _loaded = true;
                dispatchEvent(new Event(COMPLETE)); // 設定が読み込まれたらイベント創出
                notifyAll();
            }

        }

        // オーバライド前提のデータ読み込み部分
        protected function setData(xml:XML):void
        {


        }


        // 再読み込みタイマーをスタート
        protected function startTimer(i:int):void
        {
            _reloadTimer = new Timer(i,0);
            _reloadTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            _reloadTimer.start();
            log.writeLog (log.LV_DEBUG,"Config"," timer start. ");
        }

        // 再読み込みタイマーをストップ
        private function stoptTimer(i:int):void
        {
            _reloadTimer.removeEventListener(TimerEvent.TIMER, timerHandler);
            _reloadTimer.stop();
        }
        // 再読込タイマーハンドラ
        private function timerHandler(e:Event):void
        {
            update();
        }
    }
}
