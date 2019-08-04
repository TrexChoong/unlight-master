package net.server
{
    import flash.geom.*;
    import flash.events.Event;
    import net.*;
    import net.command.*;
    import model.*;
    import model.events.*;
    import model.utils.ClientLog;
    import controller.*;
    import view.*;

    /**
     * チャットの情報を扱うクラス
     *
     */
    public class QuestServer extends Server
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_GET:String = "を獲得しました。";
        CONFIG::LOCALE_JP
        private static const _TRANS_INFO:String = "情報";
        CONFIG::LOCALE_JP
        private static const _TRANS_USE		:String = "を使用しました。";

        CONFIG::LOCALE_EN
        private static const _TRANS_GET	:String = "You received ";
        CONFIG::LOCALE_EN
        private static const _TRANS_INFO:String = "Information";
        CONFIG::LOCALE_EN
        private static const _TRANS_USE		:String = "You used ";

        CONFIG::LOCALE_TCN
        private static const _TRANS_GET	:String = "獲取了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_INFO	:String = "信息";
        CONFIG::LOCALE_TCN
        private static const _TRANS_USE		:String = "使用";

        CONFIG::LOCALE_SCN
        private static const _TRANS_GET:String = "已获得";
        CONFIG::LOCALE_SCN
        private static const _TRANS_INFO:String = "信息";
        CONFIG::LOCALE_SCN
        private static const _TRANS_USE		:String = "已使用";

        CONFIG::LOCALE_KR
        private static const _TRANS_GET:String = "를 획득하였습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_INFO:String = "정보";
        CONFIG::LOCALE_KR
        private static const _TRANS_USE		:String = "을(를) 사용했습니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_GET:String = "Vous recevez ";
        CONFIG::LOCALE_FR
        private static const _TRANS_INFO:String = "Information";
        CONFIG::LOCALE_FR
        private static const _TRANS_USE		:String = "Vous avez utilisé ";

        CONFIG::LOCALE_ID
        private static const _TRANS_GET:String = "を獲得しました。";
        CONFIG::LOCALE_ID
        private static const _TRANS_INFO:String = "情報";
        CONFIG::LOCALE_ID
        private static const _TRANS_USE		:String = "を使用しました。";

        CONFIG::LOCALE_TH
        private static const _TRANS_GET:String = "ได้รับ";
        CONFIG::LOCALE_TH
        private static const _TRANS_INFO:String = "ข้อมูล";
        CONFIG::LOCALE_TH
        private static const _TRANS_USE     :String = "ใช";

        private var _command:QuestCommand;
        private var _crypted_sign:String;
        private var _ctrl:QuestCtrl;
//        private var _gameCtrl:GameCtrl;
        private var _match:Match;
        private var _duel:Duel;

        private static var __instance:QuestServer;

        // 初期化 サーバを取得
        public function QuestServer(caller:Function = null)
         {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            _command = new QuestCommand(this);
            QuestLog.setLoaderFunc(getQuestLogInfo);
         }

        private static function createInstance():QuestServer
        {
            return new QuestServer(arguments.callee);
        }

        public static function get instance():QuestServer
        {
            if( __instance == null ){
                __instance = createInstance();
           }
            return __instance;
        }



        // コンフィグからのロード
        protected override function configLoad():void
        {
            log.writeLog(log.LV_INFO, this,"configload");
            address = Config.questServerInfo.address;
            port = Config.questServerInfo.port;
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("","","QS["+address+":"+port.toString()+"] ");
            }
        }


        protected override function get command():Command
        {
            return _command;
        }

        // 開始
        public function start(ctrl:QuestCtrl):void
        {
            _ctrl= ctrl;
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"quest p_session", player.session);
            host.setSessionKey(player.session);
        }

        // 終了
        public override function exit():void
        {
            host.sendCommand(_command.logout());
            super.exit();
        }

        // オーバライド前提のHeartBeatHandler
        protected override function heartBeatHandler(e:Event):void
        {
            host.sendCommand(_command.csKeepAlive());
        }



        /**
         * 送信コマンド
         *
         */

        // アバターのアップデートをチェックする
        public function csAvatarUpdateCheck():void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar update check");
            host.sendCommand(_command.csAvatarUpdateCheck());
        }

        // アイテムを使用する
        public function csAvatarUseItem(invId:int,questMapNo:int=0):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar use item");
            host.sendCommand(_command.csAvatarUseItem(invId,questMapNo));
        }

        // アイテムを購入
        public function csAvatarBuyItem(shopId:int, itemId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar buy item", shopId, itemId);
            host.sendCommand(_command.csAvatarBuyItem(shopId, itemId));
        }

        // クエストを取得
        public function csGetQuest(mapId:int, timer:int):void
        {
            log.writeLog(log.LV_INFO, this,"get quest", mapId);
            host.sendCommand(_command.csGetQuest(mapId,timer));
        }

        // クエストマップを取得
        public function csRequestQuestMapInfo(region:int):void
        {
            log.writeLog(log.LV_INFO, this,"get quest map");
            host.sendCommand(_command.csRequestQuestMapInfo(region));
        }


        public function csGetQuestLogPageInfo(page:int):void
        {
            log.writeLog(log.LV_INFO, this,"questLog info page request");
            host.sendCommand(_command.csGetQuestLogPageInfo(page));
        }

        // 指定したIDのクエストログを取得する
        public function getQuestLogInfo(id:int):void
        {
            log.writeLog(log.LV_INFO, this,"questLog info request");
            host.sendCommand(_command.csGetQuestLogInfo(id));
        }

        // クエストログを書き込む
        public function csSetQuestLogInfo(content:String):void
        {
            log.writeLog(log.LV_INFO, this,"questLog info request");
            host.sendCommand(_command.csSetQuestLog(content));
        }

        // クエストを確認した
        public function csQuestConfirm(id:int,deckIndex:int):void
        {
            log.writeLog(log.LV_INFO, this,"quest confirm",id, deckIndex);
            host.sendCommand(_command.csQuestConfirm(id,deckIndex));
        }

        // クエストを確認した
        public function csQuestCheckFind(id:int):void
        {
            log.writeLog(log.LV_INFO, this,"quest find Check",id);
            host.sendCommand(_command.csQuestCheckFind(id));
        }
        // クエストをスタート
        public function csQuestStart(id:int,deckIndex:int):void
        {
            log.writeLog(log.LV_INFO, this,"quest start",id);
            host.sendCommand(_command.csQuestStart(id,deckIndex));
        }

        // クエストを断念
        public function csQuestAbort(id:int, deckIndex:int):void
        {
            log.writeLog(log.LV_INFO, this,"quest abort",id);
            host.sendCommand(_command.csQuestAbort(id,deckIndex));
        }

        // クエストを削除
        public function csQuestDelete(id:int):void
        {
            log.writeLog(log.LV_INFO, this,"quest delete",id);
            host.sendCommand(_command.csQuestDelete(id));
        }

        // クエストを進めた
        public function csQuestNextLand(id:int, deckIndex:int, nextNo:int):void
        {
            log.writeLog(log.LV_INFO, this,"quest next land",id, nextNo);
            host.sendCommand(_command.csQuestNextLand(id, deckIndex, nextNo));
        }

        // クエストを友達あげる
        public function csSendQuest(avatarID:int, questInv:int):void
        {
            log.writeLog(log.LV_INFO, this,"send quest",avatarID, questInv);
            host.sendCommand(_command.csSendQuest(avatarID, questInv));
        }


        public function startOk():void
        {
            log.writeLog(log.LV_INFO, this,"Game Start OK");
            host.sendCommand(_command.csStartOk());
        }

        private function setDirectionHandler(e:DirectionEvent):void
        {
            log.writeLog(log.LV_INFO, this,"Move Direction Update");
            host.sendCommand(_command.csSetDirection(e.dir));
        }

        private function addMoveCardHandler(e:ReplaceCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"ActionCard add move_table");
            host.sendCommand(_command.csMoveCardAdd(e.ac.id, e.index, e.ac.up));
        }

        private function removeMoveCardHandler(e:ReplaceCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"ActionCard remove move_table");
            host.sendCommand(_command.csMoveCardRemove(e.ac.id, e.index));
        }

        private function addAttackCardHandler(e:ReplaceCardEvent):void
        {

            log.writeLog(log.LV_INFO, this,"Attack ActionCard add battle_table");
            host.sendCommand(_command.csAttackCardAdd(e.ac.id, e.index, e.ac.up));
        }

        private function removeAttackCardHandler(e:ReplaceCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"Attack ActionCard remove attack_table");
            host.sendCommand(_command.csAttackCardRemove(e.ac.id, e.index));
        }

        private function addDeffenceCardHandler(e:ReplaceCardEvent):void
        {

            log.writeLog(log.LV_INFO, this,"Deffence ActionCard add battle_table");
            host.sendCommand(_command.csDeffenceCardAdd(e.ac.id, e.index, e.ac.up));
        }

        private function removeDeffenceCardHandler(e:ReplaceCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"Deffence ActionCard remove battle_table");
            host.sendCommand(_command.csDeffenceCardRemove(e.ac.id, e.index));
        }

        private function rotateCardHandler(e:ReplaceCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"ActionCard rotate");
            host.sendCommand(_command.csCardRotate(e.ac.id, e.table, e.index, !e.ac.up));
        }

        private function initDoneHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"Init Done");
            host.sendCommand(_command.csInitDone("",""));

        }

        private function moveDoneHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"Move Done to:");
            host.sendCommand(_command.csMoveDone(_duel.plEntrant.distance, "", ""));
        }

        private function attackDoneHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"Attack Done ");
            host.sendCommand(_command.csAttackDone("", ""));
        }

        private function deffenceDoneHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"Deffence Done ");
            host.sendCommand(_command.csDeffenceDone("", ""));
        }

        // キャラ変更を決定したときのハンドラ
        private function charaChangeHandler(e:CharaChangeEvent):void
        {
            log.writeLog(log.LV_INFO, this,"Chara Change");
            host.sendCommand(_command.csCharaChange(e.index));
        }

        private function rewardUpHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"Reward UP!");
            host.sendCommand(_command.csResultUp());
        }

        private function rewardDownHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"Reward DOWN!");
            host.sendCommand(_command.csResultDown());
        }

        private function rewardCancelHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"Reward CANCEL!");
            host.sendCommand(_command.csResultCancel());
        }

        private function rewardRetryHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"Reward RETRY!");
            host.sendCommand(_command.csRetryReward());
        }

        // デバッグコードを送る
        public function csDebugCode(code:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs debug code");
            host.sendCommand(_command.csDebugCode(code));
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
            log.writeLog(log.LV_INFO, this,"login cert");
        }

        // ログイン失敗
        public function loginFail():void
        {
            log.writeLog(log.LV_FATAL, this,"Login Failed!!");
        }


        // 行動力を消費
        public function scEnergyInfo(energy:int,remainTime:int):void
        {
            log.writeLog(log.LV_FATAL, this, "++enegy info",energy, remainTime);
            player.avatar.remainTime = remainTime;
            player.avatar.energy = energy;
        }

        // 行動力MAXを更新
        public function scUpdateEnergyMax(energyMax:int):void
        {
            player.avatar.energyMax = energyMax;
        }

        // クエスト数MAXを更新
        public function scUpdateQuestMax(questMax:int):void
        {
            player.avatar.questMax = questMax;
        }


