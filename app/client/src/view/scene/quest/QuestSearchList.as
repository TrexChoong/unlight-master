package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.BaseScene;

    import controller.QuestCtrl;



    /**
     * クエストサーチリスト
     *
     */
    public class QuestSearchList extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "現在開始可能なクエストのリストです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "List of quests you can begin.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "現在可以開始的任務一覽。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "现在可开始的任务列表。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "현재 개시 가능한 퀘스트 리스트 입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Liste des Quêtes que vous pouvez commencer";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "現在開始可能なクエストのリストです。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "รายชื่อเควสที่สามารถทำได้ตอนนี้";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private static const _LIST_X:int = -72;                         // リストX基本位置
        private static const _LIST_Y:int = 20;                          // リストY基本位置
        private var _listImage:QuestSearchListImage = new QuestSearchListImage();

        private var _itemList:Vector.<QuestSearchItem> = new Vector.<QuestSearchItem>();

        // コントローラー
        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        // 選択中のクエストマップのID
        private var _selectQuestMapId:int = -1;

        // 取得確認パネル
        private var _getSendPanel:GetSendPanel = new GetSendPanel();
        private var _getResultPanel:GetResultPanel = new GetResultPanel();


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["現在開始可能なクエストのリストです。"],
                [_TRANS_MSG],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function QuestSearchList()
        {
            _container.visible =false;
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
        }



        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {
            _getSendPanel.visible = false;
            _getResultPanel.visible = false;

            // 出すものをだす
            _container.addChild(_listImage);
            addChild(_container);
            addChild(_getSendPanel);
            addChild(_getResultPanel);

            // ここでハンドラを登録
            _ctrl.addEventListener(QuestMapEvent.UPDATE, questMapUpdateHandler);
            _ctrl.addEventListener(AvatarQuestEvent.GET_QUEST, getQuestSuccessHandler);
            _listImage.closeButton.addEventListener(MouseEvent.CLICK, closeButtonHandler)

            _getSendPanel.yesButton.addEventListener(MouseEvent.CLICK, pushUseYesHandler);
            _getSendPanel.noButton.addEventListener(MouseEvent.CLICK, pushUseNoHandler);
            _getResultPanel.okButton.addEventListener(MouseEvent.CLICK, pushOkHandler);

            // マップを取得
//            _ctrl.requestQuestMapInfo(0);

            // ヘルプ
            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);
        }

        // 後始末処理
        public override function final():void
        {
            _listImage.closeButton.removeEventListener(MouseEvent.CLICK, closeButtonHandler)
            listFinalize();

            _container.RemoveChild.aplly(_listImage);
            RemoveChild.aplly(_container);
            RemoveChild.aplly(_getSendPanel);
            RemoveChild.aplly(_getResultPanel);

            // ここでハンドラを取り除く
            _ctrl.removeEventListener(QuestMapEvent.UPDATE, questMapUpdateHandler);
            _ctrl.removeEventListener(AvatarQuestEvent.GET_QUEST, getQuestSuccessHandler);
            _getResultPanel.okButton.removeEventListener(MouseEvent.CLICK, pushOkHandler);
            _getSendPanel.yesButton.removeEventListener(MouseEvent.CLICK, pushUseYesHandler);
            _getSendPanel.noButton.removeEventListener(MouseEvent.CLICK, pushUseNoHandler);
            _getSendPanel.final();

        }

        // ハンドラ
        private function questMapUpdateHandler(e:QuestMapEvent):void
        {
            _container.visible =true;
            listFinalize();
            listInitialize(e.ids);
        }


        // クエストを取得したときのハンドラ
        public function getQuestSuccessHandler(e:AvatarQuestEvent):void
        {
            log.writeLog(log.LV_INFO, this, "questName!!!",e.obj.quest , e.obj.quest.id, e.obj.quest.name, e.obj.quest.caption);
            _getResultPanel.setQuestName(e.obj.quest.name);
            _getResultPanel.visible = true;
            _container.mouseChildren = false;
            _container.mouseEnabled = false;
        }

        // クエスト取得
        private function pushOkHandler(e:MouseEvent):void
        {
//             // クエストを取得
//             _getResultPanel.visible = false;
//             _container.mouseChildren = true;
//             _container.mouseEnabled = true;
        }


        // クエスト取得
        private function pushUseYesHandler(e:MouseEvent):void
        {
//             // クエストを取得
//             _ctrl.getQuest(_selectQuestMapId);
//             _getSendPanel.visible = false;
//             _container.mouseChildren = true;
//             _container.mouseEnabled = true;
        }

        // クエスト取得
        private function pushUseNoHandler(e:MouseEvent):void
        {
            _getSendPanel.visible = false;
            _container.mouseChildren = true;
            _container.mouseEnabled = true;
        }

        // リストの初期化
        protected  function listInitialize(ids:Array):void
        {
            // ここでQuestInventoryからリストを作る
            ids.forEach(function(item:int, index:int, array:Array):void
                        {
                            _itemList.push(new QuestSearchItem(QuestMap.ID(item),index));
                            _itemList[index].addEventListener(MouseEvent.CLICK, mouseClickHandler);
                        });

            _itemList.forEach(function(item:*, index:int, array:Vector.<QuestSearchItem>):void{item.getShowThread(_container).start()});
        }

        // リストの後始末処理
        protected   function listFinalize():void
        {
            _itemList.forEach(function(item:*, index:int, array:Vector.<QuestSearchItem>):void
                              {
                                  item.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
                                  item.getHideThread().start();
                              });
            _itemList = new Vector.<QuestSearchItem>();
        }


        // マウスクリックされたときのハンドラ
        public function mouseClickHandler(e:MouseEvent):void
        {
            _selectQuestMapId = e.currentTarget.questMap.id;

            _getSendPanel.setQuestMapName(e.currentTarget.questMap.name);
            _getSendPanel.setQuestMapThumbnail(e.currentTarget.questMap.id);
            _getSendPanel.visible = true;
            _container.mouseChildren = false;
            _container.mouseEnabled = false;

            SE.playClick();
        }

        // 全体の更新
        public function update():void
        {
//             for (var key:Object in _cccDic)
//             {
//                 clipUpdate(_cccDic[key])
//             }
        }

        // リストのの更新
        protected function listUpdate():void
        {
//            new BeTweenAS3Thread(cc, {x:_CARD_X+_CARD_OFFSET_X*CharaCardInventory(cc.cardInventory).position ,y:_CARD_Y}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE).start();
        }

        // カードを消す
        protected function removeCard():void
        {
//            _deckEditor.deckToBinderCharaCard(CharaCardInventory(cc.cardInventory));
        }


        // カードを足す
        protected function addCard():void
        {
//             clipInitialize(cci);
//             addMouseEventHandler();
//             update();
        }

        private function closeButtonHandler(e:MouseEvent):void
        {
            closeList();
        }
        public function closeList():void
        {
            listFinalize();
            _container.visible =false;

        }

    }
}


