package view.scene.item
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
    import view.*;
    import view.scene.common.*;

    import controller.*;

    /**
     * WindowItemListPanelの表示クラス
     *
     */

    public class WindowItemListPanel extends BaseItemListPanel
    {
        // アイテムパネル
        private var _windoWitemInventoryPanelImage:WindowItemInventoryPanelImage = new WindowItemInventoryPanelImage();




        // アイテムリストのモード設定
//         public static const MODE_USE:int = 0;  // アイテム使用モード
//         public static const MODE_SHOP:int = 1;  // アイテム購入モード

        // 位置定数
        public static const _ITEM_LIST_X:int = 152;
        public static const _ITEM_LIST_Y:int = 56;

        private var _initialized:Boolean = false;
        // ゲームコントローラー
        private var _gameCtrl:DuelCtrl = GameCtrl.instance;
        // クエストコントローラーm
        private var _questCtrl:QuestCtrl = QuestCtrl.instance;
        // レイドコントローラー
        private var _raidDataCtrl:RaidDataCtrl = RaidDataCtrl.instance;

        /**
         * コンストラクタ
         *
         */
        // public function WindowItemListPanel(type:int = AvatarItem.ITEM_DUEL)
        public function WindowItemListPanel(type:int = 2)
        {
            _selectTabIndex = type;
            super();
        }

        protected override function panelImageInit():void
        {
        }

        protected override function get itemInventoryPanelImage():BasePanelImage
        {
            return _windoWitemInventoryPanelImage;
        }


//         protected override function get ctrl():BaseCtrl
//         {
//             return _gameCtrl;
//         }

        override public function init():void
        {
            super.init();
//            selectTabHandler(new SelectTabEvent(SelectTabEvent.TAB_CHANGE, _selectTabIndex))
            _itemList[_selectTabIndex].visible = true;
            checkButtonEnable();
        }

        protected override function createTileList(tl:ItemTileList):void
        {
                    _itemList.push(tl);
                    tl.x = _ITEM_LIST_X;
                    tl.y = _ITEM_LIST_Y;
                    tl.itemWidth = 48;
                    tl.itemHeight= 48;
                    tl.columnCount = 1;
                    tl.rawCount = 6;
                    tl.setPagePositon(4,286);
//                     tl.width = 48;
//                     tl.height = 285;
//                    tl.setItemInventoryData(_dpList[i]);
                    tl.visible = false;

                    _container.addChild(tl);

        }
        protected override function textLabelInit():void
        {

            // 選択中のアイテムの名前
            _selectItemName.x = 10;
            _selectItemName.y = 5;
            _selectItemName.width = 200;
            _selectItemName.height = 30;
            _selectItemName.styleName = "ItemListItemName";
            _selectItemName.mouseEnabled = false;
            _selectItemName.mouseChildren = false;
            _container.addChild(_selectItemName);

            // 選択中のアイテムの説明
            _selectItemCount.x = 5;
            _selectItemCount.y = 154;
            _selectItemCount.width = 135;
            _selectItemCount.height = 30;
            _selectItemCount.styleName = "ItemListNumeric";
            _container.addChild(_selectItemCount);
            // 選択中のアイテムの効果時間
            _selectItemTime.x = 5;
            _selectItemTime.y = 189;
            _selectItemTime.width = 135;
            _selectItemTime.height = 30;
            _selectItemTime.styleName = "ItemListNumeric";
            _container.addChild(_selectItemTime);
            // 選択中のアイテムの説明
            _selectItemCaption.x = 5;
            _selectItemCaption.y = 227;
            _selectItemCaption.width = 130;
            _selectItemCaption.height = 100;
            _selectItemCaption.styleName = "ItemListCaption";
            _container.addChild(_selectItemCaption);

        }


        protected override function createSelectItemImage():void
        {
            // 選択中のアイテムのイメージ
            _selectImage = new AvatarItemImage(_selectItem.avatarItem.image, _selectItem.avatarItem.imageFrame);
            _selectImage.x = 73;
            _selectImage.y = 86;
            _selectImage.scaleX = _selectImage.scaleY = 0.7;
            _container.addChild(_selectImage);

            _selectItemName.text = _selectItem.avatarItem.name;
            _selectItemCount.text = _selectItem.count.toString();
            _selectItemTime.text = "-";
            _selectItemTiming.text = "-";
            _selectItemCaption.text = _selectItem.avatarItem.caption;

            itemInventoryPanelImage.onUse();

        }




        // DicにAvatarItemを格納
        protected  override function setItem(item:*):void
        {
            if (_itemDic[item] == null)
            {
                _itemDic[item] = new WindowItemInventoryClip(item);
            }
        }
        // 別のリストにアイテムを追加
        protected override function setItemAnotherList(type:int,item:AvatarItem,invData:ItemInventoryClipData,setItemList:Boolean=false):void
        {
            var clip:WindowItemInventoryClip = new WindowItemInventoryClip(item,invData);
            _dpList[type].push(clip);
            if (setItemList) {_itemList[getItemTypeIdx(type)].addItem(clip);};
        }

        // アイテムが使われた時のハンドラ
        protected override function useItemHandler(e:Event):void
        {
//             log.writeLog(log.LV_INFO, this, "use item ID ", dp.getItemAt(targetIndex).id);

            switch(_selectItem.avatarItem.type)
            {
            case AvatarItem.ITEM_BASIS:
                _lobbyCtrl.sendItem(AvatarItemInventory.getInventory(_selectItem.avatarItem.id));
                break;
            case AvatarItem.ITEM_AUTO_PLAY:
                _questCtrl.sendItem(AvatarItemInventory.getInventory(_selectItem.avatarItem.id));
                break;
            case AvatarItem.ITEM_DUEL:
                _gameCtrl.sendItem(AvatarItemInventory.getInventory(_selectItem.avatarItem.id));
                break;
            case AvatarItem.ITEM_SPECIAL:
//                GameCtrl.instance.sendItem(AvatarItemInventory.getInventory(dp.getItemAt(targetIndex).id));
//                break;
            case AvatarItem.ITEM_RAID:
                _raidDataCtrl.sendItem(AvatarItemInventory.getInventory(_selectItem.avatarItem.id));
                break;
            default:
                break;
            }
        }
        public function updatePageButton():void
        {
            checkButtonEnable();
        }

        public function  setCloseHandler(handler:Function):void
        {
            _windoWitemInventoryPanelImage.setCloseHandler(handler);
        }

        public function closeHandler(e:MouseEvent):void
        {
            _windoWitemInventoryPanelImage.closeClickHandler(e);
            // if (_closeFunc !=null)
            // {
            //     _closeFunc();
            // }

        }

        public function setSelectTabIndex( index:int ):void
        {
            _selectTabIndex = index;
            selectTabHandler(new SelectTabEvent(SelectTabEvent.TAB_CHANGE, index));
        }

    }

}
