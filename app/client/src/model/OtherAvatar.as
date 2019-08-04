package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    import org.libspark.thread.Thread;

    import net.*;

    import model.utils.*;

    /**
     * アバタークラス
     *
     *
     */
    public class OtherAvatar  extends BaseModel implements IAvatarParts
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "未登録";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Unregistered";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "未登錄";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "未登陆";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "미등록";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Non inscrit";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "未登録";

        CONFIG::LOCALE_TH
        private static const _TRANS :String = "ยังไม่ได้ลงทะเบียน";


        public static const INIT:String = 'init';             // 情報をロード
        public static const UPDATE:String = 'update';         // 情報をロード
        public static const UPDATE_NUM:String = 'update_num'; // 情報をロード
        private static var __loader:Function;                 // パラムを読み込む関数
        private static var __avatars:Object ={};              // ロード済みのアバター
        private static var __loadings:Object ={};             // ロード中のカード

        private var _name:String;                      // アバター名
        private var _level:int;                        // レベル
        private var _partsSet:Array;                   /* of AvatarPart */
        private var _battlePoint:int;                   // BP
        private var _isMyAvatar:Boolean = false;        // 自分のアバターか

//        private var _version:int;                      // 変更バージョン

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
            OtherAvatar.getBlankAvatar(); // ブランクだけは速攻で作る

        }

        private static function getData(id:int):void
        {
            if (__loader == null)
            {
                throw new Error("Warning: Loader is undefined.");
            }else{
                __loadings[id] = true;
                new LoaderThread(__loader, OtherAvatar.ID(id)).start();
            }
        }

        // IDのOtherAvatarインスタンスを返す
        public static function ID(id:int):OtherAvatar
        {
            if (__avatars[id] == null)
            {
                log.writeLog(log.LV_INFO, "static OtherAvatar" ," not loading get id",id, __avatars[id]);
                __avatars[id] = new OtherAvatar(id);
                getData(id);
            }else{
                // ロード済みでもローディング中でもないなら読む
                if (!(__avatars[id].loaded || __loadings[id]))
                {
                    getData(id);
                    log.writeLog(log.LV_INFO, "static OtherAvatar" ,"repeat loading get id",id, __avatars[id]);
//                    log.writeLog(log.LV_INFO, "static OtherAvatar" ,"repeat loading get id",id, __loadings[id]);
                }
            }
            return __avatars[id];
        }

        // ローダがOtherAvatarのパラメータを更新する
        public static function updateParam(id:int,  name:String, level:int, partsSet:Array, bp:int, cache:Boolean=false):void
        {

            log.writeLog(log.LV_INFO, "static OtherAvatar" ,"update id",id, name, level, partsSet);

            if (__avatars[id] == null)
            {
                __avatars[id] = new OtherAvatar(id);
            }
            __avatars[id]._id            = id;
            __avatars[id]._name          = name.replace("_rename","");
            __avatars[id]._level         = level;
            __avatars[id]._partsSet         = [];
            __avatars[id]._battlePoint         = bp;
            if (name == Player.instance.avatar.name)
            {
                __avatars[id]._isMyAvatar = true;
            }


            partsSet.forEach(function(item:*, index:int, array:Array):void{__avatars[id]._partsSet.push(AvatarPart.ID(item))});
            __avatars[id]._partsSet.sort(sortByPartsType);

            if (__avatars[id]._loaded)
            {
                __avatars[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static OtherAvatar" ,"load update",id,__avatars[id]._loaded);
            }
            else
            {
                __avatars[id]._loaded  = true;
                __avatars[id].notifyAll();
                __avatars[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static OtherAvatar" ,"load init",id,__avatars  [id]);
            }
            __loadings[id] = false;

        }

        private static function sortByPartsType(a:AvatarPart,b:AvatarPart):int
        {
            if (a.type > b.type)
            {
                return -1;
            }
            else if (a.type < b.type)
            {
                return 1;
            }
            else
            {
                return 0;
            }

        }

        // 相手用のブランクカード
        public static function getBlankAvatar():OtherAvatar
        {
            if (__avatars[0] == null)
            {
                var ac:OtherAvatar = new OtherAvatar(0);
//                ac._name          = "未登録";
                ac._name          = _TRANS;
                ac._level         = 0;
                ac._partsSet         = [];
                ac._loaded = true;
                ac._battlePoint = 0;

                __avatars[0]  = ac;
            }
            return __avatars[0];
        }


        // コンストラクタ
        public function OtherAvatar(id:int)
        {
            _id = id;
        }

        // 名前のゲッター
        public function get name():String
        {
            return _name;
        }

        // レベルのゲッター
        public function get level():int
        {
            return _level;
        }

        // パーツセットのゲッター
        public function get partsSet():Array
        {
            return _partsSet;
        }

        // レベルのゲッター
        public function get battlePoint():int
        {
            return _battlePoint;
        }

        public function getLoader():Thread
        {
            log.writeLog(log.LV_WARN, this ,"getLoader",_id);
            if (!(__avatars[id].loaded || __loadings[id]))
            {
                return new LoaderThread(__loader, OtherAvatar.ID(id));
            }else{
                return new ModelWaitThread(OtherAvatar.ID(id));
            }

        }
        public function getEquipedParts():Array
        {
            if(_isMyAvatar)
            {
                return Player.instance.avatar.getEquipedParts()
            }else{
                return partsSet;
            }
        }
        public function getWaitEquipedPartsDataThread():Thread
        {
            log.writeLog(log.LV_WARN, this ,"getEquepLoader",_id);
            if(_isMyAvatar)
            {
                return Player.instance.avatar.getWaitEquipedPartsDataThread();

            }else{

                if (!(__avatars[id].loaded || __loadings[id]))
                {
                    return getLoader();
                }else{
                    return new ModelWaitThread(OtherAvatar.ID(id));
                }
            }
        }


    }
}

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import model.*;
import model.Feat;
import model.utils.ReLoaderThread;

