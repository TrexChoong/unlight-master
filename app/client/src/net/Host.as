package net
{
    import flash.utils.ByteArray;
    import flash.events.*;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;


    import net.*;
    import net.command.*;
/**
 * サーバとのメッセージを仲介するクラス
 * 個別のサーバコマンドクラスを差し替えて使用する
 */

    public class Host extends EventDispatcher
    {
//        public static const READY:String = 'ready';                     // 設定を読み終わって準備ＯＫ
        public static const BOT_SESSION:Boolean = false;
        public static const BOT_SESSION_KEY:String = "49c5de87eced403d533526afc6ef0cbe3993efcd";
        public static const HEART_BEAT:String = "heart_beat";
        public static const GAME_HEART_BEAT:String = "game_heart_beat";

        public static const HEART_BEAT_TIME:int = 180;                    // ソケット確保用の間隔（3分）
        public static const GAME_HEART_BEAT_TIME:int = 60;                // ゲーム関連ソケット確保用の間隔（1分）
        public static const HEART_BEAT_CONNECT_TIME:int = 3000;           // ソケットが生きているかの確認用の長期タイマー(50分)
        public static const RECONNCT_TIME:int = 10;                       // 切断時の再接続間隔
        public static const SERVER_OK:String = 'server_ok';               // サーバーとの交信可
        public static const SERVER_QUIT:String = 'server_quit';           // サーバの切断
        public static const SERVER_CONNECTED:String = 'server_connected'; // サーバとコネクト

        public static const CONNECT_CLOSED:int =-1 // サーバを切断している
        public static const CONNECT_NONE:int = 0   // コネクション未接続
        public static const CONNECT_NOT_AUTH:int = 1 // 未認証
        public static const CONNECT_AUTHED:int = 2   // 認証済み


        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_JP
        private static const _DISSCONET_NO_OPERATION	:String = "長時間操作が無かったためサーバからログアウトしました";

        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT	:String = "Warning";
        CONFIG::LOCALE_EN
        private static const _DISSCONET_NO_OPERATION	:String = "Logged out due to an extended period inactivity.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_TCN
        private static const _DISSCONET_NO_OPERATION	:String = "因長時間無操作的關係與伺服器的連線中斷。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_SCN
        private static const _DISSCONET_NO_OPERATION	:String = "由于长时间没有操作，已从服务器上退出。";

        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT	:String = "Attention";
        CONFIG::LOCALE_FR
        private static const _DISSCONET_NO_OPERATION	:String = "Vous avez été déconnecté car inactif.";

        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_ID
        private static const _DISSCONET_NO_OPERATION	:String = "長時間操作が無かったためサーバからログアウトしました";

        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT   :String = "คำเตือน";
        CONFIG::LOCALE_TH
        private static const _DISSCONET_NO_OPERATION    :String = "ถูกตัดออกจากเซฟเวอร์เนื่องจากไม่มีการเคลื่อนไหวเป็นเวลานาน";

//         CONFIG::LOCALE_EN
//         private static const _TRANS_ALERT	:String = "Warning";
//         CONFIG::LOCALE_EN
//         private static const _TRANS_MSG_CUTSV	:String = ": Server connection failed.";

//         CONFIG::LOCALE_TCN
//         private static const _TRANS_ALERT	:String = "警告";
//         CONFIG::LOCALE_TCN
//         private static const _TRANS_MSG_CUTSV	:String = "：無法跟服務器通信。";

//         CONFIG::LOCALE_KR
//         private static const _TRANS_ALERT	:String = "경고";
//         CONFIG::LOCALE_KR
//         private static const _TRANS_MSG_CUTSV	:String = "서버와의 통신이 절단되었습니다.";

//         CONFIG::LOCALE_FR
//         private static const _TRANS_ALERT	:String = "Attention";
//         CONFIG::LOCALE_FR
//         private static const _DISSCONET_NO_OPERATION	:String = "Vous avez été déconnecté car inactif";


        private var _socket:ULSocket;             // ソケット
        private var sessionKey:String;            // セッションID
        private var getedCommandArray:ByteArray;  // 受信したコマンド
        private var _reconnectTimer:Timer;        // 再接続用のタイマ
        private var _heartBeatTimer:Timer;        // ハートビート用のタイマー
        private var _gameHeartBeatTimer:Timer;    // ゲームハートビート用のタイマー
        private var _heartBeatConnectTimer:Timer; // コネクション確認用の長期タイマー
        private var _port:uint;
        private var _address:String;
        private var closed:Boolean = false;
        private var cmd:Command;

        private var _useGameHeartBeat:Boolean = false; // GameHeartBeatHandlerを使用するか

        /**
         * コンストラクタ
         * @param a 接続先のアドレス
         * @param p 接続先のポート番号
         * @param c 接続サーバの種類にあわせたコマンドクラス
         */
        public function Host()
        {
            createSocket();
            // 再接続用のタイマ
            _reconnectTimer = new Timer(RECONNCT_TIME*1000, 0);
            _heartBeatTimer = new Timer(HEART_BEAT_TIME*1000,0);
            _heartBeatTimer.addEventListener(TimerEvent.TIMER, heartBeatHandler);
            // サーバから見てコネクションが生きているかを確認するためのソケットKeepAliveTimer
            _heartBeatConnectTimer = new Timer(HEART_BEAT_CONNECT_TIME*1000,0)
            _heartBeatConnectTimer.addEventListener(TimerEvent.TIMER, heartBeatHandler);
            _heartBeatConnectTimer.start();
            // 個別のサーバコマンドクラスの保持

        }

        // アドレスとポートとコマンドを初期化
        public function init(a:String, p:uint, c:Command):void
        {
            _address = a;
            if (p == 0)
            {
                log.writeLog(log.LV_WARN, this,"Port number is 0.");
            }
            _port = p;
            cmd = c;
        }

        /**
         * 通信の開始
         */
        public function connect():void
        {
            sessionKey =null;
            log.writeLog(log.LV_DEBUG, this," Connect Start",_address,_port);
            _socket.connect(_address, _port);
            closed = false;
        }

        /**
         * 通信の中断(自ら切断)
         */
        public function close():void
        {
            if (_socket.connected)
            {
                log.writeLog(log.LV_DEBUG, this,"Self Close start");
                sessionKey =null;
                _socket.clearSessionKey();
                _socket.close();
                closed = true;
            }
        }

        // 再コネクト時ハンドラ
        private function reconnectHandler(e:TimerEvent):void
        {
            //イベントハンドラの解除（GC）
            _socket.removeEventListener(Event.CONNECT,socketConnectedHandler);
            _socket.removeEventListener(Event.CLOSE, serverCloseHandler);
            _socket.removeEventListener(ProgressEvent.SOCKET_DATA, getDataHandler);
            _socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socketSecurityErrorHandler);
            _socket.removeEventListener(IOErrorEvent.IO_ERROR, socketIOErrorHandler);
            // ソケットをつくる
            createSocket();
            _socket.connect(_address, _port);
        }

        private function createSocket():void
        {
            // ソケットをつくる
            _socket = new ULSocket();
            //イベントハンドラの登録を行う
            _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketSecurityErrorHandler);
            _socket.addEventListener(Event.CONNECT,socketConnectedHandler);
            _socket.addEventListener(Event.CLOSE, serverCloseHandler);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, getDataHandler);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, socketIOErrorHandler);
        }

        // 通信コネクト時ハンドラ
        private function socketConnectedHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "Connected! ",_address,_port);
            dispatchEvent(new Event(Host.SERVER_OK));
            _reconnectTimer.stop();
        }

        // セキュリティエラーハンドラ
        private function socketSecurityErrorHandler(e:Event):void
        {
            log.writeLog(log.LV_WARN, this,"Secrurity Error!",_address, _port);
        }

        // セキュリティエラーハンドラ
        private function socketIOErrorHandler(e:IOErrorEvent):void
        {
            log.writeLog(log.LV_WARN, this,"IO Error!",e.text,"port:",_port);
        }

        // サーバ切断時のイベントハンドラ(サーバからの)
        private function serverCloseHandler(event:Event):void
        {
            sessionKey =null;
            _socket.clearSessionKey();
            // イベントの送出
            dispatchEvent(new Event(Host.SERVER_QUIT));
            // 再接続用のタイマをスタート
            if (serverState() == 0)
            {
                _reconnectTimer.start();
                log.writeLog(log.LV_INFO, this, "Server Close & Start ReconnectTimer :", _port);
           }
        }

        // サーバとの受信ハンドラ
        private function getDataHandler(event:ProgressEvent):void
        {
//            log.writeLog(log.LV_DEBUG, this, "getDataHandler: " + event);
            cmd.receiveCommand(_socket.receive());
        }

        /**
         * サーバステータスを返す
         * @return 接続なし:-1,コネクトなし:0 ,認証なし:1,認証済み:2
         */
        public function serverState():int
        {
            var i:int;
            if (closed)
            {
                return CONNECT_CLOSED;
            }
            else
            {
                if (_socket.connected)
                {
                    if (sessionKey)
                    {
                        return CONNECT_AUTHED;
                    }
                    else
                    {
                        return CONNECT_NOT_AUTH;
                    }
                }
                else
                {
                    return CONNECT_NONE;
                }
            }
        }


        /**
         * 通信のセッションキーをセットして暗号化ＯＮにする
         * @param s セッションキー
         */
        public function setSessionKey(s:String):void
        {
            if (BOT_SESSION)
            {
            // ボット用セッション固定
                sessionKey = BOT_SESSION_KEY;
            }else{
                sessionKey = s;
            }
            _socket.setSessionKey(sessionKey);
        }

        /**
         * サーバにコマンドを送信
         * @para data 送信内容
         */
        public function sendCommand(data:ByteArray):void
        {
//            log.writeLog(log.LV_INFO, "Host.as", "sendCommand: ",data);
            _heartBeatTimer.reset();
            if (Unlight.live)
            {
                _socket.send(data);
            }
            _heartBeatTimer.start();
        }

        // ハートビート信号のハンドラ
        private function heartBeatHandler(event:Event):void
        {
            if (!_useGameHeartBeat) {
                //  サーバと繋がっていれば一定間隔でイベントを送る
                if (_socket.connected)
                {
                    if (Unlight.INS.opetationCheck())
                    {
                        Alerter.showWithSize(_DISSCONET_NO_OPERATION, _TRANS_ALERT, 4, null, Alerter.reloadWindow, 110);
                        close();
                    }else{
                        dispatchEvent(new Event(HEART_BEAT));
                    }
                }
            }
        }

        // ゲーム用ハートビート信号のハンドラ
        private function gameHeartBeatHandler(event:Event):void
        {
            //  サーバと繋がっていれば一定間隔でイベントを送る
            if (_socket.connected)
            {
                if (Unlight.INS.opetationCheck())
                {
                    Alerter.showWithSize(_DISSCONET_NO_OPERATION, _TRANS_ALERT, 4, null, Alerter.reloadWindow, 110);
                    close();
                }else{
                    dispatchEvent(new Event(GAME_HEART_BEAT));
                }
            }
        }

        // ゲーム用ハートビートの使用設定
        public function setUseGameHeartBeatFlag():void
        {
            _useGameHeartBeat = true;
            _gameHeartBeatTimer = new Timer(GAME_HEART_BEAT_TIME*1000,0);
            _gameHeartBeatTimer.addEventListener(TimerEvent.TIMER, gameHeartBeatHandler);
            _gameHeartBeatTimer.start();
        }


    }

}