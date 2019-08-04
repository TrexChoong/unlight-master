package view.scene.game
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;

    import model.Duel;
    import model.Entrant;
    import model.events.*;

    import view.SleepThread;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.image.BaseImage;
    import view.scene.game.PhaseTimer;
    import view.image.game.BaseCard;
    import view.scene.game.CharaBuffsTable;
    import controller.*;

    /**
    * DuelTaleクラス
    * DropTable,PlayerHand,FoeHandをまとめて管理する
    *
    *
    */

    public class DuelTable  extends BaseScene
    {
        private static const _WAIT_TIME:int = 60;

//        private var _playerHand:PlayerHand;
        private var _playerHand:BaseHand;
        private var _foeHand:FoeHand;
        private var _dropTable:DropTable =  new DropTable();;

        // デッキエリア
        private var _deckArea:DeckArea  = new DeckArea();

        // ポジションエリア
        private var _positionArea:PositionArea  = new PositionArea();

        // 背景2(カード置き場所枠)
        private var _baseCard:BaseCard = new BaseCard();

        // ターン表示・タイマー
        private var _phaseTimer:PhaseTimer = new PhaseTimer(_WAIT_TIME);

        // 状態異常
        private const _BUFF_TABLE_SET_NUM:int = 3;
        private var _playerCharaBuffsTable:Vector.<CharaBuffsTable> = new Vector.<CharaBuffsTable>();
        private var _foeCharaBuffsTable:Vector.<CharaBuffsTable> = new Vector.<CharaBuffsTable>();

        // ダイス表示
        private var _plDiceManager:DiceManager;
        private var _foeDiceManager:DiceManager;
        private var _diceResult:DiceResult;

        // リザルト表示
        private var _resultScene:ResultScene;

        // ゲームのコントローラ

        private var _doneFunc:Function ;

        private var _duel:Duel;

        /**
        * コンストラクタ
        *
        */
        public function DuelTable(quest:Boolean = false)
        {
            if(quest)
            {
                _resultScene = new QuestResultScene();
            }else{
                _resultScene = new ResultScene();

            }

        }

        // 遅延評価
        public function tableInitialize(stage:Sprite):Thread
        {
            _duel = Duel.instance;
            _dropTable = new DropTable();
            _foeHand = new FoeHand(_dropTable, _duel.foeEntrant);
//            _playerHand = new PlayerHand(_dropTable, _duel.plEntrant);
            _playerHand = (!_duel.isWatch) ? new PlayerHand(_dropTable, _duel.plEntrant) : new AudienceHand(_dropTable, _duel.plEntrant);
            _phaseTimer.visible = false;
            _phaseTimer.isWatch = _duel.isWatch;
            _plDiceManager = new DiceManager(stage,0);
            _foeDiceManager = new DiceManager(stage,1);
            _diceResult = new DiceResult();

            for (var i:int = 0; i < _BUFF_TABLE_SET_NUM; i++) {
                var plBuffTable:CharaBuffsTable = new CharaBuffsTable(stage);
                var foeBuffTable:CharaBuffsTable = new CharaBuffsTable(stage,true,_duel.raidBoss);
                _dropTable.BG.addChild(plBuffTable);
                _dropTable.BG.addChild(foeBuffTable);
                _playerCharaBuffsTable.push(plBuffTable);
                _foeCharaBuffsTable.push(foeBuffTable);
            }

            // デュエルのイベントにハンドラを結びつける
            _duel.addEventListener(DealCardEvent.DEAL, dealHandler);
            _duel.addEventListener(DealCardEvent.GRAVE_DEAL, graveDealHandler);
            _duel.addEventListener(DealCardEvent.STEAL_DEAL, stealDealHandler);
            _duel.addEventListener(Duel.DECK_INIT, deckInitHandler);
            _duel.addEventListener(Duel.DECK_RESET, deckResetHandler);

            _duel.addEventListener(Duel.REFILL_PHASE, refilPhaseHandler);
            _duel.addEventListener(Duel.MOVE_CARD_DROP_PHASE_START, moveCardDropPhaseStartHandler);
            _duel.addEventListener(Duel.MOVE_CARD_DROP_PHASE_FINISH, moveCardDropPhaseFinishHandler);
            _duel.addEventListener(Duel.DETERMINE_MOVE_PHASE, determineMovePhaseHandler)
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_ATTACK_PHASE_START, battleCardDropAttackPhaseStartHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_DEFFENCE_PHASE_START, battleCardDropDeffencePhaseStartHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_WAITING_PHASE_START, battleCardDropWaitingPhaseStartHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_PHASE_FINISH, battleCardDropPhaseFinishHandler);
            _duel.addEventListener(Duel.DETERMINE_BATTLE_POINT_PHASE, determineBattlePointPhaseHandler);

            _duel.addEventListener(Duel.CHARA_CHANGE_PHASE_START, charaChangePhaseStartHandler);
            _duel.addEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_START, deadCharaChangePhaseStartHandler);

            _duel.addEventListener(Duel.USE_EVENT_ACTION_CARD, useEventActionCardHandler);

            _duel.addEventListener(Duel.DISTANCE_UPDATE, distanceUpdateHandler);

            _duel.addEventListener(SweepCardEvent.SWEEP_ALL_PLAYER, sweepAllPleyerCardHandler);
            _duel.addEventListener(SweepCardEvent.SWEEP_ALL_FOE, sweepAllFoeCardHandler);

            _duel.addEventListener(SweepCardEvent.SWEEP_PLAYER, sweepPleyerCardHandler);
            _duel.addEventListener(SweepCardEvent.SWEEP_FOE, sweepFoeCardHandler);

            _duel.addEventListener(SweepCardEvent.DISCARD_PLAYER, discardPleyerCardHandler);
            _duel.addEventListener(SweepCardEvent.DISCARD_FOE, discardFoeCardHandler);
            _duel.addEventListener(SweepCardEvent.STEAL_DISCARD_PLAYER, stealDiscardPleyerCardHandler);
            _duel.addEventListener(SweepCardEvent.STEAL_DISCARD_FOE, stealDiscardFoeCardHandler);


            _duel.addEventListener(RollResultEvent.PLAYER_ATTACK, battlePlayerResultHandler);
            _duel.addEventListener(RollResultEvent.FOE_ATTACK, battleFoeResultHandler);

            _duel.addEventListener(UpdateCardValueEvent.PLAYER_UPDATE, plUpdateCardValueHandler);
            _duel.addEventListener(CardLockEvent.LOCK, cardLockHandler);
            _duel.addEventListener(CardLockEvent.UNLOCK, cardUnlockHandler);
            _duel.addEventListener(EndGameEvent.GAME_END, endGameHandler);

            // Buffの更新
            _duel.addEventListener(BuffEvent.PLAYER, playerBuffHandler);
            _duel.addEventListener(BuffEvent.FOE, foeBuffHandler);
            _duel.addEventListener(BuffEvent.PLAYER_OFF, playerBuffOffHandler);
            _duel.addEventListener(BuffEvent.FOE_OFF, foeBuffOffHandler);
            _duel.addEventListener(BuffEvent.PLAYER_OFF_ALL, playerBuffOffAllHandler);
            _duel.addEventListener(BuffEvent.FOE_OFF_ALL, foeBuffOffAllHandler);
            _duel.addEventListener(BuffEvent.PLAYER_UPDATE, playerBuffUpdateHandler);
            _duel.addEventListener(BuffEvent.FOE_UPDATE, foeBuffUpdateHandler);
            _duel.addEventListener(BuffEvent.PLAYER_IDX, playerCharaBuffHandler);
            _duel.addEventListener(BuffEvent.FOE_IDX, foeCharaBuffHandler);

            _resultScene.setReward(_duel.reward);

            // DoneButtonとTimeに対してイベントハンドラを登録する
            _dropTable.doneButton.addEventListener(MouseEvent.CLICK,doneButtonClickHandler);
