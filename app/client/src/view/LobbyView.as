package view
{
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.display.*;
    import flash.filters.*;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.ui.Keyboard;

    import mx.core.UIComponent;
    import mx.events.StateChangeEvent;
    import mx.containers.Panel;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import net.Host;

    import model.*;
    import model.events.AvatarSaleEvent;
    import model.events.RaidHelpEvent;
    import model.utils.ConstData;

    import view.image.lobby.*;
    import view.scene.common.*;
    import view.scene.game.*;
    import view.scene.lobby.*;
    import view.utils.Announce;
    import view.scene.game.ActionCardClip;
    import controller.*;
    import view.scene.raid.ProfoundNoticePanel;

    /**
     * ロビーのビュークラス
     *
     */

    public class LobbyView extends Thread
    {
        private static const PRIO_BG:int       = 0;
        private static const PRIO_CHARA:int    = 1;
        private static const PRIO_AVATAR:int   = 2;
        private static const PRIO_ENTRANCE:int = 3;
        private static const PRIO_TALK_BUTTON:int = 10;

        // 背景
        private var _bg:BG = new BG();

        // アバター
        private var _avatar:AvatarView;;

        // キャラ立ち絵
        private var _standChara:LobbyStandChara = new LobbyStandChara();

        private var _talkButton:TalkButton = new TalkButton();

        // 各種要素
        private var _entrance:Entrance = new Entrance();

//        // ログインインフォ
//        private var _loginInfo:LoginInfoPanel = new LoginInfoPanel();
        private var _lobbyNotice:NoticePanel = new NoticePanel();
        private var _prfNotice:ProfoundNoticePanel = new ProfoundNoticePanel();

        // 親ステージ
        private var _stage:Sprite;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        // ロビーのコントローラ
        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;
        private var _dataCtrl:DataCtrl = DataCtrl.instance;
        private var _globalChatCtrl:GlobalChatCtrl = GlobalChatCtrl.instance;

        // ビュー
        private var _gameView:GameView;
        private var _questView:QuestView;
        private var _raidView:RaidView;
        private var _editView:DeckEditView;
        private var _optionView:OptionView;
        private var _registView:RegistView;
        private var _itemView:ItemView;
        private var _shopView:ShopView;
        private var _tutorialView:TutorialView;
        private var _lotView:LotView;
        private var _libraryView:LibraryView;
        private var _checkCount:int = 0;

        private var _player:Player = Player.instance;

        // デバッグ用フラグ
        private var _isRaidView:Boolean = false;

        // レイド遷移チェック
        private var _checkRaid:Boolean = false;

        private static const _NOTICE_TYPE_NONE:int  = 0;
        private static const _NOTICE_TYPE_LOBBY:int = 1;
        private static const _NOTICE_TYPE_PRF:int   = 2;

        // 情報表示タイプ
        private var _noticeType:int = _NOTICE_TYPE_NONE;

        // キャラチェンジインターバル
        private static const _CHANGE_CHARA_TIME:int = 1000*60*10; // 10分ごとに更新チェック
//        private static const _CHANGE_CHARA_TIME:int = 1000*60; // 1分ごとに更新チェック
        // チェック用タイマー
        private var _charaChangeTimer:Timer;

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function LobbyView(stage:Sprite)
        {
            _stage = stage;
//            _ranking.getShowThread(_container).start();
            LobbyCtrl.instance.alertEnable(false);
            Announce.init();

            RaidHelpView.instance.isUpdate = false;
        }


        // スレッドのスタート
        override protected  function run():void
        {
//            Unlight.GCW.watch(_entrance);
            _dataCtrl.start(this);
            _globalChatCtrl.start(this);
            next(waitingCreateConstData);
        }
        private function waitingCreateConstData():void
        {
            if( ConstData.isInited() )
            {
                 _ctrl.start(this);
                next(waitingConnectLobbyServer);
            }else{
                next(waitingCreateConstData);
            }

        }
        private function waitingConnectLobbyServer():void
        {
            if( _ctrl.connected && _dataCtrl.connected && _globalChatCtrl.connected)
            {
                next(waitingAvatar);
            }else{
                next(waitingConnectLobbyServer);
            }

        }


        // 待機
        private function waitingAvatar():void
        {
            if (_player.state == Player.STATE_REGIST)
            {
                 next(regist);
            }
            else if (_player.state == Player.STATE_LOBBY)
            {
                next(initEntrance);
            }
            event(_player, Player.CHANGE_STATE, getAvatatHandler);
        }

        // アバター読み込みのハンドラ
        private function getAvatatHandler(e:Event):void
        {
            if (_player.state == Player.STATE_REGIST)
            {
                 next(regist);
            }
            else if (_player.state == Player.STATE_LOBBY)
            {
                next(initEntrance);
            }else{
                next(waitingAvatar);
            }
        }

        // レジスト画面へ
        private function regist():void
        {
            Unlight.INS.loadingEnd();
            _registView = new RegistView(_stage);
            _registView.start();
            _registView.join();
            next(registEntrance);
        }

        // エントランスの初期化
        private function registEntrance():void
        {
            _registView = null;
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide)
            }
            else
            {
                next(registShow);
            }
        }

        // 表示
        private function registShow():void
        {
            _stage.addChild(_container);
            // 握ってるとGCされないので。
            _editView = null;
            _shopView = null;
            _itemView = null;
            _optionView  = null;
            _gameView = null;
            _questView = null;
            _raidView = null;
            _tutorialView = null;
            ActionCardClip.clearCache();
            FeatClip.clearCache();
            PassiveSkillClip.clearCache();
            _avatar = AvatarView.getPlayerAvatar(Const.PL_AVATAR_LOBBY);

//            _ctrl.playBGM();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatar.getLoadThread(_container));
            pExec.start();
            pExec.join();
            next(registTutorial);
        }

        // エントランスの初期化
        private function initEntrance():void
        {
//            log.writeLog(log.LV_FATAL, this, "entrant start");
            Unlight.INS.loadingEnd();
            _registView = null;
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide)
            }
            else
            {
                next(checkRaid);
//                 DataCtrl.instance.updateRankList(1,0,10);
//                 DataCtrl.instance.updateMyRank(1);
            }
        }

        private function checkRaid():void
        {
            _checkRaid = false;
            CONFIG::RAID_EVENT_ON
            {
                if (Profound.urlProfoundHash == "") {
                    next(show);
                } else {
                    next(redirectRaid);
                }
            }
            CONFIG::RAID_EVENT_OFF
            {
                next(show);
            }
        }

        private function redirectRaid():void
        {
            _dataCtrl.getProfoundForHash(Profound.urlProfoundHash);
            _ctrl.avatarUpdateCheck();
            LobbyCtrl.instance.realMoneyItemCheck(0);
            _player.state = Player.STATE_RAID;
            // RM書ぷを初期化
            RealMoneyShopView.initiData();
            next(waiting);
        }

        // 表示
        private function show():void
        {
            // RM書ぷを初期化
            RealMoneyShopView.initiData();
            // DataCtrl.instance.requestFriendsInfo();
            ProfoundTreasureData.initializeData();
            _stage.addChild(_container);
            // 握ってるとGCされないので。
            _editView = null;
            _shopView = null;
            _itemView = null;
            _optionView  = null;
            _gameView = null;
            _questView = null;
            _raidView = null;
            _tutorialView = null;
            _lotView = null;
            _libraryView = null;
            ActionCardClip.clearCache();
            FeatClip.clearCache();
            PassiveSkillClip.clearCache();
            _avatar = AvatarView.getPlayerAvatar(Const.PL_AVATAR_LOBBY);
            _ctrl.playBGM();
            var pExec:ParallelExecutor = new ParallelExecutor();
//            pExec.addThread(new BeTweenAS3Thread(_ranking, {alpha:1.0}, null, 0.8, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(_bg.getShowThread(_container, PRIO_BG));
            pExec.addThread(_standChara.getShowThread(_container, PRIO_CHARA));
            pExec.addThread(_avatar.getShowThread(_container,PRIO_AVATAR));
            pExec.addThread(_entrance.getShowThread(_container, PRIO_ENTRANCE));
            // 会話ボタン
            // pExec.addThread(_talkButton.getShowThread(_container, PRIO_TALK_BUTTON));

            pExec.start();
            pExec.join();
            _ctrl.avatarUpdateCheck();
            _entrance.rankingUpdate();
            _lobbyNotice.checkInfo();
            _ctrl.achievementClearCheck();
            _ctrl.newProfoundInventoryCheck();
            ItemListView.setSelectTabIndex( AvatarItem.ITEM_BASIS );

            _isRaidView = false;
            RaidHelpView.instance.isUpdate = true;

//            _loginInfo.checkInfo();

//             if(_player.avatar.loginBonus[2] != 0)
//             {
//                 next(initLobbyInfo);
//             }
//             else
//             {
                next(eventSet)
//             }
        }

