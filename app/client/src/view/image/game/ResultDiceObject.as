
package view.image.game
{
    import flash.display.*;

    import org.papervision3d.events.FileLoadEvent;
    import org.papervision3d.objects.parsers.DAE;
    import org.papervision3d.materials.BitmapMaterial;
    import org.papervision3d.materials.utils.MaterialsList;

    import org.libspark.thread.EnterFrameThreadExecutor; // ライブラリ初期化用
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseObject;
    import view.SleepThread;

    // ダイスオブジェクトのクラス
    public class ResultDiceObject extends BaseObject
    {
        private static const PATH:String = "../../../../public/image/sixdice.dae"; // ファイルパス
        private var _eye:int;
        private var _length:int; // 元の配列の番号（同時に出す場合に必要）
        private var _delay:Number; // 出現ディレイ

        // 段毎で、サイコロの目に対応（１～６）
        private static const _rot:Array = new Array(   0,-90,
                                                       0,  0,
                                                     -90,  0,
                                                      90,  0,
                                                     180,  0,
                                                       0, 90);

        // コンストラクタ
        public function ResultDiceObject(length:int = 0, eye:int = 1, delay:Number = 0)
        {
            getObject.load(PATH);

            _length = length;
            _eye = eye;
            _delay = delay;
        }

        // ファイルの読み込みと初期値の設定
        override protected function initObject(event:FileLoadEvent):void
        {
            _object.x = Math.random() * 50 + _length * 10;
            _object.z = Math.random() * 50;
            _object.y = 150;
            _object.rotationX = 600;
            _object.rotationY = 0;
            _object.rotationZ = 600;
        }

        public function set setDelay(delay:Number):void
        {
            _delay = delay;
        }

        public function get getEye():int
        {
            return _eye;
        }

        // 転がり処理（最初に１回呼べばOK）
        public function roll():Thread
        {
            var diceHideTween:Thread;
            var diceRotTween:Thread;
//            var diceJumpTween:Thread = new TweenerThread(_object, {y:0, transition:"easeOutBounce", delay:_delay, time:0.5, show:true});
            var diceJumpTween:Thread = new BeTweenAS3Thread(_object, {y:0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_BOUNCE ,_delay ,true);
//            var diceMoveTween:Thread = new TweenerThread(_object, {x:Math.random() * 5 + (_length / 3) * 10, z:Math.random() * 3 + (_length % 3) * 15, transition:"easeOutSine", delay:_delay,  time:0.5, show:true});
            var diceMoveTween:Thread = new BeTweenAS3Thread(_object, {x:Math.random()*5+(_length/3)*10 ,z:Math.random()*3+(_length%3)*15}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ,_delay ,true);
            var pExec:ParallelExecutor = new ParallelExecutor();

            // 1と6はY回転しない（行列より軽そうなのでこれで）
            if(_eye == 1 || _eye == 6)
            {
//                diceRotTween = new TweenerThread(_object, {rotationX:_rot[(_eye-1)*2], rotationZ:_rot[(_eye-1)*2+1], transition:"easeInOutBounce", delay:_delay, time:0.5, show:true});
                diceRotTween = new BeTweenAS3Thread(_object, {rotationX:_rot[(_eye-1)*2] ,rotationZ:_rot[(_eye-1)*2+1]}, null, 0.5, BeTweenAS3Thread.EASE_IN_OUT_BOUNCE ,_delay ,true);
            }
            else
            {
//                diceRotTween = new TweenerThread(_object, {rotationX:_rot[(_eye-1)*2], rotationY:Math.random() * 360, rotationZ:_rot[(_eye-1)*2+1], transition:"easeInOutBounce", delay:_delay, time:0.5, show:true});
                diceRotTween = new BeTweenAS3Thread(_object, {rotationX:_rot[(_eye-1)*2] ,rotationY:Math.random()*360 ,rotationZ:_rot[(_eye-1)*2+1]}, null, 0.5, BeTweenAS3Thread.EASE_IN_OUT_BOUNCE ,_delay ,true);
            }
            // 時間合わせ用の空スレッド
//            diceHideTween = new TweenerThread(_object, {transition:"easeOutBounce", delay:_delay * 0.2 + 0.2, time:0.2, show:true});
//            diceHideTween = new BeTweenAS3Thread(_object, {}, null, 0.2, BeTweenAS3Thread.EASE_OUT_BOUNCE ,_delay*0.2+0.2 ,true);
            diceHideTween = new SleepThread((_delay * 0.2 + 0.2)*1000)

            pExec.addThread(diceHideTween);
            pExec.addThread(SE.getThrowDiceSEThread(_delay+0.1))
            pExec.addThread(diceRotTween);
            pExec.addThread(diceMoveTween);
            pExec.addThread(diceJumpTween);
            return pExec;
        }

        // 消滅処理
        public function hide():Thread
        {
//            var hideTween:Thread = new TweenerThread(_object, {alpha:0.0, transition:"easeOutSine", time:0.2, hide:true});
            var hideTween:Thread = new BeTweenAS3Thread(_object, {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(hideTween);
            return pExec;
        }
    }
}
