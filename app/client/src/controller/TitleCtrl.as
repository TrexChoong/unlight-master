package controller
{
    import flash.utils.Timer;
    import flash.utils.ByteArray;
    import flash.events.*;
    import flash.display.DisplayObject;
    import flash.external.*;


    import mx.controls.Alert;
    import mx.controls.Button;
    import mx.controls.TextInput;

    import model.*;
    import net.server.*;
    import view.image.title.*;

    import sound.bgm.TitleBGM;
    import sound.se.ClickSE;



    /**
     * タイトル画面コントロールクラス
     *
     */

    public class TitleCtrl extends BaseCtrl
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "認証";
        CONFIG::LOCALE_JP
        private static const _TRANS_NAME	:String = "名前";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CUTOUT	:String = "サーバから切断されました。リロードをお願いします。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_NAME	:String = "名前を入力してください";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_FAIL	:String = "認証に失敗しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BADSV	:String = "無効なサーバーです";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_SUCCESS	:String = "登録に成功しました";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_FINISH	:String = "登録完了";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_START	:String = "アンライトの世界へようこそ！";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GSTART	:String = "ゲーム開始";

        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Login";
        CONFIG::LOCALE_EN
        private static const _TRANS_NAME	:String = "Name";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CUTOUT	:String = "Disconnected from server, please reload.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_NAME	:String = "Please enter your name.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_FAIL	:String = "Login failed.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BADSV	:String = "The server is invalid.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_SUCCESS	:String = "Registration successful.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_FINISH	:String = "Registration Finished";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_START	:String = "Welcome the world of Unlight!";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GSTART	:String = "Start";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "認證";
        CONFIG::LOCALE_TCN
        private static const _TRANS_NAME	:String = "名字";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CUTOUT	:String = "與伺服器連線中斷,請重新連線";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_NAME	:String = "請輸入名字。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_FAIL	:String = "認證失敗";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BADSV	:String = "無效的伺服器";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_SUCCESS	:String = "登錄成功";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_FINISH	:String = "登錄完畢";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_START	:String = "歡迎來到Unlight的世界。現在是OB中,會有不定時的維護作業";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GSTART	:String = "遊戲開始";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "认证";
        CONFIG::LOCALE_SCN
        private static const _TRANS_NAME	:String = "名字";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CUTOUT	:String = "服务器中断，请重装。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_NAME	:String = "请输入名字";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_FAIL	:String = "认证失败";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BADSV	:String = "无效的服务器";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_SUCCESS	:String = "登陆成功";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_FINISH	:String = "登陆完毕";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_START	:String = "欢迎来到Unlight世界！";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GSTART	:String = "游戏开始";

        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "인증";
        CONFIG::LOCALE_KR
        private static const _TRANS_NAME	:String = "이름";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CUTOUT	:String = "서버와 통신이 절단 되었습니다. 갱신을 해주십시오.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_NAME	:String = "이름을 입력해 주세요.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_FAIL	:String = "인증에 실패했습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BADSV	:String = "무효한 서버입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_SUCCESS	:String = "등록에 성공했습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_FINISH	:String = "등록 완료";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_START	:String = "UnLight의 세계에 어서 오십시오. 현재 OB중입니다. 갑작스러운 멘테난스의 가능성이 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GSTART	:String = "게임 개시";

        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Autorisation";
        CONFIG::LOCALE_FR
        private static const _TRANS_NAME	:String = "Nom";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CUTOUT	:String = "Déconnecté du serveur.\nVeuillez recharger la page.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_NAME	:String = "Écrivez votre nom";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_FAIL	:String = "L'autorisation a échoué.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BADSV	:String = "Serveur invalide";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_SUCCESS	:String = "Inscription réussie";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_FINISH	:String = "Inscription terminée";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_START	:String = "Bienvenue dans le monde Unlight.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GSTART	:String = "Commencer";

        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "認証";
        CONFIG::LOCALE_ID
        private static const _TRANS_NAME	:String = "名前";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CUTOUT	:String = "サーバから切断されました。リロードをお願いします。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_NAME	:String = "名前を入力してください";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_FAIL	:String = "認証に失敗しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_BADSV	:String = "無効なサーバーです";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_SUCCESS	:String = "登録に成功しました";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_FINISH	:String = "登録完了";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_START	:String = "アンライトの世界へようこそ！";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GSTART	:String = "ゲーム開始";

        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM :String = "Login";
        CONFIG::LOCALE_TH
        private static const _TRANS_NAME    :String = "ชื่อ";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CUTOUT  :String = "ถูกตัดออกจากเซิฟเวอร์ กรุณาลองใหม่อีกครั้ง";//"サーバから切断されました。リロードをお願いします。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_NAME    :String = "กรุณาใส่ชื่อของท่าน";//"名前を入力してください";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_FAIL    :String = "Login failed";//"認証に失敗しました";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_BADSV   :String = "เซิฟเวอร์ไม่ถูกต้อง";//"無効なサーバーです";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_SUCCESS :String = "ลงทะเบียนสำเร็จ";//"登録に成功しました";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_FINISH  :String = "การลงทะเบียนเสร็จสิ้น";//"登録完了";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_START   :String = "ยินดีต้อนรับสู่โลกแห่งUNLIGHT";//"アンライトの世界へようこそ！";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GSTART  :String = "เริ่มเกม";//"ゲーム開始";


        protected static var __instance:TitleCtrl; // シングルトン保存用

        private static const SERVER_TIMEOUT:int = 10; // ニュース更新用インターバル（長期：秒）
        private static const NEWS_INTERVAL:int = 10; // ニュース更新用インターバル（長期：秒）

        private var _server:AuthServer;

        private var _loginPanel:LoginPanel;
        private var _newsPanel:NewsPanel;

        private var newsTimer:Timer;          // ニュースのタイマ


        // タイトルBGM
        private var _bgm:TitleBGM = new TitleBGM();

        /**
         * コンストラクタ
         *
         *
         */
        public function TitleCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            // 認証サーバを登録
            log.writeLog(log.LV_INFO, this, "ここで止まる！！！！　謎");
            _server = AuthServer.instance;
            init();
        }

        private static function createInstance():TitleCtrl
        {
            return new TitleCtrl(arguments.callee);
        }

        public static function get instance():TitleCtrl
        {
             if( __instance == null )
             {
                 __instance = createInstance();
             }
             return __instance;
        }


        protected override function get server():Server
        {
           return  _server;
        }



        // コンフィグ読み込み終了ハンドラ
        private function getConfigHandler(evt:Event):void
        {
            log.writeLog (log.LV_INFO,this,"Config Loaded!");
            updateConfig();
        }

        // ニュースを更新イベントハンドラ
        private function getUpdateHandeler(evt:Event):void
        {
            updateConfig();
        }

        //
        private function updateConfig():void
        {
            // サーバの情報を更新
            updateServerState();
        }

        // サーバ接続時イベントハンドラ
        protected override function getServerConnectedHandler(evt:Event):void
        {
            super.getServerConnectedHandler(evt);
            updateServerState();
        }

        public function setLoginPanel(loginPanel:LoginPanel):void
        {
            _loginPanel = loginPanel;
        }

        public function setNewsPanel(newsPanel:NewsPanel):void
        {
            _newsPanel = newsPanel;
        }

        /**
         * ログイン
         * @param userName 名前入力のTextInput
         * @param passName PASS入力のTextInput
         *
         */// ログイン
        public function login():void
        {
            log.writeLog (log.LV_DEBUG,this,"Login buttun pushed ",_loginPanel.userName);
            if (_loginPanel.userName == "")
            {
//                Alerter.showWithSize('名前を入力してください', 'Error');
                Alerter.showWithSize(_TRANS_MSG_NAME, 'Error');
            }
                else
                {
                    log.writeLog (log.LV_DEBUG,this,"Login",_loginPanel.userName,_loginPanel.pass);
                    _loginPanel.panelEditable(false);

                    // 各種ハンドラを登録
                    player.addEventListener(Player.AUTH_FAILED, authFailHandler);
                    player.addEventListener(Player.AUTH_SUCCESS, authSuccessHandler);
                    // プレイヤーがログイン
                    player.login(_loginPanel.userName,_loginPanel.pass);
                }
        }

        // 認証に失敗時のハンドラ
        private function authFailHandler(event:Event):void
        {
            player.removeEventListener(Player.AUTH_FAILED, authFailHandler);
            player.removeEventListener(Player.AUTH_SUCCESS, authSuccessHandler);
//            Alerter.showWithSize('認証に失敗しました', 'Error');
            Alerter.showWithSize(_TRANS_MSG_FAIL, 'Error');
            _loginPanel.panelEditable(true);
        }

        // 認証に成功時のハンドラ
        private function authSuccessHandler(event:Event):void
        {
            player.removeEventListener(Player.AUTH_FAILED, authFailHandler);
            player.removeEventListener(Player.AUTH_SUCCESS, authSuccessHandler);
            _loginPanel.panelEditable(false);
            _loginPanel.panelClear();
        }


        // サーバ切断時イベントハンドラ
        protected override function getServerDisconnectedHandler(evt:Event):void
        {
            log.writeLog (log.LV_FATAL,this,"Server Disconnected");
            server.removeEventListener(Server.DISCONNECT,getServerDisconnectedHandler); // 切断時
            connected = false;
            BaseCtrl.alarted = true;
            log.writeLog (log.LV_FATAL,this,"Alarted?",BaseCtrl.alarted);
//            Alerter.showWithSize('サーバから切断されました。リロードをお願いします。', 'Error', 4, null, Alerter.reloadWindow, 100);
            Alerter.showWithSize(_TRANS_MSG_CUTOUT, 'Error', 4, null, Alerter.reloadWindow, 100);

        }


        protected override function get serverName():String
        {
//            return "認証";
            return _TRANS_CONFIRM;
        }


        // 無効なサーバ時のハンドラ
        private function invalidServerHandler(event:Event):void
        {
//            Alerter.showWithSize('無効なサーバーです', 'Error');
            Alerter.showWithSize(_TRANS_MSG_BADSV, 'Error');
            _loginPanel.panelEditable(true);
        }

        /**
         * 登録
         * @param userName 名前入力のTextInput
         * @param passName PASS入力のTextInput
         *
         */
        public function regist():void
        {
            log.writeLog (log.LV_DEBUG,this,"regist buttun pushed ",_loginPanel.userName);
            var msg:String = "";
            if (_loginPanel.userName == "")
            {
//                msg += "名前"
                msg += _TRANS_NAME
                    }
            if (_loginPanel.pass == "")
            {
                if (msg !="") {msg+=",";}
                msg += "Pass";
            }
            if (_loginPanel.email == "")
            {
                if (msg !="") {msg+=",";}
                msg += "E-mail";
            }
            if (msg != "")
            {
                //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                Alerter.showWithSize(msg+' を入力してください', 'Error');
            }
            else
            {
                if (_loginPanel.confirm == _loginPanel.pass)
                {
                    log.writeLog (log.LV_DEBUG,this,"regist",_loginPanel.userName,_loginPanel.pass);
                    _loginPanel.panelEditable(false);
                    // 各種ハンドラを登録
                    player.addEventListener(Player.REGIST_FAILED, registFailHandler);
                    player.addEventListener(Player.REGIST_SUCCESS, registSuccessHandler);
//                    player.addEventListener(AuthServer.INVALID_SEVER, invalidServerHandler);
                    // プレイヤーがログイン
                    player.regist(_loginPanel.userName,_loginPanel.email,_loginPanel.pass);
                }else
                {
                    //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                    Alerter.showWithSize('Passが確認できません。確認とPassには同一内容を記入してください', 'Error' , 4, null, null, 100);
                }

            }
        }

        // 登録に失敗時のハンドラ
        private function registFailHandler(event:ErrorEvent):void
        {
            Alerter.showWithSize(event.text, 'Error',4,null,null, 150);
            _loginPanel.panelEditable(true);
            player.removeEventListener(Player.REGIST_FAILED, registFailHandler);
            player.removeEventListener(Player.REGIST_SUCCESS, registSuccessHandler);
        }

        // 登録に成功時のハンドラ
        private function registSuccessHandler(event:Event):void
        {
            player.removeEventListener(Player.REGIST_FAILED, registFailHandler);
            player.removeEventListener(Player.REGIST_SUCCESS, registSuccessHandler);
            _loginPanel.panelEditable(true);
//            Alerter.showWithSize('登録に成功しました', '登録完了', Alert.OK,null,registToLoginHandler);
            Alerter.showWithSize(_TRANS_MSG_SUCCESS, _TRANS_MSG_FINISH, Alert.OK,null,registToLoginHandler);
        }

        // 登録OKボタンのハンドラ（そのままログインを行う）
        private function registToLoginHandler(e:Event):void
        {
            login();
        }



        // サーバー状態によってStateを変更する
        private function updateServerState():void
        {
            _loginPanel.stateChange(Config.serverState);
        }


        // チュートリアルの進行状況を更新
        public function updateTutePlay(t:int):void
        {
            _server.updatePlayedTutorial(t);
        }

        // アラートの多重起動を防ぐハンドラ
        private function alertOffHandler(event:Event):void
        {
            BaseCtrl.alarted = false;
        }

        public function playBGM():void
        {

            _bgm.loopSound(0);
        }

        public function stopBGM():void
        {
            _bgm.fade(0,2)
        }

    }
 }