//            _positionArea.doneButton.addEventListener(MouseEvent.CLICK,doneButtonClickHandler);
            _phaseTimer.addEventListener(PhaseTimer.TIME_UP,doneButtonClickHandler);

            var plThread:ParallelExecutor = new ParallelExecutor();

            plThread.addThread(_phaseTimer.getShowThread(stage,22));
            plThread.addThread(_dropTable.getShowThread(stage,23));
            plThread.addThread(_foeHand.getShowThread(stage,24));
            plThread.addThread(_playerHand.getShowThread(stage,25));
//            plThread.addThread(_deckArea.getShowThread(stage,26));
            plThread.addThread(_diceResult.getShowThread(stage,30));
            for (var x:int = 0; x < _BUFF_TABLE_SET_NUM; x++) {
                plThread.addThread(_playerCharaBuffsTable[x].getShowThread(stage,24));
                plThread.addThread(_foeCharaBuffsTable[x].getShowThread(stage,24));
            }



            return plThread;
        }


        // 後処理
        public override function final():void
        {
            // DuelTableはサーバが落ちたときに初期化されずに削除される場合があるのでチェックが必要
            if (_duel!=null){
            // デュエルのイベントからハンドラを取り除く
                _duel.removeEventListener(DealCardEvent.DEAL, dealHandler);
                _duel.removeEventListener(DealCardEvent.GRAVE_DEAL, graveDealHandler);
                _duel.removeEventListener(DealCardEvent.STEAL_DEAL, stealDealHandler);
                _duel.removeEventListener(Duel.DECK_INIT, deckInitHandler);
                _duel.removeEventListener(Duel.DECK_RESET, deckResetHandler);

                _duel.removeEventListener(Duel.REFILL_PHASE, refilPhaseHandler);
                _duel.removeEventListener(Duel.MOVE_CARD_DROP_PHASE_START, moveCardDropPhaseStartHandler);
                _duel.removeEventListener(Duel.MOVE_CARD_DROP_PHASE_FINISH, moveCardDropPhaseFinishHandler);

                _duel.removeEventListener(Duel.CHARA_CHANGE_PHASE_START, charaChangePhaseStartHandler);
                _duel.removeEventListener(Duel.DEAD_CHARA_CHANGE_PHASE_START, deadCharaChangePhaseStartHandler);

                _duel.removeEventListener(Duel.DETERMINE_MOVE_PHASE, determineMovePhaseHandler);

                _duel.removeEventListener(Duel.BATTLE_CARD_DROP_ATTACK_PHASE_START, battleCardDropAttackPhaseStartHandler);
                _duel.removeEventListener(Duel.BATTLE_CARD_DROP_WAITING_PHASE_START, battleCardDropWaitingPhaseStartHandler);
                _duel.removeEventListener(Duel.BATTLE_CARD_DROP_DEFFENCE_PHASE_START, battleCardDropDeffencePhaseStartHandler);
                _duel.removeEventListener(Duel.BATTLE_CARD_DROP_PHASE_FINISH, battleCardDropPhaseFinishHandler);

                _duel.removeEventListener(Duel.DETERMINE_BATTLE_POINT_PHASE, determineBattlePointPhaseHandler);

                _duel.removeEventListener(Duel.USE_EVENT_ACTION_CARD, useEventActionCardHandler);

                _duel.removeEventListener(Duel.DISTANCE_UPDATE, distanceUpdateHandler);

                _duel.removeEventListener(SweepCardEvent.SWEEP_ALL_PLAYER, sweepAllPleyerCardHandler);
                _duel.removeEventListener(SweepCardEvent.SWEEP_ALL_FOE, sweepAllFoeCardHandler);

                _duel.removeEventListener(SweepCardEvent.SWEEP_PLAYER, sweepPleyerCardHandler);
                _duel.removeEventListener(SweepCardEvent.SWEEP_FOE, sweepFoeCardHandler);

                _duel.removeEventListener(SweepCardEvent.DISCARD_PLAYER, discardPleyerCardHandler);
                _duel.removeEventListener(SweepCardEvent.DISCARD_FOE, discardFoeCardHandler);
                _duel.removeEventListener(SweepCardEvent.STEAL_DISCARD_PLAYER, stealDiscardPleyerCardHandler);
                _duel.removeEventListener(SweepCardEvent.STEAL_DISCARD_FOE, stealDiscardFoeCardHandler);

                _duel.removeEventListener(RollResultEvent.PLAYER_ATTACK, battlePlayerResultHandler);
                _duel.removeEventListener(RollResultEvent.FOE_ATTACK, battleFoeResultHandler);

                _duel.removeEventListener(UpdateCardValueEvent.PLAYER_UPDATE, plUpdateCardValueHandler);
                _duel.removeEventListener(CardLockEvent.LOCK, cardLockHandler);
                _duel.removeEventListener(CardLockEvent.UNLOCK, cardUnlockHandler);
                _duel.removeEventListener(EndGameEvent.GAME_END, endGameHandler);

            }
            // DoneButtonとTimeに対してイベントハンドラを取り除く
            _dropTable.doneButton.removeEventListener(MouseEvent.CLICK,doneButtonClickHandler);
//            _positionArea.doneButton.removeEventListener(MouseEvent.CLICK,doneButtonClickHandler);
            _phaseTimer.removeEventListener(PhaseTimer.TIME_UP,doneButtonClickHandler);
//             if(_foeHand != null) {_foeHand.final();};
//             if(_playerHand != null) {_playerHand.final();};
            _foeHand = null;
            _playerHand = null;
//            _phaseTimer = null;

            var cbt:CharaBuffsTable;
            if(_playerCharaBuffsTable!=null)
            {
                while(_playerCharaBuffsTable.length > 0)
                {
                    cbt = _playerCharaBuffsTable.pop();
                    cbt = null;
                }
            }
            if(_foeCharaBuffsTable!=null)
            {
                while(_foeCharaBuffsTable.length > 0)
                {
                    cbt = _foeCharaBuffsTable.pop();
                    cbt = null;
                }
            }

            if (_plDiceManager !=null){_plDiceManager.destroy()}
            if (_foeDiceManager !=null){_foeDiceManager.destroy();}
            _plDiceManager = null;
            _foeDiceManager = null;

        }



        // カードが配られるイベントのハンドラ
        public function dealHandler(e:DealCardEvent):void
        {
            //log.writeLog (log.LV_INFO,this,"deal handler",e);
             var sExec:SerialExecutor = new SerialExecutor();
             var pExec:ParallelExecutor = new ParallelExecutor();
             var plSize:int = e.plACArray.length;
             var foeSize:int = e.foeACNum;
             var len:int = plSize+ foeSize;
             var turn:Boolean = (plSize > 0);
             var isEvent:Boolean = e.isEventCard;
             //log.writeLog(log.LV_FATAL, this, "evenis ",isEvent);

             sExec.addThread(new ClousureThread(playerHand.dragOff));
             sExec.addThread(new ClousureThread(_baseCard.onDisable));

             var acc:ActionCardClip;

             // 一枚ずつ交互にくばる
             for (var i:Number = 0; i < len; i++)
             {
                 if (turn)
                 {
                     if (plSize > 0)
                     {
                         if ( !_duel.isWatch ) {
                             acc = ActionCardClip.getInstance(e.plACArray.shift());
                         } else {
                             e.plACArray.shift(); // 数調整の為、Shiftはする
                             acc = ActionCardClip.getLergeBlankCardInstance();
                         }
                         if(isEvent)
                         {
                             pExec.addThread(playerHand.getAddEventACThread(acc, i));
                             // pExec.addThread(_playerHand.getAddEventACThread(ActionCardClip.getInstance(e.plACArray.shift()), i));
                             //pExec.addThread(_playerHand.getAddACThread(ActionCardClip.getInstance(e.plACArray.shift()), i));
                         }else{
                             pExec.addThread(playerHand.getAddACThread(acc, i));
                             // pExec.addThread(_playerHand.getAddACThread(ActionCardClip.getInstance(e.plACArray.shift()), i));
                             pExec.addThread(_deckArea.decrementThread(i));
                         }
                     }
                     if (foeSize>0){turn = false;}
                 }
                 else
                 {
                     if (foeSize>0)
                     {
                         acc = ActionCardClip.getBlankCardInstance();
                         if(isEvent)
                         {
                             pExec.addThread(_foeHand.getAddEventACThread(acc, i));
                             // pExec.addThread(_foeHand.getAddEventACThread(ActionCardClip.getBlankCardInstance(), i));
                             //pExec.addThread(_foeHand.getAddACThread(ActionCardClip.getBlankCardInstance(), i));
                         }else{
                             pExec.addThread(_foeHand.getAddACThread(acc, i));
                             // pExec.addThread(_foeHand.getAddACThread(ActionCardClip.getBlankCardInstance(), i));
                             pExec.addThread(_deckArea.decrementThread(i));
                         }
                         foeSize -= 1;
                     }
                     if (e.plACArray.length > 0){turn = true;}
                 }
             }
             sExec.addThread(pExec);

             sExec.addThread(new ClousureThread(playerHand.dragOn));
             sExec.addThread(new ClousureThread(_baseCard.onEnable));
             GameCtrl.instance.addViewSequence(sExec);

        }

        // 墓地からカードが配られるイベントのハンドラ
        public function graveDealHandler(e:DealCardEvent):void
        {
             log.writeLog (log.LV_INFO,this,"deal handler",e);
             var sExec:SerialExecutor = new SerialExecutor();
             var pExec:ParallelExecutor = new ParallelExecutor();
             var plSize:int = e.plACArray.length;
             var foeSize:int = e.foeACNum;
             var len:int = plSize+ foeSize;
             var turn:Boolean = (plSize > 0);

             sExec.addThread(new ClousureThread(playerHand.dragOff))
             sExec.addThread(new ClousureThread(_baseCard.onDisable))

             // 一枚ずつ交互にくばる
             for (var i:Number = 0; i < len; i++)
             {
                 if (turn)
                 {
                     if (e.plACArray.length > 0)
                     {
                         var acc:ActionCardClip;
                         if ( !_duel.isWatch ) {
                             acc = ActionCardClip.getInstance(e.plACArray.shift());
                         } else {
                             e.plACArray.shift(); // 数調整の為、Shiftはする
                             acc = ActionCardClip.getLergeBlankCardInstance();
                         }
                         pExec.addThread(playerHand.getAddACFromGraveThread(acc, i));
                         // pExec.addThread(playerHand.getAddACFromGraveThread(ActionCardClip.getInstance(e.plACArray.shift()), i));
                     }
                     if (foeSize>0){turn = false;}
                 }
                 else
                 {
                     if (foeSize>0)
                     {
                         pExec.addThread(_foeHand.getAddACFromGraveThread(ActionCardClip.getBlankCardInstance(), i));
                         foeSize -= 1;
                     }
                     if (e.plACArray.length > 0){turn = true;}
                 }
             }
             sExec.addThread(pExec);
             sExec.addThread(new ClousureThread(playerHand.dragOn));
             sExec.addThread(new ClousureThread(_baseCard.onEnable))
             GameCtrl.instance.addViewSequence(sExec);
        }

        public function plUpdateCardValueHandler(e:UpdateCardValueEvent):void
        {
            playerHand.updateCardValue(e.card_id, e.u_value, e.b_value, e.reset);
        }

        public function cardLockHandler(e:CardLockEvent):void
        {
            playerHand.cardLock(e.id);
        }

        public function cardUnlockHandler(e:CardLockEvent):void
        {
            playerHand.cardUnlock();
        }

        //相手からカードが配られるイベントのハンドラ
        public function stealDealHandler(e:DealCardEvent):void
        {
             log.writeLog (log.LV_INFO,this,"deal handler",e);
             var sExec:SerialExecutor = new SerialExecutor();
             var pExec:ParallelExecutor = new ParallelExecutor();
             var plSize:int = e.plACArray.length;
             var foeSize:int = e.foeACNum;
             var len:int = plSize+ foeSize;
             var turn:Boolean = (plSize > 0);

             sExec.addThread(new ClousureThread(playerHand.dragOff))
             sExec.addThread(new ClousureThread(_baseCard.onDisable))

             // 一枚ずつ交互にくばる
             for (var i:Number = 0; i < len; i++)
             {
                 if (turn)
                 {
                     if ((e.plACArray.length > 0)&&(foeSize == 0))
                     {
                         var acc:ActionCardClip;
                         if ( !_duel.isWatch ) {
                             acc = ActionCardClip.getInstance(e.plACArray.shift());
                         } else {
                             e.plACArray.shift(); // 数調整の為、Shiftはする
                             acc = ActionCardClip.getLergeBlankCardInstance();
                         }
                         pExec.addThread(playerHand.getAddACFromStealThread(acc, i, _foeHand.endX, _foeHand.endY));
                         // pExec.addThread(playerHand.getAddACFromStealThread(ActionCardClip.getInstance(e.plACArray.shift()), i, _foeHand.endX, _foeHand.endY));
                     }
                     if (foeSize>0){turn = false;}
                 }
                 else
                 {
                     if (foeSize>0)
                     {
                         pExec.addThread(_foeHand.getAddACFromStealThread(ActionCardClip.getBlankCardInstance(), i, 0 , 0));
                         foeSize -= 1;
                     }
                     if (e.plACArray.length > 0){turn = true;}
                 }
             }
             sExec.addThread(pExec);
             sExec.addThread(new ClousureThread(playerHand.dragOn));
             sExec.addThread(new ClousureThread(_baseCard.onEnable))
             // GameCtrl.instance.addViewSequence(sExec);
             GameCtrl.instance.addNoWaitViewSequence(sExec);
        }


        // デッキが初期化されるイベントのハンドラ
        private function deckInitHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(_deckArea.initDeck(_duel.deckSize));
        }

        // デッキが再設定されるイベントのハンドラ
        private function deckResetHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(_deckArea.resetDeck(_duel.deckSize));
        }

        // 距離が更新される時のハンドラ
        private function distanceUpdateHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "DISTANCE UPDATE", _duel.distance);
            _positionArea.updateDistance(_duel.distance);
        }


        // =======================
        // デュエルフェイズのハンドラ
        // =======================

        // 補充フェイズのハンドラ
        private function refilPhaseHandler(e:Event):void
        {
            // 補充フェイズの時は、必ずnullにしておく
            _doneFunc = null;

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_dropTable.getSetRefillPhaseThread());
            pExec.addThread(_phaseTimer.getHideThread());
            pExec.addThread(_playerCharaBuffsTable[_duel.plEntrant.currentCharaCardIndex].getBringOnThread());
            pExec.addThread(_foeCharaBuffsTable[_duel.foeEntrant.currentCharaCardIndex].getBringOnThread());
            GameCtrl.instance.addViewSequence(pExec);
        }

        // 移動カードドロップフェイズの開始
        private function moveCardDropPhaseStartHandler(e:Event):void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_dropTable.getSetMoveCardDropPhaseThread());
            pExec.addThread(_phaseTimer.getSetMoveCardDropPhaseThread());
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(function():void{_doneFunc = initDone}));
            sExec.addThread(new ClousureThread(playerHand.dragOn));
            GameCtrl.instance.addViewSequence(sExec);
        }

        // 移動カードドロップフェイズの終了
        private function moveCardDropPhaseFinishHandler(e:Event):void
        {
            // フェイズ終了毎にnullを入れておく
            _doneFunc = null;

            _phaseTimer.onTimerStop();
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOff));
            GameCtrl.instance.addViewSequence(new ClousureThread(_baseCard.onDisable))
        }


        // 移動決定フェイズ
        private function determineMovePhaseHandler (e:Event):void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            GameCtrl.instance.addViewSequence(pExec);
            if (_duel.isWatch) {
                GameCtrl.instance.addViewSequence(playerHand.getOpenTableCardsThread());
            }
            GameCtrl.instance.addViewSequence(_foeHand.getOpenTableCardsThread());
        }

        // 攻撃フェイズにする
        private function battleCardDropAttackPhaseStartHandler(e:Event):void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_dropTable.getSetBattleAttackPhaseThread());
            pExec.addThread(_phaseTimer.getSetBattlePhaseThread());
            pExec.addThread(_playerCharaBuffsTable[_duel.plEntrant.currentCharaCardIndex].getBringOnThread());
            pExec.addThread(_foeCharaBuffsTable[_duel.foeEntrant.currentCharaCardIndex].getBringOnThread());
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(pExec);
            var pExec2:ParallelExecutor = new ParallelExecutor();
            sExec.addThread(pExec2);
            sExec.addThread(new ClousureThread(function():void{_doneFunc = attackDone}));
            GameCtrl.instance.addViewSequence(new ClousureThread(_baseCard.onEnable))
            GameCtrl.instance.addViewSequence(sExec);
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOn));
        }

        // 防御フェイズにする
        private function battleCardDropDeffencePhaseStartHandler(e:Event):void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_dropTable.getSetBattleDeffencePhaseThread());
            pExec.addThread(_phaseTimer.getSetBattlePhaseThread());
            pExec.addThread(_playerCharaBuffsTable[_duel.plEntrant.currentCharaCardIndex].getBringOnThread());
            pExec.addThread(_foeCharaBuffsTable[_duel.foeEntrant.currentCharaCardIndex].getBringOnThread());
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(function():void{_doneFunc = deffenceDone}));
            GameCtrl.instance.addViewSequence(new ClousureThread(_baseCard.onEnable))
            GameCtrl.instance.addViewSequence(sExec);
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOn));
        }

       // 待機フェイズにする
        private function battleCardDropWaitingPhaseStartHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOff));
            GameCtrl.instance.addViewSequence(new ClousureThread(_baseCard.onDisable))
             var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_dropTable.getSetBattleWaitingPhaseThread());
            pExec.addThread(_phaseTimer.getSetBattlePhaseThread());
            pExec.addThread(_playerCharaBuffsTable[_duel.plEntrant.currentCharaCardIndex].getBringOnThread());
            pExec.addThread(_foeCharaBuffsTable[_duel.foeEntrant.currentCharaCardIndex].getBringOnThread());
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(function():void{_doneFunc = null}));
            GameCtrl.instance.addViewSequence(sExec);
