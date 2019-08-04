package view.scene.game
{
    import flash.display.*;
    import flash.events.*;

    import org.papervision3d.objects.*;
    import org.papervision3d.objects.parsers.DAE;
    import org.papervision3d.view.*;
    import org.papervision3d.cameras.*;
    import org.papervision3d.render.BasicRenderEngine;

    import org.papervision3d.scenes.Scene3D;
    import org.papervision3d.materials.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import view.utils.*;
    import view.image.game.DeckObject;

    // デッキを管理するクラス
    public class Deck extends BaseScene
    {
        private var _viewport:Viewport3D;
        private var _camera:Camera3D;
        private var _scene:Scene3D;
        private var _renderer:BasicRenderEngine;

        private var _deckObj:DeckObject;
        private var _stage:DisplayObjectContainer;

        private var _num:int = 0; // デッキの残り枚数


        // コンストラクタ
        public function Deck()
        {
            initPV3();
            alpha = 0.0;
            _deckObj = new DeckObject();
        }

        // pv3dの初期化
        private function initPV3():void
        {
            if(_scene == null)
            {
                _scene = new Scene3D();
                _viewport= new Viewport3D(200, 200, false, true, true, true);
                _renderer = new BasicRenderEngine();
                _camera = new Camera3D();
                _camera.x = -5;
                _camera.y = 40;
                _camera.z = 40;
                _camera.focus = 500;
                // _camera.zoom = 0.75;
                _camera.zoom = 0.57;
                _camera.rotationX = 30; // 下向き60度
                _camera.rotationY = 80; // 横向き90度
            }
        }


        // Showスレッドの後処理メソッド
        public override function init():void
        {
            addChild(_viewport);
            _num = 0;
//            addEventListener(Event.ENTER_FRAME,render);
            _scene.addChild(_deckObj.getObject);
        }

        // hideスレッドの後処理メソッド
        public override function final():void
        {
            removeEventListener(Event.ENTER_FRAME,render);
//            removeChild(_viewport);
            _scene.removeChild(_deckObj.getObject);
            RemoveChild.apply(_viewport);
        }

        // デッキを作成
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
//            var deckTween:Thread = new TweenerThread(this, {alpha:1.0, transition:"easeOutSine", time:0.3, show:true});
            var deckTween:Thread = new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
            sExec.addThread(new ShowThread(this, stage, at));
            sExec.addThread(deckTween);
            return sExec;
        }

        // デッキを作成
        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
//            var deckTween:Thread = new TweenerThread(this, {alpha:0.0, transition:"easeOutSine", time:0.3, hide:true});
            var deckTween:Thread = new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
            sExec.addThread(new HideThread(this));
            sExec.addThread(deckTween);
            return sExec;
        }

        // 更新
//        public function render(event:Event):void
        public function render():void
        {
            _deckObj.update(_num);
            _renderer.renderScene( _scene , _camera, _viewport );
        }

        // デッキを1枚増やす
        public function inc():int
        {
            ++_num;
            render();
            return _num;
        }

        // デッキを1枚減らす
        public function dec():int
        {
            --_num;
            render();
            return _num
        }

        // 枚数をセットする
        public function set setNum(num:int):void
        {
            _num = num;
            render();
        }

        // 枚数を取得する
        public function get getNum():int
        {
            return _num;
        }
    }
}

// Duelのロードを待つShowスレッド

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.Duel;
import view.scene.game.Deck;
import view.BaseShowThread;
import view.BaseHideThread;

class ShowThread extends BaseShowThread
{

    public function ShowThread(deck:Deck, stage:DisplayObjectContainer, at:int)
    {
        super(deck, stage)
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
    public function HideThread(deck:Deck)
    {
        super(deck);
     }
}
