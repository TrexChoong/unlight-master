package net.server
{
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.*;

    import net.*;
    import model.Player;
    import net.command.*;
    import view.*;
    import view.utils.*;
    import controller.*;
    import model.utils.ClientLog;

    /**
     * 認証サーバクラス
     * 認証サーバとの通信を行い、コマンドを実行する
     *
     */
    public class AuthServer extends Server
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_INVALID	:String = "「メールアドレスが無効です」";
        CONFIG::LOCALE_JP
        private static const _TRANS_RETRY	:String = "サーバとの通信が無効です。更新ボタンを押してから再度登録してみてください。";
        CONFIG::LOCALE_JP
        private static const _TRANS_DOUBLE	:String = "2重ログインです。他のブラウザやPCから同時にログインは出来ません";
        CONFIG::LOCALE_JP
        private static const _TRANS_ERR_DIALOG	:String = "以下の登録内容に問題があります。\n";
        CONFIG::LOCALE_JP
        private static const _TRANS_ERR_NAME	:String = "「名前が無効です」\n";

        CONFIG::LOCALE_EN
        private static const _TRANS_INVALID	:String = "Invalid mail address.";
        CONFIG::LOCALE_EN
        private static const _TRANS_RETRY	:String = "Server connection failed. Please click the refresh button and try again.";
        CONFIG::LOCALE_EN
        private static const _TRANS_DOUBLE	:String = "You are attempting to login from multiple locations.\nLogging in multiple times or from different IP addresses is prohibited.";
        CONFIG::LOCALE_EN
        private static const _TRANS_ERR_DIALOG	:String = "There's a problem with the registration information below.\n";
        CONFIG::LOCALE_EN
        private static const _TRANS_ERR_NAME	:String = "Invalid name.\n";

        CONFIG::LOCALE_TCN
        private static const _TRANS_INVALID	:String = "「郵件地址無效」";
        CONFIG::LOCALE_TCN
        private static const _TRANS_RETRY	:String = "無法與伺服器連線。請按下更新鈕,重新登錄。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DOUBLE	:String = "您重覆登入了。無法使用另一瀏覽器或是從其他電腦登入";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ERR_DIALOG	:String = "在以下的註冊項目裏有錯誤\n";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ERR_NAME	:String = "「名字無效」\n";

        CONFIG::LOCALE_SCN
        private static const _TRANS_INVALID	:String = "「邮箱地址无效」";
        CONFIG::LOCALE_SCN
        private static const _TRANS_RETRY	:String = "无法连接服务器。请按下更新按钮后重新登陆。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DOUBLE	:String = "重复登陆。不能同时在其他的浏览器或PC上登陆";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ERR_DIALOG	:String = "以下的登陆内容有误。\n";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ERR_NAME	:String = "「名字无效」\n";

        CONFIG::LOCALE_KR
        private static const _TRANS_INVALID	:String = "「메일 주소가  무효입니다.」";
        CONFIG::LOCALE_KR
        private static const _TRANS_RETRY	:String = "서버와의 통신이 무효합니다. 갱신 버튼을 누르고 다시 시도해 주십시오.";
        CONFIG::LOCALE_KR
        private static const _TRANS_DOUBLE	:String = "이중로그인입니다. 다른 브라우져나 PC에서 동시에 로그인 할 수 없습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_ERR_DIALOG	:String = "이하의 등록 내용에 문제가 있습니다.\n";
        CONFIG::LOCALE_KR
        private static const _TRANS_ERR_NAME	:String = "「이름이 무효입니다.」\n";

        CONFIG::LOCALE_FR
        private static const _TRANS_INVALID	:String = "Adresse mail invalide";
        CONFIG::LOCALE_FR
        private static const _TRANS_RETRY	:String = "Connexion manquée. Rafraîchissez la page.";
        CONFIG::LOCALE_FR
        private static const _TRANS_DOUBLE	:String = "Vous êtes connecté en plusieurs endroit à la fois. Il est interdit de se connecter depuis deux serveurs différents ou d'utiliser deux adresses IP différentes.";
        CONFIG::LOCALE_FR
        private static const _TRANS_ERR_DIALOG	:String = "L'information suivante est incorrecte.\n";
        CONFIG::LOCALE_FR
        private static const _TRANS_ERR_NAME	:String = "nom invalide\n";

        CONFIG::LOCALE_ID
        private static const _TRANS_INVALID	:String = "「メールアドレスが無効です」";
        CONFIG::LOCALE_ID
        private static const _TRANS_RETRY	:String = "サーバとの通信が無効です。更新ボタンを押してから再度登録してみてください。";
        CONFIG::LOCALE_ID
        private static const _TRANS_DOUBLE	:String = "2重ログインです。他のブラウザやPCから同時にログインは出来ません";
        CONFIG::LOCALE_ID
        private static const _TRANS_ERR_DIALOG	:String = "以下の登録内容に問題があります。\n";
        CONFIG::LOCALE_ID
        private static const _TRANS_ERR_NAME	:String = "「名前が無効です」\n";

        CONFIG::LOCALE_TH
        private static const _TRANS_INVALID :String = "อีเมลแอดเดรสไม่ถูกต้อง";//"「メールアドレスが無効です」";
        CONFIG::LOCALE_TH
        private static const _TRANS_RETRY   :String = "ไม่สามารถเชื่อมต่อกับเซิฟเวอร์ได้ กรุณากดปุ่ม Refresh แล้วทำการลงทะเบียนใหม่อีกครั้ง";//"サーバとの通信が無効です。更新ボタンを押してから再度登録してみてください。";
        CONFIG::LOCALE_TH
        private static const _TRANS_DOUBLE  :String = "มีการ login ซ้ำ ท่านไม่สามารถ login ด้วยเบราเซอร์หรือคอมพิวเตอร์เครื่องเดียวกันได้";//"2重ログインです。他のブラウザやPCから同時にログインは出来ません";
        CONFIG::LOCALE_TH
        private static const _TRANS_ERR_DIALOG  :String = "เกิดข้อผิดพลาดในเนื้อหาที่ลงทะเบียนด้านล่าง\n";
        CONFIG::LOCALE_TH
        private static const _TRANS_ERR_NAME    :String = "ไม่สามารถใช้ชื่อนี้ได้\n";


        private static const SERVER_TIMEOUT:int = 20; // ログインサーバの応答タイムアウト
        public static const REGIST_NG_NAME:int = 1;   // 登録時、名前が向こう
        public static const REGIST_NG_EMAIL:int = 2;   // サーバから切断
        public static const REGIST_NG_SALT:int = 4;   // サーバから切断

        private static const SERVER_SB:int    = 0;

        private static var srp:SRP = new SRP(); // 認証用クラス
        private var _timeOutTimer:Timer; // タイムアウト用タイマ

        private var pass:String;                // パス
        private var id:String;                  // ID
        private var pub_key:String;             // クライアントのパブリックキー
        private var pri_key:String;             // クライアントのプライベートキー
        private var sv_pub_key:String;          // サーバのパブリックキー
        private var _salt:String;                // ソルト
        private var random_num:String;          // 一時的なランダムナンバー
        private var session_key:String;         // セッションキー
        private var strong_key:String;          // ストロングキー
        private var matcher:String;              // マッチャー
        private var lobby_adress:String;        // ロビーサーバのアドレス
        private var lobby_port:uint;            // ロビーサーバのポート
        private var _serverNo:int;

        private var _command:AuthCommand;

        private static var __instance:AuthServer;

        private var _connectFunc:Function;

        /**
         * コンストラクタ
         * 通信相手のホストに自信の使用するコマンドOBJを登録して生成
         *
         */
        public function AuthServer(caller:Function = null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            _command = new AuthCommand(this);
            player.addEventListener(Player.AUTH_START,loginHandler); // 接続時
            player.addEventListener(Player.REGIST_START,registHandler); // 接続時
        }

        private static function createInstance():AuthServer
        {
            return new AuthServer(arguments.callee);
        }

        public static function get instance():AuthServer
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        protected override function get command():Command
        {
            return _command;
        }

        // オーバライド前提のHeartBeatHandler
        protected override function heartBeatHandler(e:Event):void
        {
            host.sendCommand(_command.csKeepAlive());
        }



        /**
         * ログインハンドラ
         * プレイヤーがログインした場合、イベントを受け取り、ホストと通信する
         *
         */
        public function loginHandler(e:Event):void
        {
            _timeOutTimer = new Timer(SERVER_TIMEOUT*1000, 1); // 20秒でタイムアウトする
            _timeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, serverTimeoutHandler);
            _timeOutTimer.start();

            log.writeLog (log.LV_DEBUG,this,"Login event get ", player.name);
            id = player.name;
            pass = player.pass;
            random_num = srp.genRndBigNum();
            pub_key = srp.getClientPublicKey(random_num);
            _serverNo = ServerNumber.getNo(id, Config.authServerNum);

            var s:Object = Config.authServersInfo(_serverNo);
            _connectFunc = login;
            log.writeLog (log.LV_DEBUG,this,"Login event  ", s.adress,s.port);
            // サーバに接続
            connect(s.address,s.port);
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("AS["+s.address+":"+s.port.toString()+"]");
            }

        }

        private function login():void
        {
            host.sendCommand(_command.authStart(id,pub_key ));
        }

        private function regist():void
        {
            _salt = srp.genSalt();
            host.sendCommand(_command.csOpenSocialRegister(player.name,_salt,srp.getVerifire(player.name,player.pass,_salt),SERVER_SB));
        }


        protected override function serverOKHandler (event:Event):void
        {
            _timeOutTimer.stop();
            _timeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, serverTimeoutHandler);
            if (_connectFunc !=null)
            {
                _connectFunc()
            }
            dispatchEvent(new Event(Server.CONNECT));
        }

        // タイムアウトまたはサーバが死んでいるので
        private function serverTimeout():void
        {
            _timeOutTimer.stop();
            _timeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, serverTimeoutHandler);
