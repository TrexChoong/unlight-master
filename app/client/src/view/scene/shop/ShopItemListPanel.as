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
     * ShopItemListPanelの表示クラス
     * 
     */

    public class ShopItemListPanel extends BaseItemListPanel
    {

        // アイテムパネル
        private var _shopInventoryPanelImage:ShopInventoryPanelImage = new ShopInventoryPanelImage(AvatarItem.ITEM_TYPE);

//         // アバターアイテムイメージキャッシュ
        protected var _imageDic:Dictionary = new Dictionary; // Dictionary of item Key:AvatarItem


        // 選択中のアイテムの個数
        protected var _selectItemCountA:Label = new Label();
        // 選択中のアイテムの個数
        protected var _selectItemCountB:Label = new Label();

        // アバター
        protected var _avatar:Avatar = Player.instance.avatar;

        // ジェム表示
        protected var _beforeGems:Label = new Label();
        protected var _afterGems:Label = new Label();

        // コイン表示
        protected var _beforeCoins:Array = [new Label(), new Label(), new Label(), new Label(), new Label(), new Label()];
        protected var _afterCoins:Array = [new Label(), new Label(), new Label(), new Label(), new Label(), new Label()];

        // 購入確認パネル
        protected var _buySendPanel:BuySendPanel = new BuySendPanel();

        // タブ設定
        public static const TAB_AVATAR:int = 0;
        public static const TAB_CHARA:int = 1;
        public static const TAB_CHARA_EQUIP:int = 2;
        public static const TAB_DUEL:int = 3;
        public static const TAB_SPECIAL:int = 4;
        public static const TAB_ALL:int = 6;

        // 位置定数
        public static const _ITEM_LIST_X:int = 24;
        public static const _ITEM_LIST_Y:int = 104;

        private const _GEMS_X:int = 96;
        private const _GEMS_Y:int = 574;
        private const _GEMS_WIDTH:int = 100;
        private const _GEMS_HEIGHT:int = 20;

        private const _COINS_X:int = 89;
        private const _COINS_Y:int = 602;
        private const _COINS_WIDTH:int = 40;
        private const _COINS_HEIGHT:int = 20;
        private const _COINS_OFFSET_X:int = 72;

        protected var _shopID:int;


        /**
         * コンストラクタ
         *
         */
        public function ShopItemListPanel(shopID:int =0)
        {
            super();
            visible = false;
            _shopID = shopID;
        }

        protected override function get itemInventoryPanelImage():BasePanelImage
        {
            return _shopInventoryPanelImage;
        }


        // 初期化
        public override function init():void
        {
            super.init();
            log.writeLog(log.LV_FATAL, this, "init shopstart");
            itemInventoryPanelImage.addEventListener(ShopInventoryPanelImage.BUY_ITEM, buyItemHandler);
            _avatar.addEventListener(Avatar.GEMS_UPDATE, avatarUpdateHandler);

            _beforeGems.x = _GEMS_X - x;
            _beforeGems.y = _GEMS_Y - y;
            _beforeGems.width = _GEMS_WIDTH;
            _beforeGems.height = _GEMS_HEIGHT;
            _beforeGems.text = "";
            _beforeGems.styleName = "ShopGemsNumeric";

            _afterGems.x = _GEMS_X + 115 - x;
            _afterGems.y = _GEMS_Y - y;
            _afterGems.width = _GEMS_WIDTH;
            _afterGems.height = _GEMS_HEIGHT;
            _afterGems.text = "";
            _afterGems.styleName = "ShopGemsNumeric";

            // コイン
            _beforeCoins.forEach(function(item:*, index:int, array:Array):void{initCoin(item, index, false)});
            _afterCoins.forEach(function(item:*, index:int, array:Array):void{initCoin(item, index, true)});

            _container.addChild(_afterGems);
            _container.addChild(_beforeGems);
            addChild(_buySendPanel);

            _buySendPanel.visible = false;
            _buySendPanel.yesButton.addEventListener(MouseEvent.CLICK, pushBuyYesHandler);
            _buySendPanel.noButton.addEventListener(MouseEvent.CLICK, pushBuyNoHandler);
            selectTabHandler(new SelectTabEvent(SelectTabEvent.TAB_CHANGE, 0));
        }

        private function initCoin(label:Label, num:int, t:Boolean):void
        {
            if(t)
            {
                label.x = _COINS_X + _COINS_OFFSET_X * num + 30;
            }
            else
            {
                label.x = _COINS_X + _COINS_OFFSET_X * num;
            }
            // exコイン
            if(num >= 5)
            {
                label.x -= _COINS_OFFSET_X * (num+1);
            }
            label.y = _COINS_Y;
            label.width = _COINS_WIDTH;
            label.height = _COINS_HEIGHT;
            label.text = "";
            label.styleName = "ShopCoinsNumeric";

            _container.addChild(label);

        }

        protected override function textLabelInit():void
        {
            log.writeLog(log.LV_FATAL, this, "text create");
            // 選択中のアイテムの名前
            _selectItemName.x = 106;
            _selectItemName.y = 424;
            _selectItemName.width = 200;
            _selectItemName.height = 30;
            _selectItemName.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemName);
            // 選択中のアイテムの説明
            _selectItemCountA.x = -10;
            _selectItemCountA.y = 526;
            _selectItemCountA.width = 135;
            _selectItemCountA.height = 30;
            _selectItemCountA.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemCountA);
            // 選択中のアイテムの説明
            _selectItemCountB.x = -50;
            _selectItemCountB.y = 526;
            _selectItemCountB.width = 135;
            _selectItemCountB.height = 30;
            _selectItemCountB.styleName = "ItemListNumericRight2";
            _container.addChild(_selectItemCountB);
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
        // 後処理[M#Ã
        public override function final():void
        {
            super.final();
            ctrl.removeEventListener(AvatarItemEvent.USE_ITEM, useItemSuccessHandler);

            itemInventoryPanelImage.removeEventListener(ShopInventoryPanelImage.BUY_ITEM, buyItemHandler);
            _avatar.removeEventListener(Avatar.GEMS_UPDATE, avatarUpdateHandler);
            _buySendPanel.yesButton.removeEventListener(MouseEvent.CLICK, pushBuyYesHandler);
            _buySendPanel.noButton.removeEventListener(MouseEvent.CLICK, pushBuyNoHandler);
            imageDicFinal()
            _avatar = null;
            _itemDic = null;
        }
        protected function imageDicFinal():void
        {
            for (var key:Object in _imageDic) {
                RemoveChild.apply(_imageDic[key]);
                delete  _imageDic[key];
            }
        }
        // インベントリからデータを生成する
        protected override function inventoryToData():void
        {
            var i:int;
            var itemNum:int = 0; // アイテムの個数
            var items:Array = Shop.ID(_shopID).itemList;
            var prices:Array = Shop.ID(_shopID).itemPriceList;
            var coins:Array = Shop.ID(_shopID).itemCoinList;

            var avatarItem:AvatarItem;

            log.writeLog(log.LV_INFO, this, "items", items);
            log.writeLog(log.LV_INFO, this, "prices", prices);
            log.writeLog(log.LV_INFO, this, "coins", coins);

            // データプロバイダーにタイプごとのアイテムを設定する
            for(i = 0; i < items.length; i++)
            {
                avatarItem = items[i];
                if (avatarItem && !checkPremiumCoin(coins[avatarItem.id]))
                {
                    // アイテムのイメージを作成
                    setItem(avatarItem);
                    // アイテムの個数をインクリメント
                    _itemDic[avatarItem].price = prices[avatarItem.id];
                    _itemDic[avatarItem].coins = coins[avatarItem.id];
                    _dpList[avatarItem.type].push(_itemDic[avatarItem]);
                    _itemDic[avatarItem].getUpdateCount();
                }
            }
        }


        protected override function createSelectItemImage():void
        {
            // 選択中のアイテムのイメージ
//            _selectImage = new AvatarItemImage(_selectItem.avatarItem.image, _selectItem.avatarItem.imageFrame);
            _selectImage = getImage(_selectItem.avatarItem);
//            Unlight.GCW.watch(_selectImage);
            log.writeLog(log.LV_FATAL, this, "selectimagecreate",_selectImage);
            _selectImage.x = 384;
            _selectImage.y = 480;
            _selectImage.scaleX = _selectImage.scaleY = 1.0;
            _container.addChild(_selectImage);
            _selectImage.visible = true;

            log.writeLog(log.LV_FATAL, this, "selectimagecreate",_selectImage);
            _selectItemName.text = _selectItem.avatarItem.name;
            _selectItemCountA.text = int(_selectItem.count+1).toString();
            _selectItemCountB.text = _selectItem.count.toString();
            _selectItemTime.text = "-";
            _selectItemTiming.text = "-";
            _selectItemCaption.text = _selectItem.avatarItem.caption;

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

        // コイン計算用の関数
        protected function coinCalc(l0:Label, l1:Label, c0:int, c1:int):void
        {
            l0.text = c0.toString();
            l1.text = c0 - c1 < 0 ? String(c0 - c1) : (c0 - c1).toString();
            l1.styleName = c0 - c1 < 0 ? "ShopCoinsNumericRed" : c1 > 0 ? "ShopCoinsNumericYellow" : "ShopCoinsNumeric";
        }

        // タブが選択されたときのハンドラ
        protected override function selectTabHandler(e:SelectTabEvent):void
        {
            super.selectTabHandler(e);
            _beforeGems.text = "";
            _afterGems.text = "";

            for(var i:int = 0; i < _afterCoins.length; i++)
            {
                _beforeCoins[i].text = "";
                _afterCoins[i].text = "";
            }
        }

        protected override function resetSelectItem():void
        {
            if(_selectImage != null)
            {
                RemoveChild.apply(_selectImage);
                _selectImage.visible = false;
                _selectImage = null;
                for ( var i:int = 0; i < _selectImageList.length; i++ ) {
                    RemoveChild.apply(_selectImageList[i]);
                    _selectImageList[i].visible = false;
                }
                _selectImageList.length = 0;
                _selectItemName.text = "";
                _selectItemCountA.text = "";
                _selectItemCountB.text = "";
                _selectItemTime.text = "";
                _selectItemTiming.text = "";
                _selectItemCaption.text = "";
            }
        }



        // DicにAvatarItemを格納
        protected override function setItem(item:*):void
        {
            if (_itemDic[item] == null)
            {
                _itemDic[item] = new ShopItemInventoryClip(item);
            }
        }

        // DicにAvatarItemを格納
        protected function getImage(item:*):DisplayObject
        {
            // キャッシュされたものを返す
            if (_imageDic[item] == null)
            {
                var imageFrame:int = 1;
                if ( item.shopImageFrame != 0 ) {
                    imageFrame = item.shopImageFrame;
                } else {
                    imageFrame = item.imageFrame;
                }
                log.writeLog(log.LV_INFO, this ,"#####!!!!!", item.image,imageFrame);
                _imageDic[item] = new AvatarItemImage(item.image, imageFrame);
//                _imageDic[item].getShowThread(_container).start();
            }
            return _imageDic[item];
        }

        protected function get getSelectItemName():String
        {
            var ret:String = "";
            if ( _selectItem.avatarItem ) {
                ret = _selectItem.avatarItem.name;
            }
            if ( _selectItem.avatarPart ) {
                ret = _selectItem.avatarPart.name;
            }
            if ( _selectItem.card ) {
                ret = _selectItem.card.name;
            }
            return ret;
        }

        protected function setPriceData():void
        {
            var avatarCoin:Array = [];
            var coinPrice:Array = [];
            // モンスターコイン
            for(var i:int = 0; i < _selectItem.coins.length; i++)
            {
                if (i < 5)
                {
                    avatarCoin.push(CharaCardDeck.binder.sortCharaCardId(i+10001));
                    coinPrice.push(_selectItem.coins[i]);
                }
                else if (i >= 5)
                {
                    avatarCoin.push(CharaCardDeck.binder.sortCharaCardId(i+10006));
                    coinPrice.push(_selectItem.coins[i]);
                }
            }
            _buySendPanel.setSelecterItems(_avatar.gems,_selectItem.price,avatarCoin,coinPrice,getSelectItemName);
        }

        // アイテムがかわれた時のハンドラ
        protected function buyItemHandler(e:Event):void
        {
            SE.playClick();

            setPriceData();
            // 確認パネルを出す
            _buySendPanel.visible = true;
            _container.mouseChildren = false;
            _container.mouseEnabled = false;
        }

        // アイテム購入ハンドラ
        protected function pushBuyYesHandler(e:MouseEvent):void
        {
            SE.playClick();

//             // アイテムを購入
            ctrl.buyItem(_shopID, _selectItem.avatarItem.id,_buySendPanel.amount);
//            _lobbyCtrl.buySlotCard(_shopID, InventorySet.TYPE_EVENT, 1);
            _buySendPanel.visible = false;
            _container.mouseChildren = true;
            _container.mouseEnabled = true;
        }

        // アイテム購入キャンセル
        private function pushBuyNoHandler(e:MouseEvent):void
        {
            SE.playClick();

            _buySendPanel.visible = false;
            _container.mouseChildren = true;
            _container.mouseEnabled = true;

        }
        // アイテム購入に成功した時のイベント
        protected override function useItemSuccessHandler(e:AvatarItemEvent):void
        {
            var dp:Array = _dpList[AvatarItem.ID(e.id).type] as Array;
            var success:Boolean = false;
            for(var i:int = 0; i < dp.length; i++)
            {
                log.writeLog(log.LV_INFO, this, "dp", dp);
                if((dp[i].avatarItem && dp[i].avatarItem.id == e.id) || (dp[i].avatarItem && dp[i].avatarItem.id == e.id))
                {
                    dp[i].count -= 1;
                    // アイテムを減算した後、更新
                    _selectItemCountA.text = int(dp[i].count+1).toString();
                    _selectItemCountB.text = dp[i].count.toString();
                    break;
                }
            }
        }

        // アイテム購入に成功した時のイベント
        protected override function getItemSuccessHandler(e:AvatarItemEvent):void
        {
            var dp:Array = _dpList[AvatarItem.ID(e.id).type] as Array;
            var success:Boolean = false;

            for(var i:int = 0; i < dp.length; i++)
            {
                log.writeLog(log.LV_INFO, this, "dp", dp);
                if((dp[i].avatarItem && dp[i].avatarItem.id == e.id) || (dp[i].avatarItem && dp[i].avatarItem.id == e.id))
                {
                    dp[i].count += 1;
                    // アイテムを減算した後、0個なら消去する
                    if(dp[i].count <= 0)
                    {
                        _itemList[_selectTabIndex].removeItemAt(i);
                        resetSelectItem();
                        // 使用できないようにする
                        itemInventoryPanelImage.offUse();
                    }
                    else
                    {
                        _selectItemCountA.text = int(dp[i].count+1).toString();
                        _selectItemCountB.text = dp[i].count.toString();
                    }
                    break;
                }
            }
        }

        // アバターが更新された時のイベント
        protected function avatarUpdateHandler(e:Event):void
        {
           if(_beforeGems.text != ""&& _afterGems.text != "")
           {
               _beforeGems.text = _avatar.gems.toString();
               _afterGems.text = _avatar.gems-_selectItem.price < 0 ? String(_avatar.gems-_selectItem.price) : (_avatar.gems-_selectItem.price).toString();
               _afterGems.styleName = _avatar.gems-_selectItem.price < 0 ? "ShopGemsNumericRed" : _selectItem.price > 0 ? "ShopGemsNumericYellow" : "ShopGemsNumeric";
           }
           if(_selectItem)
           {
               // モンスターコイン
               for(var i:int = 0; i < _selectItem.coins.length; i++)
               {
                   coinCalc(_beforeCoins[i], _afterCoins[i],  CharaCardDeck.binder.sortCharaCardId(Const.COIN_SET[i]), _selectItem.coins[i]);
               }
           }
        }

        // プレミアムアイテムかどうか
        protected function checkPremiumCoin(coins:Array):Boolean
        {
            return (coins[5] > 0)
        }

    }

}

