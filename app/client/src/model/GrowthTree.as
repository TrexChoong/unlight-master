// TODO:コンストラクタでIDだけ渡したい。なぜならロード失敗の時IDがわからないから。

package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;
    import model.utils.*;

    /**
     * 系統樹クラス
     * 情報を扱う
     * 
     */
    public class GrowthTree  extends BaseModel
    {

        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        private static var __loader:Function;         // パラムを読み込む関数
        private static var __tree:Object ={};        // ロード済みの系統樹
        private static var __loadings:Object ={};     // ロード中の系統樹

        private var _up            :Array = [];  // 派生カードのID
        private var _down          :Array = [];  // 基底カードのID

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
            createZero();
        }

        private static function getData(id:int):void
        {
//             if (__loader == null)
//             {
//                 throw new Error("Warning: Loader is undefined.");
//             }else{
            var a:Array; /* of ElementType */ 
            if (ConstData.getData(ConstData.CHARA_CARD, id) != null)
            {
                a = ConstData.getData(ConstData.CHARA_CARD, id)
                    updateParam(id, a[19], a[20], 0, true);
            }
//             }
        }

        // idのGrowthtreeインスタンスを返す
        public static function ID(id:int):GrowthTree
        {
//            log.writeLog(log.LV_INFO, "static GrowthTree" ,"get id",id, __tree[id]);
            if (__tree[id] == null)
            {
                __tree[id] = new GrowthTree(id);
                getData(id);
            }else{
                if (__tree[id].loaded)
                {
                }else{
                    if (__loadings[id] == false){
                        getData(id);
                    }
                }
            }
            return __tree[id];
        }

        // ローダがGrowthTreeのパラメータを更新する
        public static function updateParam(id:int, up:String, down:String, version:int, cache:Boolean=false):void
        {
//            log.writeLog(log.LV_INFO, "static GrowthTree" ,"update id",id, up, down);

            if (__tree[id] == null)
            {
                __tree[id] = new GrowthTree(id);
            }
            __tree[id]._id            = id;
            __tree[id]._up            = arraySeparateNum(2 , string2intArray(up));
            __tree[id]._down          = arraySeparateNum(2 , string2intArray(down));

            if (!cache)
            {
                Cache.setCache(Cache.GROWTH_TREE, id, up, down, version);
            }


            if (__tree[id]._loaded)
            {
                __tree[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static GrowthTree" ,"load update",id,__tree[id]._loaded);
            }
            else
            {
                __tree[id]._loaded  = true;
                __tree[id].notifyAll();
                __tree[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static GrowthTree" ,"load init",id,__tree[id]);
            }
            __loadings[id] = false;

        }


        // コンストラクタ
        public function GrowthTree(id:int)
        {
            _id = id;
        }


        public function get up():Array
        {
            return _up;
        }

        public function get down():Array
        {
            return _down;
        }

        public function getLoader():Thread
        {
            return new Loader(this);
        }

        private static function createZero():void
        {
            __tree[0] = new GrowthTree(0);
            __tree[0]._id            = 0;
            __tree[0]._up            = [];
            __tree[0]._down          = [];
            __tree[0]._loaded  = true;
        }

        private static function string2intArray(str:String):Array
        {
            if ((str != "")&&(str != null))
            {
                return str.split(",").map(function(item:*, index:int, array:Array):int {return int(item)});
            }else{
                return [];
            }
        }

        private  static function arraySeparateNum(num:int, a:Array):Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < a.length; i+=num)
            {
//                log.writeLog(log.LV_FATAL, this,"sepatrater", i,a[i], a[i+1], a[i+2]);
                var c:Array = [];
                for(var j:int = 0; j < num; j++){
                    c.push(a[j+i])
                }
                ret.push (c);
            }
            return ret;
        }




    }
}

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import model.GrowthTree;
import model.Feat;

// GrowthTreeのロードを待つスレッド
class Loader extends Thread
{
    private var  _cc:GrowthTree;

    public function Loader(cc:GrowthTree)
    {
        _cc =cc;
    }

    protected override function run():void
    {
        if (_cc.loaded == false)
        {
            _cc.wait()
        }
        next(close);
    }

    private function close ():void
    {
    }
}

// GrowthTreeのロードを待つスレッド
class ReLoader extends Thread
{
    private var _loader:Function;
    private var _id:int;
    private static const INTERVAL:int = 2000; // 再ロードのms

    public function ReLoader(func:Function, id:int)
    {
        _loader = func;
        _id = id;
    }

    protected override function run():void
    {
        _loader(_id);
        next(waitingTimer);
    }

    private function waitingTimer ():void
    {
        sleep(INTERVAL);
        next(reload);
    }
    private function reload():void
    {
        if (_id ==0)
        {
            log.writeLog(log.LV_WARN, "GrowthTree" ,"data none! load failed", _id);
            return;
        }


        if (GrowthTree.ID(_id).loaded == false)
        {
            _loader(_id);
            next(waitingTimer);
            log.writeLog(log.LV_WARN, "GrowthTree" ,"load Fail ReLoad!!",_id);

        }
    }

}
