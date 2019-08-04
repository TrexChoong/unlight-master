// TODO:コンストラクタでIDだけ渡したい。なぜならロード失敗の時IDがわからないから。

package model
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;
    import model.utils.*;

    /**
     * ストーリクラス
     * 情報を扱う
     * 
     */
    public class Story extends BaseModel
    {
        public static const INIT:String = 'init';        // 情報をロード
        public static const UPDATE:String = 'update';    // 情報をロード
        private static var __loader:Function;            // パラムを読み込む関数
        private static var __stories:Object =[];         // ロード済みの必殺技
        private static var __loadings:Object ={};        // ロード中の必殺技

        private var _title         :String; // タイトル
        private var _bookType      :int;    // タイプ
        private var _content       :String; // 内容
        private var _image         :String; // SWF
        private var _age_no        :String; // 時系列
        private var _version       :int;    //バージョン

        // 外から設定する用の定数群
        public static const COLUMN_NUM:int    = 23;  // ConstDataの配列の何番目にStoryデータが入っているか
        public static const COLUMN_ID:int     = 0;   // データ配列のIDの添え字
        public static const COLUMN_TITLE:int  = 1;   // データ配列のtitleの添え字
        public static const COLUMN_AGE_NO:int = 2;   // データ配列のage_noの添え字


        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
        }

        private static function getData(id:int):void
        {
            if (__loader == null)
            {
                throw new Error("Warning: Loader is undefined.");
            }else{
                if (Cache.getCache(Cache.STORY, id))
                {
                    var a:Array = Cache.getDataParam(Cache.STORY, id);
                    updateParam(id, a[0], a[1], a[2], a[3], a[4], a[5], true);
//                    log.writeLog(log.LV_FATAL, "CharaCard static", "get param cache", a);
                }else{
                    __loadings[id] = true;
                    new ReLoaderThread(__loader, Story.ID(id)).start();
                }
            }
        }

        public static function clearData():void
        {
            __stories.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }


        // IDのStoryインスタンスを返す
        public static function ID(id:int):Story
        {
            if (id==0)
            {
                return getBlankStory();
            }else{
                if (__stories[id] == null)
                {
                    __stories[id] = new Story(id);
                    getData(id);
                }else{
                // ロード済みでもローディング中でもないなら読む
                    if (!(__stories[id].loaded || __loadings[id]))
                    {
                        getData(id);
                    }
                }
                return __stories[id];
            }
        }

        // ローダがStoryのパラメータを更新する
        public static function updateParam(id:int,  bookType:int, title:String, content:String, image:String, age_no:String, version:int, cache:Boolean=false):void
        {
//            log.writeLog(log.LV_INFO, "static Story" ,"update id",id, title, bookType, age_no);

            if (__stories[id] == null)
            {
                __stories[id] = new Story(id);
            }
            __stories[id]._id            = id;
            __stories[id]._title         = title;
            __stories[id]._bookType      = bookType;
            __stories[id]._content       = content;
            __stories[id]._image         = image;
            __stories[id]._age_no        = age_no;

            if (!cache)
            {
                Cache.setCache(Cache.STORY, id, bookType, title, content, image, age_no, version);
            }

            if (__stories[id]._loaded)
            {
                __stories[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static Story" ,"load update",id,__stories[id]._loaded);
            }
            else
            {
                __stories[id]._loaded  = true;
                __stories[id].notifyAll();
                __stories[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static Story" ,"load init",id,__stories[id]);
            }
            __loadings[id] = false;

        }

        // 相手用のブランクストーリー
        public static function getBlankStory():Story
        {
            if (__stories[0] == null)
            {
                var st:Story = new Story(0);
                st._title         = "";
                st._bookType      = 0;
                st._content       = "";
                st._age_no        = "";
                st._loaded        = true;
                __stories[0]=st
            }
            return __stories[0];
        }


        // コンストラクタ
        public function Story(id:int)
        {
            _id = id;
        }
        public function get title():String
        {
            return _title;
        }
        public function get bookType():int
        {
            return _bookType;
        }
        public function get content():String
        {
            return _content;
        }
        public function get image():String
        {
            return _image;
        }
        public function get age_no():String
        {
            return _age_no;
        }
        public function getLoader():Thread
        {
            return new ReLoaderThread(__loader, Story.ID(id))
        }

    }
}
// import org.libspark.thread.Thread;

// import model.Story;

// // Storyのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _story:Story;

//     public function Loader(story:Story)
//     {
//         _story =story;
//     }

//     protected override function run():void
//     {
//         if (_story.loaded == false)
//         {
//             _story.wait()
//         }
//         next(close);
//     }

//     private function close ():void
//     {

//     }

// }

