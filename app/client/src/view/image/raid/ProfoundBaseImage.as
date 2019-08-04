package view.image.raid
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;
    import view.utils.*;


    /**
     * ProfoundBaseImage表示クラス
     *
     */

    public class ProfoundBaseImage extends BaseImage
    {
        private var _Source:Class;

        private static const _ST_LIVE:int = 0;
        private static const _ST_FIN:int  = 1;
        private static const _BTN_ST_DEFAULT:int = 0;
        private static const _BTN_ST_SELECT:int  = 1;

        private static const LIMIT_ICON:String = "timelimit";
        private static const RARE_ICON:String = "rare";

        // 渦の状態に応じた表示フレーム
        private static const _BTN_ST_FRM:Vector.<Array> = Vector.<Array>([[1,2],[3,4]]);

        private var _timeLimitIcon:MovieClip;
        private var _rareIcon:MovieClip;


        private var _rarity:int = 0;
        private var _iconVisible:Boolean = false;
        private var _btnVisible:Boolean = true;
        private var _state:int = _ST_LIVE;

        /**
         * コンストラクタ
         *
         */
        public function ProfoundBaseImage(source:Class,rarity:int=0,iconVisible:Boolean=false,btnVisible:Boolean=true)
        {
            _Source = source;
            _rarity = rarity;
            _iconVisible = iconVisible;
            _btnVisible = btnVisible;
            super();
        }
        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            _timeLimitIcon = MovieClip(_root.getChildByName(LIMIT_ICON));
            _timeLimitIcon.visible = _iconVisible;
            _timeLimitIcon.mouseEnabled = false;
            _timeLimitIcon.mouseChildren = false;
            _rareIcon = MovieClip(_root.getChildByName(RARE_ICON));
            _rareIcon.mouseEnabled = false;
            _rareIcon.mouseChildren = false;
            rarityIcon = _rarity;
            profoundButtonVisible = _btnVisible;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function get limitIconVisible():Boolean
        {
            return _timeLimitIcon.visible;
        }
        public function set limitIconVisible(v:Boolean):void
        {
            _timeLimitIcon.visible = v;
        }
        public function set rarityIcon(rarity:int):void
        {
            _rarity = rarity;
            waitComplete(setRarityIcon);
        }
        private function setRarityIcon():void
        {
            _rareIcon.gotoAndStop(_rarity);
        }
        public function set profoundButtonVisible(v:Boolean):void
        {
            _btnVisible = v;
            waitComplete(setBtnVisible);
        }
        private function setBtnVisible():void
        {
            var btnSt:int = (_btnVisible) ? _BTN_ST_DEFAULT:_BTN_ST_SELECT;
            _root.gotoAndStop(_BTN_ST_FRM[_state][btnSt]);
        }
        public function set finish(isFinished:Boolean):void
        {
            if (isFinished) {
                _state = _ST_FIN;
            } else {
                _state = _ST_LIVE;
            }
            waitComplete(setState);
        }
        private function setState():void
        {
            _root.gotoAndStop(_BTN_ST_FRM[_state][_BTN_ST_DEFAULT]);
            setBtnVisible();
        }

    }

}
