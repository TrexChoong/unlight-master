package view
{

    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.net.*;
    import flash.external.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.core.IToolTip;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;
    import mx.managers.ToolTipManager;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Shop;
    import model.RealMoneyItem;
    import model.Player;

    import view.scene.common.*;
    import view.scene.rmshop.*;
    import view.image.shop.*;
    import view.image.common.*;
    import view.utils.*;

    import controller.LobbyCtrl;

    /**
     * ショップビューのビュークラス
     *
     */
    public class RealMoneyShopView extends UIComponent
    {
        public static const TYPE_AVATAR:int = 0;
        public static const TYPE_QUEST:int = 1;
        public static const TYPE_BONUS:int = 2;
        public static const TYPE_CHARA_CARD:int = 3;
        public static const TYPE_AVATAR_PARTS:int = 4;
        public static const TYPE_QUEST_DAMAGE:int = 5;
        public static const TYPE_QUEST_PROGRESS:int = 6;
        public static const TYPE_LOT:int = 7;
        public static const TYPE_EX_CARD:int = 8;
        public static const TYPE_QUEST_USEFUL:int = 9;
        public static const TYPE_LENGTH:int = 10;

        private static var __shopView:RealMoneyShopView;
//        private static var __shopButton:RmShopButton;
        private static var __enable:Boolean;

        // ボタン（アバターAP,クエスト画面,ボーナスゲーム,アイテムショップ）
        private static const __BUTTON_SET:Vector.<RmShopButton> = Vector.<RmShopButton>([new RmShopButton(0),new RmShopButton(1),new RmShopButton(2),new RmShopButton(3),new RmShopButton(4),new RmShopButton(5),new RmShopButton(6),new RmShopButton(7),new RmShopButton(8),new RmShopButton(9)]);

        private const _SHOP_PANEL_X:int = 0;
        private const _SHOP_PANEL_Y:int = 0;

        // ロビーのコントローラ
        private var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;

        private static var __type:int;
        private var _shopPanel:RmShopPanel = new RmShopPanel();
        private var _shopItemContainer:RmItemContainer = new RmItemContainer();
        private var _bgContainer:UIComponent = new UIComponent;
        private var _forContainer:UIComponent = new UIComponent;

        // 初期化（まっさきに先読みさせる）
        public static function initiData():void
        {
            if (__shopView == null){initView()}
        }


        // ショップボタンを呼び出す
        public static function onShopButton(type:int = 0):UIComponent
        {
             // 作ったボタンをトップビューに突っ込む
//             Unlight.INS.topContainer.parent.addChild(__shopButton);

            // セール中かで表示を変える
            __BUTTON_SET[type].setViewSaleClipFlag(Player.instance.avatar.isSaleTime);

            // イベントも必要ならつける
            __BUTTON_SET[type].addMouseOverOutEvent();

            return __BUTTON_SET[type];
        }

        // ショップボタンを隠す
        public static function offShopButton(type:int):void
        {
            RemoveChild.apply(__BUTTON_SET[type]);
        }

        // ショップボタンを呼び出す
        public static function get shopCloseButton():UIComponent
        {
             // 作ったボタンをトップビューに突っ込む
//             Unlight.INS.topContainer.parent.addChild(__shopButton);
            return __shopView.closeButton;
        }

        // ショップビューを呼び出す
        public static function show(type:int):void
        {
            // 初期化されていない場合は作る
            if (__shopView == null){
                initView();
            }

            // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
            Unlight.INS.topContainer.parent.addChild(__shopView);
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            __type =type;
            __shopView.setTab();
            __enable = true;

            RaidHelpView.instance.isUpdate = false;
        }
        public static function get enable():Boolean
        {
            return __enable;
        }

        public static function hideButtonSaleMC(type:int = 0):void
        {
            // イベントをはずす
            __BUTTON_SET[type].removeMouseOverOutEvent();
            __BUTTON_SET[type].getHideSaleMCThread().start();
        }

        public static function hide():void
        {

        }

        private static function initView():void
        {
            __shopView = new RealMoneyShopView()
        }

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function RealMoneyShopView()
        {
            addChild(_bgContainer);
            addChild(_forContainer);
            // 課金アイテムの情報を更新する
            _shopPanel.getShowThread(_bgContainer,0).start();
            _lobbyCtrl.requestRealMoneyItemInfo();
            _shopItemContainer.getShowThread(_forContainer,1).start();
            setTab()

        }

        public function setTab():void
        {
            _shopItemContainer.setTab(__type);
        }
        public function get closeButton():UIComponent
        {
            return _shopPanel.closeButton;
        }

        public static function itemReset():void
        {
            // log.writeLog(log.LV_FATAL, "static rmshopView", "itemReset");
            // データ更新が必要なら行う
            RealMoneyItem.resetData();

            __shopView._shopItemContainer.itemReset();
        }

        public static function getSaleMC(type:int=0):MovieClip
        {
            return __BUTTON_SET[type].sale;
        }


    }
}
