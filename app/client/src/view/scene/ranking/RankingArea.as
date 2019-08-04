package view.scene.ranking
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.utils.*;
    import view.image.ranking.BG;
    import view.scene.BaseScene;

    import controller.LobbyCtrl;
    /**
     * マッチング画面のアバター表示部分のクラス
     *
     */
    public class RankingArea extends BaseScene
    {

        // アバターインスタンス
        private var _avatar:Avatar = Player.instance.avatar;

        private var _rank:Label = new Label();                        // ランク
        private var _name:Label = new Label();                     // 名前

        private const _LABEL_WIDTH:int = 200;                     // ラベルの幅
        private const _LABEL_HEIGHT:int = 32;                     // ラベルの高さ
        private var _bg:BG = new BG();

        private const _RANK_X:int = 380;                       // コメントエリアのX位置
        private const _RANK_Y:int = 450;                       // コメントエリアのY位置
        private const _NAME_X:int = 380;                       // コメントエリアのX位置
        private const _NAME_Y:int = 487;                       // コメントエリアのY位置
        private var _list:RankingList = new RankingList();


        private const VOTE_TAB_IDX:int = 4;
        private const VOTE_TAB_PAGE_MAX:int = 5;
        // 変数
        CONFIG::CHARA_VOTE_ON {
            private var _selectTab:int = 4;                      // 選択中のタブ
        }
        CONFIG::RANK_EVENT_ON  {
            private var _selectTab:int = 4;                      // 選択中のタブ
        }
        CONFIG::RANK_EVENT_OFF {
            private var _selectTab:int = 1;                      // 選択中のタブ
        }
//        private var _pageNumSet:Array = [0,0,0,0]; /* of int */ ;                      // 選択中のページ
        private var _pageNumSet:Array = [0,0,0,0,0]; /* of int */ ;                      // 選択中のページ

         // 表示コンテナ
         private var _container:UIComponent = new UIComponent();

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _MATCH_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function RankingArea()
        {
            _bg.getShowThread(this).start();
            _list.getShowThread(this).start();
            RankingData.weeklyDuel.addEventListener(RankingData.UPDATE, dataUpdateHandler);
            RankingData.totalDuel.addEventListener(RankingData.UPDATE, dataUpdateHandler);
            RankingData.weeklyQuest.addEventListener(RankingData.UPDATE, dataUpdateHandler);
            RankingData.totalQuest.addEventListener(RankingData.UPDATE, dataUpdateHandler);
            RankingData.totalCharaVote.addEventListener(RankingData.UPDATE, dataUpdateHandler);
            RankingData.totalEvent.addEventListener(RankingData.UPDATE, dataUpdateHandler);

            RankingData.weeklyDuel.addEventListener(RankingData.MY_RANK_UPDATE, dataMyRankUpdateHandler);
            RankingData.totalDuel.addEventListener(RankingData.MY_RANK_UPDATE, dataMyRankUpdateHandler);
            RankingData.weeklyQuest.addEventListener(RankingData.MY_RANK_UPDATE, dataMyRankUpdateHandler);
            RankingData.totalQuest.addEventListener(RankingData.MY_RANK_UPDATE, dataMyRankUpdateHandler);
            RankingData.totalCharaVote.addEventListener(RankingData.MY_RANK_UPDATE, dataMyRankUpdateHandler);
            RankingData.totalEvent.addEventListener(RankingData.MY_RANK_UPDATE, dataMyRankUpdateHandler);
            _bg.setPrevHandler(prevHandler);
            _bg.setNextHandler(nextHandler);
            _bg.setTabHandler(tabHandler);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
        }

        private function nextHandler():void
        {
            page += 1;
            if (page > 9)
            {
                page = 9;
            }
            CONFIG::CHARA_VOTE_ON
            {
                // 人気投票時のEventタブはpageは4まで
                if (_selectTab == VOTE_TAB_IDX && page > VOTE_TAB_PAGE_MAX)
                {
                    page = VOTE_TAB_PAGE_MAX;
                }
            }
            _list.pageChange(_selectTab, page);
            _list.updateMyRank(_selectTab);
            _bg.setPage(page);
        }

        private function prevHandler():void
        {
            page-=1;
            if (page < 0)
            {
                page = 0;
            }
            _list.pageChange(_selectTab, page);
            _list.updateMyRank(_selectTab);
            _bg.setPage(page);
        }

        private function tabHandler(i:int):void
        {
            _selectTab = i;
            CONFIG::CHARA_VOTE_ON
            {
                // 人気投票時のEventタブはpageは4まで
                if (_selectTab == VOTE_TAB_IDX && page > VOTE_TAB_PAGE_MAX)
                {
                    page = VOTE_TAB_PAGE_MAX;
                }
            }
            _list.pageChange(_selectTab, page);
            _list.updateMyRank(_selectTab);
            _bg.setPage(page);
        }

        public function update():void
        {
            CONFIG::CHARA_VOTE_ON
            {
                // 人気投票時のEventタブはpageは4まで
                if (_selectTab == VOTE_TAB_IDX && page > VOTE_TAB_PAGE_MAX)
                {
                    page = VOTE_TAB_PAGE_MAX;
                }
            }
            _list.pageChange(_selectTab, page);
            _list.updateMyRank(_selectTab);
            _bg.setPage(page);
        }

        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        // 初期化
        public override function init():void
        {
//            _avatarView.addEventListener(Avatar.ENERGY_MAX_UPDATE, _avatarView.avatarUpdateHandler);
            initilizeToolTipOwners();
            updateHelp(_MATCH_HELP);
            addChild(_container);
        }

        // 終了
        public override function final():void
        {
//            _avatarView.removeEventListener(Avatar.ENERGY_UPDATE, _avatarView.avatarUpdateHandler)
            RemoveChild.all(_container)
            RemoveChild.apply(_container);
        }

        // アバター部分の表示の初期化
        private function dataUpdateHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "update avatar ranking list!!!");
            _list.pageChange(_selectTab, page);
        }

        // アバター部分の表示の初期化
        private function dataMyRankUpdateHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "update avatar ranking list!!!");
            _list.updateMyRank(_selectTab);
//            _list.pageChange(_selectTab, page);
        }

        private function get page():int
        {
            return _pageNumSet[_selectTab];
        }
        private function set page(i:int):void
        {
           _pageNumSet[_selectTab]=i;
        }
        // アバター部分の表示の初期化

        private function updateAvatarRankHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "update avatar rank!!!");
//             // 値の設定
//             _point.text = "BattlePoint  " + _avatar.point;
//             _result.text = _avatar.win + " win  " + _avatar.lose + " lose  " + _avatar.draw + " draw";
        }

    }
}