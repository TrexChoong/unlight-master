package view.utils
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;

    import mx.core.UIComponent;
    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  取得確認パネル
     *
     */

    public class ConfirmPanel extends Panel
    {

        private static var __cp:ConfirmPanel;
        private static var __yesFunc:Function;
        private static var __yesArgs:Array;
        private static var __noFunc:Function;
        private static var __noArgs:Array;
        private static var __caller:Object;
        private static var __bg:Shape = new Shape();
        private static var __bgContainer:UIComponent = new UIComponent();
        private static var __cancelMouseEnable:Boolean = false;

        // タイトル表示
        private var _text:Label = new Label();
        private var _text2:Label = new Label();

        // 決定ボタン
        private var _yesButton:Button = new Button();
        private var _noButton:Button = new Button();
        


        public static function show(title:String, text:String ,yesHandler:Function, caller:Object, args:Array = null,font:Boolean = false,cancelMouseEnable:Boolean = false, noHandler:Function = null, noArgs:Array = null):void
        {
            if (__cp == null){initPanel()}

            __cp.setText(title, text,font);
            __yesFunc = yesHandler;
            __yesArgs = args;
            __noFunc = noHandler;
            __noArgs = noArgs;
            __caller = caller;
            __cancelMouseEnable = cancelMouseEnable;

            Unlight.INS.topContainer.parent.addChild(__bgContainer);
            Unlight.INS.topContainer.parent.addChild(__cp);
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            
        }

        private static function yesHandler(e:MouseEvent):void
        {
            if (__yesFunc !=null&&__caller != null)
            {
                __yesFunc.apply(__caller, __yesArgs);
            }
            allRemove();
//             RemoveChild.apply(__cp);
//             RemoveChild.apply(__bgContainer);
            
//             Unlight.INS.topContainer.mouseEnabled = true;
//             Unlight.INS.topContainer.mouseChildren = true;
//             __caller = null;
//             __yesFunc = null;

//             SE.playClick();
        }

        private static function noHandler(e:MouseEvent):void
        {
            if (__noFunc !=null&&__caller != null)
            {
                __noFunc.apply(__caller, __noArgs);
            }
            allRemove(true);
//             RemoveChild.apply(__cp);
//             RemoveChild.apply(__bgContainer);
//             Unlight.INS.topContainer.mouseEnabled = true;
//             Unlight.INS.topContainer.mouseChildren = true;
//             __caller = null;
//             __yesFunc = null;

//             SE.playClick();
        }

        private static function allRemove(cancel:Boolean = false):void
        {
            RemoveChild.apply(__cp);
            RemoveChild.apply(__bgContainer);
            if(cancel&&__cancelMouseEnable)
            {

            }else{
                Unlight.INS.topContainer.mouseEnabled = true;
                Unlight.INS.topContainer.mouseChildren = true;
            }
            __caller = null;
            __yesFunc = null;
            __noFunc = null;
            __noArgs = null;

            SE.playClick();
        }
        private static function initPanel():void
        {
            __cp = new ConfirmPanel();
            __bg.graphics.beginFill(0x333333);
            __bg.graphics.drawRect(0, 0, Unlight.WIDTH, Unlight.HEIGHT);
            __bg.graphics.endFill();
            __bg.alpha = 0.5;
            __bgContainer.addChild(__bg);
        }
        /**
         * コンストラクタ
         *
         */
        public function ConfirmPanel()
        {
            super();
            x = 270;
            y = 280;
            width  = 250;
            height = 150;
            layout = "absolute";

            _text.x = 17;
            _text.y = 45;
            _text.width = 200;
            _text.height = 50;
            _text.styleName = "GetSendPanelLabel";

            _yesButton.x = 55;
            _yesButton.y = 100;
            _yesButton.width = 60;
            _yesButton.height = 23;
            _yesButton.label = "YES";

            _noButton.x = 125;
            _noButton.y = 100;
            _noButton.width = 60;
            _noButton.height = 23;
            _noButton.label = "NO";

            _yesButton.addEventListener(MouseEvent.CLICK, yesHandler)
            _noButton.addEventListener(MouseEvent.CLICK, noHandler)
            addChild(_text);
            addChild(_yesButton);
            addChild(_noButton);
        }

        public function setText(ti:String, te:String, font:Boolean):void
        {
            if (font)
            {
                _text.styleName = "GetSendPanelLabelNofont";
            }else{
                _text.styleName = "GetSendPanelLabel";
            }
            title = ti;
            _text.text = te;
            callLater(adjustSize,[_text])

        }

        private function adjustSize(label:Label):void
        {
            var w:int = label.width;
            label.validateNow();
            label.width = label.textWidth+25;
            label.height = label.textHeight+25;
            label.y = 70 - label.textHeight/2;
            width =  label.textWidth+60;
//            height =  label.textHeight+60;

            _yesButton.x = width/2 - _yesButton.width -5;
            _noButton.x = width/2 +5;
            x = Unlight.WIDTH/2-width/2

        }

    }
}