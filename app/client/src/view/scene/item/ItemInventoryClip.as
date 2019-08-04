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
    import model.events.AvatarItemEvent;


    import view.*;
    import view.utils.*;
    import view.image.BaseImage;
    import view.image.common.AvatarItemImage;
    import view.image.item.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.scene.common.IInventoryClip;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ItemInventoryClipの表示クラス
     * 
     */

    public class ItemInventoryClip extends BaseInventoryClip
    {
        // 描画コンテナ
        protected var _container:UIComponent = new UIComponent();

        // アイテムパネル
        protected var _itemInventoryBaseImage:IItemBase;
        // アイテムの個数
        protected var _countLabel:Label = new Label();

        // アイテム情報
        protected var _inventoryData:ItemInventoryClipData;
        // アバターアイテム
        protected var _avatarItemImage:AvatarItemImage;

        // ショップ表示か
        private var _isShop:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function ItemInventoryClip(avatarItem:AvatarItem, isShop:Boolean = false, invData:ItemInventoryClipData=null)
        {
            log.writeLog(log.LV_INFO, this ,"ItemInventoryClip Create.",isShop );

            _isShop = isShop;

            // アバターアイテムを保存
            _inventoryData = new ItemInventoryClipData(avatarItem);
            //_inventoryData = (invData) ? invData : new ItemInventoryClipData(avatarItem);
            if (invData) {_inventoryData.count = invData.count}
            initAvatarItemImage();
//            Unlight.GCW.watch(_avatarItemImage);
            setLabel()
            initItemBaseImage();

            _itemInventoryBaseImage.offEquip();
            _container.addChild(BaseImage(_itemInventoryBaseImage));
            mouseChildren = false;
            super();
        }

        protected function initAvatarItemImage():void
        {
            // アイテムを作成
            // ショップでの表示フレーム指定がある場合、そちらで表示
            var imageFrame:int = 0;
            if ( _isShop && _inventoryData.shopImageFrame > 0 ) {
                imageFrame = _inventoryData.shopImageFrame;
            } else {
                imageFrame = _inventoryData.imageFrame;
            }
            // log.writeLog(log.LV_INFO, this ,"#####!!!!! imageFrame,shopImageFrame", _inventoryData.imageFrame,_inventoryData.shopImageFrame);
            // log.writeLog(log.LV_INFO, this ,"#####!!!!!", _inventoryData.image,imageFrame);

            _avatarItemImage = new AvatarItemImage(_inventoryData.image, imageFrame);
            _avatarItemImage.x = 44;
            _avatarItemImage.y = 44;
            _avatarItemImage.scaleX = 0.5;
            _avatarItemImage.scaleY = 0.5;

        }

        protected function setLabel():void
        {
            // カウンターを作成
            _countLabel.x = 7;
            _countLabel.y = 72;
            _countLabel.width = 80;
            _countLabel.height = 30;
            _countLabel.text = "x" + _inventoryData.count;
            _countLabel.styleName = "ItemListNumericRight";
        }


        protected function initItemBaseImage():void
        {
            _itemInventoryBaseImage = new ItemInventoryBaseImage();
//            Unlight.GCW.watch(_itemInventoryBaseImage);

        }


        // 装備する
        override public function onEquip():void
        {
            _itemInventoryBaseImage.onEquip();
        }

        // 装備を外す
        override public function offEquip():void
        {
            _itemInventoryBaseImage.offEquip();
        }

        // 選択する
        override public function onSelect():void
        {
            _itemInventoryBaseImage.onSelect();
        }

        // 装備を外す
        override public function offSelect():void
        {
            if(_itemInventoryBaseImage != null)
            {
                _itemInventoryBaseImage.offSelect();
            }
        }

        // 
        override public function get avatarItem():AvatarItem
        {
            return _inventoryData.item;
        }

        // 
        override public function get avatarItemImage():AvatarItemImage
        {
            return _avatarItemImage;
        }

        // 
        override public function get count():int
        {
            return _inventoryData.count;
        }

        // 
        override public function set count(c:int):void
        {
            _inventoryData.count = c;
            _countLabel.text = "x" + _inventoryData.count;
        }
        // 
        override public function get price():int
        {
            return 0;
        }

        // 
        override public function set price(c:int):void
        {
        }

        // 
        override public function get coins():Array
        {
            return [0,0,0,0,0];
        }

        // 
        override public function set coins(c:Array):void
        {
        }

        override public function get card():ICard
        {
            return null;
        }

        public function get inventoryData():ItemInventoryClipData
        {
            return _inventoryData;
        }


        // 初期化
        public override function init():void
        {
            if(_avatarItemImage==null)
            {
                initAvatarItemImage();
                initItemBaseImage();
                _itemInventoryBaseImage.offEquip();
                _container.addChild(BaseImage(_itemInventoryBaseImage));
            }
                _avatarItemImage.getShowThread(_container).start();
                _container.addChild(_countLabel);
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
            RemoveChild.all(_container);
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