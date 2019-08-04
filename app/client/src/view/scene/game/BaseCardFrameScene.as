package view.scene.game
{
    import flash.display.*;
    import flash.events.*;

    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.*;

    import model.Duel;
    import view.image.game.*;
    import view.scene.BaseScene;
    import view.ClousureThread;
    import view.SleepThread;
    import view.utils.*;
    import controller.*;

    /**
     * 枠シーンクラス
     *
     */

    public class BaseCardFrameScene extends BaseScene
    {
        private var _base:BaseCardFrame = new BaseCardFrame();

        private var _nameLabel:Label = new Label();
        private var _talk:ChatTalk = new ChatTalk;

        private var _container:UIComponent = new UIComponent();
        private var _nameContainer:UIComponent = new UIComponent();

        private static const LABEL_X:int = 600;
        private static const LABEL_Y:int = 36;
        private static const LABEL_START_Y:int = -30;
        private static const LABEL_W:int = 168;
        private static const LABEL_H:int = 20;

        /**
         * コンストラクタ
         *
         */
        public function BaseCardFrameScene()
        {
            _nameLabel.styleName = "GameChatName";
            _nameLabel.width = LABEL_W;
            _nameLabel.height = LABEL_H;
            _nameLabel.x = LABEL_X;
            _nameLabel.y = LABEL_START_Y;
            _nameLabel.mouseEnabled = false;
        }

        public override function init():void
        {
            _talk.getShowThread(_container).start();
            Duel.instance.addEventListener(Duel.START_TURN_PHASE, toTurnUpdateHandler);
            _nameLabel.text = ChatCtrl.instance.foeName;
            _nameLabel.y = LABEL_START_Y;
            _nameContainer.addChild(_nameLabel);

            _base.alpha = 0.0;
            _container.addChild(_base);

            addChild(_container);
            addChild(_nameContainer);
        }
        public override function final():void
        {
            _talk.getHideThread().start();
            Duel.instance.removeEventListener(Duel.START_TURN_PHASE, toTurnUpdateHandler);
            _nameLabel.text = "";
            RemoveChild.apply(_nameLabel);
            RemoveChild.apply(_nameContainer);
            RemoveChild.apply(_container);

        }

        private function toTurnUpdateHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(new ClousureThread(setTurn, [Duel.instance.turn]));
        }

        // 相手の名前だけ表示させる
        public function getNameBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_nameLabel, {y:LABEL_Y,alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            return pExec;
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_base, {alpha:1.0}, {alpha:0.0}, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            return pExec;
            //return new BeTweenAS3Thread(this, {alpha:1.0}, {alpha:0.0}, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
        }

        // 実画面から消去するスレッドを返す
        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_nameLabel, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            pExec.addThread(new BeTweenAS3Thread(_base, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));
            return pExec;
            // return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
        }

        public function setTurn(i:int):void
        {
            _base.setTurn(i);
        }

        public function setEndTurn(i:int):void
        {
            _base.setEndTurn(i);
        }

    }

}


