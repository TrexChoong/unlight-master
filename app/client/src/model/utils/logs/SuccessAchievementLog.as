package model.utils.logs
{
    import flash.events.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import model.utils.*;
    import model.events.*;
    import model.*;


    /**
     * メッセージのログ情報を扱うクラス
     * チャットやゲームログを保存する
     */
    public class SuccessAchievementLog extends ClientLog
    {
        CONFIG::LOCALE_JP
        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:__NAME__のレコードを達成しました。";

        CONFIG::LOCALE_EN
        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:You completed the [__NAME__] achievement.";

        CONFIG::LOCALE_TCN
        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:您達成了“__NAME__”成就。";

        CONFIG::LOCALE_SCN
        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:您达成了“__NAME__”成就。";

        CONFIG::LOCALE_KR
        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:__NAME__のレコードを達成しました。";

        CONFIG::LOCALE_FR
        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:Vous avez réussi la mission __NAME__.";

        CONFIG::LOCALE_ID
        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:__NAME__のレコードを達成しました。";

        CONFIG::LOCALE_TH
        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:Record __NAME__ สำเร็จแล้ว";


        public function SuccessAchievementLog()
        {
            super();
        }

        public override function get type():int
        {
            return ClientLog.SUCC_ACHIEVEMENT;
        }


        public override function getLog(i:int):String
        {
            if ( _textSet[i] != null)
            {
                return _textSet[i];
            }

            return setText(i);
        }

        private function setText( i:int ):String
        {
            var dateArr:Array = dateSet;
            var nameArr:Array = nameSet;

            var date:Date = dateArr[i];
            var name:String = nameArr[i];
            var ret:String = "";
            if (date != null && name != null)
            {
                ret = _SUCC_ACHIEVEMENT_STR.replace(/__DATA__/, TimeFormat.transDateStr(date)).replace(/__NAME__/, name);
                _textSet.unshift(ret);
            }
            checkMax();
            return ret;
        }

        public override function setLog(a:Object, save:Boolean = false ):String
        {
            var id:int = int(a);

            var name:String = Achievement.ID(id).caption;

            dateSet.unshift(new Date());
            nameSet.unshift(name);
            if (save)
            {
                _sharedObj.flush();
            }

            // テキストを先に作ってしまう
            return setText( 0 );
//            return nameSet.length - 1;
        }


    }


}