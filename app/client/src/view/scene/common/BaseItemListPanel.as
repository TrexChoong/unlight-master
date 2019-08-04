package view.scene.common
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import flash.utils.Dictionary;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.common.AvatarItemImage;
    import view.image.item.*;

    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.scene.item.*;
    import view.*;
    import view.utils.*;

    import controller.LobbyCtrl;
    import controller.*;

    import view.image.common.*;

    /**
     * BaseItemListPanelの表示クラス
     * 
     */

    public class BaseItemListPanel extends BaseScene
    {
        // 描画コンテナ
        protected var _container:UIComponent = new UIComponent();


        // アイテムのリスト
        protected var _itemList:Vector.<ItemTileList> = new Vector.<ItemTileList>();  // Array of TileList
        // 種別ごとのリスト内データ
        protected var _dpList:Array = [];

        // アバターアイテム
        protected var _itemDic:Dictionary = new Dictionary(); // Dictionary of item Key:AvatarItem

        // ロビーコントローラー
        protected var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;
        // ゲームコントローラー

        // 選択中のタブ番号
        protected var _selectTabIndex:int = 0;

        // 選択中のアイテム
        protected var _selectItem:IInventoryClip;


        // 選択中のアイテムのイメージ
        protected var _selectImage:DisplayObject;
        protected var _selectImageList:Vector.<DisplayObject> = new Vector.<DisplayObject>();
        // 選択中のアイテムの名前
        protected var _selectItemName:Label = new Label();
        // 選択中のアイテムの個数
        protected var _selectItemCount:Label = new Label();
        // 選択中のアイテムの効果時間
        protected var _selectItemTime:Label = new Label();
        // 選択中のアイテムの使用タイミング
        protected var _selectItemTiming:Label = new Label();
        // 選択中のアイテムの説明
        protected var _selectItemCaption:Text = new Text();


        // 位置定数
        public static const _ITEM_LIST_X:int = 24;
        public static const _ITEM_LIST_Y:int = 104;

        // アイテムパネル
        protected var _itemInventoryPanelImage:ItemInventoryPanelImage;


        /**
         * コンストラクタ
         *
         */
        public function BaseItemListPanel()
        {
            panelImageInit();

//             Unlight.GCW.watch(_itemInventoryPanelImage);
//             Unlight.GCW.watch(_itemDic);
//             Unlight.GCW.watch(_useSendPanel);
//             Unlight.GCW.watch(_container);
        }

        protected function panelImageInit():void
        {
            _itemInventoryPanelImage = new ItemInventoryPanelImage(AvatarItem.ITEM_TYPE);
        }

        protected function get itemInventoryPanelImage():BasePanelImage
        {
            return _itemInventoryPanelImage;
        }


        // 初期化
        public override function init():void
        {
            _container.addChild(itemInventoryPanelImage);
            addChild(_container);
            var itemNum:int = 0; // アイテムの個数

            // アイテムをソートする
            AvatarItemInventory.sortAvatarItemId();

            // データを空っぽにする
            _dpList = [];

            // データを格納するタブを作成
            for(var i:int = 0; i < AvatarItem.ITEM_TYPE.length; i++)
            {
                var dp:Array = [];
                _dpList.push(dp);
            }
            inventoryToData();


            // データを格納するタブを作成
            for(i = 0; i < tabTypes.length; i++)
            {
//                log.writeLog(log.LV_FATAL, this, "init tab create i=" ,i);
                createTileList(new ItemTileList());
            }
            for(i = 0; i < tabTypes.length; i++)
            {
//              log.writeLog(log.LV_FATAL, this, "set item inven", _itemList[i],_dpList[i]);
                _itemList[getItemTypeIdx(i)].setItemInventoryData(_dpList[i]);
//                log.writeLog(log.LV_FATAL, this, "set item inven evnd", i);
            }

//            log.writeLog(log.LV_FATAL, this, "init add event");
            // イベントを設定
            for(i = 0; i < _itemList.length; i++)
            {
                _itemList[i].addEventListener(SelectItemEvent.ITEM_CHANGE, selectItemHandler);
            }


            textLabelInit();

            itemInventoryPanelImage.addEventListener(SelectTabEvent.TAB_CHANGE, selectTabHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.USE_ITEM, useItemHandler);

            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.PAGE_FIRST, pageFirstHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.PAGE_END, pageEndHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.PAGE_NEXT, pageNextHandler);
            itemInventoryPanelImage.addEventListener(ItemInventoryPanelImage.PAGE_BACK, pageBackHandler);



            ctrl.addEventListener(AvatarItemEvent.USE_ITEM, useItemSuccessHandler);
            ctrl.addEventListener(AvatarItemEvent.GET_ITEM, getItemSuccessHandler);
//             controller.addEventListener(AvatarItemEvent.USE_ITEM, useItemSuccessHandler);
//             controller.addEventListener(AvatarItemEvent.GET_ITEM, getItemSuccessHandler);

//              GameCtrl.instance.addEventListener(AvatarItemEvent.USE_ITEM, useItemSuccessHandler);
//              GameCtrl.instance.addEventListener(AvatarItemEvent.GET_ITEM, getItemSuccessHandler);

//            selectTabHandler(new SelectTabEvent(SelectTabEvent.TAB_CHANGE, 0))
        }

        protected function GCW():void
        {
//             Unlight.GCW.watch(_container);
//             Unlight.GCW.watch(_itemList);
//             Unlight.GCW.watch(_dpList);
//             Unlight.GCW.watch(_itemDic);
//            Unlight.GCW.watch(_selectItem);
//             Unlight.GCW.watch(_selectImage);

//             Unlight.GCW.watch(_selectItemName);
//             Unlight.GCW.watch(_selectItemCount);
//             Unlight.GCW.watch(_selectItemTime);
//             Unlight.GCW.watch(_selectItemTiming);
//             Unlight.GCW.watch(_selectItemCaption);
//             Unlight.GCW.watch(itemInventoryPanelImage);

        }

        protected function get tabTypes():Array
        {
            return AvatarItem.ITEM_TYPE;
        }
        protected function getItemTypeIdx(i:int):int
        {
            return AvatarItem.ITEM_TAB_LIST[i];
        }

        protected function get ctrl():BaseCtrl
        {
            return _lobbyCtrl;
        }

        protected function createTileList(tl:ItemTileList):void
        {
            _itemList.push(tl);
            tl.x = _ITEM_LIST_X;
            tl.y = _ITEM_LIST_Y;
            tl.itemWidth = 95;
            tl.itemHeight= 95;
            tl.columnCount = 5;
            tl.rawCount = 3;
            tl.visible = false;
            _container.addChild(tl);
//            log.writeLog(log.LV_FATAL, this, "createTileList ");
        }
        protected function textLabelInit():void
        {
            
            // 選択中のアイテムの名前
            _selectItemName.x = 106;
            _selectItemName.y = 424;
            _selectItemName.width = 200;
            _selectItemName.height = 30;
            _selectItemName.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemName);
            // 選択中のアイテムの説明
            _selectItemCount.x = -10;
            _selectItemCount.y = 526;
            _selectItemCount.width = 135;
            _selectItemCount.height = 30;
            _selectItemCount.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemCount);
            // 選択中のアイテムの効果時間
            _selectItemTime.x = -10;
            _selectItemTime.y = 462;
            _selectItemTime.width = 135;
            _selectItemTime.height = 30;
            _selectItemTime.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemTime);
            // 選択中のアイテムの使用場所
            _selectItemTiming.x = -10;
            _selectItemTiming.y = 494;
            _selectItemTiming.width = 135;
            _selectItemTiming.height = 30;
            _selectItemTiming.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemTiming);
            // 選択中のアイテムの説明
            _selectItemCaption.x = 145;
            _selectItemCaption.y = 463;
            _selectItemCaption.width = 165;
            _selectItemCaption.height = 100;
            _selectItemCaption.styleName = "ItemListNumericLeft";
            _container.addChild(_selectItemCaption);

        }



        // 後処理
        public override function final():void
        {
            if (!_finished)
            {
                ctrl.removeEventListener(AvatarItemEvent.USE_ITEM, useItemSuccessHandler);
                ctrl.removeEventListener(AvatarItemEvent.GET_ITEM, getItemSuccessHandler);
                resetSelectItem();
                // データを格納するタブの削除
                for(var i:int = 0; i < tabTypes.length; i++)
                {
                    if (_itemList !=null && _itemList.length > 0 )
                    {
                        _itemList[i].removeEventListener(SelectItemEvent.ITEM_CHANGE, selectItemHandler);
                        RemoveChild.apply(_itemList[i]);
                    }
                    if (_dpList != null)
                    {
                        _dpList[i] = null;
                    }
                }

                itemInventoryPanelImage.removeEventListener(SelectTabEvent.TAB_CHANGE, selectTabHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.USE_ITEM, useItemHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.REMOVE_PART, removePartHandler);

                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.PAGE_FIRST, pageFirstHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.PAGE_END, pageEndHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.PAGE_NEXT, pageNextHandler);
                itemInventoryPanelImage.removeEventListener(ItemInventoryPanelImage.PAGE_BACK, pageBackHandler);


                RemoveChild.all(_container);

                RemoveChild.apply(_container);

                for (var key:Object in _itemDic) {
                    _itemDic[key].getHideThread().start();
                    delete  _itemDic[key];
                }


                itemInventoryPanelImage.final();
                RemoveChild.apply(itemInventoryPanelImage);
                _itemDic = null;
                _itemList  =null;
                _dpList = null;
                _selectItem = null;
                super.final();
            }
        }

        // インベントリからデータを生成する
        protected function inventoryToData():void
        {
            var i:int;
            var itemNum:int = 0; // アイテムの個数
            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < AvatarItemInventory.items.length; i++)
            {
                var avatarItem:AvatarItem = AvatarItemInventory.items[i].avatarItem;
                // アイテムのイメージを作成
                setItem(avatarItem);
                // アイテムの個数をインクリメント
                _itemDic[avatarItem].count += 1;
                // 次が違うアイテムなら個数と共に表示
                if(AvatarItemInventory.items[i+1] == null || avatarItem != AvatarItemInventory.items[i+1].avatarItem)
                {
//                    _dpList[avatarItem.type].push( {itemInventoryClip:_itemDic[avatarItem]} );


//                    _dpList[avatarItem.type].push(_itemDic[avatarItem]);
                    var dpType:int;
                    switch (avatarItem.type) {
                    case AvatarItem.ITEM_RESULT:
                        dpType = AvatarItem.ITEM_SPECIAL;
                        break;
                    default:
                        dpType = avatarItem.type;
                    }
                    _dpList[dpType].push(_itemDic[avatarItem]);


                    // 別ウィンドウにも表示する場合、追加する
                    for (var x:int = 0; x < avatarItem.subTypes.length; x++) {
                        setItemAnotherList(avatarItem.subTypes[x],avatarItem,_itemDic[avatarItem].inventoryData);
                    }
                }
            }
        }

        // アイテムが選択されたときのハンドラ
        protected function selectItemHandler(e:SelectItemEvent):void
        {
            SE.playClick();

            // アイテムの選択状態の初期化と設定
            e.item.onSelect();

            _selectItem = e.item;
            log.writeLog(log.LV_INFO, this, "item id", _selectItem);

            if(_selectImage != null)
            {
                RemoveChild.apply(_selectImage);
                _selectImage = null;
            }
            createSelectItemImage();
//            Unlight.GCW.watch(_selectImage);
        }

        protected function createSelectItemImage():void
        {
            // 選択中のアイテムのイメージ
            _selectImage = new AvatarItemImage(_selectItem.avatarItem.image, _selectItem.avatarItem.imageFrame);
            _selectImage.x = 384;
            _selectImage.y = 480;
            _selectImage.scaleX = _selectImage.scaleY = 1.0;
            _container.addChild(_selectImage);

            _selectItemName.text = _selectItem.avatarItem.name;
            _selectItemCount.text = _selectItem.count.toString();
            _selectItemTime.text = "-";
            _selectItemTiming.text = "-";
            _selectItemCaption.text = _selectItem.avatarItem.caption;

            if(_selectItem.avatarItem.type == AvatarItem.ITEM_BASIS)
            {
                itemInventoryPanelImage.onUse();
            }
        }

        protected function resetSelectItem():void
        {
            if(_selectImage != null)
            {
                RemoveChild.apply(_selectImage);
                _selectImage = null;
                _selectItemName.text = "";
                _selectItemCount.text = "";
                _selectItemTime.text = "";
                _selectItemTiming.text = "";
                _selectItemCaption.text = "";
            }

        }


        // タブが選択されたときのハンドラ
        protected function selectTabHandler(e:SelectTabEvent):void
        {
//            log.writeLog(log.LV_INFO, this, "select tab index",e.index,_itemList.length);
            _selectTabIndex = e.index;

            if(_itemList.length > 0)
            {
                _itemList[_selectTabIndex].unselectPage();
                for(var i:int = 0; i < _itemList.length; i++)
                {
                    _itemList[i].visible = false;
                }
                _itemList[_selectTabIndex].visible = true;
            }
            resetSelectItem();
            checkButtonEnable()
            itemInventoryPanelImage.offUse();
            itemInventoryPanelImage.offRemove();
        }



        // DicにAvatarItemを格納
        protected function setItem(item:*):void
        {
            if (_itemDic[item] == null)
            {
                _itemDic[item] = new ItemInventoryClip(item);
//                Unlight.GCW.watch(_itemDic[item]);
            }
        }
        // 別のリストにアイテムを追加
        protected function setItemAnotherList(type:int,item:AvatarItem,invData:ItemInventoryClipData,setItemList:Boolean=false):void
        {
            // 継承したほかのクラスで実行
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // アイテムがかわれた時のハンドラ
        protected function useItemHandler(e:Event):void
        {
        }

        protected function removePartHandler(e:Event):void
        {
        }

        // アイテム購入キャンセル
        private function pushUseNoHandler(e:MouseEvent):void
        {

        }

        // アイテム使用に成功した時のイベント
        protected function useItemSuccessHandler(e:AvatarItemEvent):void
        {
            log.writeLog(log.LV_WARN, this, "ITEM USE SUCCESS 1");
            log.writeLog(log.LV_WARN, this, "ITEM USE SUCCESS 1",e);
            log.writeLog(log.LV_WARN, this, "ITEM USE SUCCESS 1",e.id);
            var item:AvatarItem = AvatarItem.ID(e.id);
            useItemSuccessFunc(e.id,item.type);
            // subTypeがあれば、そちらの対応
            for (var i:int=0; i<item.subTypes.length; i++)  {
                useItemSuccessFunc(e.id,item.subTypes[i],true);
            }
        }
        protected function useItemSuccessFunc(id:int,type:int,isAnoter:Boolean=false):void
        {
            var dp:Array = _dpList[type] as Array;
            var deleteIndex:int = -1; 
            log.writeLog(log.LV_WARN, this, "ITEM USE SUCCESS 2");
            log.writeLog(log.LV_WARN, this, "ITEM USE SUCCESS 2.5",dp);
            if (dp != null)
            {
                for(var i:int = 0; i < dp.length; i++)
                {
                    log.writeLog(log.LV_WARN, this, "ITEM USE SUCCESS 3",i);
                    if(dp[i].avatarItem != null && dp[i].avatarItem.id == id)
                    {
                        dp[i].count -= 1;
                        // アイテムを減算した後、0個なら消去する
                        if(dp[i].count <= 0)
                        {
                            log.writeLog(log.LV_WARN, this, "ITEM USE SUCCESS 4",i);
                            _itemList[getItemTypeIdx(type)].removeItemAt(i);
                            resetSelectItem();
                            // 使用できないようにする
                            itemInventoryPanelImage.offUse();
                            itemInventoryPanelImage.offRemove();
                            deleteIndex  = i;
                        }
                        else
                        {
                            _selectItemCount.text = dp[i].count;
                        }
                        if (deleteIndex > -1)
                        {
                            dp.splice(deleteIndex,1);
                        }
                        break;
                    }
                }
            }
        }

        // アイテム購入に成功した時のイベント
        protected function getItemSuccessHandler(e:AvatarItemEvent):void
        {
            // log.writeLog(log.LV_INFO, this, "*** e", e);
            // log.writeLog(log.LV_INFO, this, "*** e.id", e.id);
            // log.writeLog(log.LV_INFO, this, "*** AI", AvatarItem.ID(e.id));
            // log.writeLog(log.LV_INFO, this, "*** type", AvatarItem.ID(e.id).type);
            // log.writeLog(log.LV_INFO, this, "*** dpList", _dpList);
            // log.writeLog(log.LV_INFO, this, "*** dp", _dpList[AvatarItem.ID(e.id).type]);
            log.writeLog(log.LV_FATAL, this, "success item ge ttt++++++++++++++ 1");
            var dp:Array = _dpList[AvatarItem.ID(e.id).type] as Array;
            var ai:AvatarItem = AvatarItem.ID(e.id);
            var d:Boolean = false;
            var i:int;
            var x:int;
            if (!dp)
            {
                return;
            }
            log.writeLog(log.LV_DEBUG, this, "success item ge ttt++++++++++++++ 2" ,dp.length);
            for( i = 0; i < dp.length; i++)
            {
                if(dp[i].avatarItem.id == e.id)
                {
                    dp[i].count += 1;
                    if (dp[i].count >1) // 1個目でここに来る場合は消えているのでフラグはそのまま
                    {
                        d = true;
                    }
                }
            }
            log.writeLog(log.LV_DEBUG, this, "success item ge ttt++++++++++++++ 3",d);
            // すでにあるもので無いものが手に入ったとき
            if (!d)
            {
                log.writeLog(log.LV_DEBUG, this, "success item ge ttt++++++++++++++ 4",d);
                setItem(ai);
                // アイテムの個数をインクリメント
                _itemDic[ai].count += 1;
                _dpList[ai.type].push(_itemDic[ai]);
                _itemList[getItemTypeIdx(ai.type)].addItem(_itemDic[ai]);

                // 別ウィンドウにも表示する場合、追加する
                for ( x = 0; x < ai.subTypes.length; x++) {
                    setItemAnotherList(ai.subTypes[x],ai,_itemDic[ai].inventoryData,true);
                }
            } else {
                // 所持していて、サブ種類があるならそちらも加算
                for ( x = 0; x < ai.subTypes.length; x++) {
                    dp = _dpList[ai.subTypes[x]] as Array;
                    for( i = 0; i < dp.length; i++)
                    {
                        if(dp[i].avatarItem.id == e.id)
                        {
                            dp[i].count += 1;
                        }
                    }
                }
            }


         }


        protected function pageFirstHandler(e:Event):void
        {
            _itemList[_selectTabIndex].firstPage();
            checkButtonEnable()
        }

        protected function pageEndHandler(e:Event):void
        {
            _itemList[_selectTabIndex].endPage();
            checkButtonEnable()
        }

        protected function pageNextHandler(e:Event):void
        {
            _itemList[_selectTabIndex].nextPage();
            checkButtonEnable()
        }

        protected  function pageBackHandler(e:Event):void
        {
            _itemList[_selectTabIndex].backPage();
            checkButtonEnable()
        }


        protected function checkButtonEnable():void
        {
//            SE.playClick();
            log.writeLog(log.LV_FATAL, this, "++++++++++++ chekc button enable",_itemList[_selectTabIndex].isNextButtonExist());
            itemInventoryPanelImage.nextButtonsEnable(_itemList[_selectTabIndex].isNextButtonExist());
            itemInventoryPanelImage.backButtonsEnable(_itemList[_selectTabIndex].isBackButtonExist());
        }

        protected function resetList():void
        {
            var i:int = 0;
            // 一度削除する
            resetSelectItem();
            for( i = 0; i < tabTypes.length; i++)
            {
                if (_itemList !=null)
                {
                    _itemList[i].removeEventListener(SelectItemEvent.ITEM_CHANGE, selectItemHandler);
                    RemoveChild.apply(_itemList[i]);
                }
                if (_dpList != null)
                {
                    _dpList[i] = null;
                }
            }
            _itemDic = new Dictionary();
            _itemList = new Vector.<ItemTileList>();
            _dpList = null;
            _selectItem = null;

            // データを空っぽにする
            _dpList = [];

            // データを格納するタブを作成
            for( i = 0; i < AvatarItem.ITEM_TYPE.length; i++)
            {
                var dp:Array = [];
                _dpList.push(dp);
            }
            inventoryToData();

            // データを格納するタブを作成
            for(i = 0; i < tabTypes.length; i++)
            {
                createTileList(new ItemTileList());

                _itemList[i].setItemInventoryData(_dpList[i]);
            }

            // イベントを設定
            for(i = 0; i < _itemList.length; i++)
            {
                _itemList[i].addEventListener(SelectItemEvent.ITEM_CHANGE, selectItemHandler);
            }

            // 再表示
            if(_itemList.length > 0)
            {
                _itemList[_selectTabIndex].unselectPage();
                for( i = 0; i < _itemList.length; i++)
                {
                    _itemList[i].visible = false;
                }
                _itemList[_selectTabIndex].visible = true;
            }
            resetSelectItem();
            checkButtonEnable()
            itemInventoryPanelImage.offUse();
            itemInventoryPanelImage.offRemove();
        }



    }






}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.BaseModel;

import view.BaseShowThread;
import view.IViewThread;
import view.scene.common.AvatarClip;

class ShowThread extends BaseShowThread
{
    public function ShowThread(view:IViewThread, stage:DisplayObjectContainer, at:int)
    {
        super(view, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}