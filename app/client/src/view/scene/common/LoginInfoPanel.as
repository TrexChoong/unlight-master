package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.*;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import view.image.common.*;
    import view.image.quest.*;
    import view.utils.*;
    import view.ClousureThread;
    import view.SleepThread;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;

    /**
     * ログインインフォ表示クラス
     *
     */

    public class LoginInfoPanel extends BaseScene
    {
        // アバター
        private var _avatar:Avatar = Player.instance.avatar;

        // ベースイメージ
        private var _base:LoginInfoImage = new LoginInfoImage();

        // 各種ラベル
        private var _updateMessage:TextArea = new TextArea();    // 更新情報

        private var _title:Label = new Label();     // タイトル
        private var _message:Text = new Text();    // ブラウメッセージ

        // 取得カード
        private var _tCardClip:TreasureCardClip;

        // フェード
        private var _fade:Fade = new Fade(0.1, 0.5);

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MESSAGE	:String = "いらっしゃいませお嬢様。\n本日のボーナスアイテムをお受け取りください。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MESSAGE2	:String = "更新情報";

        CONFIG::LOCALE_EN
        private static const _TRANS_MESSAGE	:String = "Welcome back!\nPlease accept today's bonus item.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MESSAGE2	:String = "Update Information";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MESSAGE	:String = "歡迎光臨大小姐。\n請收下今天的獎勵道具";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MESSAGE2	:String = "更新情報";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MESSAGE	:String = "欢迎光临，小姐。\n请接收今天的奖励道具。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MESSAGE2	:String = "更新信息";

        CONFIG::LOCALE_KR
        private static const _TRANS_MESSAGE	:String = "어서 오십시오.\n 오늘의 보너스 아이템을 받아 주십시오.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MESSAGE2	:String = "갱신 정보";

        CONFIG::LOCALE_FR
        private static const _TRANS_MESSAGE	:String = "Bienvenue, gente dame !\nVeuillez accepter cet objet bonus !";
        CONFIG::LOCALE_FR
        private static const _TRANS_MESSAGE2	:String = "Mise à jour des informations";

        CONFIG::LOCALE_ID
        private static const _TRANS_MESSAGE	:String = "いらっしゃいませお嬢様。\n本日のボーナスアイテムをお受け取りください。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MESSAGE2	:String = "更新情報";

        CONFIG::LOCALE_TH
        private static const _TRANS_MESSAGE :String = "ยินดีต้อนรับครับคุณหนู\nได้โปรดรับโบนัสไอเท็มประจำวันนี้ไว้ด้วยครับ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MESSAGE2    :String = "ข้อมูล Update";


        /**
         * コンストラクタ
         *
         */
        public function LoginInfoPanel()
        {
            super();
            News.instance.addEventListener(Event.CHANGE, setUpdateMessageHandler)
            _updateMessage.visible = false;
        }

        // アップデート情報をセットする
        private function setUpdateMessageHandler(event:Event):void
        {
            var updateText:String = News.newsText;
            _updateMessage.htmlText = updateText;
            _updateMessage.x = 260;
            _updateMessage.y = 200;
            _updateMessage.width = 350;
            _updateMessage.height = 288;
            _updateMessage.styleName = "LoginMessageArea";
            _updateMessage.condenseWhite = true;
            _updateMessage.editable = false;
//             _updateMessage.selectable = false;


            // 読み込んだ内容を元に，更新情報データを作成
            log.writeLog(log.LV_INFO, this, "load HTML data!!!!", _updateMessage.text);
        }

        public function setBonusCard(type:int, cType:int, val:int):void
        {
            if(type == -1)
            {
                _title.text = _TRANS_MESSAGE2;
                _title.x = 310;
                _title.y = 166;
                _title.width = 145;
                _title.height = 30;
                _title.filters = [ new GlowFilter(0x000000, 1, 2, 2, 16, 1) ];
                _title.styleName = "LoginInfoTitle";

                _base.ok.removeEventListener(MouseEvent.CLICK, pushNextHandler);
                _base.ok.addEventListener(MouseEvent.CLICK, pushExitHandler);

                _updateMessage.visible = true;
            }
            else
            {
                _tCardClip = new TreasureCardClip(type,cType,val);
                _tCardClip.x = 375;
                _tCardClip.y = 367;
                _tCardClip.mouseEnabled = false;
                _tCardClip.mouseChildren = false;

                _title.text = "Login Bonus";
                _title.x = 310;
                _title.y = 166;
                _title.width = 145;
                _title.height = 30;
                _title.filters = [ new GlowFilter(0x000000, 1, 2, 2, 16, 1) ];
                _title.styleName = "LoginInfoTitle";

                _message.text = _TRANS_MESSAGE;
                _message.x = 260;
                _message.y = 200;
                _message.width = 300;
                _message.height = 50;
                _message.styleName = "LoginInfoLabel";
                _message.selectable = false;
            }
        }

        public override function init():void
        {
            _base.ok.addEventListener(MouseEvent.CLICK, pushNextHandler);

            _container.addChild(_base);
            _container.addChild(_title);
            _container.addChild(_message);
            _container.addChild(_updateMessage);

            addChild(_container);
        }

        public override function final():void
        {
            if (_tCardClip!=null)
            {
                _tCardClip.getHideThread().start();
            }

            _base.ok.removeEventListener(MouseEvent.CLICK, pushExitHandler);
            _base.ok.removeEventListener(MouseEvent.CLICK, pushExitHandler);

            _container.removeChild(_base);
            _container.removeChild(_title);
            _container.removeChild(_message);
            _container.removeChild(_updateMessage);

            removeChild(_container);
        }

        private function pushNextHandler(e:MouseEvent):void
        {
            if (_tCardClip!=null)
            {
                _tCardClip.getHideThread().start();
            }

            _title.text = _TRANS_MESSAGE2;
            _updateMessage.visible = true;
            _message.visible = false;

            _base.ok.removeEventListener(MouseEvent.CLICK, pushNextHandler);
            _base.ok.addEventListener(MouseEvent.CLICK, pushExitHandler);
        }

        private function pushExitHandler(e:MouseEvent):void
        {
            _base.ok.removeEventListener(MouseEvent.CLICK, pushExitHandler);
            _base.ok.addEventListener(MouseEvent.CLICK, pushNextHandler);

            _container.visible = false;
            _container.mouseEnabled = false;
            _container.mouseChildren = false;
        }


        private function mouseOn():void
        {
            _container.mouseEnabled = true;
            _container.mouseChildren = true;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(_fade.getShowThread(_container, 0));
            sExec.addThread(super.getShowThread(stage, at));
            return sExec;
        }

        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(_fade.getHideThread());
            sExec.addThread(super.getHideThread());
            return sExec;
        }

        public function getBringOnThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            if (_tCardClip!=null)
            {
                sExec.addThread(_tCardClip.getShowThread(_container));
                sExec.addThread(new SleepThread(200));
                sExec.addThread(_tCardClip.getFlipThread());
            }
            return sExec;
        }

    }
}
