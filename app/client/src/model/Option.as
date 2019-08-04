package model
{
    import flash.events.EventDispatcher;
    import flash.net.SharedObject;
    import flash.events.Event;

    import org.libspark.thread.*;

    import mx.managers.ToolTipManager;

    /**
     * ゲームの設定クラス
     *
     */
    public class Option extends BaseModel
    {
        // イベント
        public static const UPDATE_BGM:String = 'update_bgm';
        public static const UPDATE_SE:String = 'update_se';
        public static const UPDATE_CV:String = 'update_cv';
        public static const UPDATE_TOOLTIP:String = 'update_tooltip';


        // シングルトンインスタンス
        private static var __instance:Option;

        // ヘルプの有効設定
        private var _help:Boolean = true;
        private var _arrow:Boolean = true;

        private const DEFALT_VOLUME:int      = 50;
        private const DEFALT_TOOLTIP:Boolean = true;
        private const DEFALT_ARROW:Boolean   = true;
        private var _se:int;
        private var _bgm:int;
        private var _cv:int;

        private var _sharedObj:SharedObject = SharedObject.getLocal("volume");

        /**
         * シングルトンインスタンスを返すクラス関数
         *
         *
         */
        public static function get instance():Option
        {
            if( __instance == null )
            {
                __instance = createInstance();
            }
            return __instance;
        }

        public static function get currentOption():Option
        {
            return __instance;
        }

        // 本当のコンストラクタ
        private static function createInstance():Option
        {
            return new Option(arguments.callee);
        }

        // コンストラクタ
        public function Option(caller:Function)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");

            // SharedObjectから値を取得無ければDefault
            if (_sharedObj.data.bgm == undefined)
            {
                BGMVolume = DEFALT_VOLUME;
            }else{
                BGMVolume = _sharedObj.data.bgm;
            }

            if (_sharedObj.data.se == undefined)
            {
                SEVolume = DEFALT_VOLUME;
            }else{
                SEVolume = _sharedObj.data.se;
            }

            if (_sharedObj.data.cv == undefined)
            {
                CVVolume = DEFALT_VOLUME;
            }else{
                CVVolume = _sharedObj.data.cv;
            }

            if (_sharedObj.data.toolTip == undefined)
            {
                help = DEFALT_TOOLTIP;
            }else{
                help = _sharedObj.data.toolTip;
            }

            if (_sharedObj.data.arrow == undefined)
            {
                arrow = DEFALT_ARROW;
            }else{
                arrow = _sharedObj.data.arrow;
            }

        }

        public function get help():Boolean
        {
            return _help;
        }

        public function set help(h:Boolean):void
        {
            _help = h;
            ToolTipManager.enabled = _help;
            _sharedObj.data.toolTip = h;
            dispatchEvent(new Event(UPDATE_TOOLTIP));

        }

        public function get arrow():Boolean
        {
            return _arrow;
        }

        public function set arrow(h:Boolean):void
        {
            _arrow = h;
            _sharedObj.data.arrow = h;
        }

        // -------------------------
        // SOUND
        // -------------------------
        
        public function get BGMVolume():int
        {
            return _bgm;
        }
        public function get SEVolume():int
        {
            return _se;
        }
        public function get CVVolume():int
        {
            return _cv;
        }

        public function set BGMVolume(i:int):void
        {
            _bgm = i;
            dispatchEvent(new Event(UPDATE_BGM));
            _sharedObj.data.bgm = i;
            log.writeLog(log.LV_INFO, this, "bgm", _bgm);
        }
        public function set SEVolume(i:int):void
        {
            _se = i;
            dispatchEvent(new Event(UPDATE_SE));
            _sharedObj.data.se = i;
            log.writeLog(log.LV_INFO, this, "se", _sharedObj.data.se);
        }
        public function set CVVolume(i:int):void
        {
            _cv = i;
            dispatchEvent(new Event(UPDATE_CV));
            _sharedObj.data.cv = i;
            log.writeLog(log.LV_INFO, this, "cv", _cv);
        }
        public function save():void
        {
            _sharedObj.flush();
        }

        public function load():void
        {

        }
    }
}