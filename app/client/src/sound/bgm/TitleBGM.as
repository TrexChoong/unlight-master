package sound.bgm
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;


    public class TitleBGM extends BaseBGMSound

    {

        private static const URL:String = "/public/sound/bgm/ulbgm01.mp3";
        private var _url : URLRequest = new URLRequest(URL);
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function TitleBGM()
        {

        }
        // オーバライド前提
        protected  override function get url():String
        {
            return URL;
        }

        
    }
}


