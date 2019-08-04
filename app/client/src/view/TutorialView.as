package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import flash.filters.GlowFilter;

    import mx.core.UIComponent;
    import mx.core.MovieClipLoaderAsset;
    import mx.containers.*;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Player;
    import model.events.*;

    import view.image.tutorial.*;
    import view.scene.common.*;
    import view.utils.*;

    import controller.LobbyCtrl;
    import controller.GlobalChatCtrl;

    import net.server.LobbyServer;

    /**
     * Option画面のビュークラス
     *
     */

    public class TutorialView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_TITLE	:String = "チュートリアル";

        CONFIG::LOCALE_EN
        private static const _TRANS_TITLE	:String = "Tutorial";

        CONFIG::LOCALE_TCN
        private static const _TRANS_TITLE	:String = "遊戲教學";

        CONFIG::LOCALE_SCN
        private static const _TRANS_TITLE	:String = "教学";

        CONFIG::LOCALE_KR
        private static const _TRANS_TITLE	:String = "튜토리얼";

        CONFIG::LOCALE_FR
        private static const _TRANS_TITLE	:String = "Tutoriaux";

        CONFIG::LOCALE_ID
        private static const _TRANS_TITLE	:String = "チュートリアル";

        CONFIG::LOCALE_TH
        private static const _TRANS_TITLE   :String = "Tutorial";


        // 親ステージ
        private var _stage:Sprite;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        // デフォルトで表示させるBG
        private var _bg:BG = new BG();
        // チュートリアルswf
        private var _startMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_START);
        private var _startQuestMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_START_QUEST);
        private var _startBattleMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_START_BATTLE);
        private var _startEndMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_START_END);

        private var _battleMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_BATTLE);
        private var _changeMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_CHANGE);
        private var _bonusMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_HILOW);
        private var _eventMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_EVENT);

        private var _entranceMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_ENTRANCE);
        private var _questMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_QUEST);
        private var _deckMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_DECK);
        private var _duelMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_DUEL);
        private var _itemMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_ITEM);
        private var _shopMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_SHOP);
        private var _compoMovie:TutorialMovie = new TutorialMovie(TutorialMovie.TYPE_COMPO);


        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // アバタービュー
        private var _avatarView:AvatarView;

        // レジストからきたか
        private var _regist:Boolean = true;

        // 現在のビューの番号
        private var _selectType:int = 0;

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 100;
        private const _TITLE_HEIGHT:int = 40;
        private var _player:Player = Player.instance;

        // ビューの定数
        private static const _REGIST:int = -1;
        private static const _DEFAULT:int = 0;
        private static const _OUTLINE:int = 1;
        private static const _BATTLE:int = 2;
        private static const _CHANGE:int = 3;
        private static const _HILOW:int = 4;
        private static const _BONUS:int = 5;
        private static const _EVENT:int = 6;
        private static const _ENTRANCE:int = 7;
        private static const _AVATAR:int = 8;
        private static const _QUEST:int = 9;
        private static const _EDIT:int = 10;
        private static const _MATCH:int = 11;
        private static const _ITEM:int = 12;
        private static const _SHOP:int = 13;
        private static const _COMPO:int = 14;


        /**
         * コンストラクタ
         * @param stage 親ステージ
         */
        public function TutorialView(stage:Sprite, regist:Boolean = false)
        {
            _stage = stage;
            _container.addChild(_bg);

            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_MATCH);
            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);

            _regist = regist;

            RaidHelpView.instance.isUpdate = (regist) ? false:true;
        }

        // スレッドのスタート
        override protected  function run():void
        {
            // イベントの登録
            _bg.addEventListener(BG.UPDATE_SELECT, playMovieHandler);
            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            next(initStage);
        }

        // ステージにオブジェクトを追加
        private function initStage():void
        {
            _stage.addChild(_container);

            _stage.addChild(_title);
            _stage.addChild(_titleJ);

            _stage.addChild(_startMovie);
            _stage.addChild(_startQuestMovie);
            _stage.addChild(_startBattleMovie);
            _stage.addChild(_startEndMovie);

            _stage.addChild(_battleMovie);
            _stage.addChild(_changeMovie);
            _stage.addChild(_bonusMovie);
            _stage.addChild(_eventMovie);

            _stage.addChild(_entranceMovie);
            _stage.addChild(_questMovie);
            _stage.addChild(_deckMovie);
            _stage.addChild(_duelMovie);
            _stage.addChild(_itemMovie);
            _stage.addChild(_shopMovie);
            _stage.addChild(_compoMovie);

            next(initMovie);
        }

        // ムービーを初期化
        private function initMovie():void
        {
            hideMC();

            _startMovie.addEventListener(TutorialMovie.PUSH_NEXT_BUTTON, gotoRegistQuestHandler);
            _startQuestMovie.addEventListener(TutorialMovie.PUSH_NEXT_BUTTON, gotoRegistBattleHandler);
            _startBattleMovie.addEventListener(TutorialMovie.PUSH_NEXT_BUTTON, gotoRegistEndHandler);
            _startEndMovie.addEventListener(TutorialMovie.PUSH_GAME_BUTTON, exitMovieHandler);

            _battleMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _changeMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _bonusMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _eventMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);

            _entranceMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _questMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _deckMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _duelMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _itemMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _shopMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _compoMovie.addEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);

            if(_regist)
            {
                _startMovie.visible = true;
            }

            next(initTitle);
        }


        // タイトルの初期化
        private function initTitle():void
        {
            _title.x = _TITLE_X;
            _title.y = _TITLE_Y;
            _title.width = _TITLE_WIDTH;
            _title.height = _TITLE_HEIGHT;
            _title.text = "Tutorial";
            _title.styleName = "EditTitleLabel";
            _title.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _title.alpha = 0.0;

            _titleJ.x = _TITLE_X + 85;
            _titleJ.y = _TITLE_Y + 7;
            _titleJ.width = _TITLE_WIDTH;
            _titleJ.height = _TITLE_HEIGHT;
//            _titleJ.text = "チュートリアル";
            _titleJ.text = _TRANS_TITLE;
            _titleJ.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _titleJ.alpha = 0.0;

            next(show);
        }

        // 配置オブジェの表示
        private function show():void
        {
            LobbyCtrl.instance.playBGM(LobbyCtrl.BGM_ID_TUTORIAL);

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getShowThread(_container));
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:1.0}, null, 1.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:1.0}, null, 1.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            pExec.start();
            pExec.join();

            next(show2);
        }


        // 配置オブジェの表示
        private function show2():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.start();
            pExec.join();

            next(waiting);
        }

        // ループ
        private function waiting():void
        {
            if(_regist)
            {
                next(regist);
            }
            else if (_player.state == Player.STATE_LOGOUT ||_player.state == Player.STATE_LOBBY )
            {
                next(hide);
            }
            else
            {
                next(waiting);
            }

        }

        // 終了
        private function playMovieHandler(e:Event):void
        {
            switch (_bg.viewType)
            {
            case _REGIST:
                switch (_selectType)
                {
                case 0:
                    _startMovie.visible = true;
                    _startMovie.playLabel(TutorialMovie.LABEL_START);
                    break;
                case 1:
                    _startQuestMovie.visible = true;
                    _startQuestMovie.playMovie();
                    break;
                case 2:
                    _startBattleMovie.visible = true;
                    _startBattleMovie.playMovie();
                    break;
                case 3:
                    _startEndMovie.visible = true;
                    _startEndMovie.playMovie();
                    break;
                }
                break;
            case _OUTLINE:
                switch (_selectType)
                {
                case 0:
                    _startMovie.visible = true;
                    _startMovie.playLabel(TutorialMovie.LABEL_START);
                    break;
                case 1:
                    _startQuestMovie.visible = true;
                    _startQuestMovie.playMovie();
                    break;
                case 2:
                    _startBattleMovie.visible = true;
                    _startBattleMovie.playMovie();
                    break;
                case 3:
                    _startEndMovie.visible = true;
                    _startEndMovie.playMovie();
                    break;
                }
                break;
            case _BATTLE:
                _battleMovie.visible = true;
                _battleMovie.playMovie();
                break;
            case _CHANGE:
                _changeMovie.visible = true;
                _changeMovie.playMovie();
                break;
            case _HILOW:
                _bonusMovie.visible = true;
                _bonusMovie.playMovie();
                break;
            case _BONUS:
                _eventMovie.visible = true;
                _eventMovie.playLabel(TutorialMovie.LABEL_BONUS);
                break;
            case _EVENT:
                _eventMovie.visible = true;
                _eventMovie.playLabel(TutorialMovie.LABEL_EVENT);
                break;
            case _ENTRANCE:
                _entranceMovie.visible = true;
                _entranceMovie.playMovie();
                break;
            case _AVATAR:
                break;
            case _QUEST:
                _questMovie.visible = true;
                _questMovie.playMovie();
                break;
            case _EDIT:
                _deckMovie.visible = true;
                _deckMovie.playMovie();
                break;
            case _MATCH:
                _duelMovie.visible = true;
                _duelMovie.playMovie();
                break;
            case _ITEM:
                _itemMovie.visible = true;
                _itemMovie.playMovie();
                break;
            case _SHOP:
                _shopMovie.visible = true;
                _shopMovie.playMovie();
                break;
            case _COMPO:
                _compoMovie.visible = true;
                _compoMovie.playMovie();
                break;
            }
        }


        // レジストクエスト説明に移動
        private function gotoRegistQuestHandler(e:Event):void
        {
            _startMovie.visible = false;
            _selectType = 1;
            if (!_regist) {RaidHelpView.instance.isUpdate = false;}
            playMovieHandler(e);
        }

        // レジストバトル説明に移動
        private function gotoRegistBattleHandler(e:Event):void
        {
            _startQuestMovie.visible = false;
            _selectType = 2;
            if (!_regist) {RaidHelpView.instance.isUpdate = false;}
            playMovieHandler(e);
        }

        // レジストバトル説明に移動
        private function gotoRegistEndHandler(e:Event):void
        {
            _startBattleMovie.visible = false;
            _selectType = 3;
            if (!_regist) {RaidHelpView.instance.isUpdate = false;}
            playMovieHandler(e);
        }

        // チュートリアルムービーを抜ける
        private function exitMovieHandler(e:Event):void
        {
            // レジストならロビーに戻る
            if(_bg.viewType == _REGIST)
            {
                SE.playClick();
                _player.state = Player.STATE_LOBBY;
            }
            else
            {
                if (!_regist) {RaidHelpView.instance.isUpdate = true;}
                hideMC();
                _selectType = 0;
            }
        }

        // チュートリアル用MCを全て隠す
        private function hideMC():void
        {
            _startMovie.visible = false;
            _startQuestMovie.visible = false;
            _startBattleMovie.visible = false;
            _startEndMovie.visible = false;
            _entranceMovie.visible = false;
            _questMovie.visible = false;
            _battleMovie.visible = false;
            _deckMovie.visible = false;
            _duelMovie.visible = false;
            _changeMovie.visible = false;
            _bonusMovie.visible = false;
            _eventMovie.visible = false;
            _itemMovie.visible = false;
            _shopMovie.visible = false;
            _compoMovie.visible = false;
        }


        // 終了
        private function exitButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            _player.state = Player.STATE_LOBBY;
            log.writeLog(log.LV_INFO, this, "push exit");
        }

        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _player.state = Player.STATE_LOBBY;
        }

        private function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:0.0}, null, 1.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:0.0}, null, 1.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:0.0}, null, 1.0 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            next(hide2);
        }

        // 配置オブジェの表示
        private function hide2():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getHideThread());

            pExec.start();
            pExec.join();

            next(exit);
        }

        // レジスト
        private function regist():void
        {
            _regist = false;
            _bg.viewType = _REGIST;
            playMovieHandler(new Event("regist"));
            next(waiting);
        }

        private function exit():void
        {
            LobbyCtrl.instance.stopBGM();

            // イベントの消去
            _bg.removeEvent();

            // レイドヘルプイベント
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            _startMovie.removeEventListener(TutorialMovie.PUSH_NEXT_BUTTON, gotoRegistQuestHandler);
            _startQuestMovie.removeEventListener(TutorialMovie.PUSH_NEXT_BUTTON, gotoRegistBattleHandler);
            _startBattleMovie.removeEventListener(TutorialMovie.PUSH_NEXT_BUTTON, gotoRegistEndHandler);
            _startEndMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);

            _battleMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _changeMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _bonusMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _eventMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);

            _entranceMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _questMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _deckMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _duelMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _itemMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _shopMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);
            _compoMovie.removeEventListener(TutorialMovie.PUSH_EXIT_BUTTON, exitMovieHandler);

            log.writeLog(log.LV_INFO, this, "edit exit");
        }

        // 終了関数
        override protected function finalize():void
        {
            _stage.removeChild(_startMovie);
            _stage.removeChild(_startQuestMovie);
            _stage.removeChild(_startBattleMovie);
            _stage.removeChild(_startEndMovie);

            _stage.removeChild(_battleMovie);
            _stage.removeChild(_changeMovie);
            _stage.removeChild(_bonusMovie);

            _stage.removeChild(_entranceMovie);
            _stage.removeChild(_questMovie);
            _stage.removeChild(_deckMovie);
            _stage.removeChild(_duelMovie);
            _stage.removeChild(_itemMovie);
            _stage.removeChild(_shopMovie);
            _stage.removeChild(_compoMovie);

            _stage.removeChild(_title);
            _stage.removeChild(_titleJ);
            _stage.removeChild(_container);
            RemoveChild.all(_container);
            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            log.writeLog (log.LV_WARN,this,"option end");

            _bg = null;

            hideMC();
        }

   }

}
