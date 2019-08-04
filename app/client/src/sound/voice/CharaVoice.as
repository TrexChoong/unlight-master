package sound.voice
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;

    import sound.voice.BaseVoiceSound;

    public class CharaVoice extends BaseVoiceSound
    {
        private static const BaseURL:String = "/public/sound/voice/chara/jp/";

        private static const FileDir:String = "__CharaID__/__Mode__/";
        private static const FileNames:String = "__Situation____SituationId____OtherCharaId__.mp3";
        private var _charaIdStr:String = "";
        private var _mode:String = "";
        private var _situation:String = "";
        private var _situationIdStr:String = "";
        private var _otherCharaIdStr:String = "";
        private var _method:int = 0;
        private var _url : URLRequest = new URLRequest(BaseURL+FileDir+FileNames);
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function CharaVoice(charaId:int=0, situation:Array=null, situationId:int=0, otherCharaId:int=0, method:int=0)
        {
            //GenerateUrl(charaId, situation, situationId, otherCharaId)
            _charaIdStr = String("00000"+charaId).slice(-5);
            _mode = situation[0];
            _situation = situation[1];
            _method = method;

            if (situationId !=0 )
            {
                _situationIdStr = situationId.toString();
            }
            else
            {
                _situationIdStr = "";
            }
            if (otherCharaId != 0)
            {
                _otherCharaIdStr = String("00000"+otherCharaId).slice(-5);
            }
            super();
        }

        public static function GenerateUrl(charaId:int, situation:Array, situationId:int=0, otherCharaId:int=0):String
        {
            var tmp:String = (BaseURL+FileDir+FileNames).replace("__CharaID__", String("00000"+charaId).slice(-5) ).replace("__Mode__",situation[0]);
            var situationStr:String = relativeCheck(charaId, otherCharaId, situation);
            tmp = tmp.replace("__Situation__",relativeCheck(charaId, otherCharaId, situation));
            if (situationStr.indexOf("related") > -1)
            {
                tmp = tmp.replace("__SituationId__", "").replace("__OtherCharaId__",String("00000"+otherCharaId).slice(-5));
                log.writeLog(log.LV_DEBUG, "url : ", tmp);
                return tmp;
            }
            else
            {
                tmp = tmp.replace("__OtherCharaId__", "");
            }

            if (situationId != 0)
            {
                tmp = tmp.replace("__SituationId__", situationId.toString());
            }
            else
            {
                tmp = tmp.replace("__SituationId__", "");
            }
            log.writeLog(log.LV_DEBUG, "url : ", tmp);
            return tmp;
        }

        private static function relativeCheck(charaId:int, otherId:int, situation:Array):String
        {
            if (situation[0] != "battle") return situation[1];

            var tmp:String = situation[1];
            Const.VOICE_RELATIVE.forEach(function(item:Array, index:int, array:Array):void{
                    if (item[0] == charaId) {
                        if (item[1].indexOf(otherId) > -1)
                        {
                            tmp = "related" + situation[1];
                        }
                    }
                });

            return tmp;
        }

        // オーバライド前提
        protected  override function get url():String
        {
            return  GenerateUrl(parseInt(_charaIdStr), [_mode, _situation], parseInt(_situationIdStr), parseInt(_otherCharaIdStr));
            //return null;
        }

        // public static function PlayingMethod(charaId:int, situation:Array, situationId:int=0, otherCharaId:int=0, method:int=0):void
        // {
        //     var tmp_url:String = GenerateUrl(charaId, situation, situationId, otherCharaId);

        //     switch (method)
        //     {
        //     case Const.VOICE_PLAYING_METHOD_ADDITIOAL:
        //         addPlay(tmp_url);
        //         break;
        //     case Const.VOICE_PLAYING_METHOD_INTERRUPT:
        //         interruptPlay(tmp_url);
        //         break;
        //     case Const.VOICE_PLAYING_METHOD_FORCED:
        //         forciblyPlay(tmp_url);
        //         break;
        //     case Const.VOICE_PLAYING_METHOD_EXCLUSIVE:
        //         exclusivePlay(tmp_url);
        //         break;
        //     }
        // }
    }
}
