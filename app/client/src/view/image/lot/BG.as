package view.image.lot
{

    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import flash.filters.GlowFilter;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;



    import mx.containers.*;
    import mx.controls.*;

    import model.DeckEditor;
    import model.events.*;
    import view.image.BaseImage;
    import view.utils.*;
    import controller.*;
    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/lot/gacha_base.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;
        private static const _BUTTON_A:String = "btn_lot_a"
        private static const _BUTTON_B:String = "btn_lot_b"
        private static const _BUTTON_C:String = "btn_lot_c"
        private static const _MESSAGE:String = "messege"

        private var _goldButton:SimpleButton;
        private var _silverButton:SimpleButton;
        private var _bronzeButton:SimpleButton;
        private var _originalY:int;
        private var _overBronzeFunction:Function;
        private var _overSilverFunction:Function;
        private var _overGoldFunction:Function;
        private var _outFunction:Function;
        private var _downFunction:Function;
        private var _hiding:Boolean = false;


        /**
         * コンストラクタ
         *
         */
        public function BG()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            SwfNameInfo.toLog(_root);
            _bronzeButton = SimpleButton(_root.getChildByName(_BUTTON_A));
            _silverButton = SimpleButton(_root.getChildByName(_BUTTON_B));
            _goldButton = SimpleButton(_root.getChildByName(_BUTTON_C));

        // CONFIG::LOCALE_TCN
        // {
        //    RemoveChild.apply(_goldButton);
        // }


//            RemoveChild.apply(_goldButton);
//            RemoveChild.apply(_bronzeButton);
            _bronzeButton.addEventListener(MouseEvent.CLICK, bronzeButtonClickHandler);
            _bronzeButton.addEventListener(MouseEvent.ROLL_OVER, mouseOverBronzeHandler);
            _bronzeButton.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _silverButton.addEventListener(MouseEvent.CLICK, silverButtonClickHandler);
            _silverButton.addEventListener(MouseEvent.ROLL_OVER, mouseOverSilverHandler);
            _silverButton.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _goldButton.addEventListener(MouseEvent.ROLL_OVER, mouseOverGoldHandler);
            _goldButton.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _goldButton.addEventListener(MouseEvent.CLICK, goldButtonClickHandler);
            _originalY = _silverButton.y;
            
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public override function final():void
        {
            _bronzeButton.removeEventListener(MouseEvent.CLICK, bronzeButtonClickHandler);
            _bronzeButton.removeEventListener(MouseEvent.ROLL_OVER, mouseOverBronzeHandler);
            _bronzeButton.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _silverButton.removeEventListener(MouseEvent.ROLL_OVER, mouseOverSilverHandler);
            _silverButton.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _silverButton.removeEventListener(MouseEvent.CLICK, silverButtonClickHandler);
            _goldButton.removeEventListener(MouseEvent.ROLL_OVER, mouseOverGoldHandler);
            _goldButton.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _goldButton.removeEventListener(MouseEvent.CLICK, goldButtonClickHandler)
            LobbyCtrl.instance.removeEventListener(LobbyCtrl.RARE_CARD_GET_EVENT_FINISH,finishHandler);
            _overBronzeFunction = null;
            _overSilverFunction = null;
            _overGoldFunction = null;
            _outFunction = null;
            _downFunction = null;
        }

        private function bronzeButtonClickHandler(e:Event):void
        {
            _hiding = true;
            hideButton(_bronzeButton, bronzeButtonClickHandler)
            LobbyCtrl.instance.drawRareCardLot(Const.LOT_TYPE_BRONZE);

            if (_downFunction!=null)
            {
                _downFunction();
            }
        }

        private function silverButtonClickHandler(e:Event):void
        {
            _hiding = true;
            hideButton(_silverButton, silverButtonClickHandler)
            LobbyCtrl.instance.drawRareCardLot(Const.LOT_TYPE_SILVER);

            if (_downFunction!=null)
            {
                _downFunction();
            }
        }

        private function goldButtonClickHandler(e:Event):void
        {
            _hiding = true;
            hideButton(_goldButton, goldButtonClickHandler)
            LobbyCtrl.instance.drawRareCardLot(Const.LOT_TYPE_GOLD);

            if (_downFunction!=null)
            {
                _downFunction();
            }
        }


        private function hideButton(b:SimpleButton,f:Function):void
        {
            _bronzeButton.removeEventListener(MouseEvent.CLICK, bronzeButtonClickHandler)
            _silverButton.removeEventListener(MouseEvent.CLICK, silverButtonClickHandler)
            _goldButton.removeEventListener(MouseEvent.CLICK, goldButtonClickHandler)

            LobbyCtrl.instance.addEventListener(LobbyCtrl.RARE_CARD_GET_EVENT_FINISH,finishHandler);
            BetweenAS3.tween(_silverButton,
                             {y: _silverButton.y  + 350},
                             null,
                             0.2,
                             Sine.easeIn
                ).play();
            BetweenAS3.tween(_bronzeButton,
                             {y: _bronzeButton.y  + 350},
                             null,
                             0.2,
                             Sine.easeIn
                ).play();
            BetweenAS3.tween(_goldButton,
                             {y: _goldButton.y  + 350},
                             null,
                             0.2,
                             Sine.easeIn
                ).play();

        }

        private function finishHandler(e:Event):void
        {
            _bronzeButton.addEventListener(MouseEvent.CLICK, bronzeButtonClickHandler)
            _silverButton.addEventListener(MouseEvent.CLICK, silverButtonClickHandler)
            LobbyCtrl.instance.removeEventListener(LobbyCtrl.RARE_CARD_GET_EVENT_FINISH,finishHandler);
            BetweenAS3.serial(
            BetweenAS3.tween(_silverButton,
                             {y: _originalY},
                             null,
                             0.2,
                             Sine.easeIn
                ),
            BetweenAS3.func(_silverButton.addEventListener,[MouseEvent.CLICK, silverButtonClickHandler]),
            BetweenAS3.func(isHide,[false])
//             BetweenAS3.delay(
//                 BetweenAS3.func(mouseOutHandler,[e]),
//                 0.5,0.0)
                ).play();

            BetweenAS3.serial(
            BetweenAS3.tween(_bronzeButton,
                             {y: _originalY},
                             null,
                             0.2,
                             Sine.easeIn
                ),
            BetweenAS3.func(_bronzeButton.addEventListener,[MouseEvent.CLICK, bronzeButtonClickHandler]),
            BetweenAS3.func(isHide,[false])
//             BetweenAS3.delay(
//                 BetweenAS3.func(mouseOutHandler,[e]),
//                 0.5,0.0)
                ).play();

            BetweenAS3.serial(
            BetweenAS3.tween(_goldButton,
                             {y: _originalY},
                             null,
                             0.2,
                             Sine.easeIn
                ),
            BetweenAS3.func(_goldButton.addEventListener,[MouseEvent.CLICK, goldButtonClickHandler]),
            BetweenAS3.func(isHide,[false])
//             BetweenAS3.delay(
//                 BetweenAS3.func(mouseOutHandler,[e]),
//                 0.5,0.0)
                ).play();

        }

        private function mouseOverBronzeHandler(e:Event):void
        {
            if (_overBronzeFunction!=null&&!_hiding)
            {
                _overBronzeFunction();
            }
        }

        private function mouseOverSilverHandler(e:Event):void
        {
            if (_overSilverFunction!=null&&!_hiding)
            {
                _overSilverFunction();
            }
        }

        private function mouseOverGoldHandler(e:Event):void
        {
            if (_overGoldFunction!=null&&!_hiding)
            {
                _overGoldFunction();
            }
        }

        private function mouseOutHandler(e:Event):void
        {
            if (_outFunction!=null&&!_hiding)
            {
                _outFunction();
            }
        }

        public function setOutFunc(f:Function):void
        {
            _outFunction = f;

        }

        public function setOverBronzeFunc(f:Function):void
        {
            _overBronzeFunction = f;
        }

        public function setOverSilverFunc(f:Function):void
        {
            _overSilverFunction = f;
        }

        public function setOverGoldFunc(f:Function):void
        {
            _overGoldFunction = f;
        }

        public function setDownFunc(f:Function):void
        {

                _downFunction = f;
        }

        private function isHide(b:Boolean):void
        {
            _hiding = b;
        }
    }

}
