package view.image.raid
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * ProfoundInfoImage表示クラス
     *
     */

    public class ProfoundInfoImage extends BaseImage
    {
        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/raid/raid_win.swf")]
        private var _Source:Class;

        public static const WIN_MSG:int = 1;
        public static const REWARD:int  = 2;
        public static const RANKING:int = 3;

        // frm
        private var _frame:int = WIN_MSG;

        // OKボタン
        private var _okButton:SimpleButton;
        private var _func:Function;

        // ボタン
        private var _nextBtn:SimpleButton;
        private var _backBtn:SimpleButton;
        private var _nextFunc:Function;
        private var _backFunc:Function;

        /**
         * コンストラクタ
         *
         */
        public function ProfoundInfoImage()
        {
            super();

        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            _okButton = SimpleButton(_root.getChildByName("btn_ok"));
            _okButton.addEventListener(MouseEvent.CLICK, buttonHandler);
            _nextBtn = SimpleButton(_root.getChildByName("btn_next"));
            _nextBtn.addEventListener(MouseEvent.CLICK, nextBtnHandler);
            _backBtn = SimpleButton(_root.getChildByName("btn_back"));
            _backBtn.addEventListener(MouseEvent.CLICK, backBtnHandler);

            _okButton.visible = false;
            _nextBtn.visible = false;
            _backBtn.visible = false;

            _root.gotoAndStop(_frame);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public override function final():void
        {
            _okButton.removeEventListener(MouseEvent.CLICK, buttonHandler);
            _nextBtn.removeEventListener(MouseEvent.CLICK, nextBtnHandler);
            _backBtn.removeEventListener(MouseEvent.CLICK, backBtnHandler);
        }

        public function get ok():SimpleButton
        {
            return _okButton;
        }
        private function buttonHandler(e:Event):void
        {
            if (_func != null)
            {
                _func(e);
            }
        }
        public function setButtonFunc(func:Function=null):void
        {
            _func  = func;
        }
        public function removeButtonFunc():void
        {
            _func = null;
        }
        private function nextBtnHandler(e:Event):void
        {
            if (_nextFunc != null)
            {
                _nextFunc();
            }
        }
        private function backBtnHandler(e:Event):void
        {
            if (_backFunc != null)
            {
                _backFunc();
            }
        }
        public function set nextBtnFunc(f:Function):void
        {
            _nextFunc = f;
        }
        public function set backBtnFunc(f:Function):void
        {
            _backFunc = f;
        }
        public function set nextBtnVisible(f:Boolean):void
        {
            _nextBtn.visible = f;
        }
        public function set backBtnVisible(f:Boolean):void
        {
            _backBtn.visible = f;
        }
        public function set frame(f:int):void
        {
            _frame = f;
            waitComplete(setFrame);
        }
        private function setFrame():void
        {
            log.writeLog(log.LV_DEBUG, this, "setFrame ",_frame);
            _root.gotoAndStop(_frame);
        }
    }
}
