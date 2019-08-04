package model
{
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import org.libspark.thread.Thread;
    import model.events.*;
    import model.utils.*;

    /**
     * アクションカードクラス
     * 情報を扱う
     *
     */
    public class ActionCard  extends BaseModel
    {

        public static const SWD:int = 1;
        public static const ARW:int = 2;
        public static const DEF:int = 3;
        public static const MOVE:int = 4;
        public static const SPC:int = 5;
        public static const EVT:int = 6;

        public static const NONE_FLAG:int = 0;
        public static const SWD_FLAG:int = 1 << (ActionCard.SWD - 1);
        public static const ARW_FLAG:int = 1 << (ActionCard.ARW - 1);
        public static const DEF_FLAG:int = 1 << (ActionCard.DEF - 1);
        public static const MOVE_FLAG:int = 1 << (ActionCard.MOVE - 1);
        public static const SPC_FLAG:int = 1 << (ActionCard.SPC - 1);
        public static const EVT_FLAG:int = 1 << (ActionCard.EVT - 1);
        public static const ALL_FLAG:int = SWD_FLAG|ARW_FLAG|DEF_FLAG|MOVE_FLAG|SPC_FLAG|EVT_FLAG;

        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        public static const ROTATE:String = 'rotate'; // 回転
        public static const EVENT_ROTATE:String = 'event_rotate'; // 回転
        public static const ON:String = 'on'; // 回転
        private static var __loader:Function;         // パラムを読み込む関数
        private static var __cards:Object =[];        // ロード済みのカード
        private static var __loadings:Object ={};     // ロード中のカード
        private static var __length:int;
        private static var __allLoaded:Boolean = true;

        private var _uType   :int;
        private var _uValue  :int;
        private var _bType   :int;
        private var _bValue  :int;
        private var _eventNo :int;
        private var _image   :String; // 背景のSWF名
        private var _caption :String; // キャプション
        private var _version :int;

        private var _up      :Boolean  = true // 現在のカードの方向
        private var _on      :Boolean  = false // 現在のカードが有効か

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
            ActionCard.getBlankCard(); // ブランクカードだけは速攻で作る
        }

        private static function getData(id:int):void
        {
//             if (__loader == null)
//             {
//                 throw new Error("Warning: Loader is undefined.");
//             }else{
                var a:Array; /* of ElementType */ 
                if (ConstData.getData(ConstData.ACTION_CARD, id) != null)
                {
                    a = ConstData.getData(ConstData.ACTION_CARD, id)
                    updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], 0, true);
                }
