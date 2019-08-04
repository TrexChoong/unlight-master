package view.scene.rmshop
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.utils.*;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    import flash.geom.*;
    import flash.text.TextField;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import controller.LobbyCtrl;

    import model.*;
    import model.utils.*;
    import model.events.*;

    import view.scene.*;
    import view.scene.common.IInventoryClip;
    import view.scene.item.BaseInventoryClip;
    import view.scene.shop.*;
    import view.*;

    import view.image.BaseImage;
    import view.image.item.IItemBase;
    import view.image.rmshop.*;
    import view.image.shop.*;
    import view.utils.*;


    /**
     * クエストキャラ表示クラス
     *
     */
    public class RmItemClip extends BaseScene
    {

        // 翻訳データ
        CONFIG::LOCALE_JP
        {
            //CONFIG::LOCALE_JP <-漢字をチェックを無視する
            private static const _TRANS_MSG1	:String = "";
            //CONFIG::LOCALE_JP <-漢字をチェックを無視する
            private static const _TRANS_BUY		:String = "購入";
            //CONFIG::LOCALE_JP <-漢字をチェックを無視する
            private static const _TRANS_CURRENCY_MARK		:String = "";
            //CONFIG::LOCALE_JP <-漢字をチェックを無視する
            private static const _TRANS_CURRENCY		:String = "";
        }

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "Buy with Real-money.";
        CONFIG::LOCALE_EN
        private static const _TRANS_BUY		:String = "Buy";
        CONFIG::LOCALE_EN
        private static const _TRANS_CURRENCY_MARK		:String = '';
        CONFIG::LOCALE_EN
        private static const _TRANS_CURRENCY		:String = " credits";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "可以購買Credits的物品。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BUY		:String = "購買";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CURRENCY_MARK		:String = '';
        CONFIG::LOCALE_TCN
        private static const _TRANS_CURRENCY		:String = " credits";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "可用硬币购买的道具。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BUY		:String = "购买";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CURRENCY_MARK		:String = '';
        CONFIG::LOCALE_SCN
        private static const _TRANS_CURRENCY		:String = " credits";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1		:String = "모바코인으로 구입할 수 있는 아이템입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_BUY			:String = "구입";
        CONFIG::LOCALE_KR
        private static const _TRANS_CURRENCY_MARK	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_CURRENCY		:String = "원";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Objet que vous pouvez acheter avec vos Credits.";
        CONFIG::LOCALE_FR
        private static const _TRANS_BUY		:String = "Acheter";
        CONFIG::LOCALE_FR
        private static const _TRANS_CURRENCY_MARK		:String = '';
        CONFIG::LOCALE_FR
        private static const _TRANS_CURRENCY		:String = " credits";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "購入できるアイテムです";
        CONFIG::LOCALE_ID
        private static const _TRANS_BUY		:String = "購入";
        CONFIG::LOCALE_ID
        private static const _TRANS_CURRENCY_MARK		:String = '';
        CONFIG::LOCALE_ID
        private static const _TRANS_CURRENCY		:String = " 円";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "ไอเท็มที่ต้องใช้Credits ในการซื้อ";
        CONFIG::LOCALE_TH
        private static const _TRANS_BUY     :String = "ซื้อ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CURRENCY_MARK       :String = '';
        CONFIG::LOCALE_TH
        private static const _TRANS_CURRENCY        :String = " บาท";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private var _itemImage:RealMoneyItemImage;
        private var _label:Label = new Label();
        private var _coin:Label = new Label();
        private var _fbc_icon:TextField = new TextField();
        private var _description:TextArea = new TextArea();
        private var _button:Button = new Button();

        private var _shopInventoryClip:BaseInventoryClip;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["モバコインで購入できるアイテムです"],
                [_TRANS_MSG1],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _NORMAL_HELP:int = 0;

        private var _rmi:RealMoneyItem;

        // 支払方法変数設定
        public static function setSelPayType(selType:String):void
        {
            // __selPayType = selType;
        }

        /**
         * コンストラクタ
         *
         */
        public function RmItemClip(rmi:RealMoneyItem)
        {
//             log.writeLog(log.LV_INFO, this, "+++++++++++++++",rmi.id);
//             log.writeLog(log.LV_INFO, this, "+++++++++++++++",rmi.imageUrl);
//             log.writeLog(log.LV_INFO, this, "+++++++++++++++",rmi.name);
            _rmi = rmi;

            setClips(rmi);

            _label.text =_rmi.name;
            _label.x = 0;
            _label.width = 100;
            _label.height = 30;
            _label.styleName = "RmShopNameLabel";

            _fbc_icon.htmlText = _TRANS_CURRENCY_MARK;
            _fbc_icon.x      = -5;
            _fbc_icon.y      = 101;
            _fbc_icon.width  = 48;
            _fbc_icon.height = 48;
            _fbc_icon.mouseEnabled      = false;
            _fbc_icon.mouseWheelEnabled = false;
            _fbc_icon.multiline         = true;
            _fbc_icon.selectable        = false;
            _fbc_icon.visible           = true;
            _fbc_icon.wordWrap          = true;
            _coin.htmlText = _rmi.price.toString()+Const.COIN_STR;

            if(_TRANS_CURRENCY_MARK.length > 0){
                _coin.x = 24-5;
            }
            else{
                _coin.x = 0;
            }
            _coin.y = 115;
            _coin.width = 100;
            _coin.height = 30;
            _coin.styleName = "RmShopNameLabel";

            _description.text =_rmi.description;
            _description.x = 0;
            _description.y = 170;
            _description.width = 100;
            _description.height = 80;
            _description.styleName = "RmShopNameLabel";
            _description.selectable = false;
            _description.editable = false;

            initButton();

            _container.addChild(_label);
            _container.addChild(_fbc_icon);
            _container.addChild(_coin);
            _container.addChild(_description);
            _container.addChild(_button);
        }

        private function setClips(item:RealMoneyItem):void
        {
            switch (item.itemType)
            {
              case Shop.KIND_ITEM:
                  var ai:AvatarItem = AvatarItem.ID(item.itemID);
                  if ( item.imageFrame > 0 ) {
                      ai.shopImageFrame = item.imageFrame;
                  }
                  var itemClip:ShopItemInventoryClip = new ShopItemInventoryClip(ai, item.state);
                  itemClip.RMPrice = item.price;
                  itemClip.num = item.num;
                  itemClip.realMoneyItem = item;
                  itemClip.setPriceLabelVisible(false);
                  _shopInventoryClip = itemClip;
                  // 強引に変更してしまったので、後々影響のない様元に戻す
                  ai.shopImageFrame = 0;
                   break;
            case Shop.KIND_PART:
                  var partClip:ShopPartInventoryClip = new ShopPartInventoryClip(AvatarPart.ID(item.itemID), item.state);
                  partClip.RMPrice = item.price;
                  partClip.num = item.num;
                  partClip.realMoneyItem = item;
                  partClip.setPriceLabelVisible(false);
                  _shopInventoryClip = partClip;
                   break;
            case Shop.KIND_CHARA_CARD:
                  var cardClip:ShopSlotCardInventoryClip = new ShopSlotCardInventoryClip(CharaCard.ID(item.itemID), item.state);
                  cardClip.RMPrice = item.price;
                  cardClip.num = item.num;
                  cardClip.realMoneyItem = item;
                  cardClip.setPriceLabelVisible(false);
                  _shopInventoryClip = cardClip;
                  break;
            default:
                _itemImage = new RealMoneyItemImage(item.imageUrl);
                _itemImage.scaleX = _itemImage.scaleY = 0.5;
                _itemImage.y = 20;
                _itemImage.x = 5;
                _container.addChild(_itemImage);
                break;
            }
            if(_shopInventoryClip != null)
            {
            _shopInventoryClip.y = 20;
            _shopInventoryClip.x = 5;
            _shopInventoryClip.getShowThread(_container).start();
//            _shopInventoryClip.visible = false;
            }
        }


//         CONFIG::LOCALE_EN
//         private  function initButton():void
//         {
//             var loader:Loader = new Loader();
//             var req:URLRequest = new URLRequest("https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif");
//             loader.load(req);
//             loader.x = 0;
//             loader.y = 135;
//             addChild(loader);
//             loader.addEventListener(MouseEvent.CLICK, clickHandler);
//         }

//         CONFIG::LOCALE_JP
        private  function initButton():void
        {
//            _button.label = "購入";
            _button.label = _TRANS_BUY;
            _button.width = 50;
            _button.height = 25;
            _button.x = 23;
            _button.y = 135;
            _button.addEventListener(MouseEvent.CLICK, clickHandler);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
        }

        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {
//             log.writeLog(log.LV_INFO, this, "+++++++++++++++ image clip init");
            // 出すものをだす
            // addChild(_itemImage);
            addChild(_container);
            initilizeToolTipOwners();
            updateHelp(_NORMAL_HELP);
        }

        // 後始末処理
        public override function final():void
        {
//            removeChild(_itemImage);
            RemoveChild.apply(_container);
        }

        private function clickHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "CLICK");
        }

        private function yesHandler():void
        {
        }

    }
}
