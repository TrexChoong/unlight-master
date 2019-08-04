package view.image.raid
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.filters.*;

    import mx.core.UIComponent;
    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;
    import view.utils.*;

    import model.Player;
    import model.Profound;
    import model.Option;

    /**
     *  使用パネル
     *
     */
    public class StartBattlePanel extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/raid/raid_turn.swf")]
        private var _Source:Class;

        private static const OK:String ="btn_ok";
        private static const CLOSE:String = "btn_close";

        private var _prf:Profound;

        private var _setTurnLabel:Label = new Label();
        private var _useApLabel:Label = new Label();

        private var _apLabel:Label = new Label();

        // 決定ボタン
        private var _okButton:SimpleButton;
        private var _closeButton:SimpleButton;

        // ターン選択
        private var _selTurnBox:SelectTurnComboBox = new SelectTurnComboBox();

        private var _defAp:int = 0;
        private var _useAp:int = 0;
        private var _okFunc:Function;
        private var _closeFunc:Function;

        /**
         * コンストラクタ
         *
         */
        public function StartBattlePanel()
        {
            super();
            x = 230;
            y = 250;

            _setTurnLabel.x = 20;
            _setTurnLabel.y = 55;
            _setTurnLabel.width = 135;
            _setTurnLabel.height = 50;
            _setTurnLabel.text = "";
            _setTurnLabel.styleName = "GetSendPanelLabel";
            _setTurnLabel.filters = [new GlowFilter(0x000000, 0.9, 2.5, 2.5, 2, 1),];

            _useApLabel.x = 170;
            _useApLabel.y = 64;
            _useApLabel.width = 200;
            _useApLabel.height = 50;
            _useApLabel.styleName = "GetSendPanelMapApLabel";
            _useApLabel.filters = [new GlowFilter(0xFFFFFF, 1.0, 2, 2, 2, 1),];

            _apLabel.x = 160;
            _apLabel.y = 64;
            _apLabel.width = 28;
            _apLabel.height = 50;
            _apLabel.styleName = "GetSendPanelMapApLabel";
            _apLabel.filters = [new GlowFilter(0xFFFFFF, 1.0, 2, 2, 2, 1),];
            _apLabel.mouseEnabled = false;
            _apLabel.mouseChildren = false;

            _selTurnBox.addEventListener(ListEvent.CHANGE, selTurnHandler);
            _selTurnBox.visible = true;
            _selTurnBox.mouseEnabled = true;
            _selTurnBox.mouseChildren = true;
            //addChild(_setTurnLabel);
            addChild(_apLabel);
            addChild(_useApLabel);
            addChild(_selTurnBox);
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _okButton = SimpleButton(_root.getChildByName(OK));
            _closeButton = SimpleButton(_root.getChildByName(CLOSE));
            _okButton.addEventListener(MouseEvent.CLICK, okHandler);
            _closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
        }

        override public function final():void
        {
            _okButton.removeEventListener(MouseEvent.CLICK, okHandler);
            _closeButton.removeEventListener(MouseEvent.CLICK, closeHandler);
            _okFunc = null;
            _closeFunc = null;
        }

        //
        public function setOKHandler(handler:Function):void
        {
             _okFunc = handler;
        }
        public function setCloseHandler(handler:Function):void
        {
             _closeFunc = handler;
        }

        public function setProfound(prf:Profound):void
        {
            _prf = prf;
            _selTurnBox.selectedIndex = 0;
            setDefAp(prf.profoundData.level);
            setUseAp();
        }

        private function setDefAp(ap:int):void
        {
            _defAp = ap;
            _apLabel.htmlText = _defAp.toString();
        }

        private function setUseAp():void
        {
            _useAp = _selTurnBox.selTurn * _defAp;
            _useApLabel.htmlText = _useAp.toString();
            if (Player.instance.avatar.energy >= _useAp) {
                _useApLabel.setStyle("color","0x000000");
                _useApLabel.filters = [new GlowFilter(0xFFFFFF, 1.0, 2, 2, 2, 1),];
            } else {
                _useApLabel.setStyle("color","0xFF0000");
                _useApLabel.filters = [new GlowFilter(0x000000, 1.0, 2, 2, 2, 1),];
            }
        }

        private function selTurnHandler(e:Event):void
        {
            setUseAp();
        }

        public function okHandler(e:MouseEvent):void
        {
            if (_okFunc !=null)
            {
                _okFunc();
            }

        }

        public function closeHandler(e:MouseEvent):void
        {
            if (_closeFunc !=null)
            {
                _closeFunc();
            }

        }

        public function get selProfound():Profound
        {
            return _prf;
        }

        public function get selTurn():int
        {
            return _selTurnBox.selTurn;
        }

        public function get useAp():int
        {
            return _useAp;
        }


    }
}

import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.geom.*;

import mx.core.UIComponent;
import mx.controls.*;


/**
 * ターン選択用コンボボックス
 *
 */
class SelectTurnComboBox extends ComboBox
{
    private static const _X:int = 45;
    private static const _Y:int = 67;
    private static const _WIDTH:int = 40;
    private static const _HEIGHT:int = 18;

    private static const _SEL_TURN:Array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18];

    public function SelectTurnComboBox():void
    {
        dataProvider = _SEL_TURN;
        dropdownWidth = _WIDTH;
        x = _X;
        y = _Y;
        width  = _WIDTH;
        height = _HEIGHT;
        rowCount = 5;
    }

    public function get selTurn():int
    {
        return int(selectedItem);
    }
}
