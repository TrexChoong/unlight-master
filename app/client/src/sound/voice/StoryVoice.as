package sound.voice
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;

    import sound.voice.BaseVoiceSound;

    public class StoryVoice extends BaseVoiceSound
    {
        private static const BaseURL:String = "/public/sound/voice/story/jp/";
        private static const FileNames:String = "__StoryId__.mp3";
        private var _url : URLRequest = new URLRequest(BaseURL+FileNames);
        private var _storyId:int = 1;
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function StoryVoice(storyId:int)
        {
            _storyId = storyId;
            super();
        }
        // オーバライド前提
        protected  override function get url():String
        {
            var tmp:String = (BaseURL+FileNames).replace("__StoryId__",_storyId);
            log.writeLog(log.LV_INFO, this, "url : ", tmp);
            return tmp;
        }
    }
}
