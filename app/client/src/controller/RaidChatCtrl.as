package controller
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    import mx.containers.*;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import sound.bgm.LobbyBGM;
    import sound.se.*;
    import sound.BaseSound;
    import sound.bgm.*;
    import sound.se.*;


    import net.Host;

    import model.*;
    import model.events.*;
    import view.*;
    import view.utils.*;
    import view.scene.raid.*;
    import net.server.*;


    /**
     * レイドチャットコントロールクラス
     *
     */
    public class RaidChatCtrl extends BaseCtrl
    {
        public static const BOSS_HP_UPDATE:String   = "boss_hp_update";

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "レイドチャット";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Raid Chat";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "突擊頻道";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "突击聊天";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Raid chat";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS :String = "Raid chat";


        private const _MSG_PUSH_MAX_NUM:int = 10;
        private const _MSG_POP_MAX_NUM:int = 10;
        private const _MSG_NONWAIT_POP_NUM:int = 5;

        protected static var __instance:RaidChatCtrl; // シングルトン保存用

        private var _server:RaidchatServer;
        private var _connected:Boolean = false;        // Serverにコネクトしているか？
        private var _updateEnable:Boolean = true;

        private var _prfLogs:ProfoundLogs = ProfoundLogs.getInstance();
        private var _battle:Boolean = false;
        private var _lastId:int = 0;

        private var _msgList:Array = [];
        private var _time:Timer;  // 消滅監視用タイマー

        public function RaidChatCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            // ロビーサーバを登録
            _server = RaidchatServer.instance;
            init();
            setHandler();

        }
        private function setHandler():void
        {
            _prfLogs.addEventListener(ProfoundLogsEvent.SPEAK_COMMENT,setCommentHandler);

            _time = new Timer(5000);
            _time.addEventListener(TimerEvent.TIMER, updateDuration);
            _time.start();
        }

        private static function createInstance():RaidChatCtrl
        {
            return new RaidChatCtrl(arguments.callee);
        }

        public static function get instance():RaidChatCtrl
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        protected override function get server():Server
        {
           return  _server;
        }

        /**
         * ロビーのスタート
         *
         */
        public function start():void
        {
            log.writeLog(log.LV_DEBUG, this, "start");
            // ロビーサーバにつなぐ
            _server.connect();
            waitConnectThreadStart();
        }

        // connecetWaitスレッドが使うスタートコマンド
        public override function waitStart():void
        {
            log.writeLog(log.LV_DEBUG, this, "wait start", _server.state);
            _server.start(this);

        }

        protected override function get serverName():String
        {
            return _TRANS;
        }


        public override function get connected():Boolean
        {
            return _connected;
        }

        public override function set connected(b:Boolean):void
        {
             _connected = b;
             if (b)
             {
                 // updateRankList(4,0,10);
                 // updateMyRank(1);

             }

        }

        // コメント保存
        public function setCommentHandler(e:ProfoundLogsEvent):void
        {
            if (connected) {
                _server.csSetComment(e.prfId,e.str,e.lastId);
            }
        }

        // コメント要求
        public function requestComment(prfId:int,lastId:int):void
        {
            if (connected) {
                _server.csRequestComment(prfId,lastId);
            }
        }

        // コメント取得
        public function updateComment(prfId:int,comments:String,lastId:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "updateComment");
            var commentList:Array = comments.split(",");
            for (var i:int = 0; i < commentList.length; i++) {
                if (commentList.length <= _MSG_NONWAIT_POP_NUM) {
                    if (_battle) {
                        log.writeLog(log.LV_DEBUG, this, "updateComment battle");
                        _prfLogs.setGameMessagePrfId(prfId,commentList[i]);
                    } else {
                        log.writeLog(log.LV_DEBUG, this, "updateComment normal");
                        _prfLogs.setMessagePrfId(prfId,commentList[i]);
                    }
                } else {
                    _msgList.push(new MessageStockData(_battle,prfId,commentList[i]));
                    if (_msgList.length > _MSG_PUSH_MAX_NUM) {
                        // 多すぎるので古いのを破棄
                        _msgList.shift();
                    }
                }
                _prfLogs.setMessageLastId(prfId,lastId);
            }
        }

         // ボスHPの更新
        public function updateBossHP(prf:Profound):void
        {
            // log.writeLog(log.LV_FATAL, this, "check new notice");
            if (connected)
            {
                _server.csUpdateBossHP(prf.id,prf.nowDamage);
            }
        }

       // ボスHPの更新取得
        public function sendBossDamage(prfId:int,damage:int,strData:String,state:int,stateUpdate:Boolean):void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            ProfoundListContainer.instance.damage(prfId,damage,strData,state,stateUpdate);
        }

        // ボスの表示用HPを更新
        public function setUpdateBossViewHP(prfId:int,damage:int):void
        {
            var prf:Profound = Profound.getProfoundForId(prfId);
            if (prf) {
                prf.viewDamage = damage;
                dispatchEvent(new Event(BOSS_HP_UPDATE));
            }
        }

        // ボスHPの更新取得
        public function setUpdateBossHP(prfId:int,damage:int):void
        {
            log.writeLog(log.LV_FATAL, this, "setUpdateBossHP",prfId,damage);
            var prf:Profound = Profound.getProfoundForId(prfId);
            if (prf) {
                prf.nowDamage = damage;
            }
        }

        public function set battle(b:Boolean):void
        {
            _battle = b;
        }


        public function restart():void
        {
            if (!connected)
            {
                _server.connect();
                waitConnectThread.start();
            }
        }

        // サーバ切断時イベントハンドラ
        protected override function getServerDisconnectedHandler(evt:Event):void
        {
            _server.connect();

        }

        private function updateDuration(e:Event):void
        {
            setStockMsg();
        }

        private function setStockMsg():void
        {
            var popCnt:int = _MSG_POP_MAX_NUM;
            while (popCnt > 0) {
                var setMsg:MessageStockData = _msgList.shift();
                if (setMsg) {
                    if (setMsg.battle) {
                        log.writeLog(log.LV_DEBUG, this, "updateComment battle");
                        _prfLogs.setGameMessagePrfId(setMsg.prfId,setMsg.comment);
                    } else {
                        log.writeLog(log.LV_DEBUG, this, "updateComment");
                        _prfLogs.setMessagePrfId(setMsg.prfId,setMsg.comment);
                    }
                }
                popCnt--;
            }
        }



    }
}


class MessageStockData
{
    private var _battle:Boolean;
    private var _prfId:int;
    private var _comment:String;

    public function MessageStockData(battle:Boolean,prfId:int,comment:String):void
    {
        _battle = battle;
        _prfId = prfId;
        _comment = comment;
    }

    public function get battle():Boolean
    {
        return _battle;
    }
    public function get prfId():int
    {
        return _prfId;
    }
    public function get comment():String
    {
        return _comment;
    }
}