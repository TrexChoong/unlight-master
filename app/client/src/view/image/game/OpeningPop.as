package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Dialogue;
    import model.Player;
    import view.ClousureThread;
    import view.SleepThread;
    import view.image.BaseImage;
    import view.scene.common.DialogueTextField;

    /**
     * 会話部分の表示枠クラス
     *
     */
    public class OpeningPop extends BaseImage
    {
        // result表示元SWF
        [Embed(source="../../../../data/image/game/opening/op_hukidashi.swf")]
        private var _Source:Class;

        private static const _PL_DIALOGUE_X:int = 50;
        private static const _PL_DIALOGUE_Y:int = 30;

        private static const _FOE_DIALOGUE_X:int = 435;
        private static const _FOE_DIALOGUE_Y:int = 30;

        private static const DIALOGUE_WIDTH:int = 290;
        private static const DIALOGUE_HEIGHT:int = 180;

        private static const _DIALOGUE_WAIT:int = 300; // ms
        private static const _DIALOGUE_DELAY:int = 500; // ms

        private var _plDialogue:DialogueTextField = new DialogueTextField();
        private var _foeDialogue:DialogueTextField = new DialogueTextField();
        private static const _PL_BALOON:String = "hukidasi_p";
        private static const _FOE_BALOON:String = "hukidasi_e";

        private var _plBaloon:MovieClip;
        private var _foeBaloon:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function OpeningPop()
        {
            _plDialogue.height = DIALOGUE_HEIGHT;
            _plDialogue.width = DIALOGUE_WIDTH;
            _foeDialogue.height = DIALOGUE_HEIGHT;
            _foeDialogue.width = DIALOGUE_WIDTH;
            _plDialogue.x = _PL_DIALOGUE_X;
            _plDialogue.y = _PL_DIALOGUE_Y;
            _foeDialogue.x = _FOE_DIALOGUE_X;
            _foeDialogue.y = _FOE_DIALOGUE_Y;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _root.gotoAndStop(0);
            _root.visible = false;
            _plBaloon = MovieClip(_root.getChildByName(_PL_BALOON));
            _foeBaloon = MovieClip(_root.getChildByName(_FOE_BALOON));
            _plBaloon.visible = false;
            _foeBaloon.visible = false;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function getAnimeThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var sExec2:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            sExec.addThread(new GoToPlayThread(_root));
            var pl_str:String = Dialogue.instance.content;
            var pl_did:int = Dialogue.instance.ID;
            var pl_type:int = Dialogue.instance.type;

            if (pl_str.length!=0)
            {
                _plBaloon.visible = true;
                _plDialogue.htmlText = pl_str;
                addChild(_plDialogue.transionBitmap);
                sExec.addThread(new ClousureThread((function():void{_root.visible = true})));
                sExec.addThread(new SleepThread(_DIALOGUE_WAIT));
                pExec.addThread(_plDialogue.getAutoTransitSentenceThread());
                if (pl_did > 0) {
                    pExec.addThread(new ClousureThread(Voice.playDialogueVoice, [pl_did]));
                }
            }

            var foe_str:String = Dialogue.instance.content;
            var foe_did:int = Dialogue.instance.ID;
            var foe_type:int = Dialogue.instance.type;

            if (foe_str.length!=0)
            {
                _foeBaloon.visible = true;
                _foeDialogue.htmlText = foe_str;
                addChild(_foeDialogue.transionBitmap);
                if (pl_str.length==0)
                {
                    sExec2.addThread(new ClousureThread((function():void{_root.visible = true})));
                }
                sExec2.addThread(new SleepThread(_DIALOGUE_DELAY));
                sExec2.addThread(_foeDialogue.getAutoTransitSentenceThread());
                pExec.addThread(sExec2);
            }
            sExec.addThread(pExec);
            return sExec;
        }

        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(this, {y:-150 ,alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            return pExec;
        }
    }
}

import flash.display.*
import flash.events.Event;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

class GoToPlayThread extends Thread
{
    private var _mc:MovieClip;

    public function GoToPlayThread(mc:MovieClip)
    {
        _mc = mc;
    }

    protected override function run():void
    {
        _mc.gotoAndPlay(1);
        _mc.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function enterFrameHandler(e:Event):void
    {
        if (_mc.currentFrame == _mc.totalFrames-1)
        {
            _mc.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            _mc.stop();
        }
    }
}
