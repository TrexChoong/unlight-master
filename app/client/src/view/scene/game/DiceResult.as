package view.scene.game
{
    import flash.display.*;
    import flash.events.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.*;
    import view.scene.*;
    import view.image.game.DiceImage;
    

    // ダイスの結果を管理するクラス
    public class DiceResult extends BaseScene
    {
        private var _plDiceImage:Array = [];       // プレイヤー側のあたりダイス
        private var _foeDiceImage:Array = [];      // 相手側のあたりダイス

        private const _PL_DICE_X:int = 270;        // 
        private const _FOE_DICE_X:int = 680;       // 
        private const _DICE_Y:int = 470;           // 
//         private const _PL_DICE_X:int = 300;        // 
//         private const _PL_DICE_X:int = 300;        // 

        // コンストラクタ
        public function DiceResult()
        {
        }

        // ダイスを作成
        public function getResultThread(plDice:Array, plType:int, foeDice:Array, foeType:int):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            var pExec3:ParallelExecutor = new ParallelExecutor();
            var pExec4:ParallelExecutor = new ParallelExecutor();
            var pExec5:ParallelExecutor = new ParallelExecutor();

            _plDiceImage = [];
            _foeDiceImage = [];

            log.writeLog(log.LV_INFO, this, "pldice", plDice);

            // ダイス目の配列の分だけダイスを作成
            for(var i:int = 0; i < plDice.length; i++)
            {
                if(plDice[i] >= 6 || plDice[i] == 1)
                {
                    _plDiceImage.push(new DiceImage(plType));
                    _plDiceImage[_plDiceImage.length-1].x = _PL_DICE_X - ((i%3) * 80);
                    _plDiceImage[_plDiceImage.length-1].y = _DICE_Y - (int(i/3) * 50);
                    pExec.addThread(_plDiceImage[_plDiceImage.length-1].getShowThread(this));
                }
            }
            for(i = 0; i < foeDice.length; i++)
            {
                if(foeDice[i] >= 6 || foeDice[i] == 1)
                {
                    _foeDiceImage.push(new DiceImage(foeType));
                    _foeDiceImage[_foeDiceImage.length-1].x = _FOE_DICE_X - ((i%3) * 80);
                    _foeDiceImage[_foeDiceImage.length-1].y = _DICE_Y - (int(i/3) * 50);
                    pExec.addThread(_foeDiceImage[_foeDiceImage.length-1].getShowThread(this));
                }
            }
            sExec.addThread(pExec);

            // ダイスを中央に移動させる
            for(i = 0; i < _plDiceImage.length; i++)
            {
                pExec2.addThread(new BeTweenAS3Thread(_plDiceImage[i], {x:263+(i%5)*60 ,y:380+int(i/5)*60}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }
            for(i = 0; i < _foeDiceImage.length; i++)
            {
                pExec2.addThread(new BeTweenAS3Thread(_foeDiceImage[i], {x:263+(i%5)*60 ,y:280-int(i/5)*60}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }
            sExec.addThread(pExec2);

            // ダイスにヒットマークを出す
            for(i = 0; i < _plDiceImage.length || i < _foeDiceImage.length; i++)
            {
                if(_plDiceImage[i])
                {
                    if(_foeDiceImage[i])
                    {
                        pExec3.addThread(new ClousureDelayThread(_plDiceImage[i].crash, 100*i));
                        pExec3.addThread(new BeTweenAS3Thread(_plDiceImage[i], {scaleX:1.2 ,scaleY:1.2 ,alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ,i*0.1 ,false));
                    }
                    else
                    {
                        if(plType == 0)
                        {
                            pExec3.addThread(new ClousureDelayThread(_plDiceImage[i].hit, 100*i));
                        }
                    }
                }
                if(_foeDiceImage[i])
                {
                    if(_plDiceImage[i])
                    {
                        pExec3.addThread(new ClousureDelayThread(_foeDiceImage[i].crash, 100*i));
                        pExec3.addThread(new BeTweenAS3Thread(_foeDiceImage[i], {scaleX:1.2 ,scaleY:1.2 ,alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE ,i*0.1 ,false));
                    }
                    else
                    {
                        if(foeType == 0)
                        {
                            pExec3.addThread(new ClousureDelayThread(_foeDiceImage[i].hit, 100*i));
                        }
                    }
                }
            }
            sExec.addThread(pExec3);

//             _plDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec4.addThread(new TweenerThread(item, {alpha:0.0, transition:"easeOutSine", time:0.5, hide:true}))});
//             _plDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec4.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false))});
//             _foeDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec4.addThread(new TweenerThread(item, {alpha:0.0, transition:"easeOutSine", time:0.5, hide:true}))});
//             _foeDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec4.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false))});
//             sExec.addThread(pExec3);

            // お互いのダイスの数が異なる場合、結果を見せる
            if(_plDiceImage.length != _foeDiceImage.length)
            {
                sExec.addThread(new SleepThread(500));
            }

            // ダイスを隠す
//            _plDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec4.addThread(new TweenerThread(item, {alpha:0.0, transition:"easeOutSine", time:0.3, hide:true}))});
            _plDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec4.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false))});
//            _foeDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec4.addThread(new TweenerThread(item, {alpha:0.0, transition:"easeOutSine", time:0.3, hide:true}))});
            _foeDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec4.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false))});
            sExec.addThread(pExec4);

            // ダイスを消去
            _plDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec5.addThread(item.getHideThread())});
            _foeDiceImage.forEach(function(item:*, index:int, array:Array):void{pExec5.addThread(item.getHideThread())});
            sExec.addThread(pExec5);

            return sExec;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }
    }
}


// Duelのロードを待つShowスレッド

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.utils.*;
import org.libspark.thread.Thread;

import model.Duel;
import view.scene.game.DiceResult;
import view.image.game.DiceImage;
import view.BaseShowThread;
import view.BaseHideThread;

class ShowThread extends BaseShowThread
{

    public function ShowThread(dr:DiceResult, stage:DisplayObjectContainer, at:int)
    {
        super(dr, stage)
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
    public function HideThread(dr:DiceResult)
    {
        super(dr);
    }
}

// ディレイつきで関数が呼べるスレッド
class ClousureDelayThread extends Thread
{
    private var _func:Function;
    private var _delay:int;

    public function ClousureDelayThread(func:Function, delay:int)
    {
        _delay = delay;
        _func = func;
    }

    protected override function run():void
    {
        sleep(_delay);
        next(setFanc);
    }

    private function setFanc():void
    {
        _func();
    }

}
