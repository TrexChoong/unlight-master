package view
{

    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.utils.Dictionary;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Shop;
    import model.Player;
    import model.CharaCard;
    import model.events.AvatarSaleEvent;
    import model.events.RaidHelpEvent;

    import view.scene.common.*;
    import view.scene.shop.*;
    import view.image.shop.*;
    import view.utils.*;

    import controller.LobbyCtrl;
    import controller.GlobalChatCtrl;

    /**
     * ショップビューのビュークラス
     *
     */
    public class ShopView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_SHOP	:String = "アイテムショップ";

        CONFIG::LOCALE_EN
        private static const _TRANS_SHOP	:String = "Item Shop";

        CONFIG::LOCALE_TCN
        private static const _TRANS_SHOP	:String = "道具商店";

        CONFIG::LOCALE_SCN
        private static const _TRANS_SHOP	:String = "道具商店";

        CONFIG::LOCALE_KR
        private static const _TRANS_SHOP	:String = "아이템 샵";

        CONFIG::LOCALE_FR
        private static const _TRANS_SHOP	:String = "Magasin d'objets";

        CONFIG::LOCALE_ID
        private static const _TRANS_SHOP	:String = "アイテムショップ";

        CONFIG::LOCALE_TH
        private static const _TRANS_SHOP    :String = "Item Shop";


        // 親ステージ
        private var _stage:Sprite;

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // ビューのステート
        private var _state:int;

        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // アバタービュー
        private var _avatarView:AvatarView;

        // パネルの番号
        private static const _ITEM:int       = 0;
        private static const _CARD:int       = 1;
        private static const _BODY:int       = 2;
        private static const _CLOTH:int      = 3;
        private static const _ACC:int        = 4;
        private static const _PREMIUM:int    = 5;


        // アイテムボタン 0
        private var _shopItemButton:ShopItemButton = new ShopItemButton(_ITEM);
        // カードボタン 1
        private var _shopCardButton:ShopCardButton = new ShopCardButton(_CARD);
        // ボディボタン 2
        private var _shopBodyButton:ShopBodyButton = new ShopBodyButton(_BODY);
        // 衣装ボタン 3
        private var _shopClothButton:ShopClothButton = new ShopClothButton(_CLOTH);
        // アクセサリボタン 4
        private var _shopAccButton:ShopAccButton = new ShopAccButton(_ACC);

        // プレミアボタン 6
        private var _shopPremiumButton:ShopPremiumButton = new ShopPremiumButton(_PREMIUM);


        // 試着ボタン
        private var _shopEquipButton:ShopEquipButton = new ShopEquipButton;



        // アイテムインベントリイメージ
        private var _shopInventoryImage:ShopInventoryImage = new ShopInventoryImage;


        // アイテムインベントリパネル
        private var _shopItemListPanel:ShopItemListPanel = new ShopItemListPanel;
        // アイテムインベントリパネル
        private var _shopSlotCardListPanel:ShopSlotCardListPanel = new ShopSlotCardListPanel;
        // アイテムインベントリパネル
        private var _shopBodyListPanel:ShopBodyListPanel = new ShopBodyListPanel;
        // アイテムインベントリパネル
        private var _shopClothListPanel:ShopClothListPanel = new ShopClothListPanel;
        // アイテムインベントリパネル
        private var _shopAccListPanel:ShopAccListPanel = new ShopAccListPanel;

        // アイテムインベントリパネル
        private var _shopPremiumListPanel:ShopPremiumListPanel = new ShopPremiumListPanel;






        // アイテムパネルの配列
        private var _shopListPanelSet:Array = [_shopItemListPanel, _shopSlotCardListPanel,_shopBodyListPanel,_shopClothListPanel,_shopAccListPanel,_shopPremiumListPanel];
        // アイテムパネルの配列
        private var _shopListPanelShowedSet:Array = [false, false,false,false,false,false,false];

        // アイテム選択ボタンの配列
        private var _shopListButtonlSet:Array = [_shopItemButton, _shopCardButton, _shopBodyButton,_shopClothButton, _shopAccButton,_shopPremiumButton];


        // 店主
        private var _shopMaster:ShopMaster = new ShopMaster;

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 100;
        private const _TITLE_HEIGHT:int = 25;


        private const _SHOP_PANEL_X:int = 0;
        private const _SHOP_PANEL_Y:int = 0;

        // ステート定数
        private static const _START:int = 0;               // 開始
        private static const _WAIT:int = 1;                // 待機
        private static const _END:int = 2;                 // 終了

        private var _player:Player = Player.instance;


        //
        private var _shop:Shop;
        // 位置定数

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function ShopView(stage:Sprite, type:int)
        {
            // タイプのショップオブジェクトを読み込む
            _shop = Shop.ID(type);
            _stage = stage;

            _container.addChild(_shopInventoryImage);
            _container.addChild(_shopItemButton);
            _container.addChild(_shopCardButton);
            _container.addChild(_shopBodyButton);
            _container.addChild(_shopAccButton);
            _container.addChild(_shopClothButton);
            _container.addChild(_shopPremiumButton);
            if(CharaCard.ID(10011).num == 0)
            {
                _shopPremiumButton.visible = false;
            }
            _container.addChild(_shopEquipButton);

//            _container.addChild(_shopMaster);

            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_MATCH);

            _state = _START;

            RaidHelpView.instance.isUpdate = true;
        }

        // スレッドのスタート
        override protected function run():void
        {
            log.writeLog(log.LV_FATAL, this, "run");
            next(waitLoading);


        }

        // ショップデータが送られてくるのを待つ
        private function waitLoading():void
        {
            // ショップデータが読み込み済みか調べる
            if (_shop.loaded == false)
            {
                _shop.wait();
            }
            next(initShopPanel);
        }

        // アイテムデータが送られてくるのを待つ
        private function initShopPanel():void
        {
            log.writeLog(log.LV_DEBUG, "[ShopView] initShopPanel.");
            _shopListPanelSet.forEach(function(item:*, index:int, array:Array):void{
                   item.x = _SHOP_PANEL_X;
                   item.y = _SHOP_PANEL_Y;
                });


//             _shopSlotCardListPanel.x = _SHOP_PANEL_X;
//             _shopSlotCardListPanel.y = _SHOP_PANEL_Y;

            next(createItemData);
        }


        // 所持するアイテムデータを生成する
        private function createItemData():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getShowThread(_container,1));

            // _shopListPanelSet.forEach(function(item:*, index:int, array:Array):void{
            //        pExec.addThread(item.getShowThread(_container,index+1));
            //     });

            pExec.addThread(_shopListPanelSet[0].getShowThread(_container,1));
            _shopListPanelShowedSet[0] = true;

            pExec.start();
            pExec.join();

            next(initTitle);
        }

        // タイトルの初期化
        private function initTitle():void
        {
            _shopListPanelSet.forEach(function(item:*, index:int, array:Array):void{item.visible = true;});
//             _shopItemListPanel.visible = true;
//             _shopSlotCardListPanel.visible = true;

            _container.alpha = 0.0;

            _title.x = _TITLE_X;
            _title.y = _TITLE_Y;
            _title.width = _TITLE_WIDTH;
            _title.height = _TITLE_HEIGHT;
            _title.text = "ItemShop";
            _title.styleName = "EditTitleLabel";
            _title.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _title.alpha = 0.0;
            _title.mouseChildren = false;
            _title.mouseEnabled = false;

            _titleJ.x = _TITLE_X + 85;
            _titleJ.y = _TITLE_Y + 7;
            _titleJ.width = _TITLE_WIDTH;
            _titleJ.height = _TITLE_HEIGHT;
//            _titleJ.text = "アイテムショップ";
            _titleJ.text = _TRANS_SHOP;
            _titleJ.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _titleJ.alpha = 0.0;
            _titleJ.mouseChildren = false;
            _titleJ.mouseEnabled = false;

            _container.addChild(_title);
            _container.addChild(_titleJ);

            next(initGems);
        }

        // タイトルの初期化
        private function initGems():void
        {
            next(show);
        }

        // 表示させる
        private function show():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:1.0}, null, 0.2/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:1.0}, null, 0.2/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:1.0}, null, 0.2/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            pExec.start();
            pExec.join();

            _state = _WAIT;
            _stage.addChild(_container);

            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);

            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            _shopListButtonlSet.forEach(function(item:*, index:int, array:Array):void{item.addEventListener(MouseEvent.CLICK, pushItemButtonHandler)});
            showPanel(_ITEM);
            next(waiting);
        }

        // ループ部分
        private function waiting():void
        {
            // ステートでループ
            if (_player.state == Player.STATE_LOGOUT)
            {
                 next(hide);
            }else if(_state == _WAIT)
            {
                next(waiting);
            }
            else if(_state == _END)
            {
                next(hide);
            }

        }

        // アイテム購入画面に移行
        private function pushItemButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            log.writeLog(log.LV_FATAL, this, "click",e.currentTarget);

            // セール中で、課金タブをクリックしたら、残り時間を表示
            if (Player.instance.avatar.isSaleTime) {

            }

            showPanel(_shopListButtonlSet.indexOf(e.currentTarget));
        }


        private function showPanel(i:int):void
        {
            if (_shopListPanelShowedSet[i] == false)
            {
                _shopListPanelSet[i].getShowThread(_container,i+1).start();
                _shopListPanelShowedSet[i]= true;
            }

            _shopListPanelSet.forEach(function(item:*, index:int, array:Array):void{item.visible = false;});
            _shopListButtonlSet.forEach(function(item:*, index:int, array:Array):void{item.offButton()});
            _shopListPanelSet[i].visible = true;
            _shopListButtonlSet[i].onButton();
        }




        // 描画オブジェクトを消去
        private function hide():void
        {
            RaidHelpView.instance.isUpdate = false;

            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            next(exit);
        }

        // 終了
        private function exit():void
        {
            _shopListPanelSet.forEach(function(item:*, index:int, array:Array):void{item.getHideThread().start();});
//             _shopItemListPanel.getHideThread().start();
//             _shopSlotCardListPanel.getHideThread().start();

            _shopListButtonlSet.forEach(function(item:*, index:int, array:Array):void{item.removeEventListener(MouseEvent.CLICK, pushItemButtonHandler)});

            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);

            Player.instance.avatar.removeEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);

            // レイドヘルプイベント
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);
        }

        // 終了関数
        override protected  function finalize():void
        {

            log.writeLog (log.LV_WARN,this,"ShopView end");
            RemoveChild.all(_container);

            _shop = null;
            _shopItemButton= null;
            _shopAccButton= null;
            _shopEquipButton= null;
            _shopInventoryImage= null;
            _shopItemListPanel= null;
            _shopSlotCardListPanel= null;
            _shopBodyListPanel= null;
            _shopClothListPanel= null;
            _shopAccListPanel= null;
            _shopPremiumListPanel= null;
            _shopListPanelSet= null;
            _shopMaster= null;

        }

        // 終了
        private function exitButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            exitHandler(e);
            log.writeLog(log.LV_INFO, this, "push exit");
        }

        // 終了時のハンドラ。他のViewから呼んだときはここだけ呼ぶ予定
        private function exitHandler(e:MouseEvent):void
        {
            _state = _END;
        }

        // レイドヘルプハンドラ
        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _state = _END;
            log.writeLog(log.LV_INFO, this, "raid help");
        }

        // セールの終了判定が出たときのハンドラ
        private function saleFinishHandler(e:AvatarSaleEvent):void
        {

        }


   }
}
