package view.scene.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.core.UIComponent;
    import mx.controls.*

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.AvatarItemEvent;

    import view.SleepThread;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.utils.*;
    import view.image.game.*;
    import view.scene.item.WindowItemListPanel;
    import controller.*;

    /**
     * 結果表示クラス
     *
     */
    public class QuestResultScene extends ResultScene
    {

        /**
         * コンストラクタ
         *
         */
        public function QuestResultScene()
        {
            super();
        }


//         public override function setReward(r:Reward):void
//         {
//             _reward = r;
//             _reward.addEventListener(Reward.FINAL_RESULT, cancelResultHandler);
//         }



        // 共通のリザルトスレッドを返す
        public override function getResultThread(result:int, gems:int, exp:int, expBonus:int, gemsPow:int, expPow:int, totalGems:int, totalExp:int):Thread
        {
            // log.writeLog(log.LV_FATAL, this, "QUEST getResultThread!!!!!!!!!!!!!!!!!!!!!!!", _duel.bonus);
            if(_duel.bonus)
            {
                // log.writeLog(log.LV_FATAL, this, "goto parent func.");
                return super.getResultThread(result, gems, exp, expBonus, gemsPow, expPow, totalGems, totalExp);

            }else{
                // log.writeLog(log.LV_FATAL, this, "play current func.");
                _frame.showExpAndGem();


                addChild(_container);

                // フレームを初期化する
                _frame.initializeResult();

                _result = result;
                // 表示スレッド
                var sExec:SerialExecutor = new SerialExecutor();

                // キャライメージ
                _standChara = new StandCharaImage(true, _duel.playerCharaCard.standImage);
                _standChara.x = -500;
                _standChara.y = 0;
                _standChara.visible = false;
                _standChara.getShowThread(_container,0);
                _container.addChildAt(_standChara, 1);


                // リザルトイメージ
                _resultImage = new ResultImage(ResultImage.RESULT_IDX[result]);
                _resultImage.x = _IMAGE_X;
                _resultImage.y = _IMAGE_Y;
//            _resultImage.setAnime();
//            sExec.addThread(_resultImage.getResultThread(result));

                // 経験値とジェムを保管する
                setResult(gems,exp,expBonus,gemsPow,expPow,totalGems,totalExp);

                if (_result == _WIN)
                {
                    sExec.addThread(SE.getWinSEThread(0));
                }else{
                    sExec.addThread(SE.getLoseSEThread(0));

                }
                // スレッドを足す
                sExec.addThread(new FadeThread(_fade));

                sExec.addThread(_resultImage.getShowThread(_container));

                // Frameのロードを待つ
                sExec.addThread(_frame.getWaitCompleteThread());

                // 新しいリザルト表示（EXP他を最初に出す）
                // フレームのtextresultを出す
                _frame.visible = true;
                sExec.addThread(_frame.getTextResultShowThread(_baseGems,_baseExp,_expBonus,_gemsPower,_expPower,_gems,_exp,_result));
                sExec.addThread(_frame.getExpAndGemsShowThread());

                
                log.writeLog(log.LV_FATAL, this, "QUEST RESULT THREAD", _exp,_result);
                _levelupCount = Player.instance.avatar.levelUpNum(_exp);
                // 新しいリザルト表示（レベルアップ表示）
                if (_levelupCount > 0) {
                    sExec.addThread(_levelUpImage.getPlayThread(_levelupCount));
                }


                // 新しいリザルト（ボタンのハンドラーを付け直す）
                _resultButton.removeEventListener(MouseEvent.CLICK,resultButtonHandler);
                _resultButton.addEventListener(MouseEvent.CLICK,finishResultButtonHandler);

                // 新しいリザルト表示（ボタン表示）
                // _resultButton.x = _RESULT_BUTTON_X;
                // _resultButton.y = _RESULT_BUTTON_Y;
                sExec.addThread(new ObjectShowThread(_resultButton));
                sExec.addThread(new ClousureThread(function():void{_resultButton.buttonEnabled = true}));


                // sExec.addThread(new FrameShowThread(_frame));

                // sExec.addThread(_frame.getFadeThread());

                // log.writeLog(log.LV_FATAL, this, "level up num is", _levelupCount, exp);

                // // Rewardのスレッド
                sExec.addThread(new ClousureThread(_standChara.upImage));
                sExec.addThread(new BeTweenAS3Thread(_standChara, {x:0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));


                // sExec.addThread(getResultCancelThread(_reward.gettedCards));


                // ダブルアップのスレッドを返す
//            sExec.addThread(getInitRewardThread(_reward.gettedCards, _reward.cards1, _reward.cards2, _reward.cards3));

//             // 表示スレッド
//             var sExec:SerialExecutor = new SerialExecutor();

                // // キャライメージ
                // _standChara = new StandCharaImage(true, _duel.playerCharaCard.standImage);
                // _standChara.x = -500;
                // _standChara.y = -100;
                // _standChara.visible = false;
                // _container.addChildAt(_standChara, 1);


//             // リザルトイメージ
//             _resultImage = new ResultImage(result);
//             _resultImage.x = _IMAGE_X;
//             _resultImage.y = _IMAGE_Y;


//             // 経験値とジェムを保管する
//             setResult(gems, exp);

//             if (_result == _WIN)
//             {
//                 sExec.addThread(SE.getWinSEThread(0));
//             }else{
//                 sExec.addThread(SE.getLoseSEThread(0));

//             }
//              // スレッドを足す
//              sExec.addThread(new FadeThread(_fade));

//              sExec.addThread(_resultImage.getShowThread(_container));


//               sExec.addThread(new FrameShowThread(_frame));

//               sExec.addThread(_frame.getWaitCompleteThread());
//               sExec.addThread(_frame.getFadeThread());

                // Rewardのスレッド
                // sExec.addThread(new ClousureThread(_standChara.upImage));
                // sExec.addThread(new BeTweenAS3Thread(_standChara, {x:0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));

//                 sExec.addThread(_frame.getResultThread());
//                 sExec.addThread(new LabelShowThread(_gemsLabel));
//                 sExec.addThread(new LabelShowThread(_expLabel));
//                 sExec.addThread(new ObjectShowThread(_resultButton));
//                 sExec.addThread(new ClousureThread(function():void{_resultButton.buttonEnabled = true}));
                return sExec;
            }
        }


        // ハイローをやめた時のスレッド返す
        public override function getResultCancelThread(getCard:Array,totalGems:int,totalExp:int,addPoint:int):Thread
        {
            if (_duel.bonus)
            {
                return super.getResultCancelThread(getCard,totalGems,totalExp,addPoint);
            }else{
                var sExec:SerialExecutor = new SerialExecutor();
                var pExec:ParallelExecutor = new ParallelExecutor();
                var pExec2:ParallelExecutor = new ParallelExecutor();
                sExec.addThread(_frame.getQuestResultThread());

                // ジェムと経験値を表示
                sExec.addThread(new ObjectShowThread(_resultButton));
                sExec.addThread(new ClousureThread(function():void{_resultButton.buttonEnabled = true}));

                return sExec;
            }
        }

        // キャンセル（確定）ハンドラ
        protected override function cancelResultHandler(e:Event):void
        {
            if (_duel.bonus)
            {
                super.cancelResultHandler(e);
            }else{
                GameCtrl.instance.addViewSequence(getResultCancelThread(_reward.gettedCards,_reward.totalGems,_reward.totalExp,_reward.addPoint));
            }
        }


    }

}

