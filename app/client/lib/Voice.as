/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
{

    import org.libspark.thread.Thread;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import view.*;
    import model.Duel;

    import sound.BaseSound;
    import sound.voice.*;

    /**
     * Voiceの音管理クラスまとめて管理する
     *
     */
    public class Voice
    {
        static public function playDialogueVoice(dId:int=1):void
        {
            if (!isReleasingDialogueVoice(dId) || Duel.instance.playerCharaCard.rarity < Const.VOICE_MIN_RARITY) return;

            CONFIG::VOICE_ON
            {
                var dialogueVoice:DialogueVoice = new DialogueVoice(dId);
                new PlayVoiceThread(dialogueVoice).start();
            }
        }
        private static var _my_chara:int = 2;

        public static function set my_chara(charactor_id:int):void
        {
            _my_chara = charactor_id;
        }
        public static function get my_chara():int
        {
            return _my_chara;
        }

        static private var currentVoice:BaseVoiceSound = null;
        static public function playCharaVoice(cId:int,situ:Array,situId:int=0,otherId:int=0,method:int=0):void
        {
            if (!isReleasingCharaVoice(cId) || Duel.instance.playerCharaCard.rarity < Const.VOICE_MIN_RARITY || !isReleasingDefeatVoice(situ, cId)) return;

            CONFIG::VOICE_ON
            {
                if (Duel.instance.currentCharaCardIsControlled(true)) return;
                var isCat:Boolean = Duel.instance.currentCharaCardIsCat(true);
                var charaId:int = isCat ? 99999 : cId;
                var situation:Array = isCat ? Const.VOICE_SITUATION_BATTLE_CAT : situ;
                var situationId:int = isCat ? 0 : situId;
                var otherCharaId:int = isCat ? 0 : otherId;
                if (currentVoice && currentVoice.playing)
                {
                    currentVoice.PlayingMethod(CharaVoice.GenerateUrl(charaId, situation, situationId, otherCharaId), method);
                }
                else
                {
                    currentVoice = new CharaVoice(charaId, situation, situationId, otherCharaId);
                    new PlayVoiceThread(currentVoice).start();
                }
            }
        }

        static public function stopCurrentVoice():void
        {
            CONFIG::VOICE_ON
            {
                new PlayVoiceThread(currentVoice).Stop();
            }
        }

        static private var storyVoice:StoryVoice;
        static public function playStoryVoice(storyId:int):void
        {
            if (!isReleasingStoryVoice(storyId)) return;

            CONFIG::VOICE_ON
            {
                stopCurrentVoice();
                currentVoice = new StoryVoice(storyId);
                new PlayVoiceThread(currentVoice).start();
            }
        }

        static private function isReleasingCharaVoice(charaId:int):Boolean
        {
            return Const.RELEASING_CHARA_VOICE.indexOf(charaId) < 0 ? false : true;
        }

        static private function isReleasingStoryVoice(storyId:int):Boolean
        {
            return Const.RELEASING_STORY_VOICE.indexOf(storyId) < 0 ? false : true;
        }

        static private function isReleasingDialogueVoice(dialogueId:int):Boolean
        {
            return Const.RELEASING_DIALOGUE_VOICE.indexOf(dialogueId) < 0 ? false : true;
        }

        static private function isReleasingDefeatVoice(situation:Array, charaId:int):Boolean
        {
            if (situation[1].indexOf("win") < 0 &&situation[1].indexOf("lose") < 0 && situation[1].indexOf("draw") < 0) return true;
            var ret:Boolean = false;
            Const.VOICE_RELATIVE.forEach(function(item:Array, index:int, array:Array):void{
                    if (item[0] == charaId)
                    {
                        ret = true;
                    }
                });
            return ret;
        }
    }
}


import org.libspark.thread.Thread;
import org.libspark.thread.*;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.utils.SerialExecutor;

import sound.BaseSound;
import sound.voice.*;

class PlayVoiceThread extends Thread
{
    private var _voice:BaseVoiceSound;

    public function PlayVoiceThread(bvs:BaseVoiceSound):void
    {
        _voice = bvs;
    }

    protected override function run():void
    {
        _voice.playVoice();
    }

    private function playWait():void
    {
        if (_voice != null && !_voice.playing ) {
            next(finish);
        } else {
            next(playWait);
        }
    }

    public function Playing():Boolean
    {
        if (_voice != null && !_voice.playing ) {
            return false;
        } else {
            return true
        }
    }

    private function finish():void
    {
        _voice = null;
    }
    public function Stop():void
    {
        log.writeLog(log.LV_DEBUG,this,"Voice thread Stop!!")
        if (_voice != null)
        {
            _voice.stopSound();
        }
    }

}