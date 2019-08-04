package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.BaseScene;

    import controller.QuestCtrl;



    /**
     * クエストマップ選択ウィンドウ
     *
     */
    public class QuestSelectMapWindow extends BaseScene
    {
        private static const MAP_NO:int = 0;
        private static const MAP_REGION:int = 1;

        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private var _window:SelectMapWindowImage = new SelectMapWindowImage();

        private var _ctrl:QuestCtrl = QuestCtrl.instance;
        private var _avatar:Avatar = Player.instance.avatar;

        private var _maxMapNo:int;

        private var _iconClickFunc:Function;

        /**
         * コンストラクタ
         *
         */
        public function QuestSelectMapWindow()
        {
        }

        public override function init():void
        {
            _window.visible = false;
            _maxMapNo = Const.QUEST_FLAG_MAP[_avatar.questFlag][MAP_NO];
            _window.setButtonVisible(_maxMapNo);
            _window.setClickFunc(normalMapIconClickFunc,eventMapIconClickFunc,tutorialMapIconClickFunc,charaVoteMapIconClickFunc);

            _container.addChild(_window);
            addChild(_container);
        }

        // 後始末処理
        public override function final():void
        {
        }

        public function show():void
        {
            log.writeLog(log.LV_DEBUG, this, "show  !!!!!!!!!!!!!!!!!!!!!!!!!", _window.y,_window.visible);
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_window, {y:0}, {y:-500}, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.start();
        }

        public function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_window, {y:-500}, {y:0}, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.start();
        }

        public function get close():SimpleButton
        {
            return _window.close;
        }

        public function setIconClickFunc(clickFunc:Function):void
        {
            _iconClickFunc = clickFunc;
        }
        private function normalMapIconClickFunc(idx:int):void
        {
            // log.writeLog(log.LV_DEBUG, this, "map icon click!!!!!!!!!!!!!!!!!!!!!!!!!", idx,nowMapNo);
            if (_iconClickFunc != null) {
                _iconClickFunc(idx,Const.QUEST_NORMAL);
            }
        }
        private function eventMapIconClickFunc(idx:int):void
        {
            // log.writeLog(log.LV_DEBUG, this, "event map icon click!!!!!!!!!!!!!!!!!!!!!!!!!", idx);
            if (_iconClickFunc != null) {
                _iconClickFunc(idx,Const.QUEST_EVENT);
            }
        }
        private function tutorialMapIconClickFunc(idx:int):void
        {
            // log.writeLog(log.LV_DEBUG, this, "tutorial map icon click!!!!!!!!!!!!!!!!!!!!!!!!!", idx);
            if (_iconClickFunc != null) {
                _iconClickFunc(idx,Const.QUEST_TUTORIAL);
            }
        }
        private function charaVoteMapIconClickFunc(idx:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "charaVote map icon click!!!!!!!!!!!!!!!!!!!!!!!!!", idx);
            if (_iconClickFunc != null) {
                _iconClickFunc(idx,Const.QUEST_CHARA_VOTE);
            }
        }
    }
}