import flash.display.*

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;
import org.libspark.thread.threads.between.BeTweenAS3Thread;
import mx.controls.*
import mx.core.UIComponent;

import view.image.game.ResultFrame;
import view.scene.game.ResultDiceManager;
import controller.*;


class FadeThread extends Thread
{
    private var _fs:DisplayObject;

    public function FadeThread(fs:DisplayObject)
    {
        _fs = fs;
    }
    protected override function run():void
    {
        _fs.visible = true;
//        var thread:Thread = new TweenerThread(_fs, {alpha:0.5, transition:"easeOutSine", time:0.5, show:true});
        var thread:Thread = new BeTweenAS3Thread(_fs, {alpha:0.5}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();
        next(waiting);
    }

    private function waiting():void
    {
        log.writeLog(log.LV_FATAL, this, "aaaaaaaaa fade is gone");
    }

    private function exit():void
    {

    }
}

class FrameShowThread extends Thread
{
    private var _fr:ResultFrame;

    public function FrameShowThread(fr:ResultFrame)
    {
        _fr = fr;
    }
    protected override function run():void
    {
        next(waiting);
    }

    private function waiting():void
    {
        _fr.visible  =false;
//        var thread:Thread = new TweenerThread(_fr, {alpha:1, transition:"easeOutSine", time:1, show:true});
        var thread:Thread = new BeTweenAS3Thread(_fr, {alpha:1}, null, 1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();
    }

    private function exit():void
    {

    }
}

class ObjectShowThread extends Thread
{
    private var _object:DisplayObject;

