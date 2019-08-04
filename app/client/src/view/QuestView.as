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
    import mx.containers.*;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import net.Host;

    import model.*
    import model.events.*;

    import view.scene.common.Transition;
    import view.scene.common.AvatarClip;
    import view.scene.common.SocialLog;

    import view.image.quest.*;
    import view.image.common.ItemListButton;
    import view.scene.common.*;
    import view.scene.quest.*;

    import view.utils.*;
    import view.scene.common.Transition;
    import view.scene.common.AvatarClip;
    import view.scene.item.WindowItemListPanel;
    import view.scene.quest.*;

    import view.image.game.*;
    import view.scene.game.*;

    import controller.*;

    /**
     * ゲームのビュークラス
     *
     */
    public class QuestView extends Thread
    {
        private var trans:Transition = Transition.instance;

        // ゲームのコントローラ
        private var _ctrl:QuestCtrl;

        // ロビーのコントローラ
        private var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;

//         private var _exitButton:Button = new Button();

        // タイトル表示
//         private var _title:Label = new Label();
//         private var _titleJ:Label = new Label();
        // BG
        private var _bg:QuestBG = new QuestBG();

        // ソーシャルログ
        private var _socialLog:SocialLog = new SocialLog();

        // 親ステージ
        private var _stage:Sprite;
        private var _questContainer:UIComponent = new UIComponent(); // 表示コンテナ

        // アバター
        private var _avatar:AvatarView;;

        // デッキ
        private var _questDeck:QuestDeck = new QuestDeck();

        // ワールドマップ
        private var _questWorldMap:QuestWorldMap = new QuestWorldMap();

        // クエストリスト
        private var _questList:QuestList = new QuestList();

        // マップ選択ウィンドウ
        private var _questSelectMap:QuestSelectMapWindow = new QuestSelectMapWindow();

        // クエスト結果パネル
        private var _questClearPanel:QuestClearPanel = new QuestClearPanel();

        // クエスト宝箱パネル
        private var _questTreasurePanel:QuestTreasurePanel = new QuestTreasurePanel();

        // クエスト結果パネル
//        private var _itemPanel:WindowItemListPanel;
//        private var _questItemButton:QuestItemButton = new QuestItemButton();
        private var _itemListButton:ItemListButton = new ItemListButton();

        private var _selectMapContainer:UIComponent = new UIComponent(); // マップ選択用コンテナ
        private var _resultContainer:UIComponent = new UIComponent(); // リザルト用コンテナ
        private var _treasureContainer:UIComponent = new UIComponent(); // 宝箱用コンテナ
        private var _searchContainer:UIComponent = new UIComponent(); // サーチパネル用コンテナ


        // クエストサーチリスト
//        private var _questSearchList:QuestSearchList = new QuestSearchList();
        // クエストマップ
        private var _questMapClip:QuestMapClip;
        private var _questCaption:QuestCaption = new QuestCaption();
        // クエストキャラ
        private var _questCharaClip:QuestCharaClip;

//         //メインシークエンススレッドリスト
//         private var _sequence:Array = []; //Array of Thread;

        // 定数
        private const _TITLE_X:int = 30;
        private const _TITLE_Y:int = 25;
        private const _TITLE_WIDTH:int = 100;
        private const _TITLE_HEIGHT:int = 40;

        private var _battle:Boolean = false;

        private var _treasured:Boolean = false;

        private var _isBoss:Boolean = false;

        private var _isQuestPlay:Boolean = false;

        private var _isRaidHelpStop:Boolean = false;

        // プレイヤーインスタンス
        private var _player:Player = Player.instance;

        private var _base:BaseCardFrameScene  = new BaseCardFrameScene();

        // BG
        private var _nbg:NearBG;
        private var _fbg:FarBG;

        // デュエルのオープニング
        private var _opening:Opening = new Opening(false);
        private var _opPop:OpeningPop;

        // floor
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

        // チャットエリア
        private var _chatArea:ChatArea  = new ChatArea(false);

        // デュエルテーブル
        private var _duelTable:DuelTable  = new DuelTable(true);


        // フェイズ表示
        private var _phaseArea:PhaseArea  = new PhaseArea();

        // 移動の矢印表示
        private var _moveArrow:MoveArrow = new MoveArrow();

        // ボーナス表示
        private var _bonusMess:BonusMessScene = new BonusMessScene();

        // パッシブスキルの表示
        private var _passiveSkillScene:PassiveSkillScene = new PassiveSkillScene();


        // duelのインスタンス
        private var _duel:Duel = Duel.instance;

        // クエストのストーリーシーン
        private var _questStoryScene:QuestStoryScene;
        private var _storyOn:Boolean = false;


        private var _timer:Timer;

        // 親ステージ
        private var _container:UIComponent = new UIComponent(); // 表示コンテナ

        //メインシークエンススレッドリスト
        private var _sequence:Array = []; //Array of Thread;


        // ゲームの中断フラグ
        private var _exitGame:Boolean;

        // クエストのStoryID
        private var _storyNo:int;

        // クエストのFirstChara
        private var _firstCharaImage:String;



        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function QuestView(stage:Sprite)
        {
            _stage = stage;
        }

        // スレッドのスタート
        override protected function run():void
        {
            GameCtrl.switchMode(GameCtrl.QUEST);
            _ctrl = QuestCtrl(GameCtrl.instance);
            _ctrl.start(this);

            // RMItemShopの更新が必要であれば行う
            RealMoneyShopView.itemReset();

            next(show);
        }

        // 配置オブジェの表示
        private function show():void
        {
            _stage.stage.frameRate = 24 * Unlight.SPEED;

            _stage.addChild(_questContainer);

            _stage.addChild(_searchContainer);
            _stage.addChild(_resultContainer);
            _stage.addChild(_treasureContainer);
            _stage.addChild(_selectMapContainer);

            //_bg.addChild(_itemListButton);

            QuestWorldMap.questType = Const.QUEST_NORMAL;
            _questWorldMap.searchContainer = _searchContainer;
            _questWorldMap.questContainer = _questContainer;

            _ctrl.addEventListener(QuestCtrl.QUEST_MAP_UPDATE,mapUpdateHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_INPROGRESS, questStartHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_SOLVED, questExitHandler);
            _ctrl.addEventListener(QuestCtrl.BATTLE_START, battleStartHandler);
            _ctrl.addEventListener(QuestCtrl.SHOW_ITEM, showItemHandler);
            _ctrl.addEventListener(QuestFinishEvent.FINISH, questFinishHandler);
            _ctrl.addEventListener(QuestTreasureEvent.GET, getTreasureHandler);

            // 移動始めたらアイテムウインドウ消す
            _ctrl.addEventListener(AvatarItemEvent.USE_ITEM, hideItemHandler);
            _ctrl.addEventListener(QuestCtrl.CHARA_POINT_UPDATE, hideItemHandler);
            _ctrl.addEventListener(QuestCtrl.BATTLE_START,  hideItemHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_MAP_UPDATE,hideItemHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_INPROGRESS, hideItemHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_SOLVED, hideItemHandler);

			// By_K2
			_featScene.addEventListener(FeatScene.FEAT_FPS_DOWN, feat_fps_down);
			_featScene.addEventListener(FeatScene.FEAT_FPS_UP, feat_fps_up);

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            _ctrl.playMatchBGM()

              next(serverAuthWaiting);
        }

        // サーバーの認証を待つ
        private function serverAuthWaiting():void
        {
            if (_ctrl.serverState == Host.CONNECT_AUTHED)
            {
                next(show2);
            }else{
                next(serverAuthWaiting);
            }
        }

        private function itemPanelInitialize():void
        {
           
//            _itemListButton.visible = true;
            // if (_itemPanel != null)
            // {
            //     _itemPanel.x = 798;
            //     _itemPanel.y = 107;
            //     _itemPanel.getHideThread().start();

            // }
            // _itemPanel = new WindowItemListPanel(AvatarItem.ITEM_AUTO_PLAY);
            // _itemPanel.x = 798;
            // _itemPanel.y = 107;
            // _itemPanel.alpha = 0.8;
            // _itemPanel.visible = false;
            // _itemPanel.getShowThread(_questContainer,16).start();
        }

        // 配置オブジェの表示
        private function show2():void
        {
            log.writeLog(log.LV_INFO, this, "questview show2");
            itemPanelInitialize();
            RealMoneyShopView.shopCloseButton.addEventListener(MouseEvent.CLICK, rmShopCloseclickHandler)
            var pExec:ParallelExecutor = new ParallelExecutor();

            _avatar = AvatarView.getPlayerAvatar(Const.PL_AVATAR_QUEST);
            pExec.addThread(_questWorldMap.getShowThread(_questContainer,0));
            pExec.addThread(_bg.getShowThread(_questContainer,1));
            pExec.addThread(_questCaption.getShowThread(_questContainer,2));

           pExec.addThread(_avatar.getShowThread(_questContainer,23));
           pExec.addThread(_questList.getShowThread(_questContainer,24));
           pExec.addThread(_questDeck.getShowThread(_questContainer,25));

            pExec.addThread(_itemListButton.getShowThread(_questContainer,37));

            pExec.addThread(_questSelectMap.getShowThread(_selectMapContainer));

            pExec.start();
            pExec.join();

//             Unlight.GCWOn();
//             Unlight.GCW.watch(_title);
            _avatar.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);
            _bg.back.addEventListener(MouseEvent.CLICK, leftDeckClickHandler);
            _bg.next.addEventListener(MouseEvent.CLICK, rightDeckClickHandler);
            _bg.selectMap.addEventListener(MouseEvent.CLICK, selectMapClickHandler);
            _questSelectMap.close.addEventListener(MouseEvent.CLICK, selectMapClickCloseHandler);
            _questSelectMap.setIconClickFunc(selectMapClickIconFunc);

            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);

            next(show3);
        }

        // 配置オブジェの表示
        private function show3():void
        {
            _isRaidHelpStop = _isQuestPlay;
            if (!_isRaidHelpStop) {
                RaidHelpView.instance.isUpdate = true;
            }
            next(waiting);
        }

        // ループ
        private function waiting():void
        {
            var _player:Player = Player.instance;
             if (_player.state == Player.STATE_LOBBY)
             {
                 next(hide);
             }else{
                 if (_battle)
                 {
                     next(loading)}
                 else{
                     next(waiting);
                 }

             }
        }


        // 終了
        private function exitButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            var _player:Player = Player.instance;
            _player.state = Player.STATE_LOBBY;
            log.writeLog(log.LV_INFO, this, "push exit");
            _ctrl.questInitialize();
        }


        // 左のデッキをクリック
        private function leftDeckClickHandler(e:MouseEvent):void
        {
            _questDeck.leftDeckClick();
        }

        // 右のデッキをクリック
        private function rightDeckClickHandler(e:MouseEvent):void
        {
            _questDeck.rightDeckClick();
        }

        // マップ選択をクリック
        private function selectMapClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, this, "selectMapClickHandler!!!!!!!!!!!!!!!!!!!!");
            _questSelectMap.show();
            _questContainer.mouseEnabled = false;
            _questContainer.mouseChildren = false;
            _bg.selectMap.visible = false;

        }
        // マップ選択を隠す
        private function selectMapClickCloseHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, this, "selectMapClickCloseHandler!!!!!!!!!!!!!!!!!!!!");
            _questSelectMap.hide();
            _questContainer.mouseEnabled = true;
            _questContainer.mouseChildren = true;
            _bg.selectMap.visible = true;

        }

        // マップ選択結果
        private function selectMapClickIconFunc(idx:int,questType:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "selectMapClickIconHandler!!!!!!!!!!!!!!!!!!!!",idx,questType);
            _questSelectMap.hide();
            _questContainer.mouseEnabled = true;
            _questContainer.mouseChildren = true;
            _bg.selectMap.visible = true;

            if (!_questWorldMap.isSameErea(idx,questType)) {
                _questWorldMap.moveMap(idx,questType);
            }
        }

