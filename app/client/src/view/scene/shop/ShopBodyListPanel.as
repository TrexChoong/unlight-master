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
     * ShopBodyListPanelの表示クラス
     *
     */

    public class ShopBodyListPanel extends ShopItemListPanel
    {

        // アイテムパネル
        private var _shopInventoryPanelImage:ShopInventoryPanelImage = new ShopInventoryPanelImage(AvatarPart.PARTS_BODY_TYPE);

        /**
         * コンストラクタ
         *
         */
        public function ShopBodyListPanel(shopID:int =0)
        {
            super(shopID);
        }

        public override function init():void
        {
            super.init();
            ctrl.addEventListener(AvatarPartEvent.GET_PART, getAvatarPartSuccessHandler);

        }

        public override function final():void
        {
            super.final();
            ctrl.removeEventListener(AvatarPartEvent.GET_PART, getAvatarPartSuccessHandler);
        }


        override protected function get tabTypes():Array
        {
            return AvatarPart.PARTS_BODY_TYPE;
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
            var items:Array = Shop.ID(_shopID).bodyPartsList;
            var prices:Array = Shop.ID(_shopID).bodyPartsPriceList;
            var coins:Array = Shop.ID(_shopID).bodyPartsCoinList;

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
                    _dpList[part.type-AvatarPart.PARTS_GENRE_ID[part.genre]].push(_itemDic[part]);
                    _itemDic[part].getUpdateCount();
                }
            }
        }

        // DicにAvatarItemを格納
        override protected function setItem(item:*):void
        {
            if (_itemDic[item] == null)
            {
                _itemDic[item] = new ShopPartInventoryClip(item);
            }
        }

        // DicにAvatarItemを格納
        protected override function getImage(item:*):DisplayObject
        {
            if (_imageDic[item] == null)
            {
                _imageDic[item] =  new AvatarPartIcon(item);

            }
            return _imageDic[item];
        }

    protected override function createSelectItemImage():void
    {
            // 選択中のアイテムのイメージ
//            _selectImage = new AvatarItemImage(_selectItem.avatarItem.image, _selectItem.avatarItem.imageFrame);
        log.writeLog(log.LV_FATAL, this, "CLICK!!!!!!!!!!!!!!!!!!!");
        _selectImage = getImage(_selectItem.avatarPart);
//            Unlight.GCW.watch(_selectImage);
            log.writeLog(log.LV_FATAL, this, "selectimagecreate",_selectImage);
            _selectImage.x = 320;
            _selectImage.y = 416;
            _selectImage.scaleX = _selectImage.scaleY = 1.0;
//             _selectImage.x = 341;
//             _selectImage.y = 420;
//             _selectImage.scaleX = _selectImage.scaleY = 0.5;
            _container.addChild(_selectImage);
//            BaseScene(_selectImage).getShowThread(_container).start();
            _selectImage.visible = true;

            log.writeLog(log.LV_FATAL, this, "selectimagecreate",_selectImage);
            _selectItemName.text = _selectItem.avatarPart.name;
            _selectItemCountA.text = int(_selectItem.count+1).toString();
            _selectItemCountB.text = _selectItem.count.toString();
            if(_selectItem.avatarPart.duration==0)
            {
            _selectItemTime.text = "-";
            }else{
                _selectItemTime.text = TimeFormat.toDateString(_selectItem.avatarPart.duration);
            }
            _selectItemTiming.text = "-";
            _selectItemCaption.text = _selectItem.avatarPart.caption;

            log.writeLog(log.LV_FATAL, this, "selectimagecreate,onuse");

            if(_selectItem.count == 0)
            {
                itemInventoryPanelImage.onUse();
            }else{
                itemInventoryPanelImage.offUse();
            }

            _beforeGems.text = _avatar.gems.toString();
            _afterGems.text = _avatar.gems-_selectItem.price < 0 ? String(_avatar.gems-_selectItem.price) : (_avatar.gems-_selectItem.price).toString();
            _afterGems.styleName = _avatar.gems-_selectItem.price < 0 ? "ShopGemsNumericRed" : _selectItem.price > 0 ? "ShopGemsNumericYellow" : "ShopGemsNumeric";

            // モンスターコイン
            for(var i:int = 0; i < _selectItem.coins.length; i++)
            {
                coinCalc(_beforeCoins[i], _afterCoins[i],  CharaCardDeck.binder.sortCharaCardId(Const.COIN_SET[i]), _selectItem.coins[i]);
            }
        }

        // アイテムがかわれた時のハンドラ
        override protected function buyItemHandler(e:Event):void
        {
            SE.playClick();

            _buySendPanel.selectVisible = false;
            // 確認パネルを出す
            _buySendPanel.visible = true;
            _container.mouseChildren = false;
            _container.mouseEnabled = false;
        }

        // アイテム購入ハンドラ
        override protected function pushBuyYesHandler(e:MouseEvent):void
        {
//             // アイテムを購入
//            _lobbyCtrl.buyItem(_shopID, _selectItem.card.id);

            _lobbyCtrl.buyPart(_shopID, _selectItem.avatarPart.id);
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
        protected function getAvatarPartSuccessHandler(e:AvatarPartEvent):void
        {
            if (AvatarPart.ID(e.id).genre == AvatarPart.GENRE_BODY)
            {
                var dp:Array = _dpList[AvatarPart.ID(e.id).type-AvatarPart.GENRE_BODY] as Array;
                updateCount(dp, e.id);
            }
        }

        protected function updateCount(dp:Array,id:int):void
        {
            log.writeLog(log.LV_FATAL, this, "updatea part count",id);
            if(_itemDic[AvatarPart.ID(id)]!=null)
            {
                _itemDic[AvatarPart.ID(id)].getUpdateCount();
                _selectItemCountA.text = int(_selectItem.count+1).toString();
                _selectItemCountB.text = _selectItem.count.toString();
            }

//             for(var i:int = 0; i < dp.length; i++)
//             {
//                 if(dp[i].avatarPart.id == id)
//                 {
//                     log.writeLog(log.LV_FATAL, this, "count up !!!!",id);
//                     dp[i].getUpdateCount();
//                     _selectItemCountA.text = int(dp[i].count+1).toString();
//                     _selectItemCountB.text = dp[i].count.toString();
//                     break;
//                 }
//             }

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


