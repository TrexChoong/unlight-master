package sound.bgm
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;

    public class LobbyBGM extends BaseBGMSound

    {

//        private static const URL:String = "/public/sound/bgm/ulbgm02.mp3";
        private static const URLs:Array = [
            "/public/sound/bgm/ulbgm02.mp3", // 通常
            "/public/sound/bgm/bgm011.mp3",  // チュートリアル
            "/public/sound/bgm/bgm012.mp3",  // ガチャ
            "/public/sound/bgm/bgm013.mp3",  // ストーリー
            ];
        private var _currentSel:int = 0;
        private var _url : URLRequest = new URLRequest(URLs[_currentSel]);
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function LobbyBGM(selBgm:int = 0)
        {
            if ( selBgm < URLs.length ) _currentSel = selBgm;
            log.writeLog(log.LV_INFO, this, "selBgm",selBgm,"url",url);
            // 設定したあとに親クラスのコンストラクタを呼ぶ
            super();
        }

        // オーバライド前提
        protected  override function get url():String
        {
            return URLs[_currentSel];
        }

        public function isSetChannel():Boolean
        {
            return (_channel != null);
        }

        public function removeCurrentChannel():void
        {
            if ( _channel != null ) {
                removeChannelToCtrl(_channel);
                _channel = null;
            }
        }
    }
}

