package model
{
//    import net.*;
//    import net.events.*;

    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.ErrorEvent;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.external.*;

    /**
     * プレイヤークラス
     * プレイヤーの情報を扱う
     *
     */
    public class Player  extends EventDispatcher
    {
        /**
         * 認証スタート
         *
         */
        public static const AUTH_START:String = 'auth_start';
        /**
         * 認証に成功
         *
         */
        public static const AUTH_SUCCESS:String = 'auth_success';
        /**
         * 認証に失敗
         *
         */
        public static const AUTH_FAILED:String = 'auth_failed';
        /**
         * 未認証
         *
         */
        public static const AUTH_NOT_REGIST:String = 'auth_not_regist';
        /**
         * 登録スタート
         *
         */
        public static const REGIST_START:String = 'regist_start';
        /**
         * 登録成功
         *
         */
        public static const REGIST_SUCCESS:String = 'regist_success'; // ログインに成功
        /**
         * 登録失敗
         *
         */
        public static const REGIST_FAILED:String = 'regist_failed';
        /**
         * 登録失敗
         *
         */
        public static const AVATAR_REGIST_FAILED:String = 'avatar_regist_failed';
        /**
         * ログアウト
         *
         */
        public static const LOGOUT:String = 'logout';   // ログアウト

        /**
         * 状態の変化
         *
         */
        public static const CHANGE_STATE:String = 'change_state';

        CONFIG::LOCALE_JP
        private static const _TRANS_INVITE_ERROR	:String = "無効な招待コードです";

        CONFIG::LOCALE_EN
        private static const _TRANS_INVITE_ERROR	:String = "Invite code error";

        CONFIG::LOCALE_TCN
        private static const _TRANS_INVITE_ERROR	:String = "邀請Code error";

        CONFIG::LOCALE_SCN
        private static const _TRANS_INVITE_ERROR	:String = "邀请Code error";

        CONFIG::LOCALE_KR
        private static const _TRANS_INVITE_ERROR	:String = "초대 code error";

        CONFIG::LOCALE_FR
        private static const _TRANS_INVITE_ERROR	:String = "InvitationCodeError";

        CONFIG::LOCALE_ID
        private static const _TRANS_INVITE_ERROR	:String = "招待Code Error";

        CONFIG::LOCALE_TH
        private static const _TRANS_INVITE_ERROR  :String = "ชวนเพื่อน code error";




        public static const STATE_TITLE:int    = 0;
        public static const STATE_LOGIN:int    = 1;
        public static const STATE_REGIST:int   = 2;
        public static const STATE_LOBBY:int    = 3;
        public static const STATE_GAME:int     = 4;
        public static const STATE_EDIT:int     = 5;
        public static const STATE_OPTION:int   = 6;
        public static const STATE_ITEM:int     = 7;
        public static const STATE_SHOP:int     = 8;
        public static const STATE_QUEST:int    = 9;
        public static const STATE_TUTORIAL:int = 10;
        public static const STATE_LOT:int      = 11;
        public static const STATE_LIBRARY:int  = 12;
        public static const STATE_RAID:int     = 13;
        public static const STATE_LOGOUT:int   = 100;

        private static var __instance:Player; // プレイヤーのシングルトンインスタンス

        public var pass:String;      // パスワード
        public var email:String;     // パスワード
        public var _state:int;        // 現在の状態 0 LO、 1:LI
        public var id:uint;          // ID
        public var avatar:Avatar;    // アバター
        public var friendList:Array; // フレンドリスト
        public var joined:Boolean;

        private var _name:String;    // プレイヤネーム
        private var _session:String; // セッションID
        private var _invitedCode:String = ""; // 招待コード


        /**
         * シングルトンインスタンスを返すクラス関数
         *
         *
         */
        public static function get instance():Player
        {
            if( __instance == null )
            {
                __instance = createInstance();
            }
            return __instance;
        }

        // 本当のコンストラクタ
        private static function createInstance():Player
        {
            return new Player(arguments.callee);
        }


        /**
         * コンストラクタ
         * シングルトンなので外から呼び出すと例外
         *
         */
        public function Player(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            state = STATE_TITLE;
            log.writeLog (log.LV_INFO,this,"create new player instance.");
        }

        /**
         * Nameのセッター
         *
         */
        public function set name(str:String):void
        {
            _name = str;
            ExternalInterface.call("setUnlightAvatarName", _name);
        }

        /**
         * Nameのゲッター
         *
         */
        public function get name():String
        {
            return _name;
        }

        /**
         * Nameのセッター
         *
         */
        public function set invitedCode(str:String):void
        {
            _invitedCode = str;
        }

        /**
         * Nameのゲッター
         *
         */
        public function get invitedCode():String
        {
            return _invitedCode;
        }

        /**
         * Sessionのゲッター
         *
         */
        public function get session():String
        {
            return _session;
        }

        /**
         * Stateのセッター
         *
         */
        public function set state(i:int):void
        {
            _state = i;
            dispatchEvent(new Event(CHANGE_STATE));
        }

        /**
         * Stateのゲッター
         *
         */
        public function get state():int
        {
            return _state;
        }


        /**
         * プレイヤーのログイン
         *
         */
        public function login(n:String, p:String):void
        {
            _name = n;
            pass = p;
            dispatchEvent(new Event(AUTH_START));
            log.writeLog (log.LV_DEBUG,this,"Login  ",n,p);
        }

        /**
         * プレイヤーの新規登録
         *
         */
        public function regist(n:String, e:String, p:String):void
        {
            _name = n;
            pass = p;
            email = e;
            dispatchEvent(new Event(REGIST_START));
            log.writeLog (log.LV_DEBUG,this,"Regist  ",n,p,e);
        }

        /**
         * ログインの成功
         * @param i ID
         *
         */
        public function loginSuccess(i:uint, session:String):void
        {
            state = STATE_LOGIN;
            Unlight.RELOAD_COUNT ++;
            id = i;
            _session = session;
            dispatchEvent(new Event(AUTH_SUCCESS));
            // getInviteID();
        }
        public function getInviteID():String
        {
            var ret:String = "";
            var i1:int = id % 10; // 
            var i2:int = id % 3;  // 

            var top:String = Const.INVITE_IDX[ i2 * 10 + i1];
            var r:Array = [];
            ret = id.toString();
            var t:Array = ret.split("");
            for (var i:int; i < 8; i++)
            {
                r[i] = 0;
            }
            var ii:int = 7;
            for (i = t.length -1 ; i > -1; i--)
            {
                r[ii] = t[i];
                ii -= 1;
            }

            for (var j:int; j < 8; j++)
            {
                r[j] = Const.INVITE_REMAP[j][r[j]];
                r[j] = Const.INVITE_SHF2[i2][r[j]];
                r[j] = Const.INVITE_SHF1[i1][r[j]];
            }
            ret = r.join("");
            ret = top + ret;
            log.writeLog(log.LV_TEST, this,"INVITE CODE IS ",ret);
            // getInviteIDToPID(ret);
            return ret;
        }

        public function get invitedPID():int
        {
            return getInviteIDToPID(_invitedCode);
        }

        public function getInviteIDToPID(pid:String):int
        {
            if (pid.length < 1)
            {
                return -1;
            }
            var s:Array = pid.split("");
            var ret:String;
            var ix:int;
            var i1:int;
            var i2:int;
            var i1v:int;
            var i2v:int;
            var r:Array = [];
            var invite_id:int;
            ix = Const.INVITE_IDX.indexOf(s.shift());
            i1 = (ix%10);
            i2 = (ix/10);
            for (var i:int; i < 8; i++)
            {
                r[i] = Const.INVITE_REMAP[i].indexOf(Const.INVITE_SHF2[i2].indexOf(Const.INVITE_SHF1[i1].indexOf(s[i])))
            }
            ret = r.join("");
            log.writeLog(log.LV_TEST, this,"INVITE ID IS ",ret);
            invite_id = parseInt(ret)
            log.writeLog(log.LV_TEST, this,"INVITE ID IS ",invite_id);
            i1v = invite_id % 10;
            i2v = invite_id % 3;
            if (i1v != i1 ||i2v != i2||invite_id == -1 || invite_id == id )
            {
                Alerter.showWithSize(_TRANS_INVITE_ERROR, "Invite code error");
                invite_id = -1;
            }
            return invite_id;
        }

        


        /**
         * ログインの失敗
         *
         */
        public function loginFailed():void
        {
            log.writeLog(log.LV_TEST, this,"login Fail ");
            state = STATE_TITLE;
            id = 0;
            _session = null;
            dispatchEvent(new Event(AUTH_FAILED));
        }

        /**
         * 登録の成功
         *
         */
        public function registSuccess():void
        {
            log.writeLog(log.LV_TEST, this,"regist success ");
            dispatchEvent(new Event(REGIST_SUCCESS));
        }

        /**
         * 登録の失敗
         *
         */
        public function registFailed(msg:String):void
        {
            dispatchEvent(new ErrorEvent(REGIST_FAILED, false, false, msg));
        }

        /**
         * 未踏登録の失敗
         *
         */
        public function notRegist():void
        {
            log.writeLog(log.LV_INFO, this,"not regist ");
            dispatchEvent(new Event(AUTH_NOT_REGIST));
        }

        /**
         * ログアウト
         *
         */

        public function logout():void
        {
            state = STATE_TITLE;
            _session = '';
            dispatchEvent(new Event(LOGOUT));
        }

    }
}

{
    {

    }
}

