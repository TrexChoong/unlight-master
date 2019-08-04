package view.image.lobby
{

    import flash.display.*;
    import flash.events.Event;
    import mx.core.*

    import view.image.BaseImage;
    import view.utils.*;
    /**
     * BG表示クラス
     *
     */


    public class EntranceSet extends BaseImage
    {

        [Embed(source="../../../../data/image/lobby/entrance.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;
        private var _cardSB:SimpleButton;
        private var _optionSB:SimpleButton;
        private var _itemSB:SimpleButton;
        private var _shopSB:SimpleButton;
        private var _questSB:SimpleButton;
        private var _battleSB:SimpleButton;
        private var _tutorialSB:SimpleButton;
        private var _lotSB:SimpleButton;
        private var _librarySB:SimpleButton;
        private var _serialSB:SimpleButton;
        private var _raidSB:SimpleButton;
        private var _infoSB:SimpleButton;

        private var _saleMC:MovieClip;

//         private var _battleMC:MovieClip;
//         private var _cardMC:MovieClip;
//         private var _optionMC:MovieClip;
//         private var _itemMC:MovieClip;
//         private var _shopMC:MovieClip;
//         private var _questMC:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function EntranceSet()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            initializePos();
            _questSB = SimpleButton(_root.getChildByName("btn_b"));
            _itemSB = SimpleButton(_root.getChildByName("btn_e"));
            _battleSB = SimpleButton(_root.getChildByName("btn_f"));
            _cardSB = SimpleButton(_root.getChildByName("btn_g"));
            _optionSB = SimpleButton(_root.getChildByName("btn_h"));
            _shopSB = SimpleButton(_root.getChildByName("btn_i"));
            _tutorialSB = SimpleButton(_root.getChildByName("btn_d"));
            _lotSB =  SimpleButton(_root.getChildByName("btn_j"));
            _librarySB =  SimpleButton(_root.getChildByName("btn_c"));
            _raidSB =  SimpleButton(_root.getChildByName("btn_k"));
            _infoSB =  SimpleButton(_root.getChildByName("btn_info"));
            _saleMC = MovieClip(_root.getChildByName("sale"));
            CONFIG::LOT_OFF
            {
                _lotSB.visible = false;
            }
            CONFIG::RAID_EVENT_OFF
            {
                if (_raidSB)_raidSB.visible = false;
            }
            CONFIG::LOCALE_JP
            {
                _serialSB = SimpleButton(_root.getChildByName("btn_serial"));
            }
            CONFIG::LOCALE_TCN
            {
                _serialSB = SimpleButton(_root.getChildByName("btn_serial"));
            }
            CONFIG::LOCALE_SCN
            {
                _serialSB = SimpleButton(_root.getChildByName("btn_serial"));
            }
            CONFIG::LOCALE_TH
            {
                _serialSB = SimpleButton(_root.getChildByName("btn_serial"))
            }
            CONFIG::LOCALE_EN
            {
                _serialSB = SimpleButton(_root.getChildByName("btn_serial"));
            }
            CONFIG::LOCALE_FR
            {
                _serialSB = SimpleButton(_root.getChildByName("btn_serial"));
            }

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            _root.play();
        }

        public function get battle():InteractiveObject
        {
            return _battleSB;
        }
        public function get card():InteractiveObject
        {
            return _cardSB;
        }
        public function get option():InteractiveObject
        {
            return _optionSB;
        }
        public function get item():InteractiveObject
        {
            return _itemSB;
        }
        public function get shop():InteractiveObject
        {
            return _shopSB;
        }
        public function get quest():InteractiveObject
        {
            return _questSB;
        }
        public function get tutorial():InteractiveObject
        {
            return _tutorialSB;
        }
        public function get lot():InteractiveObject
        {
            return _lotSB;
        }
        public function get library():InteractiveObject
        {
            return _librarySB;
        }
        public function get sale():MovieClip
        {
            return _saleMC;
        }
        public function get serial():InteractiveObject
        {
            return _serialSB;
        }
        public function get raid():InteractiveObject
        {
            return _raidSB;
        }
        public function get info():InteractiveObject
        {
            return _infoSB;
        }

    }

}

import flash.display.*;
import mx.managers.IToolTipManagerClient;

class SimpleButtonTI extends SimpleButton implements IToolTipManagerClient
{
    private var _toolTip:String;

    public function SimpleButtonTI(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null)
    {
        super();
    }
    public function get toolTip():String
    {
        return _toolTip;
    }
    public function set toolTip(value:String):void
    {
        _toolTip = value;
    }
    public function get measuredHeight():Number
    {
        return height;
    }
    public function get measuredWidth():Number
    {
        return width;

    }
    public function move(x:Number, y:Number):void
    {
        this.x = x;
        this.y = y;
    }
    public function setActualSize(newWidth:Number, newHeight:Number):void
    {

    }
}

