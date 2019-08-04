package view.scene.shop
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import flash.utils.Dictionary;

    import flash.filters.GlowFilter;
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

    import view.image.common.AvatarItemImage;
    import view.image.shop.*;
    import view.scene.common.*;
    import view.scene.common.IInventoryClip;

    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;
    import view.utils.*;
    import view.scene.item.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ShopBaseInventoryClipの表示クラス
     *
     */

    public class ShopBaseInventoryClip  extends BaseInventoryClip
    {
        private static const _TRANS_CURRENCY_MARK:String = '';

        // 描画コンテナ
        protected var _container:UIComponent = new UIComponent();

        // アイテムパネル
        private var _shopInventoryBaseImage:ShopInventoryBaseImage;

        // アイテムの個数
        private var _priceLabel:Label = new Label();

        // アイテムデータ
        private var _itemClipList:ShopBaseItemClipList;

        // アイテムの個数
        private var _price:int = 0;
        private var _RMPrice:Number = 0;

        private var _realMoneyItem:RealMoneyItem;

        // アイテムの個数
        protected var _countLabel:Label = new Label();

        // アイテムの個数
        protected var _count:int = 0;
        // アイテムの個数
        private var _coins:Array = [];
        private var _coinImage:CoinImage;

        // 販売アイテムの状態
        private var _rmItemState:int = 0;

        // Icon表示
        private var _fbc_icon:TextField = new TextField();
        private var _signImage:SignImage = null;
        private static const _SIGN_X:int = 0;
        private static const _SIGN_Y:int = 42;
        private var _signCntLabel:Label = null;
        private static const _SIGN_LABEL_X:int = 30;
        private static const _SIGN_LABEL_Y:int = 18;
        private static const _SIGN_LABEL_W:int = 20;
        private static const _SIGN_LABEL_H:int = 20;
        private var _signContainer:UIComponent = new UIComponent();

        // label表示関連
        private static const _PRICE_LABEL_X:int = 7;
        private static const _PRICE_LABEL_Y:int = 72;
        private static const _PRICE_LABEL_W:int = 80;
        private static const _PRICE_LABEL_H:int = 30;
        private static const _COUNT_LABEL_X:int = 7;
        private static const _COUNT_LABEL_Y:int = 0;
        private static const _COUNT_LABEL_W:int = 80;
        private static const _COUNT_LABEL_H:int = 30;

        /**
         * コンストラクタ
         *
         */
        public function ShopBaseInventoryClip(item:*,itemType:int,state:int=0,isShop:Boolean=false,url:String="",frame:int=0)
        {
            // アイテムデータを保存、画像を作成
            _itemClipList = new ShopBaseItemClipList(item, itemType, isShop, url, frame);

            // カウンターを作成
            _priceLabel.x = _PRICE_LABEL_X;
            _priceLabel.y = _PRICE_LABEL_Y;
            _priceLabel.width = _PRICE_LABEL_W;
            _priceLabel.height = _PRICE_LABEL_H;
            _priceLabel.text = _price + "Gems";
            _priceLabel.styleName = "ItemListNumericRight";
            mouseChildren = false;

            _countLabel.x = _COUNT_LABEL_X;
            _countLabel.y = _COUNT_LABEL_Y;
            _countLabel.width = _COUNT_LABEL_W;
            _countLabel.height = _COUNT_LABEL_H;
            _countLabel.styleName = "ItemListNumericRight";

            _fbc_icon.htmlText = _TRANS_CURRENCY_MARK;
            _fbc_icon.x      = _PRICE_LABEL_X-5;
            _fbc_icon.y      = _PRICE_LABEL_Y-13;
            _fbc_icon.width  = 48;
            _fbc_icon.height = 48;
            _fbc_icon.mouseEnabled      = false;
            _fbc_icon.mouseWheelEnabled = false;
            _fbc_icon.multiline         = true;
            _fbc_icon.selectable        = false;
            _fbc_icon.visible           = true;
            _fbc_icon.wordWrap          = true;


            _rmItemState = state;
            _shopInventoryBaseImage = new ShopInventoryBaseImage(_rmItemState);
            _shopInventoryBaseImage.offEquip();
            _container.addChild(_shopInventoryBaseImage);
            super();
        }

        // 装備する
        override public function onEquip():void
        {
            _shopInventoryBaseImage.onEquip();
        }

        public override function getUpdateCount():int
        {
            if (  _itemClipList.item != null ) {
                switch (_itemClipList.type)
                {
                case ShopBaseItemClip.BASE_TYPE_ITEM:
                    _count =  AvatarItemInventory.getItemsNum(_itemClipList.item.id);
                    break;
                case ShopBaseItemClip.BASE_TYPE_PART:
                    _count =  AvatarPartInventory.getItemsNum(_itemClipList.item.id);
                    break;
                case ShopBaseItemClip.BASE_TYPE_CARD:
                    _count = _itemClipList.item.num;
                    break;
                case ShopBaseItemClip.BASE_TYPE_DECK:
                    _count = _itemClipList.item.num;
                    break;
                default:
                }
            }
            return _count;
        }

        // 装備を外す
        override public function offEquip():void
        {
            _shopInventoryBaseImage.offEquip();
        }

        // 選択する
        override public function onSelect():void
        {
            _shopInventoryBaseImage.onSelect();
        }

        // 装備を外す
        override public function offSelect():void
        {
            _shopInventoryBaseImage.offSelect();
        }
        protected function setCoinImage():void
        {
            _coinImage = new CoinImage;
            _coinImage.x = 3;
            _coinImage.y = 74;
            _container.addChild(_coinImage);
        }

        //
        override public function get avatarItem():AvatarItem
        {
            return _itemClipList.avatarItem;
        }

        //
        override public function get avatarItemImage():AvatarItemImage
        {
            return _itemClipList.avatarItemImage;
        }

        //
        public override function get avatarPart():AvatarPart
        {
            return _itemClipList.avatarPart;
        }

        //
        public override function get avatarPartIcon():AvatarPartIcon
        {
            return _itemClipList.avatarPartIcon;
        }

        //
        override public function get card():ICard
        {
            return _itemClipList.card;
        }

        //
        public function get cardClip():*
        {
            return _itemClipList.cardClip;
        }

        //
        public function get deck():ICard
        {
            return _itemClipList.deck;
        }

        //
        public function get deckImage():AvatarItemImage
        {
            return _itemClipList.deckImage;
        }

        //
        override public function get price():int
        {
            return _price;
        }

        //
        override public function set price(c:int):void
        {
            _price = c;
            _priceLabel.text = _price + "Gems";
            _fbc_icon.visible = false;
        }

        // モンスターコイン
        public override function get coins():Array
        {
            return _coins;
        }

        // モンスターコイン
        public override function set coins(c:Array):void
        {
//            log.writeLog(log.LV_INFO, this, "coin+++",c.toString());
            if(c.toString() != "0,0,0,0,0,0")
            {
                setCoinImage();
            }
            _coins = c;
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
        }

        public function set num(n:int):void
        {
            _countLabel.text = "x" + n;
            _container.addChild(_countLabel);
        }

        public  function get RMPrice():Number
        {
            return _RMPrice;
        }

        public  function set RMPrice(c:Number):void
        {
            _RMPrice = c;
            _priceLabel.text = _RMPrice + Const.COIN_STR
            _fbc_icon.visible = true;
        }

        public function set realMoneyItem(rm:RealMoneyItem):void
        {
            _realMoneyItem = rm;
            setSign();
            _itemClipList.setRmItem(rm);
        }

        override public function get realMoneyItem():RealMoneyItem
        {
            return _realMoneyItem
        }

        private function setSign():void
        {
            if ( _realMoneyItem && _realMoneyItem.extraId != 0 && Const.SHOP_SIGN_RMITEM_IDS.indexOf(_realMoneyItem.extraId) != -1 ) {
                if ( _signImage == null ) {
                    _signImage = new SignImage();
                    _signImage.x = _SIGN_X;
                    _signImage.y = _SIGN_Y;
                    _signImage.mouseEnabled = false;
                    _signImage.mouseChildren = false;
                    if ( _signCntLabel == null ) {
                        _signCntLabel = new Label();
                        _signCntLabel.x = _SIGN_LABEL_X;
                        _signCntLabel.y = _SIGN_LABEL_Y;
                        _signCntLabel.width = _SIGN_LABEL_W;
                        _signCntLabel.height = _SIGN_LABEL_H;
                        _signCntLabel.setStyle("fontSize",10);
                        _signCntLabel.text = "x"+RealMoneyItem.ID(_realMoneyItem.extraId).num;
                        _signCntLabel.filters  = [new GlowFilter(0xFFFFFF, 1, 3, 3, 4, 1),
                                                  new DropShadowFilter(0, 45, 0xFFFFFF, 1.0, 3, 3, 4, 1, false)];
                        _signImage.addChild(_signCntLabel);
                    }
                    _signContainer.addChild(_signImage);
                }
            }
        }

       // 初期化
        public override function init():void
        {
            setSign();

            _container.addChild(_priceLabel);
            addChild(_container);
            addChild(_signContainer);
            _itemClipList.getShowThread(_container, 1).start();
        }

        // 後処理
        public override function final():void
        {
            if (_itemClipList.image != null)
            {
                _itemClipList.getHideThread().start();
            };

            if (_shopInventoryBaseImage != null)
            {
                RemoveChild.apply(DisplayObject(_shopInventoryBaseImage));
            };

            RemoveChild.all(_container);
            RemoveChild.apply(_container);
            RemoveChild.all(_signContainer);
            RemoveChild.apply(_signContainer);
        }

        public function setPriceLabelVisible(flag:Boolean):void
        {
            _priceLabel.visible = flag;
            _fbc_icon.visible = flag
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
import org.libspark.thread.utils.ParallelExecutor;

import model.RealMoneyItem;
import model.AvatarItem;
import model.AvatarPart;
import model.CharaCard;
import model.WeaponCard;
import model.EventCard;
import model.ICard;

import view.BaseShowThread;
import view.IViewThread;
import view.image.common.AvatarItemImage;
import view.scene.common.AvatarClip;
import view.scene.common.AvatarPartIcon;
import view.scene.common.CharaCardClip;
import view.scene.common.WeaponCardClip;
import view.scene.common.EquipCardClip;
import view.scene.common.EventCardClip;
import view.scene.common.IInventoryClip;
import view.scene.shop.ShopBaseItemClip;


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

/**
 * ShopBaseItemClipをセットにするクラス
 *
 */
class ShopBaseItemClipList
{
    private var _clipList:Vector.<ShopBaseItemClip> = new Vector.<ShopBaseItemClip>();
    private var _type:int = ShopBaseItemClip.BASE_TYPE_ITEM;
    private var _rmItem:RealMoneyItem = null;

    // Array [ x,y,scale ]
    private const _ITEM_REPOS_PARAMS:Vector.<Vector.<Array>> = Vector.<Vector.<Array>>(
        [
            Vector.<Array>([ [0,0,1] ]),
            Vector.<Array>([ [-10,-8,1.4],[8,8,1.4] ]),
            Vector.<Array>([ [2,-10,1.6],[-10,10,1.6],[10,10,1.6] ]),
            Vector.<Array>([ [-12,-10,1.8],[12,-10,1.8],[-12,10,1.8],[12,10,1.8] ]),
            Vector.<Array>([ [-8,-14,2],[8,-14,2],[-15,4,2],[15,4,2],[0,12,2] ]),
            Vector.<Array>([ [-17,-14,2.2],[0,-14,2.2],[17,-14,2.2],[-17,14,2.2],[0,14,2.2],[17,14,2.2] ])
            ]);
    // Array [ x,y,scale ]
    private const _PART_REPOS_PARAMS:Vector.<Vector.<Array>> = Vector.<Vector.<Array>>(
        [
            Vector.<Array>([ [0,0,1] ]),
            Vector.<Array>([ [0,0,1.7],[26,26,1.7] ]),
            Vector.<Array>([ [17,0,2],[0,32,2],[32,32,2] ]),
            Vector.<Array>([ [0,0,2],[32,0,2],[0,32,2],[32,32,2] ]),
            Vector.<Array>([ [7,0,2.3],[28,0,2.3],[0,23,2.3],[36,23,2.3],[17,36,2.3] ]),
            Vector.<Array>([ [0,6,2.5],[18,6,2.5],[38,6,2.5],[0,32,2.5],[18,32,2.5],[38,32,2.5] ])
            ]);
    // Array [ x,y,scale ]
    private const _CARD_REPOS_PARAMS:Vector.<Vector.<Array>> = Vector.<Vector.<Array>>(
        [
            Vector.<Array>([ [0,0,1] ]),
            Vector.<Array>([ [-5,0,1.4],[17,20,1.4] ]),
            Vector.<Array>([ [7,0,1.5],[-9,23,1.5],[23,23,1.5] ]),
            Vector.<Array>([ [-7,0,1.6],[23,0,1.6],[-7,23,1.6],[23,23,1.6] ]),
            Vector.<Array>([ [-3,0,1.8],[20,0,1.8],[-9,18,1.8],[27,18,1.8],[9,28,1.8] ]),
            Vector.<Array>([ [-9,2,2],[10,2,2],[30,2,2],[-9,32,2],[10,32,2],[30,32,2] ])
            ]);
    private const _REPOS_PARAMS_LIST:Vector.<Vector.<Vector.<Array>>> = Vector.<Vector.<Vector.<Array>>>(
        [
            _ITEM_REPOS_PARAMS,
            _PART_REPOS_PARAMS,
            _CARD_REPOS_PARAMS
            ]);

    private const _REPOS_PARAM_X_IDX:int = 0;
    private const _REPOS_PARAM_Y_IDX:int = 1;
    private const _REPOS_PARAM_SCALE_IDX:int = 2;

    public function ShopBaseItemClipList(item:*,type:int,isShop:Boolean=false,url:String="",frame:int=0):void
    {
        // 最初に入れたアイテムのタイプを保存しておく
        _type = type;
        _clipList.push(new ShopBaseItemClip(item,type,isShop,url,frame));
    }

    public function setRmItem(rmItem:RealMoneyItem):void
    {
        _rmItem = rmItem;
        if ( _rmItem.isSetSale && _type != ShopBaseItemClip.BASE_TYPE_DECK ) {
            var sets:Vector.<RealMoneyItem> = _rmItem.setItems;
            for ( var i:int = 0; i < sets.length; i++ ) {
                pushBaseItemClip(sets[i]);
            }
            // 位置の調整
            resetPositions();
        }
    }

    private function pushBaseItemClip(rmItem:RealMoneyItem):void
    {
        if ( rmItem ) {
            switch (rmItem.itemType)
            {
            case RealMoneyItem.RM_ITEM_TYPE_ITEM:
                var ai:AvatarItem = AvatarItem.ID(rmItem.itemID);
                if ( rmItem.imageFrame > 0 ) {
                    ai.shopImageFrame = rmItem.imageFrame;
                }
                pushClip(ai,ShopBaseItemClip.BASE_TYPE_ITEM);
                // 強引に変更してしまったので、後々影響のない様元に戻す
                ai.shopImageFrame = 0;
                break;
            case RealMoneyItem.RM_ITEM_TYPE_PART:
                pushClip(AvatarPart.ID(rmItem.itemID),ShopBaseItemClip.BASE_TYPE_PART);
                break;
            case RealMoneyItem.RM_ITEM_TYPE_CHARA:
                pushClip(CharaCard.ID(rmItem.itemID),ShopBaseItemClip.BASE_TYPE_CARD);
                break;
            case RealMoneyItem.RM_ITEM_TYPE_WEAPON:
                pushClip(WeaponCard.ID(rmItem.itemID),ShopBaseItemClip.BASE_TYPE_CARD);
                break;
            case RealMoneyItem.RM_ITEM_TYPE_EVENT:
                pushClip(EventCard.ID(rmItem.itemID),ShopBaseItemClip.BASE_TYPE_CARD);
                break;
            default:
                break;
            }
        }
    }
    private function pushClip(item:*,type:int,isShop:Boolean=false):void
    {
        _clipList.push(new ShopBaseItemClip(item,type,isShop));
    }
    private function resetPositions():void
    {
        var len:int = _clipList.length;
        var key:int = len - 1;
        if ( key <= 0 ) key = 0;
        var type:int;
        for ( var i:int = 0; i < len; i++ ) {
            type = _clipList[i].type;
            log.writeLog(log.LV_INFO, this ,"resetPositions",type,key,i);
            _clipList[i].x = _clipList[i].baseX + _REPOS_PARAMS_LIST[type][key][i][_REPOS_PARAM_X_IDX];
            _clipList[i].y = _clipList[i].baseY + _REPOS_PARAMS_LIST[type][key][i][_REPOS_PARAM_Y_IDX];
            _clipList[i].scale = _clipList[i].baseScale / Number(_REPOS_PARAMS_LIST[type][key][i][_REPOS_PARAM_SCALE_IDX]);
        }
    }

    public function get type():int
    {
        return _type;
    }

    public function get item():*
    {
        return _clipList[0].item;
    }

    public function get image():*
    {
        return _clipList[0].image;
    }

    //
    public function get avatarItem():AvatarItem
    {
        if ( _type == ShopBaseItemClip.BASE_TYPE_ITEM ) {
            return _clipList[0].item;
        }
        return null;
    }

    //
    public function get avatarItemImage():AvatarItemImage
    {
        if ( _type == ShopBaseItemClip.BASE_TYPE_ITEM ) {
            return _clipList[0].image;
        }
        return null;
    }

    //
    public function get avatarPart():AvatarPart
    {
        if ( _type == ShopBaseItemClip.BASE_TYPE_PART ) {
            return _clipList[0].item;
        }
        return null;
    }

    //
    public function get avatarPartIcon():AvatarPartIcon
    {
        if ( _type == ShopBaseItemClip.BASE_TYPE_PART ) {
            return _clipList[0].image;
        }
        return null;
    }

    //
    public function get card():ICard
    {
        if ( _type == ShopBaseItemClip.BASE_TYPE_CARD ) {
            return _clipList[0].item;
        }
        return null;
    }

    //
    public function get cardClip():*
    {
        if ( _type == ShopBaseItemClip.BASE_TYPE_CARD ) {
            return _clipList[0].image;
        }
        return null;
    }

    //
    public function get deck():ICard
    {
        if ( _type == ShopBaseItemClip.BASE_TYPE_DECK ) {
            return _clipList[0].item;
        }
        return null;
    }

    //
    public function get deckImage():AvatarItemImage
    {
        if ( _type == ShopBaseItemClip.BASE_TYPE_ITEM ) {
            return _clipList[0].image;
        }
        return null;
    }

    // 表示用スレッドを返す
    public function getShowThread(stage:DisplayObjectContainer,at:int= -1):Thread
    {
        var pExec:ParallelExecutor = new ParallelExecutor();
        for ( var i:int = 0; i < _clipList.length; i++ ) {
            pExec.addThread(_clipList[i].getShowThread(stage, at));
        }
        return pExec;
    }

    // 非表示用スレッドを返す
    public function getHideThread():Thread
    {
        var pExec:ParallelExecutor = new ParallelExecutor();
        for ( var i:int = 0; i < _clipList.length; i++ ) {
            pExec.addThread(_clipList[i].getHideThread());
        }
        return pExec;
    }
}