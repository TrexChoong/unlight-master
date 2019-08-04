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
    public class SuccessInviteLog extends ClientLog
    {
        CONFIG::LOCALE_JP
        private static const  _SUCC_INVITE_STR:String      = "__DATA__:__NAME__の招待に成功しました。";

        CONFIG::LOCALE_EN
        private static const  _SUCC_INVITE_STR:String      = "__DATA__:You successfully invited __NAME__.";

        CONFIG::LOCALE_TCN
        private static const  _SUCC_INVITE_STR:String      = "__DATA__:您成功邀請了__NAME__。";

        CONFIG::LOCALE_SCN
        private static const  _SUCC_INVITE_STR:String      = "__DATA__:__NAME__邀请成功。";

        CONFIG::LOCALE_KR
        private static const  _SUCC_INVITE_STR:String      = "__DATA__:__NAME__の招待に成功しました。";

        CONFIG::LOCALE_FR
        private static const  _SUCC_INVITE_STR:String      = "__DATA__:Vous avez invité __NAME__.";

        CONFIG::LOCALE_ID
        private static const  _SUCC_INVITE_STR:String      = "__DATA__:__NAME__の招待に成功しました。";

        CONFIG::LOCALE_TH
        private static const  _SUCC_INVITE_STR:String      = "__DATA__:อัญเชิญ __NAME__ สำเร็จ";


        public function SuccessInviteLog()
        {
            super();
        }

        public override function get type():int
        {
            return ClientLog.SUCC_INVITE;
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
                ret = _SUCC_INVITE_STR.replace(/__DATA__/, TimeFormat.transDateStr(date)).replace(/__NAME__/, name);
                _textSet.unshift(ret);
            }
            checkMax();
            return ret;
        }

        public override function setLog(a:Object, save:Boolean = false ):String
        {
            var str:String = String(a);
            var inviteDataDet:Array  = str.split(",");
            var friendName:String = inviteDataDet.shift();

            dateSet.unshift(new Date());
            nameSet.unshift(friendName);
            if (save)
            {
                _sharedObj.flush();
            }

            // テキストを先に作ってしまう
            var ret:String = setText( 0 );

            // 報酬アイテムの取得ログを書く
            for ( var i:int = 0; i < inviteDataDet.length; i++ ) {
                ClientLog.write(ClientLog.GOT_ITEM, inviteDataDet[i], true);
            }

            return ret;
//            return nameSet.length - 1;
        }


    }


}