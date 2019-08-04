package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * アバターアイテムクラス
     * 情報を扱う
     *
     */
    public class RealMoneyItem extends BaseModel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ITEM	:String = "アイテム";
        CONFIG::LOCALE_JP
        private static const _TRANS_CARD	:String = "カード";
        CONFIG::LOCALE_JP
        private static const _TRANS_PART	:String = "パーツ";
        CONFIG::LOCALE_JP
        private static const _TRANS_SPECIAL	:String = "特殊";

        CONFIG::LOCALE_EN
        private static const _TRANS_ITEM	:String = "Items";
        CONFIG::LOCALE_EN
        private static const _TRANS_CARD	:String = "Cards";
        CONFIG::LOCALE_EN
        private static const _TRANS_PART	:String = "Parts";
        CONFIG::LOCALE_EN
        private static const _TRANS_SPECIAL	:String = "Specials";

        CONFIG::LOCALE_TCN
        private static const _TRANS_ITEM	:String = "道具";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CARD	:String = "卡片";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PART	:String = "零部件";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SPECIAL	:String = "特殊";

        CONFIG::LOCALE_SCN
        private static const _TRANS_ITEM	:String = "道具";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CARD	:String = "卡片";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PART	:String = "配件";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SPECIAL	:String = "特殊";

        CONFIG::LOCALE_KR
        private static const _TRANS_ITEM	:String = "아바타";
        CONFIG::LOCALE_KR
        private static const _TRANS_CARD	:String = "カード";
        CONFIG::LOCALE_KR
        private static const _TRANS_PART	:String = "배틀";
        CONFIG::LOCALE_KR
        private static const _TRANS_SPECIAL	:String = "특수";

        CONFIG::LOCALE_FR
        private static const _TRANS_ITEM	:String = "Objet";
        CONFIG::LOCALE_FR
        private static const _TRANS_CARD	:String = "Cart";
        CONFIG::LOCALE_FR
        private static const _TRANS_PART	:String = "Pièces détachées";
        CONFIG::LOCALE_FR
        private static const _TRANS_SPECIAL	:String = "Spécial";

        CONFIG::LOCALE_ID
        private static const _TRANS_ITEM	:String = "アイテム";
        CONFIG::LOCALE_ID
        private static const _TRANS_CARD	:String = "カード";
        CONFIG::LOCALE_ID
        private static const _TRANS_PART	:String = "パーツ";
        CONFIG::LOCALE_ID
        private static const _TRANS_SPECIAL	:String = "特殊";

        CONFIG::LOCALE_TH
        private static const _TRANS_ITEM    :String = "Item";
        CONFIG::LOCALE_TH
        private static const _TRANS_CARD    :String = "Cards";
        CONFIG::LOCALE_TH
        private static const _TRANS_PART    :String = "ชิ้นส่วน";
        CONFIG::LOCALE_TH
        private static const _TRANS_SPECIAL :String = "พิเศษ";


        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        public static var inited:Boolean = false; // 初期化済みか

        private static var __loader:Function;         // パラムを読み込む関数
        private static var __items:Object =[new RealMoneyItem(0)];        // ロード済みのアイテム
        private static var __loadings:Object ={};     // ロード中のアイテム
        private static var __registItems:Array = []; /* of RealMoneyItem */

        private static var __avatarItems:Array = [];
        private static var __partItems:Array = [];
        private static var __eventCardItems:Array  = [];
        private static var __weaponCardItems:Array = [];
        private static var __charaCardItems:Array  = [];
        private static var __setItems:Array  = [];

        private static var __avatarItemSet          :Vector.<AvatarItem> = new Vector.<AvatarItem>();
        private static var __partItemSet            :Vector.<AvatarPart> = new Vector.<AvatarPart>();
        private static var __eventCardItemSet       :Vector.<EventCard>  = new Vector.<EventCard>();
        private static var __weaponCardItemSet      :Vector.<WeaponCard> = new Vector.<WeaponCard>();
        private static var __charaCardItemSet       :Vector.<CharaCard>  = new Vector.<CharaCard>();
        private static var __setItemSet             :Vector.<*>          = new Vector.<*>();

        private static var __avatarItemPriceSet     :Vector.<Number> = new Vector.<Number>;
        private static var __partItemPriceSet       :Vector.<Number> = new Vector.<Number>;
        private static var __eventCardItemPriceSet  :Vector.<Number> = new Vector.<Number>;
        private static var __weaponCardItemPriceSet :Vector.<Number> = new Vector.<Number>;
        private static var __charaCardItemPriceSet  :Vector.<Number> = new Vector.<Number>;
        private static var __setItemPriceSet        :Vector.<Number> = new Vector.<Number>;

        // セール状態か
        private static var __isSale:Boolean = false;

        private var _name         :String;   // 名前
        private var _price        :Number;      // 効果番号
        private var _itemType     :int;      // アイテムのタイプ
        private var _itemId       :int;      // アイテムのID
        private var _num          :int;      // 販売数
        private var _order        :int;      // 並ぶ優先順位
        private var _state        :int;      // 状態（新発売、おすすめなど）
        private var _imageUrl     :String;   // GIF名
        private var _tab          :int;      // どのタブにでるか？
        private var _description  :String;   // 説明
        private var _imageFrame   :int;      // 表示するフレーム
        private var _extraId      :int;      // セットアイテムID
        private var _saleType     :int;      // セールタイプ
        private var _deckImageUrl :String;   // デッキセット時のswf名

        private var _setItems:Vector.<RealMoneyItem> = null;
        private var _setFinish:Boolean = false; // セットアイテムを設定済み

        // アイテムの種類定数
