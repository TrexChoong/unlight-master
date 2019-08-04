package model
{
    import flash.events.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    /**
     * 会話文用のモデル
     *
     */
    public class Dialogue extends EventDispatcher
    {
        // 更新
        public static const UPDATE:String     = "update";

        // 会話タイプ
        public static const DUEL_START:int     = 0;
        public static const DUEL_END:int       = 1;
        public static const QUEST_END_CHARA:int       = 3;
        public static const QUEST_END_AVATAR:int       = 4;

        // 内容
        private var _ids:Array = []; /* of int  */ ;
        private var _content:Array = []; /* of String  */ ;
        private var _types:Array = []; /* of int  */ ;

        // シングルトンインスタンス
        private static var __instance:Dialogue;

        /**
         * コンストラクタ
         *
         */
        public static function get instance():Dialogue
        {
            if( __instance == null )
            {
                __instance = createInstance();
            }
            return __instance;
        }

        public function clearData():void
        {
            _content = [];
            _ids = [];
            _types = [];
        }

        public function Dialogue(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor."); 
        }

        // 本当のコンストラクタ
        private static function createInstance():Dialogue
        {
            return new Dialogue(arguments.callee);
        }

        // メッセージ更新
        public function setMessage(str:String, id:int=0, typeID:int = 0):void
        {
            // メッセージをプッシュ
            _ids.push(id);
            _types.push(typeID);
            _content.push(str);
            dispatchEvent(new DataEvent(UPDATE, false,false,str));
        }

        // メッセージをとる。
        public function  get content():String
        {
            var ret:String = _content.shift();
            if (ret==null)
            {
                ret = "";
            }
            return keywordReplace(ret);

        }

        /*** キーワードを置換する
         * ${avatar_name}: アバター名
         ***/
        private function keywordReplace(text:String):String
        {
            var result:String = text;
            var patarnAvatarName:RegExp = /\$\{avatar_name\}/gi;
            if (text.length > 0 && Player.instance && Player.instance.avatar)
            {
                result = result.replace(patarnAvatarName, Player.instance.avatar.name);
            }
            return result;
        }

        // IDをとる。
        public function get ID():int
        {
            var ret:int = _ids.shift();
            if (ret < 0)
            {
                ret = 0;
            }
            return ret;

        }

        // typeをとる。
        public function get type():int
        {
            var ret:int = _types.shift();
            if (ret < 0)
            {
                ret = 0;
            }
            return ret;

        }


    }
}
