package controller
{
    import flash.events.*;
    import flash.geom.*;

    import mx.controls.Alert;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;

    import sound.bgm.LobbyBGM;
    import sound.se.*;
    import sound.BaseSound;
    import sound.bgm.*;
    import sound.se.*;


    import net.Host;

    import model.*;
    import model.events.*;
    import view.*;
    import net.server.*;

    /**
     * クエスト画面コントロールクラス
     *
     */
    public class QuestCtrl extends DuelCtrl
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_QUEST	:String = "クエスト";
        CONFIG::LOCALE_JP
        private static const _TRANS_DECK	:String = "デッキが空です";
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT	:String = "警告";

        CONFIG::LOCALE_EN
        private static const _TRANS_QUEST	:String = "Quest";
        CONFIG::LOCALE_EN
        private static const _TRANS_DECK	:String = "The deck is empty.";
        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT	:String = "Warning";

        CONFIG::LOCALE_TCN
        private static const _TRANS_QUEST	:String = "任務";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DECK	:String = "卡組是空的";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT	:String = "警告";

        CONFIG::LOCALE_SCN
        private static const _TRANS_QUEST	:String = "任务";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DECK	:String = "卡组内无卡";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT	:String = "警告";

        CONFIG::LOCALE_KR
        private static const _TRANS_QUEST	:String = "퀘스트";
        CONFIG::LOCALE_KR
        private static const _TRANS_DECK	:String = "덱이 비어있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT	:String = "경고";

        CONFIG::LOCALE_FR
        private static const _TRANS_QUEST	:String = "Quête";
        CONFIG::LOCALE_FR
        private static const _TRANS_DECK	:String = "Votre pioche est vide.";
        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT	:String = "Attention";

        CONFIG::LOCALE_ID
        private static const _TRANS_QUEST	:String = "クエスト";
        CONFIG::LOCALE_ID
        private static const _TRANS_DECK	:String = "デッキが空です";
        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT	:String = "警告";

        CONFIG::LOCALE_TH
        private static const _TRANS_QUEST   :String = "เควส";
        CONFIG::LOCALE_TH
        private static const _TRANS_DECK    :String = "ไม่มีสำรับไพ่";
        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT   :String = "คำเตือน";



        public static const QUEST_MAP_UPDATE:String = "quest_map_update";
        public static const QUEST_LAND_UPDATE:String = "quest_land_update";
        public static const CHARA_POINT_UPDATE:String = "chara_point_update";
        public static const QUEST_INPROGRESS:String = "quest_inprogress";
        public static const QUEST_SOLVED:String = "quest_solved";
        public static const BATTLE_START:String = "battle_start";
        public static const SHOW_ITEM:String = "show_item";
        public static const QUEST_LIST_CLICK:String = "quest_list_click";

        protected static var __instance:QuestCtrl; // シングルトン保存用

        // エディットインスタンス
        private var _deckEditor:DeckEditor = DeckEditor.instance;

        private var _server:QuestServer;
        private var _view:QuestView;

        private var _bgm:LobbyBGM = new LobbyBGM();
        public static const BGM_ID_BOSS:int = 12;


        public static const WORLD_MAP:int = 0;    // ワールドマップ選択画面
        public static const QUEST_MAP:int = 1;    //
        public var _currentQuestMap:Quest;
        public var _currentQuestLand:QuestLand;
        public var _currentQuestInventory:AvatarQuestInventory;

        public var _currentCharaPoint:Point;

        private var _bgmPlaying:Boolean = false;

        // クエスト中？
        private var _progress:Boolean = false;

//        private var _duelBGM:DuelBGM = new DuelBGM();
        private var _duelBGM:DuelBGM;
        private var _matchBGM:MatchBGM = new MatchBGM();

        // 直前のマップ番号
        // 現在のマップ番号
        public var _prevMapNo:int = 0;
        public var _currentMapNo:int = 0;


        public function QuestCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
        }

        protected override function serverInitialize():void
        {
            _server = QuestServer.instance;
            init();
        }


        private static function createInstance():QuestCtrl
        {
            return new QuestCtrl(arguments.callee);
        }

        public static function get instance():QuestCtrl
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        protected override function get server():Server
        {
           return  _server;
        }

        protected override function get serverName():String
        {
//            return "クエスト";
            return _TRANS_QUEST;
        }

        public override function get stageNo():int
        {
            return _stageNo;
        }

        public override function set stageNo(no:int):void
        {
            _stageNo = no;
        }

        /**
         * クエストのスタート
         *
         */
        public override function start(view:Thread):void
        {
            // クエストサーバにつなぐ
            _server.connect();
            _view = QuestView(view); // 非常手段
            waitConnectThread.start();
        }

        // connecetWaitスレッドが使うスタートコマンド
        public override function waitStart():void
        {
            log.writeLog(log.LV_FATAL, this, "start", _server.state);
            _server.start(this);

        }

        // viewにシーケンスを追加する
        public override function addViewSequence(thread:Thread):void
        {
            _view.addSequence(thread);
        }

        // Viewにシーケンスを追加する
        CONFIG::HAND_NEW
        public override function addFoeViewSequence(thread:Thread):void
        {
            _view.addSequence(thread);
        }

        CONFIG::HAND_NEW
        // Viewの敵用シーケンスを破棄する
        public override function discardFoeViewSequence():void
        {

        }


        // 終了を待たないシーケンスとして追加する
        public  override function addNoWaitViewSequence(thread:Thread):void
        {
            _view.addSequence(new ClousureThread(function():void{thread.start();}));
        }

        // Viewを一定期間止める
        public override  function sleepViewSequence(time:int):void
        {
            addViewSequence(new SleepThread(time));
        }

        // Viewにシーケンスををとめる
        public  override function stopViewSequence():void
        {
//            _view.interrupt();
            _view.finishGame();
        }

        // サーバのコマンドを遅延評価する
        public override  function commandUpdate():Boolean
        {
            return _server.commandShift();
        }

        public function playBGM():void
        {
            if (_bgmPlaying)
            {
                return;
            }else{
                _bgm.loopSound(0);
                _bgmPlaying = true;
            }

        }

        public function get questViewDuelAvatarHideThread():Thread
        {
            return _view.duelAvatars.getHidePlayerAvatarThread();
        }

        public function get questViewDuelAvatarShowThread():Thread
        {
            return _view.duelAvatars.getShowPlayerAvatarThread();
        }

        public function getQuestViewBGExcnahgeThread(no:int):Thread
        {
            return _view.getBgExchangeThread(no);
        }


        public function stopBGM():void
        {
            _bgm.fade(0,2);
            _bgmPlaying = false;
        }

        // 使用した時
        public  override function sendItem(id:int):void
        {
            _server.csAvatarUseItem(id,_currentMapNo);
        }

        // 使用した時
        override public function buyItem(shop:int, id:int, amount:int = 1):void
        {
            _server.csAvatarBuyItem(shop,id);
        }

        // マップIDのクエストを取得
        public function getQuest(mapId:int, timer:int):void
        {
            _server.csGetQuest(mapId,timer);
        }

        // クエストを消去
        public function deleteQuest():void
        {
            _server.csQuestDelete(currentQuestInventory.inventoryID);
            currentMap = Quest.ID(0);
        }

        // クエストを送るためのウインドウを出す
        public function showPresentQuestPanel():void
        {
            FriendListView.showSendQuest();
        }

        // クエストを送るためのウインドウを出す
        public function sendQuest(avatarID:int):void
        {
            _server.csSendQuest(avatarID, currentQuestInventory.inventoryID);
            currentMap = Quest.ID(0);
            FriendListView.hide();
        }



        // クエストマップを取得
        public function getQuestMap(regionId:int):void
        {
            _server.csRequestQuestMapInfo(regionId);
        }

        // クエストマップの探索チェック
        public function questFindCheck(invId:int):void
        {
            _server.csQuestCheckFind(invId);
        }


        // 仕様に成功したとき
        public function useItemSuccess(id:int):void
        {
            dispatchEvent(new AvatarItemEvent(AvatarItemEvent.USE_ITEM, id));
        }

        // 取得に成功したとき
        public function getItemSuccess(id:int):void
        {
            dispatchEvent(new AvatarItemEvent(AvatarItemEvent.GET_ITEM, id));
        }

        // クエストの使用に成功したとき
        public function useQuestSuccess(id:int):void
        {
//            log.writeLog(log.LV_FATA, this, "use quest event ", id);
            dispatchEvent(new AvatarQuestEvent(AvatarQuestEvent.USE_QUEST, null, id));
        }

        // クエストの取得に成功したとき
        public function getQuestSuccess(aqi:AvatarQuestInventory):void
        {
            dispatchEvent(new AvatarQuestEvent(AvatarQuestEvent.GET_QUEST, aqi, aqi.id));
        }

        // ページ情報をリクエスト
        public function requestPageInfo(page:int):void
        {
            _server.csGetQuestLogPageInfo(page);
        }

        // ページ情報をリクエスト
        public function requestQuestMapInfo(region:int):void
        {
            _server.csRequestQuestMapInfo(region);
        }

        // クエストマップが更新されたとき
        public function questMapUpdate(ids:Array):void
        {
            dispatchEvent(new QuestMapEvent(QuestMapEvent.UPDATE, ids));
        }

        // ログが更新された時
        public function questLogUpdate(id:int):void
        {
            dispatchEvent(new QuestLogEvent(QuestLogEvent.UPDATE, id));
        }

        // ログが更新された時
        public function questLogPageUpdate(page:int):void
        {
            dispatchEvent(new QuestLogEvent(QuestLogEvent.PAGE_UPDATE, page));
        }

        // アバターのアップデートをチェック
        public function avatarUpdateCheck():void
        {
            _server.csAvatarUpdateCheck();
        }

        // クエストリストのクエストをクリックした
        public function questListItemClick():void
        {
            dispatchEvent(new Event(QUEST_LIST_CLICK));
        }

        // 現在表示中のマップを変更
        public function set currentMap(i:Quest):void
        {
            if (_currentQuestMap != i)
            {
                _currentQuestMap = i;
                dispatchEvent(new Event(QUEST_MAP_UPDATE));
            }
        }

        // 現在表示中のマップ
        public function get currentMap():Quest
        {
           return  _currentQuestMap;
        }

        // 現在表示中の地形を変更
        public function set currentLand(i:QuestLand):void
        {
            if (_currentQuestLand != i)
            {
                _currentQuestLand = i;
                dispatchEvent(new Event(QUEST_LAND_UPDATE));
            }
        }

        // 現在の地形を取得
        public function get currentLand():QuestLand
        {
           return  _currentQuestLand;
        }

        // 現在表示中のマップインベントリの更新
        public function set currentQuestInventory(i:AvatarQuestInventory):void
        {
            if (_currentQuestInventory != i)
            {
                _currentQuestInventory = i;
            }
        }
        // 現在の地形を取得
        public function get currentQuestInventory():AvatarQuestInventory
        {
           return  _currentQuestInventory;
        }

        // 現在地域
        public function set currentMapNo(i:int):void
        {
            _currentMapNo = i;
        }

        // 現在の地形を取得
        public function get currentMapNo():int
        {
            return  _currentMapNo;
        }

        // 直前の地域を設定
        public function set prevMapNp(i:int):void
        {
            _prevMapNo = i;
        }
        public function get prevMapNp():int
        {
            return _prevMapNo;
        }

        // クエストを確認
        public function confirmQuest(id:int):void
        {
            _server.csQuestConfirm(id,_deckEditor.selectIndex);
        }

        // クエストを開始
        public function startQuest():void
        {
            // デッキが空ならはじまらない
            if (getCharaNo() != 0)
            {
                if (_currentQuestInventory!=null)
                {
                    // ここでデッキインデックスをどっからからもらってきて正しい値を入れる
                    _server.csQuestStart(_currentQuestInventory.inventoryID, _deckEditor.selectIndex);
                }
            }else{
//                Alerter.showWithSize("デッキが空です","警告");
                Alerter.showWithSize(_TRANS_DECK,_TRANS_ALERT);
            }
        }
        // クエスト進行中
        public function startSuccess():void
        {
            _progress = true;
            currentCharaPoint = new Point(_currentQuestInventory.quest.startRow,-1);
            dispatchEvent(new Event(QUEST_INPROGRESS));
//            dispatchEvent(new Event(CHARA_POINT_UPDATE));
        }

        // キャラの位置を変更
        public function set currentCharaPoint(p:Point):void
        {
            if (_currentQuestMap !=null)
            {
                if ((_currentCharaPoint != p))
                {
                    log.writeLog(log.LV_FATAL, this, "curent point update",p);
                    _currentCharaPoint = p;
                    dispatchEvent(new Event(CHARA_POINT_UPDATE));
                }
            }
        }

        // クエストを終了
        public function quitQuest():void
        {
            // 当然進行中である
            if (progress)
            {
                if (_currentQuestInventory!=null)
                {
                    // ここでデッキインデックスをどっからからもらってきて正しい値を入れる
                    _server.csQuestAbort(_currentQuestInventory.inventoryID, _deckEditor.selectIndex);
                }
            }
        }


        // 値の初期化。抜けるときに使う
        public function questInitialize():void
        {
            _currentQuestMap = null;
            _currentQuestLand = null;
            _currentQuestInventory = null;
            _currentCharaPoint = null;
        }


        // アイテムリストを表示
        public function showItem():void
        {
            dispatchEvent(new Event(SHOW_ITEM));
        }

        public function checkRealMoneyShop(damage:int):void
        {
            // デッキのダメージが0以外のときショップアイコンを出す
            if( damage!=0)
            {
                _view.showShop();

            }else{
                RealMoneyShopView.offShopButton(RealMoneyShopView.TYPE_QUEST_DAMAGE)
            }
        }



        // 現在の地形を取得
        public function get currentCharaPoint():Point
        {
           return  _currentCharaPoint;
        }

        // 現在進行中？
        public function get progress():Boolean
        {
            return  _progress;
        }

        public function getTresure(type:int, cType:int, val:int):void
        {
            if (type !=Const.TG_NONE && type !=Const.TG_BONUS_GAME)
            {
                dispatchEvent(new QuestTreasureEvent(QuestTreasureEvent.GET,type,cType,val));
            }
        }



        // クエストを終了
        public function exitQuest(result:int):void
        {
            if (_currentQuestInventory!=null)
            {
                _progress = false;
                questInitialize();
                dispatchEvent(new Event(QUEST_SOLVED));
                dispatchEvent(new QuestFinishEvent(QuestFinishEvent.FINISH, result));
            }
        }


        // クエストを進める
        public function nextLand(point:Point):void
        {
            log.writeLog(log.LV_FATAL, this, "next land ",point,_currentCharaPoint);
            if ((_currentCharaPoint != null)&&(_currentQuestInventory!=null)&&(_currentQuestMap.checkRoadExist(_currentCharaPoint.x,_currentCharaPoint.y, point.x, point.y)))
            {
                var i:int;
                i = point.y* 3 + point.x
                _server.csQuestNextLand(_currentQuestInventory.inventoryID, _deckEditor.selectIndex, i);

            }
        }

        public function getCharaNo():int
        {
            return _deckEditor.getDeckCharaNo(_deckEditor.selectIndex);
        }


        // バトル開始
        public function battle():void
        {

                dispatchEvent(new Event(BATTLE_START));
        }


        // デバッグコードを送る
        public override function sendDebugCode(code:int):void
        {
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.csDebugCode(code);
             }
        }






















        // サーバにデュエルの準備を知らせる
        public override function startOk():void
        {
             if (_server.state == Host.CONNECT_AUTHED)
             {
                 _server.startOk();
             }
        }



        /**
         * ゲームの終了
         *
         */
        public override  function exit():void
        {
            super.exit()
            Duel.instance.abortGame();
        }


        // =================================
        // BGM制御（将来的には移すべき）
        // =================================
        public override function playDuelBGM():void
        {
            _duelBGM = new DuelBGM(stageNo);
            _duelBGM.loopSound(0);
        }

        public override function stopDuelBGM():void
        {
            _duelBGM.fade(0,2)
        }

        public override function playMatchBGM():void
        {
//            log.writeLog(log.LV_FATAL, this, "bgm?", _matchBGM);
            _matchBGM.loopSound(0);
        }

        public override function stopMatchBGM():void
        {
            _matchBGM.fade(0,2)
        }

        // コントローラからビューを取り除く
        public override function removeView():void
        {
            super.removeView();
            _view =null;
        }



    }
}