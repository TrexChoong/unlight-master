package sound.se
{
    import flash.media.*;
    import flash.events.Event;
    import flash.net.URLRequest;

    import sound.se.BaseSESound;

    public class GemSE extends BaseSESound

    {
        static private const _PERMIT_NUM:int = 20; // 同時になってもいい数
        static private const _DECAY:Number = 0.01; // 同時になっている場合減衰させる割合

        private static const URL:String = "/public/sound/se/ulse14.mp3";
        private var _url : URLRequest = new URLRequest(URL);
        private var _sound_obj : Sound = new Sound();

        // コンストラクタ
        public function GemSE()
        {

        }
        // オーバライド前提
        protected  override function get url():String
        {
            return URL;
        }
        protected override function get permitNum():int
        {
            return _PERMIT_NUM;
        }
        protected override function get decay():Number
        {
            return _DECAY;
        }
        
    }
}


