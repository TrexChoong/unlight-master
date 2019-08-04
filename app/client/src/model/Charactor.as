package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import org.libspark.thread.Thread;

    import model.utils.*;


    /**
     * キャラクタークラス
     * 情報を扱う
     * 
     */
    public class Charactor  extends BaseModel
    {

        private static var __loader:Function;                 // パラムを読み込む関数
        private static var __charas:Object =[];               // ロード済みのキャラ
        private static var __loadings:Object ={};             // ロード中のカード


        private var _name          :String  // 名前
        private var _lobbyImage    :String; // ロビー画像 

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
            Charactor.getBlankData(); // ブランクカードだけは速攻で作る
        }

        private static function getData(id:int):void
        {
            var a:Array; /* of ElementType */ 
            if (ConstData.getData(ConstData.CHARACTOR, id) != null)
            {
                a = ConstData.getData(ConstData.CHARACTOR, id);
                updateParam(id, a[1], a[2], true);
            }

        }

        public static function clearData():void
        {
            __charas.forEach(function(item:Charactor, index:int, array:Array):void{if (item != null){item._loaded = false}});
        }

        // IDのCharactorインスタンスを返す
        public static function ID(id:int):Charactor
        {
            if(id == 0)
            {
                return getBlankData();
            } else if (__charas[id] == null)
            {
                __charas[id] = new Charactor(id);
                getData(id);
                return __charas[id];
            }else{
                // ロード済みでもローディング中でもないなら読む
                if (!(__charas[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
                return __charas[id];
            }
        }

        // ローダがCharactorのパラメータを更新する
        public static function updateParam(id:int,  name:String, lobbyImage:String, cache:Boolean=false):void
        {

//            log.writeLog(log.LV_INFO, "static Charactor" ,"update id",id, ap, dp,feats);

            if (__charas[id] == null)
            {
                __charas[id] = new Charactor(id);
            }
            __charas[id]._id            = id;
            __charas[id]._name          = name;
            __charas[id]._lobbyImage    = lobbyImage;

            __loadings[id] = false;
        }

        // Unknown用のブランクデータ
        public static function getBlankData():Charactor
        {
            if (__charas[0] == null)
            {
                var chara:Charactor = new Charactor(0);
                chara._id            = 0;
                chara._name          = "";
                chara._lobbyImage    = "";
                __charas[0]       = chara;
            }
            return __charas[0];
        }
        // コンストラクタ
        public function Charactor(id:int)
        {
            _id = id;
        }

        public function get name():String
        {
            return _name;

        }
        public function get lobbyImage():String
        {
            if (AvatarItemInventory.resultImages[_id] > 0)
            {
                return _lobbyImage + "_res0";
            }
            else
            {
                return _lobbyImage;
            }

        }
    }
}
import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import model.Charactor;
import model.Feat;
import model.utils.ReLoaderThread;

// Charactorのロードを待つスレッド
class Loader extends ReLoaderThread
{
    private var  _c:Charactor;

    public function Loader(func:Function, c:Charactor)
    {
        _c = c;
        super(func, c)
    }

    protected override function reload():void
    {
        if (_bm.loaded == false)
        {
            _loader(_bm.id);
            next(waitingTimer);
        }else{
            next(close)
        }
    }

    private function close ():void
    {
    }
}

