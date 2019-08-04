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
     * ShopPremiumListPanelの表示クラス
     *
     */

    public class ShopPremiumListPanel extends ShopItemListPanel
    {

        // アイテムパネル
        private var _shopInventoryPanelImage:ShopInventoryPanelImage = new ShopInventoryPanelImage(Shop.PREMIUM_ITEM_TYPE);
        private var _rmi:RealMoneyItem;

        /**
         * コンストラクタ
         *
         */
        public function ShopPremiumListPanel(shopID:int =0)
        {
            log.writeLog(log.LV_INFO, this, "new");
            super(shopID);
        }

        public override function init():void
        {
            super.init();
            ctrl.addEventListener(AvatarPartEvent.GET_PART, getAvatarPartSuccessHandler);
            ctrl.addEventListener(AvatarItemEvent.GET_ITEM, getItemSuccessHandler);
            ctrl.addEventListener(CharaCardEvent.GET_CHARA_CARD, getCharaCardSuccessHandler);
            ctrl.addEventListener(SlotCardEvent.GET_WEAPON_CARD, getWeaponCardSuccessHandler);
            ctrl.addEventListener(SlotCardEvent.GET_EVENT_CARD, getEventCardSuccessHandler);
        }

        public override function final():void
        {
            ctrl.removeEventListener(AvatarPartEvent.GET_PART, getAvatarPartSuccessHandler);
            ctrl.removeEventListener(AvatarItemEvent.GET_ITEM, getItemSuccessHandler);
            ctrl.removeEventListener(CharaCardEvent.GET_CHARA_CARD, getCharaCardSuccessHandler);
            ctrl.removeEventListener(SlotCardEvent.GET_WEAPON_CARD, getWeaponCardSuccessHandler);
            ctrl.removeEventListener(SlotCardEvent.GET_EVENT_CARD, getEventCardSuccessHandler);

            super.final();
        }


        override protected function get tabTypes():Array
        {
            return Shop.PREMIUM_ITEM_TYPE;
        }
        override protected function getItemTypeIdx(i:int):int
        {
            return i;
        }

        protected override function get itemInventoryPanelImage():BasePanelImage
        {
            return _shopInventoryPanelImage;
        }

        protected override function imageDicFinal():void
        {
            for (var key:Object in _imageDic) {
                RemoveChild.apply(_imageDic[key]);

                _imageDic[key].final();
                delete  _imageDic[key];
            }
        }

        // インベントリからデータを生成する
        override protected function inventoryToData():void
        {
            var i:int;
            var items:Array = Shop.ID(_shopID).itemList; /* of AvatarItem */
            var itemPrices:Array = Shop.ID(_shopID).itemPriceList;
            var itemCoins:Array = Shop.ID(_shopID).itemCoinList;

            var parts:Array = Shop.ID(_shopID).partsList; /* of AvatarPart */
            var partPrices:Array = Shop.ID(_shopID).partsPriceList;
            var partCoins:Array = Shop.ID(_shopID).partsCoinList;

            var cards:Array = Shop.ID(_shopID).charaCardsList;  /* of CharaCard */
            var cardPrices:Array = Shop.ID(_shopID).charaCardsPriceList;
            var cardCoins:Array = Shop.ID(_shopID).charaCardsCoinList;

            var eventCards:Array = Shop.ID(_shopID).eventCardsList;  /* of EventCard */
            var eventCardPrices:Array = Shop.ID(_shopID).eventCardsPriceList;
            var eventCardCoins:Array = Shop.ID(_shopID).eventCardsCoinList;

            var weaponCards:Array = Shop.ID(_shopID).weaponCardsList;  /* of EventCard */
            var weaponCardPrices:Array = Shop.ID(_shopID).weaponCardsPriceList;
            var weaponCardCoins:Array = Shop.ID(_shopID).weaponCardsCoinList;

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < items.length; i++)
            {
                if (items[i] && checkPremiumCoin(itemCoins[items[i].id]))
                {
                    // アイテムのイメージを作成
                    setItem(items[i]);
                    _itemDic[items[i]].price = itemPrices[items[i].id];
                    _itemDic[items[i]].coins = itemCoins[items[i].id];
                    _dpList[0].push(_itemDic[items[i]]);
                    _itemDic[items[i]].getUpdateCount();
                }
            }

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < parts.length; i++)
            {
                if (parts[i] && partCoins[parts[i].id] && checkPremiumCoin(partCoins[parts[i].id]))
                {
                    // アイテムのイメージを作成
                    setPart(parts[i]);
                    _itemDic[parts[i]].price = partPrices[parts[i].id];
                    _itemDic[parts[i]].coins = partCoins[parts[i].id];
                    _dpList[1].push(_itemDic[parts[i]]);
                    _itemDic[parts[i]].getUpdateCount();
                }
            }

