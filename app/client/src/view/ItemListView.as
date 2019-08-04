package view
{

    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.*;

    import view.scene.common.*;
    import view.scene.item.*;
    import view.image.common.*;
    import view.image.item.*;
    import view.utils.*;

    import controller.*;

    /**
     * アイテムリストビューのビュークラス
     *
     */
    public class ItemListView extends UIComponent
    {


        private static var __itemView:ItemListView;
        private static var __enable:Boolean;

        private static const _START_X:int = 798;
        private static const _X:int = 498;
        private static const _Y:int = 107;

        // ロビーのコントローラ
        private var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;

        private static var __type:int;
        // private static var __selectTabIndex:int = AvatarItem.ITEM_BASIS;
        private static var __selectTabIndex:int = 0;
//        private static var _bg:WindowItemListPanel = new WindowItemListPanel(AvatarItem.ITEM_BASIS);
        private var _bg:WindowItemListPanel;
        private var _presentLabel:Label = new Label();


        private var _bgContainer:UIComponent = new UIComponent;
        private var _forContainer:UIComponent = new UIComponent;

        // 初期化（まっさきに先読みさせる）
        public static function initiData():void
        {
            if (__itemView == null){initView()}
        }


        // ビューを呼び出す
        public static function show():void
        {
            // 初期化されていない場合は作る
            if (__itemView == null){initView()}else{__itemView.updateTabIndex();
}

            // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
            BetweenAS3.serial(
                BetweenAS3.addChild(__itemView, Unlight.INS.topContainer.parent),
                 BetweenAS3.to(__itemView,{x:_X},0.2, Quad.easeOut)
                ).play();
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            __enable = true;

        }


        public static function get enable():Boolean
        {
            return __enable;
        }

        public static function hide():void
        {
//            LobbyCtrl.instance.achievementClearCheck();
            if (__itemView != null)
            {
            BetweenAS3.serial(
                BetweenAS3.tween(__itemView, {x:_START_X}, null, 0.15, Sine.easeOut),
                BetweenAS3.removeFromParent(__itemView)
                ).play();
            }
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            __enable = false;
        }

        private static function initView():void
        {
            __itemView = new ItemListView()
        }

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function ItemListView()
        {
            log.writeLog(log.LV_FATAL, this, "ItemListView");

            _bg = new WindowItemListPanel(__selectTabIndex);

            x = _START_X;
            y = _Y;
            _bg.setCloseHandler(hide);
            _bg.getShowThread(this, 0).start();

            _bg.addChild(_presentLabel);

//            _bg.setSelectTabIndex(__selectTabIndex);

//            setSelectTabIndex();
        }


        private function updateTabIndex():void
        {
            if ( _bg != null ) { _bg.setSelectTabIndex(__selectTabIndex); }
        }

        // public static function setSelectTabIndex( index:int = AvatarItem.ITEM_BASIS ):void
        public static function setSelectTabIndex( index:int = 0 ):void
        {
            __selectTabIndex = index;

            // if(__itemView != null)
            // {
            //     __itemView.setTabIndex(index);
            // }else{
            //     __selectTabIndex = index;
            //     initView();
            //     log.writeLog(log.LV_INFO, "ItemListView ", "!!!view? is ",__itemView);
            //      __itemView.setTabIndex(index);
            // }
         }


    }
}
