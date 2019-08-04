 package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;
    import mx.core.MovieClipLoaderAsset;
    import mx.containers.*;
    import mx.controls.*;


    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;


    import model.*;
    import model.events.*;

    import view.image.library.*;
    import view.scene.edit.*;;
    import view.scene.common.*;
    import view.scene.*;
    import view.scene.library.*;
    import view.utils.*;

    import controller.*;

    /**
     * Library画面のビュークラス
     *
     */

    public class LibraryView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_TITLE	:String = "ライブラリ";

        CONFIG::LOCALE_EN
        private static const _TRANS_TITLE	:String = "Library";

        CONFIG::LOCALE_TCN
        private static const _TRANS_TITLE	:String = "圖書館";

        CONFIG::LOCALE_SCN
        private static const _TRANS_TITLE	:String = "图书馆";

        CONFIG::LOCALE_KR
        private static const _TRANS_TITLE	:String = "라이브러리";

        CONFIG::LOCALE_FR
        private static const _TRANS_TITLE	:String = "Bibliothèque";

        CONFIG::LOCALE_ID
        private static const _TRANS_TITLE	:String = "Library";

        CONFIG::LOCALE_TH
        private static const _TRANS_TITLE   :String = "ห้องสมุด";


        // 親ステージ
        private var _stage:Sprite;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        private var _charaPageSelBtn:CharaCardPageButton = new CharaCardPageButton();

        private var _bg:BG = new BG();

        private var _exitButton:Button = new Button();

        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // アバタービュー
        private var _avatarView:AvatarView;

        // カードデータ部分
        private var _dataArea:LibraryDataArea = LibraryDataArea.getCharaCardData();


        // キャラクターストーリーリストコンテナ
        private var _charaStoryListScene:CharaStoryListScene;
        // キャラクターカードリストコンテナ
        private var _charaCardListScene:CharaCardListScene;
        // 復活キャラクターカードリストコンテナ
        private var _rebornCharaCardListScene:CharaCardListScene;
        // モンスターカードリストコンテナ
        private var _monsCardListScene:MonsterCardListScene;

        private var _listSceneSet:Array =[]; /* of ListScenr */

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 150;
        private const _TITLE_HEIGHT:int = 40;
        private var _player:Player = Player.instance;

        private var _currentPage:int;
        private var _currentPageNum:int;

        private var _currentTabIndex:int;

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */
        public function LibraryView(stage:Sprite)
        {
            var list:Array = CharaCard.getCardList(); /* of Vevtor */

            _stage = stage;
            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_EDIT);
            _charaCardListScene = new CharaCardListScene(list[0]);
            _rebornCharaCardListScene = new CharaCardListScene(list[1],CharaCardListScene.LIST_TYPE_REBORN);
            _monsCardListScene = new MonsterCardListScene(list[2]);

            var storyList:Array = CharaCard.getCardListForStoryAge(); /* of CharaCard */
            _charaStoryListScene = new CharaStoryListScene(storyList);

            _charaCardListScene.addEventListener(EditCardEvent.SELECT_CARD, _dataArea.selectListCardHandler);
            _rebornCharaCardListScene.addEventListener(EditCardEvent.SELECT_CARD, _dataArea.selectListCardHandler);
            _monsCardListScene.addEventListener(EditCardEvent.SELECT_CARD, _dataArea.selectListCardHandler);

            _listSceneSet.push(_charaCardListScene);
            _listSceneSet.push(_charaStoryListScene);
            _listSceneSet.push(_charaCardListScene);
            _listSceneSet.push(_monsCardListScene);
            _listSceneSet.push(_rebornCharaCardListScene);

            _bg.setTabFunc(tabClickAction,nextClickAction,backClickAction);
            _container.addChild(_bg);
            _container.addChild(_charaPageSelBtn);
            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);

            RaidHelpView.instance.isUpdate = true;
        }


        // スレッドのスタート
        override protected  function run():void
        {
            _dataArea.storyButton = _bg.story;
            // イベントの登録
            next(initTitle);
        }

        // タイトルの初期化
        private function initTitle():void
        {
            _title.x = _TITLE_X;
            _title.y = _TITLE_Y;
            _title.width = _TITLE_WIDTH;
            _title.height = _TITLE_HEIGHT-20;
            _title.text = "Library";
            _title.styleName = "EditTitleLabel";
            _title.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _title.alpha = 0.0;

            _titleJ.x = _TITLE_X + 80;
            _titleJ.y = _TITLE_Y + 7;
            _titleJ.width = _TITLE_WIDTH;
            _titleJ.height = _TITLE_HEIGHT-20;
            _titleJ.text = _TRANS_TITLE;
            _titleJ.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _titleJ.alpha = 0.0;
            next(show);
        }

        // 配置オブジェの表示
        private function show():void
        {
            tabClickAction(2);
            _stage.addChild(_container);

            _stage.addChild(_title);
            _stage.addChild(_titleJ);

            _charaPageSelBtn.ulCardBtn.addEventListener(MouseEvent.CLICK,ulCardBtnClickHandler);
            _charaPageSelBtn.rbCardBtn.addEventListener(MouseEvent.CLICK,rbCardBtnClickHandler);

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getShowThread(_container));
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(_dataArea.getShowThread(_container, 3));
            pExec.start();
            pExec.join();

            next(show2);
        }

        // 配置オブジェの表示
        private function show2():void
        {

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_dataArea, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            pExec.start();
            _bg.mouseEnabled = true;
            _bg.mouseChildren = true;
            pExec.join();

            next(waiting);
        }

        // ループ
        private function waiting():void
        {
            if (_player.state == Player.STATE_LOGOUT ||_player.state == Player.STATE_LOBBY )
            {
                next(hide);
            }
            else
            {
                next(waiting);
            }

        }


        // 終了
        private function exitButtonHandler(e:MouseEvent):void
        {
            _container.mouseEnabled = false;
            _container.mouseChildren = false;
            SE.playClick();
            _player.state = Player.STATE_LOBBY;
            log.writeLog(log.LV_INFO, this, "push exit");
        }

        private function tabClickAction(t:int):void
        {
            for(var i:int = 0; i < 5; i++){
                if (i==t)
                {
                    _container.addChild(_listSceneSet[i]);
                    _currentTabIndex = t;
                    updatePage();
                    if(_dataArea.ccc!=null)
                    {
                        _dataArea.resetCard();
                    }
                }else{
                    RemoveChild.apply(_listSceneSet[i]);
                }
            }
        }

        private function updatePage():void
        {
            _currentPage = _listSceneSet[_currentTabIndex].page;
            _currentPageNum = _listSceneSet[_currentTabIndex].pageNum;
            if(_currentPageNum > 1 &&_currentPage > 0 && _currentPageNum > _currentPage && _currentPage+1 < _currentPageNum)
            {
                _bg.back.visible =true;
                _bg.next.visible =true;

            }else if (_currentPageNum > 1 && _currentPage+1 == _currentPageNum){
                _bg.back.visible =true;
                _bg.next.visible =false;
            }else if (_currentPageNum > 1 && _currentPage < _currentPageNum){
                _bg.back.visible =false;
                _bg.next.visible =true;
            }else{
                _bg.back.visible =false;
                _bg.next.visible =false;

            }

            if (_bg.isCharaPage(_currentTabIndex)) {
                if (_bg.isCharaPageReborn) {
                    _charaPageSelBtn.btnVisible(true,false);
                } else {
                    _charaPageSelBtn.btnVisible(false,true);
                }
            } else {
                _charaPageSelBtn.btnVisible(false,false);
            }
        }

        private function nextClickAction():void
        {
            _listSceneSet[_currentTabIndex].setPage(_currentPage+1);
            updatePage()
        }
        private function backClickAction():void
        {
            _listSceneSet[_currentTabIndex].setPage(_currentPage-1);
            updatePage()
        }

        private function ulCardBtnClickHandler(e:MouseEvent):void
        {
            if (_bg.isCharaPage(_currentTabIndex)) {
                _bg.charaCardRebornMode = false;
            }
        }
        private function rbCardBtnClickHandler(e:MouseEvent):void
        {
            if (_bg.isCharaPage(_currentTabIndex)) {
                _bg.charaCardRebornMode = true;
            }
        }
        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _container.mouseEnabled = false;
            _container.mouseChildren = false;
            _player.state = Player.STATE_LOBBY;
            log.writeLog(log.LV_INFO, this, "push exit");
        }

        private function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
