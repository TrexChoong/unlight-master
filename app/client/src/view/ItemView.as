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

    import model.*;
    import model.events.*;
//     import model.AvatarItemInventory;
//     import model.events.AvatarItemEvent;
//     import view.image.common.AvatarItemImage;

    import view.image.item.*;
    import view.image.shop.*;
    import view.scene.item.*;
    import view.scene.common.*;
    import view.utils.*;

    import controller.LobbyCtrl;
    import controller.GlobalChatCtrl;

    /**
     * アバターアイテムビューのビュークラス
     *
     */
    public class ItemView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_TITLE	:String = "所持品情報";

        CONFIG::LOCALE_EN
        private static const _TRANS_TITLE	:String = "Inventory";

        CONFIG::LOCALE_TCN
        private static const _TRANS_TITLE	:String = "所持品訊息";

        CONFIG::LOCALE_SCN
        private static const _TRANS_TITLE	:String = "所持之物的信息";

        CONFIG::LOCALE_KR
        private static const _TRANS_TITLE	:String = "소지품 정보";

        CONFIG::LOCALE_FR
        private static const _TRANS_TITLE	:String = "Possessions";

        CONFIG::LOCALE_ID
        private static const _TRANS_TITLE	:String = "所持品情報";

        CONFIG::LOCALE_TH
        private static const _TRANS_TITLE   :String = "ข้อมูลไอเท็มที่มีอยู่";


        // 親ステージ
        private var _stage:Sprite = new Sprite();

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // ビューのステート
        private var _state:int;

//         // 終了ボタン
//         private var _exitButton:Button = new Button();

        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // アバタービュー
        private var _avatarView:AvatarView;

        // アイテムリスト
