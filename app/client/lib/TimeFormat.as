/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
{
    import flash.display.*;

    public class TimeFormat extends Object
    {
        // 翻訳データ

    CONFIG::LOCALE_JP
    private static const _TRANS_DAY:String = "日";
    CONFIG::LOCALE_JP
        private static const _TRANS_HOUR:String = "時間";
    CONFIG::LOCALE_JP
        private static const _TRANS_MIN :String = "分";

    CONFIG::LOCALE_EN
        private static const _TRANS_DAY:String = "D";
    CONFIG::LOCALE_EN
        private static const _TRANS_HOUR:String = "H";
    CONFIG::LOCALE_EN
        private static const _TRANS_MIN :String = "m";

    CONFIG::LOCALE_TCN
        private static const _TRANS_DAY:String = "D";
    CONFIG::LOCALE_TCN
        private static const _TRANS_HOUR:String = "H";
    CONFIG::LOCALE_TCN
        private static const _TRANS_MIN :String = "m";

    CONFIG::LOCALE_SCN
        private static const _TRANS_DAY:String = "D";
    CONFIG::LOCALE_SCN
        private static const _TRANS_HOUR:String = "H";
    CONFIG::LOCALE_SCN
        private static const _TRANS_MIN :String = "m";

    CONFIG::LOCALE_KR
        private static const _TRANS_DAY:String = "D";
    CONFIG::LOCALE_KR
        private static const _TRANS_HOUR:String = "H";
    CONFIG::LOCALE_KR
        private static const _TRANS_MIN :String = "m";

    CONFIG::LOCALE_FR
        private static const _TRANS_DAY:String = "D";
    CONFIG::LOCALE_FR
        private static const _TRANS_HOUR:String = "H";
    CONFIG::LOCALE_FR
        private static const _TRANS_MIN :String = "m";

    CONFIG::LOCALE_ID
    private static const _TRANS_DAY:String = "日";
    CONFIG::LOCALE_ID
        private static const _TRANS_HOUR:String = "時間";
    CONFIG::LOCALE_ID
        private static const _TRANS_MIN :String = "分";

    CONFIG::LOCALE_TH
        private static const _TRANS_DAY:String = "D";
    CONFIG::LOCALE_TH
        private static const _TRANS_HOUR:String = "H";
    CONFIG::LOCALE_TH
        private static const _TRANS_MIN :String = "m";


        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_DAYS:Array = ["（日）","（月）","（火）","（水）","（木）","（金）","（土）"]; /* of String */

        CONFIG::LOCALE_EN
        private static const _TRANS_DAYS:Array = ["(Sun)","(Mon)","(Tue)","(Wed)","(Thu)","(Fri)","(Sat)"]; /* of String */

        CONFIG::LOCALE_TCN
        private static const _TRANS_DAYS:Array = ["(日)","(一)","(二)","(三)","(四)","(五)","(六)"]; /* of String */

        CONFIG::LOCALE_SCN
        private static const _TRANS_DAYS:Array = ["(日)","(一)","(二)","(三)","(四)","(五)","(六)"]; /* of String */

        CONFIG::LOCALE_KR
        private static const _TRANS_DAYS:Array = ["(일)","(월)","(화)","(수)","(목)","(금)","(토)"]; /* of String */

        CONFIG::LOCALE_FR
        private static const _TRANS_DAYS:Array = ["（Dimanche）","（Lundi）","（Mardi）","（Mercredi）","（Jeudi）","（Vendredi）","（Samedi）"]; /* of String */

        CONFIG::LOCALE_ID
        private static const _TRANS_DAYS:Array = ["（Dimanche）","（Lundi）","（Mardi）","（Mercredi）","（Jeudi）","（Vendredi）","（Samedi）"]; /* of String */

        CONFIG::LOCALE_TH
        private static const _TRANS_DAYS:Array = ["(วันอาทิตย์)","(วันจันทร์)","(วันอังคาร)","(วันพุธ)","(วันพฤหัส)","(วันศุกร์)","(วันเสาร์)"]; /* of String */



        public static function toString(nowTime:Number):String
        {
            var _sec:int;
            var _min:int;
            var _hour:int;
            var _day:int;
            var ret:Array = []
            _day = int(nowTime/(24*60*60*1000));
            if (nowTime>24*60*60*1000)
            {
                ret.push(_day.toString());
            }

            _hour =int(nowTime/(60*60*1000))%24;
            if (nowTime>60*60*1000)
            {
                ret.push(("0"+_hour.toString()).substr(-2,2))
            }

            _min = int(nowTime/(60*1000))%60;
            ret.push(("0"+_min.toString()).substr(-2,2));

            _sec = int(nowTime/(1000))%60;
            ret.push(("0"+_sec.toString()).substr(-2,2));

            if (_day > 0)
            {
                return ret[0].toString() + "d"+ ret[1].toString()+"h"+ret[2].toString()+"m"
            }else{
                return ret.join(":");
            }
        }


        public static function toDateString(nowTime:Number):String
        {
            var _sec:int;
            var _min:int;
            var _hour:int;
            var _day:int;
            var ret:Array = []
            _day = int(nowTime/(24*60));
            if (nowTime>=24*60)
            {
                ret.push(_day.toString());
                ret.push(_TRANS_DAY)
            }

            _hour =int(nowTime/(60))%24;
            if (nowTime>=60&&_hour!=0)
            {
                ret.push(_hour.toString());
                ret.push(_TRANS_HOUR);
            }

            if(ret.length < 2)
            {
                _min = int(nowTime)%60;
                ret.push(_min.toString());
                ret.push(_TRANS_MIN);
            }
            return ret.join(" ");
        }

        CONFIG::LOCALE_JP
        public static function transDateStr(date:Date):String
        {
            var ret:String;
            var min:int = date.minutes;
            var minStr:String;
            if (min<10)
            {
                minStr = "0" + min.toString();
            }else{
                minStr = min.toString();
            }

            ret = (date.month+1).toString()+"/"+date.date.toString()+_TRANS_DAYS[date.day]+" "+date.hours.toString()+":"+minStr;
            return ret;
        }


        CONFIG::LOCALE_TCN
        public static function transDateStr(date:Date):String
        {
            var ret:String;
            var min:int = date.minutes;
            var minStr:String;
            if (min<10)
            {
                minStr = "0" + min.toString();
            }else{
                minStr = min.toString();
            }

            ret = (date.month+1).toString()+"/"+date.date.toString()+_TRANS_DAYS[date.day]+" "+date.hours.toString()+":"+minStr;
            return ret;
        }

        CONFIG::LOCALE_SCN
        public static function transDateStr(date:Date):String
        {
            var ret:String;
            var min:int = date.minutes;
            var minStr:String;
            if (min<10)
            {
                minStr = "0" + min.toString();
            }else{
                minStr = min.toString();
            }

            ret = (date.month+1).toString()+"/"+date.date.toString()+_TRANS_DAYS[date.day]+" "+date.hours.toString()+":"+minStr;
            return ret;
        }

        CONFIG::LOCALE_KR
        public static function transDateStr(date:Date):String
        {
            var ret:String;
            var min:int = date.minutes;
            var minStr:String;
            if (min<10)
            {
                minStr = "0" + min.toString();
            }else{
                minStr = min.toString();
            }

            ret = (date.month+1).toString()+"/"+date.date.toString()+_TRANS_DAYS[date.day]+" "+date.hours.toString()+":"+minStr;
            return ret;
        }

        CONFIG::LOCALE_EN
        public static function transDateStr(date:Date):String
        {
            var ret:String;
            var min:int = date.minutes;
            var minStr:String;
            if (min<10)
            {
                minStr = "0" + min.toString();
            }else{
                minStr = min.toString();
            }

            ret = date.date.toString()+"/"+(date.month+1).toString()+_TRANS_DAYS[date.day]+" "+date.hours.toString()+":"+minStr;
            return ret;
        }

        CONFIG::LOCALE_FR
        public static function transDateStr(date:Date):String
        {
            var ret:String;
            var min:int = date.minutes;
            var minStr:String;
            if (min<10)
            {
                minStr = "0" + min.toString();
            }else{
                minStr = min.toString();
            }

            ret = date.date.toString()+"/"+(date.month+1).toString()+_TRANS_DAYS[date.day]+" "+date.hours.toString()+":"+minStr;
            return ret;
        }

        CONFIG::LOCALE_ID
        public static function transDateStr(date:Date):String
        {
            var ret:String;
            var min:int = date.minutes;
            var minStr:String;
            if (min<10)
            {
                minStr = "0" + min.toString();
            }else{
                minStr = min.toString();
            }

            ret = (date.month+1).toString()+"/"+date.date.toString()+_TRANS_DAYS[date.day]+" "+date.hours.toString()+":"+minStr;
            return ret;
        }

        CONFIG::LOCALE_TH
        public static function transDateStr(date:Date):String
        {
            var ret:String;
            var min:int = date.minutes;
            var minStr:String;
            if (min<10)
            {
                minStr = "0" + min.toString();
            }else{
                minStr = min.toString();
            }

            ret = (date.month+1).toString()+"/"+date.date.toString()+_TRANS_DAYS[date.day]+" "+date.hours.toString()+":"+minStr;
            return ret;
        }



    }

}
