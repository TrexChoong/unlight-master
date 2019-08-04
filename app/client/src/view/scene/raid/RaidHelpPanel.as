package view.scene.raid
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.filters.GlowFilter;
    import flash.geom.*;
    import flash.text.TextField;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import controller.GlobalChatCtrl;

    import model.ProfoundData;
    import model.Profound;

    import view.scene.BaseScene;
    import view.scene.raid.*;
    import view.image.raid.*;
    import view.*;
    import view.utils.*;

    /**
     * レイドヘルプパネル
     *
     */
    public class RaidHelpPanel extends Thread
    {
        CONFIG::LOCALE_JP
        private const _TRANS_MSG:String = "__NAME__さんから救援信号が届いています";
        CONFIG::LOCALE_EN
        private const _TRANS_MSG:String = "Received distress signal from __NAME__";
        CONFIG::LOCALE_TCN
        private const _TRANS_MSG:String = "收到__NAME__傳來的求救信號";
        CONFIG::LOCALE_SCN
        private const _TRANS_MSG:String = "收到__NAME__传来的求救信号";
        CONFIG::LOCALE_KR
        private const _TRANS_MSG:String = "__NAME__さんから救援信号が届いています";
        CONFIG::LOCALE_FR
        private const _TRANS_MSG:String = "Vous avez reçu un appel de détresse de __NAME__";
        CONFIG::LOCALE_ID
        private const _TRANS_MSG:String = "__NAME__さんから救援信号が届いています";
        CONFIG::LOCALE_TH
        private const _TRANS_MSG:String = "__NAME__さんから救援信号が届いています";

        private var _container:UIComponent = new UIComponent();

        private var _moveThread:TextMoveThread;

        private var _plId:int = 0;
        private var _avatarName:String = "";
        private var _prfHash:String = "";

        private var _movePanel:Boolean = false;
        private var _clickFunc:Function;

        private var _helpText:TextArea = new TextArea();

        private var _interrupt:Boolean = false;
        private var _helpView:Boolean = true;

        private static const _LABEL_X_START:int = 800;
        private static const _LABEL_X_END:int = -500;
        private static const _LABEL_Y_START:int = -100;
        private static const _LABEL_Y_END:int = 0;
        private static const _LABEL_X:int = 200;
        private static const _LABEL_Y:int = 0;
        private static const _LABEL_W:int = 300;
        private static const _LABEL_H:int = 40;

        public function RaidHelpPanel()
        {
            _helpText.x = _LABEL_X;
            _helpText.y = _LABEL_Y_START;
            _helpText.width = _LABEL_W;
            _helpText.height = _LABEL_H;
            _helpText.htmlText = _TRANS_MSG;
            _helpText.styleName= "ApRemainArea";
            _helpText.setStyle("fontFamily","Palatino");
            _helpText.visible = true;
        }

        public function setClickFunc(f:Function):void
        {
            _clickFunc = f;
        }

        public function startPanel(plId:int,avatarName:String,prfHash:String):void
        {
            if (!_movePanel) {
                log.writeLog(log.LV_DEBUG, this, "startPanel",plId,avatarName,prfHash);
                _plId = plId;
                _avatarName = avatarName;
                _prfHash = prfHash;
                _movePanel = true;
            }
        }

        public function get isMove():Boolean
        {
            return _movePanel;
        }

        public function setInterrupt():void
        {
            if (!_interrupt) {
                if (_moveThread != null && _moveThread.isShow)
                {
                    log.writeLog(log.LV_DEBUG, this, "move thread interrupt");
                    _moveThread.cntReset();
                }
                // if (_moveThread != null && _moveThread.state != ThreadState.TERMINATED)
                // {
                //     log.writeLog(log.LV_DEBUG, this, "thread interrupt");
                //     _moveThread.interrupt();
                // }
                _interrupt = true;
            }
        }

        public function set helpView(f:Boolean):void
        {
            _helpView = f;
            _container.visible = f;
        }

        protected override function run():void
        {
            next(waiting);
        }

        private function waiting():void
        {
            if (_movePanel) {
                next(initPanel);
            } else {
                next(waiting);
            }
        }

        private function initPanel():void
        {
            log.writeLog(log.LV_DEBUG, this, "initPanel");
            _helpText.text = _TRANS_MSG.replace("__NAME__",_avatarName);
            _helpText.y = _LABEL_Y_START;
            _helpText.alpha = 1.0;
            _helpText.visible = true;
            _helpText.addEventListener(MouseEvent.CLICK,clickHandler);
            _container.addChild(_helpText);
            Unlight.INS.parent.addChild(_container);
            next(move);
        }

        private function move():void
        {
            log.writeLog(log.LV_DEBUG, this, "move",_helpText.x);
            // if (_moveThread != null && _moveThread.state != ThreadState.TERMINATED)
            // {
            //     log.writeLog(log.LV_DEBUG, this, "move thread interrupt");
            //     _moveThread.interrupt();
            // }
            _moveThread = new TextMoveThread(_helpText);
            _moveThread.start();
            next(moving);
        }

        private function moving():void
        {
            if (_moveThread != null && _moveThread.isShow) {
                _moveThread.hideStart();
                _moveThread.join();
                next(finishMove);
            } else {
                next(moving);
            }
            //         if (_interrupt) {
            //     // if (_moveThread != null && _moveThread.state != ThreadState.TERMINATED)
            //     // {
            //     //     log.writeLog(log.LV_DEBUG, this, "move thread interrupt");
            //     //     _moveThread.interrupt();
            //     // }
            //     if (_moveThread != null && _moveThread.isShow)
            //     {
            //         log.writeLog(log.LV_DEBUG, this, "move thread interrupt");
            //         _moveThread.
            //     }
            //     _moveThread = new SerialExecutor();
            //     _moveThread.addThread(new BeTweenAS3Thread(_helpText, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            //     _moveThread.start();
            //     _moveThread.join();
            // }
            // next(finishMove);
        }

        private function finishMove():void
        {
            log.writeLog(log.LV_DEBUG, this, "finishMove",_helpText.x);
            // if (_moveThread != null && _moveThread.state != ThreadState.TERMINATED)
            // {
            //     log.writeLog(log.LV_DEBUG, this, "finishMove thread interrupt");
            //     _moveThread.interrupt();
            // }
            _helpText.removeEventListener(MouseEvent.CLICK,clickHandler);
            RemoveChild.all(_container);
            RemoveChild.apply(_container);
            _movePanel = false;
            _interrupt = false;
            _moveThread = null;
            next(waiting);
        }

        private function clickHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this, "clickhandler");
            if (_clickFunc != null && _helpView) {
                _clickFunc();
            }
        }

        public function get playerId():int
        {
            return _plId;
        }
        public function get avatarName():String
        {
            return _avatarName;
        }
        public function get prfHash():String
        {
            return _prfHash;
        }

    }
}

    import flash.text.TextField;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.SleepThread;

