package controller
{
    import flash.system.System;
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
     * レイドデータコントロールクラス
     *
     */
    public class RaidDataCtrl extends BaseCtrl
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "レイドデータ";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Raid data";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "突擊頻道";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "突击频道";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Raid data";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS	:String = "Reid chat";


        public static const BOSS_HP_UPDATE:String   = "boss_hp_update";
        public static const RAID_INPROGRESS:String  = "raid_inprogress";
        public static const RAID_SOLVED:String      = "raid_solved";
        public static const BATTLE_START:String     = "battle_start";
        public static const BTL_START_FAILED:String = "btl_start_failed";
        public static const NOTICE_UPDATE:String    = "notice_update";
        public static const GET_HASH:String         = "get_hash";


        protected static var __instance:RaidDataCtrl; // シングルトン保存用

        private var _server:RaiddataServer;
        private var _connected:Boolean = false;        // Serverにコネクトしているか？
        private var _updateEnable:Boolean = true;

        private var _battle:Boolean = false;

        // 更新されたInventoryのIDリスト
        private var _updatePrfIdList:Array = [];


        public function RaidDataCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            // ロビーサーバを登録
            _server = RaiddataServer.instance;
            init();
            setHandler();
        }
        private function setHandler():void
        {
        }


        private static function createInstance():RaidDataCtrl
        {
            return new RaidDataCtrl(arguments.callee);
        }

        public static function get instance():RaidDataCtrl
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
            waitConnectThread.start();
            //waitConnectThreadStart();
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
                log.writeLog(log.LV_DEBUG, this, "vanishProfound",prf.id);
                dispatchEvent(new ProfoundEvent(ProfoundEvent.VANISH_PRF, prf));
            }
        }

        // 使用した時
        public  override function sendItem(id:int):void
        {
            _server.csAvatarUseItem(id);
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
                                      // log.writeLog(log.LV_DEBUG, this, "add notice 1 ",item);
                                      // var arg_set:Array = item.split(":");
                                      var arg_set:Array = [];
                                      arg_set.push(item.slice(0,item.indexOf(":")));
                                      arg_set.push(item.slice(item.indexOf(":")+1,item.length))
                                      var n_type:int = int(arg_set[0]);
                                      var prfId:int = 0;
                                      // 渦関連のノーティスのみ受け取る
                                      if (LobbyNotice.PRF_TYPES.indexOf(n_type) != -1) {
                                          prfId = ProfoundNotice.setNotice(arg_set[0],arg_set[1]);
                                      }
                                      // 情報更新用にProfoundIdをリストに保持
                                      _updatePrfIdList.push(prfId);
                                  }
                              });
                dispatchEvent(new Event(NOTICE_UPDATE));
            }
        }

        // レコード更新
        public function achievementUpdate():void
        {
            dispatchEvent(new Event(NOTICE_UPDATE));
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
            log.writeLog(log.LV_DEBUG, this, "check vanish",prfId,connected);
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

        // ランキング更新
        public function updateRankList(prfId:int, start:int, count:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "rank request");
                var invId:int = ProfoundInventory.getProfoundInventoryIdForPrfId(prfId);
                _server.csRequestRankingList(invId,start,count);
            }
        }

        // 自分のランク更新
        public function updateMyRank(prfId:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "rank request");
                var invId:int = ProfoundInventory.getProfoundInventoryIdForPrfId(prfId);
                _server.csRequestRankInfo(invId);
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

        public function getProfoundForHash(hash:String):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "get profound",hash);
                _server.csGetProfound(hash);
            }
        }

        public function requestProfoundHash(id:int):void
        {
            if (connected)
            {
                _server.csRequestProfoundHash(id);
            }
        }

        public function getProfoundHash(prfId:int,hash:String,copyType:int,setDefeatReward:Boolean):void
        {
            var prf:Profound = Profound.getProfoundForId(prfId);
            if (prf) {
                prf.copyType = copyType;
                prf.setDefeatReward = setDefeatReward;
            }
            dispatchEvent(new ProfoundEvent(ProfoundEvent.GET_HASH,null,0,0,hash));
        }

        public function changeConfig(id:int,type:int,setDefeatReward:Boolean):void
        {
            if (connected)
            {
                _server.csChangeProfoundConfig(id,type,setDefeatReward);
            }
        }

        public function sendProfoundFriend(prfId:int):void
        {
            if (connected)
            {
                _server.csSendProfoundFriend(prfId);
            }
        }

        public function profoundNoticeClear(n:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "profoundNoticeClear");
                _server.csProfoundNoticeClear(n);
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


    }
}