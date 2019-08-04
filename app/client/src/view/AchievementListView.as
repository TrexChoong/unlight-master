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

    import view.scene.common.*;
    import view.image.common.*;
    import view.utils.*;

    import controller.LobbyCtrl;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;


    /**
     * 実績のビュークラス
     *
     */
    public class AchievementListView extends UIComponent
    {

        private static var __achievementView:AchievementListView;
        private static var __enable:Boolean;

        private static const _START_Y:int = -120;
        private static const _X:int = 52;
        private static const _Y:int = 100;

        // ロビーのコントローラ
        private var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;

        private static var __type:int;
        private var _bg:AchievementListImage = new AchievementListImage();
        // private var _bgContainer:UIComponent = new UIComponent;
        // private var _forContainer:UIComponent = new UIComponent;
//        private var _loginStatusUpdateTimer:Timer;

        // 初期化（まっさきに先読みさせる）
        public static function initiData():void
        {
            if (__achievementView == null){initView()}
        }


        // 実績ビューを呼び出す
        public static function show():void
        {
            // 初期化されていない場合は作る
            if (__achievementView == null){initView()}

            // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
//            Unlight.INS.topContainer.parent.addChild(__achievementView);
            BetweenAS3.serial(
                BetweenAS3.addChild(__achievementView, Unlight.INS.topContainer.parent),
                 BetweenAS3.to(__achievementView,{y:_Y},0.3, Quad.easeOut)
                ).play();
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            __enable = true;
//             __achievementView.timerStart();
            updateAchievementInfo();
            AchievementListContainer.update();
        }

        private static function updateAchievementInfo():void
        {

//             var now:int = getTimer();
//             if (now-__updatedTime > _UPDATE_INTERVAL)
//             {
//                 __updatedTime = now;
//                 LobbyCtrl.instance.requestAchievementsInfo();
//                 new WaitThread(3000,LobbyCtrl.instance.achievementUpdate).start();
//             }
        }



        public static function get enable():Boolean
        {
            return __enable;
        }

        public static function hide():void
        {
            BetweenAS3.serial(
                BetweenAS3.tween(__achievementView, {y:_START_Y}, null, 0.15, Sine.easeOut),
                BetweenAS3.removeFromParent(__achievementView)
                ).play()
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            __enable = false;
        }

        private static function initView():void
        {
            __achievementView = new AchievementListView()
        }

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function AchievementListView()
        {
            //          log.writeLog(log.LV_FATAL, this, "+++++++++++++++++++++++++++++++++++++");
//             addChild(_bgContainer);
//             addChild(_forContainer);
             x = _X;
             y = _START_Y;
            _bg.setCloseHandler(hide);
            _bg.setTabHandler(AchievementListContainer.instance.setState)
            // _bg.setTabHandler(AchievementListContainer.instance.setTab)
            _bg.getShowThread(this, 0).start();
//            _bg.addChild(_inviteButton);
             _bg.addChild(AchievementListContainer.instance);
             _bg.setNextHandler(AchievementListContainer.instance.nextPage);
             _bg.setPrevHandler(AchievementListContainer.instance.prevPage);
             AchievementListContainer.instance.bg = _bg;
//             _loginStatusUpdateTimer = new Timer(_UPDATE_INTERVAL,0)
//             _loginStatusUpdateTimer.addEventListener(TimerEvent.TIMER, updateHandler);
        }

        private function updateHandler(e:TimerEvent):void
        {
            AchievementListView.updateAchievementInfo()
        }

//         public function timerStop():void
//         {
//             _loginStatusUpdateTimer.stop();
//         }

//         public function timerStart():void
//         {
//             _loginStatusUpdateTimer.start();
//         }

    }
}
