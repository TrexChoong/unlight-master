package view.scene.common
{
    import flash.display.*;
    import flash.geom.*;
    import flash.events.MouseEvent;
    import flash.events.Event;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.RaidHelpView;
    import view.scene.BaseScene;
    import model.Story;
    import view.image.common.StoryFrameImage;
    import view.image.common.StoryImage;
    import view.ClousureThread;

    import controller.LobbyCtrl;

    /**
     * ストーリー表示クラス
     *
     */

    public class StoryClip extends BaseScene
    {
        // テキストエリア
//        private var _textArea:TextArea = new TextArea();
        private var _storyTextArea:StoryTextArea = new StoryTextArea();
        private var _storyImage:StoryImage;

        // ストーリー
        private var _story:Story;

        // 終了ボタン
//        private var _exitButton:Button = new Button();

        // 背景フレーム
        private var _frame:StoryFrameImage = new StoryFrameImage();

        // テキスト
        private var _html:String;

        // フェードベース
        private var _fade:Fade = new Fade(0.2, 0.9);

        private var _bgContainer:UIComponent = new UIComponent();
        private static const _EXIT_BUTTON_X:int = 925;     // 終了ボタンX
        private static const _EXIT_BUTTON_Y:int = 700;     // 終了ボタンY
        private static const _IMAGE_X:int = 20;
        private static const _IMAGE_Y:int = 96;

        private static const _RUBY_AREA_X:int = 865;     // 中身の文字のX
        private static const _RUBY_AREA_Y:int = 637;     // 終了ボタンY
        private static const URL:String = "/public/image/story/";
        // 挿絵

        /**
         * コンストラクタ
         *
         */
        public function StoryClip(s:Story)
        {
            _story = s;
        }

        public override function init():void
        {
            LobbyCtrl.instance.stopBGM(1);
            LobbyCtrl.instance.playStoryBGM();
            Voice.playStoryVoice(_story.id);
            _storyTextArea.setData(_story.title, _story.content);
//            log.writeLog(log.LV_FATAL, this, "init ", URL+_story.image);
            _storyImage = new StoryImage(URL+_story.image);
            _bgContainer.x = _IMAGE_X;
            _bgContainer.y = _IMAGE_Y;
            addChild(_bgContainer);
            addChild(_frame);
            addChild(_storyTextArea);
            addChild(_frame.readMark);
            _frame.addEventListener(StoryFrameImage.CLICK_EXIT, exitHandler);
            _storyTextArea.addEventListener(MouseEvent.CLICK, _storyTextArea.clickHandler);
            _storyTextArea.setReadMarkImage(_frame.readMark);
            _storyImage.getShowThread(_bgContainer).start();
        }


        public override function final():void
        {
            
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            log.writeLog(log.LV_FATAL, this, "getshow", stage);
            _depthAt = at;
            RaidHelpView.instance.isUpdate = false;
            var pExec:SerialExecutor = new SerialExecutor();
            pExec.addThread(_fade.getShowThread(stage, at));
            pExec.addThread(new ShowThread(_story, this, stage));
            return pExec;

        }

        // 非表示スレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            _frame.removeEventListener(StoryFrameImage.CLICK_EXIT, exitHandler);
            _storyTextArea.removeEventListener(MouseEvent.CLICK, _storyTextArea.clickHandler);
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_fade.getHideThread());
            pExec.addThread(new HideThread(this));
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(function():void{RaidHelpView.instance.isUpdate = true}));
            return sExec;
        }

        public function exitHandler(e:Event):void
        {
            LobbyCtrl.instance.stopStoryBGM(1);
            LobbyCtrl.instance.playBGM();
            getHideThread().start();
        }

    }

}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import view.BaseShowThread;
import model.Story;

import view.BaseHideThread;
import view.scene.common.StoryClip;

class ShowThread extends BaseShowThread
{
    private var _story:Story;

    public function ShowThread(s:Story, sc:StoryClip, stage:DisplayObjectContainer)
    {
        log.writeLog(log.LV_FATAL, this, "aaaaaaaaaStory", s);
        _story = s;
        super(sc, stage);
    }


    protected override function run():void
    {
        // ストーリーの準備を待つ
        if (_story.loaded == false)
        {
            _story.wait();
        }
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(f:StoryClip)
    {
        super(f);
    }
}