//         // 行動力を回復
//         public function scRecoveryEnergy(energy:int):void
//         {
//             player.avatar.energy = energy;
//         }

        // クエストを取得
        public function scGetQuest(invId:int, questId:int, timer:int,pow:int, qs:int, baName:String):void
        {
            log.writeLog(log.LV_INFO, this, "sc get quest",qs);
            AvatarQuestInventory.addAvatarQuestInventory(invId, Quest.ID(questId), timer, pow, qs, baName);

//             // ハロウィン限定チェック
//             if (AvatarQuestInventory.quests.length > 2)
//             {
//                 LobbyCtrl.instance.avatarUpdateCheck();
//                 LobbyCtrl.instance.achievementClearCheck();
//             }
        }

        // 経験値を回復
        public function scGetExp(exp:int):void
        {
//             log.writeLog(log.LV_INFO, this, "sc get exp");
//             player.avatar.exp = exp;
        }

        // レベルアップ
        public function scLevelUp(level:int):void
        {
//             log.writeLog(log.LV_INFO, this, "sc level up");
//             player.avatar.level = level;
            ClientLog.write( ClientLog.GOT_LEVEL, level, true );
        }

        // ジェムの更新
        public function scUpdateGems(gems:int):void
        {
            log.writeLog(log.LV_INFO, this, "sc update gems");
            player.avatar.gems = gems;
        }

        // アイテムの取得
        public function scGetItem(inv_id:int,item_id:int):void
        {
            AvatarItemInventory.addAvatarItemInventory(inv_id, AvatarItem.ID(item_id));
            ClientLog.write( ClientLog.GOT_ITEM, item_id, true );
        }

        // アイテムの取得
        public function scGetSlotCard(inv_id:int, kind:int, card_id:int):void
        {
            switch (kind+1)
            {
            case InventorySet.TYPE_WEAPON:
                WeaponCardInventory.addWeaponCardInventory(inv_id, WeaponCard.ID(card_id));
                break;
            case InventorySet.TYPE_EQUIP:
                EquipCardInventory.addEquipCardInventory(inv_id, EquipCard.ID(card_id));
                break;
            case InventorySet.TYPE_EVENT:
                EventCardInventory.addEventCardInventory(inv_id, EventCard.ID(card_id));
                break;
            }
            var type:int = kind+1;
            var setData:Array = [ type, card_id ];
            ClientLog.write( ClientLog.GOT_SLOT_CARD, setData, true );
        }

        // アイテムの取得
        public function scGetCharaCard(inv_id:int, card_id:int):void
        {
            log.writeLog(log.LV_INFO, this,"get chara card inventory ID is", inv_id, card_id);

            CharaCardDeck.binder.addCharaCardInventory(new CharaCardInventory(inv_id, CharaCard.ID(card_id), 0, 0));

            ClientLog.write( ClientLog.GOT_CHARA_CARD, card_id, true );
        }


        // パーツの取得
        public function scGetPart(inv_id:int,part_id:int):void
        {
            new AvatarPartInventory(inv_id, AvatarPart.ID(part_id));
//             LobbyCtrl.instance.getPartsSuccess(part_id)
            ClientLog.write( ClientLog.GOT_AVATAR_PART, part_id, true );
        }

        // アイテムの使用
        CONFIG::LOCALE_JP
        public function scUseItem(inv_id:int):void
        {
//            Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name + "を使用しました。", "情報");
//            Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name  + _TRANS_USE, _TRANS_INFO);
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アイテムの使用
        CONFIG::LOCALE_EN
        public function scUseItem(inv_id:int):void
        {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アイテムの使用
        CONFIG::LOCALE_TCN
        public function scUseItem(inv_id:int):void
        {
//            Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name + "を使用しました。", "情報");
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アイテムの使用
        CONFIG::LOCALE_SCN
        public function scUseItem(inv_id:int):void
        {
//            Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name + "を使用しました。", "情報");
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        CONFIG::LOCALE_KR
        public function scUseItem(inv_id:int):void
        {
//            Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name + "を使用しました。", "情報");
//            Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name  + _TRANS_USE, _TRANS_INFO);
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アイテムの使用
        CONFIG::LOCALE_FR
        public function scUseItem(inv_id:int):void
        {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        CONFIG::LOCALE_ID
        public function scUseItem(inv_id:int):void
        {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        CONFIG::LOCALE_TH
        public function scUseItem(inv_id:int):void
        {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }


//         // アイテムの使用
//         public function scUseItem(inv_id:int):void
//         {
// //            Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name + "を使用しました。", "情報");
//             Alerter.showWithSize(_TRANS_USE_A1 + _TRANS_USE_A2, _TRANS_INFO);
//             AvatarItemInventory.removeAvatarItemInventory(inv_id);
//         }


        // 指定地域のクエストマップを取得
        public function scQuestMapInfo(region:int, map_ids:String):void
        {
            var ids:Array = string2intArray(map_ids);
            log.writeLog(log.LV_INFO, this,"scQuestMapInfo", region, ids);
            // コントローラーに渡す
            _ctrl.questMapUpdate(ids);
        }

        // クエストログのページのIDリストインフォ
        public function scQuestLogPageInfo(page:int, content_ids:String):void
        {
            log.writeLog(log.LV_INFO, this,"scQuestLogPageInfo", page, content_ids);
            var ids:Array = string2intArray(content_ids);
            var len:int = ids.length;
            // 配列に含まれるログにアクセスして読み込む
            for(var i:int = 0; i < len; i++)
            {
                QuestLog.ID(ids[i]);
            }
            QuestLog.updatePageInfo(page, ids);
        }

        // クエストログのインフォ
        public function scQuestLogInfo(id:int, content:String):void
        {
            // "101, 0, 100, test, testtesttesttest, #{QuestLog[31].created_at.to_i}"
            log.writeLog(log.LV_INFO, this,"scQuestLogInfo", id, content);
            var a:Array = content.split(",");
            var a_id:int = a[0];
            var typeNo:int = a[1];
            var typeId:int = a[2];
            var name:String = a[3];
            var body:String = a[4];
            var date:Number = Number(a[5]);
            QuestLog.updateParam(id, a_id, typeNo, typeId, name, body, date);
        }

        // クエストの状態をアップデート
        public function scQuestStateUpdate(invID:int,state:int,mapId:int):void
        {
            log.writeLog(log.LV_INFO, this, "scQuestStateUpdate",invID, state, mapId);
            if (AvatarQuestInventory.ID(invID)!=null)
            {
                log.writeLog(log.LV_INFO, this, "scQuestStateUpdate",invID, state, mapId);
                if (state == Const.QS_INPROGRESS)
                {
                    _ctrl.startSuccess();
                }else if(state == Const.QS_NEW)
                {
                    log.writeLog(log.LV_INFO, this, "findUpdate",invID, state, mapId);
                    AvatarQuestInventory.ID(invID).findQuest(mapId)
                }
                AvatarQuestInventory.ID(invID).status = state;

            }
        }




        // クエストのマップ進行状況が更新
        public function scQuestMapProgressUpdate(invID:int,progress:int):void
        {
            log.writeLog(log.LV_FATAL, this, "progress update",invID, progress );
            if (AvatarQuestInventory.ID(invID)!=null)
            {
                AvatarQuestInventory.ID(invID).quest.progress = progress
            }
        }
        // デッキの状態が更新
        public function scDeckStateUpdate(deckIndex:int,state:int, hp0:int, hp1:int, hp2:int):void
        {
            log.writeLog(log.LV_FATAL, this, "DECK STATE UPDATE!!!!!!",deckIndex, state, hp0,hp1,hp2);
            if (CharaCardDeck.decks[deckIndex]!=null)
            {
                CharaCardDeck.decks[deckIndex].deckStateUpdate(state, hp0, hp1, hp2);
            }
            _ctrl.checkRealMoneyShop(hp0+hp1+hp2)

        }

        // クエスト進行度を更新
        public function scQuestFlagUpdate(q:int):void
        {
            log.writeLog(log.LV_INFO, this, "quest update!!!!!!!!!!!!" , q);
            player.avatar.questFlag  = q;
        }

        // By_K2 (무한의탑 층 수 업데이트)
        public function scFloorCountUpdate(q:int):void
        {
            log.writeLog(log.LV_INFO, this, "floor count update!!!!!!!!!!!!" , q);
            player.avatar.floorCount = q;
        }

        // クエスト達成度度を更新
        public function scQuestClearNumUpdate(c:int):void
        {
            log.writeLog(log.LV_INFO, this, "quest clear num update!!!!!!!!!!!!" , c);
            player.avatar.questClearNum  = c;
        }

        // クエスト見つける時間更新
        public function scQuestFindAtUpdate(invID:int, findAt:int):void
        {
            log.writeLog(log.LV_INFO, this, "quest  find at update!!!!!!!!!!!!");
            if (AvatarQuestInventory.ID(invID)!=null)
            {
                AvatarQuestInventory.ID(invID).updateFindAt(findAt);
            }
        }

        // イベントクエスト進行度を更新
        public function scEventQuestFlagUpdate(questType:int,flag:int):void
        {
            log.writeLog(log.LV_INFO, this, "quest update!!!!!!!!!!!!" , questType,flag);
            if (questType == Const.QUEST_EVENT) {
                player.avatar.eventQuestFlag  = flag;
            } else if (questType == Const.QUEST_TUTORIAL) {
                player.avatar.tutorialQuestFlag  = flag;
            }
        }
        // イベントクエスト達成度度を更新
        public function scEventQuestClearNumUpdate(questType:int,clearNum:int):void
        {
            log.writeLog(log.LV_INFO, this, "quest clear num update!!!!!!!!!!!!" , questType,clearNum);
            if (questType == Const.QUEST_EVENT) {
                player.avatar.eventQuestClearNum  = clearNum;
            } else if (questType == Const.QUEST_TUTORIAL) {
                player.avatar.tutorialQuestClearNum  = clearNum;
            }
        }


        // クエストが失敗
        public function scQuestFailed(inv_id:int):void
        {
//            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }
        // クエストが削除
        public function scQuestDeleted(inv_id:int):void
        {
//            log.writeLog(log.LV_FATAL, this, "quest deleted", inv_id);
            AvatarQuestInventory.removeAvatarQuestInventory(inv_id);
        }

        // 宝箱をゲット
        public function scQuestTreasureGot(type:int, id:int):void
        {
//            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // クエストが終了
        public function scQuestFinish(result:int, inv_id:int):void
        {
//            AvatarItemInventory.removeAvatarItemInventory(inv_id);
            log.writeLog(log.LV_INFO, this, "quest is finish.");
//            _ctrl.exitQuest(result);
            new WaitThread(1500,_ctrl.exitQuest,[result],true).start();
        }

        public function scGetQuestTreasure(type:int, c_type:int, val:int):void
        {
            log.writeLog(log.LV_FATAL, this, "getQuestItem",type, c_type, val);
//            _ctrl.getTresure(type, c_type, val)
            new WaitThread(1500,_ctrl.getTresure,[type, c_type, val],true).start();
        }

        //
        public function scAchievementClear(achiID:int, itemType:int, itemID:int, itemNum:int, cType:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAchievementClear", achiID, itemType, itemID, itemNum, cType);
            LobbyNotice.setAchievementSuccessInfo(achiID, itemType, itemID, itemNum, cType);
            AchievementInventory.finishAchievementInventory(achiID);
        }

        public function scAddNewAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAddNewAchievement", achiID);
            LobbyNotice.setAchievementNewInfo(achiID);

            new AchievementInventory(achiID, Const.ACHIEVEMENT_STATE_START)
        }

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
                                                         achievementsCode.split(",")
                    );
            }
        }

        public function scUpdateCombineWeaponData(invId:int,cardId:int,baseSap:int,baseSdp:int,baseAap:int,baseAdp:int,baseMax:int,addSap:int,addSdp:int,addAap:int,addAdp:int,addMax:int,passiveId:String,restriction:String,cntStr:String,cntMaxStr:String,level:int,exp:int,psvNumMax:int,passivePassSet:String,vanishPsvIds:String):void
        {

            log.writeLog(log.LV_INFO, this, "scUpdateCombineWeaponData", invId,cardId,baseSap,baseSdp,baseAap,baseAdp,baseMax,addSap,addSdp,addAap,addAdp,addMax,passiveId,restriction,cntStr,cntMaxStr,level,exp,psvNumMax,passivePassSet,vanishPsvIds);
            var wc:WeaponCard;
            var wci:WeaponCardInventory = WeaponCardInventory.getInventory(invId);
            if (wci) {
                if (wci.combined) {
                    wc = WeaponCard(wci.card);
                } else {
                    wc = WeaponCard.createCombineWeapon(cardId);
                    wc.num += 1;
                }
                wc.setCombineWeaponParam(cardId,baseSap,baseSdp,baseAap,baseAdp,baseMax,addSap,addSdp,addAap,addAdp,addMax,passiveId,restriction,cntStr,cntMaxStr,level,exp,psvNumMax,passivePassSet);
                wci.card = ICard(wc);
            } else {
                wc = WeaponCard.createCombineWeapon(cardId);
                wc.setCombineWeaponParam(cardId,baseSap,baseSdp,baseAap,baseAdp,baseMax,addSap,addSdp,addAap,addAdp,addMax,passiveId,restriction,cntStr,cntMaxStr,level,exp,psvNumMax,passivePassSet);
                WeaponCardDeck.binder.addWeaponCardInventory(new WeaponCardInventory(invId, wc, 0, 0, 0));
            }
            var vanishPsvSet:Array = vanishPsvIds.split("|");
            log.writeLog(log.LV_INFO, this, "scUpdateCombineWeaponData!!!",vanishPsvSet.length,vanishPsvSet);
            if (vanishPsvSet.length > 0&&wc) {
                var psvNameSet:Array = [];
                for (var i:int = 0; i < vanishPsvSet.length; i++) {
                    if (vanishPsvSet[i]&&int(vanishPsvSet[i])>0) {
                        var psvId:int = int(vanishPsvSet[i]);
                        var passive:PassiveSkill = PassiveSkill.ID(psvId);
                        psvNameSet.push(passive.name);
                    }
                }
                if (psvNameSet.length > 0) {
                    Alerter.showWithSize(Const.TRANS_CMB_PASSIVE_VANISH_MSG.replace("__WC_NAME__",wc.name).replace("__PSV_NAME__",psvNameSet.join(",")));
                }
            }
        }

        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {
            _ctrl.errorAlert(e);
//            _ctrl.waitingStop();
        }


        public function scNextSuccess(no:int):void
        {
            log.writeLog(log.LV_FATAL, this, "nextLandSuccess",no);
            _ctrl.currentCharaPoint = new Point(no%3,int(no/3));
//            _ctrl.sleepViewSequence(3000);
        }

        // ログイン時にカードをロードする
        public function scActioncardLength(len:int):void
        {
            log.writeLog(log.LV_INFO, this,"getActionCardLength", len);
            ActionCard.allLoad(len);
        }


        // インフォメッセージを受け取る
        public function scMessage(msg:String):void
        {
              log.writeLog(log.LV_INFO, this,"get chat messeage", msg);
             _ctrl.setMessage(msg);
        }

        // インフォメッセージを受け取る
        public function scMessageStrData(str:String):void
        {
            // log.writeLog(log.LV_INFO, this,"get chat messeage str data", str);
            commandPush(_ctrl.setMessageStrData, [str]);
        }


        // ゲームのセッション情報を受け取る()
        public function scGamesessioninfo(id:int, foe:String):void
        {
//              log.writeLog(log.LV_INFO, this,"get chat messeage", msg);
//             _ctrl.setChatMessage(msg);
        }

        // ゲームのセッションの決定
        public function scDetermineSession(id:int, foe:String, playerCharaID:String, foeCharaID:String, playerDialogue:String, foeDialogue:String,stage:int, plDmg0:int, plDmg1:int, plDmg2:int, foeDmg0:int, foeDmg1:int, foeDmg2:int):void
        {
//            log.writeLog(log.LV_INFO, this,"Determine GameSession", id, foe,"plccid:", playerCharaID,"foeccid:",foeCharaID,"starDialogue:", playerDialogue);
            Dialogue.instance.setMessage(playerDialogue);
            Dialogue.instance.setMessage(foeDialogue);
            _duel = Duel.instance;
            _duel.setQuestRule(true);   // By_K2 (퀘스트 여부 처리)
            // チャットコントローラに決定済みの
            ChatCtrl.instance.foeID = id;
            _duel.addEventListener(Duel.START, duelStartHandler);
            _duel.addEventListener(Duel.END, duelEndHandler);

            _duel.initialize(string2intArray(playerCharaID),string2intArray(foeCharaID),stage,[plDmg0,plDmg1,plDmg2],null,false);
//            _ctrl.battle();
            // 道をあるくのを待つ
            new WaitThread(1100,_ctrl.battle,null,true).start();
        }


        // クエストのダイアログ情報を受け取る
        public function scDialogueInfoUpdate(dialogue:String, id:int, type:int):void
        {
            log.writeLog(log.LV_INFO, this,"DialoguInfoUpdate", dialogue,id, type);
            Dialogue.instance.setMessage(dialogue, id , type);
        }








        // ==============
        // Duel
        // ==============

        // デュエルのスタート
        public function scOneToOneDuelStart(deckSize:int, playerEventDeckSize:int, foeEventDeckSize:int, distance:int):void
        {
            log.writeLog(log.LV_INFO, this,"start duel", deckSize);
            _duel.setRule(Duel.RULE_1VS1);
            commandPush(_duel.initializeDeck, [deckSize]);
            commandPush(_duel.setDistance, [distance]);
        }

        // デュエルのスタート
        public function scThreeToThreeDuelStart(deckSize:int, distance:int, playerEventDeckSize:int, foeEventDeckSize:int, multi:Boolean):void
        {
            ChatCtrl.instance.foeName = "Quest";
            log.writeLog(log.LV_INFO, this,"start multi duel", deckSize);
            if (multi)
            {
                _duel.setRule(Duel.RULE_3VS3);
            }else{
                _duel.setRule(Duel.RULE_1VS1);
            }
            commandPush(_duel.initializeDeck, [deckSize]);
        }

        // デュエルの終了
        public function scOneToOneDuelFinish(result:int, gems:int, exp:int, expBonus:int, gemsPow:int, expPow:int, totalGems:int, totalExp:int, bonus:Boolean):void
        {
            log.writeLog(log.LV_INFO, this,"duel end", result, gems, exp, expBonus, gemsPow, expPow, bonus);
            commandPush(_duel.endGame, [result, gems, exp, expBonus, gemsPow, expPow, totalGems, totalExp, bonus]);
        }

        // デュエルの終了
        public function scThreeToThreeDuelFinish(result:int, gems:int, exp:int, bonus:Boolean):void
        {
            log.writeLog(log.LV_INFO, this,"multi duel end", result, gems, exp, bonus);
            commandPush(_duel.endGame, [result, gems, exp,bonus]);
        }

        // ==============
        // Reward
        // ==============

        // 取得候補のカードを与える
        public function scRewardCandidateCardsList(cards1:String, cards2:String, cards3:String, cards4:String, startBonus:int):void
        {
            log.writeLog(log.LV_INFO, this,"get candidate card list", cards1, cards2, cards3, cards4,startBonus);
            if(cards2 != ""  && cards3 != "" && cards4 != "")
            {
                _duel.reward.start(string2intArray(cards1), string2intArray(cards2), string2intArray(cards3), string2intArray(cards4),startBonus);
            }
        }

        // 基本ダイスの結果を反映させる
        public function scBottomDiceNum(bottomDice:String):void
        {
            log.writeLog(log.LV_INFO, this,"reward bottom dice", bottomDice);
            _duel.reward.setBottomDice(string2intArray(bottomDice));
        }

        // ダブルアップの結果を反映させる
        public function scHighLowResult(win:Boolean, gettedCards:String, nextCards:String, bonus:int):void
        {
            log.writeLog(log.LV_INFO, this,"high row result event", win, gettedCards, nextCards, bonus);
            _duel.reward.highLowResult(win, string2intArray(gettedCards), string2intArray(nextCards), bonus);
        }

        // プレイヤーが振ったダイスの結果を反映させる
        public function scRewardResultDice(resultDice:String):void
        {
            log.writeLog(log.LV_INFO, this,"reward result dice", resultDice);
            _duel.reward.setResultDice(string2intArray(resultDice));
        }

        // 最終的に取得したカード
        public function scRewardFinalResult(gettedCards:String,totalGems:int,totalExp:int,addPoint:int):void
        {
            log.writeLog(log.LV_INFO, this,"reward final result", gettedCards,totalGems,totalExp,addPoint);
            _duel.reward.finalResult(string2intArray(gettedCards),totalGems,totalExp,addPoint);
        }

        // 追加のキャラカードインベントリ情報を受け取る
        public function scCharaCardInventoryInfo(inv_id:String, card_id:String):void
        {
            log.writeLog(log.LV_INFO, this,"get chara card inventory ID is", inv_id);

            var invID:Array = string2intArray(inv_id);
            var cardID:Array = string2intArray(card_id);

            invID.forEach(function(item:*, index:int, array:Array):void{
                    CharaCardDeck.binder.addCharaCardInventory(new CharaCardInventory(item, CharaCard.ID(cardID[1]), 0, 0));
                    ClientLog.write( ClientLog.GOT_CHARA_CARD, cardID[1], true );
                });

        }


        // ==============
        // DuelPhase
        // ==============

        // TurnStartPhase
        public function scDuelStartTurnPhase(turnCount:int):void
        {
            log.writeLog(log.LV_INFO, this,"Start Turn Phase",turnCount);
            commandPush(_duel.setTurn, [turnCount]);
            if (turnCount >1)
            {
                commandPush(_ctrl.setMessage, [Const.SV_MESS_TURN_END.replace("__TURN__",(turnCount-1).toString())]);
            }
        }

        // TurnStartPhase
        public function scDuelRefillPhase(list:String, dir:int, foeSize:int):void
        {
            log.writeLog(log.LV_INFO, this,"Refill Phase",list, dir, foeSize);
            var a:Array = [];
            var dirs:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                dirs = int2BooleanArray(dir,a.length);
//                log.writeLog(log.LV_FATAL, this, dirs);
            }
            a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).up = dirs[index]});
            commandPush(_duel.refillPhase, [a,foeSize]);
        }

        // TurnStartPhase
        public function scDuelRefillEventPhase(list:String, dir:int, foeSize:int):void
        {
            log.writeLog(log.LV_INFO, this,"Refill Event Card Phase",list, dir, foeSize);
            var a:Array = [];
            var dirs:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                dirs = int2BooleanArray(dir,a.length);
//                log.writeLog(log.LV_FATAL, this, dirs);
            }
            a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).up = dirs[index]});
            commandPush(_duel.refillEventPhase, [a, foeSize]);
        }


        public function scDuelMoveCardDropPhaseStart():void
        {
            log.writeLog(log.LV_INFO, this, "Move Card Drop Phase Start");
            commandPush(_duel.moveCardDropPhaseStart,[]);
        }

        public function scDuelMoveCardDropPhaseFinish():void
        {
            log.writeLog(log.LV_INFO, this, "Move Card Drop Phase Finish");
            commandPush(_duel.moveCardDropPhaseFinish,[]);
        }

        public function scDuelDetermineMovePhase(init:Boolean, dist:int, list:String, dir:String, foeList:String, foeDir:String, pow:int, foePow:int, locked:Boolean, foeLocked:Boolean):void
        {
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
            log.writeLog(log.LV_INFO, this, "OPEN CARD LIST", foeCards);
            commandPush(_duel.foeEntrant.openMoveCards,[foeCards,string2BooleanArray(foeDir), foeLocked]);
            log.writeLog(log.LV_INFO, this, "Determine Move Phase");
            commandPush(_duel.determineMovePhase, [init, dist, playerCards,foeCards, pow, foePow]);
            commandPush(_duel.setDistance, [ dist]);
        }


        public function scDuelCharaChangePhaseStart(player:Boolean, foe:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Chara Change Phase Start", player, foe);
            commandPush(_duel.plEntrant.setChangeDone,[player]);
            commandPush(_duel.foeEntrant.setChangeDone,[foe]);
            commandPush(_duel.charaChangePhaseStart, []);
        }

        public function scDuelCharaChangePhaseFinish():void
        {
            log.writeLog(log.LV_INFO, this, "Chara Change Phase Finish");
            commandPush(_duel.charaChangePhaseFinish, []);
        }

        public function scDuelAttackCardDropPhaseStart(attack:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Attack Card Drop Phase Start");
            commandPush(_duel.attackCardDropPhaseStart, [attack]);
        }

        public function scDuelAttackCardDropPhaseFinish(list:String, dir:String, foeList:String, foeDir:String, locked:Boolean, foeLocked:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Attack Card Drop Phase Finish");
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
            commandPush(_duel.foeEntrant.openBattleCards,[foeCards,string2BooleanArray(foeDir),foeLocked]);
            commandPush(_duel.attackCardDropPhaseFinish, []);
        }

        public function scDuelDeffenceCardDropPhaseStart(deffence:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Deffence Card Drop Phase Start");
            commandPush(_duel.deffenceCardDropPhaseStart, [deffence]);
        }

        public function scDuelDeffenceCardDropPhaseFinish(list:String, dir:String, foeList:String, foeDir:String, locked:Boolean, foeLocked:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Deffence Card Drop Phase Finish");
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
            commandPush(_duel.foeEntrant.openBattleCards,[foeCards,string2BooleanArray(foeDir),foeLocked]);
            commandPush(_duel.deffenceCardDropPhaseFinish, []);
        }


        public function scDuelDetermineBattlePointPhase(list:String, dir:String, foeList:String, foeDir:String, locked:Boolean, foeLocked:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Determine Battle Point Phase");
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
//            log.writeLog(log.LV_FATAL, this, "OPNE CARD LIST", foeCards);

            commandPush(_duel.foeEntrant.openBattleCards,[foeCards,string2BooleanArray(foeDir),foeLocked]);

            commandPush(_duel.determineBattlePointPhase, [playerCards,foeCards]);
        }

        public function scDuelBattleResultPhase(player:Boolean, attackDice:String, deffenceDice:String):void
        {
            log.writeLog(log.LV_INFO, this, "Battle Result Phase");
            log.writeLog(log.LV_INFO, this,"battle result", attackDice, deffenceDice);
            var a:Array = [];
            var b:Array = [];
            if ((attackDice != "")&&(attackDice != null))
            {
                a = string2intArray(attackDice);
            }
            if ((deffenceDice != "")&&(deffenceDice != null))
            {
                b = string2intArray(deffenceDice);
            }
            commandPush(_duel.battleResultPhase, [player, a, b]);
        }

        public function scDuelDeadCharaChangePhaseStart(player:Boolean, foe:Boolean, list:String,foeList:String):void
        {
            log.writeLog(log.LV_INFO, this, "Dead Chara Change Phase Start");
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
            _duel.plEntrant.setChangeDone(player);
            _duel.foeEntrant.setChangeDone(foe);
            commandPush(_duel.deadCharaChangePhaseStart, [playerCards,foeCards]);
        }

        public function scDuelDeadCharaChangePhaseFinish():void
        {
            log.writeLog(log.LV_INFO, this, "Dead Chara Change Phase Finish");
            commandPush(_duel.deadCharaChangePhaseFinish, []);
        }

        public function scDuelFinishTurnPhase():void
        {
            log.writeLog(log.LV_INFO, this, "Finish Turn Phase");
            commandPush(_duel.finishTurnPhase, []);
        }

        // ==============
        // Entrant
        // ==============

        // ============ Entrant Action  ==============
        public function scEntrantSetDirectionAction(player:Boolean, dir:int):void
        {
            log.writeLog(log.LV_INFO, this, "Set Direction Action. Player?",player,"dir",dir);
            if (player)
            {
                commandPush(_duel.plEntrant.setDirectionSuccess,[dir]);
            }
            else
            {
//                commandPush(_duel.foeEntrant.moveCardAdd,[null,true,index]);
            }
        }

        public function scEntrantMoveCardAddAction(player:Boolean, index:int, id:int):void
        {
            var aa:Boolean = (_duel.foeEntrant == null);
            log.writeLog(log.LV_INFO, this, "Move Card Add Action. Player?",player,"index",index, _duel,aa,id);
            if (player)
            {
                commandPush(_duel.plEntrant.moveCardAddSuccess,[ActionCard.ID(id),true,index]);
            }
            else
            {
                // indexが-1は失敗なので無視する
                if (index != -1)
                {
                    commandPush(_duel.foeEntrant.moveCardAdd,[null,true,index]);
                }
            }
        }

        public function scEntrantMoveCardRemoveAction(player:Boolean, index:int, id:int):void
        {
//            log.writeLog(log.LV_INFO, this, "Foe Move Card Remove Action. Player?",player,"index",index);
            if (player)
            {
                commandPush(_duel.plEntrant.moveCardRemoveSuccess,[ActionCard.ID(id),true,index]);
                commandPush(ActionCard.ID(id).activate,[false]);
            }
            else
            {
                // indexが-1は失敗なので無視する
                if (index != -1)
                {
                    commandPush(_duel.foeEntrant.moveCardRemove,[null, index]);
                }
            }
        }

        public function scEntrantCardRotateAction(player:Boolean, table:int, index:int, id:int, dir:Boolean):void
        {
            if (player)
            {
                commandPush(ActionCard.ID(id).rotate,[dir]);
            }
            else
            {
                commandPush(_duel.foeEntrant.cardRotate,[null, dir, table,index]);
            }
        }

        public function scEntrantEventCardRotateAction(player:Boolean, table:int, index:int, id:int, dir:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "EVENT Card Rotate Action. Player?",player,"id",id,"dir",dir);
            if (player)
            {
                commandPush(ActionCard.ID(id).eventRotate,[dir]);
            }
            else
            {
                commandPush(ActionCard.ID(id).eventRotate,[dir]);
            }
        }

        public function scEntrantBattleCardAddAction(player:Boolean, index:int,id:int):void
        {
            if (player)
            {
                commandPush(_duel.plEntrant.battleCardAddSuccess,[ActionCard.ID(id),true,index]);
            }
            else
            {
                // indexが-1は失敗なので無視する
                if (index != -1)
                {
                    commandPush(_duel.foeEntrant.battleCardAdd,[null,true,index]);
                }
            }
        }

        public function scEntrantBattleCardRemoveAction(player:Boolean, index:int, id:int):void
        {
            if (player)
            {
                commandPush(_duel.plEntrant.battleCardRemoveSuccess,[ActionCard.ID(id), true, index]);
                commandPush(ActionCard.ID(id).activate,[false]);
            }
            else
            {
                // indexが-1は失敗なので無視する
                if (index != -1)
                {
                    commandPush(_duel.foeEntrant.battleCardRemove,[null, index]);
                }
            }
        }


        public function scEntrantInitDoneAction(player:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Init Done Action. Player?",player);
            if (player)
            {
                _duel.plEntrant.initDoneSuccess();

            }else{
                log.writeLog(log.LV_INFO, this, "Foe Init Done Action");
                commandPush(_duel.foeEntrant.initDone,[]);
            }
        }

        public function scFoeEntrantMoveDoneAction():void
        {
            log.writeLog(log.LV_INFO, this, "Foe Move Done Action");
            commandPush(_duel.foeEntrant.moveDone,[]);
        }

        public function scEntrantAttackDoneAction(player:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Battle Done Action. Player?",player);
            if (player)
            {
                _duel.plEntrant.attackDoneSuccess();
            }else{

//            commandPush(_duel.foeEntrant.attackDone,[]);
            }
        }

        public function scEntrantDeffenceDoneAction(player:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Battle Done Action. Player?",player);
            if (player)
            {
                _duel.plEntrant.deffenceDoneSuccess();

            }else{
//            commandPush(_duel.foeEntrant.deffenceDone,[]);
            }
        }

        // プレイヤーが移動
        public function scEntrantMoveAction(dist:int):void
        {
//            log.writeLog(log.LV_FATAL, this, "Player Move Action");
            commandPush(_duel.setDistance,[dist]);
        }

        // ハイド中のプレイヤーが移動
        public function scEntrantHideMoveAction(dist:int):void
        {
            commandPush(_duel.setHideDistance,[dist]);
        }

        // キャラカードを変更
        public function scEntrantCharaChangeAction(player:Boolean, index:int, cardId:int, weaponBonus:String):void
        {
            log.writeLog(log.LV_INFO, this, "Player Chara Change Action", player, index, cardId, weaponBonus);

            _duel.updateUnknownCharaCard(player, index, cardId);
            if (player)
            {
//            commandPush(_duel.setDistance,[dist]);
//                _duel.plEntrant.charaChangeSuccess(index, cardId);
                commandPush(_duel.plEntrant.charaChangeSuccess,[index, cardId, string2intArray(weaponBonus)]);
            }
            else
            {
                commandPush(_duel.foeEntrant.charaChangeSuccess,[index, cardId, string2intArray(weaponBonus)]);
            }
        }


        // ============ Entrant Event ==============

        public function scEntrantDamagedEvent(player:Boolean, damage:int, is_not_hostile:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Damaged Event");
            if (damage >0)
            {
                if (player)
                {
                    commandPush(_duel.plEntrant.damage,[damage, is_not_hostile]);
                }
                else
                {
                    commandPush(_duel.foeEntrant.damage,[damage, is_not_hostile]);
                }
            }
        }

        public function scEntrantPartyDamagedEvent(player:Boolean, index:int, damage:int, is_not_hostile:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Party Damage Event");
            if (player)
            {
                commandPush(_duel.plEntrant.partyDamage,[index, damage, is_not_hostile]);
            }
            else
            {
                commandPush(_duel.foeEntrant.partyDamage,[index, damage, is_not_hostile]);
            }
        }

        public function scEntrantReviveEvent(player:Boolean, index:int, rhp:int):void
        {
            log.writeLog(log.LV_INFO, this, "Revive Event");
            if (player)
            {
                commandPush(_duel.plEntrant.revive,[index,rhp]);
            }
            else
            {
                commandPush(_duel.foeEntrant.revive,[index,rhp]);
            }
        }

        public function scEntrantConstraintEvent(player:Boolean, flag:int):void
        {
            log.writeLog(log.LV_INFO, this, "Constraint Event");
            if (player)
            {
                commandPush(_duel.plEntrant.constraint,[flag]);
            }
        }

        public function scEntrantHealedEvent(player:Boolean, heal:int):void
        {
            log.writeLog(log.LV_INFO, this, "Heal Event",heal);
            if (heal >0)
            {
                if (player)
                {
                    commandPush(_duel.plEntrant.heal,[heal]);
                }
                else
                {
                    commandPush(_duel.foeEntrant.heal,[heal]);
                }
            }
        }

        public function scEntrantPartyHealedEvent(player:Boolean, index:int, heal:int):void
        {
            log.writeLog(log.LV_INFO, this, "Party Heal Event");
            if (player)
            {
                commandPush(_duel.plEntrant.partyHeal,[index, heal]);
            }
            else
            {
                commandPush(_duel.foeEntrant.partyHeal,[index, heal]);
            }
        }

        public function scEntrantHitPointChangedEvent(player:Boolean, hp:int):void
        {
            log.writeLog(log.LV_INFO, this, "HitPoint Changed Event",hp);
            if (hp >0)
            {
                if (player)
                {
                    commandPush(_duel.plEntrant.hitPointChange,[hp]);
                }
                else
                {
                    commandPush(_duel.foeEntrant.hitPointChange,[hp]);
                }
            }
        }

        public function scEntrantCuredEvent(player:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Cured Event", player);
            if (player)
            {
                commandPush(_duel.buffOffAllEvent,[player]);
            }
            else
            {
                commandPush(_duel.buffOffAllEvent,[player]);
            }
        }

        public function scEntrantSealedEvent(player:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Sealed Event", player);
            if (player)
            {
                commandPush(_duel.featSealedEvent,[player]);
            }
            else
            {
//                commandPush(_duel.featSealedEvent,[player]);
            }
        }

        public function scEntrantUseActionCardEvent(player:Boolean, card_id:int):void
        {
            log.writeLog(log.LV_FATAL, this, "Use Action Card Event", card_id);
            commandPush(_duel.useActionCard,[player,ActionCard.ID(card_id)]);
        }

        public function scEntrantDiscardEvent(player:Boolean, card_id:int):void
        {
//            log.writeLog(log.LV_FATAL, this, "Discard Action Card Event", card_id);
            commandPush(_duel.discard,[player,ActionCard.ID(card_id)]);
        }

        public function scEntrantDiscardTableEvent(player:Boolean, card_id:int):void
        {
//            log.writeLog(log.LV_FATAL, this, "Discard Table Action Card Event", card_id);
            commandPush(_duel.discardTable, [player,ActionCard.ID(card_id)]);
        }

        public function scEntrantPointUpdateEvent(player:Boolean, list:String, on:int, point:int):void
        {
            log.writeLog(log.LV_INFO, this, "Point update. player ?",player, point);
            var a:Array = [];
            var on_cards:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                on_cards = int2BooleanArray(on, a.length);
                log.writeLog(log.LV_INFO, this, a,on_cards);
            }

            if (player)
            {
                a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).activate(on_cards[index])});
                commandPush(_duel.plEntrant.updateBattlePoint,[point]);
            }else{
                a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).activate(on_cards[index])});
                commandPush(_duel.foeEntrant.updateBattlePoint,[point]);
            }
