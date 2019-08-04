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
     * MapEventImage表示クラス
     *
     */


    public class MapEventImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/land_event.swf")]
        private var _Source:Class;
        private static const MAP_EVENT:String  ="event";
        private static const X:int = 0;
        private static const Y:int = 0;
        public static const TYPE_ENEMY:String  = "enemy";
        public static const TYPE_TRESURE:String  = "tbox_red";
        public static const TRESURE_GENRE_SET:Array =["enemy","tbox_red_g","tbox_green_s","tbox_blue_s","tbox_white_s","jem_g","enemy","enemy_hl"]

        private var _type:int;
        private var _eventMC:MovieClip;


        /**
         * コンストラクタ
         * 引数なしはエネミーで出す
         */
        public function MapEventImage(t:int = 0)
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
            _eventMC = MovieClip(_root.getChildByName(MAP_EVENT));
            setTypeFrame();
        }


        public function setType(type:int):void
        {
            _type = type;
            waitComplete(setTypeFrame);
        }

        private function setTypeFrame():void
        {
            _eventMC.gotoAndStop(TRESURE_GENRE_SET[_type]);
        }

    }

}

