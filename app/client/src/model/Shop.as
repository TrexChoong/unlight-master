package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;
    import model.utils.ReLoaderThread;

    import model.utils.*;

    /**
     * ショップクラス
     * 情報を扱う
     *
     */
    public class Shop extends BaseModel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ITEM	:String = "アイテム";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD	:String = "カード";
        CONFIG::LOCALE_JP
        private static const _TRANS_PART	:String = "パーツ";
        CONFIG::LOCALE_JP
        private static const _TRANS_ETC		:String = "ETC";

        CONFIG::LOCALE_EN
        private static const _TRANS_ITEM	:String = "Items";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD	:String = "Cards";
        CONFIG::LOCALE_EN
        private static const _TRANS_PART	:String = "Parts";
        CONFIG::LOCALE_EN
        private static const _TRANS_ETC		:String = "Etc";

        CONFIG::LOCALE_TCN
        private static const _TRANS_ITEM	:String = "道具";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD	:String = "卡片";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PART	:String = "零部件";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ETC		:String = "ETC";

        CONFIG::LOCALE_SCN
        private static const _TRANS_ITEM	:String = "道具";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD	:String = "卡片";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PART	:String = "配件";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ETC		:String = "ETC";

        CONFIG::LOCALE_KR
        private static const _TRANS_ITEM	:String = "아바타";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD	:String = "カード";
        CONFIG::LOCALE_KR
        private static const _TRANS_PART	:String = "배틀";
        CONFIG::LOCALE_KR
        private static const _TRANS_ETC		:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_ITEM	:String = "Objet";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD	:String = "Carte";
        CONFIG::LOCALE_FR
        private static const _TRANS_PART	:String = "Pièces détachées";
        CONFIG::LOCALE_FR
        private static const _TRANS_ETC		:String = "et cetera";

        CONFIG::LOCALE_ID
        private static const _TRANS_ITEM	:String = "アイテム";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD	:String = "カード";
        CONFIG::LOCALE_ID
        private static const _TRANS_PART	:String = "パーツ";
        CONFIG::LOCALE_ID
        private static const _TRANS_ETC		:String = "ETC";

        CONFIG::LOCALE_TH
        private static const _TRANS_ITEM    :String = "Item";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD    :String = "Cards";
        CONFIG::LOCALE_TH
        private static const _TRANS_PART    :String = "ชิ้นส่วน";
        CONFIG::LOCALE_TH
        private static const _TRANS_ETC     :String = "ETC";


        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード

        public static const KIND_ITEM:int = 0; // プライスリストの種類アバターアイテムの場合
        public static const KIND_PART:int = 1; // プライスリストの種類アバターパーツの場合
        public static const KIND_EVENT_CARD:int = 2; // プライスリストの種類スロットカードの場合
        public static const KIND_WEAPON_CARD:int = 3; // プライスリストの種類スロットカードの場合
        public static const KIND_CHARA_CARD:int = 4; // プライスリストの種類スロットカードの場合
        public static const KIND_SET_ITEM:int = 5; // プライスリストの種類セットの場合

        private static var __loader:Function;         // パラムを読み込む関数
        private static var __shops:Object ={};        // ロード済みのショップ
        private static var __loadings:Object ={};     // ロード中のショップ


        private var _itemList             :Array = []; /* of AvaItemItem */
        private var _bodyPartsList        :Array = []; /* of AvatarPart */
        private var _clothPartsList       :Array = []; /* of AvatarPart */
        private var _accPartsList         :Array = []; /* of AvatarPart */
        private var _eventCardsList       :Array = []; /* of EvventCard */
        private var _weaponCardsList      :Array = []; /* of EvventCard */
        private var _charaCardsList       :Array = []; /* of EvventCard */

        private var _itemPriceList        :Array =[]; /* of int(item_id) */
        private var _bodyPartsPriceList   :Array =[]; /* of int(parts_id) */
        private var _clothPartsPriceList  :Array =[]; /* of int(parts_id) */
        private var _accPartsPriceList    :Array =[]; /* of int(parts_id) */
        private var _eventCardsPriceList  :Array =[]; /* of Array of int(cards_id) */
        private var _weaponCardsPriceList :Array =[]; /* of Array of int(cards_id) */
        private var _charaCardsPriceList  :Array =[]; /* of Array of int(cards_id) */

        private var _itemCoinList         :Array =[];        // Array of Array of int(coin_0-coin4)
        private var _bodyPartsCoinList    :Array =[];        // Array of Array of int(coin_0-coin4)
        private var _clothPartsCoinList   :Array =[];        // Array of Array of int(coin_0-coin4)
        private var _accPartsCoinList     :Array =[];        // Array of Array of int(coin_0-coin4)
        private var _eventCardsCoinList   :Array =[];   // Array of Array of int(coin_0-coin4)
        private var _weaponCardsCoinList  :Array =[];  // Array of Array of int(coin_0-coin4)
        private var _charaCardsCoinList   :Array =[];   // Array of Array of int(coin_0-coin4)

        private var _basisItemList        :Array;    /* of AvatarItem*/ ;   // 名前
        private var _autoPlayItemList     :Array;    /* of AvatarItem*/ ;   // 名前
        private var _duelItemList         :Array;    /* of AvatarItem*/ ;   // 名前
        private var _spcialItemList       :Array;    /* of AvatarItem*/ ;   // 名前
        private var _salePartsList        :Array;    /* of AvatarBodyParts */ ;   // 名前

        // アイテムの種類定数
        public static const PREMIUM_ITEM_TYPE:Array = [_TRANS_ITEM, _TRANS_PART, _TRANS_CARD, _TRANS_ETC];

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
                log.writeLog(log.LV_FATAL, "SHOP", "getDAtAA");
                var a:Array; /* of ElementType */
                if (ConstData.getData(ConstData.SHOP, id) != null)
                {
                    a = ConstData.getData(ConstData.SHOP, id);
                    log.writeLog(log.LV_FATAL, "SHOP", "getDAta ", id, a);

                    updateParam(id, a[1]);

                }
