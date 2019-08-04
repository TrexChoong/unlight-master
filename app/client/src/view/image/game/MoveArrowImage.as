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


    public class MoveArrowImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/game/arrow_move.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const ARROW_RIGHT:String = "arrow_right";
        private static const ARROW_LEFT:String = "arrow_left";

        private var _rArrowMC:MovieClip;
        private var _lArrowMC:MovieClip;

//        public static const CLIP_AREA:Rectangle = new Rectangle(10,-20,50,60);
        public static const CLIP_AREA:Rectangle = new Rectangle(-0,-0,40,53);
        private var _rBitmapData:BitmapData;
        private var _lBitmapData:BitmapData;
        private var _mainBitmap:Bitmap;
        private var _right:Boolean;

        /**
         * コンストラクタ
         *
         */
        public function MoveArrowImage()
        {
            _rBitmapData = new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000);
            _lBitmapData = new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000);
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            initializePos();
            _rArrowMC = MovieClip(_root.getChildByName(ARROW_RIGHT));
//            _lArrowMC = MovieClip(_root.getChildByName(ARROW_LEFT));
//            _lArrowMC.visible = false;
            _rArrowMC.x =+ 20;
            _rArrowMC.y =+ 25;
            // 描画対象のビットマップデータ
//             _rBitmapData.draw(_rArrowMC,null,null,null,CLIP_AREA);
//             _lBitmapData.draw(_lArrowMC,null,null,null,CLIP_AREA);
            _rBitmapData.draw(_root,null,null,null,CLIP_AREA);
            _lBitmapData.draw(_root,new Matrix(-1,0,0,1,40),null,null,CLIP_AREA);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {

        }

        public function getLeftArrow():DisplayObject
        {
            return new Bitmap(_lBitmapData);
        }

        public function getRightArrow():DisplayObject
        {
            return new Bitmap(_rBitmapData);
        }

    }

}
