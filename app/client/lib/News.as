/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
{
    import flash.events.Event;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    /**
     * 設定ファイルの情報を扱うクラス
     * 各サーバーの情報や、ニュースのHTMLを読み込む
     */
    public class News extends XMLData
    {
        private static const _TRANS_NEWS_URL	:String = "/public/news.xml";
        private static const __URL:String = _TRANS_NEWS_URL
        private static const __VERSION:String = "multi_auth_101006"

        /**
         * 現在序の状態(現在の状態（-1:不明,0:メンテ,1:O)
         * @default -1
         */
        private static var __newsText:String = "";
        private static var __announceText:String = "";
        private static var __announceDate:Date;
        private static var __announceDateText:String;

        private static var __maintenanceDate:Date;
        private static var __maintenanceDateText:String;
        private static var __maintenanceDateData:Array; /* of int */

        private static var __version:String;

        private static var __instance:News = new News;
        public static const NEWS_CHANGE:String = 'news_change';
        public static const ANNOUNCE_CHANGE:String = 'announce_change';

        /**
         * コンストラクタ
         *
         */
        public static function init():void
        {
            __instance = new News();
        }

        public static function get instance():News
        {
            return __instance;
        }

        public static function get newsText():String
        {
            return __newsText;
        }

        public static function get announceText():String
        {
            // ローカルのオフセットを引いて表示時間の文字列を作成
            var date:Date = new Date();
            date.setTime(announceDate.getTime() - (announceDate.getTimezoneOffset() * 60 * 1000));
            var str:String;
            __announceText = __announceText.replace("__TIME__",TimeFormat.transDateStr(date));
            return __announceText;
        }

        public static function get announceDate():Date
        {
            var now:Date = new Date();

            if (isMaintenanceDay && (__announceDate.valueOf() < now.valueOf() ||  __announceDate.valueOf() > maintenanceDate.valueOf() ))
            {
                return maintenanceDate;
            }else{
                return __announceDate;
            }
        }

        public static function getText():void
        {
            __instance.update();
        }

        public function News()
        {
            super();
        }

        protected override function get url():String
        {
            return __URL
        }


        // 今日がメンテナンス日か判断する
        private static function get isMaintenanceDay():Boolean
        {
            var now:Date = new Date();
            if (__maintenanceDateData !=null &&
                __maintenanceDateData[0]!=null &&
                now.day == __maintenanceDateData[0] &&
                now.hours <= __maintenanceDateData[1])
            {
                // log.writeLog(log.LV_FATAL, "NEWS ST", true);
                return  true;
            }
            else{
                return false;
            }
        }

        // メンテ時間を返す
        private static function get maintenanceDate():Date
        {
            var now:Date = new Date();
            __maintenanceDate = new Date(now.fullYear, now.month, now.date, __maintenanceDateData[1],__maintenanceDateData[2]);
            __maintenanceDate.setTime(__maintenanceDate.getTime() + (-540 * 60 * 1000));
            return __maintenanceDate;
        }

        // 読み込み完了時に呼び出されるイベント
        protected override function setData (xml:XML):void
        {
            log.writeLog(log.LV_FATAL, this, "???");

            var day:int;

            // 認証サーバの情報を読み込む
            var oldText:String = "";
            log.writeLog(log.LV_FATAL, this, "???");
            oldText = __newsText;
            __newsText = xml.news;
            __announceText = xml.annouce;
            __announceDate= new Date(String(xml.a_date));
            __maintenanceDateData = String(xml.mainte_date).split(":").map(function(item:*, index:int, array:Array):int {return int(item)});

            // UTCでオフセットつけて保存(9時間は固定)
            __announceDate.setTime(__announceDate.getTime() + (-540 * 60 * 1000));

            _loaded =true;

            if ( !(oldText === __newsText))
            {
                log.writeLog(log.LV_FATAL, this,"news change");
                dispatchEvent(new Event(NEWS_CHANGE));
            }
            dispatchEvent(new Event(ANNOUNCE_CHANGE));
        }


        private function alertHandlr(e:Event):void
        {
            update()
        }
    }
}
