/**
  * Unlight
  * Copyright(c)2019 CPA This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */

package
{
    import flash.display.*;
    import flash.events.*;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import sound.se.AlertSE;
    import com.rails2u.bridge.JSProxy;

    public  class Alerter extends Alert
    {
        private static var __yesHandler:Function;
        private static var __closeHandler:Function;
        private static var __on:Boolean = false;

        public static function showWithSize(text:String = "", title:String = "", flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null, h:int = 100, w:int =200, iconClass:Class = null, defaultButtonFlag:uint = 0x4):Alert
        {
            var handler:Function;
            if (closeHandler ==null)
            {

            }else{
                __closeHandler = closeHandler;
            }

            if (!__on)
            {
                var a:Alert = show (text, title, flags, parent, closeOffHandler, iconClass, defaultButtonFlag);
                SE.playAlert();
                a.height = h;
                __on = true;
            }
            return a;
        }

        public static function showConfirmWithSize(text:String = "", title:String = "", cHandler:Function = null, h:int = 100, w:int =200, iconClass:Class = null, defaultButtonFlag:uint = Alert.NO,style:String = "BuySendPanelLabel"):Alert
        {
            SE.playAlert();
            Alert.yesLabel = "はい"
            Alert.noLabel = "いいえ"
            var a:Alert = show (text, title, Alert.YES|Alert.NO, null, yesHandler
                                , iconClass, defaultButtonFlag);

            __yesHandler = cHandler;
            log.writeLog(log.LV_FATAL, "alert confirm ", text, title);
            a.styleName = style;
            a.width = 270;
            a.height = 140;
            return a;
        }

        public static function yesHandler(e:CloseEvent):void
        {
            __on = false;
            if (e.detail ==Alert.YES)
            {
                log.writeLog(log.LV_INFO,  "++++");
                if (__yesHandler!=null){__yesHandler()}
            }

        }

        public static function closeOffHandler(e:CloseEvent):void
        {
            __on = false;
            if (__closeHandler !=null)
            {
                __closeHandler(e);
                __closeHandler = null;
            }

        }
        public static function forceOff():void
        {
            __on = false;
        }


        public static function reloadWindow(event:Event):void
        {
            JSProxy.proxy.location.$reload();
        }
    }
}