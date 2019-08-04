package view.image.match
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/match/b_lobby_base.swf")]
        private var _Source:Class;


        private static const X:int = 0;
        private static const Y:int = 0;

        // 定数
        private static const INS_NAME:Array = ["quickmatch", "createroom",
                                               "back", "next", "deckset",
                                               "exit"];
        private static const QUICK_BUTTON:String = "quickmatch"
        private static const CPU_MATCH:String = "cpumatch";
        private static const CHAT_BUTTON:String = "button_chat";
        private static const CREATE_ROOM_BUTTON:String = "createroom";

        private static const DECK_BACK_BUTTON:String = "back";
        private static const DECK_NEXT_BUTTON:String = "next";
        private static const CHANNEL_BUCK_BUTTON:String = "btn_ch_back";

        private static const DECK_VOL:String = "deck_vol";
        private static const DECK_VOL_POSI:String = "deck_vol_posi";

        private static const PAGE_BACK_BUTTON:String = "btn_p_back";
        private static const PAGE_NEXT_BUTTON:String = "btn_p_next";

        private var _deckVol:MovieClip;
        private var _deckVolPosi:MovieClip;

        private var _num:int;
        private var _currentNum:int;

        // 選択中のチャンネル
        private var _channel:int = 0;
        private var _quickButton       :SimpleButton;
        private var _createroomButton  :SimpleButton;
        private var _deckbackButton    :SimpleButton;
        private var _decknextButton    :SimpleButton;
        private var _channelbuckButton :SimpleButton;
        private var _chatButton        :SimpleButton;
        private var _pagebackButton    :SimpleButton;
        private var _pagenextButton    :SimpleButton;

        /**
         * コンストラクタ
         *
         */
        public function BG()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _deckVol = MovieClip(_root.getChildByName(DECK_VOL));
            _deckVolPosi = MovieClip(_root.getChildByName(DECK_VOL_POSI));

            _quickButton       = SimpleButton(_root.getChildByName(QUICK_BUTTON));
            _createroomButton  = SimpleButton(_root.getChildByName(CREATE_ROOM_BUTTON));
            _deckbackButton    = SimpleButton(_root.getChildByName(DECK_BACK_BUTTON));
            _decknextButton    = SimpleButton(_root.getChildByName(DECK_NEXT_BUTTON));
            _channelbuckButton = SimpleButton(_root.getChildByName(CHANNEL_BUCK_BUTTON));
            _chatButton        = SimpleButton(_root.getChildByName(CHAT_BUTTON));
            _pagebackButton    = SimpleButton(_root.getChildByName(PAGE_BACK_BUTTON));
            _pagenextButton    = SimpleButton(_root.getChildByName(PAGE_NEXT_BUTTON));
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
        }

        // 各種ボタンのゲッター
        public function get quick():SimpleButton
        {
            return _quickButton;
        }
        public function get create():SimpleButton
        {
            return _createroomButton;
        }
        public function get back():SimpleButton
        {
            return _deckbackButton;
        }
        public function get next():SimpleButton
        {
            return _decknextButton;
        }

        public function get chBack():SimpleButton
        {
            return _channelbuckButton;
        }

        public function get chatButton():SimpleButton
        {
            return _chatButton;
        }

        public function get pageBack():SimpleButton
        {
            return _pagebackButton;
        }
        public function get pageNext():SimpleButton
        {
            return _pagenextButton;
        }


        public function set deckNum(i:int):void
        {
            _num = i;
            waitComplete(deckPosUpdate);
        }

        public function set currentNum(i:int):void
        {
            _currentNum = i;
            waitComplete(deckPosUpdate)
        }

        private function deckPosUpdate():void
        {
            _deckVol.gotoAndStop(_num-1);
            _deckVolPosi.gotoAndStop(_num-_currentNum);
        }

        public function setChannel(s:int):void
        {
            _channel = s;
            waitComplete(setChannelComplete);
        }

        public function setChannelComplete():void
        {
            log.writeLog(log.LV_INFO, this, "set channel!!!!", _channel);
            

        }



    }

}
