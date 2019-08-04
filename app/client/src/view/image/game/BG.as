package view.image.game
{

    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;

    import flash.events.Event;
    import org.libspark.thread.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import view.FramePlayThread;
    import model.Duel;

    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {
        [Embed(source="../../../../data/image/bg/bg_btl00a.swf")]
        private static var _castle:Class;
        [Embed(source="../../../../data/image/bg/bg_btl01a.swf")]
        private static var _forest:Class;
        [Embed(source="../../../../data/image/bg/bg_btl02a.swf")]
        private static var _road:Class;
        [Embed(source="../../../../data/image/bg/bg_btl01a.swf")]
        private static var _lakeside:Class;
        [Embed(source="../../../../data/image/bg/bg_btl00a_far.swf")]
        private static var _plane:Class;
        [Embed(source="../../../../data/image/bg/bg_btl09a.swf")]
        private static var _mountain:Class;
        [Embed(source="../../../../data/image/bg/bg_btl10a.swf")]
        private static var _mlCastle:Class;
        [Embed(source="../../../../data/image/bg/bg_btl99a.swf")]
        private static var _throne:Class;
        // 仮です変化がわかるように]
        [Embed(source="../../../../data/image/bg/bg_btl99b.swf")]
        private static var _throne2:Class;

        // 背景タイプの列挙配列
        private static var ClassArray:Array = [_castle,
                                               _forest,
                                               _road,
                                               _lakeside,
                                               _plane,
                                               _plane,
                                               _plane,
                                               _plane,
                                               _plane,
                                               _mountain,
                                               _mlCastle,
                                               _plane,
                                               _plane,
                                               _plane,
                                               _plane,
                                               _throne,
                                               _throne2];

        // 表示タイプ
        protected var _type:int;


        // 定数
        public static const CASTLE:int = 0;                // 城
        public static const FOREST:int = 1;                // 森
        public static const UBOS:int = 12;                 // ウボス

        // Frame設定 [short, middle ,long ]
//        public static const DIST_FRAME_ANIME:Array = [13,7,1]; /* of int */ ;

        // 現在の距離
        protected var _distance:int = 2;

        /**
         * コンストラクタ
         *
         */
        public function BG(id:int)
        {
            _type = id;
            super();
            }

        protected override function get Source():Class
        {
            if (ClassArray[_type] != null)
            {
                return ClassArray[_type];
            }else{
                log.writeLog(log.LV_FATAL, this, "NON EXIST BG NO");
                return ClassArray[0];
            }
        }
        
        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
//            waitComplete(setDefaultDist);
        }

//         public function updateDistance(dist:int):void
//         {
//             _distance = dist;
//             waitComplete(setDist);
//         }

//         private function setDefaultDist():void
//         {
//             _root.gotoAndStop(DIST_FRAME_ANIME[_distance-1]);
//         }
//         private function setDist():void
//         {
// //            log.writeLog(log.LV_FATAL, this, "setDist start anime");
//             var i:int = _distance-1;
//             if ((i < 3) && (i > -1))
//             {
//                 new FramePlayThread(_root,DIST_FRAME_ANIME[i]).start();
//             }
//         }

    }
}

