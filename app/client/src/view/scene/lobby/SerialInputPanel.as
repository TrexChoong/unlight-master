package view.scene.lobby
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.managers.*;
    import mx.events.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.*;
    import view.image.common.*;
    import view.image.quest.*;
    import view.scene.common.*;
    import view.utils.*;
    import view.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.scene.ModelWaitShowThread;
    import controller.LobbyCtrl;


    /**
     * イベント用シリアルコード入力パネル
     *
     */

    public class SerialInputPanel extends TitleWindow
    {
        private var _VBox:VBox;
        private var _label:Label;
        private var _controlBar:ControlBar;
        private var _spacer:Spacer;

        private var _tabNav:TabNavigator = new TabNavigator;
        private var _infectionVBox:VBox = new VBox();
        private var _passSetVBox:VBox = new VBox();
        private var _serialVBox:VBox = new VBox();


        // Infection
        private var _infectionNameHBox:HBox = new HBox();
        private var _infectionSerialHBox:HBox = new HBox();
        private var _infectionPassHBox:HBox = new HBox();;
        private var _infectionConfirmHBox:HBox = new HBox();;
        private var _infectionEmailHBox:HBox = new HBox();;
        private var _infectionButtonHBox:HBox = new HBox();;

        private var _infectionLabel:Label = new Label();
        private var _infectionSerialLabel:Label = new Label();
        private var _infectionPassLabel:Label = new Label();
        private var _infectionConfirmLabel:Label = new Label();
        private var _infectionEmailLabel:Label = new Label();


        private var _infectionUserSerialText:TextInput = new TextInput();
        private var _infectionUserPassText:TextInput = new TextInput();
        private var _infectionUserConfirmText:TextInput = new TextInput();
        private var _infectionUserEmailText:TextInput = new TextInput();

        private var _infectionButtonSpacer1:Spacer = new Spacer();
        private var _infectionButtonSpacer2:Spacer = new Spacer();

        private var _infectionLoginButton:Button = new Button();

        // PassSet
        private var _passSetNameHBox:HBox = new HBox();
        private var _passSetSerialHBox:HBox = new HBox();
        private var _passSetPassHBox:HBox = new HBox();;
        private var _passSetConfirmHBox:HBox = new HBox();;
        private var _passSetEmailHBox:HBox = new HBox();;
        private var _passSetButtonHBox:HBox = new HBox();;

        private var _passSetLabel:Label = new Label();
        private var _passSetSerialLabel:Label = new Label();
        private var _passSetPassLabel:Label = new Label();
        private var _passSetConfirmLabel:Label = new Label();
        private var _passSetEmailLabel:Label = new Label();


        private var _passSetUserSerialText:TextInput = new TextInput();
        private var _passSetUserPassText:TextInput = new TextInput();
        private var _passSetUserConfirmText:TextInput = new TextInput();
        private var _passSetUserEmailText:TextInput = new TextInput();

        private var _passSetButtonSpacer1:Spacer = new Spacer();
        private var _passSetButtonSpacer2:Spacer = new Spacer();

        private var _passSetLoginButton:Button = new Button();

        // Serial
        private var _serialNameHBox:HBox = new HBox();
        private var _serialSerialHBox:HBox = new HBox();
        private var _serialPassHBox:HBox = new HBox();;
        private var _serialConfirmHBox:HBox = new HBox();;
        private var _serialEmailHBox:HBox = new HBox();;
        private var _serialButtonHBox:HBox = new HBox();;

        private var _serialLabel:Label = new Label();
        private var _serialSerialLabel:Label = new Label();
        private var _serialPassLabel:Label = new Label();
        private var _serialConfirmLabel:Label = new Label();
        private var _serialEmailLabel:Label = new Label();


        private var _serialUserSerialText:TextInput = new TextInput();
        private var _serialUserPassText:TextInput = new TextInput();
        private var _serialUserConfirmText:TextInput = new TextInput();
        private var _serialUserEmailText:TextInput = new TextInput();

        private var _serialButtonSpacer1:Spacer = new Spacer();
        private var _serialButtonSpacer2:Spacer = new Spacer();

        private var _serialLoginButton:Button = new Button();




        CONFIG::LOCALE_JP
        private static const _TRANS_INFECTION_MGS:String = "Infectionコラボシリアル";
        CONFIG::LOCALE_EN
        private static const _TRANS_INFECTION_MGS:String = "The serial number from the Infection Collaboration Event";
        CONFIG::LOCALE_TCN
        private static const _TRANS_INFECTION_MGS:String = "Infection的合作序號";
        CONFIG::LOCALE_SCN
        private static const _TRANS_INFECTION_MGS:String = "Infection的合作序号";
        CONFIG::LOCALE_FR
        private static const _TRANS_INFECTION_MGS:String = "Collaboration avec le jeu Infection.";
        CONFIG::LOCALE_KR
        private static const _TRANS_INFECTION_MGS:String = "Infectionコラボシリアル";
        CONFIG::LOCALE_ID
        private static const _TRANS_INFECTION_MGS:String = "Infectionコラボシリアル";
        CONFIG::LOCALE_TH
        private static const _TRANS_INFECTION_MGS:String = "Infectionコラボシリアル";

        CONFIG::LOCALE_JP
        private static const _TRANS_PASS_SET_MGS:String = "コードとパスワードを入力して下さい";
        CONFIG::LOCALE_EN
        private static const _TRANS_PASS_SET_MGS:String = "Enter code and password";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PASS_SET_MGS:String = "請輸入虛擬寶物序號與密碼";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PASS_SET_MGS:String = "请输入虚拟宝物序号与密码";
        CONFIG::LOCALE_FR
        private static const _TRANS_PASS_SET_MGS:String = "Entrez le code de série et le mot de passe";
        CONFIG::LOCALE_KR
        private static const _TRANS_PASS_SET_MGS:String = "コードとパスワードを入力して下さい";
        CONFIG::LOCALE_ID
        private static const _TRANS_PASS_SET_MGS:String = "コードとパスワードを入力して下さい";
        CONFIG::LOCALE_TH
        private static const _TRANS_PASS_SET_MGS:String = "コードとパスワードを入力して下さい";

        CONFIG::LOCALE_JP
        private static const _TRANS_SERIAL_MGS:String = "シリアル番号を入力して下さい";
        CONFIG::LOCALE_EN
        private static const _TRANS_SERIAL_MGS:String = "Enter serial code";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SERIAL_MGS:String = "請輸入虛擬寶物序號";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SERIAL_MGS:String = "请输入虚拟宝物序号";
        CONFIG::LOCALE_FR
        private static const _TRANS_SERIAL_MGS:String = "Entrez le code de série";
        CONFIG::LOCALE_KR
        private static const _TRANS_SERIAL_MGS:String = "シリアル番号を入力して下さい";
        CONFIG::LOCALE_ID
        private static const _TRANS_SERIAL_MGS:String = "シリアル番号を入力して下さい";
        CONFIG::LOCALE_TH
        private static const _TRANS_SERIAL_MGS:String = "シリアル番号を入力して下さい";

        private static const X:int = 280;
        private static const Y:int = 235;

        private var _textInputArray:Array = [];
        public function SerialInputPanel()
        {
            _textInputArray.push(_infectionUserSerialText);
            _textInputArray.push(_infectionUserPassText);
            _textInputArray.push(_infectionUserConfirmText);
            _textInputArray.push(_infectionUserEmailText);

            _textInputArray.push(_passSetUserSerialText);
            _textInputArray.push(_passSetUserPassText);
            _textInputArray.push(_passSetUserConfirmText);
            _textInputArray.push(_passSetUserEmailText);

            _textInputArray.push(_serialUserSerialText);
            _textInputArray.push(_serialUserPassText);
            _textInputArray.push(_serialUserConfirmText);
            _textInputArray.push(_serialUserEmailText);

            super();
            styleName = "LoginPanel";
            width = 245;
            height = 245;
            layout = "vertical";
            x = X;
            setStyle("paddingTop", 33);
            y  =Y;

            alpha = 1.0;

            horizontalScrollPolicy = "off";
            showCloseButton = true;

            _tabNav.width = 232;
            _tabNav.height = 175;
            _tabNav.styleName = "LoginPanel";
            _tabNav.setStyle("paddingTop", 15);
            _tabNav.setStyle("paddingLeft", 15);
            _tabNav.setStyle("backgroundColor", "#212E44");
            _tabNav.setStyle("tabStyleName", "ItemListPanelTabLabel");

            addChild(_tabNav);

            _infectionLoginButton.addEventListener(MouseEvent.CLICK,buttonClickInfectionHandler);
            _passSetLoginButton.addEventListener(MouseEvent.CLICK,buttonClickPassSetHandler);
            _serialLoginButton.addEventListener(MouseEvent.CLICK,buttonClickSerialHandler);
            addEventListener(CloseEvent.CLOSE, closeButtonClickHandler);

            _textInputArray.forEach(
                function (item:*, index:int, array:Array):void
                {
                    item.percentWidth = 65;
                    item.styleName = "LoginText";
                });
            title = "Serial CodeInput";

            // Infection
            _infectionLoginButton.label = "OK";

            _infectionVBox.addChild(_infectionNameHBox);
            _infectionVBox.addChild(_infectionSerialHBox);
            // _infectionVBox.addChild(_infectionPassHBox);
            _infectionVBox.addChild(_infectionButtonHBox);

            _infectionVBox.horizontalScrollPolicy = "off";
            _infectionVBox.percentWidth = 100;
            _infectionVBox.percentHeight = 70;
            _infectionVBox.setStyle("paddingBottom", 20);
            _infectionVBox.setStyle("paddingTop", 10);
            _infectionVBox.label = "Infection";

            _infectionLabel.text = _TRANS_INFECTION_MGS;
            _infectionLabel.styleName = "ItemListPanelTabLabel";
            _infectionLabel.width = 200;
            _infectionNameHBox.percentWidth = 100;
            _infectionNameHBox.height = 20;
            _infectionNameHBox.addChild(_infectionLabel);


            _infectionSerialLabel.text = "Serial:";
            _infectionSerialLabel.width = 48;
            _infectionSerialLabel.styleName = "LoginLabel";

            _infectionUserSerialText.maxChars = 15;
            _infectionUserSerialText.restrict = "0-9A-Za-z\\-";

            _infectionSerialHBox.percentWidth = 100;
            _infectionSerialHBox.percentHeight = 80;

            _infectionSerialHBox.addChild(_infectionSerialLabel);
            _infectionSerialHBox.addChild(_infectionUserSerialText);

            _infectionPassLabel.text = "Pass:";
            _infectionPassLabel.width = 50;
            _infectionPassLabel.styleName = "LoginLabel";

            _infectionUserPassText.maxChars = 12;
            _infectionUserPassText.restrict = "0-9";
            _infectionUserPassText.displayAsPassword = true;

            _infectionPassHBox.percentWidth = 100;
            _infectionPassHBox.percentHeight = 100;
            _infectionPassHBox.addChild(_infectionPassLabel);
            _infectionPassHBox.addChild(_infectionUserPassText);

            _infectionButtonHBox.percentWidth = 110;
            _infectionButtonHBox.percentHeight = 100;

            _infectionButtonSpacer1.percentWidth = 100;
            _infectionButtonSpacer2.percentWidth = 100;
            _infectionButtonSpacer2.percentHeight = 20;



            _infectionLoginButton.width = 80;
            _infectionLoginButton.y = 5;
            _infectionButtonHBox.addChild(_infectionButtonSpacer1);
            _infectionButtonHBox.addChild(_infectionLoginButton);
            _infectionButtonHBox.addChild(_infectionButtonSpacer2);



            // PassSet
            _passSetLoginButton.label = "OK";

            _passSetVBox.addChild(_passSetNameHBox);
            _passSetVBox.addChild(_passSetSerialHBox);
            _passSetVBox.addChild(_passSetPassHBox);
            _passSetVBox.addChild(_passSetButtonHBox);

            _passSetVBox.horizontalScrollPolicy = "off";
            _passSetVBox.percentWidth = 100;
            _passSetVBox.percentHeight = 100;
            // _passSetVBox.setStyle("paddingTop", 10);
            _passSetVBox.setStyle("paddingBottom", 20);
            _passSetVBox.label = "Serial&Pass";


            _passSetLabel.text = _TRANS_PASS_SET_MGS;
            _passSetLabel.styleName = "ItemListPanelTabLabel";
            _passSetLabel.width = 200;
            _passSetNameHBox.percentWidth = 100;
            _passSetNameHBox.height = 20;
            _passSetNameHBox.addChild(_passSetLabel);


            _passSetSerialLabel.text = "Serial:";
            _passSetSerialLabel.width = 50;
            _passSetSerialLabel.styleName = "LoginLabel";

            _passSetUserSerialText.maxChars = 12;
            _passSetUserSerialText.restrict = "0-9";

            _passSetSerialHBox.percentWidth = 100;
            _passSetSerialHBox.percentHeight = 90;

            _passSetSerialHBox.addChild(_passSetSerialLabel);
            _passSetSerialHBox.addChild(_passSetUserSerialText);

            _passSetPassLabel.text = "Pass:";
            _passSetPassLabel.width = 50;
            _passSetPassLabel.styleName = "LoginLabel";

            _passSetUserPassText.maxChars = 12;
            _passSetUserPassText.restrict = "0-9";
            _passSetUserPassText.displayAsPassword = true;

            _passSetPassHBox.percentWidth = 100;
            _passSetPassHBox.percentHeight = 100;
            _passSetPassHBox.addChild(_passSetPassLabel);
            _passSetPassHBox.addChild(_passSetUserPassText);

            _passSetButtonHBox.percentWidth = 110;
            _passSetButtonHBox.percentHeight = 100;

            _passSetButtonSpacer1.percentWidth = 100;
            _passSetButtonSpacer2.percentWidth = 100;
            _passSetButtonSpacer2.percentHeight = 20;



            _passSetLoginButton.width = 80;
            _passSetLoginButton.y = 5;
            _passSetButtonHBox.addChild(_passSetButtonSpacer1);
            _passSetButtonHBox.addChild(_passSetLoginButton);
            _passSetButtonHBox.addChild(_passSetButtonSpacer2);




            // Serial
            _serialLoginButton.label = "OK";

            _serialVBox.addChild(_serialNameHBox);
            _serialVBox.addChild(_serialSerialHBox);
            // _serialVBox.addChild(_serialPassHBox);
            _serialVBox.addChild(_serialButtonHBox);

            _serialVBox.horizontalScrollPolicy = "off";
            _serialVBox.percentWidth = 100;
            _serialVBox.percentHeight = 70;
            _serialVBox.setStyle("paddingBottom", 20);
            _serialVBox.setStyle("paddingTop", 10);
            _serialVBox.label = "Serial";

            _serialLabel.text = _TRANS_SERIAL_MGS;
            _serialLabel.styleName = "ItemListPanelTabLabel";
            _serialLabel.width = 200;
            _serialNameHBox.percentWidth = 100;
            _serialNameHBox.height = 20;
            _serialNameHBox.addChild(_serialLabel);


            _serialSerialLabel.text = "Serial:";
            _serialSerialLabel.width = 48;
            _serialSerialLabel.styleName = "LoginLabel";

            _serialUserSerialText.maxChars = 20;
            _serialUserSerialText.restrict = "0-9A-Za-z\\-";

            _serialSerialHBox.percentWidth = 100;
            _serialSerialHBox.percentHeight = 80;

            _serialSerialHBox.addChild(_serialSerialLabel);
            _serialSerialHBox.addChild(_serialUserSerialText);

            _serialPassLabel.text = "Pass:";
            _serialPassLabel.width = 50;
            _serialPassLabel.styleName = "LoginLabel";

            _serialUserPassText.maxChars = 12;
            _serialUserPassText.restrict = "0-9";
            _serialUserPassText.displayAsPassword = true;

            _serialPassHBox.percentWidth = 100;
            _serialPassHBox.percentHeight = 100;
            _serialPassHBox.addChild(_serialPassLabel);
            _serialPassHBox.addChild(_serialUserPassText);

            _serialButtonHBox.percentWidth = 110;
            _serialButtonHBox.percentHeight = 100;

            _serialButtonSpacer1.percentWidth = 100;
            _serialButtonSpacer2.percentWidth = 100;
            _serialButtonSpacer2.percentHeight = 20;



            _serialLoginButton.width = 80;
            _serialLoginButton.y = 5;
            _serialButtonHBox.addChild(_serialButtonSpacer1);
            _serialButtonHBox.addChild(_serialLoginButton);
            _serialButtonHBox.addChild(_serialButtonSpacer2);





            CONFIG::LOCALE_JP
            {
                _tabNav.addChild(_serialVBox);
                _tabNav.addChild(_infectionVBox);
            }
            CONFIG::LOCALE_EN
            {
                _tabNav.addChild(_serialVBox);
                _tabNav.addChild(_infectionVBox);
            }

            CONFIG::LOCALE_TCN
            {
                _tabNav.addChild(_serialVBox);
                _tabNav.addChild(_passSetVBox);
                _tabNav.addChild(_infectionVBox);
            }
            CONFIG::LOCALE_FR
            {
                _tabNav.addChild(_serialVBox);
                _tabNav.addChild(_infectionVBox);
            }
            CONFIG::LOCALE_SCN
            {
                _tabNav.addChild(_serialVBox);
            }
        }

        // ショップボタンを呼び出す
        public function show():void
        {
            Unlight.INS.topContainer.parent.addChild(this);
            TopView.enable (false);
        }

        private function buttonClickInfectionHandler(event:Event):void
        {
            if(_infectionUserSerialText.length > 0 )
            {
                LobbyCtrl.instance.infectionCollaboSerialSend(_infectionUserSerialText.text);
                _infectionUserSerialText.text = "";
                hide();
            };
        }

        private function buttonClickPassSetHandler(event:Event):void
        {
            if(_passSetUserSerialText.length > 0 && _passSetUserPassText.length > 0 )
            {
                log.writeLog(log.LV_DEBUG, this, "passSet serial");
                LobbyCtrl.instance.serialCodeSend(_passSetUserSerialText.text, _passSetUserPassText.text);
                _passSetUserSerialText.text = "";
                _passSetUserPassText.text = "";
                hide();
            };
        }

        private function buttonClickSerialHandler(event:Event):void
        {
            if(_serialUserSerialText.length > 0 )
            {
                log.writeLog(log.LV_DEBUG, this, "serial serial");
                LobbyCtrl.instance.serialCodeSend(_serialUserSerialText.text, "");
                _serialUserSerialText.text = "";
                hide();
            };
        }


        private function closeButtonClickHandler(event:Event):void
        {
            hide();
        }

        public  function hide():void
        {
            RemoveChild.apply(this);
            TopView.enable(true);
        }
    }
}
