package view.image.requirements
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {
        public static const TYPE_CHARA:int = 0;
        public static const TYPE_WEAPON:int = 1;

        // HP表示元SWF
        [Embed(source="../../../../data/image/compo/compo_bg.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        private const COMPO_BUTTON:String = "btn_unlock";
        private const LOCK_BUTTON:String = "unlock_dis";
        private const UP_BUTTON:String = "btn_up";
        private const DOWN_BUTTON:String = "btn_dn";
        private const UP_10_BUTTON:String = "btn_10_up";
        private const DOWN_10_BUTTON:String = "btn_10_dn";
        private const BTN_CMP:String = "btn_comp";
        private var _compoButton:SimpleButton;
        private var _lockButton:MovieClip;
        private var _upButton:SimpleButton;
        private var _downButton:SimpleButton;
        private var _up10Button:SimpleButton;
        private var _down10Button:SimpleButton;
        private var _btnCompo:SimpleButton; // 武器合成用

        private var _num:int = 0;
        private var _exchangeMax:int;
        private var _exchangeNum:int;
        private var _type:int = TYPE_CHARA;

        /**
         * コンストラクタ
         *
         */

        public function BG(type:int = TYPE_CHARA)
        {
            _type = type;
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            if (_type == TYPE_WEAPON ) {
                _root.gotoAndStop(2);
            }  else {
                initializePos();
            }
            _lockButton = MovieClip(_root.getChildByName(LOCK_BUTTON));
            _lockButton.visible =false;
            _compoButton = SimpleButton(_root.getChildByName(COMPO_BUTTON));
            _upButton = SimpleButton(_root.getChildByName(UP_BUTTON));
            _downButton = SimpleButton(_root.getChildByName(DOWN_BUTTON));
            _up10Button = SimpleButton(_root.getChildByName(UP_10_BUTTON));
            _down10Button = SimpleButton(_root.getChildByName(DOWN_10_BUTTON));
            _btnCompo = SimpleButton(_root.getChildByName(BTN_CMP));
            log.writeLog (log.LV_DEBUG,this,"swfinit",_compoButton,_upButton,_downButton);
            buttonHide();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            MovieClip(_root.getChildByName("arrow")).visible = false;
        }

        // データをセット
        public function setDetail(num:int):void
        {
            _num = num;
            waitComplete(setDetailComplete);
        }

        public function buttonHide():void
        {
            _compoButton.visible =false;
            _upButton.visible =false;
            _downButton.visible =false;
            _up10Button.visible =false;
            _down10Button.visible =false;
            // _lockButton.visible = true;
            _btnCompo.visible =false;
        }
        public function buttonShow(num:int, max:int):void
        {
            if(num >= max&&num == 1)
            {
                _upButton.visible =false;
                _downButton.visible =false;
            }
            else if(num >= max)
            {
                _upButton.visible =false;
                _downButton.visible =true;

            }else if(num <= 1)
            {
                _upButton.visible =true;
                _downButton.visible =false;
            }else{
                _upButton.visible =true;
                _downButton.visible =true;
            }

            _up10Button.visible =false;
            _down10Button.visible =false;
            _compoButton.visible =true;
            _lockButton.visible = false;

        }

        // データをセット
        public function setDetailComplete():void
        {
            // カードの枚数を設定
            if(_num)
            {
                MovieClip(_root.getChildByName("arrow")).visible = true;
                MovieClip(_root.getChildByName("arrow")).gotoAndStop(_num);
            }
            else
            {
                MovieClip(_root.getChildByName(LOCK_BUTTON)).visible = false;
                MovieClip(_root.getChildByName("arrow")).visible = false;
            }
        }


        // ボタンを取得
        public function get unlock():SimpleButton
        {
            return _compoButton;
        }
        // ボタンを取得
        public function get compo():SimpleButton
        {
            return _btnCompo;
        }


        // ボタンを取得
        public function get lock():MovieClip
        {
            return _lockButton;
        }

        public function get upButton():SimpleButton
        {
            return _upButton;
        }

        public function get downButton():SimpleButton
        {
            return _downButton;
        }

    }

}
