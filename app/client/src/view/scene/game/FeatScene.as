package view.scene.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

	// By_K2 (setTimeout)
	import flash.utils.setTimeout;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.Label;
    import mx.containers.Panel;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import model.Duel;
    import model.Entrant;
    import model.CharaCard;
    import model.events.FeatSceneEvent;

    import view.scene.BaseScene;
    import view.ClousureThread;
    import view.image.game.FeatInfoPanel;
    import controller.*;

    /**
     * 必殺技表示クラス
     *
     */

    public class FeatScene extends BaseScene
    {
		// By_K2
		public static const FEAT_FPS_DOWN:String = "feat_fps_down";
		public static const FEAT_FPS_UP:String = "feat_fps_up";

		private static const _X:int = 0;
        private static const _Y:int = 200;
        private static const _Y_DIF:int = 60;

        // コンテナ
        private var _stage:Sprite;

        // ゲームのコントローラ

        // デュエルインスタンス
        private var _duel:Duel = Duel.instance;

        // 使用したフィートクリップを保管しておく
        private var _featClips:Array = [];

        /**
         * コンストラクタ
         *
         */
        public function FeatScene()
        {
            super();
            visible = true;
        }

        // 初期化
        public override function init():void
        {
            _featClips = [];

            _duel.addEventListener(FeatSceneEvent.PLAYER_FEAT_USE, plFeatUseHandler);
            _duel.addEventListener(FeatSceneEvent.FOE_FEAT_USE, foeFeatUseHandler);
        }

        // 初期化
        public override function final():void
        {
            log.writeLog(log.LV_FATAL, this, "feat clips ", _featClips);
            _featClips.forEach(function(item:*, index:int, array:Array):void{
                    if (item != null)
                    {
                        item.getHideThread().start()
                        }
                        });

            _duel.removeEventListener(FeatSceneEvent.PLAYER_FEAT_USE, plFeatUseHandler);
            _duel.removeEventListener(FeatSceneEvent.FOE_FEAT_USE, foeFeatUseHandler);
        }

        // 必殺技使用時のハンドラ
        public function plFeatUseHandler(e:FeatSceneEvent):void
        {
			// By_K2
			dispatchEvent(new Event(FEAT_FPS_DOWN));
			setTimeout(function ():void { dispatchEvent(new Event(FEAT_FPS_UP)); }, 2500);

            var featClip:FeatClip = FeatClip.getInstance(e.id);
            GameCtrl.instance.addViewSequence(featClip.getShowThread(this));
            featClip.setAnime(true);
            _featClips[e.id] = featClip;
        }

        // 必殺技未使用時のハンドラ
        public function foeFeatUseHandler(e:FeatSceneEvent):void
        {
			// By_K2
			dispatchEvent(new Event(FEAT_FPS_DOWN));
			setTimeout(function ():void { dispatchEvent(new Event(FEAT_FPS_UP)); }, 2500);

            var featClip:FeatClip = FeatClip.getInstance(e.id);
            GameCtrl.instance.addViewSequence(featClip.getShowThread(this));
            featClip.setAnime(false);
            _featClips[e.id] = featClip;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage);
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }


    }
}
// Duelのロードを待つShowスレッド

import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;

import model.Duel;
import view.scene.game.FeatScene;
import view.BaseShowThread;
import view.BaseHideThread;

class ShowThread extends BaseShowThread
{
    private var _fs:FeatScene;

    public function ShowThread(fs:FeatScene, stage:DisplayObjectContainer)
    {
        super(fs, stage)
        _fs = fs;
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
    public function HideThread(fs:FeatScene)
    {
        super(fs);
    }
}
