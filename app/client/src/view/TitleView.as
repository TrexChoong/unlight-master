package view
{
    import flash.filters.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.containers.Panel;
    import mx.controls.*;
    import mx.core.UIComponent;
    import mx.core.*;
    import mx.managers.*;

    import mx.events.StateChangeEvent;
    import mx.controls.textClasses.TextRange;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import net.server.*;

    import model.Player;
    import controller.*;
    import view.image.title.*;
    import view.utils.*;

    /**
     * タイトル画面のビュークラス
     *
     */


    public class TitleView extends Thread
    {
        private var _stage:Sprite;

        private var _bg:BG;
        private var _logo:Logo;
        private var _ageha:Ageha;

        private var _loginPanel:LoginPanel;
        private var _newsPanel:NewsPanel;

        private var _copyRight:Label = new Label();

        private var _container:UIComponent = new UIComponent(); // 表示コンテナ
        private var _ctrl:TitleCtrl;


        private var _userPassText:TextInput = new TextInput();

        private var _hide:Function;

        // ロビービュースレッド
        private var _lobbyView:LobbyView;

        private var _player:Player = Player.instance;

        // OpensocialのID
        private var _uId:String;

        /**
         * コンストラクタ
         * @param stage 親ステージ
         *
         */
        public function TitleView(stage:Sprite)
        {
//            Unlight.GCWOn();
            _stage = stage;
            _ctrl = TitleCtrl.instance;

            _copyRight.text =   "Copyright 2010 TECHWAY All Rights Reserved. "+"ver"+Unlight.VERSION+"_d";
            _copyRight.styleName = "FeatInfoLabel";
            _copyRight.width = 490;
            _copyRight.height = 30;
            _copyRight.x = 260;
            _copyRight.y = 645;
            _copyRight.visible = false;
            _copyRight.alpha = 0;

            _loginPanel = new LoginPanel();
            Unlight.INS.addChild(_loginPanel); // 気持ち悪いが一時的処理

                _newsPanel = new NewsPanel();
            _container.addChild(_newsPanel);

            _userPassText.width = 100;
            _userPassText.height = 10;
            _userPassText.styleName = "GameChatInput";
            _userPassText.x =100;
            _userPassText.y =100;


        }
        private function init():void
        {

            _bg = new BG();
            _container.addChildAt(_bg, 0);
            _bg.visible = false;
            _bg.alpha = 0;
            _logo = new Logo();
            _container.addChild(_logo.BG1);
            _container.addChild(_logo.BG2);
            _container.addChild(_logo);
            _container.addChild(_copyRight);

            _ageha = new Ageha();
            _container.addChild(_ageha);

        }

        private function final():void
        {

            RemoveChild.apply(_bg);
            RemoveChild.apply(_logo.BG1);
            RemoveChild.apply(_logo.BG2);
            RemoveChild.apply(_logo);
            RemoveChild.apply(_copyRight);
            RemoveChild.apply(_ageha);
            _bg = null;
            _logo = null;
            _ageha = null;
            log.writeLog(log.LV_FATAL, this, "ALLREMOVE", _bg,_ageha);

        }



        // スレッドのスタート
        override protected  function run():void
        {
            next(show);
        }

        // パネル類を出す
        private function show():void
        {
            init();
            GameServer.instance.exit();
            _stage.addChildAt(_container,1);
            _ctrl.playBGM();
            _lobbyView = new LobbyView(_stage);
            _logo.resetPosition();
            _loginPanel.panelEditable(true);

            var loginTween:Thread = new BeTweenAS3Thread(_loginPanel, {alpha:1.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
            var newsTween:Thread = new BeTweenAS3Thread(_newsPanel, {alpha:0.8}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
            var bgTween:Thread = new BeTweenAS3Thread(_bg, {alpha:1.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
            var logoTween:Thread = new BeTweenAS3Thread(_logo, {alpha:1.0}, null, 3.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
            var logoBG1Tween:Thread = new BeTweenAS3Thread(_logo.BG1, {alpha:0.7}, null, 2.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE ,0.8 / Unlight.SPEED ,true );
            var logoBG2Tween:Thread = new BeTweenAS3Thread(_logo.BG2, {alpha:0.7}, null, 2.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE ,0.8  / Unlight.SPEED,true );
            var crTween:Thread = new BeTweenAS3Thread(_copyRight, {alpha:1.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(loginTween);
            pExec.addThread(newsTween);
            pExec.addThread(bgTween);
            pExec.addThread(logoTween);
            pExec.addThread(logoBG1Tween);
            pExec.addThread(logoBG2Tween);
            pExec.addThread(crTween);
            pExec.start();
            // 終了を待つ
            pExec.join();
            // アゲハの移動を追加
            _stage.addEventListener(Event.ENTER_FRAME,_ageha.mouseOverHandler);
            //
            // 待機へ
            next(waiting);
        }

        // 待機
        private function waiting():void
        {
            // 認証がすでに終了している場合
            if (_player.state == Player.STATE_LOGIN)
            {
                next(hide);
            }else{
                next(waiting);
            }

        }


        // 認証のハンドラ
        private function authHandler(event:Event):void
        {
            next(hide);
        }

        // 終了
        private function hide():void
        {
            _stage.removeEventListener(Event.ENTER_FRAME,_ageha.mouseOverHandler);
            _ctrl.stopBGM();

            var logoTween:Thread = new BeTweenAS3Thread(_logo, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_IN_SINE, 0.0 ,false );
            var loginTween:Thread = new BeTweenAS3Thread(_loginPanel, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
            var newsTween:Thread = new BeTweenAS3Thread(_newsPanel, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
            var bgTween:Thread = new BeTweenAS3Thread(_bg, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
            var logoBG1Tween:Thread = new BeTweenAS3Thread(_logo.BG1, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
            var logoBG2Tween:Thread = new BeTweenAS3Thread(_logo.BG2, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
            var agehaTween:Thread = new BeTweenAS3Thread(_ageha, {y:-200}, null, 5.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
            var crTween:Thread = new BeTweenAS3Thread(_copyRight, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(loginTween);
            pExec.addThread(newsTween);
            pExec.addThread(bgTween);
            pExec.addThread(logoBG1Tween);
            pExec.addThread(logoBG2Tween);
            pExec.addThread(crTween);
            pExec.start();
            logoTween.start();
            agehaTween.start();
            pExec.join();
            next(toLobby);
        }

        // ロビー画面へ
        private function toLobby():void
        {

            Unlight.INS.loadingStart();
            _stage.removeChild(_container);
            log.writeLog (log.LV_INFO,this,"lobby start");
            _lobbyView.start();
            _lobbyView.join();
            next(show);
            final();
            _bg = null;
            _logo = null;
            _ageha = null;

            interrupted(pushOut);
        }

        // 強制終了割り込み
        private function pushOut():void

        {
            _lobbyView.interrupt();
            _lobbyView.join();
            next(show);
        }

        // 終了関数
        override protected  function finalize():void
        {
            _stage.removeEventListener(Event.ENTER_FRAME,_ageha.mouseOverHandler);
            log.writeLog (log.LV_WARN,this,"title end");
        }

    }

}