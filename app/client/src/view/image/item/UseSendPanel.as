package view.image.item
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
     *  使用パネル
     *
     */

    public class UseSendPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "このアイテムを使用しますか？";

        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Confirm";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "Use this item?";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "要使用此道具嗎？";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "确认";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "要使用这个道具吗？";

        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "이 아이템을 사용하겠습니까?";

        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Utilisez cet objet ?";

        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "このアイテムを使用しますか？";

        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM :String = "ตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "จะใช้ไอเท็มนี้หรือไม่?";


        // タイトル表示
        private var _text:Label = new Label();

        // 決定ボタン
        private var _yesButton:Button = new Button();
        private var _noButton:Button = new Button();

        /**
         * コンストラクタ
         *
         */
        public function UseSendPanel()
        {
            super();
            x = 255;
            y = 230;
            width  = 250;
            height = 150;
            layout = "absolute"
//            title = "確認";
            title = _TRANS_CONFIRM;

            _text.x = 13;
            CONFIG::LOCALE_EN
            {
                _text.x = -25;
            }
            CONFIG::LOCALE_TH
            {
                _text.x = -25;
            }
            _text.y = 50;
            _text.width = 200;
            _text.height = 50;
//            _text.text = "このアイテムを使用しますか？";
            _text.text = _TRANS_MSG;
            _text.styleName = "UseSendPanelLabel";

            _yesButton.x = 40;
            _yesButton.y = 100;
            _yesButton.width = 60;
            _yesButton.height = 23;
            _yesButton.label = "Yes";
//            _yesButton.styleName = "BuySendPanelLabel";

            _noButton.x = 150;
            _noButton.y = 100;
            _noButton.width = 60;
            _noButton.height = 23;
            _noButton.label = "No";
//            _noButton.styleName = "BuySendPanelLabel";

            addChild(_text);
            addChild(_yesButton);
            addChild(_noButton);
//             Unlight.GCW.watch(_text);
//             Unlight.GCW.watch(_yesButton);
//             Unlight.GCW.watch(_noButton);
        }

        //
        public function get yesButton():Button
        {
            return _yesButton;
        }

        //
        public function get noButton():Button
        {
            return _noButton;
        }
    }
}