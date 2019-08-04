package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * 必殺技クラス
     * 情報を扱う
     *
     */
    public class Feat extends BaseModel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ATK	:String = "攻撃";
        CONFIG::LOCALE_JP
        private static const _TRANS_DEF	:String = "防御";
        CONFIG::LOCALE_JP
        private static const _TRANS_MOV	:String = "移動";

        CONFIG::LOCALE_EN
        private static const _TRANS_ATK	:String = "Attack";
        CONFIG::LOCALE_EN
        private static const _TRANS_DEF	:String = "Defense";
        CONFIG::LOCALE_EN
        private static const _TRANS_MOV	:String = "Move";

        CONFIG::LOCALE_TCN
        private static const _TRANS_ATK	:String = "攻撃";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DEF	:String = "防御";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MOV	:String = "移動";

        CONFIG::LOCALE_SCN
        private static const _TRANS_ATK	:String = "攻击";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DEF	:String = "防御";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MOV	:String = "移动";

        CONFIG::LOCALE_KR
        private static const _TRANS_ATK	:String = "공격";
        CONFIG::LOCALE_KR
        private static const _TRANS_DEF	:String = "방어";
        CONFIG::LOCALE_KR
        private static const _TRANS_MOV	:String = "이동";

        CONFIG::LOCALE_FR
        private static const _TRANS_ATK	:String = "Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_DEF	:String = "Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_MOV	:String = "Déplacement";

        CONFIG::LOCALE_ID
        private static const _TRANS_ATK	:String = "攻撃";
        CONFIG::LOCALE_ID
        private static const _TRANS_DEF	:String = "防御";
        CONFIG::LOCALE_ID
        private static const _TRANS_MOV	:String = "移動";

        CONFIG::LOCALE_TH
        private static const _TRANS_ATK :String = "โจมตี";
        CONFIG::LOCALE_TH
        private static const _TRANS_DEF :String = "ป้องกัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_MOV :String = "เคลื่อนที่";


        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        private static var __loader:Function;         // パラムを読み込む関数
        private static var __feats:Object =[];        // ロード済みの必殺技
        private static var __loadings:Object ={};     // ロード中の必殺技

        public static const TYPE_ATK:int = 0;
        public static const TYPE_DEF:int = 1;
        public static const TYPE_MOVE:int = 2;

        private var _name          :String; // 名前
        private var _image         :String; // 必殺技のSWF名
        private var _caption       :String; // キャプション
        private var _type          :int;    // タイプ（攻撃、移動、防御）
        private var _version       :int;


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
                a = ConstData.getData(ConstData.FEAT, id);
                if (a != null)
                {

                    if (__feats[id] == null)
                    {
                        __feats[id] = new Feat(id);
                    }
                    __feats[id]._id            = id;
                    __feats[id]._name          = a[1];
                    __feats[id]._image         = a[2];
                    __feats[id]._caption       = a[3];;
                    __feats[id].setType();

                    if (__feats[id]._loaded)
                    {
                        __feats[id].dispatchEvent(new Event(UPDATE));
                    }
                    else
                    {
                        __feats[id]._loaded  = true;
                        __feats[id].notifyAll();
                        __feats[id].dispatchEvent(new Event(INIT));
                    }
                    __loadings[id] = false;
                }

//             }
        }

        public static function clearData():void
        {
        }

        // IDのFeatインスタンスを返す
        public static function ID(id:int):Feat
        {
            if (__feats[id] == null)
            {
                __feats[id] = new Feat(id);
                getData(id);
            }
            return __feats[id];
        }

        // ローダがFeatのパラメータを更新する
        public static function updateParam(id:int,  name:String, image:String, caption:String, version:int, cache:Boolean=false):void
        {

//             if (__feats[id] == null)
//             {
//                 __feats[id] = new Feat(id);
//             }
//             __feats[id]._id            = id;
//             __feats[id]._name          = name;
//             __feats[id]._image         = image;
//             __feats[id]._caption       = caption;
//             __feats[id].setType();
//             __feats[id]._version       = version;

//             if (!cache)
//             {
//                 Cache.setCache(Cache.FEAT, id, name, image, caption, version);
//             }

//             if (__feats[id]._loaded)
//             {
//                 __feats[id].dispatchEvent(new Event(UPDATE));
// //                log.writeLog(log.LV_INFO, "static Feat" ,"load update",id,__feats[id]._loaded);
//             }
//             else
//             {
//                 __feats[id]._loaded  = true;
//                 __feats[id].notifyAll();
//                 __feats[id].dispatchEvent(new Event(INIT));
// //                log.writeLog(log.LV_INFO, "static Feat" ,"load init",id,__feats[id]);
//             }
//             __loadings[id] = false;

        }


        // コンストラクタ
        public function Feat(id:int)
        {
            _id = id;
        }

        public function get name():String
        {
            return _name;
        }
        public function get image():String
        {
            return _image;
        }
        public function get caption():String
        {
            return _caption;
        }

        public function get type():int
        {
            return _type;
        }

        private function setType():void
        {
            var str:Array = caption.slice(caption.indexOf("[")+1, caption.indexOf("]")).split(":");
//            var strValue:Array = str[2].split(",");
            // 必殺技の発動タイミングの設定
            // フェイズ表記の部分のみ、どの言語でも日本語になっている
            //CONFIG::LOCALE_JP <-漢字をチェックを無視する
            if(str[0] == "攻撃")
//            if(str[0] == _TRANS_ATK)
            {
                _type = TYPE_ATK;
            }
            //CONFIG::LOCALE_JP <-漢字をチェックを無視する
            else if(str[0] == "防御")
//            else if(str[0] == _TRANS_DEF)
            {
                _type = TYPE_DEF;
            }
            //CONFIG::LOCALE_JP <-漢字をチェックを無視する
            else if(str[0] == "移動")
//            else if(str[0] == _TRANS_MOV)
            {
                _type = TYPE_MOVE;
            }

        }

        public function setConditionCaption(c:String):void
        {
            var before_cond:String = _caption.match(/\[(.*)\:(.*)\:(.*)\]/)[3];
            _caption = _caption.replace(before_cond, c);
        }

//         public function getLoader():Thread
//         {
//             return new ReLoaderThread(__loader, this);
//         }

    }
}
