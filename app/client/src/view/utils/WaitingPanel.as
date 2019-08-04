package view.utils
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;


    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.tweener.TweenerThread;


    import view.image.BaseImage;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  エラーや返値を待つ待機専用パネル
     *
     */

    public class WaitingPanel extends Panel
    {

        private static var __wp:WaitingPanel;
        private static var __cancelFunc:Function;
        private static var __cancelArgs:Array;
        private static var __caller:Object;
        private static var __enable:Boolean;
        private static var __cancel:Boolean;

        // タイトル表示
        private var _textLabel:Label = new Label();

        private var _content:String;
        // キャンセル
        private var _cancelButton:Button = new Button();

        public static function show(title:String, text:String,cancel:Boolean = false, handler:Function = null, caller:Object= null,  args:Array = null):void
        {
            if (__wp == null){initPanel()}

            __wp.setText(title, text);
            __wp.cancelButonEnabled(cancel);

            __cancelFunc = handler;
            __cancelArgs = args;
            __caller = caller;

            Unlight.INS.topContainer.parent.addChild(__wp);
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
            log.writeLog(log.LV_FATAL, "static WatingPanel", "hide++++");
            RemoveChild.apply(__wp);
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            __enable = false;
        }

        private static function cancelHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, "static WatingPanel", "cancel button do++++");
            if (__cancelFunc !=null&&__caller != null)
            {
                __cancelFunc.apply(__caller, __cancelArgs);
            }
//              Unlight.INS.topContainer.mouseEnabled = true;
//              Unlight.INS.topContainer.mouseChildren = true;
            __caller = null;
            __cancelFunc = null;
            SE.playClick();
        }

        private static function initPanel():void
        {
            __wp = new WaitingPanel()
        }

        /**
         * コンストラクタ
         *
         */
        public function WaitingPanel()
        {
            super();
            x = 270;
            y = 280;
            width  = 250;
            height = 105;
            layout = "absolute";

            _textLabel.x = 44;
            _textLabel.y = 45;
            _textLabel.width = 200;
            _textLabel.height = 50;
            _textLabel.styleName = "WaitingPanelLabel";

            _cancelButton.x = 90;
            _cancelButton.y = 68;
            _cancelButton.width = 60;
            _cancelButton.height = 23;
            _cancelButton.label = "Cancel";

            _cancelButton.addEventListener(MouseEvent.CLICK, cancelHandler)

            _cancelButton.visible= false;
            addChild(_textLabel);
            addChild(_cancelButton);
        }

        public function setText(ti:String, te:String):void
        {
            title = ti;
            _content = te;
            _textLabel.text = "";
            new TextUpdateThread(_textLabel, _content).start();
        }

        private function cancelButonEnabled(b:Boolean):void
        {
            _cancelButton.visible= b;
        }


    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import mx.controls.Label;

import view.utils.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.tweener.TweenerThread;


// 基本的なShowスレッド
class TextUpdateThread extends Thread
{
    private var _label:Label;
    private var _content:String;

    public function TextUpdateThread(lb:Label,t:String)
    {
        _label = lb;
        _content = t;
    }

    protected override function run():void
    {

        if (WaitingPanel.enable)
        {
            next(updateText);
        }else{
            return;
        }

    }

    private function updateText():void
    {
            var textTween:Thread = new TweenerThread(_label, { _text: _content, delay:0.1, transition:"easeOutSine", time: 0.5} );
            _label.text = "";
            textTween.start();
            textTween.join();
            if (WaitingPanel.enable)
            {
                next(updateText);
            }else{
                return;
            }
    }





}
