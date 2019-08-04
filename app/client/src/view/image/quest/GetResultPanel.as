package view.image.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  取得確認パネル
     *
     */

    public class GetResultPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CHECK	:String = "確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "新クエストを取得しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "を取得しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_NEWQUEST	:String = "新クエスト";

        CONFIG::LOCALE_EN
        private static const _TRANS_CHECK	:String = "Confirm";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "You have a new quest!";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "You received ";
        CONFIG::LOCALE_EN
        private static const _TRANS_NEWQUEST	:String = "New Quest";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CHECK	:String = "確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "取得了新的任務";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "取得";
        CONFIG::LOCALE_TCN
        private static const _TRANS_NEWQUEST	:String = "新的任務";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CHECK	:String = "确认";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "获得新任务";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "已获得";
        CONFIG::LOCALE_SCN
        private static const _TRANS_NEWQUEST	:String = "新任务";

        CONFIG::LOCALE_KR
        private static const _TRANS_CHECK	:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "새로운 퀘스트를 취득했습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "을(를) 취득했습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_NEWQUEST	:String = "새로운 퀘스트";

        CONFIG::LOCALE_FR
        private static const _TRANS_CHECK	:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Vous avez obtenu une nouvelle Quête !";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "Vous avez recu ";
        CONFIG::LOCALE_FR
        private static const _TRANS_NEWQUEST	:String = "Nouvelle Quête";

        CONFIG::LOCALE_ID
        private static const _TRANS_CHECK	:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "新クエストを取得しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "を取得しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_NEWQUEST	:String = "新クエスト";

        CONFIG::LOCALE_TH
        private static const _TRANS_CHECK   :String = "ตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "ได้รับเควสใหม่";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "ได้รับ";
        CONFIG::LOCALE_TH
        private static const _TRANS_NEWQUEST    :String = "เควสใหม่";


        // タイトル表示
        private var _text:Label = new Label();
        private var _text2:Label = new Label();

        // 決定ボタン
        private var _okButton:Button = new Button();

        /**
         * コンストラクタ
         *
         */
        public function GetResultPanel()
        {
            super();
            x = 270;
            y = 280;
//             width  = 250;
//             height = 150;
            width  = 250;
            height = 130;
            layout = "absolute"
//            title = "確認";
            title = _TRANS_CHECK;

            _text.x = 24;
            _text.y = 45;
            _text.width = 200;
            _text.height = 50;
//            _text.text = "新クエストを取得しました";
            _text.text = _TRANS_MSG1;
            _text.styleName = "GetSendPanelLabel";

            _text2.x = 28;
            _text2.y = 60;
            _text2.width = 200;
            _text2.height = 50;
//            _text2.text = "を取得しました";
            _text2.text = _TRANS_MSG2;
            _text2.styleName = "GetSendPanelLabel";

//             _okButton.x = 95;
//             _okButton.y = 100;
            _okButton.x = 95;
            _okButton.y = 80;
            _okButton.width = 60;
            _okButton.height = 23;
            _okButton.label = "OK";
//            _okButton.styleName = "BuySendPanelLabel";

            CONFIG::LOCALE_TH
            {
                _text.text = _TRANS_MSG2;
                _text2.text = _TRANS_MSG1;
            }

            addChild(_text);
            addChild(_text2);
            addChild(_okButton);
        }

        //
        public function get okButton():Button
        {
            return _okButton;
        }

        public function setQuestName(str:String):void
        {
            if(str)
            {
                _text.text = str;
            }
            else
            {
//                _text.text = "新クエスト";
                _text.text = _TRANS_NEWQUEST;
            }

            CONFIG::LOCALE_TH
            {
                if(str)
                {
                    _text2.text = str;
                }
                else
                {
                    _text2.text = _TRANS_NEWQUEST;
                }
                _text.text = _TRANS_MSG2;
            }
        }
    }
}