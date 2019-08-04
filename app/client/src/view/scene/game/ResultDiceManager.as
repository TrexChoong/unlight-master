
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

    import view.image.game.ResultDiceObject;
    import view.SleepThread;


    // 複数のダイスを管理するクラス
    public class ResultDiceManager extends ResultDiceObject
    {
        private var _viewport:Viewport3D;
        private var _camera:Camera3D;
        private var _scene:Scene3D;
        private var _renderer:BasicRenderEngine;

        private var _eyeArray:Array = [4, 3, 1, 5, 2, 6]; // ダイスの目をここに保管すればOK！
        private var _diceArray:Array = [];
        private var _stage:Sprite;

        private var _type:int;

        private  function initPV3():void
        {
            if (_scene ==null)
            {
            _scene = new Scene3D();
            _viewport = new Viewport3D(300,300,true,true);
//           __viewport.opaqueBackground = 0xFFFFFF;
            _renderer = new BasicRenderEngine();

            _camera = new Camera3D();
            _camera.x = 0;
            _camera.y = 60;
            _camera.z = 27;
            _camera.focus = 500;
            _camera.zoom = 1;
            _camera.rotationX = 90; // 下向き60度
            _camera.rotationY = 90; // 横向き90度
            }
        }
        // コンストラクタ
        public function ResultDiceManager(stage:Sprite)
        {
            _stage = stage;
            _stage.addChild(this);
            init3D();
            alpha = 0.0;

            x = 60;
            y = 35;
        }

        // ダイスを作成
        public function getRollDiceThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
//            var diceManagerTween:Thread = new TweenerThread(this, { alpha: 1.0, transition:"easeOutSine", time: 0.1, show: true } );
            var diceManagerTween:Thread = new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
            var sExec:SerialExecutor = new SerialExecutor();

            // 前回のダイスを消す
            finish3D();

            _stage.addEventListener(Event.ENTER_FRAME,render);
            pExec.addThread(diceManagerTween);
            _diceArray = [];
            // ダイス目の配列の分だけダイスを作成
            for(var i:int = 0; i < _eyeArray.length; i++)
            {
                _diceArray.push(new ResultDiceObject(i, _eyeArray[i]));
                _diceArray[i].setDelay = i * 0.05;
                _scene.addChild(_diceArray[i].getObject);
                pExec.addThread(_diceArray[i].roll());
            }
            sExec.addThread(pExec);
            sExec.addThread(new SleepThread(100));
            return sExec;
        }


        public function init3D():void
        {
            initPV3();
            addChild(_viewport);
        }
        // 上に同じ
        public function render(event:Event):void
        {
            _renderer.renderScene( _scene , _camera, _viewport );
        }

        public function set eyeArray(a:Array):void
        {
            _eyeArray = a;
        }

        public function set diceType(type:int):void
        {
            _type = type;
        }

        public function finish3D():void
        {
            alpha = 0;
            visible = false;
            _stage.removeEventListener(Event.ENTER_FRAME, render);
            for(var i:int; i < _diceArray.length; i++)
            {
                _scene.removeChild(_diceArray[i].getObject);
            }
        }
    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import mx.core.UIComponent;
import mx.containers.*;
import mx.controls.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.scene.game.ResultDiceManager

// 基本的なスレッド
class HideThread extends Thread
{
    private var _rdm:ResultDiceManager;

    public function HideThread(rdm:ResultDiceManager)
    {
        _rdm = rdm;
        name = "resuldi mane"
    }

    protected override function run():void
    {
        _rdm.finish3D();
    }
}


// Moveモードへ
