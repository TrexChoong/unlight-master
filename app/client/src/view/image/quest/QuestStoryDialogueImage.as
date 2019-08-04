package view.image.quest
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.*;
    import model.*;
    import view.utils.*;
    import view.image.*;
    import view.scene.common.DialogueTextField;

    /**
     * QuestStoryDialogueImage表示クラス
     *
     */


    public class QuestStoryDialogueImage extends BaseImage
    {
        public static const END_EVENT:String = "QuestStoryDialogueImageEndEvent";

        // HP表示元SWF
        [Embed(source="../../../../data/image/quest_story/quest_story_talk.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private static const _AVATAR:String = "hukidasi_ava";
        private static const _CHARA:String = "hukidasi_chara";
        private static const _BTN:String = "btn_next";

        private var _plDialogue:DialogueTextField;
        private var _avatarMC:MovieClip;
        private var _charaMC:MovieClip;
        private var _buttonSB:SimpleButton;

        private var _type:int;

        private static const _PL_DIALOGUE_X:int = 89;
        private static const _PL_DIALOGUE_Y:int = 377;

        private static const _DIALOGUE_WAIT:int = 300; // ms


        /**
         * コンストラクタ
         *
         */
        public function QuestStoryDialogueImage()
        {
            dialogueInit();
            super();
        }

        private function dialogueInit():void
        {
            _plDialogue = new DialogueTextField();
            _plDialogue.height = 180;
            _plDialogue.width = 420;
            _plDialogue.x = _PL_DIALOGUE_X;
            _plDialogue.y = _PL_DIALOGUE_Y;
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            SwfNameInfo.toLog(_root);
            _avatarMC = MovieClip(_root.getChildByName(_CHARA));
            _charaMC = MovieClip(_root.getChildByName(_AVATAR));
            _buttonSB = SimpleButton(_root.getChildByName(_BTN));
            _avatarMC.alpha = 0.0;
            _charaMC.alpha = 0.0;
            _buttonSB.alpha = 0.0;
            buttonDisenable();
        }


        public function setType(type:int):void
        {
            _type = type;
            waitComplete(setTypeFrame);
        }

        private function setTypeFrame():void
        {
//            log.writeLog(log.LV_FATAL, this, "stop", _type,_eventMC);
        }

        private function buttonClickHandler(e:MouseEvent):void
        {
            buttonDisenable();
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(_buttonSB, {alpha:0.0}, null, 0.01, BeTweenAS3Thread.EASE_OUT_SINE, 0.001 ,true ));


            var s:String = Dialogue.instance.content;
            var id:int = Dialogue.instance.ID;
            var type:int = Dialogue.instance.type;
            log.writeLog(log.LV_FATAL, this, "Dialogue is :",s,s.length, s.length!=0);
            if (s.length!=0)
            {
                RemoveChild.apply(_plDialogue.transionBitmap);
                RemoveChild.apply(_plDialogue);

                dialogueInit();

                _plDialogue.htmlText = s;
                addChild(_plDialogue.transionBitmap);
                log.writeLog(log.LV_FATAL, this, "Dialogue is : 2",type,Dialogue.QUEST_END_CHARA );
                if(type == Dialogue.QUEST_END_CHARA)
                {
                    sExec.addThread(new BeTweenAS3Thread(_charaMC, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.01 ,true ));
                    sExec.addThread(new BeTweenAS3Thread(_avatarMC, {alpha:0.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.01 ,false ));
                }else{
                    sExec.addThread(new BeTweenAS3Thread(_avatarMC, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.01 ,true ));
                    sExec.addThread(new BeTweenAS3Thread(_charaMC, {alpha:0.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.01 ,false ));
                }
                sExec.addThread(_plDialogue.getAutoTransitSentenceThread());
                // sExec.addThread(new SleepThread(_DIALOGUE_WAIT));
                log.writeLog(log.LV_FATAL, this, "Dialogue is : 3");

                var pExec2:ParallelExecutor = new ParallelExecutor();

                // if (id > 0) {
                //     pExec.addThread(new ClousureThread(Voice.playDialogueVoice, [id]));
                // }

                sExec.addThread(pExec2);
                sExec.addThread(new BeTweenAS3Thread(_buttonSB, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.01 ,true ));
                sExec.addThread(new ClousureThread(buttonEnable));
                log.writeLog(log.LV_FATAL, this, "Dialogue is : 4");

            }
            else
            {
                log.writeLog(log.LV_FATAL, this, "Dispatch end event ",END_EVENT);
                _buttonSB.removeEventListener(MouseEvent.CLICK, buttonClickHandler);
                dispatchEvent(new Event(END_EVENT));
            }
            sExec.start();

        }

        public function getAnimeThread():Thread
        {
            _buttonSB.addEventListener(MouseEvent.CLICK, buttonClickHandler);
            var sExec:SerialExecutor = new SerialExecutor();
            var s:String = Dialogue.instance.content;
            var id:int = Dialogue.instance.ID;
            var type:int = Dialogue.instance.type;
            log.writeLog(log.LV_FATAL, this, "Dialogue is :",s,s.length, s.length!=0);
            if (s.length!=0)
            {


                _plDialogue.htmlText = s;
                addChild(_plDialogue.transionBitmap);
                log.writeLog(log.LV_FATAL, this, "Dialogue is : 2 -",type,Dialogue.QUEST_END_CHARA);
                if(type == Dialogue.QUEST_END_CHARA)
                {
                    sExec.addThread(new BeTweenAS3Thread(_charaMC, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.1 ,true ));
                }else{
                    sExec.addThread(new BeTweenAS3Thread(_avatarMC, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.1 ,true ));
                }
                sExec.addThread(new SleepThread(_DIALOGUE_WAIT));
                log.writeLog(log.LV_FATAL, this, "Dialogue is : 3");

                var pExec:ParallelExecutor = new ParallelExecutor();
                pExec.addThread(_plDialogue.getAutoTransitSentenceThread());

                // if (id > 0) {
                //     pExec.addThread(new ClousureThread(Voice.playDialogueVoice, [id]));
                // }

                sExec.addThread(pExec);
                sExec.addThread(new BeTweenAS3Thread(_buttonSB, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.1 ,true ));
                sExec.addThread(new ClousureThread(buttonEnable));
                log.writeLog(log.LV_FATAL, this, "Dialogue is : 4");
            }
            return sExec;
        }

        private function buttonEnable():void
        {
            _buttonSB.enabled = true;
            _buttonSB.mouseEnabled = true;
        }

        private function buttonDisenable():void
        {
            _buttonSB.enabled = false;
            _buttonSB.mouseEnabled = false;
        }
    }
}