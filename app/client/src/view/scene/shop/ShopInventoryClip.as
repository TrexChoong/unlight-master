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
    import model.events.AvatarItemEvent;

    import view.*;
    import view.utils.*;
    import view.image.common.AvatarItemImage;
    import view.image.common.AvatarItemImage;
    import view.scene.common.IInventoryClip;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ShopInventoryClipの表示クラス
     * 
     */

    public class ShopInventoryClip extends BaseScene implements IInventoryClip
    {
        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // アイテムパネル
        private var _shopInventoryBaseImage:ShopInventoryBaseImage = new ShopInventoryBaseImage();
        // アイテムの個数
        private var _priceLabel:Label = new Label();

        // アバターアイテム
        private var _avatarItem:AvatarItem;
        // アバターアイテム
        private var _avatarItemImage:AvatarItemImage;
        // アイテムの個数
        private var _count:int = 0;
        // アイテムの個数
        private var _price:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function ShopInventoryClip(avatarItem:AvatarItem)
        {
            // アバターアイテムを保存
            _avatarItem = avatarItem;

            // アイテムを作成
            _avatarItemImage = new AvatarItemImage(_avatarItem.image, _avatarItem.imageFrame);
            _avatarItemImage.x = 44;
            _avatarItemImage.y = 44;
            _avatarItemImage.scaleX = 0.5;
            _avatarItemImage.scaleY = 0.5;

            // カウンターを作成
            _priceLabel.x = 7;
            _priceLabel.y = 72;
            _priceLabel.width = 80;
            _priceLabel.height = 30;
            _priceLabel.text = _price + "Gems";
            _priceLabel.styleName = "ItemListNumericRight";

            _shopInventoryBaseImage.offEquip();
            _container.addChild(_shopInventoryBaseImage);
        }

        // 装備する
        public function onEquip():void
        {
            _shopInventoryBaseImage.onEquip();
        }

        // 装備を外す
        public function offEquip():void
        {
            _shopInventoryBaseImage.offEquip();
        }

        // 選択する
        public function onSelect():void
        {
            _shopInventoryBaseImage.onSelect();
        }

        // 装備を外す
        public function offSelect():void
        {
            _shopInventoryBaseImage.offSelect();
        }

        // 
        public function get avatarItem():AvatarItem
        {

            return _avatarItem;
        }

        // 
        public function get avatarItemImage():AvatarItemImage
        {
            return _avatarItemImage;
        }

        // 
        public function get price():int
        {
            return _price;
        }

        // 
        public function set price(c:int):void
        {
            _price = c;
            _priceLabel.text = _price + "Gems";
        }

        // 
        public function get count():int
        {
            return _count;
        }

        // 
        public function set count(c:int):void
        {
            _count = c;
        }

        // 初期化
        public override function init():void
        {
            _avatarItemImage.getShowThread(_container).start();
            _container.addChild(_priceLabel);
            addChild(_container);
        }

        // 後処理
        public override function final():void
        {
            if (_avatarItemImage != null)
            {
                _avatarItemImage.getHideThread().start();
            };
            if (_itemInventoryBaseImage != null)
            {
                RemoveChild.apply(DisplayObject(_itemInventoryBaseImage));
            };
            RemoveChild.apply(_container);
            _avatarItemImage = null;
            _itemInventoryBaseImage = null;
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
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