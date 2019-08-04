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
    public class RaidServer extends Server
    {

        private var _command:RaidCommand;
        private var _crypted_sign:String;
        private var _ctrl:RaidCtrl;
//        private var _gameCtrl:GameCtrl;
        private var _match:Match;
        private var _duel:Duel;
        private var _edit:DeckEditor;

        private static var __instance:RaidServer;

        // 初期化 サーバを取得
        public function RaidServer(caller:Function = null)
         {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            _command = new RaidCommand(this);
         }

        private static function createInstance():RaidServer
        {
            return new RaidServer(arguments.callee);
        }

        public static function get instance():RaidServer
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
            address = Config.raidServerInfo.address;
            port = Config.raidServerInfo.port;
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("","","","","RS["+address+":"+port.toString()+"] ");
            }
        }


        protected override function get command():Command
        {
            return _command;
        }

        // 開始
        public function start(ctrl:RaidCtrl):void
        {
            _ctrl= ctrl;
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"raid p_session", player.session);
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

        // =========================
        // Duel Handler
        // =========================
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

        // Raid関連Noticeの取得
        public function csRequestNotice():void
        {
            // log.writeLog(log.LV_INFO, this, "cs RequestNotice");
            host.sendCommand(_command.csRequestNotice());
        }

        // Noticeから更新を受け取ったInventoryの再取得
        public function csRequestUpdateInventory(idList:Array):void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestUpdateInventory");
            host.sendCommand(_command.csRequestUpdateInventory(idList.join(",")));
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

        // ボス戦開始
        public function csBossDuelStart(invId:int,turn:int,useAp:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs boss duel start",invId,turn,useAp);
            host.sendCommand(_command.csBossDuelStart(invId,turn,useAp));
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
            // _edit = DeckEditor.instance;
            // _edit.addEventListener(DeckEditor.START, editStartHandler);
            // _edit.addEventListener(DeckEditor.END, editEndHandler);
        }

        // ログイン失敗
        public function loginFail():void
        {
            log.writeLog(log.LV_FATAL, this,"Login Failed!!");
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
            // log.writeLog(log.LV_INFO, this, "scUpdateCurrentDeckIndex");
            player.avatar.currentDeck = index;
        }


        // ==============
        // DuelSession
        // ==============
        // ゲームのセッションの決定
        public function scDetermineSession(id:int, foe:String, playerCharaID:String, foeCharaID:String, startDialogue:String,stage:int, plDmg0:int, plDmg1:int, plDmg2:int, foeDmg0:int, foeDmg1:int, foeDmg2:int):void
        {
            log.writeLog(log.LV_INFO, this,"Determine GameSession", id, foe,"plccid:", playerCharaID,"foeccid:",foeCharaID,"starDialogue:", startDialogue);
            Dialogue.instance.setMessage(startDialogue);
            _duel = Duel.instance;
            _duel.setQuestRule(false);      // By_K2 (퀘스트 여부 처리)
            // チャットコントローラに決定済みの
            ChatCtrl.instance.foeID = id;
            _duel.addEventListener(Duel.START, duelStartHandler);
            _duel.addEventListener(Duel.END, duelEndHandler);

            _duel.initialize(string2intArray(playerCharaID),string2intArray(foeCharaID),stage,[plDmg0,plDmg1,plDmg2],[foeDmg0,foeDmg1,foeDmg2],true);

            // Viewに開始の合図を出す
            // _ctrl.battle();
            new WaitThread(1100,_ctrl.battle,null,true).start();
        }

        // ==============
        // DuelStart&End
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
            ChatCtrl.instance.foeName = "";
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
            commandPush(_duel.foeEntrant.openMoveCards,[foeCards,string2BooleanArray(foeDir),foeLocked]);
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
        // Duel Entrant
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
        // Duel Feat
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
        // Duel 特殊
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
        // Duel Buff
        // ==============
        public function scBuffOnEvent(player:Boolean, index:int, buff_id:int, value:int, turn:int):void
        {
            // commandPush(_duel.buffOnEvent, [player, buff_id, value, turn, index]);
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
        // Duel Deck
        // ==============
        public function scDeckInitEvent(deckSize:int):void
        {
            log.writeLog(log.LV_INFO, this, "Deck Init Event");
            commandPush(_duel.initializeDeck,[deckSize]);
        }

        // ==============
        // Duel ActionCard
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

        // インフォメッセージを受け取る
        public function scMessageStrData(str:String):void
        {
            // log.writeLog(log.LV_INFO, this,"get chat messeage str data", str);
            commandPush(_ctrl.setMessageStrData, [str]);
        }
        // 渦情報メッセージを受け取る
        public function scPrfMessageStrData(str:String):void
        {
            log.writeLog(log.LV_INFO, this,"get prf messeage str data", str);
            _ctrl.setPrfMessageStrData(str);
        }

        public function scAddNotice(body:String):void
        {
            // log.writeLog(log.LV_INFO, this,"scAddNotice", body);
            _ctrl.addNotice(body);
        }

        // アチーブメントクリア
        public function scAchievementClear(achiID:int, itemType:int, itemID:int, itemNum:int, cType:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAchievementClear", achiID, itemType, itemID, itemNum, cType);
            LobbyNotice.setAchievementSuccessInfo(achiID, itemType, itemID, itemNum, cType);
            AchievementInventory.finishAchievementInventory(achiID);
            ClientLog.write( ClientLog.SUCC_ACHIEVEMENT, achiID, true );
        }

        // アチーブメント追加
        public function scAddNewAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAddNewAchievement", achiID);
            LobbyNotice.setAchievementNewInfo(achiID);

            new AchievementInventory(achiID, Const.ACHIEVEMENT_STATE_START)
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
        // Raid専用
        // ==============
        // BossBuffを登録する
        public function scAddBuffLimit(buffId:int,value:int,turn:int,limitTime:int):void
        {
            log.writeLog(log.LV_DEBUG, this,"scAddBuffLimit", buffId,value,limitTime);
            commandPush(_duel.bossBuffOnEvent, [buffId, value, turn, limitTime]);
        }

       // レイド戦スコアのアップデート
        public function scRaidScoreUpdate(score:int):void
        {
            log.writeLog(log.LV_DEBUG, this,"scRaidScoreUpdate");
            commandPush(_duel.setRaidScore, [score]);
        }

       // レイド戦レイジ発動時の情報
        public function scRaidRageInfo(charaSetStr:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"scRaidRageInfo", charaSetStr,charaSetStr.split(","));
            commandPush(_duel.ragePassiveOn,[charaSetStr.split(",")])
        }

        // 他の要因でDuelが終了する場合
        public function scFinishedDuel():void
        {
            log.writeLog(log.LV_DEBUG, this,"scFinishedDuel");
            commandPush(_ctrl.finishedGame,[]);
        }

        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {
            _ctrl.errorAlert(e);
            if (Const.PRF_ERROR_LIST.indexOf(e) != -1)
            {
                _ctrl.battleStartFailed();
            }

//            _ctrl.waitingStop();
        }



        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }

        // ==============
        // Handler
        // ==============
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

            _duel.removeEventListener(Duel.START, duelStartHandler);
            _duel.removeEventListener(Duel.END, duelEndHandler);
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

    }
}
