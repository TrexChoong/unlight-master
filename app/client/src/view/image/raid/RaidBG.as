package view.image.raid
{

    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.*;
    import view.utils.*;
    import view.image.*;
    import controller.RaidCtrl;

    import model.ProfoundInventory;

    /**
     * BG表示クラス
     *
     */


    public class RaidBG extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/raid/raid_base.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const BUTTON_NEXT_DECK:String  = "btn_deck_next";
        private static const BUTTON_BACK_DECK:String  = "btn_deck_back";
        private static const BUTTON_CHAT_OPEN:String  = "btn_chat_open";
        private static const BUTTON_CHAT_CLOSE:String = "btn_chat_close";
        private static const BUTTON_CODE:String       = "btn_code";

        public static const STATE_NONE:int = 0;
        public static const STATE_INPROGRESS:int = 1;

        private var _backDeckButton:SimpleButton;
        private var _nextDeckButton:SimpleButton;
        private var _chatOpenButton:SimpleButton;
        private var _chatCloseButton:SimpleButton;
        private var _codeButton:SimpleButton;

        private var _ctrl:RaidCtrl = RaidCtrl.instance;

        private var _state:int;

        private var _chatOpenFunc:Function = null;
        private var _chatCloseFunc:Function = null;

        private var _countLabel:Label = new Label();

        private const _LABEL_CNT_X:int  = 430;
        private const _LABEL_CNT_Y:int  = 485;
        private const _LABEL_CNT_W:int  = 50;
        private const _LABEL_CNT_H:int  = 40;

        /**
         * コンストラクタ
         *
         */
        public function RaidBG()
        {
            super();
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _backDeckButton  = SimpleButton(_root.getChildByName(BUTTON_BACK_DECK));
            _nextDeckButton  = SimpleButton(_root.getChildByName(BUTTON_NEXT_DECK));
            _chatOpenButton  = SimpleButton(_root.getChildByName(BUTTON_CHAT_OPEN));
            _chatCloseButton = SimpleButton(_root.getChildByName(BUTTON_CHAT_CLOSE));
            _codeButton      = SimpleButton(_root.getChildByName(BUTTON_CODE));

            changeStateImage();

            _chatOpenButton.addEventListener(MouseEvent.CLICK,chatOpenClickHandler);
            _chatCloseButton.addEventListener(MouseEvent.CLICK,chatCloseClickHandler);

            _countLabel.x      = _LABEL_CNT_X;
            _countLabel.y      = _LABEL_CNT_Y;
            _countLabel.width  = _LABEL_CNT_W;
            _countLabel.height = _LABEL_CNT_H;
            _countLabel.styleName = "RaidCountLabel";
            _countLabel.filters = [new GlowFilter(0x000000, 1, 1.5, 1.5, 16, 1),];
            _countLabel.text = ProfoundInventory.battleProfoundCount.toString();

            addChild(_countLabel);
        }


        public override function init():void
        {
            _ctrl.addEventListener(RaidCtrl.RAID_INPROGRESS, improgressHandler);
            _ctrl.addEventListener(RaidCtrl.RAID_SOLVED, solevedHandler);
        }

        public  override function final():void
        {
            _ctrl.removeEventListener(RaidCtrl.RAID_INPROGRESS, improgressHandler);
            _ctrl.removeEventListener(RaidCtrl.RAID_SOLVED, solevedHandler);

            _chatOpenButton.removeEventListener(MouseEvent.CLICK,chatOpenClickHandler);
            _chatCloseButton.removeEventListener(MouseEvent.CLICK,chatCloseClickHandler);

            _chatOpenFunc = null;
            _chatCloseFunc = null;
        }

        public function get back():SimpleButton
        {
            return _backDeckButton;
        }
        public function get next():SimpleButton
        {
            return _nextDeckButton;
        }

        public function get chatOpen():SimpleButton
        {
            return _chatOpenButton;
        }
        public function get chatClose():SimpleButton
        {
            return _chatCloseButton;
        }
        public function get code():SimpleButton
        {
            return _codeButton;
        }

        private function startClickHandler(e:MouseEvent):void
        {
            //_ctrl.startRaid()
        }

        private function quitClickHandler(e:MouseEvent):void
        {
            //_ctrl.quitRaid()
        }

        private function itemClickHandler(e:MouseEvent):void
        {
            //_ctrl.showItem()
        }

        private function improgressHandler(e:Event):void
        {
            changeState(STATE_INPROGRESS);
        }

        private function solevedHandler(e:Event):void
        {
            changeState(STATE_NONE);
        }


        public function changeState(i:int):void
        {
            _state = i;
            waitComplete(changeStateImage);
        }


        private function changeStateImage():void
        {
            switch (_state)
            {
            case STATE_NONE:
                _backDeckButton.visible = true;
                _nextDeckButton.visible = true;
                break;
            case STATE_INPROGRESS:
                _backDeckButton.visible = false;
                _nextDeckButton.visible = false;
                break;
            default:
            }
        }

        public function setChatBtnFunc(openFunc:Function,closeFunc:Function):void
        {
            _chatOpenFunc = openFunc;
            _chatCloseFunc = closeFunc;
        }

        public function chatWindowOpen():void
        {
            _root.gotoAndPlay("open");
        }
        public function chatWindowClose():void
        {
            _root.gotoAndPlay("close");
        }

        public function chatOpenBtnEventReset():void
        {
            _chatOpenButton  = SimpleButton(_root.getChildByName(BUTTON_CHAT_OPEN));
            _chatOpenButton.addEventListener(MouseEvent.CLICK,chatOpenClickHandler);
        }
        public function chatCloseBtnEventReset():void
        {
            _chatCloseButton = SimpleButton(_root.getChildByName(BUTTON_CHAT_CLOSE));
            _chatCloseButton.addEventListener(MouseEvent.CLICK,chatCloseClickHandler);
        }
        private function chatOpenClickHandler(e:MouseEvent):void
        {
            // log.writeLog(log.LV_DEBUG, this,"chatOpenFunc",_chatOpenButton);
            if (_chatOpenFunc != null) {
                _chatOpenFunc(e);
            }
        }
        private function chatCloseClickHandler(e:MouseEvent):void
        {
            // log.writeLog(log.LV_DEBUG, this,"chatCloseFunc",_chatCloseButton);
            if (_chatCloseFunc != null) {
                _chatCloseFunc(e);
            }
        }

        public function updateBtlPrfCount():void
        {
            log.writeLog(log.LV_DEBUG, this,"updateBtlPrfCount",ProfoundInventory.battleProfoundCount);
            _countLabel.text = ProfoundInventory.battleProfoundCount.toString();
        }

    }

}

