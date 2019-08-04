
package view.image.game
{
    import flash.display.*;

    import org.papervision3d.events.FileLoadEvent;
    import org.papervision3d.objects.parsers.DAE;
    import org.papervision3d.materials.BitmapMaterial;
    import org.papervision3d.materials.utils.MaterialsList;

    import org.libspark.thread.EnterFrameThreadExecutor; // ライブラリ初期化用
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Duel;
    import view.image.BaseObject;
    import controller.*;

    // ダイスオブジェクトのクラス
    public class DiceObject extends BaseObject
    {
        [Embed(source="../../../../public/image/tex/dice_red.png")]
        private static var _red:Class; // 赤ダイスのテクスチャ
        [Embed(source="../../../../public/image/tex/dice.png")]
        private static var _black:Class; // 黒ダイスのテクスチャ
        [Embed(source="../../../../public/image/tex/dice_f.png")]
        private static var _fumble:Class; // 青ダイスのテクスチャ
        [Embed(source="../../../../public/image/tex/dice_c.png")]
        private static var _critical:Class; // 青ダイスのテクスチャ
        [Embed(source="../../../../public/image/dice.dae", mimeType="application/octet-stream")]
        private  static var _path:Class; // daeファイルパス

        private var _eye:int;
        private var _length:int; // 元の配列の番号（同時に出す場合に必要）
        private var _delay:Number; // 出現ディレイ
        private var _type:int; // ダイスの種類

        private var _bmpMaterial:BitmapMaterial;  // ビットマップマテリアル
        // ゲームのコントローラ

        // 段毎で、サイコロの目に対応（１～６）
        private static const _rot:Array = new Array(   0,-90,
                                                       0,  0,
                                                     -90,  0,
                                                      90,  0,
                                                     180,  0,
                                                       0, 90);

        private static var _redBmpMaterial:BitmapMaterial;
        private static var _blackBmpMaterial:BitmapMaterial;

        // コンストラクタ
        public function DiceObject(type:int = 0, subType:int=0, length:int = 0, eye:int = 1, delay:Number = 0)
        {
            var matList:Object = new Object();
            _length = length;
            _eye = eye;
            _delay = delay;
            _type = type;

            // typeに応じたマテリアルを設定
            if(type)
            {
                if (subType)
                {
                    _bmpMaterial = new BitmapMaterial((new _fumble()).bitmapData);
                }
                else
                {
                    _bmpMaterial = new BitmapMaterial((new _red()).bitmapData);
                }
            }
            else
            {
                if (subType)
                {
                    _bmpMaterial = new BitmapMaterial((new _critical()).bitmapData);
                }
                else
                {
                    _bmpMaterial = new BitmapMaterial((new _black()).bitmapData);
                }
            }
            matList = {_Default:_bmpMaterial};

            getObject.load(XML(new _path()), new MaterialsList(matList));


        }

        private static function getBlackBitMaterial():BitmapMaterial
        {
            if(_blackBmpMaterial == null)
            {
                _blackBmpMaterial = new BitmapMaterial((new _black()).bitmapData);;
            }
            return _blackBmpMaterial;
        }
        private static function getRedBitMaterial():BitmapMaterial
        {
            if(_redBmpMaterial == null)
            {
                 _redBmpMaterial = new BitmapMaterial((new _red()).bitmapData);;
            }
                return _redBmpMaterial;
        }

        // ファイルの読み込みと初期値の設定
        override protected function initObject(event:FileLoadEvent):void
        {
            restPosition();
        }

        private function restPosition():void
        {
            _object.z = Math.random() * 50;
            _object.y = 160;
            _object.rotationX = 600;
            _object.rotationY = 0;
            _object.rotationZ = 600;

        }
        public function set delay(delay:Number):void
        {
            _delay = delay;
        }

        public function set eye(e:int):void
        {
            _eye = e;
        }
        public function set length(e:int):void
        {
            _length = e;
            _object.x = Math.random() * 50 + _length * 10;
        }

        public function get getEye():int
        {
            return _eye;
        }

        public function get getType():int
        {
            return _type;
        }

        // 転がり処理（最初に１回呼べばOK）
        public function roll():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();

            _object.visible = false;
            restPosition();
            var diceHideTween:Thread;
            var diceRotTween:Thread;
            var diceJumpTween:Thread = new BeTweenAS3Thread(_object, {y:0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_BOUNCE ,_delay ,true);
            var diceMoveTween:Thread = new BeTweenAS3Thread(_object, {x:Math.random()*10+(_length/3)*20 ,z:Math.random()*10+(_length%3)*20}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ,_delay ,true);

            // 1と6はY回転しない（行列より軽そうなのでこれで）
            if(_eye == 1 || _eye == 6)
            {
                diceRotTween = new BeTweenAS3Thread(_object, {rotationX:_rot[(_eye-1)*2] ,rotationZ:_rot[(_eye-1)*2+1]}, null, 0.5, BeTweenAS3Thread.EASE_IN_OUT_BOUNCE ,_delay ,true);
            }
            else
            {
                diceRotTween = new BeTweenAS3Thread(_object, {rotationX:_rot[(_eye-1)*2] ,rotationY:Math.random()*360 ,rotationZ:_rot[(_eye-1)*2+1]}, null, 0.5, BeTweenAS3Thread.EASE_IN_OUT_BOUNCE ,_delay ,true);
            }
            pExec.addThread(diceJumpTween);
            pExec.addThread(SE.getThrowDiceSEThread(_delay))
            pExec.addThread(diceRotTween);
            pExec.addThread(diceMoveTween);
            sExec.addThread(pExec);
            return sExec;
        }

        // マテリアルリストを消去する
        public function destroy():void
        {
            if (_bmpMaterial != null)
            {
                if (_bmpMaterial.bitmap != null){_bmpMaterial.bitmap.dispose()}
                _bmpMaterial.destroy();
            }
        }
    }
}


import flash.display.*

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.image.game.DiceObject;

// オブジェクトを消去するスレッド
class ObjectDestroyThread extends Thread
{
    private var _object:DiceObject;

    public function ObjectDestroyThread(object:DiceObject)
    {
        _object = object;
    }

    protected override function run():void
    {
        _object
    }
}
