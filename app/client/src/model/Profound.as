package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;

    import flash.utils.ByteArray;

    import org.libspark.thread.*;
    import net.*;
    import view.*;
    import controller.*;

    // 渦情報クラス
    public class Profound extends BaseModel
    {
        CONFIG::LOCALE_JP
        {
            public static const SET_URL_BASE:String = "orig";
        }
        CONFIG::LOCALE_EN
        {
            public static const SET_URL_BASE:String = "orig";
        }
        CONFIG::LOCALE_TCN
        {
            public static const SET_URL_BASE:String = "orig";
        }
        CONFIG::LOCALE_SCN
        {
            public static const SET_URL_BASE:String = "orig";
        }
        CONFIG::LOCALE_KR
        {
            public static const SET_URL_BASE:String = "orig";
        }
        CONFIG::LOCALE_FR
        {
            public static const SET_URL_BASE:String = "orig";
        }
        CONFIG::LOCALE_ID
        {
            public static const SET_URL_BASE:String = "orig";
        }
        CONFIG::LOCALE_TH
        {
            public static const SET_URL_BASE:String = "orig";
        }

        public static const PRF_NEW:int        = 0; // 新規追加
        public static const PRF_NOT_CHANGE:int = 1; // 変化なし
        public static const PRF_UPDATE:int     = 2; // 更新
        public static const PRF_FINISH:int     = 3; // 終了
        public static const PRF_VANISH:int     = 4; // 消失

        public static const PRF_ST_UNKNOWN:int       = 0; // 正体不明
        public static const PRF_ST_BATTLE:int        = 1; // Boss看破＆戦闘中
        public static const PRF_ST_FINISH:int        = 2; // 戦闘終了
        public static const PRF_ST_VANISH:int        = 3; // 消失
        public static const PRF_ST_VANISH_DEFEAT:int = 4; // 消失:討伐

        public static const PRF_SORT_ID:int     = 0; // ソート：ID順
        public static const PRF_SORT_TIME:int   = 1; // ソート：残り時間が短い順
        public static const PRF_SORT_RARE:int   = 2; // ソート：レア度が低い順
        public static const PRF_SORT_FINDER:int = 3; // ソート：自分が発見したもの優先

        public static const PRF_CODE_COPY_TYPE_ALL:int    = 0; // 制限なし
        public static const PRF_CODE_COPY_TYPE_OWNER:int  = 1; // 発見者のみ
        public static const PRF_CODE_COPY_TYPE_FRIEND:int = 2; // 発見者＆発見者のFriendのみ

        public static const PRF_MAP_RANDOM_ID:int = 9999; // 表示位置をランダムにする場合の指定ID

        private static const LIMIT_ALERT_TIME:int = 1000 * 60 * 60 * 2; // 消滅2時間前からアラート表示

        private static const USE_AP_FOR_TURN_SET:Array = [1,2,3,4,5,6,7,8,9,10];
        private static const SEL_TURN_MAX:int = 10;

        private var _profoundData:ProfoundData; // 渦データ
        private var _prfDataId:int;             // 渦データID
        private var _prfHash:String;            // 渦Hash
        private var _closeAtTime:Date;          // 消滅時間
        private var _closeAtTimeStr:String;     // 消滅時間:String
        private var _createdAtTime:Date;        // 開始時間
        private var _createdAtTimeStr:String;   // 開始時間:String
        private var _state:int;                 // 状態
        private var _mapId:int;                 // 配置マップID
        private var _posIdx:int;                // 配置インデックス
        private var _copyType:int;              // CODEコピータイプ
        private var _setDefeatReward:Boolean;   // 撃破報酬の有無
        private var _nowDamage:int;             // 現在HP
        private var _viewDamage:int;            // 表示用HP
        private var _finderAvatarId:int;        // 発見者アバターID
        private var _finderName:String;         // 発見者名

        private static var __items:Array = [];          // Array of Profound
        private static var __sortItems:Array = [];
        private static var __sortType:int = PRF_SORT_ID;
        private static var __isLoaded:Boolean = false; // ロード済みか
        private static var __urlProfoundHash:String = "";
        private static var __urlErrorId:int = 0;

        private static var _ctrl:RaidDataCtrl = RaidDataCtrl.instance;  // レイドのコントローラー

        private var _waitThread:Thread;         // 消滅までの待ちThread

        public static function initializeProfounds():void
        {
            __items = []
        }

        public static function get items():Array
        {
            return __items;
        }
        // ロード済みか
        public static function get isLoaded():Boolean
        {
            return __isLoaded;
        }
        public static function set isLoaded(f:Boolean):void
        {
            __isLoaded = f;
        }

        public static function get urlProfoundHash():String
        {
            return __urlProfoundHash;
        }

        public static function set urlProfoundHash(hash:String):void
        {
            log.writeLog(log.LV_FATAL, "static Profound","set url profound hash", hash);
            __urlProfoundHash = hash;
        }

        public static function get urlProfound():Profound
        {
            var ret:Profound = getProfoundForHash(__urlProfoundHash);
            // パラメータを初期化させてしまう
            __urlProfoundHash = "";
            return ret;
        }

        public static function set urlErrorId(id:int):void
        {
            __urlErrorId = id;
        }
        public static function get urlErrorId():int
        {
            return __urlErrorId;
        }

        public static function getSortList(type:int):Array
        {
            log.writeLog(log.LV_DEBUG, "Profound","getSortList !!!!.",__sortItems.length,__items.length);

            if (__sortItems.length <= 0||type != __sortType) {
                sortItems(type);
            }

            return __sortItems;
        }
        public static function getSortListLength(type:int):int
        {
            log.writeLog(log.LV_DEBUG, "Profound","getSortList !!!!.",__sortItems.length,__items.length);

            if (__sortItems.length > 0 && type == __sortType) {
                return __sortItems.length;
            }

            sortItems(type);
            return __sortItems.length;
        }
        private static function sortItems(type:int):void
        {
            __sortItems = [];

            for(var i:int = 0; i < __items.length; i++) {
                if ( __items[i].state != PRF_ST_VANISH && __items[i].state != PRF_ST_VANISH_DEFEAT) {
                    __sortItems.push(__items[i]);
                }
            }
            log.writeLog(log.LV_DEBUG, "Profound","getSortList !!!!!!!!!!!!!!!!!!!.",__sortItems.length,__items.length);

            switch (type)
            {
            case PRF_SORT_TIME:
                __sortItems.sort(compareTime);
                break;
            case PRF_SORT_RARE:
                __sortItems.sort(compareRare);
                break;
            case PRF_SORT_FINDER:
                sortFinder();
                break;
            case PRF_SORT_ID:
            default:
                __sortItems.sortOn('id',Array.NUMERIC);
                break;
            }
        }
        private static function compareTime(x:Profound,y:Profound):Number
        {
            var ret:Number = 0;
            var now:Date = new Date();
            var xRest:Number = 0;
            var yRest:Number = 0;
            if (x.closeAt) {
                xRest = x.closeAt.getTime()-now.getTime();
            }
            if (y.closeAt) {
                yRest = y.closeAt.getTime()-now.getTime();
            }
            if (xRest == yRest) {
                if (x.id > y.id) {
                    ret = 1;
                } else {
                    ret = -1;
                }
            } else {
                if (xRest > yRest) {
                    ret = 1;
                } else {
                    ret = -1;
                }
            }
            return ret;
        }
        private static function compareRare(x:Profound,y:Profound):Number
        {
            var ret:Number = 0;
            if (x.rarity == y.rarity) {
                if (x.id > y.id) {
                    ret = 1;
                } else {
                    ret = -1;
                }
            } else {
                if (x.rarity > y.rarity) {
                    ret = 1;
                } else {
                    ret = -1;
                }
            }
            return ret;
        }
        private static function sortFinder():void
        {
            if (Player.instance&&Player.instance.avatar) {
                var avatarId:int = Player.instance.avatar.id;
                var findList:Array = [];
                var etcList:Array = [];
                for (var i:int = 0; i < __sortItems.length; i++) {
                    if (__sortItems[i].finderAvatarId == avatarId) {
                        findList.push(__sortItems[i]);
                    } else {
                        etcList.push(__sortItems[i]);
                    }
                }
                findList.sortOn('id',Array.NUMERIC);
                etcList.sortOn('id',Array.NUMERIC);
                __sortItems = [];
                __sortItems = findList.concat(etcList);
            }
        }

        // 情報更新時の状態
        public static function getResendStatus(prfId:int,state:int):int
        {
            var prf:Profound = getProfoundForId(prfId);

            // まだ追加がない場合、新規追加
            if (prf == null) return PRF_NEW;

            // 引数のStateが消失で、現在は消失前なら消失に更新
            if (state == PRF_ST_VANISH && prf.state != PRF_ST_VANISH ) return PRF_VANISH;
            if (state == PRF_ST_VANISH_DEFEAT && prf.state != PRF_ST_VANISH_DEFEAT ) return PRF_VANISH;

            // 引数のStateが終了で、現在は終了前なら終了に更新
            if (state == PRF_ST_FINISH && prf.state != PRF_ST_FINISH ) return PRF_FINISH;

            // 引数のStateが戦闘中で、現在は正体不明ならState更新
            if (state == PRF_ST_BATTLE && prf.state == PRF_ST_UNKNOWN ) return PRF_UPDATE;

            // それ以外は変化なし
            return PRF_NOT_CHANGE;
        }

        public static function getProfoundForId(id:int):Profound
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].id == id)
                {
                    return __items[i];
                }
            }
            return null;
        }

        public static function getProfoundForHash(hash:String):Profound
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].prfHash == hash)
                {
                    return __items[i];
                }
            }
            return null;
        }

        public static function getProfoundForMapId(mapId:int):Array
        {
            var ret:Array = [];
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].questMapId == mapId)
                {
                    ret.push(__items[i]);
                }
            }
            return (ret.length > 0) ? ret : null;
        }

        // 渦情報の追加
        public static function addProfound(prfId:int,prfDataId:int,prfHash:String,closeAt:String,createdAt:String,state:int,mapId:int,posIdx:int,copyType:int,setDefeatReward:Boolean,nowDamage:int,finderId:int,finderName:String):Profound
        {
            var prf:Profound = null;
            prf = getProfoundForId(prfId);

            __sortItems = []; // 更新が入るので、ソートリストをリセット

            // すでに追加済みの場合、closeAtとStateのみ更新して返す
            if (prf) {
                prf.state = state;
                prf.closeAtTime = closeAt;
                prf.createdAtTime = createdAt;
                prf.nowDamage = nowDamage;
                prf.viewDamage = nowDamage;
                return prf;
            }

            prf = new Profound(prfId,prfDataId,prfHash,closeAt,createdAt,state,mapId,posIdx,copyType,setDefeatReward,nowDamage,finderId,finderName);

            return prf;
        }

        // コンストラクタ
        public function Profound(prfId:int,prfDataId:int,prfHash:String,closeAt:String,createdAt:String,state:int,mapId:int,posIdx:int,copyType:int,setDefeatReward:Boolean,nowDamage:int,finderId:int,finderName:String)
        {
            log.writeLog(log.LV_FATAL, this,"const", prfId,prfDataId,prfHash,closeAt,state);
            _profoundData = ProfoundData.ID(prfDataId);
            _id = prfId;
            _prfDataId = prfDataId;
            _prfHash = prfHash;
            closeAtTime = closeAt;
            createdAtTime = createdAt;
            _state = state;
            _mapId = mapId;
            _posIdx = posIdx;
            _copyType = copyType;
            _setDefeatReward = setDefeatReward;
            _nowDamage = nowDamage;
            _viewDamage = nowDamage;
            _finderAvatarId = finderId;
            _finderName = finderName.replace("_rename","");
            __items.push(this);
            __items.sort();
        }

        // 消滅時間を設定
        public function set closeAtTime(closeAt:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"closeAtTime", _id,closeAt);
            if (closeAt != "")
            {
                _closeAtTime = new Date(closeAt);
                var str:String = TimeFormat.transDateStr(_closeAtTime);
                log.writeLog(log.LV_DEBUG, this,"closeAtTime 1", str, _closeAtTimeStr);
                if (_closeAtTimeStr != str) {
                    _closeAtTimeStr = str;
                    updateCloseAtWaitThread();
                }
            } else {
                _closeAtTime = null;
                _closeAtTimeStr = closeAt;
            }
        }
        // 開始時間を設定
        public function set createdAtTime(createdAt:String):void
        {
            if (createdAt != "")
            {
                _createdAtTime = new Date(createdAt);
                _createdAtTimeStr = TimeFormat.transDateStr(_createdAtTime);
            } else {
                _createdAtTime = null;
                _createdAtTimeStr = createdAt;
            }
        }

        // 渦データを取得
        public function get profoundData():ProfoundData
        {
            return _profoundData;
        }

        // 渦の名前取得
        public function get prfName():String
        {
            return _profoundData.name;
        }

        // ボスのID取得
        public function get bossId():int
        {
            return _profoundData.coreMonsterId;
        }

        // ボスキャラクターID
        public function get bossCharaId():int
        {
            var cc:CharaCard = CharaCard.ID(_profoundData.coreMonsterId);
            return (cc != null) ? cc.charactor :  1;
        }

        // ボスの名前取得
        public function get bossName():String
        {
            return _profoundData.coreMonsterName;
        }

        // 渦タイプ取得
        public function get prfType():int
        {
            return _profoundData.prfType;
        }
        // 渦のレアリティを取得
        public function get rarity():int
        {
            return _profoundData.rarity;
        }
        // 所属クエストIDを取得
        public function get questMapId():int
        {
            return _profoundData.questMapId;
        }

        // 渦データIDを取得
        public function get prfDataaId():int
        {
            return _prfDataId;
        }
        // 渦Hashを取得
        public function get prfHash():String
        {
            return _prfHash;
        }
        // 消滅時間を取得
        public function get closeAt():Date
        {
            return _closeAtTime;
        }
        // 消滅時間を取得:String
        public function get closeAtStr():String
        {
            return _closeAtTimeStr;
        }
        // 消滅までの残り時間のゲッター
        public function get closeAtRestTime():Number
        {
            var ret:Number =0;

            if (_closeAtTime != null)
            {
                var now:Date = new Date();
                ret = _closeAtTime.getTime()-now.getTime();
            }
            if (ret<0)
            {
                return 0;
            }else{
                return ret;
            }
        }
        // 開始時間を取得
        public function get createdAt():Date
        {
            return _createdAtTime;
        }
        // 開始時間を取得:String
        public function get createdAtStr():String
        {
            return _createdAtTimeStr;
        }
        // 状態を設定
        public function set state(s:int):void
        {
            _state = s;
        }
        // 状態を取得
        public function get state():int
        {
            return _state;
        }
        // 配置マップID取得
        public function get mapId():int
        {
            return _mapId;
        }
        // 配置インデックスを取得
        public function get posIdx():int
        {
            return _posIdx;
        }

        // 消滅間近か判定
        public function get isNearClosed():Boolean
        {
            if (_closeAtTime) {
                var now:Date = new Date();
                var checkDate:Date = new Date();
                checkDate.setTime(_closeAtTime.getTime() - LIMIT_ALERT_TIME);
                return now.time > checkDate.time;
            } else {
                return  true;
            }
        }

        // 消滅までの待機Thread初期化
        public function updateCloseAtWaitThread():void
        {
            log.writeLog(log.LV_DEBUG, this,"updateCloseAtWaitThread.",closeAtRestTime,_closeAtTime);
            if (closeAtRestTime > 0)
            {
                // 待ちThreadを起動させる
                var now:Date = new Date();
                var delay:int = _closeAtTime.getTime() - now.getTime();
                if (_waitThread != null && _waitThread.state != ThreadState.TERMINATED)
                {
                    _waitThread.interrupt();
                }
                // 待ち時間に多少追加しておく
                _waitThread = new WaitThread(delay+4500, closedCheck);
                _waitThread.start();

            } else {
                if (_waitThread != null && _waitThread.state != ThreadState.TERMINATED)
                {
                    _waitThread.interrupt();
                }
                if (_closeAtTime)
                {
                    log.writeLog(log.LV_DEBUG, this,"updateCloseAtWaitThread vanish check.");

                    // 更新されるのでリセットしておく
                    __sortItems = [];

                    // 消滅チェック
                    _ctrl.checkVanishProfound(id);
                }
                _closeAtTime = null;
            }
        }

        // 消滅チェック
        public function closedCheck():void
        {
            log.writeLog(log.LV_DEBUG, this,"closedCheck vanish check.");
            // 消滅したかチェックする
            updateCloseAtWaitThread();
        }

        // 現在HPを設定
        public function set nowDamage(d:int):void
        {
            _nowDamage = d;
        }
        // 現在HPを取得
        public function get nowDamage():int
        {
            return _nowDamage;
        }
        // 表示用HPを設定
        public function set viewDamage(d:int):void
        {
            _viewDamage = d;
        }
        // 表示用HPを取得
        public function get viewDamage():int
        {
            return _viewDamage;
        }
        // 発見者AvatarIDを取得
        public function get finderAvatarId():int
        {
            return _finderAvatarId;
        }
        // 発見者AvatarNameを取得
        public function get finderName():String
        {
            return _finderName;
        }
        // コピータイプを取得
        public function get copyType():int
        {
            return _copyType;
        }
        // コピータイプを設定
        public function set copyType(t:int):void
        {
            _copyType = t;
        }
        // 撃破報酬の有無を取得
        public function get setDefeatReward():Boolean
        {
            return _setDefeatReward;
        }
        // 撃破報酬の有無を設定
        public function set setDefeatReward(f:Boolean):void
        {
            _setDefeatReward = f;
        }

        // 終了チェック
        public function get isFinished():Boolean
        {
            return (_state == PRF_ST_FINISH);
        }
        // 消失チェック
        public function get isVanished():Boolean
        {
            return (_state == PRF_ST_VANISH||_state == PRF_ST_VANISH_DEFEAT);
        }

        // URLを取得
        public function get prfURL():String
        {
            return "";
        }

   }
}