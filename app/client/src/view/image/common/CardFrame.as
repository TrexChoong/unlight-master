package view.image.common
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.Text;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.EventCard;
    import view.image.BaseImage;

    /**
     * CardFrame表示クラス
     *
     */

    public class CardFrame extends BaseImage
    {

        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/item_cardframe.swf")]
        private var _normalSource:Class;
        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/weapon_cardframe.swf")]
        private var _weaponSource:Class;
        private var _sourceList:Array = [_normalSource,_weaponSource];

        private var _color:int;
        private var _type:int;

        public static const FRAME_TYPE_NORMAL:int = 0;
        public static const FRAME_TYPE_WEAPON:int = 1;

        public static const FRAME_RED:int = 5;
        public static const FRAME_BLUE:int = 0;
        public static const FRAME_GREEN:int = 3;

        public static const CARD_TYPE:Array = [0,0,6]; // カード種類によって呼ぶのを変える
                                            //        0:なし,1:白,2:黒,3:赤,4:緑,5:青,6:黄,7:紫
        public static const EVENT_COLOR_LABEL:Array = [8,9,10,11,12,13,14,15]; // 呼ぶフレームの設定

        private const _BASE_MAX:String = "max";
        private var _baseMaxMC:MovieClip;
        private var _baseMax:int = 2;

        /**
         * コンストラクタ
         *
         */
        public function CardFrame(color:int = FRAME_GREEN,type:int = FRAME_TYPE_NORMAL)
        {
            _color = color;
            _type = type;
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            if (_type == FRAME_TYPE_NORMAL) {
                _root.gotoAndStop(4);
                _root.getChildByName("rare").visible = false;
            } else {
                _baseMaxMC = MovieClip(_root.getChildByName(_BASE_MAX));
                _baseMaxMC.gotoAndStop(_baseMax);
            }
        }

        override protected function get Source():Class
        {
            return _sourceList[_type];
        }

        public function changeFrameEventColor(color:int):void
        {
            _color = color;
            waitComplete(setFrame)
        }

        private function setFrame():void
        {
            if (_type == FRAME_TYPE_NORMAL&&_color>EventCard.ECC_NONE)
            {
//                _root.gotoAndStop(COLOR_LABEL[_color]);
                _root.gotoAndStop(EVENT_COLOR_LABEL[_color]);
            }

        }

        public function setBaseMax(max:int):void
        {
            _baseMax = max;
            waitComplete(setBaseMaxFrame);
        }
        private function setBaseMaxFrame():void
        {
            if (_type == FRAME_TYPE_WEAPON) {
                _baseMaxMC.gotoAndStop(_baseMax);
            }
        }

    }

}
