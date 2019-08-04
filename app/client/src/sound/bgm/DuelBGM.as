package sound.bgm
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;


    public class DuelBGM extends BaseBGMSound

    {

//        private static const URL:String = "/public/sound/bgm/ulbgm04.mp3";
        private static const URLs:Array = [
            "/public/sound/bgm/bgm000.mp3", // 城
            "/public/sound/bgm/bgm001.mp3", // 森
            "/public/sound/bgm/bgm002.mp3", // 街道
            "/public/sound/bgm/bgm003.mp3", // 湖畔
            "/public/sound/bgm/bgm004.mp3", // 墓地
            "/public/sound/bgm/bgm005.mp3", // 村
            "/public/sound/bgm/bgm006.mp3", // 荒野
            "/public/sound/bgm/bgm007.mp3", // 遺跡
            "/public/sound/bgm/bgm008.mp3", // 街
            "/public/sound/bgm/bgm009.mp3", // 平原
            "/public/sound/bgm/bgm000.mp3", // 幻影城
            "/public/sound/bgm/bgm000.mp3", // 荒野2
            "/public/sound/bgm/bgm010.mp3", // ボス
            ];
        private var _currentSel:int = 0;
        private var _url : URLRequest = new URLRequest(URLs[_currentSel]);
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function DuelBGM( selBgm:int = 0)
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

        
    }
}
