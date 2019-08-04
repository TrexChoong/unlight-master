package view.scene.raid
{

    import flash.display.*;
    import flash.text.*;
    import flash.events.*;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;
    import mx.styles.*;

    import model.ProfoundLogs;
    import model.events.ProfoundLogsEvent;
    import view.scene.BaseScene;
    import view.scene.common.LogTextArea;

    import controller.RaidCtrl;
    import controller.ChatCtrl;

    /**
     * ログ表示用表示TextAreaクラス
     *
     */

    public class RaidLogTextArea extends TextArea
    {
        private var _prfLogs:ProfoundLogs;
        private var _type:int = ProfoundLogs.ALL_LOG;

        /**
         * コンストラクタ
         *
         */
        public function RaidLogTextArea(type:int)
        {
            _prfLogs = ProfoundLogs.getInstance();
            _type = type;
            super();
            editable = false;
            callLater(update);
        }

        private function updateHandler(e:ProfoundLogsEvent):void
        {
            update();
        }
        public function init():void
        {
            log.writeLog(log.LV_INFO, this, "init");
            _prfLogs.addEventListener(ProfoundLogsEvent.UPDATE, updateHandler);
        }

        public function final():void
        {
            _prfLogs.removeEventListener(ProfoundLogsEvent.UPDATE, updateHandler);
        }

        public function update():void
        {
            htmlText= _prfLogs.logs(_type).replace("_rename","");
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