//         // ループ部分(sequenceの)
//         private function eventWait():void
//         {
//            _ctrl.commandUpdate();
//            var sExec:SerialExecutor = new SerialExecutor();
//            while (_sequence.length > 0)
//            {
//                sExec.addThread(_sequence.shift());
//            }
//            sExec.start();
//            sExec.join();
//            next(eventWait);
//          }

//         public function addSequence(thread:Thread):void
//         {
//             _sequence.push(thread);
//         }

        public function get duelAvatars():DuelAvatars
        {
            return _duelAvatars;
        }

        private function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_questContainer, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

//            pExec.addThread(_questSearchList.getHideThread());
//          pExec.addThread(_questItemButton.getHideThread());
//            pExec.addThread(_itemPanel.getHideThread());
//            pExec.addThread(_questClearGauge.getHideThread());
            pExec.addThread(_questWorldMap.getHideThread());
            pExec.addThread(_questList.getHideThread());
            pExec.addThread(_questDeck.getHideThread());
            pExec.addThread(_avatar.getHideThread());
            if (_questStoryScene != null)
            {
                pExec.addThread(_questStoryScene.getHideThread());
            }
//            _container.removeChild(_title)
            pExec.start();
            pExec.join();

            next(hide2);
        }

        // 配置オブジェの表示
        private function hide2():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.start();
            pExec.join();

            next(exit);
        }

        private function exit():void
        {
            _ctrl.stopMatchBGM()
            _avatar.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            _bg.back.removeEventListener(MouseEvent.CLICK, leftDeckClickHandler);
            _bg.next.removeEventListener(MouseEvent.CLICK, rightDeckClickHandler);
            _bg.getHideThread().start();
            Player.instance.avatar.removeEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
            // レイドヘルプイベント
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);
            RemoveChild.apply(_treasureContainer);
            RemoveChild.apply(_resultContainer);
            RemoveChild.apply(_searchContainer);
            RemoveChild.apply(_selectMapContainer);
            _stage.removeChild(_questContainer);
            _ctrl.exit();
        }


        // マップ更新ハンドラ
        private function mapUpdateHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "mapUpdateHandler",_questMapClip,_isQuestPlay,_isRaidHelpStop);
            if (_questMapClip!=null)
            {
                _questMapClip.getHideThread().start();
                _questCaption.visible = false;
                _bg.selectMap.visible = true;
                // クエスト実行中はここでは戻さない
                if (!_isRaidHelpStop) {
                    RaidHelpView.instance.isUpdate = true;
                }
            }
            // 空マップだったらつくらない
            if (_ctrl.currentMap.id!=0)
            {
                _questMapClip = new QuestMapClip(_ctrl.currentMap);
                _questMapClip.getShowThread(_questContainer,27).start();
                _questCaption.setQuest(_ctrl.currentMap);
                _questCaption.visible = true;
                _bg.selectMap.visible = false;
                RaidHelpView.instance.isUpdate = false;
//                _questSearchList.closeList();
            }
        }

        private var beforeQuestFlag:int = 0;
        // マップスタートハンドラ
        private function questStartHandler(e:Event):void
        {
            RaidHelpView.instance.isUpdate = false;
            beforeQuestFlag = Player.instance.avatar.questFlag;
            if (_questCharaClip!=null)
            {
                _questCharaClip.getHideThread().start();
            }
            _questCharaClip = new QuestCharaClip(_ctrl.getCharaNo());
            _questCharaClip.getShowThread(_questContainer,28).start();
            _avatar.exitButton.visible = false;
            _isQuestPlay = true;
            _isRaidHelpStop = _isQuestPlay;
        }

        // マップ終了ハンドラ
        private function questExitHandler(e:Event):void
        {
            if (_questCharaClip!=null)
            {
                _questCharaClip.getHideThread().start();
            }
            if (_questMapClip!=null)
            {
                _questMapClip.getHideThread().start();
                _questCaption.visible = false;
            }
            _bg.selectMap.visible = false;
            _avatar.exitButton.visible = true;

        }
        // マップ終了ハンドラ
        private function questFinishHandler(e:QuestFinishEvent):void
        {
            log.writeLog(log.LV_INFO, this, "Quest finish ", e,e.result);
            var regionClear:Boolean = false;
            if (beforeQuestFlag < Player.instance.avatar.questFlag)
            {
                regionClear = true;
            }
            log.writeLog(log.LV_FATAL, this, "quest fin 0",e);
            _questClearPanel.setResult(e.result);
            _questClearPanel.setOKHandler(questFinishOKHandler);

            log.writeLog(log.LV_INFO, this, "Quest Story start?", _storyNo);
            if (_storyNo != 0 && e.result == 0)
            {
                log.writeLog(log.LV_INFO, this, "Quest Story start");
                _questStoryScene.getShowThread(_questContainer, 10).start();
                _questStoryScene.setStandChara(_firstCharaImage);
                _storyOn = true;
            }else{
                _resultContainer.addChild(_questClearPanel);
                _storyNo = 0;
                _storyOn = false;

            }

            _questContainer.mouseEnabled = false;
            _questContainer.mouseChildren = false;

            _isQuestPlay = false;
//             _questList.mouseEnabled = false;
//             _questList.mouseChildren = false;
//             _questWorldMap.mouseEnabled= false;
//             _questWorldMap.mouseChildren = false;
        }

        public function questFinishOKHandler():void
        {
            _questContainer.mouseEnabled = true;
            _questContainer.mouseChildren = true;

            RemoveChild.apply(_questClearPanel);
            if (beforeQuestFlag < Player.instance.avatar.questFlag)
            {
                // Voice.playCharaVoice(Voice.my_chara, Const.VOICE_SITUATION_QUEST_INTRO, Player.instance.avatar.questFlag+1);
            }
        }

        // 宝箱ゲットハンドラ
        private function getTreasureHandler(e:QuestTreasureEvent):void
        {
            _resultContainer.visible = false;
            log.writeLog(log.LV_INFO, this, "GetTreasureHandelr",e.genre, e.cType, e.val,this.name);

            _questTreasurePanel.setResult(e.genre,e.cType,e.val);

            _questTreasurePanel.setOKHandler(getTreasureOKHandler);

            _treasureContainer.addChild(_questTreasurePanel);

            _questContainer.mouseEnabled = false;
            _questContainer.mouseChildren = false;
            _treasured = true;

            log.writeLog(log.LV_INFO, this, "GetTreasureHandelr",_questContainer.parent,_storyNo);
            // 現在、戦闘中でなければ、またはボスストーリがなければ
            if(_questContainer.parent != null)
            {
                _questTreasurePanel.getBringOnThread().start();
            }

        }

        public function getTreasureOKHandler():void
        {
            _questContainer.mouseEnabled = true;
            _questContainer.mouseChildren = true;
            _resultContainer.visible = true;

            _treasured = false;
            RemoveChild.apply(_questTreasurePanel);

            if (beforeQuestFlag < Player.instance.avatar.questFlag)
            {
                // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_QUEST_CLEAR, Player.instance.avatar.questFlag);
            }
        }




        // 
        private function battleStartHandler(e:Event):void
        {
            // test
            log.writeLog(log.LV_INFO, this, "boss start quest story scene create. map is boss?", _ctrl.currentMap.storyNo != 0);
            if (_ctrl.currentMap.storyNo != 0)
            {
                log.writeLog(log.LV_INFO, this, "boss start quest story scene create. map StoryNo is", _ctrl.currentMap.storyNo);
                _questStoryScene = new QuestStoryScene(_ctrl.currentMap.storyNo);
                _storyNo =  _ctrl.currentMap.storyNo;
                _firstCharaImage = _duel.playerCharaCard.standImage;
            }
            if (_ctrl.currentLand.eventNo == QuestLand.EVENT_NO_BOSS)
            {
                _isBoss = true;
            }
            _battle = true;
        }


        // アイテム表示ハンドラ
        private function showItemHandler(e:Event):void
        {
//            _itemPanel.visible = true;
//             if(_itemPanel.visible)
//             {
//                 new BeTweenAS3Thread(_itemPanel, {x:798.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false).start();
//                 _itemPanel.updatePageButton();
// //                _itemPanel.visible = !_itemPanel.visible;
//             }
//             else
//             {
//                 new BeTweenAS3Thread(_itemPanel, {x:498.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true).start();
//                 _itemPanel.updatePageButton();
// //                _itemPanel.visible = !_itemPanel.visible;
//             }
        }

        // アイテム表示ハンドラ
        private function hideItemHandler(e:Event):void
        {
            // new BeTweenAS3Thread(_itemPanel, {x:798.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false).start();
            _questList.shopButtonCheck();
            ItemListView.hide();
        }

        CONFIG::PAYMENT
        public function showShop():void
        {
            _questContainer.addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_QUEST_DAMAGE));
        }
        CONFIG::NOT_PAYMENT
        public function showShop():void
        {
//            _questContainer.addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_QUEST_DAMAGE));
        }

        private function rmShopCloseclickHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "++++++++++++shhop closeeee");
            itemPanelInitialize();
        }

        // セールの終了判定が出たときのハンドラ
        private function saleFinishHandler(e:AvatarSaleEvent):void
        {
            // log.writeLog (log.LV_INFO,this,"saleFinish!");
            RealMoneyShopView.hideButtonSaleMC(RealMoneyShopView.TYPE_QUEST_DAMAGE);
            // ショップアイテムリストの更新
            RealMoneyShopView.itemReset();
        }

        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _player.state = Player.STATE_LOBBY;
        }

