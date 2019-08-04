package view
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Rectangle;
    import flash.geom.*;

    import org.libspark.thread.Thread;

    import com.flashdynamix.utils.SWFProfiler;

    import model.Player;
    import model.Option;
    import controller.*;

    import view.RaidHelpView;


    /**
     * メインのビュークラス
     * 他のビュークラススレッドの親になって管理する
     *
     */

    public class MainView extends Thread
    {
        private var _stage:Sprite; // 親ステージ
        private var _titleView:TitleView; // タイトルビュー
        private var _testView:TestView; // テストビュー
        private var _container:Sprite = new Sprite(); // 表示コンテナ

        private var _raidHelpView:RaidHelpView = RaidHelpView.instance;

        // 背景イメージのBG
        private var _bg:Shape = new Shape();

        // ゲームオプション
        private var _option:Option = Option.instance;

        // コンストラクタ
        public function MainView(stage:Sprite)
        {
            log.writeLog(log.LV_INFO, this, "Main Start");
            _stage = stage;
            // 背景シェイプを作成
            _bg.graphics.beginFill(0x000000);
            _bg.graphics.drawRect(0, 0, Unlight.WIDTH, Unlight.HEIGHT);
            _bg.graphics.endFill();
            _container.addChildAt(_bg,0);
            _stage.addChildAt(_container,0);
            log.writeLog(log.LV_INFO, this, "Main Finish");
        }

        // スレッドのスタート
        CONFIG::DEBUG
        override protected function run():void
        {
            log.writeLog(log.LV_INFO, this, "Main RUN DEBUG");
           _titleView = new TitleView(_stage);
            SWFProfiler.init(_stage.stage, _stage); // プロファイラの登録。ここでないとStageが帰ってこない･･･。
            next(configWait)
        }

        CONFIG::RELEASE
        override protected function run():void
        {
            log.writeLog(log.LV_INFO, this, "Main RUN RELEASE");
           _titleView = new TitleView(_stage);
           next(configWait);
        }

        // コンフィグの読み込みを待つ
        private function configWait():void
        {
            log.writeLog(log.LV_INFO, this, "Main Config wait");
            if (!Config.instance.loaded)
            {
                Config.instance.wait();
            }
            next(startTitle);
        }

        private function startTitle():void
        {
            _titleView.start();
            _raidHelpView.start();

            _stage.stage.fullScreenSourceRect = new Rectangle(0,0, Unlight.WIDTH,Unlight.HEIGHT);
            _stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownFunc);
            // 標準のパースを設定
            _stage.root.transform.perspectiveProjection.projectionCenter = new Point(_stage.stage.stageWidth / 2, _stage.stage.stageHeight / 2);
            _stage.root.transform.perspectiveProjection.fieldOfView = 15;

        }






        CONFIG::DEBUG
        private function KeyDownFunc(event:KeyboardEvent):void
        {
            if(event.keyCode == 123)
            {
                log.writeLog(log.LV_FATAL, this, "F12:フルスクリーンモードに移行",_stage.stage.stageWidth,_stage.stage.stageHeight);
                log.writeLog(log.LV_FATAL, this, "F12:フルスクリーンモードに移行",_stage.stage.width,_stage.stage.height);
                _stage.stage.displayState = StageDisplayState.FULL_SCREEN;
            }

            if(event.keyCode == 112)
            {
                log.writeLog(log.LV_FATAL, this, "F1:ヘルプ設定を切り替える");
                _option.help = !_option.help;
            }
            if(event.keyCode == 113)
            {
                log.writeLog(log.LV_FATAL, this, "F2:強制GC");
                Unlight.GCWCheckNow();
            }
            if(event.keyCode == 114)
            {
                log.writeLog(log.LV_FATAL, this, "F3:デバッグインフォの表示切り替え");
                Unlight.INS.debugInfoVisibleToggle();
            }
            if(event.keyCode == 115)
            {
                log.writeLog(log.LV_FATAL, this, "F4:デバッグコードを送る（相手に10ダメージ）");
                GameCtrl.instance.sendDebugCode(Const.DEBUG_CODE_ENEMY_DAMEGE_10);
            }
            if(event.keyCode == 116)
            {
                log.writeLog(log.LV_FATAL, this, " F5:デバッグコードを送る（自分に1ダメージ）");
                GameCtrl.instance.sendDebugCode(Const.DEBUG_CODE_SELF_DAMAGE_1);
            }
            if(event.keyCode == 117)
            {
                log.writeLog(log.LV_FATAL, this, "F6:デバッグコードを送る（ターンを残り1に）");
                GameCtrl.instance.sendDebugCode(Const.DEBUG_CODE_SET_LAST_TURN);
            }
            if(event.keyCode == 118)
            {
                log.writeLog(log.LV_FATAL, this, "F7:デバッグコードを送る（全員のHPをすべてのこり1に）");
                GameCtrl.instance.sendDebugCode(Const.DEBUG_CODE_ALL_HP_REMAIN_1);
            }
            if(event.keyCode == 119)
            {
                log.writeLog(log.LV_FATAL, this, "F8:デバッグコードを送る（自分のカードすべてにダメージ1）");
                GameCtrl.instance.sendDebugCode(Const.DEBUG_CODE_SELF_ALL_DAMAGE_1);
            }
            if(event.keyCode == 120)
            {
                log.writeLog(log.LV_FATAL, this, "F9:ヘルプを送る");
                var name:String = Player.instance.avatar.name;
                GlobalChatCtrl.instance.addHelpList(Player.instance.id.toString(),name+"Msg"+generateRandHash);
            }

        }
        private function get generateRandHash():String
        {
            var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var num_chars:Number = chars.length - 1;
            var randomChar:String = "";
            for (var i:Number = 0; i < 8; i++){
                randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
            }
            return randomChar;
        }

        CONFIG::RELEASE
        private function KeyDownFunc(event:KeyboardEvent):void
        {
            if(event.keyCode == 123)
            {
                _stage.stage.displayState = StageDisplayState.FULL_SCREEN;
            }

            if(event.keyCode == 112)
            {
                log.writeLog(log.LV_FATAL, this, "F1:ヘルプ設定を切り替える");
                _option.help = !_option.help;
            }
        }


    }
}
