package model
{

    import flash.events.*;

    /**
     * 渦のメッセージ
     *
     */

    public class ProfoundMessage
    {
        // MsgDlgId
        public static const PRF_MSGDLG_DAMAGE :int = 0;
        public static const PRF_MSGDLG_REPAIR :int = 1;
        public static const PRF_MSGDLG_MAX    :int = 2;

        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_DAMAGE:String = "__A_NAME__さんが__B_NAME__に__DMG__ダメージを与えた";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_REPAIR:String = "__B_NAME__が__POINT__回復した";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_DAMAGE:String = "__A_NAME__ dealt __DMG__ damage to __B_NAME__.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_REPAIR:String = "__B_NAME__ recovered __POINT__ HP.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_DAMAGE:String = "__A_NAME__對__B_NAME__造成__DMG__傷害";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_REPAIR:String = "__B_NAME__回復__POINT__";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_DAMAGE:String = "__A_NAME__对__B_NAME__造成__DMG__伤害";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_REPAIR:String = "__B_NAME__恢复__POINT__";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_DAMAGE:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_REPAIR:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_DAMAGE:String = "__A_NAME__ a donné __DMG__ dommages à __B_NAME__ .";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_REPAIR:String = "__B_NAME__ récupère __POINT__ .";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_DAMAGE:String = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_REPAIR:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_DAMAGE:String = "คุณ__A_NAME__สร้างความเสียหายแก่__B_NAME__เป็นจำนวน__DMG__แต้ม";//"__A_NAME__さんが__B_NAME__に__DMG__ダメージを与えた";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_REPAIR:String = "__B_NAME__ฟื้นพลัง__POINT__แต้ม";//"__B_NAME__が__POINT__回復した";

        // singleton
        private static var __instance:ProfoundMessage = null;

        // ProfoundLogs
        private var _prfLogs:ProfoundLogs = ProfoundLogs.getInstance();

        public static function setMessage(str:String):void
        {
            if (__instance == null) {initProfoundMessage();}
            log.writeLog(log.LV_FATAL, "", "ProfoundMessage", str);
            var strData:Array = str.split(":");
            var prfId:int = parseInt(strData.shift());
            var msgDlgId:int = parseInt(strData.shift());
            var msgData:Array = (strData.length > 0 ) ? strData[0].split(",") : null;
            __instance.setLogMessage(prfId,msgDlgId,msgData);
        }

        private static function initProfoundMessage():void
        {
            __instance = new ProfoundMessage();
        }

        /**
         * コンストラクタ
         *
         */
        public function ProfoundMessage()
        {
        }

        private function setLogMessage(prfId:int,msgDlgId:int,msgData:Array):void
        {
            if (msgDlgId >= 0 && msgDlgId < PRF_MSGDLG_MAX)
            {
                var msg:String = null;
                switch (msgDlgId)
                {
                case PRF_MSGDLG_DAMAGE:
                    msg = _TRANS_MSG_DAMAGE.replace("__A_NAME__",msgData[0]).replace("__B_NAME__",msgData[1]).replace("__DMG__",msgData[2]);
                    break;
                case PRF_MSGDLG_REPAIR:
                    msg = _TRANS_MSG_REPAIR.replace("__B_NAME__",msgData[0]).replace("__POINT__",msgData[1]);
                    break;
                default:
                }
                log.writeLog(log.LV_FATAL, "", "ProfoundMessage msg", msg);
                if (_prfLogs&&msg){_prfLogs.setLogPrfId(prfId,msg)}
            }
        }

    }

}
