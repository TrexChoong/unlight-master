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

    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;
    import view.utils.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ShopSlotCardListPanelの表示クラス
     *
     */

    public class ShopSlotCardListPanel extends ShopItemListPanel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_TYPE_CHAR	:String = "キャラカード";
        CONFIG::LOCALE_JP
        private static const _TRANS_TYPE_WEAPON	:String = "武器";
        CONFIG::LOCALE_JP
        private static const _TRANS_TYPE_EQUIP	:String = "装備";
        CONFIG::LOCALE_JP
        private static const _TRANS_TYPE_EVENT	:String = "イベント";
        CONFIG::LOCALE_JP
        private static const _TRANS_NONE	:String = "未定";

        CONFIG::LOCALE_EN
        private static const _TRANS_TYPE_CHAR	:String = "Character Card";
        CONFIG::LOCALE_EN
        private static const _TRANS_TYPE_WEAPON	:String = "Weapon";
        CONFIG::LOCALE_EN
        private static const _TRANS_TYPE_EQUIP	:String = "Equipment";
        CONFIG::LOCALE_EN
        private static const _TRANS_TYPE_EVENT	:String = "Event";
        CONFIG::LOCALE_EN
        private static const _TRANS_NONE	:String = "N/A";

        CONFIG::LOCALE_TCN
        private static const _TRANS_TYPE_CHAR	:String = "人物卡";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TYPE_WEAPON	:String = "武器";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TYPE_EQUIP	:String = "裝備";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TYPE_EVENT	:String = "事件";
        CONFIG::LOCALE_TCN
        private static const _TRANS_NONE	:String = "未定";

        CONFIG::LOCALE_SCN
        private static const _TRANS_TYPE_CHAR	:String = "角色卡";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TYPE_WEAPON	:String = "武器";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TYPE_EQUIP	:String = "装备";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TYPE_EVENT	:String = "活动";
        CONFIG::LOCALE_SCN
        private static const _TRANS_NONE	:String = "未定";

        CONFIG::LOCALE_KR
        private static const _TRANS_TYPE_CHAR	:String = "캐릭카드";
        CONFIG::LOCALE_KR
        private static const _TRANS_TYPE_WEAPON	:String = "무기";
        CONFIG::LOCALE_KR
        private static const _TRANS_TYPE_EQUIP	:String = "장비";
        CONFIG::LOCALE_KR
        private static const _TRANS_TYPE_EVENT	:String = "이벤트";
        CONFIG::LOCALE_KR
        private static const _TRANS_NONE	:String = "미정";

        CONFIG::LOCALE_FR
        private static const _TRANS_TYPE_CHAR	:String = "Personnage";
        CONFIG::LOCALE_FR
        private static const _TRANS_TYPE_WEAPON	:String = "Arme";
        CONFIG::LOCALE_FR
        private static const _TRANS_TYPE_EQUIP	:String = "Equipement";
        CONFIG::LOCALE_FR
        private static const _TRANS_TYPE_EVENT	:String = "Événement";
        CONFIG::LOCALE_FR
        private static const _TRANS_NONE	:String = "Indéterminé	";

        CONFIG::LOCALE_ID
        private static const _TRANS_TYPE_CHAR	:String = "キャラカード";
        CONFIG::LOCALE_ID
        private static const _TRANS_TYPE_WEAPON	:String = "武器";
        CONFIG::LOCALE_ID
        private static const _TRANS_TYPE_EQUIP	:String = "装備";
        CONFIG::LOCALE_ID
        private static const _TRANS_TYPE_EVENT	:String = "イベント";
        CONFIG::LOCALE_ID
        private static const _TRANS_NONE	:String = "未定";

        CONFIG::LOCALE_TH
        private static const _TRANS_TYPE_CHAR   :String = "การ์ดตัวละคร";
        CONFIG::LOCALE_TH
        private static const _TRANS_TYPE_WEAPON :String = "อาวุธ";
        CONFIG::LOCALE_TH
        private static const _TRANS_TYPE_EQUIP  :String = "อุปกรณ์";
        CONFIG::LOCALE_TH
        private static const _TRANS_TYPE_EVENT  :String = "อีเวนท์";
        CONFIG::LOCALE_TH
        private static const _TRANS_NONE    :String = "ยังไม่กำหนด";


        // スロットカードのタイプ
