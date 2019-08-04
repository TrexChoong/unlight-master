package view.scene.regist
{

    import flash.display.*;
    import flash.events.Event;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.Thread;

    import view.scene.BaseScene;
    import view.utils.*;
    import view.image.regist.*;
    import model.Player;

    /**
     * アバター名入力画面
     *
     */


    public class NameInput extends BaseScene
    {
        // 翻訳データ
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_NAME	:String = "名前を入力してください（3文字以上）";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CODE	:String = "招待コードを入力してください";
        CONFIG::LOCALE_JP
        private static const _TRANS_DIALOG_CODE	:String = "招待コード";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_NAME	:String = "Enter your name. (at least 3 characters)";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CODE	:String = "Please enter invitation code.";
        CONFIG::LOCALE_EN
        private static const _TRANS_DIALOG_CODE	:String = "Invitation code";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_NAME	:String = "請輸入名字。（3個字以上）";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CODE	:String = "請輸入招待碼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DIALOG_CODE	:String = "招待碼";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_NAME	:String = "请输入名字。（不得少于3个字）";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CODE	:String = "请输入招待码";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DIALOG_CODE	:String = "招待码";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_NAME	:String = "이름을 입력해 주세요.(3자 이상)";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CODE	:String = "招待コードを入力してください";
        CONFIG::LOCALE_KR
        private static const _TRANS_DIALOG_CODE	:String = "招待コードを入力してください";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_NAME	:String = "Écrivez votre nom (minimum 3 lettres)";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CODE	:String = "Veuillez taper le code Invitation";
        CONFIG::LOCALE_FR
        private static const _TRANS_DIALOG_CODE	:String = "le code Invitation";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_NAME	:String = "名前を入力してください（3文字以上）";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CODE	:String = "招待コードを入力してください";
        CONFIG::LOCALE_ID
        private static const _TRANS_DIALOG_CODE	:String = "招待コードを入力してください";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_NAME    :String = "กรุณาใส่ชื่อของท่าน (ต้องการตัวอักษร 3 ตัวขึ้นไป)";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CODE	:String = "招待コードを入力してください";
        CONFIG::LOCALE_TH
        private static const _TRANS_DIALOG_CODE	:String = "招待コードを入力してください";

        private var _bg:NameFieldImage = new NameFieldImage();
        private var _nameText:ValidTextInput = new ValidTextInput(true, ValidTextInput.USER_NAME);
        private var _codeText:TextInput = new TextInput();
        private var _code:Text =  new Text();
        private var _enterFunc:Function;

        // ヘルプ用のステート
        private static const _GAME_HELP:int = 0;


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["名前を入力してください。（3文字以上）"],
                [_TRANS_MSG_NAME,_TRANS_MSG_CODE],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private  var _toolTipOwnerArray:Array = [];


        /**
         * コンストラクタ
         *
         */
        public function NameInput()
        {
            _nameText.x = 362;
            _nameText.y = 350;
//            _nameText.y = 590;
            _nameText.width = 174;
            _nameText.height = 21;
            _nameText.styleName = "RegistName";
            _nameText.maxChars = 12;

            _codeText.x = 362;
            _codeText.y = 550;
            _codeText.width = 174;
            _codeText.height = 21;
            _codeText.styleName = "RegistName";
            _codeText.maxChars = 12;
            _codeText.setStyle("backgroundAlpha", "0.5");

            _nameText.restrict = "^ 　\",";
            _nameText.focusEnabled = true;
            _nameText.focusRect = false;

            focusEnabled = true;

            _codeText.restrict = "0-9A-NP-Z";
            _codeText.focusEnabled = true;
            _codeText.focusRect = false;
            _codeText.text = Player.instance.invitedCode;

            addChild(_bg);
            addChild(_nameText);
            addChild(_codeText);
            _nameText.addEventListener(ValidTextInput.VALID_OK,enterHandler);
            _codeText.addEventListener(ValidTextInput.VALID_OK,enterHandler);
            alpha = 0.0;

            _code.x = 417;
            _code.y = 531;;
            _code.width = 100;
            _code.height = 20;
            _code.styleName = "RegistCharaCardInfoLabel";
//          _code.text = "招待コード";
            _code.text = _TRANS_DIALOG_CODE;
            _code.setStyle("color", "#FFFFFF");
            _code.enabled = false;
            _code.alpha = 1.0;
            _code.mouseEnabled = false;
            addChild(_code);

            super();
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  // 本体
            _toolTipOwnerArray.push([1,_codeText]);  // 招待コード
        }

        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }


        public override function init():void
        {
//             log.writeLog(log.LV_INFO, this, "nanndeya", _nameText);
//             Unlight.INS.stage.focus = _nameText;
            _nameText.addEventListener(ValidTextInput.VALID_OK,enterHandler);
            _codeText.addEventListener(ValidTextInput.VALID_OK,enterHandler);
            callLater(_nameText.setFocus);
            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);

        }

        public override function final():void
        {
            _nameText.removeEventListener(ValidTextInput.VALID_OK,enterHandler);
            _codeText.removeEventListener(ValidTextInput.VALID_OK,enterHandler);
            // _enterFunc = null;
        }


        public function get avatarName():String
        {
            return _nameText.text;
        }


        private function enterHandler(e:Event):void
        {
            Player.instance.invitedCode =  _codeText.text;
            if (_nameText.text!="")
            {
                if (_enterFunc != null)
                {
                    _enterFunc();
                }
            }
        }
        public function setEnterFunc(f:Function):void
        {
                _enterFunc = f;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(super.getShowThread(stage,at,type));
//            sExec.addThread(new TweenerThread(this, { alpha: 1.0, transition:"easeOutSine", time: 0.2, show: true}));
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return sExec;
        }
        // 表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
//            sExec.addThread(new TweenerThread(this, { alpha: 0.0, transition:"easeOutSine", time: 0.15, hide: true}));
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.15, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            sExec.addThread(super.getHideThread());
            return sExec;
        }
        public function enterInput():void
        {
            _nameText.validate();
        }

    }

}
