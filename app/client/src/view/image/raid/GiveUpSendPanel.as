package view.image.raid
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
    import view.utils.RemoveChild;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  ギブアップ選択パネル
     *
     */

    public class GiveUpSendPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "この渦の攻略をあきらめますか？";

        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Confirm";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "Do you want to abandon this vortex?";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "確定要放棄這個渦嗎？";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "确认";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "是否放弃攻略这个漩涡？";

        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "この渦の攻略をあきらめますか？";

        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Souhaitez-vous abandonner ce Vortex ?";

        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "この渦の攻略をあきらめますか？";

        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM :String = "ตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "จะยกเลิกการพิชิตน้ำวนนี้ไหมครับ?";


        // タイトル表示
        private var _text:Label = new Label();

        // 決定ボタン
        private var _yesButton:Button = new Button();
        private var _noButton:Button = new Button();

        // ボタンFunction
        private var _yesFunc:Function = null;
        private var _noFunc:Function = null;

        // 表示位置
        private const _X:int      = 255;
        private const _Y:int      = 230;
        private const _WIDTH:int  = 250;
        private const _HEIGHT:int = 150;
        private const _TEXT_X:int = 13;
        private const _TEXT_Y:int = 60;
        private const _TEXT_W:int = 228;
        private const _TEXT_H:int = 50;
        private const _YES_X:int  = 40;
        private const _YES_Y:int  = 100;
        private const _YES_W:int  = 60;
        private const _YES_H:int  = 23;
        private const _NO_X:int   = 150;
        private const _NO_Y:int   = 100;
        private const _NO_W:int   = 60;
        private const _NO_H:int   = 23;

        /**
         * コンストラクタ
         *
         */
        public function GiveUpSendPanel()
        {
            super();

            layout = "absolute"
            title = _TRANS_CONFIRM;

            _text.text = _TRANS_MSG;
            _text.styleName = "BuySendPanelLabel";
            _text.setStyle("textAlign", "center");

            _yesButton.label = "Yes";

            _noButton.label = "No";

            // Panel
            x = _X;
            y = _Y;
            width  = _WIDTH;
            height = _HEIGHT;

            // Text
            _text.x = _TEXT_X;
            _text.y = _TEXT_Y;
            _text.width = _TEXT_W;
            _text.height = _TEXT_H;

            // YesButton
            _yesButton.x = _YES_X;
            _yesButton.y = _YES_Y;
            _yesButton.width = _YES_W;
            _yesButton.height = _YES_H;

            // NoButton
            _noButton.x = _NO_X;
            _noButton.y = _NO_Y;
            _noButton.width = _NO_W;
            _noButton.height = _NO_H;

            addChild(_text);
            addChild(_yesButton);
            addChild(_noButton);
        }

        public function get yesButton():Button
        {
            return _yesButton;
        }
        public function get noButton():Button
        {
            return _noButton;
        }
    }
}

