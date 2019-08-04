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
    import mx.core.UIComponent;

    import view.image.BaseImage;
    import view.utils.RemoveChild;

    import controller.GlobalChatCtrl;

    import model.Option;

    /**
     *  レイドヘルプ送信確認パネル
     *
     */

    public class RaidHelpSendPanel extends Panel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "ログイン中のユーザに救援信号を出しますか？";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "個";

        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Confirm";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "Do you want to send a distress signal for help from other online players?";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = " pieces";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "要向上線中的其他玩家發出求救信號嗎?";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "個";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "确认";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "要向线上的其他玩家发出求救信号吗？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "个";

        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "이 아이템을 구입하겠습니까?";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "個";

        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Souhaitez-vous envoyer un appel de détresse aux joueurs en ligne ?";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = " pièce";

        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "ログイン中のユーザに救援信号を出しますか？";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "個";

        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM :String = "ตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "จะซื้อไอเท็มนี้หรือไม่?";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "ชิ้น";

        // タイトル表示
        private var _text:TextField = new TextField();
        //private var _text:Label = new Label();

        // 決定ボタン
        private var _yesButton:Button = new Button();
        private var _noButton:Button = new Button();

        private var _playerId:int = 0;
        private var _prfHash:String = "";

        private var _closeFunc:Function;

        private var _container:UIComponent = new UIComponent();

        private const _X:int      = 255;
        private const _Y:int      = 230;
        private const _WIDTH:int  = 250;
        private const _HEIGHT:int = 150;
        private const _TEXT_X:int = 13;
        private const _TEXT_Y:int = 50;
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
        public function RaidHelpSendPanel()
        {
            super();

            layout = "absolute"
            title = _TRANS_CONFIRM;

            _text.text = _TRANS_MSG;
            _text.wordWrap = true;
            _text.multiline = true;
            _text.textColor = 0xFFFFFF;

            _yesButton.label = "Yes";

            _noButton.label = "No";

            setPos();

            _container.addChild(_text);
            addChild(_yesButton);
            addChild(_noButton);
            addChild(_container);

            visible = false;
        }

        private function setPos():void
        {
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
        }

        public function setCloseFunc(f:Function):void
        {
            _closeFunc = f;
        }

        private function yesButtonClickHandler(e:MouseEvent):void
        {
            if (_playerId != 0) {
                GlobalChatCtrl.instance.addHelpList(_playerId.toString(),_prfHash);
            }
            if (_closeFunc != null) {
                _closeFunc();
            }
        }
        private function noButtonClickHandler(e:MouseEvent):void
        {
            hide();
            if (_closeFunc != null) {
                _closeFunc();
            }
        }

        public function show(plId:int,prfHash:String):void
        {
            _yesButton.addEventListener(MouseEvent.CLICK,yesButtonClickHandler);
            _noButton.addEventListener(MouseEvent.CLICK,noButtonClickHandler);
            _playerId = plId;
            _prfHash = prfHash;
            visible = true;
        }
        public function hide():void
        {
            _yesButton.removeEventListener(MouseEvent.CLICK,yesButtonClickHandler);
            _noButton.removeEventListener(MouseEvent.CLICK,noButtonClickHandler);
            _playerId = 0;
            _prfHash = "";
            visible = false;
        }
    }
}

