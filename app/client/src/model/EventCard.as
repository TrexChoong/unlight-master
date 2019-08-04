package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * 武器カードクラス
     * 情報を扱う
     * 
     */
    public class EventCard extends BaseModel implements ICard
    {
        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        public static const UPDATE_NUM:String = 'update_num'; // 情報をロード
        public static const ECC_NONE:int   = 0                // 属性スロット消費なし
        public static const ECC_WHITE:int  = 1                // 属性スロットホワイト（幸運系）
        public static const ECC_BLACK:int  = 2                // 属性スロットブラック（悪運系）
        public static const ECC_RED:int    = 3                // 属性スロットレッド（近接攻撃系）
        public static const ECC_GREEN:int  = 4                // 属性スロットグリーン（遠距離攻撃系）
        public static const ECC_BLUE:int   = 5                // 属性スロットブルー（防御系）
        public static const ECC_YELLOW:int = 6                // 属性スロットイエロー（特殊系）
        public static const ECC_PURPLE:int = 7                // 属性スロットパープル（地形・移動系）

        private static var __loader:Function;         // パラムを読み込む関数
        private static var __items:Object =[];        // ロード済みのカード
        private static var __loadings:Object ={};     // ロード中のカード
        private static var __registItems:Array = []; /* of EventCard */ 

        private var _name         :String;   // 名前
        private var _no           :int;      // 効果番号
        private var _cost         :int;      // コスト
        private var _color        :int;      // 属性
        private var _maxInDeck    :int;      // デッキでの最大枚数
        private var _restriction  :Array;    // キャラ制限
        private var _image        :String;   // SWF名
        private var _caption      :String;   // 説明
        private var _version      :int;

        private var _num           :int = 0;    // 所持枚数
        private var _type          :int = InventorySet.TYPE_EVENT;    // 

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

                var a:Array; /* of ElementType */ 
                if (ConstData.getData(ConstData.EVENT_CARD, id) != null)
                {
                    a = ConstData.getData(ConstData.EVENT_CARD, id)
                    updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7],a[8], 0, true);
                }

//             }
        }

        // データを再読込（再ログイン時にデータ更新を確認するため）
        public static function clearData():void
        {
            __items.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }


        // IDのEventCardインスタンスを返す
        public static function ID(id:int):EventCard
        {
//            log.writeLog(log.LV_INFO, "static EventCard" ,"get id",id, __items[id]);
            if (__items[id] == null)
            {
                __items[id] = new EventCard(id);
                getData(id);
            }else{

                if (!(__items[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __items[id];
        }

        // ローダがEventCardのパラメータを更新する
        public static function updateParam(id:int, name:String, no:int, cost:int, color:int, maxInDeck:int, restriction:String, image:String, caption:String, version:int, cache:Boolean=false):void
        {
            if (__items[id] == null)
            {
                __items[id] = new EventCard(id);
            }
            __items[id]._id            = id;
            __items[id]._name          = name;
            __items[id]._no            = no;
            __items[id]._cost          = cost;
            __items[id]._color         = color;
            __items[id]._maxInDeck     = maxInDeck;
            __items[id]._restriction   = restriction.split(",");
            __items[id]._image         = image;
            __items[id]._caption       = caption;
            __items[id]._version       = version;

//             if (!cache)
//             {
//                 Cache.setCache(Cache.EVENT_CARD, id, name, no, cost, color, maxInDeck, restriction, image, caption, version);
//             }


            if (__items[id]._loaded)
            {
                __items[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static EventCard" ,"load update",id,__items[id]._loaded);
            }
            else
            {
                __items[id]._loaded  = true;
                __items[id].notifyAll();
                __items[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static EventCard" ,"load init",id,__items[id]);
            }
            __loadings[id] = false;
        }

        // 登録時に使えるパーツリストをセットする
        public static function setRegistItems(ids:Array /* of int */ ):void
        {
            ids.forEach(function(item:*, index:int, array:Array):void{__registItems.push(ID(item))});
        }

        public static function getRegistItems():Array /* of EventCards */
        {
            return __registItems;
        }

        // コンストラクタ
        public function EventCard(id:int)
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

        public function get color():int
        {
            return _color;
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
            return new new ReLoaderThread(__loader, EventCard.ID(id));
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
        public function get type():int
        {
            return _type;
        }

    }
}
// import org.libspark.thread.Thread;
// import org.libspark.thread.utils.ParallelExecutor;

// import model.EventCard;
// import model.Feat;

// // EventCardのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _ap:EventCard;

//     public function Loader(ap:EventCard)
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