//            commandPush(_duel.discard,[player,ActionCard.ID(card_id)]);
        }

        public function scEntrantPointRewriteEvent(player:Boolean, point:int):void
        {
            if (player)
            {
                commandPush(_duel.plEntrant.updateBattlePoint,[point]);
            }else{
                commandPush(_duel.foeEntrant.updateBattlePoint,[point]);
            }
        }

        public function scEntrantSpecialDealedEvent(player:Boolean, list:String, dir:int, size:int):void
        {
            log.writeLog(log.LV_INFO, this, "Entrant Specil Dealed Event Player?:",player);
            var a:Array = [];
            var dirs:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                dirs = int2BooleanArray(dir, a.length);
//                log.writeLog(log.LV_FATAL, this, dirs);
            }
            a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).up = dirs[index]});
            commandPush(_duel.specialDealEvent,[player, a, size]);
        }

        public function scEntrantGraveDealedEvent(player:Boolean, list:String, dir:int, size:int):void
        {
            log.writeLog(log.LV_INFO, this, "Entrant Grave Dealed Event Player?:",player);
            var a:Array = [];
            var dirs:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                dirs = int2BooleanArray(dir, a.length);
//                log.writeLog(log.LV_FATAL, this, dirs);
            }
            a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).up = dirs[index]});
            commandPush(_duel.graveDealEvent,[player, a, size]);
        }


        public function scEntrantStealDealedEvent(player:Boolean, list:String, dir:int, size:int):void
        {
            log.writeLog(log.LV_INFO, this, "Entrant Steal Dealed Event Player?:",player, "list", list);
            var a:Array = [];
            var dirs:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                dirs = int2BooleanArray(dir, a.length);
//                log.writeLog(log.LV_FATAL, this, dirs);
            }
            a.forEach(function(item:*, index:int, array:Array):void
                      {
                          ActionCard.ID(item).up = dirs[index];
                          commandPush(_duel.stealDiscard,[!player,ActionCard.ID(item)]);
                          commandPush(_duel.stealDealEvent,[player, [item], 1]);
                      });
        }

        public function scEntrantSpecialEventCardDealedEvent(player:Boolean, list:String, dir:int, size:int):void
        {
            log.writeLog(log.LV_INFO, this, "Entrant Specil Event Card Dealed Event Player?:",player);
            var a:Array = [];
            var dirs:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                dirs = int2BooleanArray(dir, a.length);
//                log.writeLog(log.LV_FATAL, this, dirs);
            }
            a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).up = dirs[index]});
            var i:int;
            if (player) {
                for ( i = 0; i < a.length; i++ ) {
                    commandPush(_duel.specialEventCardDealEvent,[player, [a[i]], 0]);
                }
            } else {
                for ( i = 0; i < size; i++ ) {
                    commandPush(_duel.specialEventCardDealEvent,[player, [], 1]);
                }
            }
        }

        // 装備カードを更新
        public function scEntrantUpdateWeaponEvent(player:Boolean, plBonus:String, foeBonus:String):void
        {
            log.writeLog(log.LV_INFO, this, "Entrant Update Weapon Event", player, plBonus, foeBonus);

            if (player)
            {
                commandPush(_duel.plEntrant.updateWeaponBonus,
                            [arraySeparateNum(9, string2intArray(plBonus)),
                             arraySeparateNum(9, string2intArray(foeBonus))]
                    );
                commandPush(_duel.foeEntrant.updateWeaponBonus,
                            [arraySeparateNum(9, string2intArray(foeBonus)),
                             arraySeparateNum(9, string2intArray(plBonus))]
                    );
            }
            else
            {
//                commandPush(_duel.foeEntrant.updateWeaponBonus, [arraySeparateNum(8, string2intArray(foeBonus)) ,arraySeparateNum(8, string2intArray(plBonus))]);
            }
        }

        public function scEntrantUpdateCardValueEvent(player:Boolean, id:int, u_value:int, b_value:int, reset:Boolean):void
        {
            commandPush(_duel.plUpdateCardValueEvent, [id, u_value, b_value, reset]);
        }

        public function scEntrantCardsMaxUpdateEvent(player:Boolean, cardsMax:int):void
        {
            log.writeLog(log.LV_INFO, this, "CardMax update. player ?",player, cardsMax);
            if (player)
            {
                commandPush(_duel.plEntrant.updateCardsMax,[cardsMax]);
            }else{
            }
//            commandPush(_duel.discard,[player,ActionCard.ID(card_id)]);
        }

        public function scEntrantTrapActionEvent(player:Boolean, kind:int, distance:int):void
        {
            log.writeLog(log.LV_INFO, this, "Trap Action Event");
            if (player)
            {
                commandPush(_duel.plEntrant.trapAction,[kind, distance]);
            }
            else
            {
                commandPush(_duel.foeEntrant.trapAction,[kind, distance]);
            }
         }

        public function scEntrantTrapUpdateEvent(player:Boolean, kind:int, distance:int, turn:int, visible:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Trap Update Event");
            if (player)
            {
                commandPush(_duel.plEntrant.trapUpdate,[kind, distance, turn, visible]);
            }
            else
            {
                commandPush(_duel.foeEntrant.trapUpdate,[kind, distance, turn, visible]);
            }
         }

        public function scSetFieldStatusEvent(kind:int, pow:int, turn:int):void
        {
            log.writeLog(log.LV_INFO, this, "Set Field Status Event");
            commandPush(_duel.setFieldStatus, [kind, pow, turn]);
        }

        public function scDuelBonusEvent(type:int, value:int):void
        {
            log.writeLog(log.LV_INFO, this, "Player get Duel Bonus",type, value);
            if (value > 0)
            {
                commandPush(_duel.setDuelBonus, [type, value]);
            }
        }


        // 現在ターン数をセット
        public function scSetTurnEvent(turn:int):void
        {
           commandPush(_duel.setTurn, [turn]);
        }

        // カードロック
        public function scCardLockEvent(id:int):void
        {
           commandPush(_duel.cardLock, [id]);
        }

        // カードロック解除
        public function scClearCardLocksEvent():void
        {
            commandPush(_duel.clearCardLocks, []);
        }

        // ==============
        // Feat
        // ==============
        public function scPlFeatOnEvent(feat_id:int):void
        {
            commandPush(_duel.featOnEvent, [true, feat_id]);
        }

        public function scPlFeatOffEvent(feat_id:int):void
        {
            commandPush(_duel.featOffEvent, [true, feat_id]);
        }

        public function scEntrantChangeFeatEvent(player:Boolean, chara_index:int, feat_index:int, feat_id:int, feat_no:int):void
        {
            commandPush(_duel.featChangeEvent, [player, chara_index, feat_index, feat_id, feat_no]);
        }

        public function scEntrantUseFeatEvent(player:Boolean, used_feat_id:int):void
        {
            commandPush(_duel.featUseEvent, [player, used_feat_id]);
        }


        // ==============
        // Passive
        // ==============
        public function scEntrantUsePassiveEvent(player:Boolean, used_passive_id:int):void
        {
            commandPush(_duel.passiveUseEvent, [player, used_passive_id]);
        }

        // ==============
        // 特殊
        // ==============

        public function scEntrantOnTransformEvent(player:Boolean, type:int):void
        {
            commandPush(_duel.onTransformEvent, [player, type]);
        }

        public function scEntrantOffTransformEvent(player:Boolean):void
        {
            commandPush(_duel.offTransformEvent, [player]);
        }

        public function scEntrantChangeCharaCardEvent(player:Boolean, chara_card_id:int):void
        {
            commandPush(_duel.changeCharaCardEvent, [player, chara_card_id]);
        }

        public function scEntrantOnLostInTheFogEvent(player:Boolean, distance:int, truth_distance:int):void
        {
            commandPush(_duel.onLostInTheFogEvent, [player, distance, truth_distance]);
        }

        public function scEntrantOffLostInTheFogEvent(player:Boolean, distance:int):void
        {
            commandPush(_duel.offLostInTheFogEvent, [player, distance]);
        }

        public function scEntrantInTheFogEvent(player:Boolean, range:String):void
        {
            commandPush(_duel.inTheFogEvent, [player, string2intArray(range)]);
        }

        public function scEntrantUpdateFeatConditionEvent(player:Boolean, chara_index:int, feat_index:int, condition:String):void
        {
            commandPush(_duel.updateFeatConditionEvent, [player, chara_index, feat_index, condition]);
        }

        public function scEntrantStuffedToysSetEvent(player:Boolean, num:int):void
        {
            commandPush(_duel.stuffedToysSetEvent, [player, num]);
        }

        // ==============
        // パッシブ
        // ==============

        public function scEntrantOnPassiveEvent(player:Boolean,skill_id:int):void
        {
            // log.writeLog(log.LV_DEBUG, this,"passive on", player,skill_id);
            commandPush(_duel.onPassiveEvent, [player,skill_id]);
        }

        public function scEntrantOffPassiveEvent(player:Boolean,skill_id:int):void
        {
            // log.writeLog(log.LV_DEBUG, this,"passive off", player,skill_id);
            commandPush(_duel.offPassiveEvent, [player,skill_id]);
        }


        // ==============
        // Buff
        // ==============
        public function scBuffOnEvent(player:Boolean, index:int, buff_id:int, value:int, turn:int):void
        {
            // commandPush(_duel.buffOnEvent, [player, index, buff_id, value, turn]);
            commandPush(_duel.buffCharaOnEvent, [player, buff_id, value, turn, index]);
        }

        public function scBuffOffEvent(player:Boolean, index:int, buff_id:int, value:int):void
        {
            commandPush(_duel.buffOffEvent, [player, buff_id, value, 0, index]);
        }

        public function scBuffUpdateEvent(player:Boolean, buff_id:int, value:int, index:int, turn:int):void
        {
            commandPush(_duel.buffUpdateEvent, [player, buff_id, value, turn, index]);
        }

        public function scCatStateUpdateEvent(player:Boolean, index:int, value:Boolean):void
        {
            commandPush(_duel.catStateUpdateEvent, [player, index, value]);
        }

        // ==============
        // Deck
        // ==============
        public function scDeckInitEvent(deckSize:int):void
        {
            log.writeLog(log.LV_INFO, this, "Deck Init Event");
            commandPush(_duel.initializeDeck,[deckSize]);
        }

        // ==============
        // ActionCard
        // ==============

        public function scActioncardChanceEvent(player:Boolean, list:String, dir:int, size:int):void
        {
            log.writeLog(log.LV_INFO, this, "Actioncard Chance Event");
            var a:Array = [];
            var dirs:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                dirs = int2BooleanArray(dir, a.length);
//                log.writeLog(log.LV_FATAL, this, dirs);
            }
            a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).up = dirs[index]});
            commandPush(_duel.specialDealEvent,[player, a, size]);
        }

        public function scActioncardHealEvent(player:Boolean, list:String, dir:int, size:int):void
        {
            log.writeLog(log.LV_INFO, this, "Actioncard Chance Event");
            var a:Array = [];
            var dirs:Array = [];
            if ((list != "")&&(list != null))
            {
                a = list.split(",");
                dirs = int2BooleanArray(dir, a.length);
//                log.writeLog(log.LV_FATAL, this, dirs);
            }
            a.forEach(function(item:*, index:int, array:Array):void{ActionCard.ID(item).up = dirs[index]});
            commandPush(_duel.specialDealEvent,[player, a, size]);
        }

        // アクションカード情報をゲット
        public function scActioncardInfo(id:int, ut:int, uv:int, bt:int, bv:int, en:int, image:String, caption:String, version:int):void
        {
            log.writeLog(log.LV_INFO, this,"get actioncard info", id);
            ActionCard.updateParam(id, ut, uv, bt, bv, en, image, caption, version);
        }

        // アクションカード情報をゲット
        public function scActioncardVerInfo(id:int, version:int):void
        {
            log.writeLog(log.LV_INFO, this,"get actioncard ver info", id);
            ActionCard.updateVersion(id, version);
        }


        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }

        // ==============
        // Handler
        // ==============

