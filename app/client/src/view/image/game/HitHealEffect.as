package view.image.game
{

    import flash.display.*;
    import flash.geom.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.*;
    import view.image.BaseImage;
    import controller.*;

    /**
     * ステータスエフェクト表示クラス
     *
     */

    public class HitHealEffect extends CachedBaseImage
    {
        // 表示元SWF
        [Embed(source="../../../../data/image/game/effect_state.swf")]
        private static var _source:Class;

        // 定数
        public static const CLIP_AREA:Rectangle = new Rectangle(-50,-50,150,200);
//         public static var CACHE_TYPE:int = CachedBaseImage.CASH_BITMAP_DATA;
        public static var CACHE_TYPE:int = CachedBaseImage.CASH_BYTE_ARRAY;
        public static var _cacheID:int = -1;
        public static const LABEL:Array  = ["heal"];
        // ゲームのコントローラ
        private var _healMC:MovieClip;
        /**
         * コンストラクタ
         *
         */
        public function HitHealEffect(pow:int)
        {
            super();
            if (pow>8){pow = 8};
            for(var i:int = 0; i < pow; i++){
             x  += Math.random() * 60 - 30;
             y += Math.random() * 10 - 5;
            }
             repeat = false;
             visible = false
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
            return _source;
        }


        public function get healMC():MovieClip
        {
            return _healMC;
        }

        public function onAnime():void
        {
            visible = true;
            goPlay();
        }



    }
}