//        public static const ITEM_TYPE:Array = ["アバター", "クエスト", "バトル", "特殊"];
        public static const ITEM_TYPE:Array = [_TRANS_ITEM, _TRANS_PART, _TRANS_CARD, _TRANS_SPECIAL];

        // ショップタブに格納されるタイプ纏める
        public static const ITEM_TYPE_ID_SET:Array = [[0], [1],[4, 2, 3],[5]];
        private static var __rmSet:Array  = [__avatarItems,__partItems,__eventCardItems,__weaponCardItems,__charaCardItems,__setItems];
        private static var __itemsSet:Array  = [__avatarItemSet,__partItemSet,__eventCardItemSet,__weaponCardItemSet,__charaCardItemSet,__setItemSet];
        private static var __priceSet:Array  = [__avatarItemPriceSet,__partItemPriceSet,__eventCardItemPriceSet,__weaponCardItemPriceSet,__charaCardItemPriceSet,__setItemPriceSet];
        public static const ITEM_BASIS:int = 0;
        public static const ITEM_AUTO_PLAY:int = 1;
        public static const ITEM_DUEL:int = 2;
        public static const ITEM_SPECIAL:int = 3;
        // 全部一緒くたに並べたときの優先順位
        public static const SORT_TAB_VALUE:Array = [1,4,2,3,5,6,7,0,9,10,11,12,13,14]; /* of int*/

        // アイテムタイプ
        public static const RM_ITEM_TYPE_ITEM:int   = 0;
        public static const RM_ITEM_TYPE_PART:int   = 1;
        public static const RM_ITEM_TYPE_EVENT:int  = 2;
        public static const RM_ITEM_TYPE_WEAPON:int = 3;
        public static const RM_ITEM_TYPE_CHARA:int  = 4;
        public static const RM_ITEM_TYPE_DECK:int   = 5;

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
        }

        private static function isSaleItem(x:RealMoneyItem):Boolean
        {
            return (x.state==Const.RM_ITEM_STATE_SALE||x.state==Const.RM_ITEM_STATE_SALE_RECOMMENDED);
        }
        public static function isSetItemData(x:RealMoneyItem,isSaleTime:Boolean):Boolean
        {
            if (isSaleTime) {
                var setType:int = Player.instance.avatar.saleType;
                if (Const.SALE_NON_TARGET_RM_ITEM_IDS.indexOf(x.id)!=-1||(isSaleItem(x)&&x.saleType == setType))
                {
                    return true;
                }
            } else {
                if (x.state != Const.RM_ITEM_STATE_SALE && x.state != Const.RM_ITEM_STATE_SALE_RECOMMENDED) {
                    return true;
                }
            }
            return false;
        }
        public static function initData():void
        {
            var i:int = 0;
            while ( ConstData.getData(ConstData.REAL_MONEY_ITEM, i) ) {
                var temp:Array = ConstData.getData(ConstData.REAL_MONEY_ITEM, i);
                updateParam( temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],temp[11],temp[12],temp[13],temp[14] );
                i++;
            }

            // セール状態かチェック
            __isSale = Player.instance.avatar.isSaleTime;

            // リストに振り分ける
            setItemList();
        }
        public static function resetData():void
        {
            var isSaleTime:Boolean = Player.instance.avatar.isSaleTime;
            // セール状態は変化しているか
            if ( isSaleTime == __isSale ) {
                // 変わってないならデータ更新しない
                return;
            }

            // セール状態が変化しているので、データを入れ替え
            __isSale = isSaleTime;

            // 一度初期化する
            __avatarItems.length = 0;
            __partItems.length = 0;
            __weaponCardItems.length = 0;
            __charaCardItems.length = 0;
            __setItems.length = 0;
            __avatarItemSet.length = 0;
            __partItemSet.length = 0;
            __weaponCardItemSet.length = 0;
            __charaCardItemSet.length = 0;
            __setItemSet.length = 0;
            __avatarItemPriceSet.length = 0;
            __partItemPriceSet.length = 0;
            __weaponCardItemPriceSet.length = 0;
            __charaCardItemPriceSet.length = 0;
            __setItemPriceSet.length = 0;

            // リストに振り分ける
            setItemList();
        }
        private static function setItemList():void
        {
            var i:int = 0;
            var setItemType:Array = [];
            // アイテムのタイプベルに格納
            for(i = 1; i < __items.length; i++)
            {
                var x:RealMoneyItem = __items[i];
                if (isSetItemData(x,__isSale) && x._tab != 11)
                {
                    if ( x.extraId > 0 && Const.SHOP_SIGN_RMITEM_IDS.indexOf(x.extraId) == -1 )
                    { // セットアイテムが印章じゃなければ、セット商品
                        if (x._setFinish == false) {
                            // セット内容を保存してしまう
                            x.addSetItems(ID(x.extraId));
                            x._setFinish = true;
                        }
                        __setItems.push(x);
                    } else {
                        switch (x._itemType)
                        {
                        case Shop.KIND_ITEM:
                            if (x._tab !=3)
                            {
                                __avatarItems.push(x);
                            }
                            break;
                        case Shop.KIND_PART:
                            __partItems.push(x);
                            break;
                        case Shop.KIND_EVENT_CARD:
                            __partItems.push(x);
                            break;
                        case Shop.KIND_WEAPON_CARD:
                            __weaponCardItems.push(x);
                            break;
                        case Shop.KIND_CHARA_CARD:
                            __charaCardItems.push(x);
                            break;
                        case Shop.KIND_SET_ITEM:
                            // デッキのみ単一でも追加
                            if (Const.RM_ITEM_DECK_ID.indexOf(x.id) != -1) {
                                __setItems.push(x);
                            }
                            break;
                        default:
                        }
                    }
                }
            }
            __avatarItems.sortOn("order", Array.NUMERIC);
            __partItems.sortOn("order", Array.NUMERIC);
            __weaponCardItems.sortOn("order", Array.NUMERIC);
            __charaCardItems.sortOn("order", Array.NUMERIC);
            __setItems.sortOn("order", Array.NUMERIC);

            for(i = 0; i < __avatarItems.length; i++)
            {
                __avatarItemSet.push(AvatarItem.ID(__avatarItems[i]._itemId));
                __avatarItemPriceSet.push(__avatarItems[i]._price);
            }
            for( i = 0; i < __partItems.length; i++)
            {
                __partItemSet.push(AvatarPart.ID(__partItems[i]._itemId));
                __partItemPriceSet.push(__partItems[i]._price);

            }
            for( i = 0; i < __eventCardItems.length; i++)
            {
                __eventCardItemSet.push(EventCard.ID(__eventCardItems[i]._itemId));
                __eventCardItemPriceSet.push(__eventCardItems[i]._price);
            }
            for( i = 0; i < __weaponCardItems.length; i++)
            {
                __weaponCardItemSet.push(WeaponCard.ID(__weaponCardItems[i]._itemId));
                __weaponCardItemPriceSet.push(__weaponCardItems[i]._price);
            }
            for( i = 0; i < __charaCardItems.length; i++)
            {
                __charaCardItemSet.push(CharaCard.ID(__charaCardItems[i]._itemId));
                __charaCardItemPriceSet.push(__charaCardItems[i]._price);
            }
            for( i = 0; i < __setItems.length; i++)
            {
                var item:*;
                switch (__setItems[i]._itemType)
                {
                case Shop.KIND_ITEM:
                    if (__setItems[i]._tab !=3)
                    {
                        item = AvatarItem.ID(__setItems[i]._itemId);
                    }
                    break;
                case Shop.KIND_PART:
                    item = AvatarPart.ID(__setItems[i]._itemId);
                    break;
                case Shop.KIND_EVENT_CARD:
                    item = EventCard.ID(__setItems[i]._itemId);
                    break;
                case Shop.KIND_WEAPON_CARD:
                    item = WeaponCard.ID(__setItems[i]._itemId);
                    break;
                case Shop.KIND_CHARA_CARD:
                    item = CharaCard.ID(__setItems[i]._itemId);
                    break;
                default:
                }
                __setItemSet.push(item);
                __setItemPriceSet.push(__setItems[i]._price);
            }
        }
        private function addSetItems(x:RealMoneyItem):void
        {
            if ( _setItems == null ) {
                _setItems = new Vector.<RealMoneyItem>();
            }
            _setItems.push(x);

            if ( x.extraId > 0 && Const.SHOP_SIGN_RMITEM_IDS.indexOf(x.extraId) == -1 ) {
                addSetItems(ID(x.extraId));
            }
        }

        private static function getData(id:int):void
        {
            if (__loader == null)
            {
                throw new Error("Warning: Loader is undefined.");
            }else{
                __loadings[id] = true;
                new ReLoaderThread(__loader, RealMoneyItem.ID(id)).start();
            }
        }

        // データを再読込（再ログイン時にデータ更新を確認するため）
        public static function clearData():void
        {
//            __items.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }

        // IDのRealMoneyItemインスタンスを返す
        public static function ID(id:int):RealMoneyItem
        {
//            log.writeLog(log.LV_INFO, "static RealMoneyItem" ,"get id",id, __items[id]);
            if (__items[id] == null)
            {
                __items[id] = new RealMoneyItem(id);
                getData(id);
            }else{

                if (!(__items[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __items[id];
        }

        // ローダがRealMoneyItemのパラメータを更新する
        public static function updateParam(id:int, name:String, price:Number, itemType:int, itemId:int, num:int, order:int, state:int, imageUrl:String, tab:int, description:String, imageFrame:int, extraId:int, saleType:int, deckImageUrl:String):void
        {
//            log.writeLog(log.LV_FATAL, "static real money item++++",
//                         id, name, price, itemType, itemId, num, order, state, imageUrl, tab, description
//                );
            if (__items[id] == null)
            {
                __items[id] = new RealMoneyItem(id);
            }
            __items[id]._id           = id;
            __items[id]._name         = name;
            __items[id]._price        = price;
            __items[id]._itemType     = itemType;
            __items[id]._itemId       = itemId;
            __items[id]._num          = num;
            __items[id]._order        = order+((SORT_TAB_VALUE[tab])*100);
            __items[id]._state        = state;
            __items[id]._imageUrl     = imageUrl;
            __items[id]._tab          = tab;
            __items[id]._description  = description;
            __items[id]._imageFrame   = imageFrame;
            __items[id]._extraId      = extraId;
            __items[id]._saleType     = saleType;
            __items[id]._deckImageUrl = deckImageUrl;


            if (__items[id]._loaded)
            {
                __items[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static RealMoneyItem" ,"load update",id,__items[id]._loaded);
            }
            else
            {
                __items[id]._loaded  = true;
                __items[id].notifyAll();
                __items[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static RealMoneyItem" ,"load init",id,__items[id]);
            }
            __loadings[id] = false;
        }

        public static function isSetTabItemData(x:RealMoneyItem,isSaleTime:Boolean):Boolean
        {
            if (isSaleTime) {
                var setType:int = Player.instance.avatar.saleType;
                if (Const.SALE_NON_TARGET_RM_ITEM_IDS.indexOf(x.id)!=-1||(isSaleItem(x)&&x.saleType == setType))
                {
                    return true;
                }
            } else {
                if (x.state != Const.RM_ITEM_STATE_SALE && x.state != Const.RM_ITEM_STATE_SALE_RECOMMENDED) {
                    return true;
                }
            }
            return false;
        }
        public static function getTabList(tab:int):Array
        {
            var isSaleTime:Boolean = Player.instance.avatar.isSaleTime;
            var ret:Array= [];
            for(var i:int = 1; i < __items.length; i++)
                    {
                        var x:RealMoneyItem = __items[i];
                        if (x.tab == tab && isSetTabItemData(x,isSaleTime))
                        {
                            ret.push(x);
                        }
                    }

            ret.sortOn("order");

            return ret;
        }

        public static function getItemList(type:int):*
        {
//            log.writeLog(log.LV_FATAL, "RealMoneyItem",type,__itemsSet);
            return __itemsSet[type];
        }

        public static function getPriceList(type:int):Vector.<Number>
        {
            return __priceSet[type];
        }

        public static function getRMList(type:int):*
        {
//            log.writeLog(log.LV_FATAL, "RealMoneyItem",type,__itemsSet);
            return __rmSet[type];
        }




        // コンストラクタ
        public function RealMoneyItem(id:int)
        {
            _id = id;
        }


        public function get name():String
        {
            return _name;
        }


        public function get description():String
        {
            return _description;
        }


        public function get price():Number
        {
            return _price;
        }
        public function get imageUrl():String
        {
            return _imageUrl;
        }

        public function get tab():int
        {
            return _tab;
        }
        public function get order():int
        {
            return _order;
        }
        public function get itemID():int
        {
            return _itemId;
        }
        public function get itemType():int
        {
            return _itemType;
        }
        public function get state():int
        {
            return _state;
        }
        public function get num():int
        {
            return _num;
        }
        public function get imageFrame():int
        {
            return _imageFrame;
        }
        public function get extraId():int
        {
            return _extraId;
        }
        public function get saleType():int
        {
            return _saleType;
        }
        public function get isSetSale():Boolean
        {
            return ( _setItems != null && _setItems.length > 0 ) ? true : false;
        }
        public function get setItems():Vector.<RealMoneyItem>
        {
            return _setItems;
        }
        public function get deckImageUrl():String
        {
            return _deckImageUrl;
        }


        public function getLoader():Thread
        {
            return new new ReLoaderThread(__loader, AvatarItem.ID(id));
        }

    }
}
