package view.image.title
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;
    import mx.managers.*;
    import mx.events.*;

    import view.image.BaseImage;

    import controller.TitleCtrl;

    /**
     * ログインパネルクラス
     *
     */

    public class LoginPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CONECT	:String = "サーバ接続中";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_MAINTE	:String = "メンテナンス";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CONFIRM	:String = "確認";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CONECT	:String = "Connecting to server";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_MAINTE	:String = "Under Maintenance";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CONFIRM	:String = "Confirm";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CONECT	:String = "跟伺服器連接中";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_MAINTE	:String = "維護";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CONFIRM	:String = "確認";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CONECT	:String = "正在连接服务器";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_MAINTE	:String = "保养";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CONFIRM	:String = "确认";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CONECT	:String = "서버 접속중";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_MAINTE	:String = "정검중";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CONFIRM	:String = "확인";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CONECT	:String = "Connexion au serveur";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_MAINTE	:String = "Maintenance";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CONFIRM	:String = "Confirmer";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CONECT	:String = "サーバ接続中";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_MAINTE	:String = "メンテナンス";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CONFIRM	:String = "確認";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CONECT  :String = "กำลังเชื่อมต่อกับเซิฟเวอร์";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_MAINTE  :String = "กำลังปรับปรุง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CONFIRM :String = "ตกลง";


        private static const X:int = 500;
        private static const Y:int = 20;

        private var _state:int = 1; // 0はメンテ、1はログイン、2はレジスト

        private var _VBox:VBox;
        private var _label:Label;
        private var _controlBar:ControlBar;
        private var _spacer:Spacer;

        private var _loginVBox:VBox = new VBox();

        private var _nameHBox:HBox = new HBox();
        private var _passHBox:HBox = new HBox();;
        private var _confirmHBox:HBox = new HBox();;
        private var _emailHBox:HBox = new HBox();;
        private var _buttonHBox:HBox = new HBox();;

        private var _nameLabel:Label = new Label();
        private var _passLabel:Label = new Label();
        private var _confirmLabel:Label = new Label();
        private var _emailLabel:Label = new Label();


        private var _userNameText:TextInput = new TextInput();
        private var _userPassText:TextInput = new TextInput();
        private var _userConfirmText:TextInput = new TextInput();
        private var _userEmailText:TextInput = new TextInput();

        private var _buttonSpacer1:Spacer = new Spacer();
        private var _buttonSpacer2:Spacer = new Spacer();

        private var _loginButton:Button = new Button();


        private var _registControlBar:ControlBar = new ControlBar();
        private var _registSpacer1:Spacer = new Spacer();
        private var _registSpacer2:Spacer = new Spacer();
        private var _registLinkButton:LinkButton = new LinkButton();

        private var _ctrl:TitleCtrl = TitleCtrl.instance;

        private var _textInputArray:Array = [];


        /**
         * コンストラクタ
         *
         */
        public function LoginPanel()
        {
            _textInputArray.push(_userNameText);
            _textInputArray.push(_userPassText);
            _textInputArray.push(_userConfirmText);
            _textInputArray.push(_userEmailText);

            super();
            styleName = "LoginPanel";
            width = 220;
            height = 80;
            layout = "vertical";
            x = X;
            y  =Y;

            alpha = 0.0;
            visible = false;

            horizontalScrollPolicy = "off";
            _VBox = new VBox();
            _VBox.percentWidth = 100;
            _VBox.percentHeight = 100;

            _label = new Label();
//            _label.text = "サーバ接続中";
            _label.text = _TRANS_MSG_CONECT;
            _label.styleName = "LoginLabel";
            _label.percentHeight = 100;
            _label.percentWidth = 100;
            _VBox.addChild(_label);
            addChild(_VBox);

            _registLinkButton.addEventListener(MouseEvent.CLICK,registClickHandler);
            _loginButton.addEventListener(MouseEvent.CLICK,buttonClickHandler);
            _textInputArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    item.percentWidth = 65;
                    item.styleName = "LoginText";
                });
            setLogin();
            setRegist();
            stateChange(1);
            _ctrl.setLoginPanel(this);

        }


        private function registClickHandler(e:MouseEvent):void
        {
            if (_state == 1)
            {
                stateChange(2);
            }
            else if (_state ==2)
            {
                stateChange(1);
            }
        }

        private function buttonClickHandler(e:MouseEvent):void
        {
            SE.playClick();
            if (_state == 1)
            {
                _ctrl.login();
            }
            else if (_state ==2)
            {
                _ctrl.regist();
            }
        }


        public function stateChange(state:int):void
        {
            if (state == 0)
            {
                _state =0;
                addChild(_VBox);
//                title = "メンテナンス";
                title = _TRANS_MSG_MAINTE;
            }
            else if(state == 1)
            {
                _state =1;
                removeAllChildren();
                _loginVBox.removeAllChildren();
                title = "Login";
                _loginButton.label = "Login";
                _registLinkButton.label = "Create New Account";
                height = 215;
                _loginVBox.addChild(_nameHBox);
                _loginVBox.addChild(_passHBox);
                _loginVBox.addChild(_buttonHBox);
                _loginVBox.addChild(_registControlBar);
                addChild(_loginVBox);
                focusEnabled = true;
                tabEnabled = true;

            }
            else if(state == 2)
            {
                _state =2;
                removeAllChildren();
                _loginVBox.removeAllChildren();
                title = "Register";
                _loginButton.label = "Register";
                _registLinkButton.label = "Login Form";
                height = 300;
                _loginVBox.addChild(_nameHBox);
                _loginVBox.addChild(_emailHBox);
                _loginVBox.addChild(_passHBox);
                _loginVBox.addChild(_confirmHBox);
                _loginVBox.addChild(_buttonHBox);
                _loginVBox.addChild(_registControlBar);
                addChild(_loginVBox);
            }
        }

        // ログインパネルの設定を行う
        private function setLogin():void
        {

            _loginVBox.percentWidth = 100;
            _loginVBox.percentHeight = 95;
            _loginVBox.setStyle("paddingTop", 10);
            _loginVBox.setStyle("paddingBottom", 20);
            _nameLabel.text = "Name:";
            _nameLabel.width = 50;
            _nameLabel.styleName = "LoginLabel";

            _userNameText.maxChars = 16;
            _userNameText.restrict = "A-Za-z0-9_\-.";

            _nameHBox.percentWidth = 100;
            _nameHBox.percentHeight = 80;
            _nameHBox.addChild(_nameLabel);
            _nameHBox.addChild(_userNameText);

            _passLabel.text = "Pass:";
            _passLabel.width = 50;
            _passLabel.styleName = "LoginLabel";

            _userPassText.maxChars = 16;
            _userPassText.restrict = "A-Za-z0-9_\-.";
            _userPassText.displayAsPassword = true;

            _passHBox.percentWidth = 100;
            _passHBox.percentHeight = 100;
            _passHBox.addChild(_passLabel);
            _passHBox.addChild(_userPassText);

            _buttonHBox.percentWidth = 110;
            _buttonHBox.percentHeight = 100;

            _buttonSpacer1.percentWidth = 100;
            _buttonSpacer2.percentWidth = 100;
            _buttonSpacer2.percentHeight = 20;

            _loginButton.width = 80;
            _loginButton.y = 5;
            _buttonHBox.addChild(_buttonSpacer1);
            _buttonHBox.addChild(_loginButton);
            _buttonHBox.addChild(_buttonSpacer2);

             _registSpacer1.percentWidth = 100;
//             _registSpacer2.percentWidth = 100;

            _registLinkButton.label = "Create New Account";
            _registLinkButton.styleName = "RegistCB";
            _registLinkButton.width = 170;
            _registControlBar.height = 30;

            _registControlBar.styleName = "RegistCB";


            _registControlBar.addChild(_registSpacer2);
            _registControlBar.addChild(_registLinkButton);
            _registControlBar.addChild(_registSpacer1)

        }

        // 登録パネルの設定を行う
        private function setRegist():void
        {
//            _confirmLabel.text = "確認:";
            _confirmLabel.text = _TRANS_MSG_CONFIRM;
            _confirmLabel.width = 50;
            _confirmLabel.styleName = "LoginLabel";
            _confirmLabel.setStyle("fontSize",  15);
            _confirmLabel.setStyle("fontFamily",  "minchoB");

            _userConfirmText.restrict = "A-Za-z0-9_\\-\\.";
            _userConfirmText.displayAsPassword = true;
            _userConfirmText.maxChars = 16;

            _confirmHBox.percentWidth = 100;
            _confirmHBox.percentHeight = 100;
            _confirmHBox.addChild(_confirmLabel);
            _confirmHBox.addChild(_userConfirmText);

            _userEmailText.restrict = "A-Za-z0-9_\\-\\.\\@";
//            _userEmailText.displayAsPassword = true;
            _userEmailText.maxChars = 64;

            _emailLabel.text = "Email:";
            _emailLabel.width = 50;
            _emailHBox.percentWidth = 100;
            _emailHBox.percentHeight = 100;
            _emailHBox.addChild(_emailLabel);
            _emailHBox.addChild(_userEmailText);
            _emailHBox..styleName = "LoginLabel";
        }


        /**
         * パネルの入力の有効/無効化の切り替え
         *
         */
        public function panelEditable(on:Boolean):void
        {
            if (on)
            {
                _textInputArray.forEach(function (item:*, index:int, array:Array):void{item.editable=true;});
                _loginButton.enabled = true;
            }
            else
            {
                _textInputArray.forEach(function (item:*, index:int, array:Array):void{item.editable=false;});
                _loginButton.enabled = false;
            }
        }

        /**
         * 入力された情報をクリア
         *
         */
        public function panelClear():void
        {
            _textInputArray.forEach(function (item:*, index:int, array:Array):void{item.text="";});
        }


        /**
         * 入力された名前を返す
         *
         */
        public function get userName():String
        {
            return _userNameText.text
        }

        /**
         * 入力されたパスを返す
         *
         */
        public function get pass():String
        {
            return _userPassText.text
        }

        /**
         * 入力された確認パスを返す
         *
         */
        public function get confirm():String
        {
            return _userConfirmText.text
        }

        /**
         * 入力されたEmailを返す
         *
         */
        public function get email():String
        {
            return _userEmailText.text
        }



    }

}
