package net.server
{
    import flash.events.Event;

    import net.*;
    import net.command.*;
    import model.*;
    import model.events.*;
    import model.utils.ClientLog;
    import view.*;
    import view.utils.*;
    import controller.*;


    /**
     * ゲームの情報を扱うクラス
     *
     */
    public class WatchServer extends Server
    {

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_JP
        private static const _DISSCONET_NO_OPERATION	:String = "長時間操作が無かったため対戦を中断しました";
        CONFIG::LOCALE_JP
        private static const _DISSCONET_NO_OP_ALERT	:String = "操作がしばらく確認できません。\nこのまま操作が確認できなければ対戦を中断します";

        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT	:String = "Warning";
        CONFIG::LOCALE_EN
        private static const _DISSCONET_NO_OPERATION	:String = "Logged out due to an extended period inactivity.";
        CONFIG::LOCALE_EN
        private static const _DISSCONET_NO_OP_ALERT	:String = "Unable to confirm operation.\nIf an operation cannot be confirmed for a while, then this battle will be suspended.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_TCN
        private static const _DISSCONET_NO_OPERATION	:String = "因長時間無操作的關係與伺服器的連線中斷。";
        CONFIG::LOCALE_TCN
        private static const _DISSCONET_NO_OP_ALERT	:String = "暫時無法確認您的操作。\n若持續這樣的狀態，對戰將會被中斷。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_SCN
        private static const _DISSCONET_NO_OPERATION	:String = "由于长时间没有操作，已从服务器上退出。";
        CONFIG::LOCALE_SCN
        private static const _DISSCONET_NO_OP_ALERT	:String = "暂时无法操作。\n若操作还无法进行，对战将被中断。";

        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT	:String = "경고";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_CUTSV	:String = "서버와의 통신이 절단되었습니다.";
        CONFIG::LOCALE_KR
        private static const _DISSCONET_NO_OP_ALERT	:String = "操作がしばらく確認できません。\nこのまま操作が確認できなければ対戦を中断します";

        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT	:String = "Attention";
        CONFIG::LOCALE_FR
        private static const _DISSCONET_NO_OPERATION	:String = "Vous avez été déconnecté car inactif";
        CONFIG::LOCALE_FR
        private static const _DISSCONET_NO_OP_ALERT	:String = "Impossibiilité de vérifier l'opération effectuée.\nSi le problème persiste, le Duel sera interrompu.";

        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT	:String = "警告";
        CONFIG::LOCALE_ID
        private static const _DISSCONET_NO_OPERATION	:String = "長時間操作が無かったため対戦を中断しました";
        CONFIG::LOCALE_ID
        private static const _DISSCONET_NO_OP_ALERT	:String = "操作がしばらく確認できません。\nこのまま操作が確認できなければ対戦を中断します";

        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT   :String = "คำเตือน";
        CONFIG::LOCALE_TH
        private static const _DISSCONET_NO_OPERATION    :String = "การต่อสู้ถูกยกเลิกเนื่องจากไม่มีการเคลื่อนไหวเป็นเวลานาน";//"長時間操作が無かったため対戦を中断しました";
        CONFIG::LOCALE_TH
        private static const _DISSCONET_NO_OP_ALERT :String = "ไม่สามารถยืนยันการประมวลผลได้\nหากยังไม่สามารถยืนยันการประมวลผลได้อีกจะทำการยกเลิกการประลอง";


        // デュエル中の放置の警告時間
        public static const DUEL_NO_OP_ALERT_TIME:int = 5*60*1000; // 5分

        // デュエル中の放置の切断時間
        public static const DUEL_NO_OP_CLOSE_TIME:int = 8*60*1000; // 8分


        private var _command:WatchCommand;
        private var _crypted_sign:String;
        private var _ctrl:WatchCtrl;
        private var _match:Match;
        private var _duel:Duel;

        private static var __instance:WatchServer;

        private var _isReturn:Boolean = false;

        // 初期化 サーバを取得
        public function WatchServer(caller:Function = null)
         {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            _command = new WatchCommand(this);
//            ActionCard.setLoaderFunc(getActionCardInfo);
         }

        private static function createInstance():WatchServer
        {
            return new WatchServer(arguments.callee);
        }

        public static function get instance():WatchServer
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

        // 開始
        public function start(ctrl:WatchCtrl):void
        {
            _ctrl= ctrl;
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"game p_session", player.session);
            host.setSessionKey(player.session);
        }

        // 開始
        public override function exit():void
        {
            log.writeLog(log.LV_DEBUG, this,"exit start");
            super.exit()
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
        public function watchStart(uid:String):void
        {
            log.writeLog(log.LV_INFO, this,"Watch Start ");
            host.sendCommand(_command.csWatchStart(uid));
        }

        public function watchCommandGetStart():void
        {
            log.writeLog(log.LV_INFO, this,"Watch Command Get Start ");
            host.sendCommand(_command.csWatchCommandGetStart());
        }

        public function watchFinish():void
        {
            log.writeLog(log.LV_INFO, this,"Watch Finish ");
            host.sendCommand(_command.csWatchFinish());
        }


        public function startOk():void
        {
            log.writeLog(log.LV_INFO, this,"Game Start OK");
            host.sendCommand(_command.csStartOk());
        }

        // アイテムを使用する
        public function csAvatarUseItem(invId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar use item");
            host.sendCommand(_command.csAvatarUseItem(invId));
        }

        // 観戦をキャンセルする
        public function watchCancelOrder():void
        {
            log.writeLog(log.LV_INFO, this, "cs Watch Cancel");
            host.sendCommand(_command.csWatchCancel());
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
            _match = Match.instance;
        }

        // ログイン失敗
        public function loginFail():void
        {
            log.writeLog(log.LV_WARN, this,"Login Failed!!");
        }

        // 観戦をキャンセルした
        public function scWatchCancel():void
        {
            log.writeLog(log.LV_INFO, this, "sc Watch Cancel");
            _ctrl.watchCancelSuccess();
        }


        // インフォメッセージを受け取る
        public function scMessage(msg:String):void
        {
            // log.writeLog(log.LV_FATAL, this,"*********************** get chat messeage", msg);
            commandPush(_ctrl.setMessage, [msg]);
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

        // // ゲームのセッションの決定
        // public function scDetermineSession(id:int, foe:String, playerCharaID:String, foeCharaID:String, startDialogue:String,startDialogueId:int):void
        // {
        //     log.writeLog(log.LV_INFO, this,"Determine GameSession", id, foe,"plccid:", playerCharaID,"foeccid:",foeCharaID,"starDialogue:", startDialogue,"startDialogueId:", startDialogueId);
        //     Dialogue.instance.setMessage(startDialogue,startDialogueId);
        //     _duel = Duel.instance;
        //     // チャットコントローラに決定済みの
        //     ChatCtrl.instance.foeID = id;
        //     ChatCtrl.instance.foeName = foe;
        //     _duel.addEventListener(Duel.START, duelStartHandler);
        //     _duel.addEventListener(Duel.END, duelEndHandler);
        //     _duel.initialize(string2intArray(playerCharaID),string2intArray(foeCharaID));
        // }

        // ゲームのセッションの決定
        public function scDetermineSession(id:int, foe:String, playerCharaID:String, foeCharaID:String, startDialogue:String,startDialogueId:int,stage:int,plDmg:String,foeDmg:String):void
        {
            log.writeLog(log.LV_INFO, this,"Determine GameSession", id, foe,"plccid:", playerCharaID,"foeccid:",foeCharaID,"starDialogue:", startDialogue,"startDialogueId:", startDialogueId, "plDmg",plDmg, "foeDmg", foeDmg);
            Dialogue.instance.setMessage(startDialogue,startDialogueId);
            _duel = Duel.instance;
            _duel.setQuestRule(false);  // By_K2 (퀘스트 여부 처리)
            // チャットコントローラに決定済みの
            ChatCtrl.instance.foeID = id;
            ChatCtrl.instance.foeName = foe;
            _duel.addEventListener(Duel.START, duelStartHandler);
            _duel.addEventListener(Duel.END, duelEndHandler);
            _duel.initialize(string2intArray(playerCharaID),string2intArray(foeCharaID),stage,string2intArray(plDmg),string2intArray(foeDmg),false);
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
            _isReturn = false;
        }

        // デュエルのスタート
        public function scThreeToThreeDuelStart(deckSize:int, distance:int, playerEventDeckSize:int, foeEventDeckSize:int, multi:Boolean):void
        {
            log.writeLog(log.LV_INFO, this,"start multi duel", deckSize);
            if (multi)
            {
                _duel.setRule(Duel.RULE_3VS3);
            }else{
                _duel.setRule(Duel.RULE_1VS1);
            }
            MatchRoom.registCurrentStartedRoom();
            commandPush(_duel.initializeDeck, [deckSize]);
            _isReturn = false;
        }

        // デュエルの終了
        public function scOneToOneDuelFinish(result:int, gems:int, exp:int, gemsPow:int, expPow:int, bonus:Boolean):void
        {
            log.writeLog(log.LV_INFO, this,"duel end", result, gems, exp, gemsPow, expPow, bonus);
            commandPush(_duel.endGame, [result, gems, exp, gemsPow, expPow,bonus]);
            MatchCtrl.instance.matchFinish();
            _isReturn = true;
        }

        // デュエルの終了
        public function scThreeToThreeDuelFinish(result:int, gems:int, exp:int, bonus:Boolean):void
        {
            log.writeLog(log.LV_INFO, this,"multi duel end", result, gems, exp, bonus);
            commandPush(_duel.endGame, [result, gems, exp, bonus]);
            MatchCtrl.instance.matchFinish();
            _isReturn = true;
        }

        // 退出
        public function scWatchDuelRoomOut():void
        {
            if (_duel&&!_isReturn) {
                log.writeLog(log.LV_INFO, this, "WatchDuelRoomOut");
                commandClear();
                commandPush(_duel.endWatchGame, []);
                commandPush(_ctrl.watchViewFinish, [false]);
                _isReturn = true;
            }
        }

        public function scWatchDuelFinishEvent(isEnd:Boolean,winnerName:String):void
        {
            if (_duel&&!_isReturn) {
                log.writeLog(log.LV_INFO, this, "WatchDuelFinishEvent",winnerName);
                commandPush(_duel.endWatchGame, []);
                commandPush(_ctrl.watchViewFinish, [isEnd,winnerName]);
                _isReturn = true;
            }
        }

        // ==============
        // 準備
        // ==============
        public function scSetCharaBuffEvent(player:Boolean,buffStr:String):void
        {
            var buffArr:Array = buffStr.split("_");
            for (var i:int = 0; i < buffArr.length; i++) {
                var buffData:Array = buffArr[i].split(",");
                commandPush(_duel.buffCharaOnEvent, [player, buffData[0], buffData[1], buffData[2], buffData[3]]);
            }
        }

        public function scResetDeckNumEvent(deckSize:int):void
        {
            // log.writeLog(log.LV_INFO, this, "scResetDeckNumEvent",deckSize);
            commandPush(_duel.resetDeck, [deckSize]);
        }

        public function scSetInitiAndDistEvent(initi:Boolean,dist:int):void
        {
            // log.writeLog(log.LV_INFO, this, "scResetDeckNumEvent",deckSize);
            commandPush(_duel.setInitiative, [initi]);
            commandPush(_duel.setDistance, [dist]);
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
        public function scRewardFinalResult(gettedCards:String,totalGems:int=0,totalExp:int=0,addPoint:int=0):void
        {
            log.writeLog(log.LV_INFO, this,"reward final result", gettedCards,totalGems,totalExp);
            _duel.reward.finalResult(string2intArray(gettedCards),totalGems,totalExp,addPoint);
        }

        // 追加のキャラカードインベントリ情報を受け取る
        public function scCharaCardInventoryInfo(inv_id:String, card_id:String):void
        {
            log.writeLog(log.LV_INFO, this,"get chara card inventory ID is", inv_id, card_id);

            var invID:Array = string2intArray(inv_id);
            var cardID:Array = string2intArray(card_id);

            invID.forEach(function(item:*, index:int, array:Array):void{
                    CharaCardDeck.binder.addCharaCardInventory(new CharaCardInventory(item, CharaCard.ID(cardID[1]), 0, 0));
                    ClientLog.write( ClientLog.GOT_CHARA_CARD, cardID[1], true );
                });

        }

        // アイテムの取得
        public function scGetItem(inv_id:int,item_id:int):void
        {
            log.writeLog(log.LV_INFO, this,"get item inventory ID is", inv_id);
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

        // ==============
        // DuelPhase
        // ==============

        // TurnStartPhase
        public function scDuelStartTurnPhase(turnCount:int):void
        {
            log.writeLog(log.LV_INFO, this,"Start Turn Phase",turnCount);
            commandPush(_duel.setTurn, [turnCount]);
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
            log.writeLog(log.LV_INFO, this, "Determine Move Phase:","init",init,"dist",dist,"list",list,"dir",dir,"foeList",foeList,"foeDir",foeDir,"pow",pow,"foePow",foePow,"locked",locked,"foeLocked",foeLocked);
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
            log.writeLog(log.LV_INFO, this, "OPEN CARD LIST", foeCards);
            commandPush(AudienceEntrant(_duel.plEntrant).openMoveCards,[playerCards,string2BooleanArray(dir),locked]);
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
            log.writeLog(log.LV_INFO, this, "Attack Card Drop Phase Finish:","list",list,"dir",dir,"foeList",foeList,"foeDir",foeDir,"locked",locked,"foeLocked",foeLocked);
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
            commandPush(AudienceEntrant(_duel.plEntrant).openBattleCards,[playerCards,string2BooleanArray(dir),locked]);
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
            log.writeLog(log.LV_INFO, this, "Deffence Card Drop Phase Finish:","list",list,"dir",dir,"foeList",foeList,"foeDir",foeDir,"locked",locked,"foeLocked",foeLocked);
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
            commandPush(AudienceEntrant(_duel.plEntrant).openBattleCards,[playerCards,string2BooleanArray(dir),locked]);
            commandPush(_duel.foeEntrant.openBattleCards,[foeCards,string2BooleanArray(foeDir),foeLocked]);
            commandPush(_duel.deffenceCardDropPhaseFinish, []);
        }


        public function scDuelDetermineBattlePointPhase(list:String, dir:String, foeList:String, foeDir:String, locked:Boolean, foeLocked:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Determine Battle Point Phase:","list",list,"dir",dir,"foeList",foeList,"foeDir",foeDir,"locked",locked,"foeLocked",foeLocked);
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
//            log.writeLog(log.LV_FATAL, this, "OPNE CARD LIST", foeCards);

            commandPush(AudienceEntrant(_duel.plEntrant).openBattleCards,[playerCards,string2BooleanArray(dir),locked]);
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
            log.writeLog(log.LV_INFO, this, "Dead Chara Change Phase Start",player, foe);
            var playerCards:Array = ActionCard.idListToActionCards(string2intArray(list));
            var foeCards:Array =ActionCard.idListToActionCards(string2intArray(foeList));
            commandPush(_duel.plEntrant.setChangeDone,[player]);
            commandPush(_duel.foeEntrant.setChangeDone,[foe]);
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
                if (!_duel.isWatch) {
                    commandPush(_duel.plEntrant.moveCardAddSuccess,[ActionCard.ID(id),true,index]);
                } else {
                    // indexが-1は失敗なので無視する
                    if (index != -1)
                    {
                        commandPush(_duel.plEntrant.moveCardAdd,[null,true,index]);
                    }
                }
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
                if (!_duel.isWatch) {
                    commandPush(_duel.plEntrant.moveCardRemoveSuccess,[ActionCard.ID(id),true,index]);
                    commandPush(ActionCard.ID(id).activate,[false]);
                } else {
                    // indexが-1は失敗なので無視する
                    if (index != -1)
                    {
                        commandPush(_duel.plEntrant.moveCardRemove,[null,index]);
                    }
                }
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
                if (!_duel.isWatch) {
                    commandPush(ActionCard.ID(id).rotate,[dir]);
                } else {
                    commandPush(_duel.plEntrant.cardRotate,[null, dir, table,index]);
                }
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
                if (!_duel.isWatch) {
                    commandPush(_duel.plEntrant.battleCardAddSuccess,[ActionCard.ID(id),true,index]);
                } else {
                    // indexが-1は失敗なので無視する
                    if (index != -1)
                    {
                        commandPush(_duel.plEntrant.battleCardAdd,[null,true,index]);
                    }
                }
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
                if (!_duel.isWatch) {
                    commandPush(_duel.plEntrant.battleCardRemoveSuccess,[ActionCard.ID(id), true, index]);
                    commandPush(ActionCard.ID(id).activate,[false]);
                } else {
                    // indexが-1は失敗なので無視する
                    if (index != -1)
                    {
                        commandPush(_duel.plEntrant.battleCardRemove,[null, index]);
                    }
                }
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
                if (!_duel.isWatch) {
                    _duel.plEntrant.initDoneSuccess();
                } else {
                    commandPush(_duel.plEntrant.initDone,[]);
                }
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
                commandPush(_duel.plEntrant.attackDoneSuccess,[]);
                // _duel.plEntrant.attackDoneSuccess();
            }else{

//            commandPush(_duel.foeEntrant.attackDone,[]);
            }
        }

        public function scEntrantDeffenceDoneAction(player:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "Battle Done Action. Player?",player);
            if (player)
            {
                commandPush(_duel.plEntrant.deffenceDoneSuccess,[]);
                // _duel.plEntrant.deffenceDoneSuccess();

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
        }


        // キャラカードを変更
        public function scEntrantCharaChangeAction(player:Boolean, index:int, cardId:int, weaponBonus:String):void
        {
            log.writeLog(log.LV_INFO, this, "Player Chara Change Action", player, index, cardId, weaponBonus);

            commandPush(_duel.updateUnknownCharaCard,[player, index, cardId]);
            // _duel.updateUnknownCharaCard(player, index, cardId);
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

            log.writeLog(log.LV_INFO, this, "Entrant Update Weapon Event 1", _duel);
            if (_duel)log.writeLog(log.LV_INFO, this, "Entrant Update Weapon Event 2", _duel.plEntrant,_duel.foeEntrant);
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
//            log.writeLog(log.LV_INFO, this, "Player get Duel Bonus",type, value);
           commandPush(_duel.setDuelBonus, [type, value]);
        }

        // 現在ターン数をセット
        public function scSetTurnEvent(turn:int):void
        {
           commandPush(_duel.setTurn, [turn]);
        }

        // カードロック
        public function scCardLockEvent(id:int):void
        {
            //commandPush(_duel.cardLock, [id]);
        }

        // カードロック解除
        public function scClearCardLocksEvent():void
        {
            //commandPush(_duel.clearCardLocks);
        }

        // ==============
        // Feat
        // ==============
        public function scPlFeatOnEvent(feat_id:int):void
        {
            // 観戦の場合は表示させない
            // commandPush(_duel.featOnEvent, [true, feat_id]);
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
            //commandPush(_duel.buffOnEvent, [player, index, buff_id, value, turn]);
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

        // ==============
        // Item
        // ==============

        // アイテムの使用
        public function scUseItem(inv_id:int):void
        {
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アチーブメントクリア
        public function scAchievementClear(achiID:int, itemType:int, itemID:int, itemNum:int, cType:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAchievementClear", achiID, itemType, itemID, itemNum, cType);
            LobbyNotice.setAchievementSuccessInfo(achiID, itemType, itemID, itemNum, cType);
            AchievementInventory.finishAchievementInventory(achiID);
        }
        // アチーブメント追加
        public function scAddNewAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAddNewAchievement", achiID);
            LobbyNotice.setAchievementNewInfo(achiID);

            new AchievementInventory(achiID, Const.ACHIEVEMENT_STATE_START)
        }

        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {
            log.writeLog(log.LV_WARN, this,"Error no is", e);
            WaitingPanel.hide();
            _ctrl.errorAlert(e);
            // エラーが中断名rゲームを止める
            if (e == Const.ERROR_GAME_ABORT)
            {
                _ctrl.errorAbortGame();
                commandClear();
                _isReturn = true;
            }

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
            // log.writeLog(log.LV_INFO, this, "************************ duelStartHandler");

            _ctrl.watchCommandGetStart();
            // PlayerEntrantを監視する
            // _duel.plEntrant.addEventListener(DirectionEvent.UPDATE,setDirectionHandler);

            // _duel.plEntrant.addEventListener(ReplaceCardEvent.ADD_MOVE_TABLE,addMoveCardHandler);
            // _duel.plEntrant.addEventListener(ReplaceCardEvent.REMOVE_MOVE_TABLE,removeMoveCardHandler);

            // _duel.plEntrant.addEventListener(ReplaceCardEvent.ADD_ATTACK_BATTLE_TABLE,addAttackCardHandler);
            // _duel.plEntrant.addEventListener(ReplaceCardEvent.REMOVE_ATTACK_BATTLE_TABLE,removeAttackCardHandler);

            // _duel.plEntrant.addEventListener(ReplaceCardEvent.ADD_DEFFENCE_BATTLE_TABLE,addDeffenceCardHandler);
            // _duel.plEntrant.addEventListener(ReplaceCardEvent.REMOVE_DEFFNCE_BATTLE_TABLE,removeDeffenceCardHandler);

            // _duel.plEntrant.addEventListener(ReplaceCardEvent.ROTATE,rotateCardHandler);

            // _duel.plEntrant.addEventListener(CharaChangeEvent.CHARA_CHANGE, charaChangeHandler);

            // _duel.plEntrant.addEventListener(Entrant.INIT_DONE,initDoneHandler);
            // _duel.plEntrant.addEventListener(Entrant.MOVE_DONE,moveDoneHandler);
            // _duel.plEntrant.addEventListener(Entrant.ATTACK_DONE,attackDoneHandler);
            // _duel.plEntrant.addEventListener(Entrant.DEFFENCE_DONE,deffenceDoneHandler);

            // _duel.reward.addEventListener(Reward.UP,rewardUpHandler);
            // _duel.reward.addEventListener(Reward.DOWN,rewardDownHandler);
            // _duel.reward.addEventListener(Reward.CANCEL,rewardCancelHandler);
            // _duel.reward.addEventListener(Reward.RETRY,rewardRetryHandler);
        }

        // Duelが初期化された場合のイベントハンドラ
        private function duelEndHandler(e:Event):void
        {
            // PlayerEntrantを監視を解く
            // _duel.plEntrant.removeEventListener(DirectionEvent.UPDATE,setDirectionHandler);

            // _duel.plEntrant.removeEventListener(ReplaceCardEvent.ADD_MOVE_TABLE,addMoveCardHandler);
            // _duel.plEntrant.removeEventListener(ReplaceCardEvent.REMOVE_MOVE_TABLE,removeMoveCardHandler);

            // _duel.plEntrant.removeEventListener(ReplaceCardEvent.ADD_ATTACK_BATTLE_TABLE,addAttackCardHandler);
            // _duel.plEntrant.removeEventListener(ReplaceCardEvent.REMOVE_ATTACK_BATTLE_TABLE,removeAttackCardHandler);

            // _duel.plEntrant.removeEventListener(ReplaceCardEvent.ADD_DEFFENCE_BATTLE_TABLE,addDeffenceCardHandler);
            // _duel.plEntrant.removeEventListener(ReplaceCardEvent.REMOVE_DEFFNCE_BATTLE_TABLE,removeDeffenceCardHandler);

            // _duel.plEntrant.removeEventListener(ReplaceCardEvent.ROTATE,rotateCardHandler);

            // _duel.plEntrant.removeEventListener(CharaChangeEvent.CHARA_CHANGE, charaChangeHandler);

            // _duel.plEntrant.removeEventListener(Entrant.INIT_DONE,initDoneHandler);
            // _duel.plEntrant.removeEventListener(Entrant.MOVE_DONE,moveDoneHandler);
            // _duel.plEntrant.removeEventListener(Entrant.ATTACK_DONE,attackDoneHandler);
            // _duel.plEntrant.removeEventListener(Entrant.DEFFENCE_DONE,deffenceDoneHandler);


//             _duel.reward.removeEventListener(Reward.UP,rewardUpHandler);
//             _duel.reward.removeEventListener(Reward.DOWN,rewardDownHandler);
//             _duel.reward.removeEventListener(Reward.CANCEL,rewardCancelHandler);
//             _duel.reward.removeEventListener(Reward.RETRY,rewardRetryHandler);

            _duel.removeEventListener(Duel.START, duelStartHandler);
            _duel.removeEventListener(Duel.END, duelEndHandler);


        }


    }

}
