package sound.se
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;

    import sound.se.BaseSESound;

    public class CardSetBSE extends BaseSESound

    {

        private static const URL:String = "/public/sound/se/ulse05_b.mp3";
        private var _url : URLRequest = new URLRequest(URL);
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function CardSetBSE()
        {

        }
        // オーバライド前提
        protected  override function get url():String
        {
            return URL;
        }


    }
}


