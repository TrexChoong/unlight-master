package view.image.match
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class RoomBase extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/match/lobby_list_base.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private var _channel:int = 0;                    // この部屋があるチャンネルのルール
        private var _rule:int = 0;                       // 部屋のルール

        private static const Rules:Array = ["vs1","vs3"];


        /**
         * コンストラクタ
         *
         */
        public function RoomBase()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _root.cacheAsBitmap = true;
            offSelect();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function setRule(rule:int):void
        {
            _rule = rule;
            waitComplete(setRuleComplete);
        }

        private function setRuleComplete():void
        {
            for(var i:int = 0; i < Rules.length; i++)
            {
                _root.getChildByName(Rules[i]).visible = false;
            }
            var rule:int = (_rule < Rules.length) ? _rule : 0;
            _root.getChildByName(Rules[rule]).visible = true;
        }

        public function setChannel(channel:int):void
        {
            _channel = channel;
            waitComplete(setChannelComplete);
        }


        private function setChannelComplete():void
        {

        }

        public function onSelect():void
        {
            waitComplete(onSelectComplete);
        }

        public function onSelectComplete():void
        {
            _root.getChildByName("list_en").visible = true;
        }

        public function offSelect():void
        {
            waitComplete(offSelectComplete);
        }

        private function offSelectComplete():void
        {
            _root.getChildByName("list_en").visible = false;
        }

        public function onCapacity():void
        {
            waitComplete(onCapacityComplete);
        }

        private  function onCapacityComplete():void
        {
            _root.gotoAndStop("ch_full");
        }

        public function offCapacity():void
        {
            waitComplete(offCapacityComplete);
        }

        private function offCapacityComplete():void
        {
//            _root.gotoAndStop(Channels[_channel]);
        }

        public function onCpu():void
        {
            waitComplete(onCpuComplete);
        }

        private  function onCpuComplete():void
        {
            _root.gotoAndStop("ch_c");
        }

    }
}
