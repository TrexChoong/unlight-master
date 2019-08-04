package view.image.match
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class ChannelList extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/match/lobby_channel.swf")]
        private static var _Source:Class;
        private var _chAButton :SimpleButton;
        private var _chBButton :SimpleButton;
        private var _chCButton :SimpleButton;

        /**
         * コンストラクタ
         *
         */
        public function ChannelList()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
            _chAButton = SimpleButton(_root.getChildByName("ch_a"));
            _chBButton = SimpleButton(_root.getChildByName("ch_b"));
            _chCButton = SimpleButton(_root.getChildByName("ch_c"));
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
//            SimpleButton(_root.getChildAt(1)).gotoAndStop(1);
        }

        public function get channelA():SimpleButton
        {
            return  _chAButton ;
        }

        public function get channelB():SimpleButton
        {
            return  _chBButton ;
        }
        public function get channelC():SimpleButton
        {
            return  _chCButton ;
        }
    }

}
