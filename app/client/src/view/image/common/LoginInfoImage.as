package view.image.common
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
     * LoginInfoImage表示クラス
     *
     */

    public class LoginInfoImage extends BaseImage
    {

        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/common/info_login.swf")]
        private var _Source:Class;

        // OKボタン
        private var _okButton:SimpleButton;
        private var _recordMC:MovieClip;
        private var _brauMC:MovieClip;
        private var _func:Function;
        private var _beginerMC:MovieClip;
        private var _saleMC:MovieClip;
        private var _saleValueLabel:Label = new Label();
        private static const _LABEL_WIDTH:int  = 20;
        private static const _LABEL_HEIGHT:int = 15;
        // 描画コンテナ
        private var _labelContainer:UIComponent = new UIComponent();

        /**
         * コンストラクタ
         *
         */
        public function LoginInfoImage()
        {
            _saleValueLabel.x = 350;
            _saleValueLabel.y = 318;
            _saleValueLabel.width = 100;
            _saleValueLabel.height = 100;
            _saleValueLabel.setStyle("fontSize",  64);
            _saleValueLabel.setStyle("color",  "#ffffff");
            _saleValueLabel.setStyle("fontFamily",  "bradley");
            _saleValueLabel.filters = [ new GlowFilter(0x000000, 1, 2, 2, 16, 1) ];
            // _saleValueLabel.selectable = false;
            super();

        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            _okButton = SimpleButton(_root.getChildByName("btn_ok"));
            _recordMC = MovieClip(_root.getChildByName("record"));
            _brauMC = MovieClip(_root.getChildByName("braw"));
            _saleMC = MovieClip(_root.getChildByName("sale"))
            _beginerMC = MovieClip(_root.getChildByName("novice"))
            _okButton.addEventListener(MouseEvent.CLICK, buttonHandler);
            setRecordMode();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function get ok():SimpleButton
        {
            return _okButton;
//            return SimpleButton(_root.getChildByName("exit"));
        }
        private function buttonHandler(e:Event):void
        {
            if (_func != null)
            {
                _func(e);
            }
        }

        public function setButtonFunc(func:Function):void
        {
            _func  = func;
        }
        public function removeButtonFunc():void
        {
            _func = null;
            _okButton.removeEventListener(MouseEvent.CLICK, buttonHandler);

        }
        // レコードチャレンジ画像
        public function setRecordMode():void
        {
            if(_recordMC != null)
            {
                _brauMC.visible = false;
                _recordMC.visible = true;
                _saleMC.visible = false;
                _beginerMC.visible = false;
            }
            RemoveChild.apply(_saleValueLabel);

        }

        // ニュース画像（ブラウのみON）
        public function setNewsMode():void
        {
            if(_recordMC != null)
            {
                _brauMC.visible = true;
                _recordMC.visible = false;
                _saleMC.visible = false;
                _beginerMC.visible = false;
            }
            RemoveChild.apply(_saleValueLabel);
        }

        // レコードチャレンジ(ビギナーON)
        public function setRecordBeginerMode():void
        {
            if(_recordMC != null)
            {
                _brauMC.visible = false;
                _recordMC.visible = false;
                _saleMC.visible = false;
                _beginerMC.visible = true;
            }
            RemoveChild.apply(_saleValueLabel);

        }

        // セール
        public function setSaleMode(val:Number):void
        {
            if(_recordMC != null)
            {
                _brauMC.visible = true;
                _recordMC.visible = false;
                _saleMC.visible = true;
                _beginerMC.visible = false;
            }
            addChild(_saleValueLabel);
            _saleValueLabel.text = (val*10).toString();
        }




    }
}
