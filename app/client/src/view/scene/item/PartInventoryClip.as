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
    import view.image.item.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.scene.common.IInventoryClip;
    import view.scene.common.*             ;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * PartInventoryClipの表示クラス
     * 
     */

    public class PartInventoryClip extends BaseInventoryClip
    {
        // 描画コンテナ
        protected var _container:UIComponent = new UIComponent();

        // アイテムパネル
        protected var _itemInventoryBaseImage:IItemBase;

        // アイテムの個数
        protected var _countLabel:Label = new Label();

        // アバターパーツ
        protected var _avatarPart:AvatarPart;
        // アバターパーツアイコン
        protected var _avatarPartIcon:AvatarPartIcon;
        // アイテムの個数
        protected var _count:int = 0;

        private var _equiped:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function PartInventoryClip(avatarPart:AvatarPart)
        {
            // アバターアイテムを保存
            _avatarPart = avatarPart;
                
            // アイテムを作成
            _avatarPartIcon = new AvatarPartIcon(_avatarPart);
//             _avatarPartClip.scaleX = 0.5;
//             _avatarPartClip.scaleY = 0.5;

//            Unlight.GCW.watch(_avatarItemIcon);
            setLabel()
            initItemBaseImage();

            _itemInventoryBaseImage.offEquip();
            _container.addChild(BaseImage(_itemInventoryBaseImage));
            mouseChildren = false;
            super();

        }
        protected function setLabel():void
        {
            // カウンターを作成
            _countLabel.x = 7;
            _countLabel.y = 72;
            _countLabel.width = 80;
            _countLabel.height = 30;
            _countLabel.text = "x" + _count;
            _countLabel.styleName = "ItemListNumericRight";
        }


        protected function initItemBaseImage():void
        {
            _itemInventoryBaseImage = new ItemInventoryBaseImage();

        }


        // 装備する
        override public function onEquip():void
        {
            _equiped = true;

            _itemInventoryBaseImage.onEquip();
        }

        // 装備を外す
        override public function offEquip():void
        {
            _equiped = false;
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
            _itemInventoryBaseImage.offSelect();
        }

        //
        public override function get avatarPart():AvatarPart
        {
            return _avatarPart;
        }

        // 
        public override function get avatarPartIcon():AvatarPartIcon
        {
            return _avatarPartIcon;
        }

        // 
        override public function get count():int
        {
            return _count;
        }

        // 
        override public function set count(c:int):void
        {
            _count = c;
            _countLabel.text = "x" + _count;
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

        // 
        public function get equiped():Boolean
        {
            return _equiped;
        }



        // 初期化
        public override function init():void
        {
            _avatarPartIcon.getShowThread(_container).start();
            _avatarPartIcon.x = 4 ;
            _avatarPartIcon.y = -8;
            _container.addChild(_countLabel);
            addChild(_container);
        }

        // 後処理
        public override function final():void
        {
            if (_avatarPartIcon != null)
            {
                _avatarPartIcon.getHideThread().start();
            };
            if (_itemInventoryBaseImage != null)
            {
                RemoveChild.apply(DisplayObject(_itemInventoryBaseImage));
            };
            RemoveChild.all(_container);
            RemoveChild.apply(_container);
            _avatarPartIcon = null;
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