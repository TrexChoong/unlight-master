package view.scene.shop
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
    import view.image.shop.*;
    import view.image.item.*;
    import view.scene.common.*;
    import view.scene.item.PartInventoryClip;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;
    import view.utils.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ShopAcceListPanelの表示クラス
     *
     */

    public class ShopAccListPanel extends ShopBodyListPanel
    {

        // アイテムパネル
        private var _shopInventoryPanelImage:ShopInventoryPanelImage = new ShopInventoryPanelImage(AvatarPart.PARTS_ACCESSORY_TYPE);

        /**
         * コンストラクタ
         *
         */
        public function ShopAccListPanel(shopID:int =0)
        {
            super(shopID);
        }


        override protected function get tabTypes():Array
        {
            return AvatarPart.PARTS_ACCESSORY_TYPE;
        }
        override protected function getItemTypeIdx(i:int):int
        {
            return i;
        }


        protected override function get itemInventoryPanelImage():BasePanelImage
        {
            return _shopInventoryPanelImage;
        }


        // インベントリからデータを生成する
        override protected function inventoryToData():void
        {
            var i:int;
            var itemNum:int = 0; // アイテムの個数
            var items:Array = Shop.ID(_shopID).accPartsList;
            var prices:Array = Shop.ID(_shopID).accPartsPriceList;
            var coins:Array = Shop.ID(_shopID).accPartsCoinList;

            var part:AvatarPart;

            log.writeLog(log.LV_INFO, this, "items", items);
            log.writeLog(log.LV_INFO, this, "price", prices);

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < items.length; i++)
            {
                part = items[i];
                if (part && !checkPremiumCoin(coins[part.id]))
                {
                    // アイテムのイメージを作成
                    setItem(part);
                    // アイテムの個数をインクリメント
                    _itemDic[part].price = prices[part.id];
                    _itemDic[part].coins = coins[part.id];

                    log.writeLog(log.LV_INFO, this, "dp p c",prices[part.id], coins[part.id]);
                    log.writeLog(log.LV_INFO, this, "dp dp",_dpList[part.type-part.genre]);
                    _dpList[part.type-AvatarPart.PARTS_GENRE_ID[part.genre]].push(_itemDic[part]);
                }
            }

            log.writeLog(log.LV_INFO, this, "dp seted");
            // アイテムの個数
            var partsInvSet:Array = AvatarPartInventory.getGenreItems(AvatarPart.GENRE_ACCE); /* of api */ 
            for(i = 0; i < partsInvSet.length; i++)
            {
                part = partsInvSet[i].avatarPart;
                // アイテムのイメージを作成
                if (_itemDic[part] != null)
                {
//                 setItem(part);
                    // アイテムの個数をインクリメント
                    _itemDic[part].count += 1;
                }
            }
        }




        // アイテム購入に成功した時のイベント
        override protected function getAvatarPartSuccessHandler(e:AvatarPartEvent):void
        {
            if (AvatarPart.ID(e.id).genre == AvatarPart.GENRE_ACCE)
            {
                var dp:Array = _dpList[AvatarPart.ID(e.id).type-AvatarPart.GENRE_ACCE] as Array;
                updateCount(dp, e.id);
            }
        }


    }

}