    public function ObjectShowThread(object:DisplayObject)
    {
        _object = object;
    }

    protected override function run():void
    {
        _object.visible = false;
        _object.alpha = 0.0;
//        var thread:Thread = new TweenerThread(_object, {alpha:1, transition:"easeOutSine", time:0.5, show:true});
        var thread:Thread = new BeTweenAS3Thread(_object, {alpha:1}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();

        next(waiting);
    }

    private function waiting():void
    {
    }

    private function exit():void
    {
    }
}

class ObjectHideThread extends Thread
{
    private var _object:DisplayObject;

    public function ObjectHideThread(object:DisplayObject)
    {
        _object = object;
    }

    protected override function run():void
    {
//        var thread:Thread = new TweenerThread(_object, {alpha:0, transition:"easeOutSine", time:0.5, hide:true});
        var thread:Thread = new BeTweenAS3Thread(_object, {alpha:0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
        thread.start();
        thread.join();

        next(waiting);
    }

    private function waiting():void
    {
    }
}
class LabelShowThread extends Thread
{
    private var _label:Label;

    public function LabelShowThread(label:Label)
    {
        _label = label;
    }

    protected override function run():void
    {
        var sExec:SerialExecutor = new SerialExecutor();
        var pExec:ParallelExecutor = new ParallelExecutor();
        var text:String = ""; // 現在のテキスト
        var num:Array = [];
        var count:int = 0;

        // テキストを1の桁からバラバラにして配列に格納
        for(var i:int = _label.text.length-1; i >= 0; i--)
        {
            num.push(int(_label.text.charAt(i)));
        }

        // テキストを空にして表示させる
        _label.text = "";
        _label.visible = true;
        _label.alpha = 1.0;

        //
        for(i = 0; i < num.length; i++)
        {
            // ランダム表示
            for(count = 0; count < 10; count++)
            {
//                 sExec.addThread(SE.getGemSEThread(0));
//                 sExec.addThread(new TextThread(_label, String(int(count)+text)));
//                 pExec.addThread(SE.getGemSEThread(0.08*count));
                pExec.addThread(new TextThread(_label, String(int(count)+text), 80*count));
            }
            text = String(num[i]) + text;
//             pExec.addThread(SE.getGemSEThread(0.08*11));

            pExec.addThread(new TextThread(_label, text,11*80));
            sExec.addThread(pExec);

        }

        // ランダム表示
        for(var j:int = 0; j < 10; j++)
        {
            pExec.addThread(SE.getGemSEThread(0.08*j));
        }


        sExec.start();
        sExec.join();
        next(waiting);
    }

    private function waiting():void
    {
    }

    private function exit():void
    {
    }
}

class TextThread extends Thread
{
    private var _label:Label;
    private var _text:String;
    private var _wait:int;
    public function TextThread(label:Label, text:String, wait:int = 0)
    {
        _label = label;
        _text = text;
        _wait = wait;
    }

    protected override function run():void
    {
        sleep(_wait);
        next(text)

    }
    private function text():void
    {
        _label.text = _text;
    }}

class SetRollNumThread extends Thread
{
    private var _fr:ResultFrame;
    private var _num:int;

    public function SetRollNumThread(fr:ResultFrame, num:int)
    {
        log.writeLog(log.LV_INFO, this, "set Roll num Thread!!!!", num);
        _fr = fr;
        _num = num;
    }

    protected override function run():void
    {
        _fr.setRollNum(_num);
    }
}

class FinishDiceThread extends Thread
{
    private var _rm:ResultDiceManager;

    public function FinishDiceThread(rm:ResultDiceManager)
    {
        _rm = rm;
    }

    protected override function run():void
    {
        _rm.finish3D();
    }
}

