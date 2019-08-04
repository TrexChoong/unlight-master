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
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;


    import model.*;
    import model.events.*;

    import view.*;
    import view.utils.*;
    import view.image.quest.*;
    import view.scene.*;
    import view.scene.common.*;
    import view.scene.game.*;
    import view.image.game.*;

    import controller.*;


    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class QuestStoryScene extends BaseScene
    {

        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ
        // 背景の黒
        private var _shape:Shape = new Shape();

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [""],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        private var _bg:QuestStoryBGImage;
        private var _standChara:StandCharaImage;
        private var _dialogue:QuestStoryDialogueImage;
        private static const _PLAYER_X:int = 0;
        private static const _PLAYER_Y:int = 0;
        private var _questBg:QuestBG = new QuestBG();
        private const LAST_BOSS:int  = 6; 
        private var _isBoss:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function QuestStoryScene(mapNo:int=0)
        {
            _isBoss = (mapNo == LAST_BOSS);
            _bg = new QuestStoryBGImage(mapNo);
            _dialogue = new QuestStoryDialogueImage();
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
        }

        public function setStandChara(image:String):void
        {
            _standChara = new StandCharaImage( true, image);
            _standChara.upImage();
            _standChara.x = _PLAYER_X - 500;
            _standChara.y = _PLAYER_Y;
            _standChara.visible = false;
        }
        protected override function get helpTextArray():Array /* of String or Null */ 
        {
            return _helpTextArray;
            // _container.alpha = 0.0;
            // self.alpha = 0;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */ 
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {
            _shape.graphics.beginFill(0x000000);
            _shape.graphics.drawRect(0, 0, 1024, 476);
            addChild(_shape);
            addChild(_container);
            _bg.getShowThread(_container,10).start();
            _standChara.getShowThread(_container,12).start();
            _questBg.getShowThread(_container,13).start();
            _dialogue.getShowThread(_container,15).start();
            _bg.addEventListener("caption_end", bgCaptionFinishHandler);
            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);

        }

        public function fadeInThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(_bg, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.1 ,true ));
            sExec.addThread(new ClousureThread(_bg.play));
            sExec.addThread(QuestCtrl.instance.questViewDuelAvatarShowThread);
            return sExec;
        }

        private function bgCaptionFinishHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "test story BG finish.end");
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(_standChara, {x:_PLAYER_X}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));
            sExec.addThread(_dialogue.getAnimeThread());
            sExec.start();
        }
        public function get dialogueImage():DisplayObject
        {
            return _dialogue;
        }

        public function get bg():DisplayObject
        {
            return _bg;
        }

        // 後始末処理
        public override function final():void
        {
            RemoveChild.apply(_shape);
            RemoveChild.apply(_container);
            _bg.getHideThread().start();
            if (_standChara != null)
            {
                _standChara.getHideThread().start();
            }
            _questBg.getHideThread().start();
            _dialogue.getHideThread().start();
            _bg.removeEventListener("caption_end", bgCaptionFinishHandler);
        }



    }
}