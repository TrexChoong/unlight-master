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
     * MapPassImage表示クラス
     *
     */


    public class MapPassImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/map_pass_center.swf")]
        private var _SourceC:Class;
        [Embed(source="../../../../data/image/quest/map_pass_right.swf")]
        private var _SourceR:Class;
        [Embed(source="../../../../data/image/quest/map_pass_left.swf")]
        private var _SourceL:Class;

        private var _SourceSet:Vector.<Class> = Vector.<Class>([_SourceL, _SourceC, _SourceR]);
        private static const MAP_CENTER:String  ="map_pass_center";
        private static const MAP_RIGHT:String  ="map_pass_right";
        private static const MAP_LEFT:String  ="map_pass_left";
        private var _MCNameSet:Vector.<String> = Vector.<String>([MAP_LEFT, MAP_CENTER, MAP_RIGHT]);

        private var _typeSetCenter:Vector.<int> = Vector.<int>([]);

        private static const X:int = 0;
        private static const Y:int = 0;
        public static const TYPE_FRAME:int  = 1;
        public static const TYPE_PASS:int  = 3;
        public static const TYPE_END:int  = 3;
        public static const TYPE_START:int  = 4;

        private var _passMC:MovieClip;
        private var _pos:int = 1;
        private var _type:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function MapPassImage(p:int, t:int)
        {
            _pos = p;
            _type = t;
            super();
        }


        protected override function get Source():Class
        {
            return _SourceSet[_pos];
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _passMC = MovieClip(_root.getChildByName(_MCNameSet[_pos]));
            setTypeFrame();
        }


        public function setType(type:int):void
        {
            _type = type;
            waitComplete(setTypeFrame);
        }

        private function setTypeFrame():void
        {
//            log.writeLog(log.LV_FATAL, this, "set",_type);
            if (_type ==0)
            {
                RemoveChild.apply(_passMC);
            }else{
                _passMC.gotoAndStop(_type);
            }
        }


    }

}

