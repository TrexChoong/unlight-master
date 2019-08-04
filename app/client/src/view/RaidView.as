package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.*;
    // import flash.events.MouseEvent;
    // import flash.events.Event;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.system.System;

    import mx.core.UIComponent;
    import mx.core.MovieClipLoaderAsset;
    import mx.events.*;
//    import mx.events.StateChangeEvent;
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

    import view.image.raid.*;
    import view.image.common.ItemListButton;
    import view.scene.common.*;
    import view.scene.raid.*;

    import view.utils.*;
    import view.scene.common.Transition;
    import view.scene.common.AvatarClip;
    import view.scene.item.WindowItemListPanel;
    import view.scene.raid.*;

    import view.image.game.*;
    import view.scene.game.*;
    import view.scene.lobby.NoticePanel;

    import controller.*;

    /**
     * レイドのビュークラス
     *
     */
    public class RaidView extends Thread
    {
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ALERT_TITLE:String       = "警告";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ALERT_AP:String          = "APが不足してます";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ALERT_DECK_USED:String   = "このデッキは別の渦で使用中です";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_ALERT_DECK_COMMIT:String = "使用中のデッキではありません";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_COPY_TITLE:String        = "コピー";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_COPY:String              = "このレイドコードをみんなに知らせて協力して渦のボスと戦おう！\n__CODE__";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ALERT_TITLE:String       = "Warning";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ALERT_AP:String          = "Not enough AP.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ALERT_DECK_USED:String   = "This deck is already participating in another vortex battle.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_ALERT_DECK_COMMIT:String = "This deck is not used.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_COPY_TITLE:String        = "Copy";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_COPY:String              = "The raid code was copied. Call everyone and work together to take down the RAID-BOSS!";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ALERT_TITLE:String       = "警告";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ALERT_AP:String          = "AP不足";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ALERT_DECK_USED:String   = "這副牌組正在參加其他的渦戰鬥";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_ALERT_DECK_COMMIT:String = "這並非使用中的排組";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_COPY_TITLE:String        = "複製";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_COPY:String              = "RAID CODE已經複製！\n通知大家，一起來合作擊退渦的BOSS吧！";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ALERT_TITLE:String       = "警告";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ALERT_AP:String          = "AP不足";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ALERT_DECK_USED:String   = "这个卡组正用于其他的漩涡战斗";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_ALERT_DECK_COMMIT:String = "不是正在使用的卡组";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_COPY_TITLE:String        = "复制";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_COPY:String              = "已复制RAID代码！\n通知大家来一起打败RAID-BOSS吧！";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_ALERT_TITLE:String       = "경고";
        CONFIG::LOCALE_KR
	private static const _TRANS_MSG_ALERT_AP:String = "AP가 부족합니다.";
        CONFIG::LOCALE_KR
	private static const _TRANS_MSG_ALERT_DECK_USED:String = "이 덱은 다른 소용돌이에 사용중입니다.";
        CONFIG::LOCALE_KR
	private static const _TRANS_MSG_ALERT_DECK_COMMIT:String = "사용중인 덱이 아닙니다.";
	CONFIG::LOCALE_KR
	private static const _TRANS_MSG_COPY_TITLE:String = "복사";
        CONFIG::LOCALE_KR
	private static const _TRANS_MSG_COPY:String = "RAID CODE을 복사했습니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ALERT_TITLE:String       = "Attention";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ALERT_AP:String          = "AP insuffisants";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ALERT_DECK_USED:String   = "Cette pioche est utilisée pour une autre bataille de Vortex.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_ALERT_DECK_COMMIT:String = "Ce n'est pas la pioche que vous utilisez.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_COPY_TITLE:String        = "Copie";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_COPY:String              = "RaidCode copié !\nAppelez vos amis et combattez ensemble le Boss du Vortex !";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ALERT_TITLE:String       = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ALERT_AP:String          = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ALERT_DECK_USED:String   = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_ALERT_DECK_COMMIT:String = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_COPY_TITLE:String        = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_COPY:String              = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ALERT_TITLE:String       = "คำเตือน";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ALERT_AP:String          = "ขาดAP"; // APが不足してます
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ALERT_DECK_USED:String   = "Deckนี้กำลังใช้งานที่น้ำวน"; // このデッキは別の渦で使用中です
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_ALERT_DECK_COMMIT:String = "ไม่มีDeckที่กำลังใช้งาน"; // 使用中のデッキではありません
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_COPY_TITLE:String        = "คัดลอก"; // コピー
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_COPY:String              = "คักลอกURLของน้ำวนเรียบร้อย ! \nทุกท่านไปเข้าร่วมสงครามBossของน้ำวนกันเถอะ !"; // 渦のURLをコピーしました！\nみんなに知らせて協力して渦のボスと戦おう！

        private static const _NOTICE_TYPE_NONE:int  = 0;
        private static const _NOTICE_TYPE_LOBBY:int = 1;
        private static const _NOTICE_TYPE_PRF:int   = 2;

        private var trans:Transition = Transition.instance;

        // ゲームのコントローラ
        private var _ctrl:RaidCtrl;
        // チャットのコントローラ
        private var _rChatCtrl:RaidChatCtrl;
        // データのコントローラ
        private var _rDataCtrl:RaidDataCtrl;
        // ランクのコントローラ
        private var _rRankCtrl:RaidRankCtrl;

        // ロビーのコントローラ
        private var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;

        // Notice
        private var _notice:NoticePanel = new NoticePanel();
        private var _prfNotice:ProfoundNoticePanel = new ProfoundNoticePanel();

        // 親ステージ
        private var _stage:Sprite;
        private var _raidContainer:UIComponent  = new UIComponent(); // 表示コンテナ
        private var _frontContainer:UIComponent = new UIComponent(); // 表示コンテナ

        // プレイヤーインスタンス
        private var _player:Player = Player.instance;

        // BG
        private var _bg:RaidBG = new RaidBG();
        // Map
        private var _map:RaidMap = new RaidMap();
        // 情報
        private var _raidInfo:RaidInfo = new RaidInfo();
        // 一覧
        private var _raidList:RaidList = new RaidList();
        // PopUp情報
        private var _raidMiniInfo:RaidMiniInfo = new RaidMiniInfo();

        // アバター
        private var _avatar:AvatarView;

        // 渦情報リスト
        private var _prfListContainer:ProfoundListContainer = ProfoundListContainer.instance;

        // アイテムリスト
        private var _itemListButton:ItemListButton = new ItemListButton();

        // 戦闘ターン選択パネル
        private var _startBtlPanel:StartBattlePanel = new StartBattlePanel();
        // GiveUp確認パネル
        private var _giveUpPanel:GiveUpSendPanel = new GiveUpSendPanel();
        // レイドコード入力パネル
        private var _raidCodePanel:RaidCodePanel = new RaidCodePanel();
        // レイドコードコピーパネル
        private var _raidCodeCopyPanel:RaidCodeCopyPanel = new RaidCodeCopyPanel();
        // レイドヘルプパネル
        private var _raidHelpSendPanel:RaidHelpSendPanel = new RaidHelpSendPanel();

        // デッキ
        private var _raidDeck:RaidDeck = new RaidDeck();

        // 渦情報表示タイプ
        private var _prfNoticeType:int = _NOTICE_TYPE_NONE;

        // BossHpチェックインターバル
        // private static const _BOSS_HP_CHECK_TIME:int = 1000*10; // 3分ごとに更新チェック
        private static const _BOSS_HP_CHECK_TIME:int = 1000*30; // 30秒ごとに更新チェック
        // Noticeチェックインターバル
        // private static const _NOTICE_CHECK_TIME:int = 1000*10; // 3分ごとに更新チェック
        private static const _NOTICE_CHECK_TIME:int = 1000*30*1; // 30秒ごとに更新チェック
        // コメントチェックインターバル
        // private static const _COMMENT_CHECK_TIME:int = 1000*10; // 1分ごとに更新チェック
        private static const _COMMENT_CHECK_TIME:int = 1000*10; // 10秒ごとに更新チェック
        // ランキングチェックインターバル
        // private static const _RANKING_CHECK_TIME:int = 1000*10; // 10分ごとに更新チェック
        private static const _RANKING_CHECK_TIME:int = 1000*60*1; // 1分ごとに更新チェック
        // 報酬チェックインターバル
        // private static const _REWARD_CHECK_TIME:int = 1000*10; // 10分ごとに更新チェック
        private static const _REWARD_CHECK_TIME:int = 1000*60*1; // 3分ごとに更新チェック
        // 新規渦チェックインターバル
        // private static const _NEW_PRF_CHECK_TIME:int = 1000*10; // 10秒ごとに更新チェック
        private static const _NEW_PRF_CHECK_TIME:int = 1000*60*10; // 10分ごとに更新チェック
        // BossHpチェック用タイマー
        private var _bossHpTimer:Timer;
        // Noticeチェック用タイマー
        private var _noticeTimer:Timer;
        // コメントチェック用タイマー
        private var _commentTimer:Timer;
        // ランキングチェック用タイマー
        private var _rankingTimer:Timer;
        // 報酬チェック用タイマー
        private var _rewardTimer:Timer;
        // 新規渦チェック用タイマー
        private var _newPrfTimer:Timer;

        // 渦のログ管理
        private var _prfLogs:ProfoundLogs = ProfoundLogs.getInstance();
        // レイド用チャットエリア
        private var _raidChatArea:RaidChatArea  = new RaidChatArea();

        // 渦ハッシュチェック
        private var _isCheckHash:Boolean = false;

        // =======================================
        // Duel関連
        // =======================================
        // duelのインスタンス
        private var _duel:Duel = Duel.instance;
        // 親ステージ
        private var _duelContainer:UIComponent = new UIComponent(); // 表示コンテナ
        // Duel開始フラグ
        private var _battle:Boolean = false;
        //メインシークエンススレッドリスト
        private var _sequence:Array = []; //Array of Thread;
        // ゲームの中断フラグ
        private var _exitGame:Boolean;

        // カードのベース
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
        private var _chatArea:RaidDuelChatArea  = new RaidDuelChatArea();

        // デュエルテーブル
        private var _duelTable:DuelTable  = new DuelTable(true);

        // フェイズ表示
        private var _phaseArea:PhaseArea  = new PhaseArea();

        // 移動の矢印表示
        private var _moveArrow:MoveArrow = new MoveArrow();

        // ボーナス表示
        private var _bonusMess:BonusMessScene = new BonusMessScene();

        // レイドスコア表示
        private var _raidScore:RaidScoreScene = new RaidScoreScene();

        // 状態異常表示
        private var _bossBuffs:RaidBossBuffsWindow = new RaidBossBuffsWindow();

        // パッシブスキルの表示
        private var _passiveSkillScene:PassiveSkillScene = new PassiveSkillScene();

        // 制限時間表示
        private var _raidDuelTime:RaidDuelTime = new RaidDuelTime();
        // =======================================

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function RaidView(stage:Sprite)
        {
            log.writeLog(log.LV_FATAL, this,"create");
            _stage = stage;

            _bossHpTimer = new Timer(_BOSS_HP_CHECK_TIME);
            _bossHpTimer.addEventListener(TimerEvent.TIMER, updateBossHPHandler);
            _bossHpTimer.start();
            _noticeTimer = new Timer(_NOTICE_CHECK_TIME);
            _noticeTimer.addEventListener(TimerEvent.TIMER, noticeCheckHandler);
            _noticeTimer.start();
            _commentTimer = new Timer(_COMMENT_CHECK_TIME);
            _commentTimer.addEventListener(TimerEvent.TIMER, commentCheckHandler);
            _commentTimer.start();
            _rankingTimer = new Timer(_RANKING_CHECK_TIME);
            _rankingTimer.addEventListener(TimerEvent.TIMER, rankingCheckHandler);
            _rankingTimer.start();
            // _rewardTimer = new Timer(_REWARD_CHECK_TIME);
            // _rewardTimer.addEventListener(TimerEvent.TIMER, rewardCheckHandler);
            // _rewardTimer.start();
            _newPrfTimer = new Timer(_NEW_PRF_CHECK_TIME);
            _newPrfTimer.addEventListener(TimerEvent.TIMER, newPrfCheckHandler);
            _newPrfTimer.start();

            RaidHelpView.instance.isUpdate = true;
        }

        // スレッドのスタート
        override protected function run():void
        {
            GameCtrl.switchMode(GameCtrl.RAID);
            _ctrl = RaidCtrl(GameCtrl.instance);
            _ctrl.start(this);
            _rChatCtrl = RaidChatCtrl.instance;
            _rChatCtrl.start();
            _rDataCtrl = RaidDataCtrl.instance;
            _rDataCtrl.start();
            _rRankCtrl = RaidRankCtrl.instance;
            _rRankCtrl.start();

            // RMItemShopの更新が必要であれば行う
            RealMoneyShopView.itemReset();

            next(show);
        }

        // 配置オブジェの表示
        private function show():void
        {
            log.writeLog(log.LV_FATAL, this,"show");
            _stage.addChild(_raidContainer);
            _stage.addChild(_frontContainer);
            _bg.addChild(_itemListButton);
            ProfoundTreasureData.initializeData();

            // レイド画面ではニュースを表示しない
            LobbyNotice.getNews = false;

            _ctrl.playMatchBGM();

            next(serverAuthWaiting);
        }

        // サーバーの認証を待つ
        private function serverAuthWaiting():void
        {
            if (_ctrl.serverState == Host.CONNECT_AUTHED && _rChatCtrl.serverState == Host.CONNECT_AUTHED && _rDataCtrl.serverState == Host.CONNECT_AUTHED && _rRankCtrl.serverState == Host.CONNECT_AUTHED)
            {
                next(getProfoundDataWaiting);
            }else{
                next(serverAuthWaiting);
            }
        }

        // 渦情報の取得待ちを行う
        private function getProfoundDataWaiting():void
        {
            if (Profound.isLoaded)
            {
                log.writeLog(log.LV_DEBUG, this,"getProfoundDataWaiting",_map.mapNum);
                for (var i:int = 0; i < _map.mapNum; i++ ) {
                    ProfoundPositionsManager.instance.setPointStandard(i,_map.getMapPos(i));
                }
                _prfListContainer.listInitialize(_map.mapNum);
                next(show2);
            }else{
                next(getProfoundDataWaiting);
            }
        }

        // 配置オブジェの表示
        private function show2():void
        {
            log.writeLog(log.LV_FATAL, this,"show2");
            var pExec:ParallelExecutor = new ParallelExecutor();

            _prfLogs.prfId = 0;

            _avatar = AvatarView.getPlayerAvatar(Const.PL_AVATAR_QUEST);
            pExec.addThread(_bg.getShowThread(_raidContainer,0));
            pExec.addThread(_map.getShowThread(_raidContainer,1));
            pExec.addThread(_prfListContainer.getShowThread(_raidContainer,2));
            pExec.addThread(_avatar.getShowThread(_raidContainer,3));
            pExec.addThread(_raidDeck.getShowThread(_raidContainer,4));
            pExec.addThread(_raidList.getShowThread(_raidContainer,5));
            pExec.addThread(_raidInfo.getShowThread(_raidContainer,6));
            pExec.addThread(_raidChatArea.getShowThread(_raidContainer,16));
            pExec.addThread(_itemListButton.getShowThread(_raidContainer,17));
            pExec.addThread(_raidMiniInfo.getShowThread(_raidContainer,18));

            pExec.start();
            pExec.join();

            _raidChatArea.inputFlag = false;

            _startBtlPanel.visible = false;
            _frontContainer.addChild(_startBtlPanel);
            _giveUpPanel.visible = false;
            _frontContainer.addChild(_giveUpPanel);
            _raidCodePanel.visible = false;
            _frontContainer.addChild(_raidCodePanel);
            _raidCodeCopyPanel.visible = false;
            _frontContainer.addChild(_raidCodeCopyPanel);

            log.writeLog(log.LV_FATAL, this,"show2 avatar",_avatar,_avatar.exitButton);

            _bg.updateBtlPrfCount();

            next(eventSet);
        }

        private function eventSet():void
        {
            _rDataCtrl.setDeckEvent();
            _ctrl.addEventListener(RaidCtrl.BATTLE_START, battleStartHandler);
            _ctrl.addEventListener(RaidCtrl.BTL_START_FAILED, battleStartFailedHandler);
            _rDataCtrl.addEventListener(RaidDataCtrl.NOTICE_UPDATE, noticeUpdateHandler);
            _raidInfo.setButtonFunctions(openStartBattlePanel,giveUpBattle,copyRaidCodeClipBoardHandler);
            _avatar.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);
            _bg.back.addEventListener(MouseEvent.CLICK, leftDeckClickHandler);
            _bg.next.addEventListener(MouseEvent.CLICK, rightDeckClickHandler);
            _bg.code.addEventListener(MouseEvent.CLICK, raidCodeButtonClickHandler);
            _bg.setChatBtnFunc(chatOpenClickHandler,chatCloseClickHandler);
            _map.addEventListener(MouseEvent.CLICK,unSelectProfoundHandler);
            _prfListContainer.addEventListener(ProfoundEvent.SELECT,selectProfoundHandler);
            _prfListContainer.addEventListener(ProfoundEvent.MOUSE_OVER,mouseOverProfoundHandler);
            _prfListContainer.addEventListener(ProfoundEvent.MOUSE_OUT,mouseOutProfoundHandler);
            _raidList.addEventListener(ProfoundEvent.SELECT,selectProfoundHandler);
            _ctrl.addEventListener(ProfoundEvent.ADD_PRF,addProfoundHandler);
            _ctrl.addEventListener(ProfoundEvent.UPDATE_PRF,updateProfoundStateHandler);
            _ctrl.addEventListener(ProfoundEvent.FINISH_PRF,finishProfoundHandler);
            _ctrl.addEventListener(ProfoundEvent.VANISH_PRF,vanishProfoundHandler);
            _rDataCtrl.addEventListener(ProfoundEvent.ADD_PRF,addProfoundHandler);
            _rDataCtrl.addEventListener(ProfoundEvent.UPDATE_PRF,updateProfoundStateHandler);
            _rDataCtrl.addEventListener(ProfoundEvent.FINISH_PRF,finishProfoundHandler);
            _rDataCtrl.addEventListener(ProfoundEvent.VANISH_PRF,vanishProfoundHandler);
            _rDataCtrl.addEventListener(ProfoundEvent.GET_HASH,getHashHandler);
            _startBtlPanel.setOKHandler(startBtlPanelOkHandler);
            _startBtlPanel.setCloseHandler(startBtlPanelCloseHandler);
            _giveUpPanel.yesButton.addEventListener(MouseEvent.CLICK,giveUpYesButtonHandler);
            _giveUpPanel.noButton.addEventListener(MouseEvent.CLICK,giveUpNoButtonHandler);
            _raidCodePanel.confirm.addEventListener(MouseEvent.CLICK,sendRaidCodeHandler);
            _raidCodePanel.cancel.addEventListener(MouseEvent.CLICK,sendRaidCodeCancelHandler);
            _raidCodeCopyPanel.addEventListener(CloseEvent.CLOSE,copyPanelCloseButtonHander);
            _raidCodeCopyPanel.change.addEventListener(MouseEvent.CLICK,copyPanelChangeButtonHander);
            _raidCodeCopyPanel.help.addEventListener(MouseEvent.CLICK,copyPanelHelpButtonHander);
            _raidHelpSendPanel.setCloseFunc(helpSendPanelCloseFunc);

            ProfoundListContainer.resetImageButton();

            // Rewardチェックを入れる
            _rDataCtrl.checkProfoundReward();

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            next(show3);
        }

        // checkhash
        private function checkHash():void
        {
            if (Profound.urlProfoundHash != "") {
                _rDataCtrl.getProfoundForHash(Profound.urlProfoundHash);
            }
            _isCheckHash = false;
            next(show3);
        }

        // 配置オブジェの表示
        private function show3():void
        {
            // URLから移動の際に、Errorが返ってきてるなら、アラート表示
            if (Profound.urlErrorId != 0) {
                _ctrl.errorAlert(Profound.urlErrorId);
                Profound.urlErrorId = 0;
                Profound.urlProfoundHash = ""; // エラーが返ってきているので、Hashを無効にする
            } else if (Profound.urlProfoundHash != "" ) {
                // URLでPrfIDが指定されてエラーが出てなければ、選択状態にする
                var prf:Profound = Profound.urlProfound;
                if (prf&&Profound.urlErrorId == 0) {
                    _raidInfo.setProfoundInfo(prf);
                    updateDeckData();
                    _prfLogs.prfId = prf.id;
                    ProfoundListContainer.resetImageButton(prf.id);
                    _raidChatArea.inputFlag = true;
                }
            }

            // Noticeチェックを入れる
            _rDataCtrl.checkNewNotice();
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
                     next(loading);
                 }
                 else if (_prfNoticeType != _NOTICE_TYPE_NONE)
                 {
                     if (_prfNoticeType == _NOTICE_TYPE_LOBBY) {
                         next(showNoticeWait);
                     } else if (_prfNoticeType == _NOTICE_TYPE_PRF) {
                         next(showPrfNoticeWait);
                     }
                 }
                 else if (_isCheckHash) {
                     next(checkHash);
                 }
                 else
                 {
                     next(waiting);
                 }

             }
        }

        // Noticeの表示終了待ち
        private function showNoticeWait():void
        {
            if (! _notice.panelEnable() )
            {
                if (_prfNotice.checkInfo()) {
                    next(showPrfNoticeWait);
                    _prfNoticeType = _NOTICE_TYPE_PRF;
                } else {
                    setMouseEnabled = false;
                    _rDataCtrl.updateProfoundInventory();
                    next(retryGetProfoundDataWaiting);
                }
            }else{
                next(showNoticeWait);
            }
        }

        // Noticeの表示終了待ち
        private function showPrfNoticeWait():void
        {
            if (! _prfNotice.panelEnable() )
            {
                setMouseEnabled = false;
                _rDataCtrl.updateProfoundInventory();
                next(retryGetProfoundDataWaiting);
            }else{
                next(showPrfNoticeWait);
            }
        }

        // 渦情報の再取得待ちを行う
        private function retryGetProfoundDataWaiting():void
        {
            if (Profound.isLoaded)
            {
                setMouseEnabled = true;
                _prfNoticeType = _NOTICE_TYPE_NONE;
                _prfListContainer.listInitialize();
                next(waiting);
            }else{
                next(retryGetProfoundDataWaiting);
            }
        }

        // マウス判定設定
        private function set setMouseEnabled(f:Boolean):void
        {
            _avatar.mouseEnabled = f;
            _avatar.mouseChildren = f;
            _bg.mouseEnabled = f;
            _bg.mouseChildren = f;
            _map.mouseEnabled = f;
            _map.mouseChildren = f;
            _itemListButton.mouseEnabled = f;
            _itemListButton.mouseChildren = f;
            _raidInfo.mouseEnabled = f;
            _raidInfo.mouseChildren = f;
            _raidList.mouseEnabled = f;
            _raidList.mouseChildren = f;
            _prfListContainer.mouseEnabled = f;
            _prfListContainer.mouseChildren = f;
            _raidDeck.mouseEnabled = f;
            _raidDeck.mouseChildren = f;

            RaidHelpView.instance.isUpdate = f;
        }

        // 表示デッキ情報更新
        private function updateDeckData():void
        {
            if (_raidInfo&&_raidInfo.selectProfound) {
                _raidDeck.selectable = ProfoundInventory.isCanUseDeck(_raidInfo.selectProfound.id,_raidDeck.selectIndex);
            } else {
                _raidDeck.selectable = true;
            }
        }

        // 終了
        private function exitButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            var _player:Player = Player.instance;
            _player.state = Player.STATE_LOBBY;
        }

        // 左のデッキをクリック
        private function leftDeckClickHandler(e:MouseEvent):void
        {
            _raidDeck.leftDeckClick();
            // updateDeckData();
        }

        // 右のデッキをクリック
        private function rightDeckClickHandler(e:MouseEvent):void
        {
            _raidDeck.rightDeckClick();
            // updateDeckData();
        }

        // チャットウィンドウ開閉
        private function chatOpenClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, this,"chatOpen");
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor= new ParallelExecutor();
            pExec.addThread(new ClousureThread(function():void{_bg.chatWindowOpen();}));
            pExec.addThread(new ClousureThread(function():void{_raidDeck.changeHalfMode();}));
            pExec.addThread(new ClousureThread(function():void{_raidChatArea.openWindow();}));
            sExec.addThread(pExec);
            sExec.addThread(new SleepThread(200));
            sExec.addThread(new ClousureThread(function():void{_bg.chatCloseBtnEventReset();}));
            sExec.start();
        }
        private function chatCloseClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, this,"chatClose");
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor= new ParallelExecutor();
            pExec.addThread(new ClousureThread(function():void{_bg.chatWindowClose();}));
            pExec.addThread(new ClousureThread(function():void{_raidDeck.changeNormalMode();}));
            pExec.addThread(new ClousureThread(function():void{_raidChatArea.closeWindow();}));
            sExec.addThread(pExec);
            sExec.addThread(new SleepThread(200));
            sExec.addThread(new ClousureThread(function():void{_bg.chatOpenBtnEventReset();}));
            sExec.start();
        }

        // 渦を選択
        private function selectProfoundHandler(e:ProfoundEvent):void
        {
            // log.writeLog(log.LV_FATAL, this,"selectProfound",e.prf.id);
            _raidInfo.setProfoundInfo(e.prf);
            _raidList.setSelectProfound(e.prf);
            updateDeckData();
            _prfLogs.prfId = e.prf.id;
            ProfoundListContainer.resetImageButton(e.prf.id);
            _raidChatArea.inputFlag = true;
        }
        // 渦の選択を解除
        private function unSelectProfoundHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, this,"unselectProfound");
            if (!_startBtlPanel.visible&&!_giveUpPanel.visible&&_raidInfo.selectProfound ) {
                _prfLogs.prfId = 0;
                _raidChatArea.inputFlag = false;
                _bg.updateBtlPrfCount();
                _raidInfo.clearProfoundInfo();
                _raidList.unselPrf();
            }
            updateDeckData();
            ProfoundListContainer.resetImageButton();
        }
        // 渦上にカーソル移動
        private function mouseOverProfoundHandler(e:ProfoundEvent):void
        {
            // log.writeLog(log.LV_DEBUG, this,"mosueOverProfound",e.prf.id,e.posX,e.posY);
            _raidMiniInfo.setProfoundInfo(e.prf,e.posX,e.posY);
        }
        // 渦上からカーソル移動
        private function mouseOutProfoundHandler(e:ProfoundEvent):void
        {
            // log.writeLog(log.LV_DEBUG, this,"mosueOutProfound",e.prf.id,e.posX,e.posY);
            _raidMiniInfo.clearProfoundInfo();
        }

        // 渦を追加
        private function addProfoundHandler(e:ProfoundEvent):void
        {
            // log.writeLog(log.LV_FATAL, this,"addProfound",e.prf.id);
            ProfoundListContainer.resetImageButton();
            _prfListContainer.addProfound(e.prf);
            _raidInfo.setProfoundInfo(e.prf);
            _raidList.resetList();
            _raidList.setSelectProfound(e.prf);
            _bg.updateBtlPrfCount();
            updateDeckData();
            _prfLogs.prfId = e.prf.id;
            _raidChatArea.inputFlag = true;
        }

        // 渦Stateが更新
        private function updateProfoundStateHandler(e:ProfoundEvent):void
        {
            // log.writeLog(log.LV_FATAL, this,"addProfound",e.prf.id);
            if (_raidInfo) {
                _raidInfo.setProfoundInfo(e.prf);
                _bg.updateBtlPrfCount();
            }
        }

        // 渦戦闘が終了
        private function finishProfoundHandler(e:ProfoundEvent):void
        {
            log.writeLog(log.LV_FATAL, this,"finishProfoundHandler",e.prf.id,_prfListContainer,_raidInfo,_bg);
            // _raidInfo.buttonVisibles = false;
            _prfListContainer.setFinish(e.prf.id,true);
            _raidInfo.buttonVisibleCheck();
            _bg.updateBtlPrfCount();
        }

        // 渦が消滅
        private function vanishProfoundHandler(e:ProfoundEvent):void
        {
            log.writeLog(log.LV_DEBUG, this,"vanishProfound",e.prf.id,_raidMiniInfo.selPrfId);
            if (_raidInfo.selectProfound && _raidInfo.selectProfound.id == e.prf.id) {
                _prfLogs.prfId = 0;
                _raidChatArea.inputFlag = false;
                _raidInfo.clearProfoundInfo();
            }
            if (e.prf.id == _raidMiniInfo.selPrfId) {
                _raidMiniInfo.clearProfoundInfo();
            }
            if ( _startBtlPanel.visible && _startBtlPanel.selProfound && _startBtlPanel.selProfound.id == e.prf.id ) {
                _startBtlPanel.visible = false;
                setMouseEnabled = true;
            }
            _prfListContainer.vanishProfound(e.prf);
            _raidList.resetList();
            _bg.updateBtlPrfCount();
            _raidChatArea.resetInputText();
            updateDeckData();
            ProfoundListContainer.resetImageButton();
            // 終了後ノーティスをチェック
            _rDataCtrl.checkNewNotice();
            // Rewardチェックを入れる
            _rDataCtrl.checkProfoundReward();
        }

        // 戦闘開始パネル表示
        private function openStartBattlePanel():void
        {
            // log.writeLog(log.LV_FATAL, this,"openStartBattlePanel",_raidDeck.selectable);
            // if (_raidDeck.selectable) {
                var prf:Profound = _raidInfo.selectProfound;
                if (prf) {
                    setMouseEnabled = false;
                    _startBtlPanel.setProfound(prf);
                    _startBtlPanel.visible = true;
                }
            // } else {
            //     if (ProfoundInventory.getUsedDeckInvId(_raidDeck.selectIndex) != 0) {
            //         Alerter.showWithSize(_TRANS_MSG_ALERT_DECK_USED,_TRANS_MSG_ALERT_TITLE);
            //     } else {
            //         Alerter.showWithSize(_TRANS_MSG_ALERT_DECK_COMMIT,_TRANS_MSG_ALERT_TITLE);
            //     }
            // }
        }

        // ギブアップ
        private function giveUpBattle():void
        {
            log.writeLog(log.LV_FATAL, this,"giveUpBattle");
            setMouseEnabled = false;
            _giveUpPanel.visible = true;
        }

        // レイドコードパネル表示
        private function raidCodeButtonClickHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this,"raidCodePanelHandler");
            setMouseEnabled = false;
            _raidCodePanel.visible = true;
        }
        // レイドコード送信
        private function sendRaidCodeHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this,"sendRaidCodeHandler");
            if (_raidCodePanel.hash != "") {
                _rDataCtrl.getProfoundForHash(_raidCodePanel.hash);
            }
            setMouseEnabled = true;
            _raidCodePanel.resetText();
            _raidCodePanel.visible = false;
        }
        // レイドコードパネル非表示
        private function sendRaidCodeCancelHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this,"raidCodePanelCancelHandler");
            setMouseEnabled = true;
            _raidCodePanel.resetText();
            _raidCodePanel.visible = false;
        }

        // 戦闘開始パネルOkボタンハンドラー
        private function startBtlPanelOkHandler():void
        {
            log.writeLog(log.LV_DEBUG, this,"startBtlPanelOkHandler",_raidInfo.selectProfound);
            if (_raidInfo.selectProfound && Player.instance.avatar.energy >= _startBtlPanel.useAp) {
                var pi:ProfoundInventory = ProfoundInventory.getProfoundInventoryForPrfId(_raidInfo.selectProfound.id);
                if (pi) {
                    _ctrl.bossDuelStart(pi.id,_startBtlPanel.selTurn,_startBtlPanel.useAp);
                    _base.setEndTurn(_startBtlPanel.selTurn);
                    _ctrl.state = DuelCtrl.GAME_STAGE;
                }
            } else {
                Alerter.showWithSize(_TRANS_MSG_ALERT_AP,_TRANS_MSG_ALERT_TITLE);
                setMouseEnabled = true;
                _ctrl.state = DuelCtrl.WAITING;
            }
            _startBtlPanel.visible = false;
        }

        // 戦闘開始パネルCloseボタンハンドラー
        private function startBtlPanelCloseHandler():void
        {
            _startBtlPanel.visible = false;
            setMouseEnabled = true;
        }

        // GiveUpパネルYesボタンハンドラー
        private function giveUpYesButtonHandler(e:MouseEvent):void
        {
            // log.writeLog(log.LV_FATAL, this, "giveUpYesButtonHandler");
            if (_raidInfo.selectProfound) {
                _rDataCtrl.giveUpProfound(_raidInfo.selectProfound.id);
            }
            _giveUpPanel.visible = false;
            setMouseEnabled = true;
            ProfoundListContainer.resetImageButton();
        }
        // GiveUpパネNoボタンハンドラー
        private function giveUpNoButtonHandler(e:MouseEvent):void
        {
            // log.writeLog(log.LV_FATAL, this, "giveUpNoButtonHandler");
            _giveUpPanel.visible = false;
            setMouseEnabled = true;
        }

        // CODE Copyボタンハンドラ
        private function copyRaidCodeClipBoardHandler():void
        {
            _rDataCtrl.requestProfoundHash(_raidInfo.selectProfound.id);
        }

        //
        private function getHashHandler(e:ProfoundEvent):void
        {
            if (_raidInfo) {
                var type:int = (_raidInfo.selectProfound.finderAvatarId == _player.avatar.id) ? RaidCodeCopyPanel.PANEL_TYPE_OWNER : RaidCodeCopyPanel.PANEL_TYPE_OTHER;
                setMouseEnabled = false;
                _raidCodeCopyPanel.show(e.hash,type,_raidInfo.selectProfound.copyType,_raidInfo.selectProfound.setDefeatReward);
            }
        }

        private function copyPanelCloseButtonHander(e:Event):void
        {
            _raidCodeCopyPanel.visible = false;
            setMouseEnabled = true;
        }

        private function copyPanelChangeButtonHander(e:Event):void
        {
            _rDataCtrl.changeConfig(_raidInfo.selectProfound.id,_raidCodeCopyPanel.selType,_raidCodeCopyPanel.selSwitch);
            _raidCodeCopyPanel.visible = false;
            setMouseEnabled = true;
        }

        private function copyPanelHelpButtonHander(e:Event):void
        {
            _raidCodeCopyPanel.visible = false;
            setMouseEnabled = true;
            if (_raidInfo) {
                Unlight.INS.topContainer.parent.addChild(_raidHelpSendPanel);
                Unlight.INS.topContainer.mouseEnabled = false;
                Unlight.INS.topContainer.mouseChildren = false;
                _raidHelpSendPanel.show(_player.id,_raidInfo.selectProfound.prfHash);
            }
        }

        private function helpSendPanelCloseFunc():void
        {
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            RemoveChild.apply(_raidHelpSendPanel);
        }

        // 戦闘開始
        private function battleStartHandler(e:Event):void
        {
            _battle = true;
        }

        // 戦闘開始失敗
        private function battleStartFailedHandler(e:Event):void
        {
            setMouseEnabled = true;
        }

        private function noticeCheckHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "noticeCheckHandler");
            if (!_battle && _prfNoticeType == _NOTICE_TYPE_NONE && !_notice.panelEnable() && !_prfNotice.panelEnable() )
            {
                _rDataCtrl.checkNewNotice();
            }
        }

        // Notice更新
        private function noticeUpdateHandler(e:Event):void
        {
            if (! _battle) {
                noticeUpdateCheck();
            }
        }
        private function noticeUpdateCheck():void
        {
            if (! _notice.panelEnable() ) {
                if (_notice.checkInfo()) {
                    _prfNoticeType = _NOTICE_TYPE_LOBBY;
                } else if (_prfNotice.checkInfo()) {
                    _prfNoticeType = _NOTICE_TYPE_PRF;
                }
            }
        }

        // ボスHPの更新
        private function updateBossHPHandler(e:Event):void
        {
            // log.writeLog(log.LV_DEBUG, this, "updateBossHPHandler");
            if (! _battle) {
                if (_raidInfo&&_raidInfo.selectProfound) {
                    _rDataCtrl.updateBossHP(_raidInfo.selectProfound);
                }
            }
        }

        private function commentCheckHandler(e:Event):void
        {
             log.writeLog(log.LV_FATAL, this, "commentCheckHandler");
             if (_prfNoticeType == _NOTICE_TYPE_NONE && _prfLogs.prfId != 0 )
            {
                _rChatCtrl.requestComment(_prfLogs.prfId,_prfLogs.lastId);
            }
        }

        private function rankingCheckHandler(e:Event):void
        {
            // log.writeLog(log.LV_FATAL, this, "rankingCheckHandler");
            if (!_battle && _prfNoticeType == _NOTICE_TYPE_NONE && _raidInfo )
            {
                _raidInfo.updateRanking();
            }
        }

        private function rewardCheckHandler(e:Event):void
        {
            // log.writeLog(log.LV_FATAL, this, "rewardCheckHandler");
            if (!_battle && _prfNoticeType == _NOTICE_TYPE_NONE)
            {
                _rDataCtrl.checkProfoundReward();
            }
        }

        private function newPrfCheckHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "newPrfCheckHandler");
            if (!_battle && _prfNoticeType == _NOTICE_TYPE_NONE)
            {
                _rDataCtrl.updateProfoundInventory();
            }
        }

        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _isCheckHash = true;
        }

        private function hide():void
        {
            // 出るときに元に戻す
            LobbyNotice.getNews = true;

            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_raidContainer, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_frontContainer, {alpha:0.0}, null, 0.8 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.addThread(_raidDeck.getHideThread());
            pExec.addThread(_avatar.getHideThread());

            pExec.start();
            pExec.join();

            next(hide2);
        }

        // 配置オブジェの表示
        private function hide2():void
        {
            next(exit);
        }

        private function exit():void
        {
            _ctrl.stopMatchBGM()
            _bg.getHideThread().start();
            _map.getHideThread().start();
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);
            _rDataCtrl.unsetDeckEvent();
            _bg.back.removeEventListener(MouseEvent.CLICK, leftDeckClickHandler);
            _bg.next.removeEventListener(MouseEvent.CLICK, rightDeckClickHandler);
            _bg.code.removeEventListener(MouseEvent.CLICK, raidCodeButtonClickHandler);
            _avatar.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            _prfListContainer.removeEventListener(ProfoundEvent.SELECT,selectProfoundHandler);
            _prfListContainer.removeEventListener(ProfoundEvent.MOUSE_OVER,mouseOverProfoundHandler);
            _prfListContainer.removeEventListener(ProfoundEvent.MOUSE_OUT,mouseOutProfoundHandler);
            _rDataCtrl.removeEventListener(ProfoundEvent.ADD_PRF,addProfoundHandler);
            _rDataCtrl.removeEventListener(ProfoundEvent.UPDATE_PRF,updateProfoundStateHandler);
            _rDataCtrl.removeEventListener(ProfoundEvent.FINISH_PRF,finishProfoundHandler);
            _rDataCtrl.removeEventListener(ProfoundEvent.VANISH_PRF,vanishProfoundHandler);
            _giveUpPanel.yesButton.removeEventListener(MouseEvent.CLICK,giveUpYesButtonHandler);
            _giveUpPanel.noButton.removeEventListener(MouseEvent.CLICK,giveUpNoButtonHandler);
            _raidCodePanel.confirm.removeEventListener(MouseEvent.CLICK,sendRaidCodeHandler);
            _raidCodePanel.cancel.removeEventListener(MouseEvent.CLICK,sendRaidCodeCancelHandler);
            _raidCodeCopyPanel.removeEventListener(CloseEvent.CLOSE,copyPanelCloseButtonHander);
            _raidCodeCopyPanel.change.removeEventListener(MouseEvent.CLICK,copyPanelChangeButtonHander);
            _raidCodeCopyPanel.help.removeEventListener(MouseEvent.CLICK,copyPanelHelpButtonHander);
            _raidInfo.getHideThread().start();
            _raidMiniInfo.getHideThread().start();
            _stage.removeChild(_raidContainer);
            _stage.removeChild(_frontContainer);

            // 次回のInの時の読み込み用
            Profound.isLoaded = false;

            _ctrl.exit();
            _rChatCtrl.exit();
            _rDataCtrl.exit();
            _rRankCtrl.exit();
        }


        // 配置オブジェクトをきれいに消す
        private function bringOffHandler(e:EndGameEvent):void
        {
            log.writeLog(log.LV_WARN, this, "bringOffHandler");
            _ctrl.addViewSequence(new ClousureThread(_ctrl.stopDuelBGM));
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
        }

        // ゲームの終了
        public function finishGame():void
        {
            log.writeLog(log.LV_WARN, this, "finish");
            _exitGame = true;
            _battle = false;
        }


        // 配置オブジェの読み込み
        private function loading():void
        {
			// By_K2
            _stage.stage.frameRate = 24 * Unlight.SPEED;

            RaidHelpView.instance.isUpdate = false;

            Transition.instance.setTransionImage(_raidContainer, _duelContainer);
            Transition.instance.getBurnigTransitionThread().start();

            _exitGame = false;

            log.writeLog(log.LV_DEBUG, this, "loading",_raidInfo.selectProfound);

            _ctrl.stopMatchBGM();
            _ctrl.stageNo = _duel.stage;
            _ctrl.playDuelBGM();

            // ログアウトしていないか？
            if ( _player.state != Player.STATE_LOGOUT && _raidInfo.selectProfound)
            {
                // ここでステージの値をいれる
                _fbg = new FarBG(_duel.stage);
                _nbg = new NearBG(_duel.stage);
                _opPop = new OpeningPop();
                log.writeLog(log.LV_INFO, this, "loading 1");

                var pExec:ParallelExecutor = new ParallelExecutor();
                pExec.addThread(_fbg.getShowThread(_duelContainer, 0));
                pExec.addThread(_duelTable.positionArea.getShowThread(_duelContainer,1));
                pExec.addThread(_standChara.getShowThread(_duelContainer,2));
                pExec.addThread(_nbg.getShowThread(_duelContainer, 3));
                if (_player && _player.avatar ) {
                    _opening.avatarIds = [_player.avatar.id];
                }
                pExec.addThread(_opening.getShowThread(_duelContainer,4));
                pExec.addThread(_base.getShowThread(_duelContainer, 4));
                pExec.addThread(_opPop.getShowThread(_duelContainer,5));
                pExec.addThread(_featInfo.getShowThread(_duelContainer,5));
                pExec.addThread(_duelTable.deckArea.getShowThread(_duelContainer,6));
                pExec.addThread(_duelTable.baseCard.getShowThread(_duelContainer,7));
                pExec.addThread(_hp.getShowThread(_duelContainer,8));

                log.writeLog(log.LV_INFO, this, "loading 2");

                _duelAvatars.isRaid = true;
                pExec.addThread(_duelAvatars.getShowThread(_duelContainer,11));
                pExec.addThread(_infoBar.getShowThread(_duelContainer,12));

                log.writeLog(log.LV_INFO, this, "loading 3");


                pExec.addThread(_phaseArea.getShowThread(_duelContainer,14));

                // レイド戦用変数を設定
                _chatArea.prfId = _raidInfo.selectProfound.id;
                pExec.addThread(_chatArea.getShowThread(_duelContainer,16));


                pExec.addThread(_duelTable.resultScene.getShowThread(_duelContainer,18));



                // 22～30まではActionCardが使う(26はキャラカード)
                pExec.addThread(_bonusMess.getShowThread(_duelContainer,25));
                pExec.addThread(_passiveSkillScene.getShowThread(_duelContainer,26));
                pExec.addThread(_raidScore.getShowThread(_duelContainer,26));
                pExec.addThread(_duelCharaCards.getShowThread(_duelContainer,30));
                pExec.addThread(_moveArrow.getShowThread(_duelContainer,31));


                //pExec.addThread(_bossBuffs.getShowThread(_duelContainer,32));
                _raidDuelTime.selProfound = _raidInfo.selectProfound;
                pExec.addThread(_raidDuelTime.getShowThread(_duelContainer,32));
                pExec.addThread(_featScene.getShowThread(_duelContainer,33));

                 log.writeLog(log.LV_INFO, this, "loading 4");

                _duel.addEventListener(EndGameEvent.GAME_END, bringOffHandler);

				// By_K2
				_featScene.addEventListener(FeatScene.FEAT_FPS_DOWN, feat_fps_down);
				_featScene.addEventListener(FeatScene.FEAT_FPS_UP, feat_fps_up);

                _stage.addChildAt(_duelContainer,_stage.numChildren-1);

                _stage.removeChild(_raidContainer);
                _stage.removeChild(_frontContainer);
                pExec.start();
                pExec.join();

                next(bring);
            }
            else
            {
                // 中断処理
                next(abortHide);
            }
        }

        // 配置後にキャラクターカードを登場させる
        private function bring():void
        {
            log.writeLog(log.LV_INFO, this, "bring");

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();

            // pExec2.addThread(_duelCharaCards.getBringOnThread());
            // pExec2.addThread(_opening.getBringOnThread());
            pExec2.addThread(_opening.getBringOnThread(_base.getNameBringOnThread(),
                                                       _duelCharaCards.getBringOnThread(),
                                                       _opPop.getAnimeThread()));
            sExec.addThread(pExec2);
            sExec.addThread(_opening.getBringOffThread(_opPop.getBringOffThread()));
            // sExec.addThread(_opening.getHideThread());

             var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(_duelTable.getShowThread(_duelContainer));

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
            //pExec.addThread(_bossBuffs.getBringOnThread());
            pExec.addThread(_raidDuelTime.getBringOnThread());
            pExec.addThread(_bonusMess.getBringOnThread());
            pExec.addThread(_raidScore.getBringOnThread());
            pExec.addThread(_passiveSkillScene.getBringOnThread());

            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(_ctrl.startOk));

            sExec.start();
            sExec.join();
            _duel.updateRaidScore();
            next(eventWait);
        }


        // ゲームのループ部分(sequenceの)
        private function eventWait():void
        {
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

        // Duelから全て退場
        private function bringAllOff(result:int = 0):void
        {
            if (_hp.getPlHp > 0 && _hp.getFoeHp > 0)
            {
                Voice.playCharaVoice(_duel.playerCharaCard.parentID, Const.VOICE_SITUATION_BATTLE_DRAW, 0,0, Const.VOICE_PLAYING_METHOD_ADDITIOAL);
            }

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_chatArea.getBringOffThread());
            pExec.addThread(_hp.getBringOffThread());
            pExec.addThread(_featInfo.getBringOffThread());
            pExec.addThread(_infoBar.getBringOffThread());
            pExec.addThread(_duelTable.getBringOffThread());
            pExec.addThread(_standChara.getBringOffThread(result));
            pExec.addThread(_duelCharaCards.getBringOffThread());
            pExec.addThread(_duelAvatars.getBringOffThread());
            pExec.addThread(_phaseArea.getBringOffThread());
            pExec.addThread(_opening.getUpBarBringOffThread());
            pExec.addThread(_base.getBringOffThread());
            //pExec.addThread(_bossBuffs.getBringOffThread());
            pExec.addThread(_raidDuelTime.getBringOffThread());
            pExec.addThread(_bonusMess.getBringOffThread());
            pExec.addThread(_raidScore.getBringOffThread());
            pExec.addThread(_passiveSkillScene.getBringOffThread());
            addSequence(new SleepThread(1500));
            addSequence(pExec);
        }

        // Duel開始失敗
        private function abortHide():void
        {
            log.writeLog(log.LV_WARN, this, "abort hide");
            _sequence = [];
            _ctrl.state = DuelCtrl.WAITING;
            _battle = false;
            setMouseEnabled = true;
            infoUpdate();
            next(waiting)
        }

        // 情報更新
        private function infoUpdate():void
        {
            log.writeLog(log.LV_DEBUG, this, "infoUpdate",_raidInfo.selectProfound);
            _rDataCtrl.checkNewNotice();
            if (_raidInfo.selectProfound) {
                _rDataCtrl.updateBossHP(_raidInfo.selectProfound);
            }
            _raidInfo.updateRanking();
            noticeUpdateCheck(); // すでにノーティスがあればすぐ表示
        }

        // Duel終了
        private function exitGame():void
        {
            log.writeLog(log.LV_WARN, this, "return to RaidLobby");
            _lobbyCtrl.avatarUpdateCheck();

            _duel.removeEventListener(EndGameEvent.GAME_END, bringOffHandler);

			// By_K2
			_featScene.removeEventListener(FeatScene.FEAT_FPS_DOWN, feat_fps_down);
			_featScene.removeEventListener(FeatScene.FEAT_FPS_UP, feat_fps_up);

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new ClousureThread(_ctrl.stopDuelBGM));

            //pExec.addThread(_bossBuffs.getHideThread());
            pExec.addThread(_raidDuelTime.getHideThread());

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
            pExec.addThread(_fbg.getHideThread());
            pExec.addThread(_opening.getHideThread());
            pExec.addThread(_opPop.getHideThread());
            pExec.addThread(_base.getHideThread());

            sExec.addThread(pExec);
            // sExec.addThread(new ClousureThread(_rDataCtrl.checkNewNotice));
            sExec.addThread(new ClousureThread(infoUpdate));
            sExec.start();
            sExec.join();
            addSequence(sExec);
            // 元に戻す
            _chatArea.prfId = 0;
            _raidDuelTime.selProfound = null;
            // ボスのHPを更新
            _raidInfo.updateBossHp();
            _raidList.resetList();
            // レイドを出す
            _stage.addChild(_raidContainer);
            _stage.addChild(_frontContainer);
            setMouseEnabled = true;

            _ctrl.state = DuelCtrl.WAITING;
            _ctrl.playMatchBGM();

            RaidHelpView.instance.isUpdate = true;
            next(waiting);
        }

        // 終了関数
        override protected  function finalize():void
        {
			// By_K2
            _stage.stage.frameRate = 24;

            _rDataCtrl.unsetDeckEvent();
            _ctrl.removeEventListener(RaidCtrl.BATTLE_START, battleStartHandler);
            _ctrl.removeEventListener(RaidCtrl.BTL_START_FAILED, battleStartFailedHandler);
            _rDataCtrl.removeEventListener(RaidDataCtrl.NOTICE_UPDATE, noticeUpdateHandler);
            _bg.back.removeEventListener(MouseEvent.CLICK, leftDeckClickHandler);
            _bg.next.removeEventListener(MouseEvent.CLICK, rightDeckClickHandler);
            _avatar.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            _prfListContainer.removeEventListener(ProfoundEvent.SELECT,selectProfoundHandler);
            _rDataCtrl.removeEventListener(ProfoundEvent.ADD_PRF,addProfoundHandler);
            _rDataCtrl.removeEventListener(ProfoundEvent.UPDATE_PRF,updateProfoundStateHandler);
            _rDataCtrl.removeEventListener(ProfoundEvent.FINISH_PRF,finishProfoundHandler);
            _rDataCtrl.removeEventListener(ProfoundEvent.VANISH_PRF,vanishProfoundHandler);
            _giveUpPanel.yesButton.removeEventListener(MouseEvent.CLICK,giveUpYesButtonHandler);
            _giveUpPanel.noButton.removeEventListener(MouseEvent.CLICK,giveUpNoButtonHandler);
            _raidCodePanel.confirm.removeEventListener(MouseEvent.CLICK,sendRaidCodeHandler);
            _raidCodePanel.cancel.removeEventListener(MouseEvent.CLICK,sendRaidCodeCancelHandler);
            _raidCodeCopyPanel.removeEventListener(CloseEvent.CLOSE,copyPanelCloseButtonHander);
            _raidCodeCopyPanel.change.removeEventListener(MouseEvent.CLICK,copyPanelChangeButtonHander);
            _raidCodeCopyPanel.help.removeEventListener(MouseEvent.CLICK,copyPanelHelpButtonHander);
            // _bg = null;
            // _map = null;
            // _raidContainer = null;
            // _frontContainer = null;
            // _raidDeck = null;
            // _avatar = null;
            // _chatArea = null;
            // _prfListContainer = null;
            // _raidInfo = null;
            // _passiveSkillScene = null;

            _bossHpTimer.stop();
            _noticeTimer.stop();
            _commentTimer.stop();
            _rankingTimer.stop();
            // _rewardTimer.stop();
            _newPrfTimer.stop();
            _bossHpTimer.removeEventListener(TimerEvent.TIMER, updateBossHPHandler);
            _noticeTimer.removeEventListener(TimerEvent.TIMER, noticeCheckHandler);
            _commentTimer.removeEventListener(TimerEvent.TIMER, commentCheckHandler);
            _rankingTimer.removeEventListener(TimerEvent.TIMER, rankingCheckHandler);
            // _rewardTimer.removeEventListener(TimerEvent.TIMER, rewardCheckHandler);
            _newPrfTimer.removeEventListener(TimerEvent.TIMER, newPrfCheckHandler);
        }


        // 選択中の渦情報の取得
        public function get selectProfound():Profound
        {
            return (_raidInfo) ? _raidInfo.selectProfound : null;
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