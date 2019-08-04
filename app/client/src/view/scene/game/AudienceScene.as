package view.scene.game
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.filters.*;
    import flash.filters.GradientBevelFilter;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.CharaCard;
    import model.Duel;
    import model.Entrant;
    import model.events.DamageEvent;
    import view.ClousureThread;
    import view.image.game.*;
    import view.scene.BaseScene;
    import view.utils.RemoveChild;
    import controller.*;



    /**
     * AudienceScene表示クラス
     *
     */


    public class AudienceScene  extends BaseScene
    {
        // 観戦待機表示
        private var _watchWaitImage:WatchWaitImage = new WatchWaitImage();
        private var _viewWaitImage:Boolean = false;

        private var _duel:Duel = Duel.instance;

        /**
         * コンストラクタ
         *
         */
        public function AudienceScene()
        {
            super();
        }

        public override function init():void
        {
            _watchWaitImage.alpha = 1.0;
            _watchWaitImage.visible = false;

            addChild(_watchWaitImage);
        }

        public override function final():void
        {
            RemoveChild.apply(_watchWaitImage);
        }


        //Show 実画面に表示するスレッドを返す
        public function getShowWaitImageThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            if ( _duel.isWatch ) {
                // sExec.addThread(new BeTweenAS3Thread(_watchWaitImage,{alpha:1.0}, {alpha:0.0}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
                // sExec.addThread(new ClousureThread(function():void{_viewWaitImage = true}));
                sExec.addThread(new ClousureThread(function():void{_watchWaitImage.visible = true}));
            }
            return sExec;
        }
        public function getHideWaitImageThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            if ( _duel.isWatch ) {
                sExec.addThread(new ClousureThread(function():void{_watchWaitImage.visible = false}));
                // sExec.addThread(new BeTweenAS3Thread(_watchWaitImage,{alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0, false ));
                // sExec.addThread(new ClousureThread(function():void{_viewWaitImage = false}));
            }
            return sExec;
        }
        public function showWaitImage():void
        {
            _watchWaitImage.alpha = 1.0;
            _watchWaitImage.visible = true;
        }
        public function hideWaitImage():void
        {
            _watchWaitImage.alpha = 0.0;
            _watchWaitImage.visible = false;
        }

        public function getBringOnThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            return sExec;
        }

        // 消去するスレッドを返す
        public function getBringOffThread():Thread
        {
            var sExec:ParallelExecutor = new ParallelExecutor();
            return sExec;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return  new ShowThread(this, stage);
        }

        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new HideThread(this));
            var pExec:ParallelExecutor = new ParallelExecutor();
            if ( _duel.isWatch ) {
                pExec.addThread(new ClousureThread(function():void{_watchWaitImage.alpha = 0.0}));
                sExec.addThread(pExec);
            }
            return sExec;
        }
    }
}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.utils.*;
import org.libspark.thread.Thread;

import model.Duel;
import view.scene.BaseScene;
import view.scene.game.AudienceScene;
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

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(audienceScene:AudienceScene)
    {
        super(audienceScene);
    }
}

