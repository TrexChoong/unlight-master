package view.image.raid
{

    import flash.display.*;
    import flash.events.*;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * RaidListPanelImage表示クラス
     *
     */


    public class RaidListPanelImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/raid/raid_list.swf")]
        private var _Source:Class;

        private static const _STATE:String  = "list_state";
        private static const _SELECT:String = "list_select";

        private static const _SEL_TYPE:Array = ["dis","en"];

        private static const _SEL_OFF:int = 0;
        private static const _SEL_ON:int  = 1;

        private var _state:MovieClip;
        private var _select:MovieClip;

        private var _isSelect:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function RaidListPanelImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);

            log.writeLog(log.LV_DEBUG, this,"swfInit  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            SwfNameInfo.toLog(_root);


            //_state = MovieClip(_root.getChildByName(_STATE));
            _state = MovieClip(_root.getChildAt(1));
            _select = MovieClip(_root.getChildByName(_SELECT));

            _state.gotoAndStop("act");
            select = false;
        }

        override public function final():void
        {
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function set select(b:Boolean):void
        {
            _isSelect = b;
            waitComplete(setSelect);
        }

        private function setSelect():void
        {
            var setFrm:String = (_isSelect) ? "en" : "dis";
            _select.gotoAndStop(setFrm);
        }
    }

}