//        private static const SLOT_CARD_TYPE:Array = ["キャラカード","武器","装備","イベント"];
        private static const SLOT_CARD_TYPE:Array = [_TRANS_TYPE_CHAR,_TRANS_TYPE_WEAPON,_TRANS_TYPE_EQUIP,_TRANS_TYPE_EVENT];

        // アイテムパネル
        private var _shopInventoryPanelImage:ShopInventoryPanelImage = new ShopInventoryPanelImage(SLOT_CARD_TYPE);

        /**
         * コンストラクタ
         *
         */
        public function ShopSlotCardListPanel(shopID:int =0)
        {
            super(shopID);
        }

        public override function init():void
        {
            super.init();
            ctrl.addEventListener(CharaCardEvent.GET_CHARA_CARD, getCharaCardSuccessHandler);
            ctrl.removeEventListener(AvatarItemEvent.GET_ITEM, getItemSuccessHandler);

//            ctrl.addEventListener(SlotCardEvent.GET_EQUIP_CARD, getEquipCardSuccessHa);
            ctrl.addEventListener(SlotCardEvent.GET_WEAPON_CARD, getWeaponCardSuccessHandler);
            ctrl.addEventListener(SlotCardEvent.GET_EVENT_CARD, getEventCardSuccessHandler);


        }

        public override function final():void
        {
            super.final();
            ctrl.removeEventListener(CharaCardEvent.GET_CHARA_CARD, getCharaCardSuccessHandler);
//            ctrl.removeEventListener(SlotCardEvent.GET_EQUIP_CARD, getEquipCardSuccessHa);
            ctrl.removeEventListener(SlotCardEvent.GET_WEAPON_CARD, getWeaponCardSuccessHandler);
            ctrl.removeEventListener(SlotCardEvent.GET_EVENT_CARD, getEventCardSuccessHandler);

        }




        override protected function get tabTypes():Array
        {
            return SLOT_CARD_TYPE;
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
            var itemNum:int = 0; // アイテムの個数
            var items:Array = Shop.ID(_shopID).eventCardsList;
            var prices:Array = Shop.ID(_shopID).eventCardsPriceList;
            var coins:Array = Shop.ID(_shopID).eventCardsCoinList;
            var card:ICard;

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < items.length; i++)
            {
                card = items[i];
                // アイテムのイメージを作成
                if (items[i] && !checkPremiumCoin(coins[card.id]))
                {
                    setItem(card);
                    _itemDic[card].price = prices[card.id];
                    _itemDic[card].coins = coins[card.id];
                    _dpList[card.type].push(_itemDic[card]);
                    _itemDic[card].getUpdateCount();
                }
            }

            items = Shop.ID(_shopID).weaponCardsList;
            prices = Shop.ID(_shopID).weaponCardsPriceList;
            coins = Shop.ID(_shopID).weaponCardsCoinList;

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < items.length; i++)
            {
                card = items[i];
                if (items[i] && !checkPremiumCoin(coins[card.id]))
                {
                    // アイテムのイメージを作成
                    setItem(card);
                    _itemDic[card].price = prices[card.id];
                    _itemDic[card].coins = coins[card.id];
                    _dpList[card.type].push(_itemDic[card]);
                    _itemDic[card].getUpdateCount();
                }
            }

            items = Shop.ID(_shopID).charaCardsList;
            prices = Shop.ID(_shopID).charaCardsPriceList;
            coins = Shop.ID(_shopID).charaCardsCoinList;

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < items.length; i++)
            {
                card = items[i];
                if (items[i] && !checkPremiumCoin(coins[card.id]))
                {
                    // アイテムのイメージを作成
                    setItem(card);
                    _itemDic[card].price = prices[card.id];
                    _itemDic[card].coins = coins[card.id];
                    _dpList[card.type].push(_itemDic[card]);
                    _itemDic[card].getUpdateCount();
                }
            }
        }

        // DicにAvatarItemを格納
        override protected function setItem(item:*):void
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
                _imageDic[item] = new SelectedImage(_selectItem.card.type, item);
            }
            return _imageDic[item];
        }

//         // アイテムが選択されたときのハンドラ
//         private function selectItemHandler(e:SelectItemEvent):void
//         {
//             // アイテムの選択状態の初期化と設定
//             var dp:Array = _dpList[e.item.card.type] as Array;
//             for(var i:int = 0; i < _itemList[_selectTabIndex].dataProvider.length; i++)
//             {
//                 _itemList[_selectTabIndex].dataProvider[i].shopSlotCardInventoryClip.offSelect();
//             }
//             e.item.onSelect();

//             _selectItem = e.item;
//             log.writeLog(log.LV_INFO, this, "item id", _selectItem.card.id);

