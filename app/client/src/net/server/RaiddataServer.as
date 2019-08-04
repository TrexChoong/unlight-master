package net.server
{
    import flash.events.Event;
    import net.*;
    import net.command.*;
    import model.*;
    import model.events.*;
    import controller.*;

    /**
     * レイドの情報を扱うクラス
     *
     */
    public class RaiddataServer extends Server
    {

        private var _command:RaiddataCommand;
        private var _crypted_sign:String;
        private var _ctrl:RaidDataCtrl;
        private var _edit:DeckEditor;

        private static var __instance:RaiddataServer;

        // 初期化 サーバを取得
        public function RaiddataServer(caller:Function = null)
         {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor."); 
            _command = new RaiddataCommand(this);
         }

        private static function createInstance():RaiddataServer
        {
            return new RaiddataServer(arguments.callee);
        }

        public static function get instance():RaiddataServer
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }

        // コンフィグからのロード
        protected override function configLoad():void
        {
            log.writeLog(log.LV_DEBUG, this,"configload");
            address = Config.raidDataServerInfo.address;
            port = Config.raidDataServerInfo.port;
            log.writeLog(log.LV_DEBUG, this,"configload",address,port);
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("","","","","","","RDS["+address+":"+port.toString()+"] ");
            }
        }

        protected override function get command():Command
        {
            return _command;
        }

        public function start(ctrl:RaidDataCtrl):void
        {
            log.writeLog(log.LV_DEBUG, this,"start");
            _ctrl= ctrl;
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"raid data p_session", player.session);
            host.setSessionKey(player.session);
        }

        // 終了
        public override function exit():void
        {
            super.exit();
        }

        // オーバライド前提のHeartBeatHandler
        protected override function heartBeatHandler(e:Event):void
        {
            host.sendCommand(_command.csKeepAlive());
        }


        public function getPort():int
        {
            return port;
        }


        public function getHost():String
        {
            return address;
        }




        /**
         * 受信コマンド
         *
         */

        // ネゴシエーション処理の返答
        public function negoCert(crypted_sign:String, ok:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"negotiated");
            host.sendCommand(_command.login("yes, ok.",crypted_sign));
        }

        // ログインOK
        public function loginCert(msg:String, hash_key:String):void
        {
            log.writeLog(log.LV_INFO, this,"server messeage", msg);
        }

        // ログイン失敗
        public function loginFail():void
        {
            log.writeLog(log.LV_FATAL, this,"Login Failed!!");
        }

        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }

        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {
            _ctrl.errorAlert(e);
            if (Const.ERROR_PRF_FINISHED == e ||
                Const.ERROR_PRF_HAVE_MAX_OVER == e ||
                Const.ERROR_PRF_MEMBER_LIMIT_OVER == e ||
                Const.ERROR_PRF_ALREADY_HAD == e ||
                Const.ERROR_PRF_WAS_GIVE_UP == e)
            {
                // 渦の取得失敗なので、念の為Hashを無効化
                Profound.urlProfoundHash = "";
            }
        }


        public function scResendProfoundInventory(dataId:int,hash:String,closeAt:String,createdAt:String,state:int,mapId:int,posIdx:int,copyType:int,setDefeatReward:Boolean,nowDamage:int,finderId:int,finderName:String,invId:int,profoundId:int,deckIdx:int,charaCardDmg1:int,charaCardDmg2:int,charaCardDmg3:int,damageCount:int,invState:int,deckStatus:int):void
        {
            log.writeLog(log.LV_FATAL, this,"scResendProfoundInventory:","dataId",dataId,"hash",hash,"closeAt",closeAt,"state",state,"mapId",mapId,"posIdx",posIdx,"copyType",copyType,"setDefeatReward",setDefeatReward,"nowDamage",nowDamage,"finderId",finderId,"finderName",finderName,"invId",invId,"profoundId",profoundId,"deckIdx",deckIdx,"charaCardDmg1",charaCardDmg1,"charaCardDmg2",charaCardDmg2,"charaCardDmg3",charaCardDmg3,"damageCount",damageCount,"invState",invState,"deckStatus",deckStatus);

            var resendStatus:int = Profound.getResendStatus(profoundId,state);
            var prf:Profound = Profound.addProfound(profoundId,dataId,hash,closeAt,createdAt,state,mapId,posIdx,copyType,setDefeatReward,nowDamage,finderId,finderName);
            var giveUp:Boolean = false;
            if (prf) {
                giveUp = ProfoundInventory.isGiveUp(profoundId,invState);
                ProfoundInventory.updateProfoundInventory(invId,profoundId,deckIdx,charaCardDmg1,charaCardDmg2,charaCardDmg3,damageCount,invState);
                // デッキ情報を更新
                if (deckIdx != 0 && CharaCardDeck.decks[deckIdx]) {
                    CharaCardDeck.decks[deckIdx].deckStateUpdate(deckStatus,charaCardDmg1,charaCardDmg2,charaCardDmg3);
                }
            }

            if (resendStatus == Profound.PRF_NEW) {
                // 渦追加イベント発行
                _ctrl.addProfound(prf);
            } else if (resendStatus == Profound.PRF_UPDATE) {
                // 渦更新イベント発行
                _ctrl.updateProfoundState(prf);
            } else if (resendStatus == Profound.PRF_FINISH) {
                // 渦更新イベント発行
                _ctrl.finishProfound(prf);
            } else if (resendStatus == Profound.PRF_VANISH || giveUp) {
                // 渦消失イベント発行
                _ctrl.vanishProfound(prf.id);
            }
        }

        public function scResendProfoundInventoryFinish():void
        {
            Profound.isLoaded = true;
        }

        // アイテムの使用
        public function scUseItem(inv_id:int):void
        {
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // カレントデッキをかえるのに成功
        public function scUpdateCurrentDeckIndex(index:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateCurrentDeckIndex");
            player.avatar.currentDeck = index;
        }

        public function scAddNotice(body:String):void
        {
            log.writeLog(log.LV_INFO, this,"scAddNotice", body);
            _ctrl.addNotice(body);
        }

        public function scUpdateRank(prfId:int, rank:int, point:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateRank", prfId,rank,point);
            var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(prfId);
            if (prfRank) prfRank.updateMyRank(rank,point);
        }

        public function scUpdateRankingList(prfId:int, start:int, rankList:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateTotalDuelRankingList", start, rankList);
            var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(prfId);
            if (prfRank) prfRank.updateData(start,arraySeparateThree(rankList.split(",")));
        }

        // BossHp更新
        public function scSendBossDamage(prfId:int,damage:int,strData:String,state:int,stateUpdate:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "sc SendBossDamage",damage,state,stateUpdate);
            _ctrl.sendBossDamage(prfId,damage,strData,state,stateUpdate);
        }

        // BossHp更新
        public function scUpdateBossHp(prfId:int,damage:int):void
        {
            log.writeLog(log.LV_INFO, this, "sc UpdateBossHP",damage);
            _ctrl.setUpdateBossHP(prfId,damage);
        }

        // アチーブメントクリア
        public function scAchievementClear(achiID:int, itemType:int, itemID:int, itemNum:int, cType:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAchievementClear", achiID, itemType, itemID, itemNum, cType);
            LobbyNotice.setAchievementSuccessInfo(achiID, itemType, itemID, itemNum, cType);
            AchievementInventory.finishAchievementInventory(achiID);
            _ctrl.achievementUpdate();
        }

        // アチーブメント追加
        public function scAddNewAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAddNewAchievement", achiID);
            LobbyNotice.setAchievementNewInfo(achiID);
            new AchievementInventory(achiID, Const.ACHIEVEMENT_STATE_START)
            _ctrl.achievementUpdate();
        }

        // アチーブメント削除
        public function scDeleteAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scDeleteAchievement", achiID);
            AchievementInventory.deleteAchievementInventory(achiID);
        }

        // アチーブメント情報をアップデート
        public function scUpdateAchievementInfo(achievements:String,achievementsState:String,achievementsProgress:String,achievementsEndAt:String,achievementsCode:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateAchievementInfo", achievements,achievementsState,achievementsProgress,achievementsEndAt,achievementsCode);
            if (Player.instance && Player.instance.avatar) {
                Player.instance.avatar.achievementUpdate(string2intArray(achievements),
                                                         string2intArray(achievementsState),
                                                         achievementsProgress.split(/_/),
                                                         achievementsEndAt.split(","),
                                                         achievementsCode.split(","));
            }
        }

        // 渦のHashを取得
        public function scGetProfoundHash(prfId:int,hash:String,copyType:int,setDefeatReward:Boolean):void
        {
            _ctrl.getProfoundHash(prfId,hash,copyType,setDefeatReward);
        }

        /**
         * 送信コマンド
         *
         */
        // アイテムを使用する
        public function csAvatarUseItem(invId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar use item");
            host.sendCommand(_command.csAvatarUseItem(invId));
        }

        // Raid関連Noticeの取得
        public function csRequestNotice():void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestNotice");
            host.sendCommand(_command.csRequestNotice());
        }

        // 渦をギブアップ
        public function csGiveUpProfound(invId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs GiveUpProfound");
            host.sendCommand(_command.csGiveUpProfound(invId));
        }

        // 渦の消失チェック
        public function csCheckVanishProfound(invId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs CheckVanishProfound");
            host.sendCommand(_command.csCheckVanishProfound(invId));
        }

        // 渦の報酬チェック
        public function csCheckProfoundReward():void
        {
            log.writeLog(log.LV_INFO, this, "cs CheckProfoundReward");
            host.sendCommand(_command.csCheckProfoundReward());
        }

        // Noticeから更新を受け取ったInventoryの再取得
        public function csRequestUpdateInventory(idList:Array):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestUpdateInventory");
            host.sendCommand(_command.csRequestUpdateInventory(idList.join(",")));
        }

        // BossHp更新
        public function csUpdateBossHP(prfId:int,nowDamage:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs UpdateBossHP");
            host.sendCommand(_command.csUpdateBossHp(prfId,nowDamage));
        }

        // ランキング一覧の取得
        public function csRequestRankingList(invId:int, offset:int, count:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestRankingList", invId, offset, count);
            host.sendCommand(_command.csRequestRankingList(invId, offset, count));
        }

        // ランキング情報の取得
        public function csRequestRankInfo(invId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestRankInfo");
            host.sendCommand(_command.csRequestRankInfo(invId));
        }

        // 渦Noticeのみ削除
        public function csProfoundNoticeClear(num:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs ProfoundNoticeClear");
            host.sendCommand(_command.csProfoundNoticeClear(num));
        }

        // DeckEditorのイベントハンドラを登録
        private function editStartHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "editStartHandler");
            _edit.addEventListener(EditDeckEvent.CHANGE_CURRENT_DECK, csUpdateCurrentDeckIndexHandler);
        }

        // DeckEditorのイベントハンドラを消去
        private function editEndHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "editEndHandler");
            _edit.removeEventListener(EditDeckEvent.CHANGE_CURRENT_DECK, csUpdateCurrentDeckIndexHandler);
        }

        // デッキを変更
        public function csUpdateCurrentDeckIndexHandler(e:EditDeckEvent):void
        {
            log.writeLog(log.LV_INFO, this, "cs UpdateCurrentDeckIndex");
            host.sendCommand(_command.csUpdateCurrentDeckIndex(e.index));
        }

        // デッキエディット準備
        public function setDeckEditorEvent():void
        {
            _edit = DeckEditor.instance;
            _edit.addEventListener(EditDeckEvent.CHANGE_CURRENT_DECK, csUpdateCurrentDeckIndexHandler);
        }

        // デッキエディット準備
        public function unsetDeckEditorEvent():void
        {
            _edit.removeEventListener(EditDeckEvent.CHANGE_CURRENT_DECK, csUpdateCurrentDeckIndexHandler);
            _edit = null;
        }

        // 渦の取得
        public function csGetProfound(hash:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs GetProfound", hash);
            host.sendCommand(_command.csGetProfound(hash));
        }

        // 渦のHash取得
        public function csRequestProfoundHash(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestProfoundHash", id);
            host.sendCommand(_command.csRequestProfoundHash(id));
        }

        // 渦の設定変更
        public function csChangeProfoundConfig(id:int,type:int,setDefeatReward:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "cs ChangeProfoundCopyType", id,type,setDefeatReward);
            host.sendCommand(_command.csChangeProfoundConfig(id,type,setDefeatReward));
        }

        // フレンドにも渦を設定
        public function csSendProfoundFriend(prfId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs SendProfoundFriend", prfId);
            host.sendCommand(_command.csSendProfoundFriend(prfId));
        }

    }
}