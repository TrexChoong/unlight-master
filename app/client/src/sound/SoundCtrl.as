package sound
{

    import flash.events.*;
    import flash.media.*;

    import mx.controls.*;

    import org.libspark.thread.Thread;
    import model.Option;


    /**
     * コントロールの基底クラス
     *
     */
    public class SoundCtrl extends EventDispatcher
    {

        private static var __bgmVolume:int;
        private static var __seVolume:int;
        private static var __cvVolume:int;

        protected static var __instance:SoundCtrl; // シングルトン保存用

        private static var __currentBGMChannels:Vector.<SoundChannel> = new Vector.<SoundChannel>();
        private static var __currentSEChannels:Vector.<SoundChannel> = new Vector.<SoundChannel>();
        private static var __currentCVChannels:Vector.<SoundChannel> = new Vector.<SoundChannel>();
        private var _option:Option = Option.instance;


        public function SoundCtrl(caller:Function=null)
        {
            __bgmVolume = _option.BGMVolume;
            __seVolume = _option.SEVolume;
            __cvVolume = _option.CVVolume;
            _option.addEventListener(Option.UPDATE_BGM, bgmHandler);
            _option.addEventListener(Option.UPDATE_SE, seHandler);
            _option.addEventListener(Option.UPDATE_CV, cvHandler);

        }
        private static function createInstance():SoundCtrl
        {
            return new SoundCtrl(arguments.callee);
        }

        public static function get instance():SoundCtrl
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }

        public  function get BGMVolume():int
        {
            return __bgmVolume;
        }

        public function get SEVolume():int
        {
            return __seVolume;
        }

        public function get CVVolume():int
        {
            return __cvVolume;
        }

        public function set BGMVolume(v:int):void
        {
            __bgmVolume = v;
            var trans:SoundTransform = new SoundTransform();
            trans.volume = __bgmVolume/100;
            __currentBGMChannels.forEach(function(item:*, index:int, vector:Vector.<SoundChannel>):void{item.soundTransform = trans});
//            log.writeLog(log.LV_FATAL, this, "volume change", __bgmVolume);
        }

        public function set SEVolume(v:int):void
        {
            __seVolume = v;
            var trans:SoundTransform = new SoundTransform();
            trans.volume = __seVolume/100;
            __currentSEChannels.forEach(function(item:*, index:int,  vector:Vector.<SoundChannel>):void{item.soundTransform = trans});

        }

        public function set CVVolume(v:int):void
        {
            __cvVolume = v;
            var trans:SoundTransform = new SoundTransform();
            trans.volume = __cvVolume/100;
            __currentCVChannels.forEach(function(item:*, index:int,  vector:Vector.<SoundChannel>):void{item.soundTransform = trans});

        }

        public  function disposeBGM(sc:SoundChannel):void
        {
            __currentBGMChannels.splice(__currentBGMChannels.indexOf(sc),1);
        }

        public function disposeSE(sc:SoundChannel):void
        {
            __currentSEChannels.splice(__currentSEChannels.indexOf(sc),1);
        }

        public function disposeCV(sc:SoundChannel):void
        {
            __currentCVChannels.splice(__currentCVChannels.indexOf(sc),1);
        }

        public function addBGM(sc:SoundChannel):void
        {
            __currentBGMChannels.push(sc);
        }

        public  function addSE(sc:SoundChannel):void
        {
            __currentSEChannels.push(sc);
        }

        public  function addCV(sc:SoundChannel):void
        {
            __currentCVChannels.push(sc);
        }

        private function bgmHandler(e:Event):void
        {
//            log.writeLog(log.LV_FATAL, this, "bgm vol change");
            BGMVolume = _option.BGMVolume;
        }
        private function seHandler(e:Event):void
        {
            SEVolume = _option.SEVolume;
        }
        private function cvHandler(e:Event):void
        {
            CVVolume = _option.CVVolume;
        }
   }
}