//            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOn));
        }

        // 攻撃/防御フェイズ終了
        private function battleCardDropPhaseFinishHandler(e:Event):void
        {
            // フェイズ終了毎にnullを入れておく
            _doneFunc = null;

            _phaseTimer.onTimerStop();
            if (_duel.isWatch) {
                GameCtrl.instance.addViewSequence(playerHand.getOpenTableCardsThread());
            }
            GameCtrl.instance.addViewSequence(_foeHand.getOpenTableCardsThread());
        }


        // バトルカード決定
        private function determineBattlePointPhaseHandler(e:Event):void
        {
//            GameCtrl.instance.addViewSequence(_dropTable.getSetBattleResultThread());
//            GameCtrl.instance.addViewSequence(_foeHand.getOpenTableCardsThread());
            // DropTableとPhaseTimerを隠す
            var pExec2:ParallelExecutor = new ParallelExecutor();z
            pExec2.addThread(_dropTable.getHidePhaseThread());
            pExec2.addThread(_phaseTimer.getHideThread());
            pExec2.addThread(_playerCharaBuffsTable[_duel.plEntrant.currentCharaCardIndex].getBringOffThread());
            pExec2.addThread(_foeCharaBuffsTable[_duel.foeEntrant.currentCharaCardIndex].getBringOffThread());
            GameCtrl.instance.addViewSequence(pExec2);
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOff));
            GameCtrl.instance.addViewSequence(new ClousureThread(_baseCard.onDisable))
        }

        // キャラチェンジフェイズにする
        private function charaChangePhaseStartHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOff));
            GameCtrl.instance.addViewSequence(new ClousureThread(_baseCard.onDisable))
