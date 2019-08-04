package sound.voice
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;

    import sound.voice.BaseVoiceSound;

    public class DialogueVoice extends BaseVoiceSound
    {
        private static const BaseURL:String = "/public/sound/voice/dialogue/jp/";

        private static const FileNames:String =  "__ID__.mp3";
        private var _dialogueId:int = 1;
        private var _url : URLRequest = new URLRequest(BaseURL+FileNames.replace("__ID__",_dialogueId));
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function DialogueVoice(dId:int = 1)
        {
            _dialogueId = dId;
            // log.writeLog(log.LV_INFO, this, "dialogueId",dId);
            // 設定したあとに親クラスのコンストラクタを呼ぶ
            super();
        }
        // オーバライド前提
        protected  override function get url():String
        {
            // log.writeLog(log.LV_INFO, this, "url",BaseURL+FileNames.replace("__ID__",_dialogueId));
            return BaseURL+FileNames.replace("__ID__",_dialogueId);
        }
    }
}