//         // ロビーインフォの初期化
//         private function initLobbyInfo():void
//         {
//             var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.addThread(_loginInfo.getShowThread(_container));
//             pExec.start();
//             pExec.join();
// //            next(setBonusCard);
//             next(eventSet);

//         }

//         // ログインボーナスの設定
//         private function setBonusCard():void
//         {
//             var bonus:Array = _player.avatar.loginBonus;
//             _loginInfo.setBonusCard(bonus[0],bonus[1],bonus[2]);
//             _player.avatar.loginBonus = [0, 0, 0];

//             var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.addThread(_loginInfo.getBringOnThread());
//             pExec.start();
//             pExec.join();
//             next(eventSet);
//         }


        private function showClearAchievement():void
        {

        }

        // Noticeの表示終了待ち
        private function showNoticeWait():void
        {
            if (! _lobbyNotice.panelEnable() )
            {
                _noticeType = _NOTICE_TYPE_NONE;
                next(waiting);
            }
            else
            {
                next(showNoticeWait);
            }
            // if (! _lobbyNotice.panelEnable() )
            // {
            //     if (_prfNotice.checkInfo()) {
            //         next(showPrfNoticeWait);
            //         _noticeType = _NOTICE_TYPE_PRF;
            //     } else {
            //         _noticeType = _NOTICE_TYPE_NONE;
            //         next(waiting);
            //     }
            // }else{
            //     next(showNoticeWait);
            // }
        }

        // Noticeの表示終了待ち
        private function showPrfNoticeWait():void
        {
            if (! _prfNotice.panelEnable() )
            {
                _noticeType = _NOTICE_TYPE_NONE;
                next(waiting);
            }else{
                next(showPrfNoticeWait);
            }
        }

        // イベントの設定
        private function eventSet():void
        {
            // 2014クリスマスイベント
            // _charaChangeTimer = new Timer(_CHANGE_CHARA_TIME);
            // _charaChangeTimer.addEventListener(TimerEvent.TIMER, clampsAppearCheckHandler);
            // _charaChangeTimer.start();
            // _ctrl.addEventListener(LobbyCtrl.CLAMPS_APPEAR, clampsAppearHandler);
            // _ctrl.clampsAppearCheck();

            _entrance.battle.addEventListener(MouseEvent.CLICK,gameButtonClickHandler);
            _entrance.card.addEventListener(MouseEvent.CLICK,editButtonClickHandler);
            _entrance.option.addEventListener(MouseEvent.CLICK,optionButtonClickHandler);
            _entrance.item.addEventListener(MouseEvent.CLICK,itemButtonClickHandler);
            _entrance.shop.addEventListener(MouseEvent.CLICK,shopButtonClickHandler);
            _entrance.lot.addEventListener(MouseEvent.CLICK,lotButtonClickHandler);
            _entrance.library.addEventListener(MouseEvent.CLICK,libraryButtonClickHandler);
            _entrance.quest.addEventListener(MouseEvent.CLICK,questButtonClickHandler);
            _entrance.raid.addEventListener(MouseEvent.CLICK,raidButtonClickHandler);
            _entrance.tutorial.addEventListener(MouseEvent.CLICK,tutorialButtonClickHandler);

            // セール状態更新のイベント
            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_START,saleUpdateHandler);
            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH,saleUpdateHandler);

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            CONFIG::DEBUG
            {
                _stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownFunc);
            }

            _checkCount = 0;
            next(waiting);
        }

        private function keyDownFunc(e:KeyboardEvent):void
        {
            if (e.keyCode == Keyboard.SHIFT) {
                CONFIG::DEBUG
                {
                    _isRaidView = !_isRaidView;
                    if (_isRaidView) {
                        log.writeLog (log.LV_DEBUG,this,"Click mode Raid!");
                    } else {
                        log.writeLog (log.LV_DEBUG,this,"Click mode Quest!");
                    }
                }
            }
        }

        // クランプスの出現可否問い合わせ
        private function clampsAppearCheckHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this, "clampsAppearCheckHandler");
            //_ctrl.clampsAppearCheck();
        }

        // クランプスを出現させる
        private function clampsAppearHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this, "clampsAppearHandler", _standChara.isChanged);
            // if (_player&&!_standChara.isChanged) {
            //     var pExec:ParallelExecutor = new ParallelExecutor();
            //     pExec.addThread(_standChara.getChangeClampsThread());
            //     pExec.start();
            // }
        }

        // ゲームへのボタンを押したときのハンドラ
        private function gameButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"game Click!");
            SE.playLobbyClick();
            _ctrl.avatarUpdateCheck();
            _player.state = Player.STATE_GAME;
        }

        // 編集画面へのボタンを押したときのハンドラ
        private function editButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"edit Click!");
            SE.playLobbyClick();
            _ctrl.avatarUpdateCheck();
            _player.state = Player.STATE_EDIT;
        }

        // option画面へのボタンを押したときのハンドラ
        private function optionButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"option Click!");
            SE.playLobbyClick();
            _ctrl.avatarUpdateCheck();
            _player.state = Player.STATE_OPTION;
        }

        // tutorial画面へのボタンを押したときのハンドラ
        private function tutorialButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"tutorial Click!");
            _ctrl.avatarUpdateCheck();
            SE.playLobbyClick();
            _player.state = Player.STATE_TUTORIAL;
        }

        // アイテム画面へのボタンを押したときのハンドラ
        private function itemButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"item Click!");
            SE.playLobbyClick();
            _ctrl.avatarUpdateCheck();
            // 念のためRMアイテムの更新をチェックする
            LobbyCtrl.instance.realMoneyItemCheck(0);
            _player.state = Player.STATE_ITEM;
        }

        // ショップ画面へのボタンを押したときのハンドラ
        private function shopButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"shop Click!");
            _ctrl.avatarUpdateCheck();
            SE.playLobbyClick();
            // 念のためRMアイテムの更新をチェックする
            LobbyCtrl.instance.realMoneyItemCheck(0);
            _player.state = Player.STATE_SHOP;
        }

        // クエスト画面へのボタンを押したときのハンドラ
        private function questButtonClickHandler(e:MouseEvent):void
        {
            if (_isRaidView) {
                // CONFIG::VOICE_ON
                //{
                    // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_QUEST_START);
                //}
                log.writeLog (log.LV_INFO,this,"raid Click!");
                _ctrl.avatarUpdateCheck();
                LobbyCtrl.instance.realMoneyItemCheck(0);
                // CONFIG::VOICE_OFF
                // {
                SE.playLobbyClick();
                // }
                _player.state = Player.STATE_RAID;
            } else {
                // CONFIG::VOICE_ON
                //{
                    // Voice.playCharaVoice(Voice.my_chara,Const.VOICE_SITUATION_QUEST_START);
                //}
                log.writeLog (log.LV_INFO,this,"quest Click!");
                _ctrl.avatarUpdateCheck();
                LobbyCtrl.instance.realMoneyItemCheck(0);
                // CONFIG::VOICE_OFF
                // {
                SE.playLobbyClick();
                // }
                _player.avatar.setQuestType(Const.QUEST_NORMAL,false);
                _player.state = Player.STATE_QUEST;
            }
        }

        // レイド画面へのボタンを押したときのハンドラ
        private function raidButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"raid Click!");
            _ctrl.avatarUpdateCheck();
            LobbyCtrl.instance.realMoneyItemCheck(0);
            SE.playLobbyClick();
            _player.state = Player.STATE_RAID;
        }

        // ゲームへのボタンを押したときのハンドラ
        private function gameButtonOverHandler(e:MouseEvent):void
        {
//             log.writeLog (log.LV_INFO,this,"game button over");
//             _entrance.battleAnime();
        }

        // 編集画面へのボタンを押したときのハンドラ
        private function editButtonOverHandler(e:MouseEvent):void
        {
//             log.writeLog (log.LV_INFO,this,"edit button over");
//             _entrance.cardAnime();
        }
        // ショップ画面へのボタンを押したときのハンドラ
        private function lotButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"lot Click!");
            _ctrl.avatarUpdateCheck();
            LobbyCtrl.instance.realMoneyItemCheck(0);
            SE.playLobbyClick();
            _player.state = Player.STATE_LOT;
        }

        // ショップ画面へのボタンを押したときのハンドラ
        private function libraryButtonClickHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_INFO,this,"library Click!");
            _ctrl.avatarUpdateCheck();
            LobbyCtrl.instance.realMoneyItemCheck(0);
            SE.playLobbyClick();
            _player.state = Player.STATE_LIBRARY;
        }

        // セールの変化判定が出たときのハンドラ
        private function saleUpdateHandler(e:AvatarSaleEvent):void
        {
            // log.writeLog (log.LV_INFO,this,"saleUpdate!",e.type);

            switch (e.type)
            {
            case AvatarSaleEvent.SALE_START:
                _entrance.getShowSaleMCThread().start();
                break;
            case AvatarSaleEvent.SALE_FINISH:
                _entrance.getHideSaleMCThread().start();
                break;
            default:
                break;
            }
        }

        // レイドヘルプハンドラ
        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _checkRaid = true;
        }

