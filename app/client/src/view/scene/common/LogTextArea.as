package view.scene.common
{

    import flash.display.*;
    import flash.text.*;
    import flash.events.*;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;
    import mx.styles.*;

    import model.MessageLog;
    import model.events.MessageLogEvent;
    import view.scene.BaseScene;

    import controller.ChatCtrl;

    /**
     * ログ表示用表示TextAreaクラス
     *
     */

    public class LogTextArea extends TextArea
    {
        protected var _log:MessageLog;

        /**
         * コンストラクタ
         *
         */
        public function LogTextArea(type:int)
        {
//            styleName = "LogArea";
            super();
            editable = false;
            ChatCtrl.instance.start();
            callLater(update);
            _log = MessageLog.getMessageLog(type)
        }

        protected function updateHandler(e:MessageLogEvent):void
        {
            update();
        }
        public override function set styleName(value:Object):void
        {
            super.styleName = value;
        }

        public function init():void
        {
//            text = "";
            log.writeLog(log.LV_INFO, this, "init");
            _log.addEventListener(MessageLogEvent.UPDATE, updateHandler);
        }

        public function final():void
        {
//            text = "";
            _log.removeEventListener(MessageLogEvent.UPDATE, updateHandler);
        }

        public function typeChange(type:int):void
        {
            _log = MessageLog.getMessageLog(type);
        }

        public function update():void
        {
            htmlText= _log.log.replace("_rename","");
            validateNow();
            var len:int = textHeight;
            if (len > 0)
            {
                var fontSize:int =getLineMetrics(0).height;
                //最新が最下段にくるようにスクロールさせる
                verticalScrollPosition =(len-height)/fontSize+2; // 本当は切り上げに+1のような・・・。
            }
        }

    }

}
