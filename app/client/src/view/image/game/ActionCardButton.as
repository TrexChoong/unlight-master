package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.core.UIComponent;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;
    import org.libspark.betweenas3.core.easing.IEasing;
    import org.libspark.betweenas3.events.TweenEvent;
    import view.image.BaseImage;
    import model.Option;

    /**
     * ActionCardButton表示クラス
     *
     */


    public class ActionCardButton extends BaseImage
    {

        // ActionCardButton表示元SWF
        [Embed(source="../../../../data/image/cardaction.swf")]
        private var _Source:Class;

        private const _ARROW:String = "arrow";
        private const _ROTATE:String = "rotate";
        private var _arrow:MovieClip;
        private var _rotate:SimpleButton;
        // ローテートボタンハンドラ
        private var _func:Function;

        private var _blinkTween:ITween;

        /**
         * コンストラクタ
         *
         */
        public function ActionCardButton()
        {
            super();

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // 初期化関数
        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _arrow  = MovieClip(_root.getChildByName(_ARROW));
            _rotate  = SimpleButton(_root.getChildByName(_ROTATE));
            _arrow.visible = true;
            _rotate.visible = true;
            _arrow.y = -40;
            // ハンドラがあったら登録する
            if (_func != null)
            {
            _rotate.addEventListener(MouseEvent.CLICK,_func);
            }
            if (Option.instance.arrow)
            {
                _blinkTween =  BetweenAS3.serial(
                BetweenAS3.to(_arrow,{y:-44},0.4),
                BetweenAS3.to(_arrow,{y:-40},0.4)
                );
                _blinkTween.stopOnComplete = false;
                _blinkTween.play();
            }

        }

        public function registRotateHandler(func:Function):void
        {
            _func = func;
            // すでにインスタンスが確保されていれば登録する
            if (_rotate != null)
            {
            _rotate.addEventListener(MouseEvent.CLICK,_func);

            }
        }


        public function disposeRotateHandler():void
        {
            // すでにインスタンスが確保されていれば取り除く
            if (_rotate != null)
            {
                if (_func != null)
                {
                    _rotate.removeEventListener(MouseEvent.CLICK,_func);
                }
                _func = null;

            }
        }

        private function clickHandler(e:MouseEvent):void
        {

        }

        public function get rotateButton():SimpleButton
        {
            return _rotate;
        }

        public function arrowBlinkStart():void
        {
            if (_blinkTween != null && visible == false && Option.instance.arrow)
            {
                _rotate.visible = false;
                visible = true;
                _arrow.alpha = 0.8;
            }
        }

        public function arrowBlinkStop():void
        {
            if (_blinkTween != null && Option.instance.arrow)
            {
                _arrow.y = -40;
                _arrow.alpha = 1.0;
                _rotate.visible = true;
                visible = false;
            }
        }

    }

}