//                 if (Cache.getCache(Cache.ACTION_CARD, id))
//                 {
//                     a = Cache.getDataParam(Cache.ACTION_CARD, id);
//                     updateParam(id, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], true);
//                 }else{
//                     __loadings[id] = true;
//                     new ReLoaderThread(__loader, ActionCard.ID(id)).start();
//                 }
//             }
        }

        // データを再読込（再ログイン時にデータ更新を確認するため）
        public static function clearData():void
        {
            __cards.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }


        // 全部をホストからロードするスレッドを返す。todo:startさせて返すの変だろ。。キャッシュ入れるときに直せ。
        public static function allLoad(l:int):Thread
        {
            // 総数にはブランクを足している
            __length = l+1;
            var loader:LoadAll = new LoadAll(__length);
            loader.start();
            return loader;
        }

        public static function get allLoaded():Boolean
        {
           return  __allLoaded;
        }

        public static function set allLoaded(b:Boolean):void
        {
            __allLoaded = b;
        }

        // IDのActionCardインスタンスを返す
        public static function ID(id:int):ActionCard
        {
//            log.writeLog(log.LV_INFO, "static ActionCard ID" ,"ID is", __cards[id]);
            // 空なら問答無用で読み込む
            if (__cards[id] == null)
            {
                if (id == 0)
                {
                    getBlankCard();
                }else{
                    __cards[id] = new ActionCard(id);
                    getData(id);
                }
            }
            else
            {
//                 // ロード済みでもローディング中でもないなら読む
//                 if (!(__cards[id].loaded || __loadings[id]))
//                 {
//                     getData(id);
//                 }
            }
            return __cards[id];
        }


        // ローダがActionCardのパラメータを更新する
        public static function updateParam(id:int, ut:int, uv:int, bt:int, bv:int, en:int, image:String, caption:String, version:int, cache:Boolean=false):void
        {
//             log.writeLog(log.LV_TEST, "static ActionCard" ,"update id",id);
            if (__cards[id] == null)
            {
                __cards[id] = new ActionCard(id);
            }
            __cards[id]._id      = id;
            __cards[id]._uType   = ut;
            __cards[id]._uValue  = uv;
            __cards[id]._bType   = bt;
            __cards[id]._bValue  = bv;
            __cards[id]._eventNo = en;
            __cards[id]._image   = image;
            __cards[id]._caption = caption;
            __cards[id]._version = version;
            if (!cache)
            {
                Cache.setCache(Cache.ACTION_CARD,id, ut, uv, bt, bv, en, image, caption, version);
            }

            if (__cards[id]._loaded)
            {
                __cards[id].dispatchEvent(new Event(UPDATE));
            }
            else
            {
                __cards[id].notifyAll();
                __cards[id]._loaded  = true;
                __cards[id].dispatchEvent(new Event(INIT));
            }
            __loadings[id] = false;
        }

        // 相手用のブランクカード
        public static function getBlankCard():ActionCard
        {
            if (__cards[0] == null)
            {
                var ac:ActionCard = new ActionCard(0);
                ac._uType   = 0;
                ac._uValue  = 0;
                ac._bType   = 0;
                ac._bValue  = 0;
                ac._eventNo = 0;
                ac._image   = "";
                ac._caption = "";
                ac._loaded  = true;
                __cards[0]  = ac;
            }
            return __cards[0];
        }
        public static function get length():int
        {
            return __length-1;
        }

        public static function idListToActionCards(intArray:Array):Array
        {
            var result:Array = [];
            intArray.forEach(function(item:*, index:int, array:Array):void{result.push(ActionCard.ID(item))});
            return result;
        }

        // バージョンの更新
        public static function updateVersion(id:int, version:int):void
        {
        }

        // コンストラクタ（ここ不正な呼び出しで例外だした方がいいな）
        public function ActionCard(id:int)
        {
            _id = id;
        }

        public function get uType():int
        {
            return _uType;
        }
        public function get uValue():int
        {
            return _uValue;
        }
        public function get bType():int
        {
            return _bType;
        }
        public function get bValue():int
        {
            return _bValue;
        }
        public function get eventNo():int
        {
            return _eventNo;
        }
        public function get image():String
        {
            return _image;
        }
        public function get caption():String
        {
            return _caption;
        }

        public function get up():Boolean
        {
            return _up
        }

        public function get on():Boolean
        {
            return _on
        }
        public function set up(b:Boolean):void
        {
            _up = b;
        }

        public function rotate(u:Boolean):void
        {
            if( _up != u)
            {
                _up = u;
                dispatchEvent(new Event(ROTATE));
            }

        }

        public function eventRotate(u:Boolean):void
        {
            if( _up != u)
            {
                _up = u;
                dispatchEvent(new Event(EVENT_ROTATE));
            }

        }

        public function activate(u:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "activate ON!!");
            _on = u;
            dispatchEvent(new Event(ON));

        }

        public function  swdPoint():int
        {
            return typeValue(SWD, up);
        }

        public function  arwPoint():int
        {
            return typeValue(ARW, up);
        }

        public function  defPoint():int
        {
            return typeValue(DEF, up);
        }

        public function  movePoint():int
        {
            return typeValue(MOVE,true) + typeValue(MOVE, false);
        }

        private function typeValue(type:int, u:Boolean):int
        {
            var ret:int = 0;
            if (u)
            {
                if (_uType == type)
                {
                    ret = _uValue;
                }
            }
            else
            {
                if (_bType == type)
                {
                    ret = _bValue;
                }
            }
            return ret;
        }


    }
}
// すべてのActionCard情報をロードするスレッド

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.tweener.TweenerThread;

import model.ActionCard;

class LoadAll extends Thread
{
    private var _len:int;

    public function LoadAll(len:int)
    {
        _len = len;
    }

    protected override function run():void
    {
        var pExec:ParallelExecutor = new ParallelExecutor();
        for(var i:int = 1; i < _len; i++)
        {
            var t:Loader = new Loader(ActionCard.ID(i));
            pExec.addThread(t);
        }
        pExec.start();
        pExec.join();
        next(close);
    }

    private function close ():void
    {
        ActionCard.allLoaded = true;
        notifyAll();
    }
}


// ActionCardのロードを待つスレッド
class Loader extends Thread
{
    private var  _ac:ActionCard;

    public function Loader(ac:ActionCard)
    {
        _ac =ac;
    }

    protected override function run():void
    {
        if (_ac.loaded == false)
        {
            _ac.wait()
        }
        next(close);
    }

    private function close ():void
    {

    }

}
