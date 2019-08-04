package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * アバターベース表示クラス
     *
     */


    public class AvatarBase extends BaseImage
    {

//         // H表示元SWF
        [Embed(source="../../../../data/image/game/avatar.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;

        private const _SIGN:String = "watch";
        private const _OUT_BUTTON:String = "watchout";
        private const _RAID_POINT:String = "raid_point";
        private var _watchSign:MovieClip;
        private var _watchRoomOutBtn:SimpleButton;
        private var _raidPoint:MovieClip;
        private var _raidPointView:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function AvatarBase()
        {
            super();
            alpha = 0.0;
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _watchSign = MovieClip(_root.getChildByName(_SIGN));
            _watchRoomOutBtn = SimpleButton(_root.getChildByName(_OUT_BUTTON));
            _raidPoint = MovieClip(_root.getChildByName(_RAID_POINT));
            _watchSign.visible = false;
            _watchRoomOutBtn.visible = false;
            _raidPoint.visible = _raidPointView;
//            initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
        }

        public function get watchSign():MovieClip
        {
            return _watchSign;
        }
        public function get watchRoomOutBtn():SimpleButton
        {
            return _watchRoomOutBtn;
        }

        public function watchView(isWatch:Boolean):void
        {
            _watchSign.visible = isWatch;
            _watchRoomOutBtn.visible = isWatch;
            _watchRoomOutBtn.mouseEnabled = isWatch;
        }

        public function set raidPointView(v:Boolean):void
        {
            _raidPointView = v;
            waitComplete(setRaidPointView);
        }
        private function setRaidPointView():void
        {
            _raidPoint.visible = _raidPointView;
        }

    }

}
