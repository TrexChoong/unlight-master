package view.scene.raid
{

    import flash.display.*;
    import flash.text.*;
    import flash.events.*;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;
    import mx.styles.*;

    import model.ProfoundLogs;
    import model.events.*;
    import view.scene.BaseScene;
    import controller.RaidChatCtrl;
    import view.utils.*;


    /**
     * レイドコメント用表示TextAreaクラス
     *
     */

    public class RaidCommentInput extends TextInput
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "チャットログは運営会社、DeNA社の審査、監視が行われています。またログは記録されてDeNA社にも提供されます。同意できる方のみご利用下さい";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "チャットご利用についての確認";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "All chat logs will be recorded and may be inspected by operators. By entering this chat room you agree to this policy.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "Confirmation About Chat Usage";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "對話記錄有受到監視。請在同意的前提下使用。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "聊天室使用確認";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "对话记录受监视。请在允许的前提下使用";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "聊天室的使用须知";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "채팅로그는 운영회사의 심사, 감시가 실시되고 있습니다.\n또 로그는 운영회사에 제공되고 있습니다. 동의하시고 \n이용을 해주십시오.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "채팅 이용에 대해서 확인";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Toutes les conversations du chat seront inspectées et sauvegardées.\nVeuillez accepter les conditions d'usage avant d'accéder au Chat.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "Vérification des conditions d'usage du Chat";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "チャットログは運営会社、DeNA社の審査、監視が行われています。またログは記録されてDeNA社にも提供されます。同意できる方のみご利用下さい";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "チャットご利用についての確認";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1	:String = "Chat log อยู่ในความดูแลและตรวจสอบโดยบริษัท DeNA และ log ที่ถูกบันทึกไว้จะถูกส่งให้กับบริษัท DeNA ด้วย บริการนี้สำหรับท่านที่ยอมรับข้อตกลงเท่านั้น";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2	:String = "กรุณาตอบตกลงการใช้งานแชท";


        private var _prfLogs:ProfoundLogs = ProfoundLogs.getInstance();
        private var _fontSize:int;
        private static const MAX_CHARS:int = 64; // 入力可能な文字数
        private static var __warned:Boolean = false;

        private var _ctrl:RaidChatCtrl;

        private var _type:int;
        private var _channel:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function RaidCommentInput()
        {
            super();
            _ctrl = RaidChatCtrl.instance;
            editable = true;
            styleName = "ChatInput";
            maxChars = MAX_CHARS;

            addEventListener(MouseEvent.CLICK,clickHandler);
            addEventListener(FlexEvent.ENTER,enterChannelHandler);
        }

        private function enterChannelHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "entr channel handlr");
            if (text!="")
            {
                _prfLogs.speakComment(text);
                text = "";
            }
        }

        private function clickHandler(e:Event):void
        {

        }

        private function okHandler():void
        {
                editable = true;
                __warned = true;
        }

        public function resetText():void
        {
            text = "";
        }



    }

}