//         // ロビーのインフォを更新する
//         public function lobbyInfo (text:String):void
//         {
//             _lobbyInfoText+=text;
//             _lobbyInfoText+="\n";
//         }

        // 待機
        private function waiting():void
        {
            switch (_player.state)
            {
            case Player.STATE_GAME:
                   next(game);
                   break;
            case Player.STATE_EDIT:
                   next(edit);
                   break;
            case Player.STATE_OPTION:
                   next(option);
                   break;
            case Player.STATE_TUTORIAL:
                   next(tutorial);
                   break;
            case Player.STATE_ITEM:
                   next(item);
                   break;
            case Player.STATE_SHOP:
                   next(shop);
                   break;
            case Player.STATE_QUEST:
                   next(quest);
                   break;
            case Player.STATE_RAID:
                   next(raid);
                   break;
            case Player.STATE_LOT:
                   next(lot);
                   break;
            case Player.STATE_LIBRARY:
                   next(library);
                   break;
            case Player.STATE_LOGOUT:
                   next(hide);
                   break;
            default:
                if (_checkRaid) {
                    next(checkRaid);
                } else {
                    next(waiting);
                    if(! _lobbyNotice.panelEnable() && ! _prfNotice.panelEnable() && _checkCount< 5)
                    {
                        if (_lobbyNotice.checkInfo() ) {
                            _noticeType = _NOTICE_TYPE_LOBBY;
                            next(showNoticeWait);
                            _checkCount +=1;
                        }
                        //  else if (_prfNotice.checkInfo()) {
                        //     _noticeType = _NOTICE_TYPE_PRF;
                        //     next(showPrfNoticeWait);
                        // }
                    }
                }
            }
        }
        private function hideThread():Thread
        {
            _entrance.tutorial.removeEventListener(MouseEvent.CLICK,tutorialButtonClickHandler);
            _entrance.battle.removeEventListener(MouseEvent.CLICK,gameButtonClickHandler);
            _entrance.card.removeEventListener(MouseEvent.CLICK,editButtonClickHandler);
            _entrance.option.removeEventListener(MouseEvent.CLICK,optionButtonClickHandler);
            _entrance.item.removeEventListener(MouseEvent.CLICK,itemButtonClickHandler);
            _entrance.lot.removeEventListener(MouseEvent.CLICK,lotButtonClickHandler);
            _entrance.library.removeEventListener(MouseEvent.CLICK,libraryButtonClickHandler);
            _entrance.shop.removeEventListener(MouseEvent.CLICK,shopButtonClickHandler);
            _entrance.quest.removeEventListener(MouseEvent.CLICK,questButtonClickHandler);
            _entrance.raid.removeEventListener(MouseEvent.CLICK,raidButtonClickHandler);
            Player.instance.avatar.removeEventListener(AvatarSaleEvent.SALE_START,saleUpdateHandler);
            Player.instance.avatar.removeEventListener(AvatarSaleEvent.SALE_FINISH,saleUpdateHandler);
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);
            // 2014クリスマスイベント
            // if (_charaChangeTimer)
            // {
            //     _charaChangeTimer.stop();
            //     _charaChangeTimer.removeEventListener(TimerEvent.TIMER, clampsAppearCheckHandler);
            // }
            // if (_ctrl)
            // {
            //     _ctrl.removeEventListener(LobbyCtrl.CLAMPS_APPEAR, clampsAppearHandler);
            // }

            CONFIG::DEBUG
            {
                _stage.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownFunc);
            }

            var pExec:ParallelExecutor = new ParallelExecutor();
