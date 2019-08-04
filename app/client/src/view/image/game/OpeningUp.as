package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Dialogue;
    import view.ClousureThread;
    import view.SleepThread;
    import view.image.BaseImage;
    import view.scene.common.DialogueTextField;

    /**
     * 会話部分の表示枠クラス
     *
     */
    public class OpeningUp extends BaseImage
    {
        // result表示元SWF
        [Embed(source="../../../../data/image/game/opening/op_up.swf")]
        private var _Source:Class;

//         // result表示元SWF
//         [Embed(source="../../../../data/image/op_up.swf")]
//         private var _Source:Class;

        private static const _PL_DIALOGUE_X:int = 45;
        private static const _PL_DIALOGUE_Y:int = 25;

        private static const _DIALOGUE_WAIT:int = 700; // ms

        private static const _PL_BALOON:String = "hukidasi_p";
        private static const _FOE_BALOON:String = "hukidasi_e";

        private var _plBaloon:MovieClip;
        private var _foeBaloon:MovieClip;
        private var _plDialogue:DialogueTextField = new DialogueTextField();

        /**
         * コンストラクタ
         *
         */
        public function OpeningUp()
        {
//             _plDialogue.height = 180;
//             _plDialogue.width = 330;
// //            _plDialogue.width = 150;
//             _plDialogue.x = _PL_DIALOGUE_X;
//             _plDialogue.y = _PL_DIALOGUE_Y;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
//             _plBaloon = MovieClip(_root.getChildByName(_PL_BALOON));
//             _foeBaloon = MovieClip(_root.getChildByName(_FOE_BALOON));
//             _plBaloon.visible = false;
//             _foeBaloon.visible = false;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function getAnimeThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new GoToPlayThread(_root));
//             var s:String = Dialogue.instance.content;
// //            log.writeLog(log.LV_FATAL, this, "Dialogue is :",s,s.length, s.length!=0);
//             if (s.length!=0)
//             {
//                 _plDialogue.htmlText = s;
//                 _plBaloon.visible = true;
//                 _plBaloon.addChild(_plDialogue.transionBitmap);
//                 sExec.addThread(new SleepThread(_DIALOGUE_WAIT));
//                 sExec.addThread(_plDialogue.getAutoTransitSentenceThread());
//             }
            return sExec;
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