//         // 接続待機
//         private function connect():void
//         {
//             _exitGame = false;
//             log.writeLog(log.LV_INFO, this, "connect ed");
//             next(loading);
//         }

        // 配置オブジェの読み込み
        private function loading():void
        {
            Transition.instance.setTransionImage(_questContainer, _container);
            Transition.instance.getBurnigTransitionThread().start();

            _exitGame = false;

            log.writeLog(log.LV_INFO, this, "loading");

            _ctrl.stopMatchBGM();
            if ( _isBoss ) {
                _ctrl.stageNo = QuestCtrl.BGM_ID_BOSS;
            } else {
                _ctrl.stageNo = _duel.stage;
            }
            _ctrl.playDuelBGM();
//            log.writeLog(log.LV_INFO, this, "losd", MatchRoom.list[_match.currentRoomId]);

            // ログアウトしていないか？
            if ( _player.state != Player.STATE_LOGOUT)
            {
                // ここでステージの値をいれる
                _fbg = new FarBG(_duel.stage);
                _nbg = new NearBG(_duel.stage);
                _opPop = new OpeningPop();
                // _fbg = new FarBG(15);
                // _nbg = new NearBG(15);
                log.writeLog(log.LV_INFO, this, "loading 1");

                var pExec:ParallelExecutor = new ParallelExecutor();
                pExec.addThread(_fbg.getShowThread(_container, 0));
                pExec.addThread(_duelTable.positionArea.getShowThread(_container,1));
                pExec.addThread(_standChara.getShowThread(_container,2));
                pExec.addThread(_nbg.getShowThread(_container, 3));
                if (_player && _player.avatar ) {
                    _opening.avatarIds = [_player.avatar.id];
                }
                pExec.addThread(_opening.getShowThread(_container,4));
                pExec.addThread(_base.getShowThread(_container, 4));
                pExec.addThread(_opPop.getShowThread(_container,5));
                pExec.addThread(_featInfo.getShowThread(_container,5));
                pExec.addThread(_duelTable.deckArea.getShowThread(_container,6));
                pExec.addThread(_duelTable.baseCard.getShowThread(_container,7));
                pExec.addThread(_hp.getShowThread(_container,8));

                log.writeLog(log.LV_INFO, this, "loading 2");

                _duelAvatars.isRaid = false;
                pExec.addThread(_duelAvatars.getShowThread(_container,11));
                pExec.addThread(_infoBar.getShowThread(_container,12));

                log.writeLog(log.LV_INFO, this, "loading 3");


                pExec.addThread(_phaseArea.getShowThread(_container,14));
                pExec.addThread(_chatArea.getShowThread(_container,16));


                pExec.addThread(_duelTable.resultScene.getShowThread(_container,18));


                // 22～30まではActionCardが使う(26はキャラカード)
                pExec.addThread(_bonusMess.getShowThread(_container,25));
                pExec.addThread(_passiveSkillScene.getShowThread(_container,26));
                pExec.addThread(_duelCharaCards.getShowThread(_container,30));
                pExec.addThread(_moveArrow.getShowThread(_container,31));


                pExec.addThread(_featScene.getShowThread(_container,33));
//                pExec.addThread();

                 log.writeLog(log.LV_INFO, this, "loading 4");

                _duel.addEventListener(EndGameEvent.GAME_END, bringOffHandler);
                

                _stage.addChildAt(_container,_stage.numChildren-1);

                _stage.removeChild(_questContainer);
                pExec.start();
                pExec.join();

//                next(transition)
//                _stage.addChild(_bonusMess);
                next(bring);
            }
            else
                // 中断処理
            {
                next(abortHide);
            }
        }