//            pExec.addThread(new BeTweenAS3Thread(_entrance, {alpha:0.0}, null, 0.8, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(_bg.getHideThread());
            pExec.addThread(_entrance.getHideThread());
//            pExec.addThread(new BeTweenAS3Thread(_lobbyNews, {alpha:0.0}, null, 0.8, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            if (_standChara) pExec.addThread(_standChara.getHideThread());
            if (_avatar) pExec.addThread(_avatar.getHideThread());
            return pExec;
        }

        private function hide():void
        {

        }

        private function game():void
        {
            _ctrl.stopBGM();
            _gameView= new GameView(_stage);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(game2);
        }

        private function game2():void
        {
            _stage.removeChild(_container);
            _gameView.start();
            _gameView.join();
            next(game3);
        }

        // ゲームからのリターン
        private function game3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else
            {
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        // 編集画面へ
        private function edit():void
        {
//            _ctrl.stopBGM();
            _editView= new DeckEditView(_stage);
//            Unlight.GCW.watch(_editView);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(edit2);
        }

        private function edit2():void
        {
            _stage.removeChild(_container);
            _editView.start();
            _editView.join();
            next(edit3)
        }

        // 編集画面からのリターン
        private function edit3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else
            {
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        // 編集画面へ
        private function option():void
        {
            _optionView= new OptionView(_stage);
//             Unlight.GCW.watch(_optionView);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(option2);
        }

        private function option2():void
        {
            _stage.removeChild(_container);
            _optionView.start();
            _optionView.join();
            next(option3)
        }

        // 編集画面からのリターン
        private function option3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        // レジストチュートリアルへ
        private function registTutorial():void
        {
            // チュートリアルに入るときにアバター作製終了をDataServerに報告
            _dataCtrl.createAvatarSuccess();

            _ctrl.stopBGM();
            _tutorialView= new TutorialView(_stage, true);
//             Unlight.GCW.watch(_tutorialView);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(registTutorial2);
        }

        private function registTutorial2():void
        {
            _stage.removeChild(_container);
            _tutorialView.start();
            _tutorialView.join();
            next(registTutorial3)
        }

        // リターン
        private function registTutorial3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        // チュートリアル
        private function tutorial():void
        {
            _ctrl.stopBGM();
            _tutorialView= new TutorialView(_stage);
//             Unlight.GCW.watch(_tutorialView);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(tutorial2);
        }

        private function tutorial2():void
        {
            _stage.removeChild(_container);
            _tutorialView.start();
            _tutorialView.join();
            next(tutorial3)
        }

        // リターン
        private function tutorial3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        // アイテム画面へ
        private function item():void
        {
            LobbyCtrl.instance.alertEnable(true);

            _itemView= new ItemView(_stage);
//            Unlight.GCW.watch(_itemView);
              var t:Thread = hideThread();
            t.start();
            t.join();
            next(item2);
        }

        private function item2():void
        {
            _stage.removeChild(_container);
            _itemView.start();
            _itemView.join();
            next(item3)
        }

        // アイテム画面からのリターン
        private function item3():void
        {
            LobbyCtrl.instance.alertEnable(false);

            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        // ショップ画面へ
        private function shop():void
        {
            LobbyCtrl.instance.alertEnable(true);

            _shopView= new ShopView(_stage,0);
//             Unlight.GCW.watch(_shopView);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(shop2);
//            interrupted(pushOut);
        }

        private function shop2():void
        {
            _stage.removeChild(_container);
            _shopView.start();
            _shopView.join();
            next(shop3)
//            interrupted(pushOut);
        }

        // アイテム画面からのリターン
        private function shop3():void
        {
            LobbyCtrl.instance.alertEnable(false);

            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        // アイテム画面へ
        private function quest():void
        {
            _ctrl.stopBGM();
            ItemListView.setSelectTabIndex( AvatarItem.ITEM_AUTO_PLAY);
            _questView= new QuestView(_stage);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(quest2);
//            interrupted(pushOut);
        }

        private function quest2():void
        {
            _stage.removeChild(_container);
            _questView.start();
            _questView.join();
            next(quest3)
//            interrupted(pushOut);
        }

        // アイテム画面からのリターン
        private function quest3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        // レイド画面へ
        private function raid():void
        {
            _ctrl.stopBGM();
            var itemType:int = AvatarItem.ITEM_RAID;
            CONFIG::RAID_ITEM_OFF
            {
                itemType = AvatarItem.ITEM_AUTO_PLAY;
            }
            ItemListView.setSelectTabIndex( AvatarItem.getTabIndexFromType(itemType));
            _raidView= new RaidView(_stage);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(raid2);
        }

        private function raid2():void
        {
            // 指定がない場合のみ
            if (Profound.urlProfoundHash == "") {
                _stage.removeChild(_container);
            }
            _raidView.start();
            _raidView.join();
            next(raid3)
        }

        // アイテム画面からのリターン
        private function raid3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        private function lot():void
        {
            LobbyCtrl.instance.alertEnable(false);
            _ctrl.stopBGM();
            _lotView= new LotView(_stage);
//             Unlight.GCW.watch(_lotView);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(lot2);
//            interrupted(pushOut);
        }

        private function lot2():void
        {
            _stage.removeChild(_container);
            _lotView.start();
            _lotView.join();
            next(lot3)
//            interrupted(pushOut);
        }

        // アイテム画面からのリターン
        private function lot3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }

        private function library():void
        {
            LobbyCtrl.instance.alertEnable(false);
            _libraryView= new LibraryView(_stage);
//             Unlight.GCW.watch(_libraryView);
            var t:Thread = hideThread();
            t.start();
            t.join();
            next(library2);
//            interrupted(pushOut);
        }

        private function library2():void
        {
            _stage.removeChild(_container);
            _libraryView.start();
            _libraryView.join();
            next(library3)
//            interrupted(pushOut);
        }

        // アイテム画面からのリターン
        private function library3():void
        {
            if(_player.state == Player.STATE_LOGOUT)
            {
                next(hide);
            }else{
                _player.state = Player.STATE_LOBBY;
                next(checkRaid);
            }
        }














        // 終了関数
        override protected  function finalize():void
        {

            if (_container.parent != null)
            {
                _stage.removeChild(_container);
            }
            log.writeLog (log.LV_WARN,this,"Lobby end");

        }

   }
}