//            log.writeLog(log.LV_WARN, this, "wait phase start");
             var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_dropTable.getSetCharaChangePhaseThread());
            pExec.addThread(_phaseTimer.getSetBattlePhaseThread());
            pExec.addThread(_playerCharaBuffsTable[_duel.plEntrant.currentCharaCardIndex].getBringOffThread());
            pExec.addThread(_foeCharaBuffsTable[_duel.foeEntrant.currentCharaCardIndex].getBringOffThread());
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(function():void{_doneFunc = changeDone}));
            GameCtrl.instance.addViewSequence(sExec);
//            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOn));
        }

        // キャラ死亡時のキャラチェンジフェイズにする
        private function deadCharaChangePhaseStartHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOff));
            GameCtrl.instance.addViewSequence(new ClousureThread(_baseCard.onDisable))
//            log.writeLog(log.LV_WARN, this, "wait phase start");
             var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_dropTable.getSetCharaChangePhaseThread());
            pExec.addThread(_phaseTimer.getSetBattlePhaseThread());
            pExec.addThread(_playerCharaBuffsTable[_duel.plEntrant.currentCharaCardIndex].getBringOffThread());
            pExec.addThread(_foeCharaBuffsTable[_duel.foeEntrant.currentCharaCardIndex].getBringOffThread());
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(function():void{_doneFunc = deadChangeDone}));
            GameCtrl.instance.addViewSequence(sExec);
