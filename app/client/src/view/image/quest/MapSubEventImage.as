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
     * MapSubEventImage表示クラス
     *
     */


    public class MapSubEventImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/land_subevent.swf")]
        private var _Source:Class;
        private static const MAP_EVENT:String  ="subevent";
        private static const X:int = 0;
        private static const Y:int = 0;
//        public static const TYPE_GOAL:String  = "goal";

        public static const TYPE_TRESURE:String  = "tbox_red";
        // 0:none,1:charaCard,2:SLOT_CARD,3,AvatarItem,4:AvatarPart,5:gem
        public static const TRESURE_GENRE_SET:Array =["tbox_red_s","tbox_red_g","tbox_green_s","tbox_blue_s","tbox_white_s","jem_g","exp_s","highlow"]

        private var _eventMC:MovieClip;

        private var _type:int;


        /**
         * コンストラクタ
         *
         */
        public function MapSubEventImage(t:int)
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
//            log.writeLog(log.LV_FATAL, this, "stop", _type,_eventMC);
            _eventMC.gotoAndStop(TRESURE_GENRE_SET[_type]);
        }

    }

}

