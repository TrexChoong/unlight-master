package view.image.quest
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.*;
    import view.utils.*;
    import view.image.*;

    /**
     * MapBaseImage表示クラス
     *
     */


    public class MapBaseImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/map_base.swf")]
        private var _Source:Class;
        private static const MAP_BASE:String  ="map_base";
        private static const X:int = 0;
        private static const Y:int = 0;
        public static const TYPE_FRAME:int  = 1;
        public static const TYPE_PASS:int   = 2;
        public static const TYPE_END:int    = 3;
        public static const TYPE_START:int  = 4;
        public static const TYPE_GOAL:int  = 5;

        private var _baseMC:MovieClip;
        private var _type:int;


        /**
         * コンストラクタ
         *
         */
        public function MapBaseImage(t:int)
        {
            _type = t;
            super();
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _baseMC = MovieClip(_root.getChildByName(MAP_BASE));
            setTypeFrame();
        }


        public function setType(type:int):void
        {
            _type = type;
            waitComplete(setTypeFrame);
        }

        private function setTypeFrame():void
        {
            _baseMC.gotoAndStop(_type);
        }

    }

}

