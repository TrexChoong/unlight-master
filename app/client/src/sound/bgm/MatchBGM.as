package sound.bgm
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;



    public class MatchBGM extends BaseBGMSound

    {

        private static const URL:String = "/public/sound/bgm/ulbgm03.mp3";
        private var _url : URLRequest = new URLRequest(URL);
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function MatchBGM()
        {

        }
        // オーバライド前提
        protected  override function get url():String
        {
            return URL;
        }

        
    }
}