//            GameCtrl.instance.addViewSequence(new ClousureThread(playerHand.dragOn));
        }


        // 自分のドロップテーブルにあるカードを捨てる
        private function sweepPleyerCardHandler(e:SweepCardEvent):void
        {
//            log.writeLog(log.LV_FATAL, this, "sweepPlayerCard",e.actionCards);
            GameCtrl.instance.addViewSequence(playerHand.getWipeTableCardsThread(e.actionCards));
        }

        // 相手のドロップテーブルにあるカードを捨てる
        private function sweepFoeCardHandler(e:SweepCardEvent):void
        {
            GameCtrl.instance.addViewSequence(_foeHand.getWipeTableCardsThread(e.actionCards));
        }

        // 自分のドロップテーブルにあるカードをすべて捨てる
        private function sweepAllPleyerCardHandler(e:SweepCardEvent):void
        {
//            GameCtrl.instance.addNoWaitViewSequence(playerHand.getWipeAllTableCardsThread(e.actionCards));
            GameCtrl.instance.addViewSequence(playerHand.getWipeAllTableCardsThread(e.actionCards));
        }

        // 相手のドロップテーブルにあるカードをすべて捨てる
        private function sweepAllFoeCardHandler(e:SweepCardEvent):void
        {
//            GameCtrl.instance.addNoWaitViewSequence(_foeHand.getWipeAllTableCardsThread(e.actionCards));
            GameCtrl.instance.addViewSequence(_foeHand.getWipeAllTableCardsThread(e.actionCards));
        }

        // 自分の手札のカードを捨てる
        private function discardPleyerCardHandler(e:SweepCardEvent):void
        {
            GameCtrl.instance.addViewSequence(playerHand.getWipeHandCardsThread(e.actionCards));
        }

        // 相手の手札のカードを捨てる
        private function discardFoeCardHandler(e:SweepCardEvent):void
        {
            GameCtrl.instance.addViewSequence(_foeHand.getWipeHandCardsThread(e.actionCards));
        }

        // 自分のカードが盗まれて消える
        private function stealDiscardPleyerCardHandler(e:SweepCardEvent):void
        {
//            GameCtrl.instance.addNoWaitViewSequence(playerHand.getVanishHandCardsThread(e.actionCards));
            GameCtrl.instance.addViewSequence(playerHand.getVanishHandCardsThread(e.actionCards));
        }

        // 相手のカードが盗まれて消える
        private function stealDiscardFoeCardHandler(e:SweepCardEvent):void
        {
//            GameCtrl.instance.addNoWaitViewSequence(_foeHand.getVanishHandCardsThread(e.actionCards));
            GameCtrl.instance.addViewSequence(_foeHand.getVanishHandCardsThread(e.actionCards));
        }

        // アクションイベントカード使用する
        private function useEventActionCardHandler(e:Event):void
        {

            GameCtrl.instance.addViewSequence(SE.getChanceCardSEThread(0));
        }


        // 自分が攻撃の場合
        private function battlePlayerResultHandler(e:RollResultEvent):void
        {
            _plDiceManager.eyeArray = e.atkDice;
            _foeDiceManager.eyeArray = e.defDice;y
            // 自分と相手のダイスを出す
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_plDiceManager.getRollDiceThread(0));
            pExec.addThread(_foeDiceManager.getRollDiceThread(1));
            GameCtrl.instance.addViewSequence(pExec);
            GameCtrl.instance.addViewSequence(new SleepThread(500));
            pExec2.addThread(_plDiceManager.getHideDiceThread());
            pExec2.addThread(_foeDiceManager.getHideDiceThread());
            pExec2.addThread(_diceResult.getResultThread(_plDiceManager.eyeArray, 0, _foeDiceManager.eyeArray, 1));
            GameCtrl.instance.addViewSequence(pExec2);
        }

        // 敵が攻撃
        private function battleFoeResultHandler(e:RollResultEvent):void
        {
            _foeDiceManager.eyeArray = e.atkDice;
            _plDiceManager.eyeArray = e.defDice;
            // 自分と相手のダイスを出す
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_foeDiceManager.getRollDiceThread(0));
            pExec.addThread(_plDiceManager.getRollDiceThread(1));
            GameCtrl.instance.addViewSequence(pExec);
            GameCtrl.instance.addViewSequence(new SleepThread(500));
            pExec2.addThread(_plDiceManager.getHideDiceThread());
            pExec2.addThread(_foeDiceManager.getHideDiceThread());
            pExec2.addThread(_diceResult.getResultThread(_plDiceManager.eyeArray, 1, _foeDiceManager.eyeArray, 0));
            GameCtrl.instance.addViewSequence(pExec2);
        }

        // 戦闘結果フェイズにする
        private function nextBattleHandler(e:Event):void
        {
            //setBattlePhase();
        }

        // 戦闘終了ハンドラ（結果をだして抜ける
        private function endGameHandler(e:EndGameEvent):void
        {
            GameCtrl.instance.addViewSequence(_foeHand.getVanishAllHandCards());
            GameCtrl.instance.addViewSequence(playerHand.getVanishAllHandCards());
            log.writeLog(log.LV_INFO, this, "e.result, e.gems, e.exp, e.expBonus, e.gemsPow, e.expPow, e.totalGems, e.totalExp",e.result, e.gems, e.exp, e.expBonus, e.gemsPow, e.expPow, e.totalGems, e.totalExp);
            GameCtrl.instance.addViewSequence(_resultScene.getResultThread(e.result, e.gems, e.exp, e.expBonus, e.gemsPow, e.expPow, e.totalGems, e.totalExp));
        }

        // =======================
        // 状態異常ハンドラ
        // =======================
        // プレイヤー側の状態付加イベント
        private function playerBuffHandler(e:BuffEvent):void
        {
            var currentIndex:int = _duel.plEntrant.currentCharaCardIndex;
            if (_playerCharaBuffsTable&&_playerCharaBuffsTable.length > 0) {
                _playerCharaBuffsTable[currentIndex].addBuffStatus(e.id, e.value, e.turn);
            }
        }

        // 対戦相手側の状態付加イベント
        private function foeBuffHandler(e:BuffEvent):void
        {
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            if (_foeCharaBuffsTable&&_foeCharaBuffsTable.length > 0) {
                _foeCharaBuffsTable[currentIndex].addBuffStatus(e.id, e.value, e.turn);
            }
        }

        // プレイヤー側の状態解除イベント
        private function playerBuffOffHandler(e:BuffEvent):void
        {
            //var currentIndex:int = _duel.plEntrant.currentCharaCardIndex;
            if (_playerCharaBuffsTable&&_playerCharaBuffsTable.length > 0) {
                _playerCharaBuffsTable[e.index].removeBuffStatus(e.id, e.value);
            }
        }

        // 対戦相手側の状態解除イベント
        private function foeBuffOffHandler(e:BuffEvent):void
        {
            //var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            if (_foeCharaBuffsTable&&_foeCharaBuffsTable.length > 0) {
                _foeCharaBuffsTable[e.index].removeBuffStatus(e.id, e.value);
            }
        }

        // プレイヤー側の全状態解除イベント
        private function playerBuffOffAllHandler(e:BuffEvent):void
        {
            var currentIndex:int = _duel.plEntrant.currentCharaCardIndex;
            if (_playerCharaBuffsTable&&_playerCharaBuffsTable.length > 0) {
                _playerCharaBuffsTable[currentIndex].removeBuffStatusAll();
            }
        }

        // 対戦相手側の全状態解除イベント
        private function foeBuffOffAllHandler(e:BuffEvent):void
        {
            var currentIndex:int = _duel.foeEntrant.currentCharaCardIndex;
            if (_foeCharaBuffsTable&&_foeCharaBuffsTable.length > 0) {
                _foeCharaBuffsTable[currentIndex].removeBuffStatusAll();
            }
        }

        // プレイヤーの状態異常更新
        private function playerBuffUpdateHandler(e:BuffEvent):void
        {
            if (_playerCharaBuffsTable&&_playerCharaBuffsTable.length > 0) {
                _playerCharaBuffsTable[e.index].updateBuffStatus(e.id, e.value, e.turn);
            }
        }

        // 対戦相手側の状態異常更新
        private function foeBuffUpdateHandler(e:BuffEvent):void
        {
            if (_foeCharaBuffsTable&&_foeCharaBuffsTable.length > 0) {
                _foeCharaBuffsTable[e.index].updateBuffStatus(e.id, e.value, e.turn);
            }
        }

        // プレイヤー側のキャラ指定状態付加イベント
        private function playerCharaBuffHandler(e:BuffEvent):void
        {
            if (_playerCharaBuffsTable&&_playerCharaBuffsTable.length > 0) {
                _playerCharaBuffsTable[e.index].addBuffStatus(e.id, e.value, e.turn);
            }
        }

        // 対戦相手側の状態付加イベント
        private function foeCharaBuffHandler(e:BuffEvent):void
        {
            if (_foeCharaBuffsTable&&_foeCharaBuffsTable.length > 0) {
                _foeCharaBuffsTable[e.index].addBuffStatus(e.id, e.value, e.turn);
            }
        }



        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            return new ShowThread(this, stage);
        }

        // 消去用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        private function doneButtonClickHandler(e:Event):void
        {
//            _phaseTimer.onTimerStop();
            if(_doneFunc == null)
            {
                return;
            }
            _doneFunc();
        }

        // イニシアチブ決定
        private function initDone():void
        {
            log.writeLog (log.LV_INFO,this,"initDone");

            playerHand.dragOff();
            _baseCard.onDisable()

            _duel.plEntrant.initDone();
        }

        // キャラ変更決定
        private function changeDone():void
        {
            _duel.plEntrant.charaChange(_duel.plEntrant.currentCharaCardIndex);
        }

        // 死亡キャラ変更決定
        private function deadChangeDone():void
        {
            _duel.plEntrant.charaChange(_duel.plEntrant.liveCharaCardIndex);
        }

