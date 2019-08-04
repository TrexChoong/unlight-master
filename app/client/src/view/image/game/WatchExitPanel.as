package view.image.game
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
     *  観戦退室確認パネル
     *
     */

    public class WatchExitPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "退室";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "退室しますか？";

        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Exit room";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "Exit this room?";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "退出";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "確定要退出嗎？";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "退出";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "是否退出？";

        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "退室";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "退室しますか？";

        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Quitter";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Voulez-vous quittez?";

        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "退室";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "退室しますか？";

        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM :String = "ออกจากห้อง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "ออกจากห้องไหม?";

        // タイトル表示
        private var _text:Label = new Label();

        // 決定ボタン
        private var _yesButton:Button = new Button();
        private var _noButton:Button = new Button();

        /**
         * コンストラクタ
         *
         */
        public function WatchExitPanel()
        {
            super();
            x = 255;
            y = 230;
            width  = 250;
            height = 150;
            layout = "absolute"
            title = _TRANS_CONFIRM;

            _text.x = 13;
            _text.y = 60;
            _text.width = 228;
            _text.height = 50;
            _text.text = _TRANS_MSG;
            _text.styleName = "BuySendPanelLabel";

            _yesButton.x = 40;
            _yesButton.y = 100;
            _yesButton.width = 60;
            _yesButton.height = 23;
            _yesButton.label = "Yes";

            _noButton.x = 150;
            _noButton.y = 100;
            _noButton.width = 60;
            _noButton.height = 23;
            _noButton.label = "No";

            addChild(_text);
            addChild(_yesButton);
            addChild(_noButton);
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