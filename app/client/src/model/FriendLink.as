package model
{
//     import net.*;
    import flash.events.*;
    import flash.utils.ByteArray;
    import controller.*;
    import net.server.DataServer;

    // import flash.events.*;
    // import org.libspark.thread.Thread;
    // import flash.utils.ByteArray;

    import model.utils.*;

    /**
     * アバターアイテムクラス
     * 情報を扱う
     *
     */
    public class FriendLink extends BaseModel
    {
        public static const TYPE_CONFIRM:int = 0;
        public static const TYPE_FRIEND:int = 1;
        public static const TYPE_BLOCK:int = 2;
        public static const UPDATE_INTERVAL:int = 1000*60*5; // 5分
        public static const FRIEND_LIST_MAX:int = 3000;


        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_FRIEND	:String = "モバ友";
        CONFIG::LOCALE_JP
        private static const _TRANS_REQ		:String = "認証願い";
        CONFIG::LOCALE_JP
        private static const _TRANS_BAN		:String = "禁止";

        CONFIG::LOCALE_EN
        private static const _TRANS_FRIEND	:String = "Friends";
        CONFIG::LOCALE_EN
        private static const _TRANS_REQ		:String = "Authentication Request";
        CONFIG::LOCALE_EN
        private static const _TRANS_BAN		:String = "Prohibited";

        CONFIG::LOCALE_TCN
        private static const _TRANS_FRIEND	:String = "好友";
        CONFIG::LOCALE_TCN
        private static const _TRANS_REQ		:String = "請求認證";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BAN		:String = "禁止";

        CONFIG::LOCALE_SCN
        private static const _TRANS_FRIEND	:String = "好友";
        CONFIG::LOCALE_SCN
        private static const _TRANS_REQ		:String = "验证请求";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BAN		:String = "禁止";

        CONFIG::LOCALE_KR
        private static const _TRANS_FRIEND	:String = "모바일 친구";
        CONFIG::LOCALE_KR
        private static const _TRANS_REQ		:String = "인증 요청";
        CONFIG::LOCALE_KR
        private static const _TRANS_BAN		:String = "금지";

        CONFIG::LOCALE_FR
        private static const _TRANS_FRIEND	:String = "Friend";
        CONFIG::LOCALE_FR
        private static const _TRANS_REQ		:String = "Demande d'autorisation";
        CONFIG::LOCALE_FR
        private static const _TRANS_BAN		:String = "Interdit";

        CONFIG::LOCALE_ID
        private static const _TRANS_FRIEND	:String = "モバ友";
        CONFIG::LOCALE_ID
        private static const _TRANS_REQ		:String = "認証願い";
        CONFIG::LOCALE_ID
        private static const _TRANS_BAN		:String = "禁止";

        CONFIG::LOCALE_TH
        private static const _TRANS_FRIEND  :String = "Friend";
        CONFIG::LOCALE_TH
        private static const _TRANS_REQ     :String = "กรุณาตอบตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_BAN     :String = "ห้าม";


        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード

        private static var __loader:Function;         // パラムを読み込む関数
//        private static var __linkSet:Array =[];        // フレンドリンクのセット(avatarIDがindex)
        private static var __linkSet:Object = new Object();        // フレンドリンクのセット(avatarIDがoropaete)
        private static var __snsSet:Object = new Object();        // フレンドリンクのセット(avatarIDがoropaete)
        private static var __blockSet:Object = new Object();
        private static var __myBlockSet:Object = new Object();    // しているセット
        private static var __blockNameList:Object; /* of String */
        private static var __myBlockNameList:Object; /* of String */

        private static var __friendNum:int = 0;
        private static var __blockNum:int = 0;
        private static var __requestNum:int = 0;
        private static var __linkList:Array = [new Array(FRIEND_LIST_MAX),new Array(FRIEND_LIST_MAX),new Array(FRIEND_LIST_MAX)];
        private static var __isSetSns:Boolean = false;
        private static var __dataLoaded:Array = [[],[],[]]; /* of Boolean */
        private static var __lastUpdateTime:int = 0;

//        private var _id           :int;      // 相手のプレイヤーID
        private var _avatarId     :int;      // 相手のアバターID
        private var _status       :int;      // 状態
        private var _uid          :String;   // ユーザID（name）
        private var _avatarData   :OtherAvatar;   // アバターデータ
        private var _nickName     :String = "";   // ユーザnickname

        // アイテムの種類定数
//        public static const LINK_TYPE:Array = ["Mates", "モバ友", "認証願い", "禁止"];
        public static const LINK_TYPE:Array = ["Mates", _TRANS_REQ, _TRANS_BAN];


        // FriendListの状態
        public static const   FR_ST_OTHER_CONFIRM:int = 0;             // 相手の認証待ち
        public static const   FR_ST_MINE_CONFIRM:int  = 1;             // 自分の認証待ち
        public static const   FR_ST_FRIEND:int        = 2;             // フレンド
        public static const   FR_ST_BLOCK:int         = 3;             // ブロックしている
        public static const   FR_ST_BLOCKED:int       = 4;             // ブロックされている
        public static const   FR_ST_ONLY_SNS:int      = 5;             // SNS上の友人
        public static const   FR_ST_FRIEND_LOGIN:int  = 6;             // 友人かつログイン中
        public static const   FR_ST_SEARCH:int        = 7;             // 検索結果
        public static const   FR_ST_DELETED:int       = 8;            // 削除ずみ

        public static function getLink(avId:int):FriendLink
        {
            return __linkSet[avId];
        }

        public static function isFriend(avId:int):Boolean
        {
            var ret:Boolean = false;

            if (__linkSet[avId] !=null)
            {
                if (__linkSet[avId].status == FR_ST_FRIEND||__linkSet[avId].status == FR_ST_FRIEND_LOGIN)
                {
                    ret =  true;
                }
            }
            return ret;
        }

        public static function setFriendNum(num:int):void
        {
            __friendNum = num;
        }
        public static function setBlockNum(num:int):void
        {
            __blockNum = num;
        }
        public static function setRequestNum(num:int):void
        {
            __requestNum = num;
        }
        public static function getFriendNum():int
        {
            return __friendNum;
        }
        public static function getBlockNum():int
        {
            return __blockNum;
        }
        public static function getRequestNum():int
        {
            return __requestNum;
        }


        public static function getLinkList(type:int,offset:int=0,count:int=0):Array
        {
            // ロード済み課のデータがないときはfalse
            if (__dataLoaded[type][offset] == null)
            {
                __dataLoaded[type][offset] = false;
            }
            // ロードされてないならロード
            if(!__dataLoaded[type][offset])
            {
                DataCtrl.instance.requestFriendList(type,offset, count);
                __dataLoaded[type][offset] = true;
            }else{
                // ロードされているなら時間経過をチェックする
                var d:Date = new Date();
                var now:int= d.getTime();
                if (__lastUpdateTime == 0 || ((now - __lastUpdateTime) > UPDATE_INTERVAL))
                {
                    log.writeLog(log.LV_DEBUG, "FriendLink getLinkList");
                    __dataLoaded[type] = [];
                    __linkList[type] = new Array(FRIEND_LIST_MAX);
                    __lastUpdateTime = now;
                    DataCtrl.instance.requestFriendList(type,offset,count);
                    __dataLoaded[type][offset] = true;
                }else{

                };
            }
            var ret:Array = [];
            for (var i:int = 0;i < count; i++) {
                if (__linkList[type][i+offset] != null) {
                    ret.push(__linkSet[__linkList[type][i+offset]]);
                }
            }

            return ret;
        }

        public static function updateBlockList():void
        {
            DataCtrl.instance.requestFriendList(TYPE_BLOCK, 0, 10);
        }

        public static function getLinkSet():Object
        {
//            return __linkSet.filter(isLink);
            return __linkSet;
        }

//         private static  function isLink(element:*, index:int, arr:Array):Boolean
//         {
//             return element != null;
//         }


        public static function setLink(ids:String, avIds:String, stSet:String,uids:String,type:int,offset:int=0):void
        {
            log.writeLog(log.LV_WARN, "FriendLink setLink",ids ,avIds,stSet,uids);

            // __linkSet = new Object();
            // __blockSet = new Object()
            // clearBlockNameList();

            // if (! __isSetSns) {
            //     log.writeLog(log.LV_WARN, "FriendLink setLink",ids ,avIds,stSet,uids);
            //     for (var keyy:Object in __snsSet) {
            //         log.writeLog(log.LV_WARN, "snsSet keyy", keyy, __snsSet[keyy]);
            //         __linkSet[keyy] = __snsSet[keyy];
            //     }
            // }

//             __linkSet = UtilFunctions.clone(__snsSet);

            var idSet:Array = ids.split(",");
            var avIdSet:Array = avIds.split(",");
            var statusSet:Array = stSet.split(",");
            var idSetCount:Array = ids.split(",");
            var uidSet:Array = uids.split(",");

            for ( var i:int = 0; i < idSet.length; i++) {
                log.writeLog(log.LV_DEBUG, "FriendLink setLink",avIdSet[i]);
                if (avIdSet[i]) {
                    if (__linkSet[avIdSet[i]] == null||__linkList[type][i+offset] == null) {
                        __linkList[type][i+offset] = avIdSet[i];
                        __linkSet[avIdSet[i]] = addFriendLink(idSet[i],avIdSet[i],statusSet[i],uidSet[i],type,i+offset);
                    }
                } else {
                    // avIDがない場合で、データが入ってるなら削除されているので、ステートを変更
                    if (__linkList[type][i+offset] != null) {
                        if (__linkSet[__linkList[type][i+offset]]) {
                            log.writeLog(log.LV_DEBUG, "FriendLink setLink only sns",__linkList[type][i+offset]);
                            __linkSet[__linkList[type][i+offset]].status = FR_ST_ONLY_SNS;
                        }
                    }
                }
            }

            // getSNSFriend();

//             for (var key:Object in __linkSet) {
//                 log.writeLog(log.LV_WARN, "FriendLink  key", key, __linkSet[key]);
//                 // 更新情報にavIDが無ければ削除されたのでSNSFriendに戻すあるならば新しいステートを入れる
//                 var i:int = avIdSet.indexOf(key);
//                 if (i == -1)
//                 {
//                     __linkSet[key].status = FR_ST_ONLY_SNS;
//                 }else{
//                     log.writeLog(log.LV_WARN, "create FriendLink ", idSet[i],avIdSet[i],statusSet[i],uidSet[i]);
//                     __linkSet[avIdSet[i]] = new FriendLink(idSet[i],avIdSet[i],statusSet[i],uidSet[i]);
//                     idSetCount.splice(i,1,-1)
//                 }

//             }
//             // SNSフレンドでないものも登録する（コレはテスト環境しか必要ないかも）
//             if (avIds != "")
//             {
//                 var num:int = idSetCount.length;
//                 for(var j:int = 0; j < num; j++)
//                 {
// //                    log.writeLog(log.LV_WARN, "FriendLink setLink",num,j );
//                     if (idSetCount[j]!=-1)
//                     {
//                         __linkSet[avIdSet[j]] = new FriendLink(idSet[j],avIdSet[j],statusSet[j],uidSet[j]);
//                     }
//                 }
//             }


        }

        public static function setSeachResult(avIds:String):void
        {
            clearSeachResult();
            var avIdSet:Array = avIds.split(",");
            __requestNum = avIdSet.length/2;
            for(var j:int = 0; j < avIdSet.length; j+=2)
            {
                if (__linkSet[avIdSet[j+1]] == null)
                {
                    __linkSet[avIdSet[j+1]] = new FriendLink(avIdSet[j],avIdSet[j+1],FR_ST_SEARCH);
                }
            }
        }

        public static function clearSeachResult():void
        {
            for (var key:Object in __linkSet) {
                if (__linkSet[key]._status == FR_ST_SEARCH)
                {
                    delete __linkSet[key];
                }
            }
        }

        private static function getSNSFriend():void
        {
        }

        public static function setSNSLink(uid:String, id:int, avId:int):void
        {
            log.writeLog(log.LV_WARN, "FriendLink setSNSLink",uid,id ,avId,__linkSet[avId]);
            if (__linkSet[avId] == null)
            {
                log.writeLog(log.LV_WARN, "FriendLink setSNSLink set!! ",uid,id ,avId);
                var fl:FriendLink = new FriendLink(id, avId, FR_ST_ONLY_SNS, uid);
                __linkSet[avId] = fl
                if (__snsSet[avId] == null)
                {
                    __snsSet[avId] = fl;
                    log.writeLog(log.LV_WARN, "FriendLink setSNSLink set!! ",__snsSet[avId]);
                }

            }else{
            }
        }

        public static function changeStatus(id:int,st:int):void
        {
            var beforeStatus:int = st;
            for (var key:Object in __linkSet) {
                if (__linkSet[key]._id == id)
                {
                    beforeStatus = __linkSet[key].status;
                    __linkSet[key].status = st;
                }
            }
            // 変更前と変更後のリストデータをリセット
            var flType:int = convertFlType(beforeStatus);
            if (flType != -1) {
                __linkList[flType] = new Array(FRIEND_LIST_MAX);
                __dataLoaded[flType] = [];
            }
            flType = convertFlType(st);
            if (flType != -1) {
                __linkList[flType] = new Array(FRIEND_LIST_MAX);
                __dataLoaded[flType] = [];
            }
        }

        // リンクステータスからフレンドタイプに変換
        private static function convertFlType(fType:int):int
        {
            var ret:int;
            switch (fType)
            {
            case FriendLink.FR_ST_OTHER_CONFIRM:
                ret = TYPE_CONFIRM;
                break;
            case FriendLink.FR_ST_MINE_CONFIRM:
                ret = TYPE_CONFIRM;
                break;
            case FriendLink.FR_ST_FRIEND:
                ret = TYPE_FRIEND;
                break;
            case FriendLink.FR_ST_BLOCK:
                ret = TYPE_BLOCK;
                break;
            case FriendLink.FR_ST_BLOCKED:
                ret = -1;
                break;
            case FriendLink.FR_ST_ONLY_SNS:
                ret = -1;
                break;
            case FriendLink.FR_ST_FRIEND_LOGIN:
                ret = TYPE_FRIEND;
                break;
            case FriendLink.FR_ST_SEARCH:
                ret = -1;
                break;
            default:
                ret = -1;
            }
            return ret;
        }


        public static function deleteLink(id:int):void
        {
//            log.writeLog(log.LV_FATAL, "FriendLink", "++, delete link",id);
            var deleteAvId:int = 0;

            for (var key:Object in __linkSet)
            {
                if (__linkSet[key]._id == id)
                {
                    deleteAvId = int(key);
                }
            }
            log.writeLog(log.LV_FATAL, "FriendLink", "++, delete link, delete avid ", deleteAvId);

            if (deleteAvId != 0)
            {

                delete __linkSet[deleteAvId];
            }


            if (deleteAvId != 0&&__blockSet[deleteAvId] != null)
            {
            log.writeLog(log.LV_FATAL, "FriendLink", "++, delete link, delete avid ", __blockSet[deleteAvId]);
                delete __blockSet[deleteAvId];
                clearBlockNameList();
            }

            // var i:int;
            // var delIdx:int = -1;
            // for (i = 0;i < __linkList.length; i++) {
            //     if (__linkList[i].avatarId == deleteAvId) {
            //         delIdx = i;
            //         break;
            //     }
            // }
            // if (delIdx != -1) {
            //     __linkList[i].splice(delIdx,1);
            // }
            var i:int;
            var delIdx:int = -1;
            log.writeLog(log.LV_FATAL, "FriendLink", "++, delete link, delete avid list",__linkList[TYPE_FRIEND].length);
            for (i = 0;i < __linkList[TYPE_FRIEND].length; i++) {
                if (__linkList[TYPE_FRIEND][i] == deleteAvId) {
                    delIdx = i;
                    break;
                }
            }
            if (delIdx != -1) {
                __linkList[TYPE_FRIEND].splice(delIdx,1);
                __linkList[TYPE_FRIEND].push(null);
            }
            delIdx = -1;
            log.writeLog(log.LV_FATAL, "FriendLink", "++, delete link, delete avid list",__linkList[TYPE_BLOCK].length);
            for (i = 0;i < __linkList[TYPE_BLOCK].length; i++) {
                if (__linkList[TYPE_BLOCK][i] == deleteAvId) {
                    delIdx = i;
                    break;
                }
            }
            if (delIdx != -1) {
                __linkList[TYPE_BLOCK].splice(delIdx,1);
                __linkList[TYPE_BLOCK].push(null);
            }
            delIdx = -1;
            log.writeLog(log.LV_FATAL, "FriendLink", "++, delete link, delete avid list",__linkList[TYPE_CONFIRM].length);
            for (i = 0;i < __linkList[TYPE_CONFIRM].length; i++) {
                if (__linkList[TYPE_CONFIRM][i] == deleteAvId) {
                    delIdx = i;
                    break;
                }
            }
            if (delIdx != -1) {
                __linkList[TYPE_CONFIRM].splice(delIdx,1);
                __linkList[TYPE_CONFIRM].push(null);
            }

            __lastUpdateTime = 0;

//             for (var key2:Object in __linkSet)
//             {
//                 log.writeLog(log.LV_FATAL, "FriendLink", "++, remain friend link  ", key2);
//             }
        }

        //
        public static function clearBlockNameList():void
        {
            __blockNameList = null
        }

        // ブロック中の名前リストを取る
        public static function getBlockNameList():Object
        {
            if (__blockNameList == null)
            {
                __blockNameList = new Object();
                var obj:Object = __blockSet;
                for (var key:Object in obj) {
                    if (Player.instance.avatar.name != obj[key].name)
                    {
                        __blockNameList[obj[key].name] = true;
                        log.writeLog(log.LV_INFO, "statci ", "block name is ",obj[key].name);
                    }
                }

            }
            return __blockNameList;
        }

        // 自分がブロック中の名前リストを取る
        public static function getMyBlockNameList():Object
        {
            if (__myBlockNameList == null)
            {
                __myBlockNameList = new Object();
                var obj:Object = __myBlockSet;
                for (var key:Object in obj) {
                    if (Player.instance.avatar.name != obj[key].name)
                    {
                        __myBlockNameList[obj[key].name] = true;
                    }
                }

            }
            return __myBlockNameList;
        }

        public static function addFriendLink(id:int, aid:int, st:int, snsID:String = "",type:int=0,index:int=0):FriendLink
        {
            var fl:FriendLink = new FriendLink(id,aid,st,snsID);
            return fl;
        }

        // コンストラクタ
        public function FriendLink(id:int, aid:int, st:int, snsID:String = "")
        {
            log.writeLog(log.LV_WARN, this, "Create FriendLink ",id ,"snsID",snsID);
            _id = id;
            _avatarId = aid;
            status = st;
            _uid = snsID;
        }

        public function set status(i:int):void
        {

            _status = i;
            // もし作られたリンクがブロックリンクならば、ブロックリストを更新する
            if (_status == FR_ST_BLOCK || _status == FR_ST_BLOCKED)
            {
                __blockSet[_avatarId] = OtherAvatar.ID(_avatarId);
                if (_status == FR_ST_BLOCK)
                {
                    __myBlockSet[_avatarId] = OtherAvatar.ID(_avatarId);
                }
                DataServer.instance.getOtherAvatarInfo(_avatarId);
                log.writeLog(log.LV_INFO, this, "friend link constractor", __blockSet[_avatarId]);
            }
        }

        public function get status():int
        {
            return _status;
        }

        public function get otherAvatar():OtherAvatar
        {
//           return _avatarData;
            return OtherAvatar.ID(avatarId);
        }
        public function get nickName():String
        {
                return _nickName;

        }
        public function get avatarId():int
        {
            return _avatarId;
        }
        public function get uid():String
        {
            return _uid;
        }

        public function get isBlock():Boolean
        {
            return (_status == FR_ST_BLOCK || _status == FR_ST_BLOCKED)
        }


        /**
         *  ディープコピーを行います.
         */
        public static function clone( arg:* ) :*
        {
            var myBA:ByteArray = new ByteArray();
            myBA.writeObject(arg);
            myBA.position = 0;
            return( myBA.readObject() );
        }






    }
}


import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

class UtilFunctions
{
    public static function newSibling(sourceObj:Object):* {
        if(sourceObj) {

            var objSibling:*;
            try {
                var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
                objSibling = new classOfSourceObj();
            }
            catch(e:Object) {}
            return objSibling;
        }
        return null;
    }

    public static function clone(source:Object):Object {
        var clone:Object;
        if(source) {
            clone = newSibling(source);
            if(clone) {
                copyData(source, clone);
            }
        }
        return clone;
    }

    public static function copyData(source:Object, destination:Object):void {
        //copies data from commonly named properties and getter/setter pairs
        if((source) && (destination)) {
            try {
                var sourceInfo:XML = describeType(source);
                var prop:XML;
                for each(prop in sourceInfo.variable) {
                        if(destination.hasOwnProperty(prop.@name)) {
                            destination[prop.@name] = source[prop.@name];
                        }
                    }
                for each(prop in sourceInfo.accessor) {
                        if(prop.@access == "readwrite") {
                            if(destination.hasOwnProperty(prop.@name)) {
                                destination[prop.@name] = source[prop.@name];
                            }
                        }
                    }
            }
            catch (err:Object) {
                ;
            }
        }
    }
}
