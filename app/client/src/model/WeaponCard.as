package model
{
//     import net.*;
    import flash.utils.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * 武器カードクラス
     * 情報を扱う
     * 
     */
    public class WeaponCard extends BaseModel implements ICard
    {
        public static const PARAM_NUM:int = 4; // 基本的な数値の数（近攻、近防、遠攻、遠防）
        public static const RESTRICTION_SET_ADD_PARAM:int = 5;
        private static const CMB_CAPTION_BASE:String = "基礎[近攻:__BSAP__ 近防:__BSDP__ 遠攻:__BAAP__ 遠防:__BADP__]\n合成[近攻:__ASAP__ 近防:__ASDP__ 遠攻:__AAAP__ 遠防:__AADP__]";

        private static const CMB_COPY_DUMMY_START_ID:int = 100000;

        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        public static const UPDATE_NUM:String = 'update_num'; // 情報をロード

        private static var __loader:Function;         // パラムを読み込む関数
        private static var __items:Object =[];        // ロード済みのカード
        private static var __loadings:Object ={};     // ロード中のカード
        private static var __registItems:Array = []; /* of WeaponCard */ 
        private static var __combineWeaponRegistCnt:int = 0; // 合成武器登録数
        private static var __copyDummyWeaponCnt:int = 0; // コピーダミー合成武器登録数

        private var _name         :String;   // 名前
        private var _no           :int;      // 効果番号
        private var _cost         :int;      // コスト
        private var _restriction  :Array;    // キャラ制限
        private var _image        :String;   // SWF名
        private var _caption      :String;   // 説明
        private var _version       :int;

        private var _type          :int = InventorySet.TYPE_WEAPON;    // 
        private var _num           :int = 0;    // 所持枚数

        private var _combined:Boolean = false;

        private var _baseSap:int = 0;
        private var _baseSdp:int = 0;
        private var _baseAap:int = 0;
        private var _baseAdp:int = 0;
        private var _baseMax:int = 0;
        private var _addSap:int = 0;
        private var _addSdp:int = 0;
        private var _addAap:int = 0;
        private var _addAdp:int = 0;
        private var _useCnt:int = 0;
        private var _useCntMax:int = 0;
        private var _addMax:int = 0;
        private var _passiveIdPass:int = 0;
        private var _level:int = 0;
        private var _exp:int = 0;
        private var _passiveNumMax:int = 0;

        private var _matUseMaxNum:int = Const.CMB_COUNT_DEFAULT_MAX; // 合成使用時可能回数
        private var _weaponType:int;

        private var _weaponPassiveId:Array = []; // 武器自体に設定されているパッシブID
        private var _passiveId:Array = [];

        private var _useCntSet:Array = [];
        private var _useCntMaxSet:Array = [];
        private var _passiveIdPassSet:Array = [];

        private var _baseCardId:int; // 合成カードの元カードID

        private var _forceReload:Boolean = false;

        // 素材として使用した場合の、モンスパラ上昇値
        private var _matAddSap:int = 0;
        private var _matAddSdp:int = 0;
        private var _matAddAap:int = 0;
        private var _matAddAdp:int = 0;

        // Bit演算関連
        private static const _PARAM_MASK_BIT_MASK:int = 0;
        private static const _PARAM_MASK_BIT_SHIFT_NUM:int = 1;
        private const _COMB_PARAM_MASK_BASE_MAX:Array  = [4026531840, 28]; // # 0-15 BASE_MAX default:3
        private const _COMB_PARAM_MASK_CNT_A:Array     = [260046848, 23];  // # 0-31
        private const _COMB_PARAM_MASK_CNT_A_MAX:Array = [8126464, 18];    // # 0-31
        private const _COMB_PARAM_MASK_ADD_MAX:Array   = [261632, 9];      // # 0-511 ADD_MAX defalt:20
        private const _COMB_PARAM_MASK_PASS_A:Array    = [511, 0];         // # 0-511
        private const _COMB_PARAM_MASK_PSV_NUM:Array   = [4026531840, 28]; // # 0-15 PSV_NUM default:0
        private const _COMB_PARAM_MASK_CNT_B:Array     = [260046848, 23];  // # 0-31
        private const _COMB_PARAM_MASK_CNT_B_MAX:Array = [8126464, 18];    // # 0-31
        private const _COMB_PARAM_MASK_PASS_B:Array    = [511, 0];         // # 0-511

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
                if (ConstData.getData(ConstData.WEAPON_CARD, id) != null)
                {
                    a = ConstData.getData(ConstData.WEAPON_CARD, id)
                        updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], 0, true);
                }
