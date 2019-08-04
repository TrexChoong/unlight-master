package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import org.libspark.thread.Thread;

    import model.utils.*;


    /**
     * キャラカードクラス
     * 情報を扱う
     * 
     */
    public class CharaCard  extends BaseModel implements ICard
    {

        public static const INIT:String = 'init';             // 情報をロード
        public static const UPDATE:String = 'update';         // 情報をロード
        public static const UPDATE_NUM:String = 'update_num'; // 情報をロード
        private static var __loader:Function;                 // パラムを読み込む関数
        private static var __cards:Object =[];                // ロード済みのカード
        private static var __loadings:Object ={};             // ロード中のカード
        private static var __registCards:Array = [];/* of CharaCard *///登録時に使えるカード
        private static var __abNameRegExp:RegExp =  /-(.*)- (.*)/g;


        private var _name          :String  // 名前
        private var _abName        :String; // 英名
        private var _titleName     :String; // 異名
        private var _englishName   :String; // 異名
        private var _level         :int;    // レベル
        private var _hp            :int;    // HP
        private var _ap            :int;    // 攻撃力
        private var _dp            :int;    // 防御力
        private var _rarity        :int;    // レアリティ
        private var _cost          :int;    // コスト
        private var _slotColor     :Array;    // スロット色

        private var _standImage    :String; // キャラ立ち絵のSWF名
        private var _charaImage    :String; // キャラ絵のSWF名
        private var _artifactImage :String; // 前景のSWF名（アイテム、衣装など）
        private var _bgImage       :String; // 背景のSWF名
        private var _caption       :String; // キャプション
        private var _feats         :Array = [];  // 必殺技
        private var _overrideFeats :Object = new Object();
        private var _passiveSkill  :Array = [];  // パッシブスキル
        private var _storyID       :int;    // ストーリーID
        private var _charactor     :int;    // キャラ番号
        private var _parentID      :int;    // 親カードのID
        private var _nextID        :int;    // 成長先キャラカードID
        private var _version       :int;    //バージョン

        private var _storyTitle    :String; // ストーリーのタイトル
        private var _storyAgeNo    :String; // ストーリーの時系列

        private var _num           :int = 0;    // 所持枚数
        private var _type          :int = InventorySet.TYPE_CHARA;    // 
        private var _kind          :int = InventorySet.TYPE_CHARA;    // 

        private var _towerHp       :int = 0;    // By_K2 (무한의탑 증가 HP)
        private var _towerAp       :int = 0;    // By_K2 (무한의탑 증가 AP)
        private var _towerDp       :int = 0;    // By_K2 (무한의탑 증가 DP)

        // public static const CHARACTOR_UNKNOWN_ID:int = 1000;           // 有効でないキャラクターのID
        // public static const CHARACTOR_COIN_ID:int = 1000;              // モンスターコインのキャラクターのID
        // public static const CHARACTOR_TIPS_ID:int = 1001;              // カードのかけらのキャラクターのID
        // public static const CHARACTOR_EX_COIN_ID:int = 1002;           // EXコインのキャラクターのID
        // public static const CHARACTOR_EX_TIPS_ID:int = 1003;           // ケイオシウムのキャラクターのID
        // public static const CHARACTOR_EX_MONSTER_ID:int = 2000;        // 特殊なモンスターのID

        private static var __storyDataList:Array;                      // ストーリータイトル、時系列のリスト - Array of Object
        private static var __searchId:int         = 0;                 // 検索に関するIDを入れる
        private static var __searchParam:Object   = {};                // 検索に関するパラメータを入れる Object of charactor: rearity
        private static const COLUMN_CHARACTOR:int = 17;                // characorの添え字ID
        private static const COLUMN_RARITY:int    = 7;                 // rarityの添え字ID

        private static const RARITY_BORDER:int = 5;

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
            CharaCard.getBlankCard(); // ブランクカードだけは速攻で作る
        }

        private static function getData(id:int):void
        {
                var a:Array; /* of ElementType */ 
                if (ConstData.getData(ConstData.CHARA_CARD, id) != null)
                {
                    a = ConstData.getData(ConstData.CHARA_CARD, id);
                    updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[21], a[22], a[Story.COLUMN_NUM], 0, true);
                }

        }

        public static function clearData():void
        {
            __cards.forEach(function(item:CharaCard, index:int, array:Array):void{if (item != null){item._loaded = false}});
        }

        // IDのCharaCardインスタンスを返す
        public static function ID(id:int):CharaCard
        {
//            log.writeLog(log.LV_INFO, "static CharaCard" ,"get id",id, __cards[id]);
            if(id == 0)
            {
                return getBlankCard();
            } else if (__cards[id] == null)
            {
                __cards[id] = new CharaCard(id);
                getData(id);
                return __cards[id];
            }else{
                // ロード済みでもローディング中でもないなら読む
                if (!(__cards[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
                return __cards[id];
            }
        }

        // ローダがCharaCardのパラメータを更新する
        public static function updateParam(id:int,  name:String, abName:String, level:int, hp:int, ap:int, dp:int, rarity:int, cost:int, slot:int, standImage:String, charaImage:String, artifactImage:String, bgImage:String, caption:String, feats:String, story:int, chara:int, nextID:int, kind:int, passiveSkill:String, s_data:Array, version:int, cache:Boolean=false):void
        {

//            log.writeLog(log.LV_INFO, "static CharaCard" ,"update id",id, ap, dp,feats);

            if (__cards[id] == null)
            {
                __cards[id] = new CharaCard(id);
            }
            __cards[id]._id            = id;
            __cards[id]._name          = name;
            __cards[id]._abName        = abName;
            __cards[id]._level         = level;
            __cards[id]._hp            = hp;
            __cards[id]._ap            = ap;
            __cards[id]._dp            = dp;
            __cards[id]._rarity        = rarity;
            __cards[id]._standImage    = standImage;
            __cards[id]._charaImage    = charaImage;
            __cards[id]._artifactImage = artifactImage;
            __cards[id]._bgImage       = bgImage;
            __cards[id]._caption       = caption;
            __cards[id]._storyID       = story;
            __cards[id]._charactor     = chara;
            __cards[id]._nextID        = nextID;
            __cards[id]._version       = version;
            __cards[id]._cost          = cost;
            __cards[id]._kind          = kind;
            __cards[id]._slotColor     = String(slot).split("");
            __cards[id]._feats = [];
            __cards[id]._passiveSkill = [];
            if (chara)
            {
                var charactor_data:Array = ConstData.getData(ConstData.CHARACTOR, chara);
                if (charactor_data)
                {
                    __cards[id]._parentID      = ConstData.getData(ConstData.CHARACTOR, chara)[4];
                }
            }

            if(abName.indexOf("-") == -1)
            {
                __cards[id]._englishName = abName;
                __cards[id]._titleName = "";
            }
            else
            {
                __cards[id]._englishName = abName.replace(__abNameRegExp,"$2");
                __cards[id]._titleName = abName.replace(__abNameRegExp,"$1");
            }

            if (feats != "")
            {
                var f_set:Array = feats.split(",");
                f_set.forEach(function(item:*, index:int, array:Array):void{
                        if (item != null)
                        {
                            __cards[id]._feats.push(Feat.ID(item));
                        }
                    });
            }

            if (passiveSkill != "")
            {
                var p_set:Array = passiveSkill.split(",");
                p_set.forEach(function(item:*, index:int, array:Array):void{
                        if (item != null)
                        {
                            __cards[id]._passiveSkill.push(PassiveSkill.ID(item));
                        }
                    });
            }

            if ( s_data.length > 0 && __cards[id]._storyID == s_data[Story.COLUMN_ID] )
            {
                __cards[id]._storyTitle = s_data[Story.COLUMN_TITLE];
                __cards[id]._storyAgeNo = s_data[Story.COLUMN_AGE_NO];
            }

            if (!cache)
            {
                Cache.setCache(Cache.CHARA_CARD, id, name, abName, level, hp, ap, dp, rarity, cost, slot, standImage, charaImage, artifactImage, bgImage, caption, feats, story, chara, nextID, kind, passiveSkill, __cards[id]._storyTitle, __cards[id]._storyAgeNo, version);
            }


            if (__cards[id]._loaded)
            {
                __cards[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static CharaCard" ,"load update",id,__cards[id]._loaded);
            }
            else
            {
                __cards[id]._loaded  = true;
                __cards[id].notifyAll();
                __cards[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static CharaCard" ,"load init",id,__cards[id]);
            }
            __loadings[id] = false;

        }

        // 
        public function addPassiveSkill(charaId:int, pid:int):Boolean
        {
            var passive:PassiveSkill;
            if (pid)
            {
               passive = PassiveSkill.ID(pid);
            }

            if (pid && __cards[charaId]._passiveSkill.length < 4 && __cards[charaId]._passiveSkill.indexOf(passive) < 0)
            {
                __cards[charaId]._passiveSkill.push(passive);
                return true;
            }
            else
            {
                return false;
            }
        }

        // Unknown用のブランクカード
        public static function getBlankCard():CharaCard
        {
            if (__cards[0] == null)
            {
                var cc:CharaCard = new CharaCard(0);
                cc._id            = 0;
                cc._name          = "";
                cc._abName        = "";
                cc._level         = 0;
                cc._hp            = 0;
                cc._ap            = 0;
                cc._dp            = 0;
                cc._rarity        = 10;
                cc._standImage    = "";
                cc._charaImage    = "cc00.swf";
                cc._artifactImage = "";
                cc._bgImage       = "";
                cc._caption       = "";
                cc._storyID       = 0;
                cc._charactor     = 0;
                cc._parentID      = 0;
                cc._nextID        = 0;
                cc._kind          = 0;
                cc._loaded        = true;
                __cards[0]        = cc;
                __cards[0]._cost          = 0;
                __cards[0]._slotColor     = [];
            }
            return __cards[0];
        }
        // 登録時に使えるカードリストをセットする
        public static function setRegistCards(ids:Array /* of int */ ):void
        {
            ids.forEach(function(item:*, index:int, array:Array):void{__registCards.push(ID(item))});
        }
        // 登録時に使えるカードリストをゲットする
        public static function getRegistCards():Array
        {
            return __registCards;
        }
        // コンストラクタ
        public function CharaCard(id:int)
        {
            _id = id;
        }

        public function get name():String
        {
            return _name;

        }

        public function get abName():String
        {
            return _abName;
        }

        public function get englishName():String
        {
            return _englishName;
        }
        public function get titleName():String
        {
            return _titleName;
        }
        public function get level():int
        {
            return _level;
        }

        public function get nameSet():String
        {
            var ret:String = _name;
            switch (_kind)
            {
            case Const.CC_KIND_CHARA:
                if (_rarity > RARITY_BORDER) {
                    ret += " R" + _level;
                } else {
                    ret += " Lv." + _level;
                }
                break;
            case Const.CC_KIND_REBORN_CHARA:
                ret += " Lv." + _level;
                break;
            case Const.CC_KIND_RENTAL:
                ret += " Lv." + _level;
                break;
            case Const.CC_KIND_EPISODE:
                ret += " Lv." + _level;
                break;
            default:
                break;
            }
            return ret;
        }

        public function get hp():int
        {
            return _hp;
        }

        // By_K2 (무한의탑 몬스터 능력치 증가)
        public function setPower(num:int):void
        {
            // By_K2 : 기준은 11층 (이하일경우는 약화)
            var t_hp:int = num - 1 - 10;
            var t_ap:int = int(num / 5) - 2;
            var t_dp:int = int(num / 5) - 2;

            _hp = _hp + t_hp - _towerHp;
            _ap = _ap + t_ap - _towerAp;
            _dp = _dp + t_dp - _towerDp;

            _towerHp = t_hp;
            _towerAp = t_ap;
            _towerDp = t_dp;
        }

        // By_K2 (무한의탑 몬스터 능력치 복귀)
        public function unSetPower():void
        {
            _hp = _hp - _towerHp;
            _ap = _ap - _towerAp;
            _dp = _dp - _towerDp;

            _towerHp = 0;
            _towerAp = 0;
            _towerDp = 0;
        }
        
        public function get ap():int
        {
            return _ap;
        }

        public function get dp():int
        {
            return _dp;
        }
        public function get rarity():int
        {
            return _rarity;
        }
        public function get standImage():String
        {
            var cid:int = _kind == Const.CC_KIND_EPISODE ? parentID : _charactor;

            if (AvatarItemInventory.resultImages[cid] > 0)
            {
                return _standImage + "_res0";
            }
            else
            {
                return _standImage;
            }
        }
        public function get charaImage():String
        {
            return _charaImage;
        }
        public function get artifactImage():String
        {
            return _artifactImage;
        }
        public function get bgImage():String
        {
            return _bgImage;
        }
        public function get caption():String
        {
            return _caption;
        }
        public function get feats():Array
        {
            return _feats;
        }

        public function get passiveSkill():Array
        {
            return _passiveSkill;
        }

        public function get story():Story
        {
            return Story.ID(_storyID);
        }

        public function get storyId():int
        {
            return _storyID;
        }

        public function get storyTitle():String
        {
            return _storyTitle;
        }

        public function get storyAgeNo():String
        {
            return _storyAgeNo;
        }

        public function get next():CharaCard
        {
            return CharaCard.ID(_nextID)
        }

        public function get bookExist():Boolean
        {
            if (_storyID ==0)
            {
                return false;
            }else{
                return true;
            }
        }
        public function get isCompositable():Boolean
        {
            return ( _kind == Const.CC_KIND_CHARA ||
                     _kind == Const.CC_KIND_MONSTAR ||
                     _kind == Const.CC_KIND_COIN ||
                     _kind == Const.CC_KIND_REBORN_CHARA);
        }

        public function getLoader():Thread
        {
            return new Loader(__loader, this);
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

        public function get cost():int
        {
            return _cost;
        }

        public function get charactor():int
        {
            return _charactor;
        }

        public function get parentID():int
        {
            return _parentID == 0 ? _charactor : _parentID;
        }

        public function get color():int
        {
//             return toString(_color).split("");
            return 0;
        }

        public function get slotColor():Array
        {
            return _slotColor;
        }

        public function get restriction():Array
        {
            return [];
        }

        public function get slotValues():Array
        {
            var ret:Array = [0,0,0,0,0,0,0,0]; /* of ElementType */ 

            for(var i:int = 0; i < 8; i++){
                if (_slotColor[i]==null)
                {
                    ret[0]++;
                }else{
                    ret[_slotColor[i]]++
                }
            }
            return ret;
        }
        public function get type():int
        {
            return _type;
        }
        public function get kind():int
        {
            return _kind;
        }

        public function isRare():Boolean
        {
            return (_rarity > 5);
        }

        // キャラごとの取得リストを送る
        public static function getCardList():Array
        {
            log.writeLog(log.LV_INFO, "CharaCard.as", "static");
//             var ret:Vector.<CharaCard> = new Vector.<CharaCard>;
//             var ret2:Vector.<CharaCard> = new Vector.<CharaCard>;
            var ret:Dictionary = new Dictionary();
            var ret2:Dictionary = new Dictionary();
            var ret3:Dictionary = new Dictionary();

            __cards.forEach(function(item:CharaCard, index:int, array:Array):void{
                    if(item!=null)
                    {
                        if (item.num > 0)
                        {
                            switch (item.kind) {
                            case Const.CC_KIND_CHARA:
                                if(ret[item.charactor.toString()]==null){ret[item.charactor.toString()]=[]};
//                                log.writeLog(log.LV_INFO, "CharaCard.as", ret[item.charactor.toString()],item,item.id,item.charactor.toString());
                                ret[item.charactor.toString()].push(item);
//                                log.writeLog(log.LV_INFO, "CharaCard.as", ret[item.charactor.toString()]);
                                break;

                            case Const.CC_KIND_EPISODE:
                                if(ret[item.parentID.toString()]==null){ret[item.parentID.toString()]=[]};
                                ret[item.parentID.toString()].push(item);
                                break;

                            case Const.CC_KIND_REBORN_CHARA:
                                if(ret2[item.charactor.toString()]==null){ret2[item.charactor.toString()]=[]};
                                ret2[item.charactor.toString()].push(item);
                                break;

                            case Const.CC_KIND_MONSTAR:
                            case Const.CC_KIND_BOSS_MONSTAR:
                            case Const.CC_KIND_RARE_MONSTAR:
                                if(ret3[item.charactor.toString()]==null){ret3[item.charactor.toString()]=[]};
                                ret3[item.charactor.toString()].push(item);
                                break;

                            default:

                            }
                        }
                    }
                });
            log.writeLog(log.LV_INFO, ret,ret2,ret3);
            return [ret,ret2,ret3];
        }

        // 解禁済みのストーリー時系列順のリストを送る
        public static function getCardListForStoryAge():Array
        {
            var ret:Array = [];

            // ロード済みでストーリー持ちをリストに入れる
            __cards.forEach(function(item:CharaCard, index:int, array:Array):void{
                    if ( item!=null && item.num > 0 && item.storyId > 0 && item.storyAgeNo != "" ) {
                        // キャラクターの場合
                        if (item.kind == Const.CC_KIND_CHARA) {
                        // 同じキャラで、item以下のレア度のデータを取得
                        __searchParam = {charactor:item.charactor,rarity:item.rarity};
                        var sameCharaBelowRareList:Array = ConstData.getDataList(ConstData.CHARA_CARD).filter(getSameCharaBelowRearity);
                        sameCharaBelowRareList.forEach(function(sameChara:*, sameIndex:int, sameArray:Array):void{
                                __searchId = sameChara[0];
                                if ( ret.filter(getCharaId).length == 0 ) {
                                    // ロードされていない場合を考え、インスタンスを取得
                                    var cc:CharaCard = CharaCard.ID(sameChara[0]);
                                    if ( cc!=null && cc.storyId > 0 ) ret.push(cc);
                                }
                            });
                        } else {
                        // モンスターの場合
                            __searchId = item.id;
                            if ( ret.filter(getCharaId).length == 0 ) {
                                ret.push(item);
                            }
                        }
                    }
                });

            // リストを時系列でソートする
            ret.sortOn("storyAgeNo");

            return ret;
        }
        private static function getCharaId(item:*, index:int, array:Array):Boolean
        {
            return item.id == __searchId;
        }
        private static function getSameCharaBelowRearity(item:*, index:int, array:Array):Boolean
        {
            return ((item[COLUMN_CHARACTOR] == __searchParam.charactor) && (item[COLUMN_RARITY] >= 5) && (item[COLUMN_RARITY] <= __searchParam.rarity));
        }

        // 次の時系列のデータをストーリーIDから取得
        public static function getNextAgeStoryCharaDataFromId(storyId:int=1):Object
        {
            // リストがなければ作っておく
            if ( __storyDataList == null ) {
                __storyDataList = new Array(); /* of Object id: title: ageNo: */ ;
                var list:Array = ConstData.getDataList(ConstData.CHARA_CARD).filter(isSetStory);
                list.forEach(function(item:*, index:int, array:Array):void{
                        __storyDataList.push({storyId:item[Story.COLUMN_NUM][0],storyTitle:item[Story.COLUMN_NUM][1],storyAgeNo:item[Story.COLUMN_NUM][2]});
                    });
                __storyDataList.sortOn("storyAgeNo");
            }

            var ret:Object = null;
            __storyDataList.forEach(function(item:*, index:int, array:Array):void{
                    if ( storyId == item.storyId ) {
                        if ( __storyDataList[index+1] != null ) {
                            ret = __storyDataList[index+1];
                            return;
                        }
                    }
                });

            return ret;
        }
        private static function isSetStory(item:*,index:int,array:Array):Boolean
        {
            return (item[Story.COLUMN_NUM] && item[Story.COLUMN_NUM].length > 0);
        }
        public function isSamePerson(cc:CharaCard):Boolean
        {
            return this.baseCharactorId == cc.baseCharactorId;
        }

        // 復活カードの場合は復活前のキャラクターIDを返す
        public function get unlightCharactorId():int
        {
            return this.kind == Const.CC_KIND_REBORN_CHARA ? this.charactor - Const.REBORN_CHARACTOR_ID_OFFSET : this.charactor
        }

        // 派生カードは親のIDを返し、復活カードは復活前のIDを返す。同一キャラ判定用
        public function get baseCharactorId():int
        {
            switch (this.kind)
            {
            case Const.CC_KIND_REBORN_CHARA:
                return this.unlightCharactorId;
            default:
                return this.parentID;
            }
        }
    }
}
import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import model.CharaCard;
import model.Feat;
import model.utils.ReLoaderThread;

// CharaCardのロードを待つスレッド
class Loader extends ReLoaderThread
{
    private var  _cc:CharaCard;

    public function Loader(func:Function, cc:CharaCard)
    {
        _cc =cc;
        super(func, cc)
    }

    protected override function reload():void
    {
        if (_bm.loaded == false)
        {
            _loader(_bm.id);
            next(waitingTimer);
//            log.writeLog(log.LV_WARN, "model" ,"load Fail ReLoad!!",_bm);
        }else{
            next(close)
        }
    }

//     private function featLoad ():void
//     {
//         var pExec:ParallelExecutor = new ParallelExecutor();

//         for(var i:int = 0; i < _cc.feats.length; i++)
//         {
//             var x:Feat = _cc.feats[i];
//             pExec.addThread(x.getLoader());
//         }
//         pExec.start();
//         pExec.join();
//         next(close);
//     }

    private function close ():void
    {
    }
}