//        private var _avatarItemList:AvatarItemList = new AvatarItemList;

        // アイテムインベントリイメージ
        private var _itemInventoryImage:ItemInventoryImage = new ItemInventoryImage();

        // アイテムインベントリイメージ
        private var _itemListPanel:ItemListPanel = new ItemListPanel();
        private var _bodyListPanel:BodyListPanel = new BodyListPanel();
        private var _clothListPanel:ClothListPanel = new ClothListPanel();
        private var _acceListPanel:AcceListPanel = new AcceListPanel();

        // アイテムインベントリパネル
        private var _listPanelSet:Array = [_itemListPanel, _bodyListPanel,_clothListPanel, _acceListPanel];


        private var _player:Player = Player.instance;
        private var _avatar:Avatar;

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 100;
        private const _TITLE_HEIGHT:int = 25;

        private const _ITEM_PANEL_X:int = 0;
        private const _ITEM_PANEL_Y:int = 0;

        // ステート定数
        private static const _START:int = 0;               // 開始
        private static const _WAIT:int = 1;                // 待機
        private static const _END:int = 2;                 // 終了

        // 位置定数

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function ItemView(stage:Sprite)
        {

            _stage = stage;
            _avatar = _player.avatar;

            _container.addChild(_itemInventoryImage);
            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_QUEST);

            _state = _START;

            RaidHelpView.instance.isUpdate = true;
        }

        // スレッドのスタート
        override protected function run():void
        {
            next(waitLoading);

        }

        // アイテムデータが送られてくるのを待つ
        private function waitLoading():void
        {
            next(initItemPanel);
        }

        // アイテムデータが送られてくるのを待つ
        private function initItemPanel():void
        {
            _bodyListPanel.x = _itemListPanel.x = _ITEM_PANEL_X;
            _bodyListPanel.y = _itemListPanel.y = _ITEM_PANEL_Y;

            next(createItemData);
        }


        // 所持するアイテムデータを生成する
        private function createItemData():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_avatarView.getShowThread(_container));
            pExec.addThread(_itemListPanel.getShowThread(_container));
            pExec.addThread(_bodyListPanel.getShowThread(_container));
            pExec.addThread(_clothListPanel.getShowThread(_container));
            pExec.addThread(_acceListPanel.getShowThread(_container));

            pExec.start();
            pExec.join();

            next(initTitle);
        }

        // タイトルの初期化
        private function initTitle():void
        {
            _container.alpha = 0.0;
            partsNumUpdate();
            _title.x = _TITLE_X;
            _title.y = _TITLE_Y;
            _title.width = _TITLE_WIDTH;
            _title.height = _TITLE_HEIGHT;
            _title.text = "ItemList";
            _title.styleName = "EditTitleLabel";
            _title.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _title.alpha = 0.0;
            _title.mouseChildren = false;
            _title.mouseEnabled = false;

            _titleJ.x = _TITLE_X + 85;
            _titleJ.y = _TITLE_Y + 7;
            _titleJ.width = _TITLE_WIDTH;
            _titleJ.height = _TITLE_HEIGHT;
//            _titleJ.text = "所持品情報";
            _titleJ.text = _TRANS_TITLE;
            _titleJ.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _titleJ.alpha = 0.0;
            _titleJ.mouseChildren = false;
            _titleJ.mouseEnabled = false;

            _container.addChild(_title);
            _container.addChild(_titleJ);

            _avatar.addEventListener(Avatar.PART_MAX_UPDATE, partGetHandler);
            LobbyCtrl.instance.addEventListener(AvatarPartEvent.VANISH_PART,partGetHandler);
            LobbyCtrl.instance.addEventListener(AvatarPartEvent.GET_PART, partGetHandler);

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            next(show);
        }

        // 表示させる
        private function show():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            pExec.start();
            pExec.join();

            _state = _WAIT;
            _stage.addChild(_container);

            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);
            _itemInventoryImage.setSwitchFunc(switchPanel);
            switchPanel(0);

            next(waiting);
        }

        private function switchPanel(t:int):void
        {
            _listPanelSet.forEach(function(item:*, index:int, array:Array):void{
                    if(index == t)
                    {
                        item.visible = true;
                    }else{
                        item.visible = false;
                    }
                });
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

        // 描画オブジェクトを消去
        private function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();


            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            next(exit);
        }

        // 終了
        private function exit():void
        {
            _itemListPanel.getHideThread().start();
            _bodyListPanel.getHideThread().start();
            _clothListPanel.getHideThread().start();
            _acceListPanel.getHideThread().start();
            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);

            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(_avatarView.getHideThread());
            sExec.start();
            sExec.join();
            _itemInventoryImage.getHideThread().start();
        }

        // 終了
        private function exitButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            exitHandler();
            log.writeLog(log.LV_INFO, this, "push exit");
        }

        // 終了時のハンドラ。他のViewから呼んだときはここだけ呼ぶ予定
        private function exitHandler():void
        {
            _state = _END;
        }

        private function partGetHandler(e:Event):void
        {
            partsNumUpdate();
        }

        private function partsNumUpdate():void
        {
            log.writeLog(log.LV_FATAL, this, "parts num update",AvatarPartInventory.items.length, Player.instance.avatar.partInventoryMax);
            _itemInventoryImage.setPartsNum(AvatarPartInventory.items.length, Player.instance.avatar.partInventoryMax);
//            _itemInventoryImage.setPartsNum(30, Player.instance.avatar.partInventoryMax);
        }

        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            exitHandler();
            log.writeLog(log.LV_INFO, this, "push exit");
        }



        // 終了関数
        override protected  function finalize():void
        {
            // レイドヘルプイベント
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);


            _avatar.removeEventListener(Avatar.PART_MAX_UPDATE, partGetHandler);
            LobbyCtrl.instance.removeEventListener(AvatarPartEvent.VANISH_PART,partGetHandler);
            LobbyCtrl.instance.removeEventListener(AvatarPartEvent.GET_PART, partGetHandler);
            log.writeLog (log.LV_WARN,this,"item end");
            RemoveChild.all(_container);
            RemoveChild.apply(_container);
            _avatarView = null;
            _stage =null;
            _itemListPanel = null;
            _bodyListPanel = null;
            _clothListPanel = null;
            _acceListPanel = null;
            _listPanelSet = null;
            _itemInventoryImage = null;
        }



   }
}
