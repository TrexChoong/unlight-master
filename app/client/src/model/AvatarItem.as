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
    public class AvatarItem extends BaseModel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_AVATAR	:String = "アバター";
        CONFIG::LOCALE_JP
        private static const _TRANS_QUEST	:String = "クエスト";
        CONFIG::LOCALE_JP
        private static const _TRANS_BATTLE	:String = "バトル";
        CONFIG::LOCALE_JP
        private static const _TRANS_SPECIAL	:String = "特殊";
        CONFIG::LOCALE_JP
        private static const _TRANS_RAID	:String = "レイド";

        CONFIG::LOCALE_EN
        private static const _TRANS_AVATAR	:String = "Avatar";
        CONFIG::LOCALE_EN
        private static const _TRANS_QUEST	:String = "Quest";
        CONFIG::LOCALE_EN
        private static const _TRANS_BATTLE	:String = "Duel";
        CONFIG::LOCALE_EN
        private static const _TRANS_SPECIAL	:String = "Special";
        CONFIG::LOCALE_EN
        private static const _TRANS_RAID	:String = "Raid";

        CONFIG::LOCALE_TCN
        private static const _TRANS_AVATAR	:String = "虛擬人物";
        CONFIG::LOCALE_TCN
        private static const _TRANS_QUEST	:String = "任務";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BATTLE	:String = "對戰";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SPECIAL	:String = "特殊";
        CONFIG::LOCALE_TCN
        private static const _TRANS_RAID	:String = "突擊";

        CONFIG::LOCALE_SCN
        private static const _TRANS_AVATAR	:String = "虚拟人物";
        CONFIG::LOCALE_SCN
        private static const _TRANS_QUEST	:String = "任务";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BATTLE	:String = "战斗";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SPECIAL	:String = "特殊";
        CONFIG::LOCALE_SCN
        private static const _TRANS_RAID	:String = "突击";

        CONFIG::LOCALE_KR
        private static const _TRANS_AVATAR	:String = "아바타";
        CONFIG::LOCALE_KR
        private static const _TRANS_QUEST	:String = "퀘스트";
        CONFIG::LOCALE_KR
        private static const _TRANS_BATTLE	:String = "배틀";
        CONFIG::LOCALE_KR
        private static const _TRANS_SPECIAL	:String = "특수";
        CONFIG::LOCALE_KR
        private static const _TRANS_RAID	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_AVATAR	:String = "Avatar";
        CONFIG::LOCALE_FR
        private static const _TRANS_QUEST	:String = "Quête";
        CONFIG::LOCALE_FR
        private static const _TRANS_BATTLE	:String = "Duel";
        CONFIG::LOCALE_FR
        private static const _TRANS_SPECIAL	:String = "Spécial";
        CONFIG::LOCALE_FR
        private static const _TRANS_RAID	:String = "Raid";

        CONFIG::LOCALE_ID
        private static const _TRANS_AVATAR	:String = "アバター";
        CONFIG::LOCALE_ID
        private static const _TRANS_QUEST	:String = "クエスト";
        CONFIG::LOCALE_ID
        private static const _TRANS_BATTLE	:String = "バトル";
        CONFIG::LOCALE_ID
        private static const _TRANS_SPECIAL	:String = "特殊";
        CONFIG::LOCALE_ID
        private static const _TRANS_RAID	:String = "レイド";

        CONFIG::LOCALE_TH
        private static const _TRANS_AVATAR  :String = "อวาตาร์";
        CONFIG::LOCALE_TH
        private static const _TRANS_QUEST   :String = "เควส";
        CONFIG::LOCALE_TH
        private static const _TRANS_BATTLE  :String = "การต่อสู้";
        CONFIG::LOCALE_TH
        private static const _TRANS_SPECIAL :String = "พิเศษ";
        CONFIG::LOCALE_TH
        private static const _TRANS_RAID    :String = "Raid";


        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード

        private static var __loader:Function;         // パラムを読み込む関数
        private static var __items:Object =[];        // ロード済みのカード
        private static var __loadings:Object ={};     // ロード中のカード
        private static var __registItems:Array = []; /* of AvatarItem */

        private var _name          :String;   // 名前
        private var _no            :int;      // 効果番号
        private var _type          :int;      // 種類
        private var _cond          :String;   // その他設定値
        private var _image         :String;   // SWF名
        private var _imageFrame    :int;      // SWFの指定フレーム
        private var _shopImageFrame:int;      // ショップでのSWFの指定フレーム
        private var _effectImage   :String;   // 使用時のエフェクト
        private var _caption       :String;   // 説明
        private var _version       :int;

        private var _subTypes      :Array = [];    // 種類

        // アイテムの種類定数