//         // Matchが初期化された場合のイベントハンドラ
//         private function matchStartHandler():void
//         {
//             // Matchのイベントをリッスン
//             _match.addEventListener(MatchEvent.CREATE_ROOM, csCreateRoomHandler);
//             _match.addEventListener(MatchEvent.CREATE_CPU_ROOM, csCreateCpuRoomHandler);
//             _match.addEventListener(MatchEvent.JOIN_ROOM, csRoomJoinHandler);
//             _match.addEventListener(MatchEvent.EXIT_ROOM, csRoomExitHandler);
//         }

//         // Matchが終了した場合のイベントハンドラ
//         private function matchEndHandler(e:Event):void
//         {
//             // Matchのイベントをはずす
//             _match.removeEventListener(MatchEvent.CREATE_ROOM, csCreateRoomHandler);
//             _match.removeEventListener(MatchEvent.JOIN_ROOM, csRoomJoinHandler);
//             _match.removeEventListener(MatchEvent.EXIT_ROOM, csRoomExitHandler);
//         }

        // Duelが初期化された場合のイベントハンドラ
        private function duelStartHandler(e:Event):void
        {
            // PlayerEntrantを監視する
            _duel.plEntrant.addEventListener(DirectionEvent.UPDATE,setDirectionHandler);

            _duel.plEntrant.addEventListener(ReplaceCardEvent.ADD_MOVE_TABLE,addMoveCardHandler);
            _duel.plEntrant.addEventListener(ReplaceCardEvent.REMOVE_MOVE_TABLE,removeMoveCardHandler);

            _duel.plEntrant.addEventListener(ReplaceCardEvent.ADD_ATTACK_BATTLE_TABLE,addAttackCardHandler);
            _duel.plEntrant.addEventListener(ReplaceCardEvent.REMOVE_ATTACK_BATTLE_TABLE,removeAttackCardHandler);

            _duel.plEntrant.addEventListener(ReplaceCardEvent.ADD_DEFFENCE_BATTLE_TABLE,addDeffenceCardHandler);
            _duel.plEntrant.addEventListener(ReplaceCardEvent.REMOVE_DEFFNCE_BATTLE_TABLE,removeDeffenceCardHandler);

            _duel.plEntrant.addEventListener(ReplaceCardEvent.ROTATE,rotateCardHandler);

            _duel.plEntrant.addEventListener(CharaChangeEvent.CHARA_CHANGE, charaChangeHandler);

            _duel.plEntrant.addEventListener(Entrant.INIT_DONE,initDoneHandler);
            _duel.plEntrant.addEventListener(Entrant.MOVE_DONE,moveDoneHandler);
            _duel.plEntrant.addEventListener(Entrant.ATTACK_DONE,attackDoneHandler);
            _duel.plEntrant.addEventListener(Entrant.DEFFENCE_DONE,deffenceDoneHandler);

            _duel.reward.addEventListener(Reward.UP,rewardUpHandler);
            _duel.reward.addEventListener(Reward.DOWN,rewardDownHandler);
            _duel.reward.addEventListener(Reward.CANCEL,rewardCancelHandler);
            _duel.reward.addEventListener(Reward.RETRY,rewardRetryHandler);
        }

        // Duelが初期化された場合のイベントハンドラ
        private function duelEndHandler(e:Event):void
        {
            // PlayerEntrantを監視を解く
            _duel.plEntrant.removeEventListener(DirectionEvent.UPDATE,setDirectionHandler);

            _duel.plEntrant.removeEventListener(ReplaceCardEvent.ADD_MOVE_TABLE,addMoveCardHandler);
            _duel.plEntrant.removeEventListener(ReplaceCardEvent.REMOVE_MOVE_TABLE,removeMoveCardHandler);

            _duel.plEntrant.removeEventListener(ReplaceCardEvent.ADD_ATTACK_BATTLE_TABLE,addAttackCardHandler);
            _duel.plEntrant.removeEventListener(ReplaceCardEvent.REMOVE_ATTACK_BATTLE_TABLE,removeAttackCardHandler);

            _duel.plEntrant.removeEventListener(ReplaceCardEvent.ADD_DEFFENCE_BATTLE_TABLE,addDeffenceCardHandler);
            _duel.plEntrant.removeEventListener(ReplaceCardEvent.REMOVE_DEFFNCE_BATTLE_TABLE,removeDeffenceCardHandler);

            _duel.plEntrant.removeEventListener(ReplaceCardEvent.ROTATE,rotateCardHandler);

            _duel.plEntrant.removeEventListener(CharaChangeEvent.CHARA_CHANGE, charaChangeHandler);

            _duel.plEntrant.removeEventListener(Entrant.INIT_DONE,initDoneHandler);
            _duel.plEntrant.removeEventListener(Entrant.MOVE_DONE,moveDoneHandler);
            _duel.plEntrant.removeEventListener(Entrant.ATTACK_DONE,attackDoneHandler);
            _duel.plEntrant.removeEventListener(Entrant.DEFFENCE_DONE,deffenceDoneHandler);

//             _duel.reward.removeEventListener(Reward.UP,rewardUpHandler);
//             _duel.reward.removeEventListener(Reward.DOWN,rewardDownHandler);
//             _duel.reward.removeEventListener(Reward.CANCEL,rewardCancelHandler);
//             _duel.reward.removeEventListener(Reward.RETRY,rewardRetryHandler);

            _duel.removeEventListener(Duel.START, duelStartHandler);
            _duel.removeEventListener(Duel.END, duelEndHandler);


        }




    }
}
