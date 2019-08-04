package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    import mx.core.UIComponent;
    import mx.core.MovieClipLoaderAsset;
    import mx.events.StateChangeEvent;
    import mx.containers.Panel;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.errors.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Player;
    import model.Duel;
    import model.ActionCard;
    import model.Match;
    import model.MatchRoom;
    import model.Channel;
    import model.events.EndGameEvent;
    import model.events.FieldStatusEvent;

    import view.scene.common.Transition;
    import view.scene.common.AvatarClip;

    import view.image.game.*;
    import view.scene.game.*;
    import view.utils.*;
    import controller.*;

    /**
     * ゲームのビュークラス
     *
     */
    public class GameView extends Thread
    {
        // プレイヤーインスタンス
        private var _player:Player = Player.instance;

        //private var _base:BaseCardFrame  = new BaseCardFrame();
        private var _base:BaseCardFrameScene  = new BaseCardFrameScene();

        // BG
        private var _nbg:NearBG;
        private var _nnbg:NearBG;       // フィールド状態用
        private var _fbg:FarBG;

        // デュエルのオープニング
        private var _opening:Opening = new Opening();
        private var _opPop:OpeningPop;

        // // floor
        // private var _floor:Floor = new Floor();

        // HP表示
        private var _hp:HP = new HP() ;

        // アバター表示
        private var _duelAvatars:DuelAvatars = new DuelAvatars();
        // アイテム表示
        private var _infoBar:InfoBarImage = new InfoBarImage();


        // 立ちキャラ表示
        private var _standChara:StandChara = new StandChara();

        // キャラカードのクリップ
        private var _duelCharaCards:DuelCharaCards = new DuelCharaCards;

        // 必殺技の情報
        private var _featInfo:FeatInfo = new FeatInfo();

        // 必殺技の表示
        private var _featScene:FeatScene = new FeatScene();

        // パッシブスキルの表示
        private var _passiveSkillScene:PassiveSkillScene = new PassiveSkillScene();

        // チャットエリア
        private var _chatArea:ChatArea  = new ChatArea();

        // デュエルテーブル
        private var _duelTable:DuelTable  = new DuelTable();


        // フェイズ表示
        private var _phaseArea:PhaseArea  = new PhaseArea();

        // 移動の矢印表示
        private var _moveArrow:MoveArrow = new MoveArrow();

        // ボーナス表示
        private var _bonusMess:BonusMessScene = new BonusMessScene();

        // 観戦者用表示
        private var _watchResultScene:WatchResultScene = new WatchResultScene();
        private var _watchExitPanel:WatchExitPanel = new WatchExitPanel();

        // ロビーのコントローラ
        private var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;


        // duelのインスタンス
        private var _duel:Duel = Duel.instance;

        // matchのインスタンス
        private var _match:Match = Match.instance;

        private var _timer:Timer;

        // 親ステージ
        private var _stage:Sprite;
        private var _container:UIComponent = new UIComponent(); // 表示コンテナ

        //メインシークエンススレッドリスト
        private var _sequence:Array = []; //Array of Thread;

        //メインシークエンススレッドリスト
        CONFIG::HAND_NEW
        private var _foeSequence:Array = []; //Array of Thread;

        // マッチングビュー
        private var _matchView:MatchView;

        // ゲームの中断フラグ
        private var _exitGame:Boolean;

        // ウォッチの中断フラグ
        private var _exitWatch:Boolean;


        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function GameView(stage:Sprite)
        {
            _stage = stage;

//             interrupted(returnGameLobby);
//             error(InterruptedError, returnGameLobby);

            RaidHelpView.instance.isUpdate = false;
        }

        // スレッドのスタート
        override protected function run():void
        {
            GameCtrl.switchMode(GameCtrl.DUEL);
            GameCtrl.instance.start(this);
            MatchCtrl.instance.start(this);
            WatchCtrl.instance.start(this);
            DataCtrl.instance.requestChannelInfo();
            next(matching);

            // GCを監査する
//            Unlight.GCWOn();
            // Unlight.GCW.watch(obj);
        }

        // マッチングのスタート
        private function matching():void
        {
            if (_player.state == Player.STATE_LOGOUT)
            {
                next(exit);
            }else{
                // ロビーに再接続
//                LobbyCtrl.instance.restart();
                GameCtrl.instance.state = DuelCtrl.WAITING;
                _matchView = new MatchView(_stage);
                _matchView.start();
                _matchView.join();
                next(waiting);
            }
        }

        // 待機
        private function waiting():void
        {
            if (_player.state == Player.STATE_LOGOUT)
            {
                next(exit);
            }else{

                _matchView = null;
                log.writeLog(log.LV_INFO, this, "state is", GameCtrl.instance.state);
                // ステートによって次のシーンを切り替える
                switch (GameCtrl.instance.state)
                {
                case DuelCtrl.WAITING:
                    next(waiting);
                    break;
                case DuelCtrl.EXIT:
                    next(exit);
                    break;
                case DuelCtrl.GAME_STAGE:
                    log.writeLog(log.LV_INFO, this, "witing exit", MatchRoom.currentStartedRoom);
                    next(connect);
                    break;
                }
            }
        }

        // 接続待機
        private function connect():void
        {
            _exitGame = false;
            _exitWatch = false;
            _sequence = [];
            log.writeLog(log.LV_INFO, this, "connect ed");
            next(loading);
        }

        // 配置オブジェの読み込み
        private function loading():void
        {
            // By_K2
            _stage.stage.frameRate = 24 * Unlight.SPEED

            // ふざけたバグのために一度ロビーを切断する
//            LobbyCtrl.instance.exit();
            log.writeLog(log.LV_INFO, this, "loading");
            GameCtrl.instance.playDuelBGM();
            log.writeLog(log.LV_INFO, this, "losd", MatchRoom.currentStartedRoom);

            // マッチグルームは存在するか？ ログアウトしていないか？
            // if (MatchRoom.list[_match.currentRoomId] != null|| _player.state == Player.STATE_LOGOUT)
            // AIの時は中断を気にせずabortの時には中断を検知する(AIに移行するのが0ターンのときのみの処理なので注意もし将来1ターン以降に戻すなら元に戻すべき。混在するなら分けろ)

            if (Channel.list[Channel.current].penaltyType == Channel.PNLY_TYPE_AI ? MatchRoom.currentStartedRoom|| _player.state == Player.STATE_LOGOUT : MatchRoom.list[_match.currentRoomId] != null|| _player.state == Player.STATE_LOGOUT)
            {
                _fbg = new FarBG(MatchRoom.currentStartedRoom.stage);
                _nbg = new NearBG(MatchRoom.currentStartedRoom.stage);
                _opPop = new OpeningPop();
                log.writeLog(log.LV_INFO, this, "loading 1");

                var plName:String = "";
                var foeName:String = "";
                if (MatchRoom.list[_match.currentRoomId] && MatchRoom.list[_match.currentRoomId].avatarName[0] ) {
                    plName = MatchRoom.list[_match.currentRoomId].avatarName[0];
                }
                if (MatchRoom.list[_match.currentRoomId] && MatchRoom.list[_match.currentRoomId].avatarName[1] ) {
                    foeName = MatchRoom.list[_match.currentRoomId].avatarName[1];
                }

                var pExec:ParallelExecutor = new ParallelExecutor();
//            pExec.addThread(Transition.instance.getBurnigTransitionThread());
                pExec.addThread(_fbg.getShowThread(_container, 0));
                pExec.addThread(_duelTable.positionArea.getShowThread(_container,1));
                pExec.addThread(_standChara.getShowThread(_container,2));
                pExec.addThread(_nbg.getShowThread(_container, 3));
                if (MatchRoom.list[_match.currentRoomId] && MatchRoom.list[_match.currentRoomId].avatarId ) {
                    _opening.avatarIds = MatchRoom.list[_match.currentRoomId].avatarId;
                }
                pExec.addThread(_opening.getShowThread(_container,5));
                pExec.addThread(_base.getShowThread(_container, 6));
                pExec.addThread(_opPop.getShowThread(_container,7));
                pExec.addThread(_featInfo.getShowThread(_container,7));
                pExec.addThread(_duelTable.baseCard.getShowThread(_container,8));

                if (_duel.isWatch) _hp.setName(plName,foeName);
                pExec.addThread(_hp.getShowThread(_container,9));

                log.writeLog(log.LV_INFO, this, "loading 2");

                _duelAvatars.isWatch = _duel.isWatch;
                if (_duel.isWatch) _duelAvatars.ownerName = plName;
                _duelAvatars.isRaid = false;
                pExec.addThread(_duelAvatars.getShowThread(_container,11));
                pExec.addThread(_infoBar.getShowThread(_container,12));

                log.writeLog(log.LV_INFO, this, "loading 3");


                pExec.addThread(_phaseArea.getShowThread(_container,14));

                // チャットエリアタイプを設定
                _chatArea.currentRoomId = _match.currentRoomId;
                _chatArea.changeInputType(_duel.isWatch);
                pExec.addThread(_chatArea.getShowThread(_container,16));


                pExec.addThread(_duelTable.resultScene.getShowThread(_container,17));
                pExec.addThread(_duelTable.deckArea.getShowThread(_container,18));



                // 22～30まではActionCardが使う(26はキャラカード)
                pExec.addThread(_bonusMess.getShowThread(_container,25));
                pExec.addThread(_passiveSkillScene.getShowThread(_container,26));
                pExec.addThread(_duelCharaCards.getShowThread(_container,30));
                pExec.addThread(_moveArrow.getShowThread(_container,31));

                pExec.addThread(_featScene.getShowThread(_container,33));

                pExec.addThread(_watchResultScene.getShowThread(_container,34));
                _watchExitPanel.visible = false;
                _container.addChild(_watchExitPanel);

                _duelAvatars.watchRoomOutBtn.addEventListener(MouseEvent.CLICK,watchRoomOutBtnClickHandler);
                _watchExitPanel.yesButton.addEventListener(MouseEvent.CLICK,watchRoomExitHandler);
                _watchExitPanel.noButton.addEventListener(MouseEvent.CLICK,watchRoomExitCancelHandler);

				// By_K2
				_featScene.addEventListener(FeatScene.FEAT_FPS_DOWN, feat_fps_down);
				_featScene.addEventListener(FeatScene.FEAT_FPS_UP, feat_fps_up);

                pExec.start();
                pExec.join();

                log.writeLog(log.LV_INFO, this, "loading 4");

                _duel.addEventListener(EndGameEvent.GAME_END, bringOffHandler);
                _duel.addEventListener(FieldStatusEvent.SET, fieldStatusUpdateHandler);

                _stage.addChild(_container);

                next(bring);
            }
            else
                // 中断処理
            {
                next(abortHide);
            }
        }

        // 配置後にキャラクターカードを登場させる
        private function bring():void
        {
            log.writeLog(log.LV_INFO, this, "bring");

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();

//            sExec.addThread(Transition.instance.getBurnigTransitionThread());
            //pExec2.addThread(_duelCharaCards.getBringOnThread());
            pExec2.addThread(_opening.getBringOnThread(_base.getNameBringOnThread(),
                                                       _duelCharaCards.getBringOnThread(),
                                                       _opPop.getAnimeThread()));
            sExec.addThread(pExec2);
            sExec.addThread(_opening.getBringOffThread(_opPop.getBringOffThread()));
//            sExec.addThread(_opening.getHideThread());

             var pExec:ParallelExecutor = new ParallelExecutor();
//             // ここの休みでテーブルも表示
            pExec.addThread(_duelTable.getShowThread(_container));

            pExec.addThread(_standChara.getBringOnThread());
            pExec.addThread(_infoBar.getBringOnThread());
            pExec.addThread(_base.getBringOnThread());
            pExec.addThread(_phaseArea.getBringOnThread());
            pExec.addThread(_hp.getBringOnThread());
            pExec.addThread(_featInfo.getBringOnThread());
            pExec.addThread(_duelCharaCards.getBringOnAfterThread());
            pExec.addThread(_chatArea.getBringOnThread());
            pExec.addThread(_duelAvatars.getBringOnThread());
            pExec.addThread(_duelTable.baseCard.getBringOnThread());
            pExec.addThread(_duelTable.positionArea.getBringOnThread());
            pExec.addThread(_duelTable.deckArea.getBringOnThread());
            pExec.addThread(_bonusMess.getBringOnThread());
            pExec.addThread(_passiveSkillScene.getBringOnThread());

            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(GameCtrl.instance.startOk));

            sExec.start();
            sExec.join();
            next(eventWait);

        }

        // ゲームのループ部分(sequenceの)
        CONFIG::HAND_OLD
        private function eventWait():void
        {
           GameCtrl.instance.commandUpdate();
           var sExec:SerialExecutor = new SerialExecutor();

           while (_sequence.length > 0)
           {
               sExec.addThread(_sequence.shift());
           }
           sExec.start();
           sExec.join();

           if (_exitGame || _player.state == Player.STATE_LOGOUT) {
               next(returnGameLobby);
           }else{
               next(eventWait);
           }
         }


        CONFIG::HAND_NEW
        private function eventWait():void
        {
           GameCtrl.instance.commandUpdate();
           var pExec:ParallelExecutor = new ParallelExecutor();
           var sExec:SerialExecutor = new SerialExecutor();

           while (_sequence.length > 0)
           {
               sExec.addThread(_sequence.shift());
           }

           // 敵側のViewSequesnceは止めれるようにするので2個ずつしか喰わない
           var foesExec:SerialExecutor = new SerialExecutor();
           var c:int = 0
           while (_foeSequence.length > 0&&c < 2)
           {
               foesExec.addThread(_foeSequence.shift());
               c +=1;
           }
           pExec.addThread(sExec);
           pExec.addThread(foesExec);
           pExec.start();
           pExec.join();

           if (_exitGame || _player.state == Player.STATE_LOGOUT) {
               next(returnGameLobby);
           }else{
               next(eventWait);
           }
         }

        CONFIG::HAND_NEW
        public function addSequence(thread:Thread):void
        {
            _sequence.push(thread);
        }

        CONFIG::HAND_NEW
        public function addFoeSequence(thread:Thread):void
        {
            _foeSequence.push(thread);
        }





        public function addSequence(thread:Thread):void
        {
            _sequence.push(thread);
        }


        // 配置オブジェクトをきれいに消す
        private function bringOffHandler(e:EndGameEvent):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(GameCtrl.instance.stopDuelBGM));
            bringAllOff(e.result);
        }

        // 退室ボタンクリックハンドラ
        private function watchRoomOutBtnClickHandler(e:MouseEvent):void
        {
            _exitWatch = true;
            _chatArea.inputFlag = false;
            _duelAvatars.avatarBaseMouseEnabeld = false;
            _watchExitPanel.visible = true;
        }
        // 退室確認ウィンドウYesボタンハンドラ
        private function watchRoomExitHandler(e:MouseEvent):void
        {
            if (_duel.isWatch) {
                log.writeLog (log.LV_INFO,this,"watchRoomExitHandler.");
                _watchExitPanel.visible = false;
                WatchCtrl.instance.watchFinish();
                _duelAvatars.avatarBaseMouseEnabeld = false;
                _chatArea.inputFlag = true;
            }
        }
        // 退室確認ウィンドウNoボタンハンドラ
        private function watchRoomExitCancelHandler(e:MouseEvent):void
        {
            _watchExitPanel.visible = false;
            _duelAvatars.avatarBaseMouseEnabeld = true;
            _chatArea.inputFlag = true;
        }

        // フィールド状態更新イベント
        public function fieldStatusUpdateHandler(e:FieldStatusEvent):void
        {
            switch (e.kind) {
            case FieldStatusEvent.FOG:

                log.writeLog(log.LV_DEBUG,this,"～～～霧は出ている？");
                if (_duel.fieldStatus[FieldStatusEvent.FOG])
                {
                    log.writeLog(log.LV_DEBUG,this,"～～～霧のターン数",_duel.fieldStatus[FieldStatusEvent.FOG][1]);
                }
                else
                {
                    log.writeLog(log.LV_DEBUG,this,"～～～まだなにもない");
                }

                // 既に同じ状態が存在しているときは、パラメータ更新のみ
                if (_duel.fieldStatus[FieldStatusEvent.FOG] && _duel.fieldStatus[FieldStatusEvent.FOG][1] > 0) {
                    _duel.fieldStatus[FieldStatusEvent.FOG] = [e.pow, e.turn];

                    if (e.turn == 0 && _nnbg)
                    {
                        // 霧を消す
                        _nnbg.getHideThread().start();
                    }
                    return;
                }
                else
                {
                    // 霧を出す
                    if (e.turn > 0)
                    {
                        log.writeLog(log.LV_DEBUG,this,"～～～～～～～ 霧出す", [e.pow, e.turn]);
                        _duel.fieldStatus[FieldStatusEvent.FOG] = [e.pow, e.turn];
                        _nnbg = new NearBG(BG.UBOS);
                        _nnbg.getShowThread(_container, 4).start();
                    }
                }
            }
        }

        private function fieldStatus():Array
        {
            return _duel.fieldStatus;
        }

        // ゲームの中断。オブジェクトを退場
        public function abortGame():void
        {
            GameCtrl.instance.stopDuelBGM();
            log.writeLog(log.LV_WARN, this, "aborting");
            _sequence = [];
            bringAllOff();
            GameCtrl.instance.commandClear();
            _duelAvatars.avatarBaseMouseEnabeld = false;
            _watchExitPanel.visible = false;
            _exitGame = true;
        }

        // ゲームの終了
        public function finishGame():void
        {
            log.writeLog(log.LV_WARN, this, "finish");
            _duelAvatars.avatarBaseMouseEnabeld = false;
            _watchExitPanel.visible = false;
            _exitGame = true;
        }

        // ゲームの終了
        public function watchFinishGame():void
        {
            GameCtrl.instance.stopDuelBGM();
            log.writeLog(log.LV_WARN, this, "watch finish");
            _sequence = [];
            _duelAvatars.avatarBaseMouseEnabeld = false;
            _watchExitPanel.visible = false;
            bringAllOff();
            _exitGame = true;
        }
        public function viewWatchResult(isEnd:Boolean,winnerName:String=""):void
        {
            _duelAvatars.avatarBaseMouseEnabeld = false;
            if (isEnd) {
                addSequence(_watchResultScene.getShowResultThread(winnerName));
            }
            addSequence(new ClousureThread(watchFinishGame));
        }

        private function bringAllOff(result:int = 0):void
        {
            if (_hp.getPlHp > 0 && _hp.getFoeHp > 0 && !_exitWatch)
            {
                Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_DRAW, 0,0, Const.VOICE_PLAYING_METHOD_ADDITIOAL);
            }

            log.writeLog(log.LV_WARN, this, "bringAllOff", "result",result);

            var pExec:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();
            pExec.addThread(_opening.getUpBarBringOffThread());
            pExec.addThread(_chatArea.getBringOffThread());
            pExec.addThread(_hp.getBringOffThread());
            pExec.addThread(_featInfo.getBringOffThread());
            pExec.addThread(_infoBar.getBringOffThread());
            pExec.addThread(_watchResultScene.getHideThread());
            pExec.addThread(_duelTable.getBringOffThread());
            pExec.addThread(_standChara.getBringOffThread(result));
            pExec.addThread(_duelCharaCards.getBringOffThread());
            pExec.addThread(_duelAvatars.getBringOffThread());
            pExec.addThread(_phaseArea.getBringOffThread());
            pExec.addThread(_base.getBringOffThread());
            pExec.addThread(_bonusMess.getBringOffThread());
            pExec.addThread(_passiveSkillScene.getBringOffThread());
            sExec.addThread(pExec);
            sExec.addThread(_passiveSkillScene.getFinalizeThread());

            addSequence(new SleepThread(1500));
            addSequence(sExec);

        }

        private function returnGameLobby():void
        {
            _lobbyCtrl.avatarUpdateCheck();
            log.writeLog(log.LV_WARN, this, "return to GameLobby");
            GameCtrl.instance.addViewSequence(new ClousureThread(GameCtrl.instance.stopDuelBGM));

            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(_duelTable.resultScene.getHideThread());
            pExec.addThread(_duelTable.getHideThread());

            pExec.addThread(_infoBar.getHideThread());

            pExec.addThread(_featScene.getHideThread());

            pExec.addThread(_phaseArea.getHideThread());
            pExec.addThread(_duelTable.positionArea.getHideThread());
            pExec.addThread(_featInfo.getHideThread());

            pExec.addThread(_hp.getHideThread());
            pExec.addThread(_duelCharaCards.getHideThread());
            pExec.addThread(_duelTable.deckArea.getHideThread());

            pExec.addThread(_moveArrow.getHideThread());

            pExec.addThread(_bonusMess.getHideThread());
            pExec.addThread(_passiveSkillScene.getHideThread());
            pExec.addThread(_chatArea.getHideThread());
            pExec.addThread(_duelAvatars.getHideThread());

            pExec.addThread(_duelTable.baseCard.getHideThread());

            pExec.addThread(_standChara.getHideThread());
            pExec.addThread(_nbg.getHideThread());
            if (_nnbg)
            {
                pExec.addThread(_nnbg.getHideThread());
            }
            pExec.addThread(_fbg.getHideThread());
            pExec.addThread(_opening.getHideThread());
            pExec.addThread(_opPop.getHideThread());
            pExec.addThread(_base.getHideThread());
            pExec.start();
            pExec.join();
            addSequence(pExec);

            next(hide);
        }

        private function hide():void
        {
            _duelAvatars.watchRoomOutBtn.removeEventListener(MouseEvent.CLICK,watchRoomOutBtnClickHandler);
            _watchExitPanel.yesButton.removeEventListener(MouseEvent.CLICK,watchRoomExitHandler);
            _watchExitPanel.noButton.removeEventListener(MouseEvent.CLICK,watchRoomExitCancelHandler);
            _duel.removeEventListener(EndGameEvent.GAME_END, bringOffHandler);
            _stage.removeChild(_container);
            _sequence = [];
            next(matching);
        }

        private function abortHide():void
        {
            log.writeLog(log.LV_WARN, this, "aborr hide");
            _duel.abortGame();
            _sequence = [];
            next(matching);
        }

        private function exit():void
        {
        }

        // 終了関数
        override protected  function finalize():void
        {
			// By_K2
            _stage.stage.frameRate = 24;

            _duel.removeEventListener(EndGameEvent.GAME_END, bringOffHandler);
            _duelAvatars.watchRoomOutBtn.removeEventListener(MouseEvent.CLICK,watchRoomOutBtnClickHandler);
            _watchExitPanel.yesButton.removeEventListener(MouseEvent.CLICK,watchRoomExitHandler);
            _watchExitPanel.noButton.removeEventListener(MouseEvent.CLICK,watchRoomExitCancelHandler);

			// By_K2
			_featScene.removeEventListener(FeatScene.FEAT_FPS_DOWN, feat_fps_down);
			_featScene.removeEventListener(FeatScene.FEAT_FPS_UP, feat_fps_up);

//            Unlight.GCW.watch(this);
            log.writeLog (log.LV_WARN,this,"game end");
            RemoveChild.all(_container);
            RemoveChild.apply(_container);
            _duelTable.final();
            _opening = null;
            _opPop = null;
            // _floor = null;
            _hp = null;
            _duelAvatars = null;
            _infoBar = null;
            _standChara = null;
            _duelCharaCards = null;
            _featInfo = null;
            _featScene = null;
            _chatArea = null;
            _duelTable = null;
            _matchView = null;
            _phaseArea = null;
            _moveArrow = null;
            _bonusMess = null;
            _passiveSkillScene = null;
            _base = null;
            _stage =null;
            GameCtrl.instance.removeView();

            RaidHelpView.instance.isUpdate = true;
        }

        // 強制終了割り込み
        private function pushOut():void
        {
             next(hide);
        }

        // By_K2
        public function feat_fps_down(e:Event):void
        {
            _stage.stage.frameRate = 24;
        }

        // By_K2
        public function feat_fps_up(e:Event):void
        {
            _stage.stage.frameRate = 24 * Unlight.SPEED;
        }

   }

}

