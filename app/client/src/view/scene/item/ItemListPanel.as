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
    import view.utils.*;
    import view.scene.common.*;

    import controller.LobbyCtrl;
    import controller.*;

    import view.image.common.*;

    /**
     * ItemListPanelの表示クラス
     * 
     */

    public class ItemListPanel extends BaseItemListPanel
    {
        // アイテムパネル
//        private var _itemInventoryPanelImage:ItemInventoryPanelImage = new ItemInventoryPanelImage(AvatarItem.ITEM_TYPE);


        // 使用確認パネル
        private var _useSendPanel:UseSendPanel = new UseSendPanel();

        // 位置定数
        public static const _ITEM_LIST_X:int = 24;
        public static const _ITEM_LIST_Y:int = 104;


        /**
         * コンストラクタ
         *
         */
        public function ItemListPanel()
        {
            super();

//             Unlight.GCW.watch(_itemInventoryPanelImage);
//             Unlight.GCW.watch(_itemDic);
//             Unlight.GCW.watch(_useSendPanel);
//             Unlight.GCW.watch(_container);
        }

        protected override function get itemInventoryPanelImage():BasePanelImage
        {
            return _itemInventoryPanelImage;
        }

//         protected function panelImageInit():void
//         {
//             _itemInventoryPanelImage = new ItemInventoryPanelImage(AvatarItem.ITEM_TYPE);
//         }

        // 初期化
        public override function init():void
        {
            super.init();
            _useSendPanel.visible = false;
            _useSendPanel.yesButton.addEventListener(MouseEvent.CLICK, pushUseYesHandler);
            _useSendPanel.noButton.addEventListener(MouseEvent.CLICK, pushUseNoHandler);
            addChild(_useSendPanel);
            selectTabHandler(new SelectTabEvent(SelectTabEvent.TAB_CHANGE, 0))

        }

        protected override function textLabelInit():void
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
            super.final();
            _useSendPanel.yesButton.removeEventListener(MouseEvent.CLICK, pushUseYesHandler);
            _useSendPanel.noButton.removeEventListener(MouseEvent.CLICK, pushUseNoHandler);

        }

        // アイテムが使われた
        protected override function useItemHandler(e:Event):void
        {
            SE.playClick();

            log.writeLog(log.LV_FATAL, this, "use button done");
            // 確認パネルを出す
            _useSendPanel.visible = true;
            _container.mouseChildren = false;
            _container.mouseEnabled = false;
        }

        // アイテム使用ハンドラ
        private function pushUseYesHandler(e:MouseEvent):void
        {
            SE.playClick();

            // アイテムを購入
            _useSendPanel.visible = false;
            _container.mouseChildren = true;
            _container.mouseEnabled = true;

            switch(_selectItem.avatarItem.type)
            {
            case AvatarItem.ITEM_BASIS:
                log.writeLog(log.LV_FATAL, this, "USE_ITEM",_selectItem.avatarItem.id);
                ctrl.sendItem(AvatarItemInventory.getInventory(_selectItem.avatarItem.id));
                break;
            case AvatarItem.ITEM_AUTO_PLAY:
//                _lobbyCtrl.sendItem(AvatarItemInventory.getInventory(dp.getItemAt(targetIndex).id));
//                break;
            case AvatarItem.ITEM_DUEL:
//                GameCtrl.instance.sendItem(AvatarItemInventory.getInventory(_selectItem.avatarItem.id));
                break;
            case AvatarItem.ITEM_SPECIAL:
//                GameCtrl.instance.sendItem(AvatarItemInventory.getInventory(dp.getItemAt(targetIndex).id));
//                break;
            case AvatarItem.ITEM_RAID:
            default:
                break;
            }

        }

        // アイテム購入キャンセル
        private function pushUseNoHandler(e:MouseEvent):void
        {
            SE.playClick();

            _useSendPanel.visible = false;
            _container.mouseChildren = true;
            _container.mouseEnabled = true;

        }


    }






}

