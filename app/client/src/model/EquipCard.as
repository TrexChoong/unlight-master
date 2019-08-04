package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * 装備カードクラス
     * 情報を扱う
     * 
     */
    public class EquipCard extends BaseModel implements ICard
    {
        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        public static const UPDATE_NUM:String = 'update_num'; // 情報をロード

        private static var __loader:Function;         // パラムを読み込む関数
        private static var __items:Object =[];        // ロード済みのカード
        private static var __loadings:Object ={};     // ロード中のカード
        private static var __registItems:Array = []; /* of EquipCard */ 

        private var _name         :String;   // 名前
        private var _no           :int;      // 効果番号
        private var _cost         :int;      // コスト
        private var _restriction  :Array;    // キャラ制限
        private var _image        :String;   // SWF名
        private var _caption      :String;   // 説明
        private var _version       :int;

        private var _num           :int = 0;    // 所持枚数
        private var _type          :int = InventorySet.TYPE_EQUIP;    // 

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
        }

        private static function getData(id:int):void
        {
//             if (__loader == null)
//             {
//                 throw new Error("Warning: Loader is undefined.");
//             }else{

                if (Cache.getCache(Cache.EQUIP_CARD, id))
                {
                    var a:Array = Cache.getDataParam(Cache.EQUIP_CARD, id);
                    updateParam(id, a[0], a[1], a[2], a[3], a[4], a[5], a[6], true);
//                    log.writeLog(log.LV_FATAL, "CharaCard static", "get param cache", a);
                }else{
                __loadings[id] = true;
                new ReLoaderThread(__loader, EquipCard.ID(id)).start();
//                __loader(id);
                }
//             }
        }

        // データを再読込（再ログイン時にデータ更新を確認するため）
        public static function clearData():void
        {
            __items.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }


        // IDのEquipCardインスタンスを返す
        public static function ID(id:int):EquipCard
        {
//            log.writeLog(log.LV_INFO, "static EquipCard" ,"get id",id, __items[id]);
            if (__items[id] == null)
            {
                __items[id] = new EquipCard(id);
                getData(id);
            }else{

                if (!(__items[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __items[id];
        }

        // ローダがEquipCardのパラメータを更新する
        public static function updateParam(id:int, name:String, no:int, cost:int, restriction:Array, image:String, caption:String, version:int, cache:Boolean=false):void
        {
            if (__items[id] == null)
            {
                __items[id] = new EquipCard(id);
            }
            __items[id]._id            = id;
            __items[id]._name          = name;
            __items[id]._no            = no;
            __items[id]._cost          = cost;
            __items[id]._restriction   = restriction;
            __items[id]._image         = image;
            __items[id]._caption       = caption;
            __items[id]._version       = version;

            if (!cache)
            {
                Cache.setCache(Cache.EQUIP_CARD, id, name, no, cost, restriction, image, caption, version);
            }


            if (__items[id]._loaded)
            {
                __items[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static EquipCard" ,"load update",id,__items[id]._loaded);
            }
            else
            {
                __items[id]._loaded  = true;
                __items[id].notifyAll();
                __items[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static EquipCard" ,"load init",id,__items[id]);
            }
            __loadings[id] = false;
        }

        // 登録時に使えるパーツリストをセットする
        public static function setRegistItems(ids:Array /* of int */ ):void
        {
            ids.forEach(function(item:*, index:int, array:Array):void{__registItems.push(ID(item))});
        }

        public static function getRegistItems():Array /* of EquipCards */
        {
            return __registItems;
        }

        // コンストラクタ
        public function EquipCard(id:int)
        {
            _id = id;
        }


        public function get name():String
        {
            return _name;
        }

        public function get no():int
        {
            return _no;
        }

        public function get cost():int
        {
            return _cost;
        }

        public function get restriction():Array
        {
            return _restriction;
        }

        public function get image():String
        {
            return _image;
        }

        public function get caption():String
        {
            return _caption;
        }

        public function getLoader():Thread
        {
            return new new ReLoaderThread(__loader, EquipCard.ID(id));
        }

        public function set num(i:int):void
        {
            _num = i;
            dispatchEvent(new Event(UPDATE_NUM));
//            log.writeLog(log.LV_FATAL, this, "setnum" , _num);
        }

        public function get num():int
        {
            return _num;
        }


        // インターフェイス用の偽アクセサ（後々取る予定。）

        public function get abName():String
        {
            return "";
        }

        public function get level():int
        {
            return 0;
        }
        public function get hp():int
        {
            return 0;
        }
        public function get ap():int
        {
            return 0;
        }
        public function get dp():int
        {
            return 0;
        }
        public function get rarity():int
        {
            return 0;
        }
        public function get kind():int
        {
            return -1;
        }
        public function get bookExist():Boolean
        {
            return false;
        }
        public function get color():int
        {
            return 0;
        }

        public function get type():int
        {
            return _type;
        }

    }
}
// import org.libspark.thread.Thread;
// import org.libspark.thread.utils.ParallelExecutor;

// import model.EquipCard;
// import model.Feat;

// // EquipCardのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _ap:EquipCard;

//     public function Loader(ap:EquipCard)
//     {
//         _ap = ap;
//     }

//     protected override function run():void
//     {
//         if (_ap.loaded == false)
//         {
//             _ap.wait()
//         }
//         next(close);
//     }

//     private function close ():void
//     {
//     }
// }
