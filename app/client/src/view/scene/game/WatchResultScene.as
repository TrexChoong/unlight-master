package view.scene.game
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Duel;
    import view.ClousureThread;
    import view.SleepThread;
    import view.image.game.*;
    import view.scene.BaseScene;
    import view.utils.RemoveChild;
    import controller.*;


    /**
     * WatchResultScene表示クラス
     *
     */
    public class WatchResultScene extends BaseScene
    {

        private var _resultImage:ResultImage;
        private var _container:UIComponent = new UIComponent();
        private var _watchResultPanel:WatchResultPanel = new WatchResultPanel();

        private var _duel:Duel = Duel.instance;

        private var _resultLabel:Label = new Label();

        private static const _IMAGE_X:int = Unlight.WIDTH/2;  // Win/Lose表示X
        private static const _IMAGE_Y:int = 195;              // Win/Lose表示Y

        private static const _POS_X:int   = 0;
        private static const _POS_Y:int   = 0;
        private static const _START_X:int = 1500;
        private static const _END_X:int   = -1500;

        private static const _LABEL_X:int = 325;
        private static const _LABEL_Y:int = 389;
        private static const _LABEL_W:int = 180;
        private static const _LABEL_H:int = 50;

        /**
         * コンストラクタ
         *
         */
        public function WatchResultScene()
        {
            super();
        }

        public override function init():void
        {
            _watchResultPanel.x = _START_X;
            _watchResultPanel.y = _POS_Y;
            _watchResultPanel.alpha = 0.0;
            _watchResultPanel.visible = true;
            addChild(_watchResultPanel);
            addChild(_container);

            labelInit();
        }

        public function labelInit():void
        {
            _resultLabel.x = _LABEL_X;
            _resultLabel.y = _LABEL_Y;
            _resultLabel.width  = _LABEL_W;
            _resultLabel.height = _LABEL_H;
            _resultLabel.setStyle("fontSize", 20);
            _resultLabel.setStyle("textAlign", "center");
            _resultLabel.filters  = [new GlowFilter(0xFFFFFF, 1, 4, 4, 16, 1),
                                     new DropShadowFilter(5, 270, 0xFFFFFF, 0.3, 8, 8, 1, 1, true),
                                     new DropShadowFilter(2, 70, 0xFFFFFF, 0.7, 1, 1, 1, 1, false)];
            _resultLabel.text = "";

            _watchResultPanel.addChild(_resultLabel);
        }

        public override function final():void
        {
            // WIN/LOSEを消す
            if (_resultImage != null)
            {
                _resultImage.getHideThread().start();
            }
            RemoveChild.apply(_resultLabel);
            RemoveChild.apply(_watchResultPanel);
            RemoveChild.apply(_container);
        }

        public function getShowResultThread(winnerName:String):Thread
        {
            // リザルトイメージ
            var result:int = (winnerName!="") ? Const.DUEL_RESULT_WIN : Const.DUEL_RESULT_DRAW;
            _resultImage = new ResultImage(ResultImage.RESULT_IDX[result]);
            _resultImage.x = _IMAGE_X;
            _resultImage.y = _IMAGE_Y;

            _watchResultPanel.alpha = 1.0;
            _resultLabel.text = winnerName.replace("_rename","");
            var sExec:SerialExecutor = new SerialExecutor();
            var pShowExec:ParallelExecutor = new ParallelExecutor();
            var pHideExec:ParallelExecutor = new ParallelExecutor();
            pShowExec.addThread(_resultImage.getShowThread(_container));
            if (result == Const.DUEL_RESULT_WIN) {
                pShowExec.addThread(new BeTweenAS3Thread(_watchResultPanel,{x:_POS_X}, {x:_START_X}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            }
            sExec.addThread(pShowExec);
            sExec.addThread(new SleepThread(3000));
            if (result == Const.DUEL_RESULT_WIN) {
                pHideExec.addThread(new BeTweenAS3Thread(_watchResultPanel,{x:_END_X}, {x:_POS_X}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            }
            pHideExec.addThread(_resultImage.getHideThread());
            sExec.addThread(pHideExec);
            sExec.addThread(new ClousureThread(function():void{_resultLabel.text="";}));
            return sExec;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return  new ShowThread(this, stage);
        }

    }
}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.utils.*;
import org.libspark.thread.Thread;

import model.Duel;
import view.scene.BaseScene;
import view.scene.game.WatchResultScene;
import view.BaseShowThread;
import view.BaseHideThread;

// Duelのinitを待つShowスレッド
class ShowThread extends BaseShowThread
{
    private var _sc:BaseScene;

    public function ShowThread(sc:BaseScene, stage:DisplayObjectContainer)
    {
        _sc = sc;
        super(sc,stage)
    }

    protected override function run():void
    {
        // ロードを待つ
        if (Duel.instance.inited == false)
        {
            Duel.instance.wait();
        }
        next(close);
    }

}