//             if(_selectItemImage != null)
//             {
//                 _selectItemImage.visible = false;
//             }

//             setImage(_selectItem.card);
//             _selectItemImage = _imageDic[_selectItem.card];
//             _selectItemImage.x = 341;
//             _selectItemImage.y = 420;
//             _selectItemImage.scaleX = _selectItemImage.scaleY = 0.5;
//             _selectItemImage.visible = true;

//             _selectItemName.text = _selectItem.card.name;
//             _selectItemCountA.text = int(_selectItem.count+1).toString();
//             _selectItemCountB.text = _selectItem.count.toString();
////             _selectItemTime.text = "未定";
//             _selectItemTime.text = _TRANS_NONE;
////             _selectItemTiming.text = "未定";
//             _selectItemTiming.text = _TRANS_NONE;
//             _selectItemCaption.text = _selectItem.card.caption;

//             _shopInventoryPanelImage.onUse();

//             _beforeGems.text = _avatar.gems.toString();
//             _afterGems.text = _avatar.gems-_selectItem.price < 0 ? "0" : (_avatar.gems-_selectItem.price).toString();
//             _afterGems.styleName = _avatar.gems-_selectItem.price < 0 ? "ShopGemsNumericRed" : "ShopGemsNumeric";

// //             if(_selectItem.avatarItem.type == AvatarItem.ITEM_BASIS)
// //             {
// //                 _shopInventoryPanelImage.onUse();
// //             }
//         }
    protected override function createSelectItemImage():void
    {
            // 選択中のアイテムのイメージ
//            _selectImage = new AvatarItemImage(_selectItem.avatarItem.image, _selectItem.avatarItem.imageFrame);
            _selectImage = getImage(_selectItem.card);
//            Unlight.GCW.watch(_selectImage);
            log.writeLog(log.LV_FATAL, this, "selectimagecreate",_selectImage);
            _selectImage.x = 341;
            _selectImage.y = 420;
            _selectImage.scaleX = _selectImage.scaleY = 0.5;
            _container.addChild(_selectImage);
//            BaseScene(_selectImage).getShowThread(_container).start();
            _selectImage.visible = true;

            log.writeLog(log.LV_FATAL, this, "selectimagecreate",_selectImage);
            _selectItemName.text = _selectItem.card.name;
            _selectItemCountA.text = int(_selectItem.count+1).toString();
            _selectItemCountB.text = _selectItem.count.toString();
            _selectItemTime.text = "-";
            _selectItemTiming.text = "-";
            _selectItemCaption.text = _selectItem.card.caption;

            log.writeLog(log.LV_FATAL, this, "selectimagecreate,onuse");

            itemInventoryPanelImage.onUse();

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
//             // アイテムを購入
//            _lobbyCtrl.buyItem(_shopID, _selectItem.card.id);
            if(_selectItem.card.type == InventorySet.TYPE_CHARA)
            {
                _lobbyCtrl.buyCharaCard(_shopID, _selectItem.card.id, _buySendPanel.amount);
            }
            else
            {
                _lobbyCtrl.buySlotCard(_shopID, _selectItem.card.type, _selectItem.card.id, _buySendPanel.amount);
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
        private function getEventCardSuccessHandler(e:SlotCardEvent):void
        {
            var dp:Array = _dpList[EventCard.ID(e.id).type] as Array;

            updateSlotCardount(dp, e.id);
        }

        // アイテム購入に成功した時のイベント
        private function getWeaponCardSuccessHandler(e:SlotCardEvent):void
        {
            var dp:Array = _dpList[WeaponCard.ID(e.id).type] as Array;

            updateSlotCardount(dp,e.id);
        }

        // アイテム購入に成功した時のイベント
        private function getCharaCardSuccessHandler(e:CharaCardEvent):void
        {
            var dp:Array = _dpList[CharaCard.ID(e.id).type] as Array;

            updateSlotCardount(dp,e.id);
        }

        private function updateSlotCardount(dp:Array,id:int):void
        {
            log.writeLog(log.LV_FATAL, this, "updatea slot card count",id);
            for(var i:int = 0; i < dp.length; i++)
            {
                if(dp[i].card.id == id)
                {
                    log.writeLog(log.LV_FATAL, this, "count up !!!!",id);
                    dp[i].count += 1;
                    _selectItemCountA.text = int(dp[i].count+1).toString();
                    _selectItemCountB.text = dp[i].count.toString();
                    break;
                }
            }

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

