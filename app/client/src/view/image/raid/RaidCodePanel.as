package view.image.raid
{
    import flash.display.*;
    import flash.text.*;
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
     *  レイドコード入力パネル
     *
     */

    public class RaidCodePanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "入力";
        CONFIG::LOCALE_JP
        private static const _TRANS_CANCEL	:String = "キャンセル";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "渦のコードを入力してください";

        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Enter";
        CONFIG::LOCALE_EN
        private static const _TRANS_CANCEL	:String = "Cancel";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "Enter your vortex code.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "輸入";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CANCEL	:String = "取消";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "請輸入渦的代碼";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "输入";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CANCEL	:String = "取消";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "请输入漩涡的编号。";

        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_CANCEL	:String = "キャンセル";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "この渦の攻略をあきらめますか？";

        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Saisie";
        CONFIG::LOCALE_FR
        private static const _TRANS_CANCEL	:String = "Annuler";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Veuillez taper le code du Vortex";

        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_CANCEL	:String = "キャンセル";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "この渦の攻略をあきらめますか？";

        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_TH
        private static const _TRANS_CANCEL	:String = "キャンセル";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG		:String = "この渦の攻略をあきらめますか？";


        // タイトル表示
        private var _text:Label = new Label();

        // 決定ボタン
        private var _confirmButton:Button = new Button();
        // キャンセルボタン
        private var _cancelButton:Button = new Button();

        // ボタンFunction
        private var _confFunc:Function = null;
        private var _cancelFunc:Function = null;

        // 入力
        private var _input:TextInput = new TextInput();

        // Hash
        private var _hash:String = "";

        // 表示位置
        private const _X:int      = 255;
        private const _Y:int      = 230;
        private const _WIDTH:int  = 250;
        private const _HEIGHT:int = 150;
        private const _TEXT_X:int = 13;
        private const _TEXT_Y:int = 40;
        private const _TEXT_W:int = 228;
        private const _TEXT_H:int = 50;
        private const _CONFIRM_X:int  = 50;
        private const _CONFIRM_Y:int  = 110;
        private const _CONFIRM_W:int  = 60;
        private const _CONFIRM_H:int  = 23;
        private const _CANCEL_X:int  = 120;
        private const _CANCEL_Y:int  = 110;
        private const _CANCEL_W:int  = 80;
        private const _CANCEL_H:int  = 23;
        private const _BTN_Y:int  = 100;
        private const _BTN_W:int  = 60;
        private const _BTN_H:int  = 23;

        /**
         * コンストラクタ
         *
         */
        public function RaidCodePanel()
        {
            super();

            layout = "absolute"
            title = _TRANS_CONFIRM;

            _text.text = _TRANS_MSG;
            _text.styleName = "BuySendPanelLabel";
            _text.setStyle("textAlign", "center");

            _confirmButton.label = _TRANS_CONFIRM;
            _cancelButton.label = _TRANS_CANCEL;

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

            // confirmButton
            _confirmButton.x = _CONFIRM_X;
            _confirmButton.y = _BTN_Y;
            _confirmButton.width = _BTN_W;
            _confirmButton.height = _BTN_H;

            // cancelButton
            _cancelButton.x = _CANCEL_X;
            _cancelButton.y = _BTN_Y;
            _cancelButton.width = _CANCEL_W;
            _cancelButton.height = _BTN_H;

            // input
            _input.x = 50;
            _input.y = 60;
            _input.width = 160;
            _input.height = 21;
            _input.maxChars = 120;
            _input.visible = true;
            //_input.setStyle("focusThickness",  0);

            addChild(_text);
            addChild(_confirmButton);
            addChild(_cancelButton);
            addChild(_input);
        }

        public function get confirm():Button
        {
            return _confirmButton;
        }
        public function get cancel():Button
        {
            return _cancelButton;
        }

        public function resetText():void
        {
            _input.text = "";
            _hash = "";
        }
        public function get text():String
        {
            return _input.text;
        }
        public function get hash():String
        {
            if (_hash == "" && _input.text != "") {
                if (_input.text.match(/^http/)) {
                    var txt1:Array = _input.text.split("pn");
                    _hash = txt1.pop().slice(0,11);
                } else {
                    _hash = _input.text;
                }
            }
            return _hash;
        }
    }
}