//                 if (Cache.getCache(Cache.WEAPON_CARD, id))
//                 {
//                     var a:Array = Cache.getDataParam(Cache.WEAPON_CARD, id);
//                     updateParam(id, a[0], a[1], a[2], a[3], a[4], a[5], a[6], true);
// //                    log.writeLog(log.LV_FATAL, "CharaCard static", "get param cache", a);
//                 }else{
//                 __loadings[id] = true;
//                 new ReLoaderThread(__loader, WeaponCard.ID(id)).start();
// //                __loader(id);
//                 }
//             }
        }

        // データを再読込（再ログイン時にデータ更新を確認するため）
        public static function clearData():void
        {
            __items.forEach(function(item:*, index:int, array:Array):void{item._loaded = false});
        }


        // IDのWeaponCardインスタンスを返す
        public static function ID(id:int):WeaponCard
        {
//            log.writeLog(log.LV_INFO, "static WeaponCard" ,"get id",id, __items[id]);
            if (__items[id] == null)
            {
                __items[id] = new WeaponCard(id);
                getData(id);
            }else{

//                 if (!(__items[id].loaded || __loadings[id]))
//                 {
//                     getData(id);
//                 }
            }
            return __items[id];
        }

        // ローダがWeaponCardのパラメータを更新する
        public static function updateParam(id:int, name:String, no:int, cost:int, restriction:Array, image:String, caption:String, weaponType:int, materialUseMaxNum:int, matAddSap:int, matAddSdp:int, matAddAap:int, matAddAdp:int, passiveId:String, version:int, cache:Boolean=false):void
        {
            if (__items[id] == null)
            {
                __items[id] = new WeaponCard(id);
            }
            var tmp_restriction:Array = [];
            var tmp_passiveId:Array = [];
            if (restriction)
            {
                tmp_restriction = restriction[0].split("|");
            }
            if (passiveId)
            {
                var strArr:Array = passiveId.split("|");
                for (var i:int = 0; i < strArr.length; i++) {
                    if (int(strArr[i])!=0) {
                        tmp_passiveId.push(int(strArr[i]));
                    }
                }
            }
            __items[id]._id           = id;
            __items[id]._name         = name;
            __items[id]._no           = no;
            __items[id]._cost         = cost;
            __items[id]._restriction  = tmp_restriction;
            __items[id]._image        = image;
            __items[id]._caption      = caption;
            __items[id]._weaponType   = weaponType;
            __items[id]._matUseMaxNum = materialUseMaxNum;
            __items[id]._matAddSap    = matAddSap;
            __items[id]._matAddSdp    = matAddSdp;
            __items[id]._matAddAap    = matAddAap;
            __items[id]._matAddAdp    = matAddAdp;
            __items[id]._passiveId    = tmp_passiveId;
            __items[id]._version       = version;

            // 武器自体に設定されているパッシブIDを保持しておく
            __items[id]._weaponPassiveId = tmp_passiveId;

            log.writeLog(log.LV_INFO, "static WeaponCard" ,"update param",__items[id]._name,__items[id]._weaponPassiveId);

            if (!cache)
            {
                Cache.setCache(Cache.WEAPON_CARD, id, name, no, cost, restriction, image, caption, version);
            }


            if (__items[id]._loaded)
            {
                __items[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static WeaponCard" ,"load update",id,__items[id]._loaded);
            }
            else
            {
                __items[id]._loaded  = true;
                __items[id].notifyAll();
                __items[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static WeaponCard" ,"load init",id,__items[id]);
            }
            __loadings[id] = false;
        }

        // 登録時に使えるパーツリストをセットする
        public static function setRegistItems(ids:Array /* of int */ ):void
        {
            ids.forEach(function(item:*, index:int, array:Array):void{__registItems.push(ID(item))});
        }

        public static function getRegistItems():Array /* of WeaponCards */
        {
            return __registItems;
        }

        // コンストラクタ
        public function WeaponCard(id:int)
        {
            _id = id;
        }

        public static function createCombineWeapon(id:int):WeaponCard
        {
            var wc:WeaponCard = __items[__combineWeaponRegistCnt+Const.COMBINE_WEAPON_START_ID];
            if (__items[__combineWeaponRegistCnt+Const.COMBINE_WEAPON_START_ID] == null) {
                wc = new WeaponCard(__combineWeaponRegistCnt+Const.COMBINE_WEAPON_START_ID);
                var baseWC:WeaponCard = WeaponCard.ID(id);
                wc._name = baseWC.name;
                wc._no = baseWC.no;
                wc._cost = baseWC.cost;
                wc._restriction = baseWC.restriction;
                wc._image = baseWC.image;
                wc._caption = baseWC.caption;
                wc._type = baseWC.type;
                wc._weaponType    = baseWC.weaponType;
                wc._matUseMaxNum  = baseWC.materialUseMaxNum;
                wc._matAddSap    = baseWC.matAddSap;
                wc._matAddSdp    = baseWC.matAddSdp;
                wc._matAddAap    = baseWC.matAddAap;
                wc._matAddAdp    = baseWC.matAddAdp;
                wc._passiveId = baseWC.passiveId;
                wc._weaponPassiveId = baseWC.weaponPassiveId;
                wc._baseCardId = id;
                wc._combined = true;
                __items[__combineWeaponRegistCnt+Const.COMBINE_WEAPON_START_ID] = wc;
                __combineWeaponRegistCnt++;
            }
            return wc;
        }
        private function getCombinePassive():Array
        {
            var ret:Array = [];
            for (var i:int = 0; i<_passiveId.length; i++) {
                var hit:Boolean = false;
                for (var j :int = 0; j<_weaponPassiveId.length; j++) {
                    if (_passiveId[i] == _weaponPassiveId[j]) {
                        hit = true;
                        break;
                    }
                }
                if (! hit) {
                    ret.push(_passiveId[i]);
                }
            }
            return ret;
        }
        public function getUpdateCombineWeapon(id:int):WeaponCard
        {
            var wc:WeaponCard = __items[__combineWeaponRegistCnt+Const.COMBINE_WEAPON_START_ID];
            if (__items[__combineWeaponRegistCnt+Const.COMBINE_WEAPON_START_ID] == null) {
                log.writeLog(log.LV_DEBUG, this ,"getUpdateCombineWeapon",_passiveId,passiveNum,_passiveId.slice(0,passiveNum));
                // 合成関連の各パラメータを一時保持
                var bsap:int = _baseSap;
                var bsdp:int = _baseSdp;
                var baap:int = _baseAap;
                var badp:int = _baseAdp;
                var asap:int = _addSap;
                var asdp:int = _addSap;
                var aaap:int = _addSap;
                var aadp:int = _addSap;
                var bmax:int = _baseMax;
                var amax:int = _addMax;
                var cntStr:String = _useCntSet.join("|");
                var cntMaxStr:String = _useCntMaxSet.join("|");
                var passiveIdStr:String = getCombinePassive().join("|");
                var restrictionStr:String = _restriction.join("|");
                var weaponPassiveIdStr:String = _weaponPassiveId.join("|");
                var level:int = _level;
                var exp:int = _exp;
                wc = new WeaponCard(__combineWeaponRegistCnt+Const.COMBINE_WEAPON_START_ID);
                var baseWC:WeaponCard = WeaponCard.ID(id);
                wc._name = baseWC.name;
                wc._no = baseWC.no;
                wc._cost = baseWC.cost;
                wc._restriction = baseWC.restriction;
                wc._image = baseWC.image;
                wc._type = baseWC.type;
                wc._caption = baseWC.caption;
                wc._weaponType    = baseWC.weaponType;
                wc._matUseMaxNum  = baseWC.materialUseMaxNum;
                wc._matAddSap    = baseWC.matAddSap;
                wc._matAddSdp    = baseWC.matAddSdp;
                wc._matAddAap    = baseWC.matAddAap;
                wc._matAddAdp    = baseWC.matAddAdp;
                wc._weaponPassiveId = baseWC.weaponPassiveId;
                wc._baseCardId = id;
                wc._combined = true;
                wc.setCombineWeaponParam(id,bsap,bsdp,baap,badp,bmax,asap,asdp,aaap,aadp,amax,passiveIdStr,restrictionStr,cntStr,cntMaxStr,level,exp);
                __items[__combineWeaponRegistCnt+Const.COMBINE_WEAPON_START_ID] = wc;
                __combineWeaponRegistCnt++;
            }
            return wc;
        }

        private function convByteToInt(b:int):int
        {
            if (b < 0)
            {
                return -(128 + b);
            }else{
                return b;
            }

        }

        public function setCombineWeaponParamByteData(combineData:String):void
        {
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParamByteData",combineData);
            var combineDataArray:Array = combineData.split("|");
            _level = combineDataArray.shift();
            _exp = combineDataArray.shift();
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParamByteData","level",_level,"exp",_exp);
            var data:ByteArray = new ByteArray();
            // data.endian= Endian.LITTLE_ENDIAN;
            for (var i:int = 0;i < combineDataArray.length; i++) {
                data.writeUnsignedInt(uint(combineDataArray[i]));
            }
            data.position = 0;
            _baseSap = convByteToInt(data.readByte());
            _baseSdp = convByteToInt(data.readByte());
            _baseAap = convByteToInt(data.readByte());
            _baseAdp = convByteToInt(data.readByte());
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParamByteData 2",_baseSap,_baseSdp,_baseAap,_baseAdp);
            _addSap = convByteToInt(data.readByte());
            _addSdp = convByteToInt(data.readByte());
            _addAap = convByteToInt(data.readByte());
            _addAdp = convByteToInt(data.readByte());
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParamByteData 3",_addSap,_addSdp,_addAap,_addAdp);
            var otherParamData:uint = data.readUnsignedInt();
            var tmp:uint;

            var mask:uint = _COMB_PARAM_MASK_BASE_MAX[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            _baseMax = tmp >> _COMB_PARAM_MASK_BASE_MAX[_PARAM_MASK_BIT_SHIFT_NUM];

            mask = _COMB_PARAM_MASK_CNT_A[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            _useCnt = tmp >> _COMB_PARAM_MASK_CNT_A[_PARAM_MASK_BIT_SHIFT_NUM];
            _useCntSet.push(_useCnt);

            mask = _COMB_PARAM_MASK_CNT_A_MAX[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            _useCntMax = tmp >> _COMB_PARAM_MASK_CNT_A_MAX[_PARAM_MASK_BIT_SHIFT_NUM];
            _useCntMaxSet.push(_useCntMax);

            mask = _COMB_PARAM_MASK_ADD_MAX[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            _addMax = tmp >> _COMB_PARAM_MASK_ADD_MAX[_PARAM_MASK_BIT_SHIFT_NUM];

            mask = _COMB_PARAM_MASK_PASS_A[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            _passiveIdPass = tmp >> _COMB_PARAM_MASK_PASS_A[_PARAM_MASK_BIT_SHIFT_NUM];
            _passiveIdPassSet.push(_passiveIdPass);

            otherParamData = data.readUnsignedInt();

            mask = _COMB_PARAM_MASK_PSV_NUM[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            _passiveNumMax = tmp >> _COMB_PARAM_MASK_BASE_MAX[_PARAM_MASK_BIT_SHIFT_NUM];

            var cntTmp:int;
            mask = _COMB_PARAM_MASK_CNT_B[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            cntTmp = tmp >> _COMB_PARAM_MASK_CNT_B[_PARAM_MASK_BIT_SHIFT_NUM];
            _useCntSet.push(cntTmp);

            mask = _COMB_PARAM_MASK_CNT_B_MAX[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            cntTmp = tmp >> _COMB_PARAM_MASK_CNT_B_MAX[_PARAM_MASK_BIT_SHIFT_NUM];
            _useCntMaxSet.push(cntTmp);

            mask = _COMB_PARAM_MASK_PASS_B[_PARAM_MASK_BIT_MASK];
            tmp = otherParamData & mask;
            cntTmp = tmp >> _COMB_PARAM_MASK_PASS_B[_PARAM_MASK_BIT_SHIFT_NUM];
            _passiveIdPassSet.push(cntTmp);

            setPassiveId();

            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParamByteData 3",_baseMax,_useCnt,_useCntMax,_addMax,_passiveIdPass);
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParamByteData 4",_passiveNumMax,_useCntSet,_useCntMaxSet,_passiveIdPassSet);
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParamByteData 5",_name,_passiveId,_weaponPassiveId);
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParamByteData 6",Const.CMB_PASSIVE_MATERIAL_SET.keys);

            //setCombineCaption();

            if (_loaded)
            {
                dispatchEvent(new Event(UPDATE));
            }
            else
            {
                _loaded  = true;
                notifyAll();
                dispatchEvent(new Event(INIT));
            }
        }

        private function setPassiveId():void
        {
            var tmp_passive:Array = [];
            for (var i:int=0;i<_useCntSet.length;i++) {
                if (_useCntSet[i] > 0) {
                    tmp_passive.push(Const.CMB_PASSIVE_SET[_passiveIdPassSet[i]][0]);
                }
            }
            _passiveId = tmp_passive.concat(_passiveId);
        }

        private function cnvStrToIntArray(str:String,sepa:String,isSetZero:Boolean=true):Array
        {
            var retArr:Array = [];
            var strArr:Array = str.split(sepa);
            for (var i:int = 0; i < strArr.length; i++) {
                if (int(strArr[i])!=0||isSetZero) {
                    retArr.push(int(strArr[i]));
                }
            }
            return retArr;
        }

        public function setCombineWeaponParam(cardId:int,baseSap:int,baseSdp:int,baseAap:int,baseAdp:int,baseMax:int,addSap:int,addSdp:int,addAap:int,addAdp:int,addMax:int,passiveId:String,restriction:String,cntStr:String,cntMaxStr:String,level:int=1,exp:int=0,passiveNumMax:int=0,passivePassSet:String=""):void
        {
            var baseWC:WeaponCard = WeaponCard.ID(cardId);
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParam!!!!",baseWC.passiveId,passiveId);
            // ベースカードを基準にパラメータを変更
            _name = baseWC.name;
            _no = baseWC.no;
            _cost = baseWC.cost;
            _image = baseWC.image;
            _caption = baseWC.caption;
            _type = baseWC.type;
            _weaponType    = baseWC.weaponType;
            _matUseMaxNum  = baseWC.materialUseMaxNum;
            _matAddSap    = baseWC.matAddSap;
            _matAddSdp    = baseWC.matAddSdp;
            _matAddAap    = baseWC.matAddAap;
            _matAddAdp    = baseWC.matAddAdp;
            _restriction = baseWC.restriction;

            _weaponPassiveId = baseWC.weaponPassiveId;
            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParam!!!!",_weaponPassiveId);

            _baseCardId = cardId;

            var tmp_restriction:Array = [];
            var tmp_passiveId:Array = [];
            var tmp_passiveIdPassSet:Array = [];
            if (restriction)
            {
                tmp_restriction = restriction.split("|");
            }
            if (passiveId)
            {
                tmp_passiveId = cnvStrToIntArray(passiveId,"|",false);
            }
            if (passiveIdPassSet)
            {
                tmp_passiveIdPassSet = cnvStrToIntArray(passivePassSet,"|",false);
            }

            // その他のパラメータを更新
            _baseSap   = baseSap;
            _baseSdp   = baseSdp;
            _baseAap   = baseAap;
            _baseAdp   = baseAdp;
            _addSap    = addSap;
            _addSdp    = addSdp;
            _addAap    = addAap;
            _addAdp    = addAdp;
            _baseMax   = baseMax;
            _addMax    = addMax;
            _useCntSet    = cnvStrToIntArray(cntStr,"|");
            _useCntMaxSet = cnvStrToIntArray(cntMaxStr,"|");
            _passiveId = tmp_passiveId;
            _restriction = restriction.split("|");
            _level = level;
            _exp = exp;
            _passiveNumMax = passiveNumMax;
            _passiveIdPassSet = tmp_passiveIdPassSet;

            //setCombineCaption();

            log.writeLog(log.LV_DEBUG, this ,"setCombineWeaponParam",_name,_passiveId);

            // 強制更新状態に変更
            _forceReload = true;

            if (_loaded)
            {
                dispatchEvent(new Event(UPDATE));
            }
            else
            {
                _loaded  = true;
                notifyAll();
                dispatchEvent(new Event(INIT));
            }
        }

        private function setCombineCaption():void
        {
            _caption = CMB_CAPTION_BASE;
            _caption = _caption.replace("__BSAP__",_baseSap.toString());
            _caption = _caption.replace("__BSDP__",_baseSdp.toString());
            _caption = _caption.replace("__BAAP__",_baseAap.toString());
            _caption = _caption.replace("__BADP__",_baseAdp.toString());
            _caption = _caption.replace("__ASAP__",_addSap.toString());
            _caption = _caption.replace("__ASDP__",_addSdp.toString());
            _caption = _caption.replace("__AAAP__",_addAap.toString());
            _caption = _caption.replace("__AADP__",_addAdp.toString());
            _caption = _caption.replace("__EXP__",_exp.toString());
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
            return new new ReLoaderThread(__loader, WeaponCard.ID(id));
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

        public function get combined():Boolean
        {
            return _combined;
        }

        public function get passiveId():Array
        {
            return _passiveId;
        }

        public function get baseCardId():int
        {
            return baseCardId;
        }
        public function getUseCnt(idx:int=0):int
        {
            return _useCntSet[idx];
        }
        public function getUseCntMax(idx:int=0):int
        {
            return _useCntMaxSet[idx];
        }
        public function get useCntSet():Array
        {
            return _useCntSet;
        }
        public function get useCntMaxSet():Array
        {
            return _useCntMaxSet;
        }

        public function get baseSap():int
        {
            return _baseSap;
        }
        public function get baseSdp():int
        {
            return _baseSdp;
        }
        public function get baseAap():int
        {
            return _baseAap;
        }
        public function get baseAdp():int
        {
            return _baseAdp;
        }
        public function get baseTotal():int
        {
            log.writeLog(log.LV_DEBUG, this, "baseTotal",_baseSap,_baseSdp,_baseAap,_baseAdp);
            return _baseSap+_baseSdp+_baseAap+_baseAdp;
        }

        public function get baseMax():int
        {
            return _baseMax;
        }

        // Indexで基礎数値を取得（近攻、近防、遠攻、遠防）
        public function getBaseParamIdx(idx:int):int
        {
            var params:Array = [_baseSap,_baseSdp,_baseAap,_baseAdp];
            return params[idx];
        }

        public function get addSap():int
        {
            return _addSap;
        }
        public function get addSdp():int
        {
            return _addSdp;
        }
        public function get addAap():int
        {
            return _addAap;
        }
        public function get addAdp():int
        {
            return _addAdp;
        }
        public function get addMax():int
        {
            return _addMax;
        }
        // Indexで加算数値を取得（近攻、近防、遠攻、遠防）
        public function getAddParamIdx(idx:int):int
        {
            var params:Array = [_addSap,_addSdp,_addAap,_addAdp];
            return params[idx];
        }
        // Indexで基礎数値に対する加算数値の最大値取得（近攻、遠攻、近防、遠防）
        public function getAddMaxParamIdx(idx:int):int
        {
            return _level + restrictionAddParam;
            // var base:int = getBaseParamIdx(idx);
            // if (base > 0) {
            //     return Const.CMB_ADD_PARAM_UPPER_LIMIT;
            // } else if (base == 0) {
            //     return Const.CMB_ADD_PARAM_ZERO_LIMIT;
            // } else {
            //     return Const.CMB_ADD_PARAM_LOWER_LIMIT;
            // }
        }
        public function get addMaxParam():int
        {
            return _level + restrictionAddParam;
        }
        private function get restrictionAddParam():int
        {
            return (isCharaSpecial) ? 5 : 0;
        }
        // 加算数値の最大値取得
        public function get addParamMax():int
        {
            return (isCharaSpecial&&_weaponType == Const.WEAPON_TYPE_CMB_WEAPON) ? _level + RESTRICTION_SET_ADD_PARAM : _level;
        }

        public function get materialUseMaxNum():int
        {
            return _matUseMaxNum;
        }

        public function get weaponType():int
        {
            return _weaponType;
        }

        public function get forceReload():Boolean
        {
            return _forceReload;
        }
        public function set forceReload(f:Boolean):void
        {
            _forceReload = f;
        }

        // 専用武器か
        public function get isCharaSpecial():Boolean
        {
            return (_restriction&&_restriction.length > 0&&restriction[0] != "")
        }
        // 既存専用武器か
        public function get isNormalCharaSpecial():Boolean
        {
            return (_id >= Const.CMB_BLOCK_WC_ID_START && Const.CMB_BLOCK_WC_ID_END >= _id);
        }
        // 既存通常武器か
        public function get isNormalWeapon():Boolean
        {
            return (_weaponType == Const.WEAPON_TYPE_NORMAL && !isCharaSpecial && !isNormalCharaSpecial);
        }

        public function get matAddSap():int
        {
            return _matAddSap;
        }
        public function get matAddSdp():int
        {
            return _matAddSdp;
        }
        public function get matAddAap():int
        {
            return _matAddAap;
        }
        public function get matAddAdp():int
        {
            return _matAddAdp;
        }
        // Indexで素材使用時加算数値を取得（近攻、近防、遠攻、遠防）
        public function getMatAddParamIdx(idx:int):int
        {
            var params:Array = [_matAddSap,_matAddSdp,_matAddAap,_matAddAdp];
            return params[idx];
        }

        public function get level():int
        {
            return _level;
        }
        public function get exp():int
        {
            return _exp;
        }

        public function get passiveNumMax():int
        {
            return _passiveNumMax;
        }
        public function get passiveNum():int
        {
            var ret:int = 0;
            for (var i:int = 0; i<_useCntSet.length; i++) {
                if (_useCntSet[i] > 0) {
                    ret++;
                }
            }
            return ret;
        }
        public function get weaponPassiveNum():int
        {
            return _weaponPassiveId.length;
        }
        public function get weaponPassiveId():Array
        {
            return _weaponPassiveId;
        }
        public function get passiveIdPassSet():Array
        {
            return _passiveIdPassSet;
        }


        // WeaponCardをコピーして返す
        public function copyThis():WeaponCard
        {
            var cardId:int = id;
            if (_combined) {
                cardId = _baseCardId;
            }
            return copyCombineWeaponCard(cardId);
        }
        public function copyCombineWeaponCard(id:int):WeaponCard
        {
            // 合成関連の各パラメータを一時保持
            var bsap:int = _baseSap;
            var bsdp:int = _baseSdp;
            var baap:int = _baseAap;
            var badp:int = _baseAdp;
            var asap:int = _addSap;
            var asdp:int = _addSdp;
            var aaap:int = _addAap;
            var aadp:int = _addAdp;
            var bmax:int = _baseMax;
            var amax:int = _addMax;
            var cntStr:String = _useCntSet.join("|");
            var cntMaxStr:String = _useCntMaxSet.join("|");
            var passiveIdStr:String = getCombinePassive().join("|");
            var restrictionStr:String = _restriction.join("|");
            var weaponPassiveIdStr:String = _weaponPassiveId.join("|");
            var level:int = _level;
            var exp:int = _exp;
            var wc:WeaponCard = new WeaponCard(__copyDummyWeaponCnt+CMB_COPY_DUMMY_START_ID);
            var baseWC:WeaponCard = WeaponCard.ID(id);
            wc._name = baseWC.name;
            wc._no = baseWC.no;
            wc._cost = baseWC.cost;
            wc._restriction = baseWC.restriction;
            wc._image = baseWC.image;
            wc._type = baseWC.type;
            wc._caption = baseWC.caption;
            wc._weaponType    = baseWC.weaponType;
            wc._matUseMaxNum  = baseWC.materialUseMaxNum;
            wc._matAddSap    = baseWC.matAddSap;
            wc._matAddSdp    = baseWC.matAddSdp;
            wc._matAddAap    = baseWC.matAddAap;
            wc._matAddAdp    = baseWC.matAddAdp;
            wc._weaponPassiveId = baseWC.weaponPassiveId;
            wc._baseCardId = id;
            wc._combined = _combined;
            wc.setCombineWeaponParam(id,bsap,bsdp,baap,badp,bmax,asap,asdp,aaap,aadp,amax,passiveIdStr,restrictionStr,cntStr,cntMaxStr,level,exp);
            __copyDummyWeaponCnt++;
            return wc;
        }

        // インターフェイス用の偽アクセサ（後々取る予定。）

        public function get abName():String
        {
            return "";
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

// import model.WeaponCard;
// import model.Feat;

// // WeaponCardのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _ap:WeaponCard;

//     public function Loader(ap:WeaponCard)
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
