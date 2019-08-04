package view.image.lobby
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;

    import view.image.*;
    import flash.utils.*;

    /**
     * LobbyBattleButtons再遠景表示クラス
     *
     */


    public class TestBattleA extends CachedBaseImage
    {

        [Embed(source="../../../../data/image/lobby/test_battle_a.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        public static const CLIP_AREA:Rectangle = new Rectangle(673,30,292,234);
//         public static var CACHE_TYPE:int = CachedBaseImage.CASH_BITMAP_DATA;
        public static var CACHE_TYPE:int = CachedBaseImage.CASH_BYTE_ARRAY;
        public static var _cacheID:int = -1;
        public static const LABEL:Array  = ["wind"];

        /**
         * コンストラクタ
         *
         */
        public function TestBattleA()
        {
            super();
        }

        // オーバーライド前提のキャッシュが切り取るエリアのRectangle
        public override function  get cacheClipArea():Rectangle
        {
            return CLIP_AREA;
        }

        // オーバライド前提のムービーラベル
        protected override function get label():Array
        {
            return LABEL;
        }

        // オーバライド前提のキャッシュID
        protected override function get cacheID():int
        {
            return _cacheID;
        }

        // オーバライド前提のキャッシュID
        protected override function set cacheID(i:int):void
        {
            _cacheID = i;
        }

        // オーバライド前提のキャッシュタイプ
        protected override function get cacheType():int
        {
            return CACHE_TYPE;
        }


        override protected function get Source():Class
        {
            return _Source;
        }


    }

}
