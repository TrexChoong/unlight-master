package view.image.regist
{

    import flash.display.*;
    import flash.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * HP表示クラス
     *
     */

    public class RegistFrame extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/regist/make_frame.swf")]
        private var _Source:Class;

        public static const OK_CLICK:String = "ok_click";
        public static const PREV_CLICK:String = "prev_click";
        public static const NEXT_CLICK:String = "next_click";

        private static const NAME_NAME_MARK:String = "phase_a";
        private static const NAME_AVATAR_MARK:String = "phase_b";
        private static const NAME_CARD_MARK:String = "phase_c";
        private static const NAME_PREV_ARROW:String = "prev";
        private static const NAME_NEXT_ARROW:String = "next";
        private static const NAME_OK_BUTTON:String = "ok";
        private static const LABEL_MARK_ENABLE:String = "en";
        private static const LABEL_MARK_DISABLE:String = "dis";

        private static const SCALE:Number = 1.0;
        private static const X:int = 0;
        private static const Y:int = 0;

        private var _avatarMark:MovieClip;
        private var _cardMark:MovieClip;
        private var _nameMark:MovieClip;

        private var _prevArrow:SimpleButton;
        private var _nextArrow:SimpleButton;

        private var _okButton:SimpleButton;

        /**
         * コンストラクタ
         *
         */
        public function RegistFrame()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _nameMark = MovieClip(_root.getChildByName(NAME_NAME_MARK));
            _avatarMark = MovieClip(_root.getChildByName(NAME_AVATAR_MARK));
            _cardMark = MovieClip(_root.getChildByName(NAME_CARD_MARK));
            _prevArrow = SimpleButton(_root.getChildByName(NAME_PREV_ARROW));
            _nextArrow = SimpleButton(_root.getChildByName(NAME_NEXT_ARROW));
            _okButton = SimpleButton(_root.getChildByName(NAME_OK_BUTTON));
            _prevArrow.addEventListener(MouseEvent.CLICK, prevClickHandler);
            _nextArrow.addEventListener(MouseEvent.CLICK, nextClickHandler);
            _okButton.addEventListener(MouseEvent.CLICK, okClickHandler);
            setNamePhase();
            prevOff();
            nextOff();
            initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            scaleX = SCALE;
            scaleY = SCALE;
            x = X;
            y = Y;
            alpha = 0.0;
        }

        public override function init():void
        {
//            var bgTween:Thread = new TweenerThread(this, { alpha: 1.0, transition:"easeOutSine", time: 2.0, show: true });
            var bgTween:Thread = new BeTweenAS3Thread(this, {alpha:1.0}, null, 2.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
            bgTween.start();
        }

        public override function final():void
        {
            _prevArrow.removeEventListener(MouseEvent.CLICK, prevClickHandler)
            _nextArrow.removeEventListener(MouseEvent.CLICK, nextClickHandler)
            _okButton.removeEventListener(MouseEvent.CLICK, okClickHandler)
        }

        public function setNamePhase():void
        {
            _nameMark.gotoAndStop(LABEL_MARK_ENABLE);
            _cardMark.gotoAndStop(LABEL_MARK_DISABLE);
            _avatarMark.gotoAndStop(LABEL_MARK_DISABLE);
        }
        public function setAvatarPhase():void
        {
            _nameMark.gotoAndStop(LABEL_MARK_DISABLE);
            _avatarMark.gotoAndStop(LABEL_MARK_ENABLE);
            _cardMark.gotoAndStop(LABEL_MARK_DISABLE);
        }

        public function setCardPhase():void
        {
            _nameMark.gotoAndStop(LABEL_MARK_DISABLE);
            _avatarMark.gotoAndStop(LABEL_MARK_DISABLE);
            _cardMark.gotoAndStop(LABEL_MARK_ENABLE);
        }

        public function prevOn():void
        {
            _prevArrow.visible = true;
        }

        public function prevOff():void
        {
            _prevArrow.visible = false;
        }

        public function nextOn():void
        {
            _nextArrow.visible = true;
        }

        public function nextOff():void
        {
            _nextArrow.visible = false;
        }

        public function okButton():SimpleButton
        {
            return _okButton;
        }
        private function prevClickHandler(e:Event):void
        {
            dispatchEvent(new Event(PREV_CLICK));
        }

        private function nextClickHandler(e:Event):void
        {
            dispatchEvent(new Event(NEXT_CLICK));
        }

        private function okClickHandler(e:Event):void
        {
            dispatchEvent(new Event(OK_CLICK));
        }



    }

}

