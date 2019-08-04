package view.image.raid
{

    import flash.display.*;
    import flash.events.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;

    import model.MessageLog
    import view.image.BaseImage;
    import view.scene.common.*;

    /**
     * チャットのBGクラス
     *
     */


    public class RaidChatBase extends BaseImage
    {

        // カードの下
        [Embed(source="../../../../data/image/game/chat_base.swf")]
//         private static var FONT_HEIGHT:int = 14;  // フォントの高さ
//         private static var AREA_HEIGHT:int = 280;  // エリアの高さ

        private var _Source:Class;

        public static const CHAT_ON:String = "chat_on"
        public static const TAB1_ON:String = "tab1_on"
        public static const TAB2_ON:String = "tab2_on"
        public static const TAB3_ON:String = "tab3_on"

        private static const WIDHT:int = 193;
        private static const HEIGHT:int = 295;
        private static const X:int = 100;
        private static const Y:int = 0;
//         private var _chatSwitch:SimpleButton;
        private var _chatSwitch:MovieClip;
        private var _chatTab1:SimpleButton;
        private var _chatTab2:SimpleButton;
        private var _chatTab3:SimpleButton;



        /**
         * コンストラクタ
         *
         */
        public function RaidChatBase()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
            _chatSwitch = MovieClip(MovieClip(_root.getChildByName("chat_base")).getChildByName("textarea"));
            _chatTab1 = SimpleButton(MovieClip(_root.getChildByName("chat_base")).getChildByName("tab_a"));
            _chatTab2 = SimpleButton(MovieClip(_root.getChildByName("chat_base")).getChildByName("tab_b"));
            _chatTab3 = SimpleButton(MovieClip(_root.getChildByName("chat_base")).getChildByName("tab_c"));
            init();
        }
        override public  function init():void
        {
            _chatSwitch.addEventListener(MouseEvent.CLICK,swithHandler);
            _chatTab1.addEventListener(MouseEvent.CLICK,tab1Handler);
            _chatTab2.addEventListener(MouseEvent.CLICK,tab2Handler);
            _chatTab3.addEventListener(MouseEvent.CLICK,tab3Handler);
            

        }
        override public  function final():void
        {
            if(_chatSwitch != null)
            {
                _chatSwitch.removeEventListener(MouseEvent.CLICK,swithHandler);
                _chatTab1.removeEventListener(MouseEvent.CLICK,tab1Handler);
                _chatTab2.removeEventListener(MouseEvent.CLICK,tab2Handler);
                _chatTab3.removeEventListener(MouseEvent.CLICK,tab3Handler);
            }

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
//             x = X;
//             y = Y;
        }


        private function swithHandler(e:Event):void
        {
            dispatchEvent(new Event(CHAT_ON));
        }

        private function tab1Handler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"tab1");
            _chatTab1.visible = false;
            _chatTab2.visible = true;
            _chatTab3.visible = true;
            dispatchEvent(new Event(TAB1_ON));
        }

        private function tab2Handler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"tab2");
            _chatTab1.visible = true;
            _chatTab2.visible = false;
            _chatTab3.visible = true;
            dispatchEvent(new Event(TAB2_ON));
        }

        private function tab3Handler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this,"tab3");
            _chatTab1.visible = true;
            _chatTab2.visible = true;
            _chatTab3.visible = false;
            dispatchEvent(new Event(TAB3_ON));
        }

        public function onActive():void
        {
            waitComplete(setEnable);
        }

        // 有効に
        public function onNonactive():void
        {
            waitComplete(setDisable);
        }

        private function setEnable():void
        {
            _root.gotoAndStop("on");
        }

        private function setDisable():void
        {
            _root.gotoAndStop("off");
        }

        private function setStandby():void
        {
            _root.gotoAndStop("standby");
        }

        public function setTabEnabled(f:Boolean = true):void
        {
            _chatTab1.visible = _chatTab2.visible = _chatTab3.visible = f;
            _chatTab1.mouseEnabled = _chatTab2.mouseEnabled = _chatTab3.mouseEnabled = f;
        }

    }

}
