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
    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Option;

    import view.utils.*;
    import view.*;
    import view.image.BaseImage;
    import view.scene.common.TreasureCardClip;

    import controller.TitleCtrl;


    /**
     *  使用パネル
     *
     */

    public class QuestTreasurePanel extends BaseImage
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
//         private var _okButtonC:SimpleButton;
//         private var _okButtonF:SimpleButton;
        private var _okButton:SimpleButton;
        private var _okFunc:Function;
        private var _tCardClip:TreasureCardClip;


        /**
         * コンストラクタ
         *
         */
        public function QuestTreasurePanel()
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

            _okButton = SimpleButton(_tresureMC.getChildByName(OK));
            _okButton.addEventListener(MouseEvent.CLICK, okHandler);
//              log.writeLog(log.LV_FATAL, this, "Tresure mc", _tresureMC);
//              log.writeLog(log.LV_FATAL, this, "Tresure mc.name", _tresureMC.name);
            _okButton.mouseEnabled = false;
             y = -420;

        }


        override public function final():void
        {
            _okButton.removeEventListener(MouseEvent.CLICK, okHandler);
            _okFunc = null;
            if (_tCardClip!=null)
            {
                _tCardClip.getHideThread().start();
            }
        }

        public function setResult(type:int, cType:int, val:int):void
        {
            _tCardClip = new TreasureCardClip(type,cType,val);
            _tCardClip.getShowThread(this).start();
            _tCardClip.x = 224;
            _tCardClip.y = 260;
            _tresureMC.visible = true;
            _tCardClip.mouseEnabled = false;
            _tCardClip.mouseChildren = false;
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
                y = -420;
                _okButton.mouseEnabled = false;
            }
         }

        private function mouseOn():void
        {
            _okButton.mouseEnabled = true;
         }

        public function  getBringOnThread():Thread
        {
//            log.writeLog(log.LV_FATAL, this, "get BRINGON!!! THR");
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(this, {y:0}, {y:-420}, 0.13, BeTweenAS3Thread.EASE_OUT_SINE, 0.3 ,true));
            sExec.addThread(new SleepThread(400));
            sExec.addThread(_tCardClip.getFlipThread());
            sExec.addThread(new ClousureThread(mouseOn));
            return sExec;
        }


    }
}