//            log.writeLog(log.LV_INFO, this, "hide start");
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            next(hide2);
//            log.writeLog(log.LV_INFO, this, "hide endt");
        }

        // 配置オブジェの表示
        private function hide2():void
        {
//            log.writeLog(log.LV_INFO, this, "hide2 start");
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getHideThread());
            pExec.addThread(new BeTweenAS3Thread(_dataArea, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            next(hide3);
//            log.writeLog(log.LV_INFO, this, "hide2 endt");
        }

        // 配置オブジェの表示
        private function hide3():void
        {
            // イベントの消去
            _charaCardListScene.removeEventListener(EditCardEvent.SELECT_CARD, _dataArea.selectListCardHandler);
            _monsCardListScene.removeEventListener(EditCardEvent.SELECT_CARD, _dataArea.selectListCardHandler);
            _rebornCharaCardListScene.removeEventListener(EditCardEvent.SELECT_CARD, _dataArea.selectListCardHandler);

            _charaPageSelBtn.ulCardBtn.removeEventListener(MouseEvent.CLICK,ulCardBtnClickHandler);
            _charaPageSelBtn.rbCardBtn.removeEventListener(MouseEvent.CLICK,rbCardBtnClickHandler);

            // レイドヘルプイベント
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

//            log.writeLog(log.LV_INFO, this, "hide3 start");
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(_bg.getHideThread());           // 背景
            pExec.addThread(_dataArea.getHideThread());   // データ
            pExec.addThread(_charaCardListScene.getHideThread());   // データ
            pExec.addThread(_monsCardListScene.getHideThread());   // データ
            pExec.addThread(_rebornCharaCardListScene.getHideThread());   // データ

            pExec.start();
            pExec.join();
//            log.writeLog(log.LV_INFO, this, "hide3 endt");

            next(exit);
        }

        private function exit():void
        {
//            log.writeLog(log.LV_INFO, this, "exit start");

//            log.writeLog(log.LV_INFO, this, "edit exit");
        }

        // 終了関数
        override protected function finalize():void
        {
            _stage.removeChild(_title);
            _stage.removeChild(_titleJ);
            _stage.removeChild(_container);
            RemoveChild.all(_container);
            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            log.writeLog (log.LV_WARN,this,"library end");
            _bg = null;

        }


   }

}
