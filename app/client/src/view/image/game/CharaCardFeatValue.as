package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import mx.core.UIComponent;

    import flash.events.MouseEvent;
    import view.image.BaseImage;

    import flash.filters.GlowFilter;
    import flash.filters.BitmapFilterQuality;

    /**
     * CharaCardFeatValue表示クラス
     *
     */

    public class CharaCardFeatValue extends BaseImage
    {
        // move条件アイコン表示元SWF
        [Embed(source="../../../../data/image/icon_card_mov.swf")]
        private static var _mov:Class;
        // swd条件アイコン表示元SWF
        [Embed(source="../../../../data/image/icon_card_swd.swf")]
        private static var _swd:Class;
        // gun条件アイコン表示元SWF
        [Embed(source="../../../../data/image/icon_card_gun.swf")]
        private static var _gun:Class;
        // str条件アイコン表示元SWF
        [Embed(source="../../../../data/image/icon_card_str.swf")]
        private static var _str:Class;
        // shd条件アイコン表示元SWF
        [Embed(source="../../../../data/image/icon_card_shd.swf")]
        private static var _shd:Class;
        // wld条件アイコン表示元SWF
        [Embed(source="../../../../data/image/icon_card_wld.swf")]
        private static var _wld:Class;
        // SAD条件アイコン表示元SWF
        [Embed(source="../../../../data/image/icon_card_wld3.swf")]
        private static var _sad:Class;

        // 条件チップの配列
        private static var ClassArray:Array = [_mov, _swd, _gun, _str, _shd, _wld, _sad];

        // 表示タイプ
        private var _type:int;
        // 値のタイプ
        private var _valueType:int;
        // 影響値
        private var _value:int;

        // 定数
        private const _VALUE_MAX:int = 10;            // 値の最大

        public static const MOV:int = 0;             // 移動
        public static const SWD:int = 1;             // 近距離
        public static const GUN:int = 2;             // 遠距離
        public static const STR:int = 3;             // 特殊
        public static const SHD:int = 4;             // 防御
        public static const WLD:int = 5;             // なんでも
        public static const CMP:int = 6;             // 近遠防など 複合

        public static const VALUE_EQUAL:int = 0;           // 値が等しい
        public static const VALUE_UP:int = 1;              // 値以上
        public static const VALUE_DOWN:int = 2;            // 値以下

        private var _icon:MovieClip = null;

        /**
         * コンストラクタ
         *
         */
        public function CharaCardFeatValue(type:int, valueType:int, value:int)
        {
            _type = type;
            _valueType = valueType;
            _value = value;

            super();
        }

        override protected function get Source():Class
        {
            return ClassArray[_type];
        }

        // 初期化関数
        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);

            _icon = MovieClip(_root.getChildAt(0));

            waitComplete(initializeValue)
        }

        // 値を初期化する
        public function initializeValue():void
        {
            if(!(_value%10))
            {
                _value += 10;
            }
            _icon.gotoAndStop(_valueType*_VALUE_MAX+_value);
        }

        // 値を再セットする
        public function setValue(type:int, valueType:int, value:int):void
        {
            _type = type;
            _valueType = valueType;
            _value = value;
            initializeValue();
            growOn();
        }

        private function growOn():void
        {
            // var glow_filter1:GlowFilter = new GlowFilter(0x0033CC, 1.0, 3, 3, 255);
            // var glow_filter2:GlowFilter = new GlowFilter(0x00CCFF, 1.0, 2, 2, 255);
            var glow_filter1:GlowFilter = new GlowFilter(0x191970, 1.0, 3, 3, 255, 1, true);
            var glow_filter2:GlowFilter = new GlowFilter(0x4169e1, 1.0, 2, 2, 255);
//            var glow_filter2:GlowFilter = new GlowFilter(0x00CCFF, 1.0, 4, 4, 255);
            _icon.filters = [glow_filter1, glow_filter2];
        }

    }
}
