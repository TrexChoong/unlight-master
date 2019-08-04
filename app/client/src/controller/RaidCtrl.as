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
     * レイド画面コントロールクラス
     *
     */
    public class RaidCtrl extends DuelCtrl
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_RAID	:String = "レイド";

        CONFIG::LOCALE_EN
        private static const _TRANS_RAID	:String = "Raid";

        CONFIG::LOCALE_TCN
        private static const _TRANS_RAID	:String = "突擊";

        CONFIG::LOCALE_SCN
        private static const _TRANS_RAID	:String = "突击";

        CONFIG::LOCALE_KR
        private static const _TRANS_RAID	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_RAID	:String = "Raid";

        CONFIG::LOCALE_ID
        private static const _TRANS_RAID	:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_RAID	:String = "Reid";

        public static const RAID_INPROGRESS:String  = "raid_inprogress";
        public static const RAID_SOLVED:String      = "raid_solved";
        public static const BATTLE_START:String     = "battle_start";
        public static const BTL_START_FAILED:String = "btl_start_failed";
        public static const NOTICE_UPDATE:String    = "notice_update";

        protected static var __instance:RaidCtrl; // シングルトン保存用

        private var _server:RaidServer;
        private var _view:RaidView;

        private var _bgm:LobbyBGM = new LobbyBGM();
        private var _bgmPlaying:Boolean = false;

        private var _time:Timer;

        // 更新されたInventoryのIDリスト
        private var _updatePrfIdList:Array = [];

        public function RaidCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
        }

        protected override function serverInitialize():void
        {
            _server = RaidServer.instance;
            init();
        }


        private static function createInstance():RaidCtrl
        {
            return new RaidCtrl(arguments.callee);
        }

        public static function get instance():RaidCtrl
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

        protected override function get serverName():String
        {
            return _TRANS_RAID;
        }

        // 渦が追加されたイベント発行
        public function addProfound(prf:Profound):void
        {
            dispatchEvent(new ProfoundEvent(ProfoundEvent.ADD_PRF, prf));
        }

        // 渦Stateが更新された
        public function updateProfoundState(prf:Profound):void
        {
            log.writeLog(log.LV_FATAL, this, "updateProfoundStaten");
            dispatchEvent(new ProfoundEvent(ProfoundEvent.UPDATE_PRF, prf));
        }

        // 渦戦闘が終了した
        public function finishProfound(prf:Profound):void
        {
            log.writeLog(log.LV_DEBUG, this, "finishProfound");
            dispatchEvent(new ProfoundEvent(ProfoundEvent.FINISH_PRF, prf));
        }

        // 渦が消滅したイベント発行
        public function vanishProfound(prfId:int):void
        {
            var prf:Profound = Profound.getProfoundForId(prfId);
            if (prf) {
                dispatchEvent(new ProfoundEvent(ProfoundEvent.VANISH_PRF, prf));
            }
        }

        // 使用した時
        public  override function sendItem(id:int):void
        {
            _server.csAvatarUseItem(id);
        }

        // ボス戦開始
        public function bossDuelStart(invId:int,turn:int,useAp:int):void
        {
            _server.csBossDuelStart(invId,turn,useAp);
        }

        // 新規ノーティスの要求
        public function checkNewNotice():void
        {
            // log.writeLog(log.LV_FATAL, this, "check new notice");
            if (connected)
            {
                _server.csRequestNotice();
            }
        }

        // レイドのノーティスを読み込み
        public function addNotice(body:String):void
        {
            // log.writeLog(log.LV_DEBUG, this, "add notice",body);
            // コマンドごとに割る
            var c_set:Array =  body.split("|");
            if (c_set.length > 0) {
                c_set.forEach(function(item:*, index:int, array:Array):void
                              {
                                  if ( item != "") {
                                      var arg_set:Array = item.split(":");
                                      var n_type:int = int(arg_set[0]);
                                      var prfId:int = 0;
                                      if (LobbyNotice.TYPE_FIN_PRF_WIN <= n_type && n_type <= LobbyNotice.TYPE_FIN_PRF_RANKING) {
                                          prfId = ProfoundNotice.setNotice(arg_set[0],arg_set[1]);
                                      } else {
                                          LobbyNotice.setNotice(arg_set[0],arg_set[1]);
                                          log.writeLog(log.LV_DEBUG, this, "addNotice 2",arg_set);
                                          prfId = int(arg_set[1].split(",").shift());
                                      }
                                      // 情報更新用にProfoundIdをリストに保持
                                      _updatePrfIdList.push(prfId);
                                  }
                              });
                dispatchEvent(new Event(NOTICE_UPDATE));
            }
        }

        // Inventoryの情報を更新
        public function updateProfoundInventory():void
        {
            log.writeLog(log.LV_FATAL, this, "update profound inventory",_updatePrfIdList);
            // Profoundを読み込み待ちに変更
            Profound.isLoaded = false;
            _server.csRequestUpdateInventory(_updatePrfIdList);
            // Listをからに直す
            _updatePrfIdList = [];
        }

        // 渦をギブアップ
        public function giveUpProfound(prfId:int):void
        {
            if (connected) {
                log.writeLog(log.LV_FATAL, this, "give up",prfId);
                var invId:int = ProfoundInventory.getProfoundInventoryIdForPrfId(prfId);
                _server.csGiveUpProfound(invId);
            }
        }

        // 渦の消失チェック
        public function checkVanishProfound(prfId:int):void
        {
            if (connected) {
                log.writeLog(log.LV_FATAL, this, "check vanish",prfId);
                var invId:int = ProfoundInventory.getProfoundInventoryIdForPrfId(prfId);
                _server.csCheckVanishProfound(invId);
            }
        }

        // 渦の報酬チェック
        public function checkProfoundReward():void
        {
            if (connected) {
                log.writeLog(log.LV_FATAL, this, "check reward");
                _server.csCheckProfoundReward();
            }
        }

        // BossState更新
        public function updateBossState(prfId:int,state:int):void
        {
            log.writeLog(log.LV_INFO, this, "updateBossState",state);
            var resendStatus:int = Profound.getResendStatus(prfId,state);
            if (resendStatus == Profound.PRF_UPDATE) {
                log.writeLog(log.LV_FATAL, this,"updateBossState PRF_UPDATE");
                var prf:Profound = Profound.getProfoundForId(prfId);
                prf.state = state;
                // 渦更新イベント発行
                updateProfoundState(prf);
            }
        }

        /**
         * レイドのスタート
         *
         */
        public override function start(view:Thread):void
        {
            // レイドサーバにつなぐ
            _server.connect();
            _view = RaidView(view); // 非常手段
            waitConnectThread.start();
        }

        // connecetWaitスレッドが使うスタートコマンド
        public override function waitStart():void
        {
            log.writeLog(log.LV_FATAL, this, "start", _server.state);
            _server.start(this);

        }

        // viewにシーケンスを追加する
        public override function addViewSequence(thread:Thread):void
        {
            _view.addSequence(thread);
        }

        // 終了を待たないシーケンスとして追加する
        public  override function addNoWaitViewSequence(thread:Thread):void
        {
            _view.addSequence(new ClousureThread(function():void{thread.start();}));
        }

        // Viewを一定期間止める
        public override  function sleepViewSequence(time:int):void
        {
            addViewSequence(new SleepThread(time));
        }

        // Viewにシーケンスををとめる
        public  override function stopViewSequence():void
        {
            _view.finishGame();
        }

        private function abortGame():void
        {
            addViewSequence(new ClousureThread(_view.abortGame));
            addViewSequence(new ClousureThread(Duel.instance.abortGame));
        }

        // サーバのコマンドを遅延評価する
        public override function commandUpdate():Boolean
        {
            return _server.commandShift();
        }

        // バトル開始
        public function battle():void
        {
            dispatchEvent(new Event(BATTLE_START));
        }

        // バトル開始失敗
        public function battleStartFailed():void
        {
            dispatchEvent(new Event(BTL_START_FAILED));
        }

        // サーバにデュエルの準備を知らせる
        public override function startOk():void
        {
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.startOk();
             }
        }

        // デバッグコードを送る
        public override function sendDebugCode(code:int):void
        {
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.csDebugCode(code);
             }
        }

        public function setDeckEvent():void
        {
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.setDeckEditorEvent();
             }
        }
        public function unsetDeckEvent():void
        {
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.unsetDeckEditorEvent();
             }
        }


        /**
         * ゲームの終了
         *
         */
        public override  function exit():void
        {
            super.exit()
            // Duel.instance.abortGame();
        }

        public function finishedGame():void
        {
            log.writeLog(log.LV_DEBUG, this, "finishedGame", "state",_state);
            // ゲーム中ならゲームロビーに戻す
            if (_state == GAME_STAGE)
            {
                log.writeLog(log.LV_DEBUG, this, "ゲームを止める",_view);
                abortGame();
            }
        }

        // 渦のログを表示
        public function setPrfMessageStrData(str:String):void
        {
            log.writeLog(log.LV_INFO, this,"get prf messeage str data", str);
            ProfoundMessage.setMessage(str);
        }

        // コントローラからビューを取り除く
        public override function removeView():void
        {
            super.removeView();
            _view =null;
        }

        public function playBGM():void
        {
            if (_bgmPlaying)
            {
                return;
            }else{
                _bgm.loopSound(0);
                _bgmPlaying = true;
            }

        }

        public function stopBGM():void
        {
            _bgm.fade(0,2);
            _bgmPlaying = false;
        }

    }
}