class TextMoveThread extends Thread
{
    private var _ta:TextArea;
    private var _waitCnt:int;
    private var _isShow:Boolean = false;
    private var _hideStart:Boolean = false;

    private const _LABEL_Y_START:int = -100;
    private const _LABEL_Y_END:int = 0;

    private const _WAIT_CNT:int = 150;

    public function TextMoveThread(ta:TextArea)
    {
        _ta = ta;
        _waitCnt = _WAIT_CNT;
        _isShow = true;
        _hideStart = false;
    }

    protected override function run():void
    {
        next(show);
    }

    private function show():void
    {
        // log.writeLog(log.LV_DEBUG, this, "show!!!!!!!!!!!!!!!!!!!!!!");
        var sExec:SerialExecutor = new SerialExecutor();
        sExec.addThread(new BeTweenAS3Thread(_ta, {y:_LABEL_Y_END}, {y:_LABEL_Y_START}, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
        sExec.start();
        sExec.join();
        next(showWait);
    }
    private function showWait():void
    {
        // log.writeLog(log.LV_DEBUG, this, "showWait!!!!!!!!!!!!!!!!!!!!!!",_waitCnt);
        if (_waitCnt > 0) {
            _waitCnt--;
            next(showWait);
        } else {
            next(hideWait);
        }
    }
    private function hideWait():void
    {
        if (_hideStart) {
            next(hide);
        } else {
            next(hideWait);
        }
    }
    private function hide():void
    {
        // log.writeLog(log.LV_DEBUG, this, "hide!!!!!!!!!!!!!!!!!!!!!!");
        _isShow = false;
        var sExec:SerialExecutor = new SerialExecutor();
        sExec.addThread(new BeTweenAS3Thread(_ta, {y:_LABEL_Y_START}, {y:_LABEL_Y_END}, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
        sExec.start();
        sExec.join();
    }

    public function get isShow():Boolean
    {
        return _isShow;
    }
    public function set isShow(f:Boolean):void
    {
        _isShow = f;
    }
    public function cntReset():void
    {
        if (_isShow) {
            _waitCnt = 0;
        }
    }
    public function hideStart():void
    {
        _hideStart = true;
    }

}