//                 __loadings[id] = true;
//                 new ReLoaderThread(__loader, Shop.ID(id)).start();
//             }
        }

        // IDのShopインスタンスを返す
        public static function ID(id:int):Shop
        {
            log.writeLog(log.LV_INFO, "static Shop" ,"get id",id, __shops[id]);
            if (__shops[id] == null)
            {
                __shops[id] = new Shop(id);
                getData(id);
            }else{
                if (__shops[id].loaded)
                {
                }else{
                    if (__loadings[id] == false){
                        getData(id);
                    }
                }
            }
            return __shops[id];
        }

        // ローダがShopのパラメータを更新する
        public static function updateParam(id:int, saleList:Array):void
        {
            log.writeLog(log.LV_FATAL, "SHOP", "updateparam ", id, saleList);
            if (__shops[id] == null)
            {
                __shops[id] = new Shop(id);
            }

            __shops[id]._id            = id;
            saleList.forEach(function(item:*, index:int, array:Array):void
                             {
                                 if(item[0] == KIND_ITEM)
                                 {
                                     var setItem:AvatarItem = AvatarItem.ID(item[1]);
                                     setItem.shopImageFrame = item[9];
                                     __shops[id]._itemList.push(setItem);
//                                     __shops[id]._itemList.push(AvatarItem.ID(item[1]));
                                     __shops[id]._itemPriceList[item[1]] = item[2];
                                     __shops[id]._itemCoinList[item[1]] = [item[3], item[4], item[5], item[6], item[7], item[8]];
                                 }
                                 else if (item[0] == KIND_PART)
                                 {
                                     var t:int = AvatarPart.ID(item[1]).genre;
                                     if (t == AvatarPart.GENRE_BODY)
                                     {
                                         __shops[id]._bodyPartsList.push(AvatarPart.ID(item[1]));
                                         __shops[id]._bodyPartsPriceList[item[1]] = item[2];
                                         __shops[id]._bodyPartsCoinList[item[1]] = [item[3], item[4], item[5], item[6], item[7], item[8]];
                                     }
                                     else if (t == AvatarPart.GENRE_CLOTH)
                                     {
                                         __shops[id]._clothPartsList.push(AvatarPart.ID(item[1]));
                                         __shops[id]._clothPartsPriceList[item[1]] = item[2];
                                         __shops[id]._clothPartsCoinList[item[1]] = [item[3], item[4], item[5], item[6], item[7], item[8]];
                                     }
                                     else if (t == AvatarPart.GENRE_ACCE)
                                     {
                                         __shops[id]._accPartsList.push(AvatarPart.ID(item[1]));
                                         __shops[id]._accPartsPriceList[item[1]] = item[2];
                                         __shops[id]._accPartsCoinList[item[1]] = [item[3], item[4], item[5], item[6], item[7], item[8]];
                                     }
                                 }
                                 else if (item[0] == KIND_EVENT_CARD)
                                 {
                                     __shops[id]._eventCardsList.push(EventCard.ID(item[1]));
                                     __shops[id]._eventCardsPriceList[item[1]] = item[2];
                                     __shops[id]._eventCardsCoinList[item[1]] = [item[3], item[4], item[5], item[6], item[7], item[8]];
                                 }
                                 else if (item[0] == KIND_WEAPON_CARD)
                                 {
                                     __shops[id]._weaponCardsList.push(WeaponCard.ID(item[1]));
                                     __shops[id]._weaponCardsPriceList[item[1]] = item[2];
                                     __shops[id]._weaponCardsCoinList[item[1]] = [item[3], item[4], item[5], item[6], item[7], item[8]];
                                 }
                                 else if (item[0] == KIND_CHARA_CARD)
                                 {
                                     __shops[id]._charaCardsList.push(CharaCard.ID(item[1]));
                                     __shops[id]._charaCardsPriceList[item[1]] = item[2];
                                     __shops[id]._charaCardsCoinList[item[1]] = [item[3], item[4], item[5], item[6], item[7], item[8]];
                                 }
                             });
            if (__shops[id]._loaded)
            {
                __shops[id].dispatchEvent(new Event(UPDATE));
                log.writeLog(log.LV_INFO, "static Shop" ,"load update",id,__shops[id]._loaded);
            }
            else
            {
                __shops[id]._loaded  = true;
                __shops[id].notifyAll();
                __shops[id].dispatchEvent(new Event(INIT));
                log.writeLog(log.LV_INFO, "static Shop" ,"load init",id,__shops[id]);
            }
            __loadings[id] = false;
        }

        // コンストラクタ
        public function Shop(id:int)
        {
            _id = id;
        }

        public function get itemList():Array  /* of AvatarItem */
        {
            return _itemList;
        }

        public function get bodyPartsList():Array  /* of AvatarBodyParts */
        {
            return _bodyPartsList;
        }
        public function get clothPartsList():Array  /* of AvatarClothParts */
        {
            return _clothPartsList;
        }
        public function get accPartsList():Array  /* of AvatarAccParts */
        {
            return _accPartsList;
        }
        public function get partsList():Array /* of AvatarParts */
        {
            var ret:Array = [];
            ret = _bodyPartsList.concat(_clothPartsList,_accPartsList);
            return ret;
        }

        public function get eventCardsList():Array  /* of AvatarParts */
        {
            return _eventCardsList;
        }
        public function get weaponCardsList():Array  /* of AvatarParts */
        {
            return _weaponCardsList;
        }
        public function get charaCardsList():Array  /* of AvatarParts */
        {
            return _charaCardsList;
        }
        public function get itemPriceList():Array  /* of AvatarParts */
        {
            return _itemPriceList;
        }
        public function get bodyPartsPriceList():Array  /* of AvatarParts */
        {
            return _bodyPartsPriceList;
        }
        public function get clothPartsPriceList():Array  /* of AvatarParts */
        {
            return _clothPartsPriceList;
        }
        public function get accPartsPriceList():Array  /* of AvatarParts */
        {
            return _accPartsPriceList;
        }
        public function get partsPriceList():Array  /* of AvatarParts */
        {
            var ret:Array = [];
            _bodyPartsList.forEach(function(item:*, index:int, array:Array):void
                             {
                                 ret[item.id] = _bodyPartsPriceList[item.id];
                             });
            _clothPartsList.forEach(function(item:*, index:int, array:Array):void
                             {
                                 ret[item.id] = _clothPartsPriceList[item.id];
                             });
            _accPartsList.forEach(function(item:*, index:int, array:Array):void
                             {
                                 ret[item.id] = _accPartsPriceList[item.id];
                             });
            return ret;
        }
        public function get eventCardsPriceList():Array  /* of AvatarParts */
        {
            return _eventCardsPriceList;
        }
        public function get weaponCardsPriceList():Array  /* of AvatarParts */
        {
            return _weaponCardsPriceList;
        }
        public function get charaCardsPriceList():Array  /* of AvatarParts */
        {
            return _charaCardsPriceList;
        }

        public function get itemCoinList():Array  /* of AvatarParts */
        {
            return _itemCoinList;
        }
        public function get bodyPartsCoinList():Array  /* of AvatarParts */
        {
            return _bodyPartsCoinList;
        }
        public function get clothPartsCoinList():Array  /* of AvatarParts */
        {
            return _clothPartsCoinList;
        }
        public function get accPartsCoinList():Array  /* of AvatarParts */
        {
            return _accPartsCoinList;
        }
        public function get partsCoinList():Array  /* of AvatarParts */
        {
            var ret:Array = [];
            var i:int;
            _bodyPartsList.forEach(function(item:*, index:int, array:Array):void
                             {
                                 ret[item.id] = _bodyPartsCoinList[item.id];
                             });
            _clothPartsList.forEach(function(item:*, index:int, array:Array):void
                             {
                                 ret[item.id] = _clothPartsCoinList[item.id];
                             });
            _accPartsList.forEach(function(item:*, index:int, array:Array):void
                             {
                                 ret[item.id] = _accPartsCoinList[item.id];
                             });
            return ret;
        }
        public function get eventCardsCoinList():Array  /* of AvatarParts */
        {
            return _eventCardsCoinList;
        }
        public function get weaponCardsCoinList():Array  /* of AvatarParts */
        {
            return _weaponCardsCoinList;
        }
        public function get charaCardsCoinList():Array  /* of AvatarParts */
        {
            return _charaCardsCoinList;
        }

        public function getLoader():Thread
        {
            return new ReLoaderThread(__loader, Shop.ID(id));
        }

    }
}
// import org.libspark.thread.Thread;
// import org.libspark.thread.utils.ParallelExecutor;

// import model.Shop;
// import model.Feat;

// // Shopのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _ap:Shop;

//     public function Loader(ap:Shop)
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

// // Shopのロードを待つスレッド
// class ReLoader extends Thread
// {
//     private var _loader:Function;
//     private var _id:int;
//     private static const INTERVAL:int =2000; // 再ロードのms

//     public function ReLoader(func:Function, id:int)
//     {
//         _loader = func;
//         _id = id;
//     }

//     protected override function run():void
//     {
//         _loader(_id);
//         next(waitingTimer);
//     }

//     private function waitingTimer ():void
//     {
//         sleep(INTERVAL);
//         next(reload);
//     }
//     private function reload():void
//     {
//         if (Shop.ID(_id).loaded == false)
//         {
//             _loader(_id);
//             next(waitingTimer);
//             log.writeLog(log.LV_WARN, "Shop" ,"load Fail ReLoad!!",_id);
//         }
//     }
// }
