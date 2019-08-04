package model.utils
 {
    import flash.external.ExternalInterface;
    import flash.utils.getQualifiedClassName;
    import flash.utils.ByteArray;
    import flash.net.SharedObject;

    import model.utils.logs.*;
    /**
     * クライアントのログクラス
     * 
     */





    public class ClientLog
    {

        public static const ALL:int                 = 0;      // 全記録
        public static const GOT_EXCH_CARD:int       = 1;      // 合成の記録
        public static const GOT_LOT:int             = 2;      // クジの記録
        public static const GOT_LOGIN:int           = 3;      // ログインボーナスの記録
        public static const BOUGHT_ITEM:int         = 4;      // アイテム購入の記録
        public static const BOUGHT_RMITEM:int       = 5;      // リアルマネーアイテム購入の記録
        public static const GOT_ITEM:int            = 6;      // アイテム取得の記録
        public static const GOT_LEVEL:int           = 7;      // レベルアップの記録
        public static const GOT_SLOT_CARD:int       = 8;      // スロットカード取得の記録
        public static const GOT_CHARA_CARD:int      = 9;      // キャラカード取得の記録
        public static const GOT_AVATAR_PART:int     = 10;     // アバターパーツ取得の記録
        public static const SUCC_ACHIEVEMENT:int    = 11;     // アチーブメント達成の記録
        public static const SUCC_INVITE:int         = 12;     // 招待成功の記録
        public static const VANISH_ITEM:int         = 13;     // アイテム消滅の記録
        public static const VANISH_CARD:int         = 14;     // カード消滅の記録

        public static const TYPE_NUM:int            = 15;     // タイプの合計数

//        private static const  _GOT_LOT_STR:String          = "__DATA__:__NAME__をカードクジで取得しました。";
//        private static const  _GOT_LOGIN_STR:String        = "__DATA__:__NAME__をログインボーナスで取得しました。";
//        private static const  _BOUGHT_ITEM_STR:String      = "__DATA__:__NAME__を購入しました。";
//        private static const  _BOUGHT_RMITEM_STR:String    = "__DATA__:__NAME__を__NAME2__で購入しました。";
//        private static const  _GOT_ITEM_STR:String         = "__DATA__:__NAME__を手に入れた。";
//        private static const  _GOT_LEVEL:String            = "__DATA__:__NAME__レベルになりました。";
//        private static const  _GOT_SLOT_CARD_LOG:String    = "__DATA__:__NAME__を手に入れた。";
//        private static const  _GOT_CHARA_CARD_STR:String   = "__DATA__:__NAME____RARE__LV__を入手しました。";
//        private static const  _GOT_AVATAR_PART_STR:String  = "__DATA__:__NAME__を入手しました。";
//        private static const  _SUCC_ACHIEVEMENT_STR:String = "__DATA__:__NAME__のレコードを達成しました。";
//        private static const  _SUCC_INVITE_STR:String      = "__DATA__:__NAME__の招待に成功しました。";
//        private static const  _VANISH_ITEM_STR:String      = "__DATA__:__NAME__の期限がきました";
//        private static const  _VANISH_CARD_STR:String      = "__DATA__:__NAME__が__NUM__枚消滅しました";

//         private static const  __COLOR_SET:Array = [ ]; /* of int */ 

        // 実際のデータの配列
        private static var __uid:String;
        private static var __inited:Boolean =  false;

        protected static const MAX_NUM:int = 20; // 保存する数一つのLOGのMAX保存数
        protected static var __tmp:Array = []; /* of ClientLog */ 


        // 日付の配列
        protected var _dateSet:Vector.<Date> = new Vector.<Date>();
        // 名前の配列
        protected var _nameSet:Vector.<String>  = new Vector.<String>();
        // 種類
        protected var _type:int;
        protected var _toStrFunc:Function;
        protected var _setLogFunc:Function;
        protected var _sharedObj:SharedObject;
        protected var _textSet:Array= [];

        public static function init(uid:int):void
        {
            if (__inited == false)
            {
                log.writeLog(log.LV_INFO, "### clientlog init");
                __uid = uid.toString();
                __tmp.push(new Array);
                __tmp.push(new ExchangeCardLog());
                __tmp.push(new LotLog());
                __tmp.push(new LoginBonusLog());
                __tmp.push(new BoughtItemLog());
                __tmp.push(new BoughtRMItemLog());
                __tmp.push(new ItemGetLog());
                __tmp.push(new LevelUpLog());
                __tmp.push(new SlotCardGetLog());
                __tmp.push(new CharaCardGetLog());
                __tmp.push(new AvatarPartGetLog());
                __tmp.push(new SuccessAchievementLog());
                __tmp.push(new SuccessInviteLog());
                __tmp.push(new VanishItemLog());
                __tmp.push(new VanishCardLog());
                __inited = true;
            }
        }

        public static function write(type:int, a:Object, save:Boolean = false ):void
        {
            __tmp[0].unshift(__tmp[type].setLog(a,  save));
        }


        public static function read(type:int, offset:int, num:int ):Array
        {
            var ret:Array=[]; /* of String */ 
            for(var i:int = offset; i < num; i++){
                if (type == 0)
                {
                    ret.push(__tmp[0][i]);
                }else{
                    ret.push(__tmp[type].getLog(i));
                }
            }
            return ret;
        }


        public function ClientLog()
        {
            // 保存データを読み込む
            _sharedObj = SharedObject.getLocal(__uid+"_"+type.toString());
            // 保存データなしなら作り直し
            if (_sharedObj.data.dateSet == undefined)
            {
                _sharedObj.data.dateSet = [];
                _sharedObj.data.nameSet = [];
            }
        }

        protected function duplicateCheck(text:String):void
        {
            log.writeLog(log.LV_INFO, this, "setText",text,_textSet[0]);
            if(_textSet[0]==null||_textSet[0].replace(/X\d*/,"") != text)
            {
                _textSet.unshift(text);
            }else{
                log.writeLog(log.LV_INFO, this, "setText num ",_textSet[0]);
                var num:int = 1;
                if (_textSet[0].match(/X\d*/)!=null)
                {
                    log.writeLog(log.LV_INFO, this, "setText num 222",_textSet[0].match(/X\d*/));
                    num=int(_textSet[0].match(/X\d*/)[0].replace(/X/,""));
                }
                log.writeLog(log.LV_INFO, this, "setText num 333",num);
                num+=1;
                _textSet[0] = text+"X"+num.toString();
                dateSet.shift();
                nameSet.shift();
                _sharedObj.flush();
            }

        }

        public static function getLogNum( type:int ):int
        {
            if ( type == ALL ) {
                return __tmp[type].length;
            } else {
                return __tmp[type].dateSet.length;
            }
        }

        public function get type():int
        {
            return _type;
        }

        public function getLog(i:int):String
        {
            return "";
        }

        public function setLog(a:Object, save:Boolean = false):String
        {
            return _nameSet[0];
        }

        public function get dateSet():Array /* of Date */
        {
            return _sharedObj.data.dateSet;
        }

        public function get nameSet():Array /* of String */
        {
            return _sharedObj.data.nameSet;
        }

        protected function checkMax():void
        {
            if(nameSet.length > MAX_NUM)
            {
                nameSet.pop();
                dateSet.pop();
                _textSet.pop();
            }
        }
    }
}