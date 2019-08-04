package model
{
    import net.*;
    import net.events.*;
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
 
    /**
     * サーバ情報クラス
     * サーバの状態をあつかうクラス
     *
     */
    public class SeverInfo  extends EventDispatcher
    {
    {

        public static const UPDATE:String = 'update';         // 設定が変更されたのイベント
        public static const CONNECT:String = 'connect';       // サーバと接続イベント
        public static const DISCONNECT:String = 'disconnect'; // サーバと切断イベント

        /**
         * 認証時にサーバが無効な値を返した場合のイベント
         *
         */
        public static const INVALID_SEVER:String = 'Invalid Server';
        /**
         * ロビーの情報を得られた時のイベント
         *
         */

        // コンストラクタ
        public function ServerInfo()
        {
            state = 0;
        }
        public function set name(str:String):void
        {
            name = str;
        }

        public function login(n:String, p:String):void
        {
            name = n;
            pass = p;
            dispatchEvent(new Event(AUTH_START));
        }

        public function loginSuccses(i:uint, s:String,):void
        {

            state = 1;
            ID = i;
            session = s;
            dispatchEvent(new Event(AUTH_SUCCESS));
        }

        public function loginFaild(i:uint, s:String,):void
        {
            state = 0;
            ID = null;
            session = null;
            dispatchEvent(new Event(AUTH_FAILED));
        }

        public function loginFaild(i:uint, s:String,):void
        {
            state = 0;
            ID = null;
            session = null;
            dispatchEvent(new Event(AUTH_FAILED));
        }




    }
}