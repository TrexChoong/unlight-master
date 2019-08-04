package view.image.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.filters.*;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  使用パネル
     *
     */

    public class QuestClearPanel extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/quest_result.swf")]
        private var _Source:Class;
        private static const OK:String ="btn_ok";
        private static const CLEAR:String = "clear";
        private static const FAILED:String = "failed";
        private static const TRESURE:String = "get_tbox";
        private static const WIN:int = 0;
        private static const LOSE:int = 0;


        // MovieClip
        private var _clearMC:MovieClip;
        private var _failedMC:MovieClip;
        private var _tresureMC:MovieClip;


        // 決定ボタン
        private var _okButtonC:SimpleButton;
        private var _okButtonF:SimpleButton;
        private var _okFunc:Function;


        /**
         * コンストラクタ
         *
         */
        public function QuestClearPanel()
        {
            super();
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _clearMC = MovieClip(_root.getChildByName(CLEAR));
            _failedMC = MovieClip(_root.getChildByName(FAILED));
            _tresureMC = MovieClip(_root.getChildByName(TRESURE));

            _clearMC.visible = false;
            _failedMC.visible = false;
            _tresureMC.visible = false;

            _okButtonC = SimpleButton(_clearMC.getChildByName(OK));
            _okButtonF = SimpleButton(_failedMC.getChildByName(OK));
             _okButtonC.addEventListener(MouseEvent.CLICK, okHandler);
             _okButtonF.addEventListener(MouseEvent.CLICK, okHandler);
             log.writeLog(log.LV_FATAL, this, "Tresure mc", _tresureMC);
             log.writeLog(log.LV_FATAL, this, "Tresure mc.name", _tresureMC.name);
        }


        override public function final():void
        {
            _okButtonC.removeEventListener(MouseEvent.CLICK, okHandler);
            _okButtonF.removeEventListener(MouseEvent.CLICK, okHandler);
            _okFunc = null;
        }

        public function setResult(result:int):void
        {
            if (result == WIN)
            {
                _clearMC.visible = true;
                _failedMC.visible = false;
            }else
            {
                _clearMC.visible = false;
                _failedMC.visible = true;
            }

        }


        // 
        public function  setOKHandler(handler:Function):void
        {
             _okFunc = handler;
        }

        public function okHandler(e:MouseEvent):void
        {
            if (_okFunc !=null)
            {
                _okFunc();
            }

        }


    }
}