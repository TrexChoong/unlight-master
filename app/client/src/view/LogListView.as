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

    import model.Shop;
    import model.Player;

    import view.scene.log.*;
    import view.image.log.*;
    import view.utils.*;

    import controller.LobbyCtrl;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;


    /**
     * ログのビュークラス
     *
     */
    public class LogListView extends UIComponent
    {

        private static var __logView:LogListView;
        private static var __enable:Boolean;
        private static var __activate:Boolean=true;

        private static const _START_Y:int = -120;
        private static const _X:int = 152;
        private static const _Y:int = 150;

        // ロビーのコントローラ
        private var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;

        private static var __type:int;
        private var _bg:BG = new BG();



        // 初期化（まっさきに先読みさせる）
        public static function initData():void
        {
            if (__logView == null){initView()}
        }


        // ログビューを呼び出す
        public static function show():void
        {
            if (__activate)

            {           // 初期化されていない場合は作る
                if (__logView == null){initView()}

                // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
                BetweenAS3.serial(
                    BetweenAS3.addChild(__logView, Unlight.INS.topContainer.parent),
                    BetweenAS3.to(__logView,{y:_Y},0.3, Quad.easeOut)
                    ).play();
                Unlight.INS.topContainer.mouseEnabled = false;
                Unlight.INS.topContainer.mouseChildren = false;
                __enable = true;
                updateLogInfo();
                LogListContainer.update();
            }
        }

        private static function updateLogInfo():void
        {

        }


        public static function activate(b:Boolean):void
        {
            __activate = b;
        }


        public static function get enable():Boolean
        {
            return __enable;
        }

        public static function hide():void
        {
            BetweenAS3.serial(
                BetweenAS3.tween(__logView, {y:_START_Y}, null, 0.15, Sine.easeOut),
                BetweenAS3.removeFromParent(__logView)
                ).play()
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            __enable = false;
        }

        private static function initView():void
        {
            __logView = new LogListView()
        }

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function LogListView()
        {
            x = _X;
            y = _START_Y;
            _bg.setCloseHandler(hide);
            _bg.getShowThread(this, 0).start();
            _bg.addChild(LogListContainer.instance);
            _bg.setNextHandler(LogListContainer.instance.nextPage);
            _bg.setPrevHandler(LogListContainer.instance.prevPage);
            _bg.setListSortHandler(LogListContainer.instance.setTab);
            LogListContainer.instance.bg = _bg;
        }

        private function updateHandler(e:TimerEvent):void
        {
            LogListView.updateLogInfo()
        }

    }
}



