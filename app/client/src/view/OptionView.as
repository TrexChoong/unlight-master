package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;
    import mx.core.MovieClipLoaderAsset;
    import mx.containers.*;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Player;
    import model.events.*;

    import view.image.option.*;
    import view.scene.common.*;
    import view.utils.*;

    import net.server.LobbyServer;

    import controller.GlobalChatCtrl;
    /**
     * Option画面のビュークラス
     *
     */

    public class OptionView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_TITLE	:String = "オプション設定";

        CONFIG::LOCALE_EN
        private static const _TRANS_TITLE	:String = "Options";

        CONFIG::LOCALE_TCN
        private static const _TRANS_TITLE	:String = "選項設定";

        CONFIG::LOCALE_SCN
        private static const _TRANS_TITLE	:String = "选项设定";

        CONFIG::LOCALE_KR
        private static const _TRANS_TITLE	:String = "옵션 설정";

        CONFIG::LOCALE_FR
        private static const _TRANS_TITLE	:String = "Paramètres";

        CONFIG::LOCALE_ID
        private static const _TRANS_TITLE	:String = "オプション設定";

        CONFIG::LOCALE_TH
        private static const _TRANS_TITLE   :String = "ตั้งค่า Option";


        // 親ステージ
        private var _stage:Sprite;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        private var _bg:BG = new BG();
        private var _helpPanel:HelpPanel = new HelpPanel();
        private var _soundPanel:SoundPanel = new SoundPanel();

        private var _exitButton:Button = new Button();

        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // アバタービュー
        private var _avatarView:AvatarView;

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 100;
        private const _TITLE_HEIGHT:int = 40;
        private var _player:Player = Player.instance;

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */
        public function OptionView(stage:Sprite)
        {
            _stage = stage;

            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_MATCH);

            _container.addChild(_bg);
            _container.addChild(_helpPanel);
            _container.addChild(_soundPanel);
            _container.addChild(_exitButton);

            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);

//             Unlight.GCWOn();
//             Unlight.GCW.watch(_bg);
//             Unlight.GCW.watch(_helpPanel);
//             Unlight.GCW.watch(_soundPanel);
//             Unlight.GCW.watch(_exitButton);

            RaidHelpView.instance.isUpdate = true;
        }

        // スレッドのスタート
        override protected  function run():void
        {

            // イベントの登録
            next(initTitle);
        }

        // タイトルの初期化
        private function initTitle():void
        {
            _title.x = _TITLE_X;
            _title.y = _TITLE_Y;
            _title.width = _TITLE_WIDTH;
            _title.height = _TITLE_HEIGHT;
            _title.text = "Option";
            _title.styleName = "EditTitleLabel";
            _title.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _title.alpha = 0.0;

            _titleJ.x = _TITLE_X + 85;
            _titleJ.y = _TITLE_Y + 7;
            _titleJ.width = _TITLE_WIDTH;
            _titleJ.height = _TITLE_HEIGHT;
//            _titleJ.text = "オプション設定";
            _titleJ.text = _TRANS_TITLE;
            _titleJ.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _titleJ.alpha = 0.0;

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            next(show);
        }

        // 配置オブジェの表示
        private function show():void
        {
            _stage.addChild(_container);

            _stage.addChild(_title);
            _stage.addChild(_titleJ);

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getShowThread(_container));
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:1.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:1.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            pExec.start();
            pExec.join();

            next(show2);
        }

        // 配置オブジェの表示
        private function show2():void
        {

            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.start();
            pExec.join();

            next(waiting);
        }

        // ループ
        private function waiting():void
        {
            if (_player.state == Player.STATE_LOGOUT ||_player.state == Player.STATE_LOBBY )
            {
                next(hide);
            }
            else
            {
                next(waiting);
            }

        }


        // 終了
        private function exitButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            _player.state = Player.STATE_LOBBY;
            log.writeLog(log.LV_INFO, this, "push exit");
        }

        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _player.state = Player.STATE_LOBBY;
        }

        private function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            next(hide2);
        }

        // 配置オブジェの表示
        private function hide2():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getHideThread());

            pExec.start();
            pExec.join();

            next(exit);
        }


        private function exit():void
        {
            // イベントの消去

            log.writeLog(log.LV_INFO, this, "edit exit");
        }

        // 終了関数
        override protected function finalize():void
        {
            _stage.removeChild(_title);
            _stage.removeChild(_titleJ);
            _stage.removeChild(_container);
            RemoveChild.all(_container);
            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            // レイドヘルプイベント
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);
            log.writeLog (log.LV_WARN,this,"option end");
            _helpPanel.final();
            _soundPanel.final();

            _bg = null;
            _helpPanel = null;
            _soundPanel = null;
            _exitButton = null;

        }

   }

}