//LOCALE_JP <-フォント読み込みを防ぐ
            CONFIG::LOCALE_JP
            {
                Alerter.showWithSize('サーバが応答しません。しばらくたってからもう一度入力してください', 'Error', 4, null);
            }
            CONFIG::LOCALE_EN
            {
                Alerter.showWithSize('Server connection failed', 'Error', 4, null);
            }
            CONFIG::LOCALE_TCN
            {
                Alerter.showWithSize('伺服器無回應，請稍後再試。', 'Error', 4, null);
            }
            CONFIG::LOCALE_SCN
            {
                Alerter.showWithSize('伺服器无回应，请稍後再试。', 'Error', 4, null);
            }
            CONFIG::LOCALE_FR
            {
                Alerter.showWithSize('Le serveur ne répond pas. Veuillez réessayer après avoir relancer votre navigateur.', 'Error', 4, null);
            }
            CONFIG::LOCALE_TH
            {
                Alerter.showWithSize('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ กรุณาลองใหม่อีกครั้งค่ะ', 'Error', 4, null);
            }
//              Alerter.showWithSize('Server connection failed', 'Error.', 4, null);
        }

        /**
         * 登録ハンドラ
         *
         */
        public function registHandler(e:Event):void
        {
            _timeOutTimer = new Timer(SERVER_TIMEOUT*1000, 1); // 20秒でタイムアウトする
            _timeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, serverTimeoutHandler);
            _timeOutTimer.start();

            log.writeLog (log.LV_DEBUG,this,"Regist even get ", player.name);

            _serverNo = ServerNumber.getNo(player.name, Config.authServerNum);

            var s:Object = Config.authServersInfo(_serverNo);
            _connectFunc = regist;
            // サーバに接続
            connect(s.address,s.port);
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("AS["+s.address+":"+s.port.toString()+"]");
            }


        }

        // サーバの応答のタイムアウト時のハンドラ
        private function serverTimeoutHandler(evt:TimerEvent):void
        {
            serverTimeout();
        }



        /**
         * 受信コマンド
         *
         */

        /**
         * 登録コマンドの結果
         *
         */
        public function registResult(result:int):void
        {
//            var msg:String ="以下の登録内容に問題があります。\n"
            var msg:String =_TRANS_ERR_DIALOG
            if (result==0)
            {
                player.registSuccess();
            }
            else
            {
                if (result&REGIST_NG_NAME)
                {
//                    msg += "「名前が無効です」\n"
                    msg += _TRANS_ERR_NAME
                }
                if(result&REGIST_NG_EMAIL)
                {
//                    msg += "「メールアドレスが無効です」"
                    msg += _TRANS_INVALID
                }
                if(result&REGIST_NG_SALT)
                {
//                    msg = "サーバとの通信が無効です。更新ボタンを押してから再度登録してみてください。"
                    msg = _TRANS_RETRY
                }

                player.registFailed(msg)
            }

        }

        /**
         * ホストからsaltとServerPubKeyを受け取認証に対する返答をおこなう
         * @param s 受け取ったsalt
         * @param server_pub_key 受け取ったServerPubKey
         *
         */
        public function authReturn(s:String, server_pub_key:String):void
        {
            log.writeLog(log.LV_INFO, this, "authReturn ", s, server_pub_key);
            // 帰ってきたコマンドが正しいかを検証
            _salt = s;
            sv_pub_key = server_pub_key;
            //SaltとパスとIDからプライベートキーを計算する
            pri_key = srp.getPrivateKey(id, pass, _salt);
            //セッションキーを計算する
            session_key = srp.getSessionKey(pub_key, sv_pub_key, pri_key, random_num);
            // セッションキーからストロングセッションキーを作る
            strong_key = srp.getStrongKey(session_key);
            log.writeLog(log.LV_DEBUG, this, "StrongrKey is", strong_key);
            //ストロングキーからマッチャーを作って送る
            matcher = srp.getMatcher(pub_key, sv_pub_key, id, _salt, strong_key);
            log.writeLog(log.LV_DEBUG, this, "sendMatcher ", matcher);
            host.sendCommand(_command.authGetMatcher(matcher));
        }

        /**
         * ホストからの認証の結果を照合する
         * 成功/失敗のイベントを送出する
         * @param cert サーバからの証明
         */
        public function authCert(cert:String,i:uint):void
        {
            log.writeLog(log.LV_INFO, this, "authCert ", cert);

            // コマンドの合否を調べる
            // 成功のイベントを創出
            if (srp.getCert(pub_key, matcher, strong_key) == cert)
            {
                log.writeLog(log.LV_INFO, this, "cert ok ", cert);
                player.loginSuccess(i,strong_key);

                ClientLog.init(i); // ログクライアントの初期化
//                host.setSessionKey(strong_key);
            }
            else
            // 失敗の場合サーバ無効のイベントを送出してホストと切断
            {
                host.close();
                log.writeLog(log.LV_FATAL, "AuthServer.as", "Invalid Server! ");
                player.loginFailed();
            }
        }

        /**
         * 認証の失敗
         *
         */
        public function authFail():void
        {
            log.writeLog(log.LV_ERROR, "AuthServer.as", "Auth Failed!!: ");
            player.loginFailed();
        }

        /**
         * 人数制限
         *
         */
        public function authUserLimit():void
        {
            log.writeLog(log.LV_ERROR, "AuthServer.as", "Auth User Limit!!: ");
        }

        /**
         * ホストからロビーの情報を受け取ったときにイベントを送出
         *
         */
        public function lobbyInfo(ip:String, port:uint):void
        {
            lobby_adress = ip;
            lobby_port = port;
        }

        public function scOpenSocialNotRegist():void
        {
            log.writeLog(log.LV_WARN, this, "Not regist. ");
            player.notRegist();

        }

        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }

        public function scRequestReregist():void
        {
            reregist();
        }

        private function reregist():void
        {
            log.writeLog(log.LV_WARN, this, "reregist!!");
//LOCALE_JP <-フォント読み込みを防ぐ
            Alerter.showWithSize("認証エラー　ブラウザをリロードしてみてください。", 'Error', 4, null, Alerter.reloadWindow, 130);
//             _salt = srp.genSalt();
//             Alerter.showWithSize("認証エラー　ブラウザをリロードしてみてください。（このエラーが何度も出る場合、大変お手数ですが下記お問い合わせまでご連絡下さい）", 'Error', 4, null, Alerter.reloadWindow, 130);
//             host.sendCommand(_command.csReregister(player.name, _salt, srp.getVerifire(player.name,player.pass,_salt),SERVER_SB));
        }

        public function updateInvitedUser(users:String):void
        {
            log.writeLog(log.LV_ERROR, "AuthServer.as", "updateinviteuser: ", users);
            host.sendCommand(_command.csUpdateInvitedUser(users));
        }

        public function updatePlayedTutorial(type:int):void
        {
            log.writeLog(log.LV_ERROR, "AuthServer.as", "updateplayedTutorial: ", type);
            host.sendCommand(_command.csUpdateTutoPlay(type));
        }


        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {
            log.writeLog(log.LV_WARN, this,"Error no is", e);
            WaitingPanel.hide();
//            TitleCtrl.instance.errorAlert(e);
            if (e == 7)
            {
                exit();
 //               Alerter.showWithSize('2重ログインです。他のブラウザやPCから同時にログインは出来ません', 'Error', 4, null, Alerter.reloadWindow, 110);
                Alerter.showWithSize(_TRANS_DOUBLE, 'Error', 4, null, Alerter.reloadWindow, 110);
                Unlight.live = false; // 二度と通信出来なくする
                LobbyServer.instance.exit();
                QuestServer.instance.exit();
                DataServer.instance.exit();
                GameServer.instance.exit();
                MatchServer.instance.exit();
                ChatServer.instance.exit();
            }else if (e == 8){
                exit()
                Alerter.showWithSize(Const.ERROR_STR[e], "Error", 4, null);
//                Alerter.showWithSize(, 'Error', 4, null, Alerter.reloadWindow, 110);
            }
            log.writeLog(log.LV_WARN, this,"Error no is", e);
        }

    }
}