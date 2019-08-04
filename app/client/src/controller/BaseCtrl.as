package controller
{

    import flash.events.*;

    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.ThreadState;

    import model.*;
    import view.utils.*;
    import net.server.Server;

    /**
     * コントロールの基底クラス
     *
     */
    public class BaseCtrl extends EventDispatcher
    {

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_CUTSV	:String = "サーバから切断されました";

        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT	:String = "Warning";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_CUTSV	:String = "Disconnected from server.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_CUTSV	:String = "：無法跟服務器通信。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_CUTSV	:String = "：服务器中断";

        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT	:String = "경고";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CUTSV	:String = "서버와의 통신이 절단되었습니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT	:String = "Attention";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_CUTSV	:String = "Déconnexion";

        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_CUTSV	:String = "サーバから切断されました";

        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT   :String = "คำเตือน";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_CUTSV   :String = "ถูกตัดออกจากเซิฟเวอร์";


        public  const CONNECT_CLOSED:int =-1;
        public  const CONNECT_NONE:int = 0;
        public  const CONNECT_NOT_AUTH:int = 1;
        public  const CONNECT_AUTHED:int = 2;

        public static var alarted:Boolean = false;      // すでにアラートが出ている？
        private static var __waitingThread:Thread;

        protected static var __instance:BaseCtrl; // シングルトン保存用

        protected var player:Player = Player.instance;

        private var _connected:Boolean = false;        // Serverにコネクトしているか？

        private var _server:Server;


        public function BaseCtrl(caller:Function=null)
        {
        }

        // オーバライド前提のサーバゲッタ
        protected function get server():Server
        {
           return  _server;
        }
        protected function init():void
        {
            server.addEventListener(Server.CONNECT,getServerConnectedHandler); // 接続時
        }

         // サーバ接続時イベントハンドラ
        protected function getServerConnectedHandler(evt:Event):void
        {
            connected = true;
            log.writeLog (log.LV_INFO,this,"Server Connected");
            server.addEventListener(Server.DISCONNECT,getServerDisconnectedHandler); // 接続時
        }

        // サーバ切断時イベントハンドラ
        protected function getServerDisconnectedHandler(evt:Event):void
        {
            log.writeLog (log.LV_FATAL,this,"Server Disconnected");
            server.removeEventListener(Server.DISCONNECT,getServerDisconnectedHandler); // 切断時
            connected = false;
            if (BaseCtrl.alarted==false)
            {
                BaseCtrl.alarted = true;
                log.writeLog (log.LV_FATAL,this,"Alarted?",BaseCtrl.alarted);
//                Alerter.showWithSize(serverName+'サーバから切断されました', 'Error', 4, null, logoutAlertOffHandler);
                Alerter.showWithSize(serverName+_TRANS_MSG_CUTSV, 'Error', 4, null, logoutAlertOffHandler);
            }

        }

        protected function get serverName():String
        {
            return "";
        }

        // アラートの多重起動を防ぐハンドラ
        protected function logoutAlertOffHandler(event:Event):void
        {
            BaseCtrl.alarted = false;
        }

        public function get connected():Boolean
        {
            return _connected;
        }

        public function set connected(b:Boolean):void
        {
             _connected = b;
        }

        public function get serverState():int
        {
            return server.state;
        }

        public function errorAlert(e:int):void
        {
            if (BaseCtrl.alarted==false)
            {
                BaseCtrl.alarted = true;
                log.writeLog (log.LV_FATAL,this,"Alarted?",BaseCtrl.alarted);
//                Alerter.showWithSize(Const.ERROR_STR[e], '警告', 4, null, errorOffHandler);
                Alerter.showWithSize(Const.ERROR_STR[e], _TRANS_ALERT, 4, null, errorOffHandler);
            }
        }

        // アラートの多重起動を防ぐハンドラ
        protected function errorOffHandler(event:Event):void
        {
            BaseCtrl.alarted = false;
            // なにかまっていたら消す
            WaitingPanel.hide();
        }

        public function exit():void
        {
            if (server!=null)
            {
                server.exit();
                log.writeLog(log.LV_FATAL, this, "exit server");
                connected = false;
            }
        }

        // アイテム用
        // 使用した時
        public function sendItem(id:int):void
        {
        }

        // 買った時
        public function buyItem(shop:int, id:int, amount:int = 1):void
        {
        }

        protected function waitConnectThreadStart():void
        {
            // WaitndThreadがからまたは終了していたらあたらしくスタートさせる
            if (waitingThread ==null || waitingThread.state==ThreadState.TERMINATED)
            {
                waitingThread = waitConnectThread;
                log.writeLog(log.LV_FATAL, this, "start waitconnecetthread",waitingThread);
                waitingThread.start();
            }
        }

        //
        protected function get waitConnectThread():Thread
        {
            return new WaitConnectThread(server,this);
        }

        public function waitStart():void
        {

        }

        protected function get waitingThread():Thread
        {
            return __waitingThread
        }

        protected function set waitingThread(t:Thread):void
        {
            __waitingThread = t;
        }
   }
}

import org.libspark.thread.*;
import model.*;
import net.server.Server;
import net.*;
import controller.*;



class WaitConnectThread extends Thread
{
    private var _server:Server;
    private var _ctrl:BaseCtrl;

    public function WaitConnectThread(s:Server,ctrl:BaseCtrl)
    {
        _server = s;
        _ctrl = ctrl;
    }

    protected override function run():void
    {
        log.writeLog(log.LV_INFO, this, "connect?",_server.state,_server);
        next(waitConnect)
    }

    private function waitConnect():void
    {
        if (_server.state != Host.CONNECT_NONE&&_server.state != Host.CONNECT_CLOSED)
        {
            next(close);
        }else
        {
            next(waitConnect)
        }
    }


    private function close():void
    {
        _ctrl.waitStart();
        return;
    }
}
