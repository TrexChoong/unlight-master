package view.image.match
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;
    import view.utils.*;

    import controller.TitleCtrl;

    import model.Option;

    /**
     * ローディング用パネルクラス
     *
     */

    public class LoadingPanel extends Panel
    {
        // タイトル表示
        private var _text:Label = new Label();

        private static var __loadingPanel:LoadingPanel;
        private static var __clickHandler:Function;

        /**
         * コンストラクタ
         *
         */


        public static function create(di:Sprite):void
        {
            if (__loadingPanel !=null)
            {
                di.addChild(__loadingPanel)
            }
            else
            {
                __loadingPanel = new LoadingPanel()
                di.addChild(__loadingPanel)
            }
            __loadingPanel.visible = false;
        }

        public static function final():void
        {
            if (__loadingPanel !=null)
            {
                if(__clickHandler != null)
                {
                    __loadingPanel.removeEventListener(MouseEvent.CLICK,__clickHandler);
                    __clickHandler = null;
                }
                RemoveChild.apply(__loadingPanel);
                __loadingPanel = null;

            }
        }

        public static function onLoading():void
        {
            if (__loadingPanel !=null)
            {
                __loadingPanel.visible = true;
            }
        }
        public static function offLoading():void
        {
            if (__loadingPanel !=null)
            {
                __loadingPanel.visible = false;
            }
        }

        public static function setClickHandler(f:Function):void
        {
            if (__loadingPanel !=null)
            {
                if (__clickHandler != null)
                {
                    __loadingPanel.removeEventListener(MouseEvent.CLICK,__clickHandler);
                }
                __clickHandler = f;
                __loadingPanel.addEventListener(MouseEvent.CLICK,__clickHandler);
            }
        }

        public function LoadingPanel()
        {
            super();
            x = 85;
            y = 170;
            width  = 200;
            height = 100;
            layout = "absolute"
            title = "loading";

            _text.x = 20;
            _text.y = 50;
            _text.width = 150;
            _text.height = 50;
            _text.text = "Now Loading";
            _text.styleName = "GameLobbyLoadingLabel";
            addChild(_text);
        }
    }
}