//        public static const ITEM_TYPE:Array = ["アバター", "クエスト", "バトル", "特殊"];
        CONFIG::RAID_ITEM_ON
        public static const ITEM_TYPE:Array = [_TRANS_AVATAR,_TRANS_QUEST,_TRANS_BATTLE,_TRANS_RAID,_TRANS_SPECIAL];
        CONFIG::RAID_ITEM_OFF
        public static const ITEM_TYPE:Array = [_TRANS_AVATAR,_TRANS_QUEST,_TRANS_BATTLE,_TRANS_SPECIAL];

        public static const ITEM_BASIS:int = 0;   //エントランス
        public static const ITEM_AUTO_PLAY:int = 1;   //クエスト
        public static const ITEM_DUEL:int = 2;   //ボーナスゲーム
        public static const ITEM_SPECIAL:int = 3;   //チケットなど
        public static const ITEM_RAID:int = 4;   //レイド
        public static const ITEM_RESULT:int = 5;   //リザルト画像追加券

        CONFIG::RAID_ITEM_ON
        public static const ITEM_TAB_LIST:Array = [ITEM_BASIS,ITEM_AUTO_PLAY,ITEM_DUEL,ITEM_RAID,ITEM_SPECIAL];
        CONFIG::RAID_ITEM_OFF
        public static const ITEM_TAB_LIST:Array = [ITEM_BASIS,ITEM_AUTO_PLAY,ITEM_DUEL,ITEM_SPECIAL];


        public static function getTabIndexFromType(type:int):int
        {
            return ITEM_TAB_LIST.indexOf(type);
        }

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
                if (ConstData.getData(ConstData.AVATAR_ITEM, id) != null)
                {
                    a = ConstData.getData(ConstData.AVATAR_ITEM, id);
                    updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], 0, true);
                }
//             }
        }

        // データを再読込（再ログイン時にデータ更新を確認するため）
        public static function clearData():void
        {
            __items.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }

        // IDのAvatarItemインスタンスを返す
        public static function ID(id:int):AvatarItem
        {
//            log.writeLog(log.LV_INFO, "static AvatarItem" ,"get id",id, __items[id]);
            if (__items[id] == null)
            {
                __items[id] = new AvatarItem(id);
                getData(id);
            }else{

//                 if (!(__items[id].loaded || __loadings[id]))
//                 {
//                     getData(id);
//                 }
            }
            return __items[id];
        }

        // ローダがAvatarItemのパラメータを更新する
        public static function updateParam(id:int, name:String, no:int, type:int, subType:String, cond:String, image:String, imageFrame:int, effectImage:String, caption:String, version:int, cache:Boolean=false):void
        {
            if (__items[id] == null)
            {
                __items[id] = new AvatarItem(id);
            }
            __items[id]._id             = id;
            __items[id]._name           = name;
            __items[id]._no             = no;
            __items[id]._type           = type;
            __items[id]._cond           = cond;
            __items[id]._image          = image;
            __items[id]._imageFrame     = imageFrame;
            __items[id]._shopImageFrame = 0;
            __items[id]._effectImage    = effectImage;
            __items[id]._caption        = caption;
            __items[id]._version        = version;

            if (subType && subType != "") {
                var subTypes:Array = subType.split("+");
                for (var i:int=0; i<subTypes.length; i++) {__items[id]._subTypes.push(int(subTypes[i]))}
            }


//             if (!cache)
//             {
//                 Cache.setCache(Cache.AVATAR_ITEM, id, name, no, type, image, imageFrame, effectImage, caption, version);
//             }


            if (__items[id]._loaded)
            {
                __items[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static AvatarItem" ,"load update",id,__items[id]._loaded);
            }
            else
            {
                __items[id]._loaded  = true;
                __items[id].notifyAll();
                __items[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static AvatarItem" ,"load init",id,__items[id]);
            }
            __loadings[id] = false;
        }

        // 登録時に使えるパーツリストをセットする
        public static function setRegistItems(ids:Array /* of int */ ):void
        {
            ids.forEach(function(item:*, index:int, array:Array):void{__registItems.push(ID(item))});
        }

        public static function getRegistItems():Array /* of AvatarItems */
        {
            return __registItems;
        }

        // コンストラクタ
        public function AvatarItem(id:int)
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

        public function get type():int
        {
            return _type;
        }

        public function get cond():String
        {
            return _cond;
        }

        public function get image():String
        {
            return _image;
        }

        public function get imageFrame():int
        {
            return _imageFrame;
        }

        public function get shopImageFrame():int
        {
            return _shopImageFrame;
        }

        public function set shopImageFrame(shopImageFrame:int):void
        {
            _shopImageFrame = shopImageFrame;
        }

        public function get effectImage():String
        {
            return _effectImage;
        }
        public function get caption():String
        {
            return _caption;
        }
        public function get subTypes():Array
        {
            return _subTypes;
        }

        public function getLoader():Thread
        {
            return new new ReLoaderThread(__loader, AvatarItem.ID(id));
        }

    }
}
// import org.libspark.thread.Thread;
// import org.libspark.thread.utils.ParallelExecutor;

// import model.AvatarItem;
// import model.Feat;

// // AvatarItemのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _ap:AvatarItem;

//     public function Loader(ap:AvatarItem)
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