//         private function transition():void
//         {
//             var t:Thread = 
//             t.join();
//             t.start();
//             next(bring)
//         }

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
            sExec.addThread(new ClousureThread(_ctrl.startOk));

            sExec.start();
            sExec.join();
            next(eventWait);

        }

        // ゲームのループ部分(sequenceの)
        private function eventWait():void
        {
//            log.writeLog(log.LV_INFO, this, "aaa");
           _ctrl.commandUpdate();
           var sExec:SerialExecutor = new SerialExecutor();

           while (_sequence.length > 0)
           {
               sExec.addThread(_sequence.shift());
           }
           sExec.start();
           sExec.join();

           if (_exitGame || _player.state == Player.STATE_LOGOUT) {
               next(exitGame);
           }else{
               next(eventWait);
           }
         }

        public function addSequence(thread:Thread):void
        {
            _sequence.push(thread);
        }


        // 配置オブジェクトをきれいに消す
        private function bringOffHandler(e:EndGameEvent):void
        {
            _ctrl.addViewSequence(new ClousureThread(_ctrl.stopDuelBGM));
            log.writeLog(log.LV_FATAL, this, "stop bgm. by bringoff method.  ");
            bringAllOff(e.result);
        }


        // ゲームの中断。オブジェクトを退場
        public function abortGame():void
        {
            log.writeLog(log.LV_WARN, this, "aborting");
            _sequence = [];
            bringAllOff();
            _exitGame = true;
            _battle = false;
            _isBoss = false;
        }

        // ゲームの終了
        public function finishGame():void
        {
            log.writeLog(log.LV_WARN, this, "finish");
            _exitGame = true;
            _battle = false;
            _isBoss = false;
        }

        private function bringAllOff(result:int = 0):void
        {
            if (_hp.getPlHp > 0 && _hp.getFoeHp > 0)
            {
                Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_DRAW, 0,0, Const.VOICE_PLAYING_METHOD_ADDITIOAL);
            }

            var pExec:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();
            pExec.addThread(_chatArea.getBringOffThread());
            pExec.addThread(_hp.getBringOffThread());
            pExec.addThread(_featInfo.getBringOffThread());
            pExec.addThread(_passiveSkillScene.getBringOffThread());
            pExec.addThread(_infoBar.getBringOffThread());
            pExec.addThread(_duelTable.getBringOffThread());
            pExec.addThread(_standChara.getBringOffThread(result));
            pExec.addThread(_duelCharaCards.getBringOffThread());
            pExec.addThread(_duelAvatars.getBringOffThread());
            pExec.addThread(_phaseArea.getBringOffThread());
            pExec.addThread(_opening.getUpBarBringOffThread());
            pExec.addThread(_base.getBringOffThread());
            pExec.addThread(_bonusMess.getBringOffThread());
            addSequence(new SleepThread(1500));
            sExec.addThread(pExec);
            sExec.addThread(_passiveSkillScene.getFinalizeThread());
            addSequence(sExec);


        }

        private function exitGame():void
        {
            log.writeLog(log.LV_WARN, this, "return to GameLobby");
            _lobbyCtrl.avatarUpdateCheck();

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new ClousureThread(_ctrl.stopDuelBGM));
//            log.writeLog(log.LV_FATAL, this, "stop bgm. by exit game method.  ");

            pExec.addThread(_duelTable.resultScene.getHideThread());
            pExec.addThread(_duelTable.getHideThread());

            pExec.addThread(_infoBar.getHideThread());

            pExec.addThread(_featScene.getHideThread());
            pExec.addThread(_passiveSkillScene.getHideThread());

            pExec.addThread(_phaseArea.getHideThread());
            pExec.addThread(_duelTable.positionArea.getHideThread());
            pExec.addThread(_featInfo.getHideThread());

            pExec.addThread(_hp.getHideThread());
            pExec.addThread(_duelCharaCards.getHideThread());
            pExec.addThread(_duelTable.deckArea.getHideThread());

            pExec.addThread(_moveArrow.getHideThread());
            pExec.addThread(_bonusMess.getHideThread());
            pExec.addThread(_chatArea.getHideThread());
            pExec.addThread(_duelAvatars.getHideThread());

            pExec.addThread(_duelTable.baseCard.getHideThread());

            pExec.addThread(_standChara.getHideThread());
            pExec.addThread(_nbg.getHideThread());
            pExec.addThread(_fbg.getHideThread());
            pExec.addThread(_opening.getHideThread());
            pExec.addThread(_opPop.getHideThread());
            pExec.addThread(_base.getHideThread());
            pExec.start();
            pExec.join();
            addSequence(pExec);
            log.writeLog(log.LV_INFO, this, "Quest Story start 2", _storyOn,_ctrl.currentMap.storyNo);
            if (_storyOn)
            {
                _stage.addChild(_questContainer);
                setStoryVisible(false);
                TitleCtrl.instance.playBGM();
                next(storyStart);
                // ならべなおし･･･
            }else{
                // クエストを出す
                _stage.addChild(_questContainer);
                _stage.addChild(_searchContainer);
                _stage.addChild(_resultContainer);
                _stage.addChild(_treasureContainer);
                _stage.addChild(_selectMapContainer);
                _ctrl.playMatchBGM();

                next(show3);
            }
            // もし宝箱が設定されていたらかつボスでなければ宝箱パネルを出す
            if(_treasured && !_storyOn)
            {
                _questTreasurePanel.getBringOnThread().start();
            }
        }

        private function setStoryVisible(v:Boolean):void
        {
            // _bg.visible = v;
            _questWorldMap.visible = v;
            // _questCaption.visible = v;
            _questList.visible = v;
            _avatar.base.visible = v;
            _questContainer.mouseEnabled = !v;
            _questContainer.mouseChildren = !v;
            _avatar.mouseEnabled = v;
            _avatar.mouseChildren = v;

            // _questDeck.mouseEnabled = v;
            // _questDeck.mouseChildren= v;
            _itemListButton.mouseEnabled = v;
            _itemListButton.mouseChildren = v;
            _bg.mouseEnabled = v;
            _bg.mouseChildren= v;

        }

        private function storyStart():void
        {
            _questStoryScene.dialogueImage.addEventListener(QuestStoryDialogueImage.END_EVENT, storyFinishHandler);
            _questStoryScene.bg.addEventListener(QuestStoryBGImage.SKIP_EVENT, storyFinishHandler);


            RemoveChild.apply(_searchContainer);
            RemoveChild.apply(_resultContainer);
            RemoveChild.apply(_treasureContainer);
            RemoveChild.apply(_selectMapContainer);

            log.writeLog(log.LV_INFO, this, "story start thread start.");
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_questStoryScene.fadeInThread());
            pExec.start();
            pExec.join();
            next(storyTelling);
        }

        private function storyFinishHandler(e:Event):void
        {

            log.writeLog(log.LV_INFO, this, "story is finish.");
            _questStoryScene.dialogueImage.removeEventListener(QuestStoryDialogueImage.END_EVENT, storyFinishHandler);
            _questStoryScene.bg.removeEventListener(QuestStoryBGImage.SKIP_EVENT, storyFinishHandler);
            _storyOn = false;
            _storyNo = 0;
        }

        private function storyTelling():void
        {
            if (_storyOn)
            {
                next(storyTelling);
            }else{
                TitleCtrl.instance.stopBGM();
                next(storyEndFade);

            }

        }

        private function storyEndFade():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(_questStoryScene, {alpha:0.0}, null, 0.5/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.4/Unlight.SPEED ,false));
            sExec.addThread(_questStoryScene.getHideThread());
            sExec.start();
            sExec.join();
            next(storyEnd);

        }
        private function storyEnd():void
        {
            log.writeLog(log.LV_INFO, this, "Story end thread.start");
            setStoryVisible(true);
            _stage.addChild(_questContainer);
            _stage.addChild(_searchContainer);
            _stage.addChild(_resultContainer);
            _stage.addChild(_treasureContainer);
            _stage.addChild(_selectMapContainer);
            _questContainer.mouseEnabled = true;
            _questContainer.mouseChildren = true;
            RemoveChild.apply(_questStoryScene);
            _ctrl.playMatchBGM();
            if(_treasured)
            {
                _questTreasurePanel.getBringOnThread().start();
            }
            _resultContainer.addChild(_questClearPanel);

            next(show3);
        }

        public function getBgExchangeThread(no:int):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            var fbg:FarBG = new FarBG(no);
            var nbg:NearBG = new NearBG(no);

            fbg.alpha = 0.0;
            fbg.alpha = 0.0;

            pExec.addThread(fbg.getShowThread(_container, 0));
            pExec.addThread(nbg.getShowThread(_container, 3));
            pExec.addThread(new BeTweenAS3Thread(_fbg, {alpha:0.0}, null, 2.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 3 ,false ));
            pExec.addThread(new BeTweenAS3Thread(_nbg, {alpha:0.0}, null, 2.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 3 ,false));
            pExec.addThread(new BeTweenAS3Thread(fbg, {alpha:1.0}, null, 2.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 3 ,true ));
            pExec.addThread(new BeTweenAS3Thread(nbg, {alpha:1.0}, null, 2.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 3 ,true ));

            sExec.addThread(pExec);
            sExec.addThread(_fbg.getHideThread());
            sExec.addThread(_nbg.getHideThread());
            sExec.addThread(new ClousureThread(bgCheange,[fbg,nbg]));
            return sExec;
        }

        private function bgCheange(fb:FarBG, nb:NearBG):void
        {
            _fbg = fb;
            _nbg = nb;
        }


        private function abortHide():void
        {
//            log.writeLog(log.LV_WARN, this, "aborr hide");
            _sequence = [];
            next(waiting)
        }

        // 終了関数
        override protected  function finalize():void
        {
            _stage.stage.frameRate = 24;

//            Unlight.GCW.watch(this);

            _ctrl.removeEventListener(QuestCtrl.QUEST_MAP_UPDATE,mapUpdateHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_INPROGRESS, questStartHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_SOLVED, questExitHandler);
            _ctrl.removeEventListener(QuestCtrl.BATTLE_START, battleStartHandler);
            _ctrl.removeEventListener(QuestCtrl.SHOW_ITEM, showItemHandler);
            _ctrl.removeEventListener(QuestFinishEvent.FINISH, questFinishHandler);
            _ctrl.removeEventListener(QuestTreasureEvent.GET, getTreasureHandler)

            _ctrl.removeEventListener(AvatarItemEvent.USE_ITEM, hideItemHandler);
            _ctrl.removeEventListener(QuestCtrl.CHARA_POINT_UPDATE, hideItemHandler);
            _ctrl.removeEventListener(QuestCtrl.BATTLE_START,  hideItemHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_MAP_UPDATE,hideItemHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_SOLVED, hideItemHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_INPROGRESS, hideItemHandler);

			// By_K2
			_featScene.removeEventListener(FeatScene.FEAT_FPS_DOWN, feat_fps_down);
			_featScene.removeEventListener(FeatScene.FEAT_FPS_UP, feat_fps_up);

            RealMoneyShopView.shopCloseButton.removeEventListener(MouseEvent.CLICK, rmShopCloseclickHandler)

            _questClearPanel.final();
            _questTreasurePanel.final();

            _avatar.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            _bg.back.removeEventListener(MouseEvent.CLICK, leftDeckClickHandler);
            _bg.next.removeEventListener(MouseEvent.CLICK, rightDeckClickHandler);

            log.writeLog (log.LV_WARN,this,"quest end");

            _duel.removeEventListener(EndGameEvent.GAME_END, bringOffHandler);

            RemoveChild.all(_container);
            RemoveChild.apply(_container);
            _duelTable.resultScene.disposeObj();
            _duelTable.final();
            _opening = null;
            _opPop = null;
            //_floor = null;
            _hp = null;
            _duelAvatars = null;
            _infoBar = null;
            _standChara = null;
            _duelCharaCards = null;
            _featInfo = null;
            _featScene = null;
            _chatArea = null;
            _duelTable = null;
            _phaseArea = null;
            _moveArrow = null;
            _bonusMess = null;
            _passiveSkillScene = null;
            _base = null;
            _stage =null;

            GameCtrl.instance.removeView();

            _bg = null;
            _socialLog = null;
            _questContainer = null;
            _avatar = null;
            _questDeck = null; 
            _questWorldMap = null;
            _questList = null;
//            _questSearchList = null;
            _questMapClip = null;
            _questCharaClip = null;
            _questStoryScene = null;
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
 