// OtherAvatarのロードを待つスレッド
class LoaderThread extends ReLoaderThread
{
    private var  _oa:OtherAvatar;

    public function LoaderThread(func:Function, oa:OtherAvatar)
    {
        log.writeLog(log.LV_WARN, this ,"loader start OtherAvatar",oa.id);
        _oa =oa;
        super(func, oa,1000*100)
    }


    protected override function run():void
    {
        if (_bm.loaded)
        {
            next(avatarPartLoad);
        }else{
            _loader(_bm.id);
            next(waitingTimer);
        }
    }

    private function check():void
    {
        if (_time < Const.RELOAD_LIMIT)
        {
            _time +=1;
            next(reload);
        }else{
            return;
//            next(avatarPartLoad)
        }
    }


    protected override function reload():void
    {
        if (_bm.loaded == false)
        {
            _loader(_bm.id);
            next(waitingTimer);
            log.writeLog(log.LV_WARN, this ,"load Fail ReLoad!! otherAvatar",_bm,_reloadSec);
//            log.writeLog(log.LV_WARN, "model" ,"load Fail ReLoad!!",_bm);
        }else{
            next(avatarPartLoad);
        }
    }


    private function avatarPartLoad ():void
    {
        var pExec:ParallelExecutor = new ParallelExecutor();

//        log.writeLog(log.LV_FATAL, this, "avatar parts reloaddddd");
        for(var i:int = 0; i < _oa.partsSet.length; i++)
        {
            var x:AvatarPart = _oa.partsSet[i];
            pExec.addThread(x.getLoader());
        }
        pExec.start();
        pExec.join();
        next(close);
    }

    private function close ():void
    {
//        log.writeLog(log.LV_FATAL, this, "avatar parts reloaddddd close");
    }
}
class ModelWaitThread extends Thread
{
        private var _m:BaseModel;

        public function ModelWaitThread(m:BaseModel)
        {
            _m = m;

        }

        protected override function run():void
        {
//            log.writeLog(log.LV_INFO, this, "run?");
            if (_m.loaded == false)
            {
                log.writeLog(log.LV_INFO, this, "waiting?",_m,_m.id);
                _m.wait();
            }
            next(callFunc);
        }

        private function callFunc():void
        {

        }
}

