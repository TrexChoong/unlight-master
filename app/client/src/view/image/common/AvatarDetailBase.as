package view.image.common
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.Text;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import view.LogListView;

    /**
     * AvatarDetailBase表示クラス
     *
     */

    public class AvatarDetailBase extends BaseImage
    {

        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/common/gene.swf")]
        private var _Source:Class;
        private var _frame:int;

        private var _backButton:SimpleButton;
        private var _exitButton:SimpleButton;

        private var _logListButton:SimpleButton;

        private var _logoutButton:SimpleButton;
        /**
         * コンストラクタ
         *
         */
        public function AvatarDetailBase()
        {
            super();
        }

        override protected function swfinit(event: Event):void
        {
             super.swfinit(event);
            _logoutButton = SimpleButton(_root.getChildByName("logout"));
            _logoutButton.visible = false;
            _backButton = SimpleButton(_root.getChildByName("back"));
            _exitButton = SimpleButton(_root.getChildByName("exit"));
            _logListButton = SimpleButton(_root.getChildByName("log"));
            SimpleButton(_root.getChildByName("exit")).visible = false;
            _logListButton.addEventListener(MouseEvent.CLICK,logCLickHandler);

//         CONFIG::LOCALE_TCN
        _logListButton.visible = false;


//             mouseEnabled = false;
//             mouseChildren = false;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function logCLickHandler(e:MouseEvent):void
        {
            LogListView.show();
        }

        public function get back():SimpleButton
        {
            return _backButton;
//            return SimpleButton(_root.getChildByName("back"));
        }
        public function get exit():SimpleButton
        {
            return _exitButton;
//            return SimpleButton(_root.getChildByName("exit"));
        }
        public function get logout():SimpleButton
        {
            return _logoutButton;
        }

        public function get logList():SimpleButton
        {
            LogListView.show();
            return _logListButton;
        }

//         public function setTitle():void
//         {
//             _root.gotoAndStop("lobby");
//         }


    }

}
