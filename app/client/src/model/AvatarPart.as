
package model
{
//     import net.*;
    import flash.geom.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;
    import model.utils.*;

    /**
     * アバターパーツクラス
     * 情報を扱う
     *
     */
    public class AvatarPart extends BaseModel
    {
        // 翻訳データアイテムの種類定数
        CONFIG::LOCALE_JP
        private static const _TRANS_BODY	:String = "ボディ";
        CONFIG::LOCALE_JP
        private static const _TRANS_CLOTH	:String = "服";
        CONFIG::LOCALE_JP
        private static const _TRANS_ACCE	:String = "アクセサリー";
        CONFIG::LOCALE_JP
        private static const _TRANS_BODYCOL	:String = "ボディ色";
        CONFIG::LOCALE_JP
        private static const _TRANS_EYE		:String = "眼";
        CONFIG::LOCALE_JP
        private static const _TRANS_MOUTH	:String = "口";
        CONFIG::LOCALE_JP
        private static const _TRANS_HAIR	:String = "髪型";
        CONFIG::LOCALE_JP
        private static const _TRANS_TOPS	:String = "トップス";
        CONFIG::LOCALE_JP
        private static const _TRANS_BOTTOM	:String = "ボトム";
        CONFIG::LOCALE_JP
        private static const _TRANS_DRESS	:String = "ドレス";
        CONFIG::LOCALE_JP
        private static const _TRANS_SHOES	:String = "シューズ";
        CONFIG::LOCALE_JP
        private static const _TRANS_HEAD	:String = "ヘッド";
        CONFIG::LOCALE_JP
        private static const _TRANS_ARM		:String = "アーム";
        CONFIG::LOCALE_JP
        private static const _TRANS_FACE	:String = "フェイス";
        CONFIG::LOCALE_JP
        private static const _TRANS_ETC	:String = "ETC";

        CONFIG::LOCALE_EN
        private static const _TRANS_BODY	:String = "Body";
        CONFIG::LOCALE_EN
        private static const _TRANS_CLOTH	:String = "Clothes";
        CONFIG::LOCALE_EN
        private static const _TRANS_ACCE	:String = "Accessories";
        CONFIG::LOCALE_EN
        private static const _TRANS_BODYCOL	:String = "Skin Color";
        CONFIG::LOCALE_EN
        private static const _TRANS_EYE		:String = "Eyes";
        CONFIG::LOCALE_EN
        private static const _TRANS_MOUTH	:String = "Mouth";
        CONFIG::LOCALE_EN
        private static const _TRANS_HAIR	:String = "Hairstyle";
        CONFIG::LOCALE_EN
        private static const _TRANS_TOPS	:String = "Tops";
        CONFIG::LOCALE_EN
        private static const _TRANS_BOTTOM	:String = "Bottoms";
        CONFIG::LOCALE_EN
        private static const _TRANS_DRESS	:String = "Dresses";
        CONFIG::LOCALE_EN
        private static const _TRANS_SHOES	:String = "Shoes";
        CONFIG::LOCALE_EN
        private static const _TRANS_HEAD	:String = "Head";
        CONFIG::LOCALE_EN
        private static const _TRANS_ARM		:String = "Arm";
        CONFIG::LOCALE_EN
        private static const _TRANS_FACE	:String = "Face";
        CONFIG::LOCALE_EN
        private static const _TRANS_ETC	:String = "Etc";

        CONFIG::LOCALE_TCN
        private static const _TRANS_BODY	:String = "身體";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CLOTH	:String = "服飾";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ACCE	:String = "裝飾品";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BODYCOL	:String = "身體顏色";
        CONFIG::LOCALE_TCN
        private static const _TRANS_EYE		:String = "眼睛";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MOUTH	:String = "嘴";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HAIR	:String = "髮型";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TOPS	:String = "上衣";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BOTTOM	:String = "下衣";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DRESS	:String = "禮服";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SHOES	:String = "鞋";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HEAD	:String = "頭";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ARM		:String = "手臂";
        CONFIG::LOCALE_TCN
        private static const _TRANS_FACE	:String = "臉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ETC	:String = "ETC";

        CONFIG::LOCALE_SCN
        private static const _TRANS_BODY	:String = "身体";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CLOTH	:String = "服装";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ACCE	:String = "装饰品";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BODYCOL	:String = "肤色";
        CONFIG::LOCALE_SCN
        private static const _TRANS_EYE		:String = "眼睛";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MOUTH	:String = "嘴巴";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HAIR	:String = "发型";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TOPS	:String = "上装";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BOTTOM	:String = "下装";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DRESS	:String = "礼服";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SHOES	:String = "鞋";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HEAD	:String = "头";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ARM		:String = "手臂";
        CONFIG::LOCALE_SCN
        private static const _TRANS_FACE	:String = "脸";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ETC	:String = "ETC";

        CONFIG::LOCALE_KR
        private static const _TRANS_BODY	:String = "보디";
        CONFIG::LOCALE_KR
        private static const _TRANS_CLOTH	:String = "옷";
        CONFIG::LOCALE_KR
        private static const _TRANS_ACCE	:String = "악세사리";
        CONFIG::LOCALE_KR
        private static const _TRANS_BODYCOL	:String = "보디 색";
        CONFIG::LOCALE_KR
        private static const _TRANS_EYE		:String = "눈";
        CONFIG::LOCALE_KR
        private static const _TRANS_MOUTH	:String = "입";
        CONFIG::LOCALE_KR
        private static const _TRANS_HAIR	:String = "머리 모양";
        CONFIG::LOCALE_KR
        private static const _TRANS_TOPS	:String = "상의";
        CONFIG::LOCALE_KR
        private static const _TRANS_BOTTOM	:String = "하의";
        CONFIG::LOCALE_KR
        private static const _TRANS_DRESS	:String = "드레스";
        CONFIG::LOCALE_KR
        private static const _TRANS_SHOES	:String = "신발";
        CONFIG::LOCALE_KR
        private static const _TRANS_HEAD	:String = "머리";
        CONFIG::LOCALE_KR
        private static const _TRANS_ARM		:String = "손";
        CONFIG::LOCALE_KR
        private static const _TRANS_FACE	:String = "페이즈";
        CONFIG::LOCALE_KR
        private static const _TRANS_ETC	:String = "ETC";

        CONFIG::LOCALE_FR
        private static const _TRANS_BODY	:String = "Corps";
        CONFIG::LOCALE_FR
        private static const _TRANS_CLOTH	:String = "Vêtements";
        CONFIG::LOCALE_FR
        private static const _TRANS_ACCE	:String = "Accessoires";
        CONFIG::LOCALE_FR
        private static const _TRANS_BODYCOL	:String = "Couleur de la peau";
        CONFIG::LOCALE_FR
        private static const _TRANS_EYE		:String = "Yeux";
        CONFIG::LOCALE_FR
        private static const _TRANS_MOUTH	:String = "Bouche";
        CONFIG::LOCALE_FR
        private static const _TRANS_HAIR	:String = "Coiffure";
        CONFIG::LOCALE_FR
        private static const _TRANS_TOPS	:String = "Haut";
        CONFIG::LOCALE_FR
        private static const _TRANS_BOTTOM	:String = "Bas";
        CONFIG::LOCALE_FR
        private static const _TRANS_DRESS	:String = "Robes";
        CONFIG::LOCALE_FR
        private static const _TRANS_SHOES	:String = "Chaussures";
        CONFIG::LOCALE_FR
        private static const _TRANS_HEAD	:String = "Tête";
        CONFIG::LOCALE_FR
        private static const _TRANS_ARM		:String = "Bras";
        CONFIG::LOCALE_FR
        private static const _TRANS_FACE	:String = "Visage";
        CONFIG::LOCALE_FR
        private static const _TRANS_ETC	:String = "et cetera";

        CONFIG::LOCALE_ID
        private static const _TRANS_BODY	:String = "ボディ";
        CONFIG::LOCALE_ID
        private static const _TRANS_CLOTH	:String = "服";
        CONFIG::LOCALE_ID
        private static const _TRANS_ACCE	:String = "アクセサリー";
        CONFIG::LOCALE_ID
        private static const _TRANS_BODYCOL	:String = "ボディ色";
        CONFIG::LOCALE_ID
        private static const _TRANS_EYE		:String = "眼";
        CONFIG::LOCALE_ID
        private static const _TRANS_MOUTH	:String = "口";
        CONFIG::LOCALE_ID
        private static const _TRANS_HAIR	:String = "髪型";
        CONFIG::LOCALE_ID
        private static const _TRANS_TOPS	:String = "トップス";
        CONFIG::LOCALE_ID
        private static const _TRANS_BOTTOM	:String = "ボトム";
        CONFIG::LOCALE_ID
        private static const _TRANS_DRESS	:String = "ドレス";
        CONFIG::LOCALE_ID
        private static const _TRANS_SHOES	:String = "シューズ";
        CONFIG::LOCALE_ID
        private static const _TRANS_HEAD	:String = "ヘッド";
        CONFIG::LOCALE_ID
        private static const _TRANS_ARM		:String = "アーム";
        CONFIG::LOCALE_ID
        private static const _TRANS_FACE	:String = "フェイス";
        CONFIG::LOCALE_ID
        private static const _TRANS_ETC	:String = "ETC";

        CONFIG::LOCALE_TH
        private static const _TRANS_BODY    :String = "ลำตัว";
        CONFIG::LOCALE_TH
        private static const _TRANS_CLOTH   :String = "เสื้อผ้า";
        CONFIG::LOCALE_TH
        private static const _TRANS_ACCE    :String = "เครื่องประดับ";
        CONFIG::LOCALE_TH
        private static const _TRANS_BODYCOL :String = "สีผิว";
        CONFIG::LOCALE_TH
        private static const _TRANS_EYE     :String = "ตา";
        CONFIG::LOCALE_TH
        private static const _TRANS_MOUTH   :String = "ปาก";
        CONFIG::LOCALE_TH
        private static const _TRANS_HAIR    :String = "ทรงผม";
        CONFIG::LOCALE_TH
        private static const _TRANS_TOPS    :String = "ท่อนบน";
        CONFIG::LOCALE_TH
        private static const _TRANS_BOTTOM  :String = "ท่อนล่าง";
        CONFIG::LOCALE_TH
        private static const _TRANS_DRESS   :String = "ชุด";
        CONFIG::LOCALE_TH
        private static const _TRANS_SHOES   :String = "รองเท้า";
        CONFIG::LOCALE_TH
        private static const _TRANS_HEAD    :String = "ศีรษะ";
        CONFIG::LOCALE_TH
        private static const _TRANS_ARM     :String = "แขน";
        CONFIG::LOCALE_TH
        private static const _TRANS_FACE    :String = "ขั้นตอน";
        CONFIG::LOCALE_TH
        private static const _TRANS_ETC :String = "ETC";


        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        private static var __loader:Function;         // パラムを読み込む関数
        private static var __parts:Object = [];        // ロード済みのカード
        private static var __loadings:Object ={};     // ロード中のカード
        private static var __registParts:Array = []; /* of AvatarPart */

        private var _name         :String;   // 名前
        private var _offsetX      :int;      // アイコン用オフセットX
        private var _offsetY      :int;      // アイコン用オフセットY
        private var _offsetScale  :Number    // アイコン用拡大率
        private var _image        :String;  // SWF名
        private var _type         :int;
        private var _color        :int;
        private var _powerType    :int;
        private var _power        :int;
        private var _duration     :int;//
        private var _caption      :String;
        private var _version      :int;

        private var _colorTransform:ColorTransform;

        // アイテムの種類定数
//        public static const PARTS_GENRE:Array = ["ボディ","服","アクセサリー"];

        public static const GENRE_BODY:int = 0;
        public static const GENRE_CLOTH:int = 1;
        public static const GENRE_ACCE:int = 2;
        public static const PARTS_GENRE:Array = [_TRANS_BODY,_TRANS_CLOTH,_TRANS_ACCE];
        public static const PARTS_GENRE_ID:Array = [0, 10, 20];

//        public static const PARTS_BODY_TYPE:Array = ["ボディ色","眼","口","髪型"];
        public static const PARTS_BODY_TYPE:Array = [_TRANS_BODYCOL,_TRANS_EYE,_TRANS_MOUTH,_TRANS_HAIR];
//        public static const PARTS_CLOTHES_TYPE:Array = ["トップス","ボトム","ドレス","シューズ"];
        public static const PARTS_CLOTHES_TYPE:Array = [_TRANS_TOPS,_TRANS_BOTTOM,_TRANS_DRESS,_TRANS_SHOES];
//        public static const PARTS_ACCESSORY_TYPE:Array = ["ヘッド","アーム","フェイス"];
        public static const PARTS_ACCESSORY_TYPE:Array = [_TRANS_HEAD,_TRANS_ARM,_TRANS_FACE,_TRANS_ETC];

        public static const PARTS_TYPE_SET:Array = [PARTS_BODY_TYPE, PARTS_CLOTHES_TYPE, PARTS_ACCESSORY_TYPE]; /* of Array */

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
        }

        private static function getData(id:int):void
        {
            var a:Array; /* of ElementType */
            if (ConstData.getData(ConstData.AVATAR_PART, id) != null)
            {
                a = ConstData.getData(ConstData.AVATAR_PART, id);
                updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], 0, true);
            }


        }
        // データを再読込（再ログイン時にデータ更新を確認するため）
        public static function clearData():void
        {
            __parts.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }


        // IDのAvatarPartインスタンスを返す
        public static function ID(id:int):AvatarPart
        {
//            log.writeLog(log.LV_INFO, "static AvatarPart" ,"get id",id, __parts[id]);
            if (__parts[id] == null)
            {
                __parts[id] = new AvatarPart(id);
                getData(id);
            }else{
                if (!(__parts[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __parts[id];
        }

        // ローダがAvatarPartのパラメータを更新する
        public static function updateParam(id:int,
                                           name:String,
                                           image:String,
                                           type:int,
                                           color:int,
                                           offsetX:int,
                                           offsetY:int,
                                           offsetScale:Number,
                                           powerType:int,
                                           power:int,
                                           duration:int,
                                           caption:String,
                                           version:int,
                                           cache:Boolean=false):void
        {
            if (__parts[id] == null)
            {
                __parts[id] = new AvatarPart(id);
            }
            __parts[id]._id            = id;
            __parts[id]._name          = name;
            __parts[id]._type          = type;
            __parts[id]._image         = image;
            __parts[id]._color         = color;
            __parts[id]._offsetX       = offsetX;
            __parts[id]._offsetY       = offsetY;
            __parts[id]._offsetScale   = offsetScale;
            __parts[id]._powerType     = powerType;
            __parts[id]._power         = power;
            __parts[id]._duration      = duration;
            __parts[id]._caption       = caption;


            __parts[id]._version       = version;

            // 色替えを定義する
            __parts[id]._colorTransform =  setColorTransform(color);


            if (!cache)
            {
                Cache.setCache(Cache.AVATAR_PART, id, name, image, type, color, offsetX, offsetY, offsetScale, version);
            }

            if (__parts[id]._loaded)
            {
                __parts[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static AvatarPart" ,"load update",id,__parts[id]._loaded);
            }
            else
            {
                __parts[id]._loaded  = true;
                __parts[id].notifyAll();
                __parts[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static AvatarPart" ,"load init",id,__parts[id]);
            }
            __loadings[id] = false;
        }

        // 登録時に使えるパーツリストをセットする
        public static function setRegistParts(ids:Array /* of int */ ):void
        {
            ids.forEach(function(item:*, index:int, array:Array):void{__registParts.push(ID(item))});
        }

        public static function getRegistParts():Array /* of AvatarParts */
        {
            return __registParts;
        }

        // コンストラクタ
        public function AvatarPart(id:int)
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

        public function get offsetX():int
        {
            return _offsetX;
        }

        public function get offsetY():int
        {
            return _offsetY;
        }
        public function get offsetScale():Number
        {
            return _offsetScale;
        }

        public function get type():int
        {
            return _type;
        }

        public function get genre():int
        {
            return int(type/10);
        }



        public function get caption():String
        {
            return _caption;
        }

        public function get duration():int
        {
            return _duration;
        }

        public function get remainTime():Number
        {
            var api:AvatarPartInventory = AvatarPartInventory.getPartsInventory(this);
            return api.getRemainTime;
        }

        public function get activeted():Boolean
        {
            var api:AvatarPartInventory = AvatarPartInventory.getPartsInventory(this);
            return api.activated;
        }

        private static function setColorTransform(color:int):ColorTransform
        {
            var colorTransform:ColorTransform;
            if (color>0)
            {
                colorTransform = new ColorTransform(int(color/1000000)/100, int(color%1000000/1000)/100, int(color%1000000%1000)/100,1,0,0,0,0);
            }else{
                colorTransform = new ColorTransform(1, 1, 1, 1, 0,0,0,0);
            }
            return colorTransform;
        }

        public function get colorTransform():ColorTransform
        {
            return _colorTransform;
        }

        public function getLoader():Thread
        {
            return new ReLoaderThread(__loader, AvatarPart.ID(id))
        }
        public override function  toString():String
        {
            return  _id.toString();
        }



    }
}

// import org.libspark.thread.Thread;
// import org.libspark.thread.utils.ParallelExecutor;

// import model.AvatarPart;
// import model.Feat;

// // AvatarPartのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _ap:AvatarPart;

//     public function Loader(ap:AvatarPart)
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

