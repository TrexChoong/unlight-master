package view.image.edit
{

    import flash.display.*;
    import flash.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import mx.containers.*;
    import mx.controls.*;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class DeckCase extends BaseImage
    {

        // DeckCase表示元SWF
        [Embed(source="../../../../data/image/edit/deckcase.swf")]
        private var _Source:Class;
        private static const X:int = -100;
        private static const Y:int = 0;

        public static const CHANGE_CHARA:String = "change_chara";
        public static const CHANGE_EQUIP:String = "change_equip";
        public static const CHANGE_EVENT:String = "change_event";
        public static const COST_FRAME:String = "cost";
        private var _costFrameMC:MovieClip;

        private var _statusLabel:Label = new Label();                                             // 名前ラベル
        private var _costLabel:Label = new Label();                                           // 行動力ラベル
        private var _maskShape:Shape;

        private var _kind:int;
        private var _status:int;
        private var _cost:int;
        private var _maxCost:int;

        private var _finished:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function DeckCase()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializeEvent();
            _costFrameMC = MovieClip(_root.getChildByName(COST_FRAME));
            _costFrameMC.alpha = 0.0;
        }

        public function setType(kind:int, status:int, cost:int, maxCost:int):void
        {
            _kind =kind;
            _status = _status;
            _cost  = cost;
            _maxCost = maxCost;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializeEvent():void
        {
            _root.getChildByName("tab_chara").addEventListener(MouseEvent.CLICK, pushTabCharaHandler);
            _root.getChildByName("tab_equip").addEventListener(MouseEvent.CLICK, pushTabEquipHandler);
            _root.getChildByName("tab_event").addEventListener(MouseEvent.CLICK, pushTabEventHandler);

            x = X;
            y = Y;
            if(_finished){finalizeEvent()};
        }

        public function finalizeEvent():void
        {
            _finished = true;
            _root.getChildByName("tab_chara").removeEventListener(MouseEvent.CLICK, pushTabCharaHandler);
            _root.getChildByName("tab_equip").removeEventListener(MouseEvent.CLICK, pushTabEquipHandler);
            _root.getChildByName("tab_event").removeEventListener(MouseEvent.CLICK, pushTabEventHandler);

            x = X;
            y = Y;
        }

        public function getShowCostFrameThread():Thread
        {
            var thread:Thread = null;
            if (_costFrameMC){
                var sExec:SerialExecutor = new SerialExecutor();
                sExec.addThread(new BeTweenAS3Thread(_costFrameMC, {alpha:1.0}, {alpha:0}, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 , true));
                sExec.addThread(new BeTweenAS3Thread(_costFrameMC, {alpha:0}, {alpha:1.0}, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 , true));
                thread = sExec;
            }
            return thread;
        }

        // キャラボタン
        private function pushTabCharaHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(CHANGE_CHARA));
        }

        // 装備ボタン
        private function pushTabEquipHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(CHANGE_EQUIP));
        }

        // イベントボタン
        private function pushTabEventHandler(e:MouseEvent):void
        {
            dispatchEvent(new Event(CHANGE_EVENT));
        }

        private function changeCharaEventHandler():void
        {
            _root.getChildByName("tab_chara").visible = false;
            _root.getChildByName("tab_equip").visible = true;
            _root.getChildByName("tab_event").visible = true;
        }

        private function changeEquipEventHandler():void
        {
            _root.getChildByName("tab_chara").visible = true;
            _root.getChildByName("tab_equip").visible = false;
            _root.getChildByName("tab_event").visible = true;
        }

        private function changeEventEventHandler():void
        {
            _root.getChildByName("tab_chara").visible = true;
            _root.getChildByName("tab_equip").visible = true;
            _root.getChildByName("tab_event").visible = false;
        }

    }

}
