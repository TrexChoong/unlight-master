package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;
    import flash.utils.escapeMultiByte;
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;

    import mx.core.UIComponent;
    import mx.controls.*;
    import mx.containers.*;
    import mx.events.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import view.scene.BaseScene;
    import view.image.lobby.*;
    import view.ItemListView;
    import model.Player;

    /**
     * イベント情報パネル表示クラス
     *
     */

    public class NewInvitePanel extends BaseScene
    {
        CONFIG::LOCALE_JP
        private static const _TRANS_INVITE_MSG1		:String = "ゴシックバトルカードゲームUnlight　特典付き招待コード [";
        CONFIG::LOCALE_JP
        private static const _TRANS_INVITE_MSG2_1	:String = "\n\nあなたの招待コードは\n";
        CONFIG::LOCALE_JP
        private static const _TRANS_INVITE_MSG2_2	:String = "]\nコードを共有して友達を招待しよう";
        CONFIG::LOCALE_JP
        private static const _TRANS_LINKCOPY		:String = "Linkをコピー";

        CONFIG::LOCALE_EN
        private static const _TRANS_INVITE_MSG1		:String = "Gothic Card Battling Game Unlight with invitation code to special privileges [";
        CONFIG::LOCALE_EN
        private static const _TRANS_INVITE_MSG2_1	:String = "\n\nYour invitation code is \n";
        CONFIG::LOCALE_EN
        private static const _TRANS_INVITE_MSG2_2	:String = "]\nShare your invitation code to invite friends.";
        CONFIG::LOCALE_EN
        private static const _TRANS_LINKCOPY		:String = "Copy Link";

        CONFIG::LOCALE_TCN
        private static const _TRANS_INVITE_MSG1		:String = "哥德式戰鬥卡片遊戲Unlight  附贈特典招待碼 [";
        CONFIG::LOCALE_TCN
        private static const _TRANS_INVITE_MSG2_1	:String = "\n\n你的邀請代碼是\n";
        CONFIG::LOCALE_TCN
        private static const _TRANS_INVITE_MSG2_2	:String = "]\n分享代碼來邀請朋友吧";
        CONFIG::LOCALE_TCN
        private static const _TRANS_LINKCOPY		:String = "複製連結";

        CONFIG::LOCALE_SCN
        private static const _TRANS_INVITE_MSG1		:String = "哥特式卡片战斗游戏Unlight  附赠特典的邀请码 [";
        CONFIG::LOCALE_SCN
        private static const _TRANS_INVITE_MSG2_1	:String = "\n\n你的邀请代码是\n";
        CONFIG::LOCALE_SCN
        private static const _TRANS_INVITE_MSG2_2	:String = "]\n分享代码来邀请朋友吧";
        CONFIG::LOCALE_SCN
        private static const _TRANS_LINKCOPY		:String = "複製连结";

        CONFIG::LOCALE_KR
        private static const _TRANS_INVITE_MSG1		:String = "ゴシックバトルカードゲームUnlight　特典付き招待コード [";
        CONFIG::LOCALE_KR
        private static const _TRANS_INVITE_MSG2_1	:String = "\n\nあなたの招待コードは\n";
        CONFIG::LOCALE_KR
        private static const _TRANS_INVITE_MSG2_2	:String = "]\nコードを共有して友達を招待しよう";
        CONFIG::LOCALE_KR
        private static const _TRANS_LINKCOPY		:String = "Linkをコピー";

        CONFIG::LOCALE_FR
        private static const _TRANS_INVITE_MSG1		:String = "Code Invitation spécial au jeu de cartes gothique Unlight [";
        CONFIG::LOCALE_FR
        private static const _TRANS_INVITE_MSG2_1	:String = "\n\nVotre Code Invitation est\n";
        CONFIG::LOCALE_FR
        private static const _TRANS_INVITE_MSG2_2	:String = "].\nPartagez votre code et invitez vos amis.";
        CONFIG::LOCALE_FR
        private static const _TRANS_LINKCOPY		:String = "Copier le lien";

        CONFIG::LOCALE_ID
        private static const _TRANS_INVITE_MSG1		:String = "ゴシックバトルカードゲームUnlight　特典付き招待コード [";
        CONFIG::LOCALE_ID
        private static const _TRANS_INVITE_MSG2_1	:String = "\n\nあなたの招待コードは\n";
        CONFIG::LOCALE_ID
        private static const _TRANS_INVITE_MSG2_2	:String = "]\nコードを共有して友達を招待しよう";
        CONFIG::LOCALE_ID
        private static const _TRANS_LINKCOPY		:String = "Linkをコピー";

        CONFIG::LOCALE_TH
        private static const _TRANS_INVITE_MSG1		:String = "ゴシックバトルカードゲームUnlight　特典付き招待コード [";
        CONFIG::LOCALE_TH
        private static const _TRANS_INVITE_MSG2_1	:String = "\n\nあなたの招待コードは\n";
        CONFIG::LOCALE_TH
        private static const _TRANS_INVITE_MSG2_2	:String = "]\nコードを共有して友達を招待しよう";
        CONFIG::LOCALE_TH
        private static const _TRANS_LINKCOPY		:String = "Linkをコピー";


        private var _panel:TitleWindow = new TitleWindow();

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();
        private var _text1:TextArea = new TextArea();
        private var _text2:TextArea = new TextArea();

        private static const _START_X:int = Unlight.WIDTH / 2 - 120;
        private static const _START_Y:int = Unlight.HEIGHT / 2 - 120;
//        private static const _MSG:String = escapeMultiByte("ゴシックバトルカードゲームUnlight　特典付き招待コード [") +"__CODE__"+escapeMultiByte("]") ;
        private static const _MSG:String = escapeMultiByte(_TRANS_INVITE_MSG1) +"__CODE__"+escapeMultiByte("]") ;
        public static const SET_URL_BASE:String = "orig";
        public static const TWITTER_URL:String = "<p><a href=\"https://twitter.com/intent/tweet?text=__MSG__&hashtags=unlight&url=__URL__\" target=\"_blank\"><img src=\"./public/twitter_alt.png\" width=\"32\" height=\"32\" ></a>\n".replace("__MSG__",_MSG).replace("__URL__",SET_URL_BASE);

        private var _hBox:HBox = new HBox();
        private var _lhBox:HBox = new HBox();
        private var _rhBox:HBox = new HBox();
        private var _spacer1:Spacer = new Spacer();
        private var _h2Box:HBox = new HBox();
        private var _spacer2:Spacer = new Spacer();
        private var _linkButton:Button = new Button();


        /**
         * コンストラクタ
         *
         */
        public function NewInvitePanel()
        {
            setAllParam();
            super();
        }
        private function setAllParam():void
        {
            width = 240;
            height = 260;
            _panel.x = _START_X;
            _panel.y = _START_Y;
            _panel.alpha = 0.0;
            _panel.width = 260;
            _panel.height = 250;
            _panel.showCloseButton = true;
            _panel.title = "Invite Code";
            _panel.layout = "vertical";

            _text1.percentWidth = 100;
            _text1.percentHeight = 90;

            _text1.htmlText = Player.instance.getInviteID();
//            _text1.htmlText = "\n\nあなたの招待コードは\n" +"[ " + Player.instance.getInviteID() + " ]\nコードを共有して友達を招待しよう";
            _text1.htmlText = _TRANS_INVITE_MSG2_1 +"[ " + Player.instance.getInviteID() + _TRANS_INVITE_MSG2_2;
            _text1.editable = false;
            _text1.styleName = "NewsTextArea";
            _text1.setStyle("textAlign",  "center");

//            _linkButton.label = "Linkをコピー";
            _linkButton.label = _TRANS_LINKCOPY;
            _linkButton.addEventListener(MouseEvent.CLICK,buttonClickHandler);

            _panel.addChild(_text1);
            _panel.addChild(_h2Box);
            _panel.addChild(_hBox);
            _hBox.percentWidth = 100;
            _hBox.percentHeight = 100;
            _hBox.addChild(_lhBox);
            _hBox.addChild(_text2);
            _hBox.addChild(_rhBox);

            _h2Box.addChild(_spacer1);
            _h2Box.addChild(_linkButton);
            _h2Box.addChild(_spacer2);

            _lhBox.percentWidth = 100;
            _lhBox.percentHeight = 100;
            _rhBox.percentWidth = 60;
            _rhBox.percentHeight = 100;

            _h2Box.percentWidth = 100;
            _h2Box.percentHeight = 20;
            _spacer1.percentWidth = 100;
            _spacer1.percentHeight = 100;
            _spacer2.percentWidth = 100;
            _spacer2.percentHeight = 100;

            _text2.percentWidth = 100;
            _text2.percentHeight = 100;
            _text2.editable = false;
            _text2.styleName = "NewsTextArea";
            _text2.setStyle("textAlign",  "center");
            _text1.setStyle("paddingBottom", "0");
            _text2.setStyle("paddingBottom", "0");
            _text1.setStyle("paddingTop", "0");
            _text2.setStyle("paddingTop", "0");

            // _text2.width = 100;
            // _text2.x = 40;
            // _text2.y =100;
            // _text2.height = 80;
            _text2.htmlText = Player.instance.getInviteID();
            var _code:RegExp = /__CODE__/g;
            _text2.htmlText = "" + TWITTER_URL.replace(_code,Player.instance.getInviteID()) ;


            CONFIG::LOCALE_SCN
            {
                _hBox.percentHeight = 0;
                _lhBox.percentHeight = 0;
                _rhBox.percentHeight = 0;
                _text2.htmlText = "";
                _panel.height = 180;
            }
        }

        private function buttonClickHandler(e:MouseEvent):void
        {
            SE.playClick();
            var _code:RegExp = /__CODE__/g;
            var clipboard : Clipboard = Clipboard.generalClipboard;
            var str:String = SET_URL_BASE..replace(_code,Player.instance.getInviteID())
            clipboard.setData(ClipboardFormats.TEXT_FORMAT , str);
        }


        public override function init():void
        {
            log.writeLog (log.LV_DEBUG,this,"!!!Set Close Func!");
            // _panel.setCloseFunc(hide);
            _panel.addEventListener(CloseEvent.CLOSE, closeButtonClickHandler)
            // _container.addChild(_panel);
            // addChild(_container);

        }

        private function closeButtonClickHandler(event:Event):void
        {
            hide();
        }


        public function show():void
        {
            // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
            BetweenAS3.serial(
                BetweenAS3.addChild(_panel, Unlight.INS.topContainer.parent),
                BetweenAS3.to(_panel,{x:_START_X,y:_START_Y,alpha:1.0},0.05, Quad.easeOut)
                ).play();
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            _panel.addEventListener(CloseEvent.CLOSE, closeButtonClickHandler)
            // _panel.setCloseFunc(hide);
        }

        private function hide():void
        {
            log.writeLog (log.LV_DEBUG,this,"Info Close Click!");
            BetweenAS3.serial(
                BetweenAS3.tween(_panel, {alpha:0.0}, null, 0.05, Sine.easeOut),
                BetweenAS3.removeFromParent(_panel)
                ).play()
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
        }

    }
}
