package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;

    import view.image.BaseImage;
    import view.*;
    import view.utils.*;
    import view.scene.game.*;
    import view.scene.common.*;
    import controller.*;

    /**
     * アバターレベルアップ表示
     *
     */
    public class ResultAvatarLevelUpImage extends BaseImage
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "アバターのレベルが";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "になった";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "Your avatar has reached level ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = ".";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "虛擬人物的等級提升為";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "虚拟人物的等级变为";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "아바타의 레벨이 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "이 되었다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Votre Avatar a atteint le Niveau ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = ".";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "アバターのレベルが";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "になった";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "เลเวลของอวาตาร์เพิ่มเป็น";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "";

        // result表示元SWF
        [Embed(source="../../../../data/image/game/result/lvup_avatar.swf")]

        private var _Source:Class;
//        private const LEVEL_UP_F:String = "アバターのレベルが";
        private const LEVEL_UP_F:String = _TRANS_MSG1;
//        private const LEVEL_UP_B:String = "になった";
        private const LEVEL_UP_B:String = _TRANS_MSG2;
        private const TEXT_X:int = 192;
        private const TEXT_Y:int = 500;
        private const TEXT_W:int = 380;
        private const TEXT_H:int = 80;

        private const RESULT_X:int = 308;
        private const RESULT_Y:int = 608;

        private var _rankImage:MovieClip;
        private var _starImage:MovieClip;
        private var _starMaskImage:MovieClip;
        private var _rank:int;
        private var _frameNum:int = 20;
        private var _text:Text = new Text;
        private var _level:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function ResultAvatarLevelUpImage()
        {
            _text.x = TEXT_X;
            _text.y = TEXT_Y;
            _text.width = TEXT_W;
            _text.height = TEXT_H;
            _text.styleName = "LevelUpInfoLabel";
            _text.selectable = false;
            _text.alpha = 0.0;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _frameNum = _root.totalFrames;
            _root.gotoAndStop(0);
            _root.visible = false;
            _root.alpha = 0;

        }

        override public function final(): void
        {
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function goPlay():void
       {
            waitComplete(setPlay);
        }

        private function setPlay():void
        {
            _root.gotoAndPlay(1);
            _root.alpha = 1.0;
            _root.visible = true;
        }

        public function getPlayThread(level:int):Thread
        {
            addChild(_text);
            var t:Array = []; /* of String */
            _level = level;
            var lv:int = Player.instance.avatar.level-level+1
            t.push(LEVEL_UP_F+lv.toString()+LEVEL_UP_B);
            if (Const.LEVEL_UP_STR[lv]!=null&&Const.LEVEL_UP_STR[lv].length>0)
            {
                for(var i:int = 0; i < Const.LEVEL_UP_STR[lv].length; i++)
                {
                    var x:String = Const.LEVEL_UP_STR[lv][i];
                    t.push(x);
                }
            }
            _text.text = t.join("\n");
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            sExec.addThread(new ClousureThread(goPlay));
            sExec.addThread(new SleepThread(_frameNum*42));
            sExec.addThread(new BeTweenAS3Thread(_text, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return sExec;
        }
        public function getFadeThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_root, {alpha:0.0}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_text, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new ClousureThread(function():void{_root.buttonEnabled = false}));
            pExec.addThread(new ClousureThread(function():void{_text.mouseEnabled = false}));
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(hideAll));
            return sExec;
        }


        private function avatarInit():void
        {
        }


        // 最終リザルトOKボタン
        private function clickHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "last Click");
            SE.playClick();
            _level = _level -1;
            if(_level > 0)
            {
                GameCtrl.instance.addViewSequence(getPlayThread(_level));
            }else{
                GameCtrl.instance.stopViewSequence();
                hideAll();
                RemoveChild.apply(_text);
            }
        }

        public function hideAll():void
        {
            _root.gotoAndStop(0);
            _text.alpha = 0.0;
            _root.visible = false;
            _root.alpha = 0;
            RemoveChild.apply(_text);
        }

    }

}