//             // データプロバイダーにタイプごとのアイテムを設定する
//             for(i = 0; i < parts.length; i++)
//             {
//                 // アイテムのイメージを作成
//                 setPart(parts[i]);
//                 // アイテムの個数をインクリメント
//                 _itemDic[parts[i]].RMPrice = partPrices[i];;
//                 _itemDic[parts[i]].coins = parts[i].num;
//                 _dpList[1].push(_itemDic[parts[i]]);
//                 _itemDic[parts[i]].getUpdateCount();
//             }

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < cards.length; i++)
            {
                if (cards[i] && checkPremiumCoin(cardCoins[cards[i].id]))
                {
                    // アイテムのイメージを作成
                    setCard(cards[i]);
                    _itemDic[cards[i]].price = cardPrices[cards[i].id];
                    _itemDic[cards[i]].coins = cardCoins[cards[i].id];
                    _dpList[2].push(_itemDic[cards[i]]);
                    _itemDic[cards[i]].getUpdateCount();
                }
            }

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < eventCards.length; i++)
            {
                if (eventCards[i] && checkPremiumCoin(eventCardCoins[eventCards[i].id]))
                {
                    // アイテムのイメージを作成
                    setCard(eventCards[i]);
                    _itemDic[eventCards[i]].price = eventCardPrices[eventCards[i].id];
                    _itemDic[eventCards[i]].coins = eventCardCoins[eventCards[i].id];
                    _dpList[3].push(_itemDic[eventCards[i]]);
                    _itemDic[eventCards[i]].getUpdateCount();
                }
            }

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < weaponCards.length; i++)
            {
                if (weaponCards[i] && checkPremiumCoin(weaponCardCoins[weaponCards[i].id]))
                {
                    // アイテムのイメージを作成
                    setCard(weaponCards[i]);
                    _itemDic[weaponCards[i]].price = weaponCardPrices[weaponCards[i].id];
                    _itemDic[weaponCards[i]].coins = weaponCardCoins[weaponCards[i].id];
                    _dpList[3].push(_itemDic[weaponCards[i]]);
                    _itemDic[weaponCards[i]].getUpdateCount();
                }
            }


        }

        // DicにAvatarItemを格納
        override protected function setItem(item:*):void
        {
            if (_itemDic[item] == null)
            {
                _itemDic[item] = new ShopItemInventoryClip(item);
            }
        }

        private function setPart(item:*):void
        {
            if (_itemDic[item] == null)
            {
                _itemDic[item] = new ShopPartInventoryClip(AvatarPart.ID(item));
            }
        }

        private function setCard(item:*):void
        {
            if (_itemDic[item] == null)
            {
                _itemDic[item] = new ShopSlotCardInventoryClip(item);
            }
        }

        // DicにAvatarItemを格納
        protected override function getImage(item:*):DisplayObject
        {
            if (_imageDic[item] == null)
            {
                _imageDic[item] = new AvatarPartIcon(item);
            }
            return _imageDic[item];
        }

        // DicにAvatarItemを格納
        protected function getCardImage(item:*):DisplayObject
        {
            if (_imageDic[item] == null)
            {
                _imageDic[item] = new SelectedImage(_selectItem.card.type, item);
            }
            return _imageDic[item];
        }

        protected override function createSelectItemImage():void
        {

            if(_selectItem.avatarItem !=null)
            {
                // 選択中のアイテムのイメージ
                _selectImage = new AvatarItemImage(_selectItem.avatarItem.image, _selectItem.avatarItem.imageFrame);
                _selectImage.x = 384;
                _selectImage.y = 480;
                _selectImage.scaleX = _selectImage.scaleY = 1.0;
                _container.addChild(_selectImage);
                _selectImage.visible = true;

                _selectItemName.text = _selectItem.avatarItem.name;

                log.writeLog(log.LV_FATAL, this, "selectimagecreate,onuse");

                itemInventoryPanelImage.onUse();
                _selectItemTime.text = "-";
                _selectItemTiming.text = "-";

                _selectItemCaption.text = _selectItem.avatarItem.caption;
            }
            else if (_selectItem.avatarPart !=null)
            {
                // 選択中のアイテムのイメージ
                _selectImage = getImage(_selectItem.avatarPart);
                _selectImage.x = 320;
                _selectImage.y = 416;
                _selectImage.scaleX = _selectImage.scaleY = 1.0;
                _container.addChild(_selectImage);
                _selectImage.visible = true;
                _selectItemName.text = _selectItem.avatarPart.name;
                if(_selectItem.avatarPart.duration==0)
                {
                    _selectItemTime.text = "-";
                }else{
                    _selectItemTime.text = TimeFormat.toDateString(_selectItem.avatarPart.duration);
                }
                _selectItemTiming.text = "-";

                if (AvatarPartInventory.getItemsNum(_selectItem.avatarPart.id) == 0)
                {
                    itemInventoryPanelImage.onUse();
                }else{
                    itemInventoryPanelImage.offUse();
                }

                _selectItemCaption.text = _selectItem.avatarPart.caption;

            }
            else if (_selectItem.card !=null)
            {
                // 選択中のアイテムのイメージ
                _selectImage = getCardImage(_selectItem.card);
                _selectImage.x = 341;
                _selectImage.y = 420;
                _selectImage.scaleX = _selectImage.scaleY = 0.5;
                _container.addChild(_selectImage);
                _selectImage.visible = true;

                log.writeLog(log.LV_FATAL, this, "selectimagecreate",_selectImage);
                _selectItemName.text = _selectItem.card.name;
                itemInventoryPanelImage.onUse();
                log.writeLog(log.LV_FATAL, this, "selectimagecreate,onuse");

                _selectItemCaption.text = _selectItem.card.caption;
            }

            _selectItemCountA.text = int(_selectItem.count+1).toString();
            _selectItem.getUpdateCount();
            _selectItemCountB.text = _selectItem.count.toString();

            _beforeGems.text = _avatar.gems.toString();
            _afterGems.text = _avatar.gems-_selectItem.price < 0 ? String(_avatar.gems-_selectItem.price) : (_avatar.gems-_selectItem.price).toString();
            _afterGems.styleName = _avatar.gems-_selectItem.price < 0 ? "ShopGemsNumericRed" : _selectItem.price > 0 ? "ShopGemsNumericYellow" : "ShopGemsNumeric";

            // モンスターコイン
            for(var i:int = 0; i < _selectItem.coins.length; i++)
            {
                coinCalc(_beforeCoins[i], _afterCoins[i],  CharaCardDeck.binder.sortCharaCardId(Const.COIN_SET[i]), _selectItem.coins[i]);
            }

        }

        // アイテム購入ハンドラ
        override protected function pushBuyYesHandler(e:MouseEvent):void
        {
            // アイテムを購入
            if(_selectItem.card!=null)
            {
                if(_selectItem.card.type == InventorySet.TYPE_CHARA)
                {
                    _lobbyCtrl.buyCharaCard(_shopID, _selectItem.card.id,_buySendPanel.amount);
                }
                else
                {
                    _lobbyCtrl.buySlotCard(_shopID, _selectItem.card.type, _selectItem.card.id,_buySendPanel.amount);
                }
            }
            if(_selectItem.avatarPart!=null)
            {
                _lobbyCtrl.buyPart(_shopID, _selectItem.avatarPart.id);
            }
            if(_selectItem.avatarItem!=null)
            {
                _lobbyCtrl.buyItem(_shopID, _selectItem.avatarItem.id,_buySendPanel.amount);
            }

            _buySendPanel.visible = false;
            _container.mouseChildren = true;
            _container.mouseEnabled = true;

        }

        // アイテム購入キャンセル
        private function pushBuyNoHandler(e:MouseEvent):void
        {
            _buySendPanel.visible = false;
            _container.mouseChildren = true;
            _container.mouseEnabled = true;
        }


        // アイテム購入に成功した時のイベント
        protected override function getItemSuccessHandler(e:AvatarItemEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "getItemSucc",e.id);
            updateCount(_dpList[0], e.id, 0);
        }

        // パーツ購入に成功した時のイベント
        protected function getAvatarPartSuccessHandler(e:AvatarPartEvent):void
        {
            updateCount(_dpList[1], e.id, 1);
        }

        // キャラカード購入に成功した時のイベント
        protected function getCharaCardSuccessHandler(e:CharaCardEvent):void
        {
            updateCount(_dpList[2], e.id, 2);
        }

        // キャラカード購入に成功した時のイベント
        protected function getEventCardSuccessHandler(e:SlotCardEvent):void
        {
            updateCount(_dpList[3], e.id, 3);
        }

        // キャラカード購入に成功した時のイベント
        protected function getWeaponCardSuccessHandler(e:SlotCardEvent):void
        {
            updateCount(_dpList[3], e.id, 3);
        }


        protected function updateCount(dp:Array , id:int ,type:int):void
        {
           if (dp != null)
           {
               for(var i:int = 0; i < dp.length; i++)
               {
                   if (type ==3)
                   {
                       if((dp[i].card!=null)&& dp[i].card.id == id && dp[i].card.type == type)
                       {
//                        dp[i].getUpdateCount();
                           _selectItem.getUpdateCount();
                           log.writeLog(log.LV_WARN, this, "count up !!!!", dp[i].count,type);
                           _selectItemCountA.text = int(_selectItem.count+1).toString();
                           _selectItemCountB.text = _selectItem.count.toString();
                           itemInventoryPanelImage.offUse();
                           break;
                       }
                   }
                   else if (type ==2)
                   {
                       if((dp[i].card!=null)&& dp[i].card.id == id && dp[i].card.type == type)
                       {
//                        dp[i].getUpdateCount();
                           _selectItem.getUpdateCount();
                           log.writeLog(log.LV_WARN, this, "count up !!!!", dp[i].count,type);
                           _selectItemCountA.text = int(_selectItem.count+1).toString();
                           _selectItemCountB.text = _selectItem.count.toString();
                           itemInventoryPanelImage.offUse();
                           break;
                       }
                   }
                   else if (type ==1)
                   {
                       if((dp[i].avatarPart!=null)&& dp[i].avatarPart.id == id)
                       {
//                        dp[i].getUpdateCount();
                           _selectItem.getUpdateCount();
                           log.writeLog(log.LV_WARN, this, "count up !!!!", dp[i].count,type);
                           _selectItemCountA.text = int(_selectItem.count+1).toString();
                           _selectItemCountB.text = _selectItem.count.toString();
                           itemInventoryPanelImage.offUse();
                           break;
                       }
                   }
                   else if (type == 0)
                   {
                       if((dp[i].avatarItem!=null)&& dp[i].avatarItem.id == id)
                       {
                           dp[i].getUpdateCount();
                           log.writeLog(log.LV_WARN, this, "count up !!!!", dp[i].count,type);
                           _selectItemCountA.text = int(dp[i].count+1).toString();
                           _selectItemCountB.text = dp[i].count.toString();
                           break;
                       }
                   }
               }
           }
        }

        // アイテムがかわれた時のハンドラ
        protected override function buyItemHandler(e:Event):void
        {
            SE.playClick();
            // 確認パネルを出す
            setPriceData();
            _buySendPanel.visible = true;
            _container.mouseChildren = false;
            _container.mouseEnabled = false;
        }

    }

}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import mx.core.UIComponent;

import org.libspark.thread.Thread;

import model.*;
import model.events.*;
import view.image.shop.*;
import view.image.item.*;
import view.scene.common.*;
import view.scene.*;

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

class SelectedImage extends UIComponent
{

    private var _image:BaseScene;

    public function SelectedImage(type:int,item:*)
    {
        switch (type)
        {
        case InventorySet.TYPE_CHARA:
            _image = new CharaCardClip(CharaCard(item));
            break;
        case InventorySet.TYPE_WEAPON:
            _image = new WeaponCardClip(WeaponCard(item));
            break;
        case InventorySet.TYPE_EQUIP:
            _image = new EquipCardClip(EquipCard(item));
            break;
        case InventorySet.TYPE_EVENT:
            _image = new EventCardClip(EventCard(item));
            break;
        }
        log.writeLog(log.LV_FATAL, this, "selecet image create",_image);
        if (_image!=null)
        {
            _image.getShowThread(this).start();
        };
    }

    public function final():void
    {
        if (_image!=null)
        {
            _image.getHideThread().start();
        };

    }


}
