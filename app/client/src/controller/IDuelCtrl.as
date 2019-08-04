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

     import model.Player;
//     import model.AvatarItemInventory;
//     import model.events.AvatarItemEvent;
//     import view.image.common.AvatarItemImage;
//     import view.scene.common.ItemListRenderer;

    import view.image.item.*;
    import view.scene.item.*;
    import view.scene.common.*;

    import controller.LobbyCtrl;

    /**
     * アバターアイテムビューのビュークラス
     *
     */
    public class ItemView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "所持品情報";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Inventory";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "所持品訊息";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "所持之物的信息";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "소지품 정보";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Possessions";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "所持品情報";

        CONFIG::LOCALE_TH
        private static const _TRANS :String = "ข้อมูลไอเท็มที่มีอยู่";


        // 親ステージ
        private var _stage:Sprite = new Sprite();

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // ビューのステート
        private var _state:int;

        // 終了ボタン
        private var _exitButton:Button = new Button();

        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // アバタービュー
        private var _avatarView:AvatarView;

        // アイテムリスト
//        private var _avatarItemList:AvatarItemList = new AvatarItemList;

        // アイテムインベントリイメージ
        private var _itemInventoryImage:ItemInventoryImage = new ItemInventoryImage;
        // アイテムインベントリイメージ
        private var _itemListPanel:ItemListPanel = new ItemListPanel;


        private var _player:Player = Player.instance;

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 100;
        private const _TITLE_HEIGHT:int = 40;

        private const _ITEM_PANEL_X:int = 30;
        private const _ITEM_PANEL_Y:int = 115;

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

//            _container.addChild(_avatarItemList);
            _container.addChild(_itemInventoryImage);
//            _container.addChild(_exitButton);
//            _container.addChild(_itemListPanel);

            _exitButton.width = 70;
            _exitButton.height = 30;
            _exitButton.x = 850;
            _exitButton.y = 10;
            _exitButton.label = "Exit";

            _avatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_MATCH);

            _state = _START;
        }

        // スレッドのスタート
        override protected function run():void
        {
            next(waitLoading);
        }

        // アイテムデータが送られてくるのを待つ
        private function waitLoading():void
        {
//             _avatarItem = AvatarItem.ID(_id);
//             // 系統樹の準備を待つ
//             if (_avatarItem.loaded == false)
//             {
//                 _avatarItem.wait();
//             }

            next(initItemPanel);
        }

        // アイテムデータが送られてくるのを待つ
        private function initItemPanel():void
        {
            _itemListPanel.x = _ITEM_PANEL_X;
            _itemListPanel.y = _ITEM_PANEL_Y;

            next(createItemData);
        }


        // 所持するアイテムデータを生成する
        private function createItemData():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
//            pExec.addThread(_avatarItemList.getShowThread(_container));
            pExec.addThread(_avatarView.getShowThread(_container));
            pExec.addThread(_itemListPanel.getShowThread(_container));

            pExec.start();
            pExec.join();

            next(initTitle);
        }

        // タイトルの初期化
        private function initTitle():void
        {
            _container.alpha = 0.0;

            _title.x = _TITLE_X;
            _title.y = _TITLE_Y;
            _title.width = _TITLE_WIDTH;
            _title.height = _TITLE_HEIGHT;
            _title.text = "ItemList";
            _title.styleName = "EditTitleLabel";
            _title.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _title.alpha = 0.0;

            _titleJ.x = _TITLE_X + 85;
            _titleJ.y = _TITLE_Y + 7;
            _titleJ.width = _TITLE_WIDTH;
            _titleJ.height = _TITLE_HEIGHT;
//            _titleJ.text = "所持品情報";
            _titleJ.text = _TRANS;
            _titleJ.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _titleJ.alpha = 0.0;

            _container.addChild(_title);
            _container.addChild(_titleJ);

            next(show);
        }

        // 表示させる
        private function show():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            pExec.start();
            pExec.join();

            _state = _WAIT;
            _stage.addChild(_container);

            _exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);
            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, exitButtonHandler);

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

        // 描画オブジェクトを消去
        private function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_container, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            next(exit);
        }

        // 終了
        private function exit():void
        {
            _exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);
            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, exitButtonHandler);

            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(_avatarView.getHideThread());
            sExec.start();
            sExec.join();
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

        // 終了関数
        override protected  function finalize():void
        {

            if (_container.parent != null)
            {
                _stage.removeChild(_container);
            }
            log.writeLog (log.LV_WARN,this,"item end");
        }

   }
}
