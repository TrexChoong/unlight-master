
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
    import view.image.game.DiceObject;
    import view.SleepThread;
    import view.utils.*;
    

    // 複数のダイスを管理するクラス
    public class DiceManager extends BaseScene
    {
        private  var _viewport:Viewport3D;
        private  var _camera:Camera3D;
        private  var _scene:Scene3D;
        private  var _renderer:BasicRenderEngine;

        private var _eyeArray:Array = [4, 3, 1, 5, 2, 6]; // ダイスの目をここに保管すればOK！

//        private var _avatarPartClip:Vector.<AvatarPartClip > = new Vector.<AvatarPartClip>();
        private var _redDiceSet:Vector.<DiceObject> = new Vector.<DiceObject>();
        private var _fumbleDiceSet:Vector.<DiceObject> = new Vector.<DiceObject>();
        private var _blackDiceSet:Vector.<DiceObject> = new Vector.<DiceObject>();
        private var _criticalDiceSet:Vector.<DiceObject> = new Vector.<DiceObject>();
        private var _diceArray:Array = [[_redDiceSet, _fumbleDiceSet], [_blackDiceSet, _criticalDiceSet]];
        private var _arrayPtr:Array = [[0,0],[0,0]];
        private var _stage:Sprite;

        private var _type:int;
        private var _currentAttackType:int;

        private  function initPV3():void
        {
            if (_scene ==null)
            {
            _scene = new Scene3D();
            _viewport = new Viewport3D(300,300,true,true);
            _renderer = new BasicRenderEngine();
            _camera = new Camera3D();
            _camera.x = -10;
            _camera.y = 120;
            _camera.z = 50;
            _camera.focus = 500;
            _camera.zoom = 0.8;
            _camera.rotationX = 60; // 下向き60度
            _camera.rotationY = 90; // 横向き90度
            }
        }

        // コンストラクタ
        public function DiceManager(stage:Sprite, type:int = 0)
        {
            _stage = stage;
            init3D();
            alpha = 0.0;
            _type = type;
            if (type == 0)
            {
                x = -330
                y = 20
            }
            else
            {
                x = 120
                y = -20
            }
        }

        // ダイスを作成
        public function getRollDiceThread(attack:int):Thread
        {
            _currentAttackType = attack;
            _stage.addChild(this);
            _stage.addEventListener(Event.ENTER_FRAME,render);
            var pExec:ParallelExecutor = new ParallelExecutor();
            var diceManagerTween:Thread = new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
            pExec.addThread(diceManagerTween);
            var diceObj:DiceObject;
            // ダイス目の配列の分だけダイスを作成
            for(var i:int = 0; i < _eyeArray.length; i++)
            {
                diceObj = getDiceObj(i, attack, _eyeArray[i], i*0.05);
                _scene.addChild(diceObj.getObject);
                pExec.addThread(diceObj.roll());
            }
            return pExec;
        }

        private function getDiceObj(i:int, type:int, eye:int=1, delay:Number=0):DiceObject
        {
            var subType:uint = 0;
            if (eye > 0 && 7 > eye)
            {
                subType = 0;
            }
            else if (eye < 1)
            {
                subType = 1;
                eye = 2;
            }
            else if (eye > 6)
            {
                subType = 1;
                eye = 6;
            }

            if (i == 0)
            {
                // ダイスアレイに追加する際のインデックスを示すポインタ
                _arrayPtr[type][subType] = [[0,0],[0,0]];
            }

            var retObj:DiceObject;
            if (_diceArray[type][subType].length - _arrayPtr[type][subType] > 0)
            {
                _diceArray[type][subType][i].eye = eye;
                _diceArray[type][subType][i].delay = delay;
                retObj = _diceArray[type][subType][i];
            }
            else
            {
                retObj = new DiceObject(type,subType,i,eye,delay);
                _diceArray[type][subType].push(retObj);
            }

            _arrayPtr[type][subType] += 1;
            return retObj;

        }

        // ダイスを隠す
        public function getHideDiceThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            sExec.addThread(new HideThread(this));
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

        public function get eyeArray():Array
        {
            return _eyeArray;
        }

        public function get type():int
        {
            return _type;
        }

        public function finish3D():void
        {
            _stage.removeEventListener(Event.ENTER_FRAME, render);
            for(var subType:uint=0; subType < 2; subType++)
            {
                for(var i:uint=0; i < _diceArray[_currentAttackType][subType].length; i++)
                {
                    _scene.removeChild(_diceArray[_currentAttackType][subType][i].getObject);
                }
            }
            _stage.removeChild(this);

        }
        public function destroy():void
        {
            for(var i:int = 0; i < _redDiceSet.length; i++){
                _redDiceSet[i].destroy();
            }
            for(i = 0; i < _blackDiceSet.length; i++){
                _blackDiceSet[i].destroy();
            }
            for(i = 0; i < _fumbleDiceSet.length; i++){
                _fumbleDiceSet[i].destroy();
            }
            for(i = 0; i < _criticalDiceSet.length; i++){
                _criticalDiceSet[i].destroy();
            }
            _redDiceSet.length = 0;
            _blackDiceSet.length = 0;
            _fumbleDiceSet.length = 0;
            _criticalDiceSet.length = 0;
            RemoveChild.all(this);
            _scene = null;
            _viewport = null;
            _renderer = null;
            _camera = null;

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

import view.scene.game.DiceManager

// 基本的なスレッド
class HideThread extends Thread
{
    private var _dm:DiceManager;

    public function HideThread(dm:DiceManager)
    {
        _dm = dm;
        name = "dice manager"
    }

    protected override function run():void
    {
        _dm.finish3D();
    }
}


// Moveモードへ
