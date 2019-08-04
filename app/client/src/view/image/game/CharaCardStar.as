package view.image.game
{

    import flash.display.*;
    import flash.geom.*;

    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * 移動矢印表示クラス
     *
     */


    public class CharaCardStar extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/common/ccframe_star.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static var __colorSet:Vector.<ColorTransform> = Vector.<ColorTransform>([
                                                                                            new ColorTransform(1,1,1), // なし
                                                                                            new ColorTransform(1,1,1), // 白
                                                                                            new ColorTransform(0,0,0), // 黒
                                                                                            new ColorTransform(1.0,0.0,0.0), // 赤
                                                                                            new ColorTransform(0.0,1.0,0.0), // 緑
                                                                                            new ColorTransform(0.0,0.0,1.0), // 青
                                                                                            new ColorTransform(1.0,1.0,0.0), // 黄
                                                                                            new ColorTransform(1.0,0.0,1.0) // 紫
                                                                                            ]);
        public static const CLIP_AREA:Rectangle = new Rectangle(-0,-0,10,10);
        private static var COLOR_STAR:Array = [
            new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000),
            new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000),
            new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000),
            new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000),
            new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000),
            new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000),
            new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000),
            new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000)
            ];
        private static var __init:Boolean = false;
        private var _func:Function;
        protected static var __instance:CharaCardStar;

//        private var _bitmapData:BitmapData = new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000);;

        /**
         * コンストラクタ
         *
         */
        public function CharaCardStar(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
        }

        private static function createInstance():CharaCardStar
        {
            return new CharaCardStar(arguments.callee);
        }

        public static function get instance():CharaCardStar
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            for(var i:int = 0; i < __colorSet.length; i++){
                if (__init == false)
                {
                    COLOR_STAR[i].draw(_root,null,__colorSet[i],null,CLIP_AREA);
                    __init == true;
                }
            }
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function setStar(func:Function):void
        {
            _func = func;
            waitComplete(func);
        }


        public function getStarBitmapData(type:int):BitmapData
        {
            return COLOR_STAR[type];
        }

        public function getBitmap(type:int):Bitmap
        {
            return new Bitmap(COLOR_STAR[type]);
        }

        public function clearSetStar():void
        {
            _func = null;
        }



    }

}