//          // 移動決定
//          private function moveDone():void
//          {
//              _duel.plEntrant.moveDone(_positionArea.movingDistance);
//          }

        // 戦闘決定
        private function deffenceDone():void
        {
            playerHand.dragOff();
            _baseCard.onDisable()
            _duel.plEntrant.deffenceDone();
        }

        // 戦闘決定
        private function attackDone():void
        {
            playerHand.dragOff();
            _baseCard.onDisable()
            _duel.plEntrant.attackDone();
        }

        public function get positionArea():PositionArea
        {
            return _positionArea;
        }

        public function get deckArea():DeckArea
        {
            return _deckArea;
        }

        public function get resultScene():ResultScene
        {
            return _resultScene;
        }

        public function get baseCard():BaseCard
        {
            return _baseCard;
        }

        private function get playerHand():*
        {
            if ( _duel.isWatch ) {
                return AudienceHand(_playerHand);
            } else {
                return PlayerHand(_playerHand);
            }
        }

        public function getAllHideThread():Thread
        {
            var plThread:ParallelExecutor = new ParallelExecutor();
             if( _phaseTimer != null){plThread.addThread(_phaseTimer.getHideThread());}
             if( _dropTable != null){plThread.addThread(_dropTable.getHideThread());}
             if( _foeHand != null){plThread.addThread(_foeHand.getHideThread());}
             if( _playerHand != null){plThread.addThread(_playerHand.getHideThread());}
            return plThread;
        }

        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if( _baseCard != null)     {pExec.addThread(_baseCard.getBringOffThread());}
            if( _positionArea != null) {pExec.addThread(_positionArea.getBringOffThread());}
            if( _deckArea != null)     {pExec.addThread(_deckArea.getBringOffThread());}
            if( _foeHand != null)      {pExec.addThread(_foeHand.getBringOffThread());}
            if( _playerHand != null)   {pExec.addThread(_playerHand.getBringOffThread());}
            if( _dropTable != null)    {pExec.addThread(_dropTable.getBringOffThread());}
            if( _phaseTimer != null)   {pExec.addThread(_phaseTimer.getBringOffThread());}
            var i:int;
            if( _playerCharaBuffsTable != null) {
                for (i = 0; i < _playerCharaBuffsTable.length; i++) {
                    pExec.addThread(_playerCharaBuffsTable[i].getBringOffThread());
                }
            }
            if( _foeCharaBuffsTable != null) {
                for (i = 0; i < _foeCharaBuffsTable.length; i++) {
                    pExec.addThread(_foeCharaBuffsTable[i].getBringOffThread());
                }
            }
            return pExec;
        }

    }

}

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import org.libspark.thread.Thread;

import model.Duel;
import model.Player;
import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.game.DuelTable;
import org.libspark.thread.utils.*;

class ShowThread extends BaseShowThread
{

    public function ShowThread(dt:DuelTable, stage:DisplayObjectContainer)
    {
        super(dt, stage)
    }

    protected override function run():void
    {
        next(duelWaiting);
    }

    private function duelWaiting():void
    {
        if (Duel.instance.inited == false)
        {
            if (Player.instance.state == Player.STATE_LOGOUT)
            {
                return;
            }
            else
            {
                next(duelWaiting);
            }
            
        }else{
            next(init)
        }



    }


    private function init ():void
    {
        var thread:Thread;
        thread =  DuelTable(_view).tableInitialize(Sprite(_stage));
        thread.start();
        thread.join();
        next(close);
    }

}


// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    private var _dt:DuelTable;

    public function HideThread(dt:DuelTable)
    {
        _dt = dt;
        super(dt);
    }

    protected override function run():void
    {
        var thread:Thread;

        thread = _dt.getAllHideThread();
        thread.start();
        thread.join();
        next(exit);
    }



}
