package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;
    import model.utils.*;

    /**
     * ショップクラス
     * 情報を扱う
     * 
     */
    public class RareCardLot extends BaseModel
    {
        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード

        public static const KIND_BRONZE:int = 0; // ブロンズクジ
        public static const KIND_SILVER:int = 1; // シルバークジ
        public static const KIND_GOLD:int   = 2; // ゴールドクジ
        public static const KIND_LENGTH:int = 3; // クジの種類数

        public static const GENRE_RED:int    = 0; // 確率ジャンル赤
        public static const GENRE_YELLOW:int = 1; // 確率ジャンル黄
        public static const GENRE_GREEN:int  = 2; // 確率ジャンル緑
        public static const GENRE_BLUE:int   = 3; // 確率ジャンル青
        public static const GENRE_GRAY:int   = 4; // 確率ジャンル灰
        public static const GENRE_LENGTH:int = 5; // 確率ジャンルの総数

        public static const GENRE_SEPARATER_SET:Array = [200,300,400,500,600];  // 確率ジャンルの区切り番号



        private static var __initData:Boolean = false;

        private static var __lotsListSet        :Array = []; /* of rareCardLots Array */ 
        private static var __genreListSet        :Array = []; /* of int Array */ 
        private static var __rareCardLots:Object =[];        // ロード済みのクエスト

        private var _lotKind:int;        // 種類
        private var _articleKind:int;    // 商品のタイプ
        private var _articleID:int;      // 商品のID
        private var _order:int;          // 商品のID
        private var _num:int;            // 渡す数
        private var _visibleState:int    // 可視性の設定
        private var _description:String; // キャプション
        private var _color:int;
        private var _start:Boolean = false;
        private var _finish:Boolean = false;

        // ローダがShopのパラメータを更新する
        public static function updateParam(id:int, lotKind:int, articleKind:int, articleID:int, order:int, v:int,description:String, num:int):void
        {
          log.writeLog(log.LV_FATAL, "RARE_CARD_LOT", "updateparam ", id,lotKind, articleKind, articleID, order, description);
            if (__rareCardLots[id] == null)
            {
                __rareCardLots[id] = new RareCardLot(id);
            }
            __rareCardLots[id]._id            = id;
            __rareCardLots[id]._lotKind = lotKind;
            __rareCardLots[id]._articleKind = articleKind;
            __rareCardLots[id]._articleID = articleID;
            __rareCardLots[id]._order = order;
            __rareCardLots[id]._visibleState    = v;
            __rareCardLots[id]._description = description;
            __rareCardLots[id]._num = num;
            __rareCardLots[id]._loaded  = true;
            __rareCardLots[id].notifyAll();
            __rareCardLots[id].dispatchEvent(new Event(INIT));
//          log.writeLog(log.LV_INFO, "static RareCardLot" ,"load init",id, __rareCardLots[id]);
        }

        // コンストラクタ
        public function RareCardLot(id:int)
        {
            _id = id;
        }

        private static function initializeData():void
        {

            log.writeLog(log.LV_INFO, "RareCardLot Static", "initialize Data");
            if (__initData == false)
            {
                for (var i:int = 0; i < KIND_LENGTH; i++)
                {
                    log.writeLog(log.LV_INFO, "RareCardLot Static", "initialize Data kind set add",i);
                    __lotsListSet.push([]);
                }

                var num:int = 1;
                var a:Array; /* of ElementType */ 
                while ( ConstData.getData(ConstData.RARE_CARD_LOT, num) != null ) {
                    a = ConstData.getData(ConstData.RARE_CARD_LOT,num);
                    log.writeLog(log.LV_INFO, "RareCardLot Static", "initialize Data",num,a);
                    updateParam(num, a[1], a[2], a[3], a[4], a[5], a[6], a[7]) ;
                    __lotsListSet[__rareCardLots[num]._lotKind].push(__rareCardLots[num]);
                    num++;
                }

                for (var j:int = 0; j < KIND_LENGTH; j++)
                {
//                    log.writeLog(log.LV_INFO, "RareCardLot Static", "sort on",__lotsListSet[j]);
                    var sortSet:Array  = __lotsListSet[j];
                    sortSet.sortOn("order", Array.NUMERIC);
                }
                initializeGenreData();

                __initData = true;

            }
            log.writeLog(log.LV_INFO, "RareCardLot Static", "initialize Data END!!");
        }

        private static function initializeGenreData():void
        {
            var ret:Array = []; /* of Array */ 
            for (var j:int = 0; j < KIND_LENGTH; j++)
                {
                    // ジャンルごとの区切り位置をとりあえず0で満たす
                    var genreSet:Array = []; /* of int */
                    for(var k:int = 0; k < GENRE_LENGTH; k++){
                        genreSet[k] = 0;
                    }
                    // 各クジの種類を頭から読んでいって自分のジャンルをインクリメントしていく
                    var lotSet:Array  = __lotsListSet[j];
                    for(var i:int = 0; i < lotSet.length; i++)
                    {
                        var x:RareCardLot = RareCardLot(lotSet[i]);
                        for(var m:int = 0; m < GENRE_LENGTH; m++){
                            if(x.order < GENRE_SEPARATER_SET[m])
                            {
                                genreSet[m]+=1;
                                x._color = m;
                                if(genreSet[m]==1)
                                {
                                    x._start = true;
                                    if(i!=0){RareCardLot(lotSet[i-1])._finish = true};
                                }

                                if(i == lotSet.length-1 ){x._finish = true}
                                break;
                            }
                        }
                    }
                    ret[j] = genreSet;
                }

            log.writeLog(log.LV_INFO, "RareCardLot Static", "genre set is" ,ret);
            __genreListSet = ret;
        }

        public static function getLotList(kind:int):Array
        {
            initializeData();
            return __lotsListSet[kind];
        }


        public static function getGenreList(kind:int):Array
        {
            initializeData();
            return __genreListSet[kind];
        }

        public function get articleKind():int
        {
            return _articleKind;
        }

        public function get articleID():int
        {
            return _articleID;
        }
        public function get order():int
        {
            return _order;
        }
        public function get visibleState():int
        {
            return _visibleState;
        }
        public function get num():int
        {
            return _num;
        }
        public  function get color():int
        {
            return _color;
        }
        public  function get start():Boolean
        {
            return _start;
        }
        public  function get finish():Boolean
        {
            return _finish;
        }

    }
}
