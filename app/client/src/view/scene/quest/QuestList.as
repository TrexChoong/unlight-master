package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;
    import flash.filters.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.*;
    import view.scene.BaseScene;
    import view.utils.*;

    import controller.QuestCtrl;


    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class QuestList extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "現在開始可能なクエストのリストです";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "List of quests you can begin.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "現在可以開始的任務一覽。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "现在可开始的任务列表。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "현재 개시 가능한 퀘스트 리스트 입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Quête que vous pouvez commencer";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "現在開始可能なクエストのリストです";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "รายชื่อเควสที่สามารถทำได้ตอนนี้";


        private static const _PAGE_MAX:int = 10;

        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private static const _LIST_X:int = -72;                         // カードのX基本位置
        private static const _LIST_Y:int = 20;                          // カードのY基本位置
        private var _listImage:QuestListImage = new QuestListImage();

        private var _ct:ColorTransform = new ColorTransform(0.4,0.4,0.4);// トーンを半分に
        private var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーンを半分に

//        private var _itemList:Vector.<QuestItem> = new Vector.<QuestItem>();
        private var _itemListContainerSet:Array = [];
        private var _itemDic:Dictionary = new Dictionary();

        private var _currentPage:int = 0;
        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        private var _pageNo:Label = new Label();
        private var _APLabel:Label = new Label();


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["現在開始可能なクエストのリストです"],
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
        public function QuestList()
        {
            _APLabel.width = 50;
            _APLabel.height = 50;
            _APLabel.text = "0/0";
            _APLabel.styleName = "GetSendPanelLabel";
            _APLabel.filters = [new GlowFilter(0x000000, 0.7, 2, 2, 2, 1),];
            _APLabel.x = 710;
            _APLabel.y = 210;
            _APLabel.mouseEnabled = false;
            _APLabel.mouseChildren = false;

            _pageNo.x = 560;
            _pageNo.y = 210;
            _pageNo.width = 60;
            _pageNo.height = 20;
            _pageNo.styleName ="PageLabel"
//            _pageNo.text = "1";
            _pageNo.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _pageNo.mouseEnabled = false;
            _pageNo.mouseChildren = false;

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
            // RMItemShopの更新が必要であれば行う
            RealMoneyShopView.itemReset();

            // ここでハンドラを登録
            _ctrl.addEventListener(AvatarQuestEvent.GET_QUEST, getQuestSuccessHandler);
            _ctrl.addEventListener(AvatarQuestEvent.USE_QUEST, useQuestSuccessHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_INPROGRESS, questProgressHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_SOLVED, questExitHandler);
            Player.instance.avatar.addEventListener(Avatar.QUEST_MAX_UPDATE, questMaxUpdateHandler);
            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
             // 出すものをだす
            _container.addChild(_listImage);
            addChild(_container);
            addChild(_pageNo)
            _container.addChild(_APLabel);
            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);
            shopButtonCheck();
            _listImage.setButtonFunc(prevPage,nextPage);
            listInitialize();

        }

        // 後始末処理
        public override function final():void
        {
            _listImage.getHideThread().start();
            RemoveChild.apply(_container);

            listFinalize();

            // ここでハンドラを取り除く
            _ctrl.removeEventListener(AvatarQuestEvent.GET_QUEST, getQuestSuccessHandler);
            _ctrl.removeEventListener(AvatarQuestEvent.USE_QUEST, useQuestSuccessHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_INPROGRESS, questProgressHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_SOLVED, questExitHandler);
            Player.instance.avatar.removeEventListener(Avatar.QUEST_MAX_UPDATE,questMaxUpdateHandler)
            Player.instance.avatar.removeEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
        }


        // リストの初期化
        protected  function listInitialize():void
        {

            // ここでQuestInventoryからリストを作る
            AvatarQuestInventory.quests.forEach(function(item:AvatarQuestInventory, index:int, array:Array):void
                                                {
                                                    log.writeLog(log.LV_FATAL, this, "index is ",index%_PAGE_MAX);
                                                    var i:int = int(index%_PAGE_MAX)
                                                    addDic(item, i);
                                                    var page:int = int(index/_PAGE_MAX)
                                                    if (_itemListContainerSet[page] == null)
                                                    {
                                                        _itemListContainerSet[page] = new UIComponent();
                                                    }
                                                     _itemDic[item].getShowThread(_itemListContainerSet[page]).start();
                                                     _itemDic[item].setPosition(i);
//                                                    _itemDic[item].getShowThread(_container).start();
                                                });

            _itemListContainerSet.forEach(function(item:UIComponent, index:int, array:Array):void
                                 {
                                     if(index == _currentPage)
                                     {
                                         log.writeLog(log.LV_FATAL, this, "num",_container.numChildren);
                                         _container.addChild(item);
                                     }
                                     else{
                                         RemoveChild.apply(item);
                                     }
                                 });
            updateQuestNum();
        }

        private function addDic(item:AvatarQuestInventory, index:int):void
        {
            if(_itemDic[item] == null)
            {
                _itemDic[item] = new QuestItem(item,index);
            }
        }

        private function nextPage():void
        {
            log.writeLog(log.LV_FATAL, this, "next11111111111111111111111111111");
            _currentPage+=1;
            if (_currentPage>maxPage)
            {
                _currentPage = maxPage;
            }
            listInitialize();
        }

        private function prevPage():void
        {
            log.writeLog(log.LV_FATAL, this, "prevvvv");
            _currentPage-=1;
            if (_currentPage<0)
            {
                _currentPage = 0;
            }
            listInitialize();

        }

        // リストの後始末処理
        protected   function listFinalize():void
        {

            for (var key:Object in _itemDic) {
                _itemDic[key].getHideThread().start();
                delete  _itemDic[key];
            }
        }

        // クエストを取得したときのハンドラ
        public function getQuestSuccessHandler(e:AvatarQuestEvent):void
        {
            listInitialize();
//     var qi:QuestItem = new QuestItem(e.obj, AvatarQuestInventory.quests.length);
//             _itemList.push(qi);
//             qi.getShowThread(_container).start();
            updateQuestNum();
        }
        private function questMaxUpdateHandler(e:Event):void
        {
            updateQuestNum();
        }

        // セールの終了判定が出たときのハンドラ
        private function saleFinishHandler(e:AvatarSaleEvent):void
        {
            // log.writeLog (log.LV_INFO,this,"saleFinish!");
            _listImage.setViewSaleClipFlag(Player.instance.avatar.isSaleTime);
            // ショップアイテムリストの更新
            RealMoneyShopView.itemReset();
        }



        // クエストリストの数を更新
        private function updateQuestNum():void
        {
            var i:int = AvatarQuestInventory.quests.length;
            _APLabel.text = i.toString()+ "/"+ Player.instance.avatar.questMax.toString();
            if (i >= Player.instance.avatar.questMax)
            {
                _APLabel.setStyle("color", 0xFF0000);
            }else{
                _APLabel.setStyle("color", 0xFFFFFF);
            }
            if (_PAGE_MAX<i)
            {
                i = _PAGE_MAX;
            }
            shopButtonCheck();
            _listImage.setMaxLength(Player.instance.avatar.questMax);
            _listImage.setPage(_currentPage+1, maxPage+1);

            if (maxPage > 0)
            {
                _pageNo.text = (_currentPage+1).toString()+ "/"+(maxPage+1).toString();
            }else{
                _pageNo.text = "";
            }
        }

        // ショップボタンのチェック
        CONFIG::PAYMENT
        public function shopButtonCheck():void
        {
            log.writeLog(log.LV_FATAL, this, "shop button check");
//             if (AvatarQuestInventory.findingNum>1)
//             {
                // addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_QUEST));
                // addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_QUEST_PROGRESS));
            _listImage.shopButtonVisible(true);
            _listImage.setShopButtonFunc(shopSkipButtonHandler,shopGetButtonHandler,shopUsefulButtonHandler);
            _listImage.setViewSaleClipFlag(Player.instance.avatar.isSaleTime);
//             }else{
//                 RealMoneyShopView.offShopButton(RealMoneyShopView.TYPE_QUEST)
//             }
        }

        // ショップボタンのチェック
        CONFIG::NOT_PAYMENT
        public function shopButtonCheck():void
        {
            log.writeLog(log.LV_FATAL, this, "shop button check");
            _listImage.shopButtonVisible(false);
//             if (AvatarQuestInventory.findingNum>1)
//             {
//             }else{
//                 RealMoneyShopView.offShopButton(RealMoneyShopView.TYPE_QUEST)
//             }
        }

        public function shopSkipButtonHandler():void
        {
            log.writeLog(log.LV_DEBUG, this, "shop skip button handler");
            RealMoneyShopView.show(RealMoneyShopView.TYPE_QUEST);
        }
        public function shopGetButtonHandler():void
        {
            log.writeLog(log.LV_DEBUG, this, "shop get button handler");
            RealMoneyShopView.show(RealMoneyShopView.TYPE_QUEST_PROGRESS);
        }
        public function shopUsefulButtonHandler():void
        {
            log.writeLog(log.LV_DEBUG, this, "shop useful button handler");
            RealMoneyShopView.show(RealMoneyShopView.TYPE_QUEST_USEFUL);
        }

        // クエストを削除したときのハンドラ
        public function useQuestSuccessHandler(e:AvatarQuestEvent):void
        {
            for (var key:Object in _itemDic) {
                if(AvatarQuestInventory(key).inventoryID == e.id)
                {
                    _itemDic[key].getHideThread().start();
                    delete  _itemDic[key];
                }

            }
            listInitialize();
            updateQuestNum();
//             for(var i:int = 0; i < AvatarQuestInventory.quests.length; i++)
//             {
//                 log.writeLog(log.LV_INFO, this, "deleted", _itemList[i].questInv.inventoryID, e.id);
//                 if(_itemList[i].questInv.inventoryID == e.id)
//                 {
//                     log.writeLog(log.LV_INFO, this, "deleted");
//                     listFinalize();
//                     _itemList.splice(i,1);
//                     listInitialize();
//                 }
//             }

        }
            // クエスト進行中になった時のハンドラ
        public function questProgressHandler(e:Event):void
        {
            transform.colorTransform = _ct;
//            visible = false;
            mouseEnabled = false;
            mouseChildren = false;
        }
        // クエスト終了後のハンドラ
        public function questExitHandler(e:Event):void
        {
            transform.colorTransform = _ct2;
//            visible = true;
            mouseEnabled = true;
            mouseChildren = true;
        }
        private function  get maxPage():int
        {
            return int((AvatarQuestInventory.quests.length-1)/_PAGE_MAX);
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


    }
}


