package view.image.raid
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.utils.*;

    import view.image.BaseImage;
    import view.utils.*;


    /**
     * RaidMap表示クラス
     *
     */

    public class RaidMap extends BaseImage
    {
        [Embed(source="../../../../data/image/raid/raid_map.swf")]
        private var _Source:Class;

        //  i,j,kは今は使用しない 2014/02/21
        // private static const MAP_NAMES:Array = ["map_a", "map_b", "map_c0", "map_c1", "map_c2", "map_c3", "map_c4", "map_d", "map_e", "map_f", "map_g", "map_h", "map_i", "map_j", "map_k"];
        private static const MAP_NAMES:Array = ["map_a", "map_b", "map_c0", "map_c1", "map_c2", "map_c3", "map_c4", "map_d", "map_e", "map_f", "map_g", "map_h"];

        private var _maps:Array = [];

        /**
         * コンストラクタ
         *
         */
        public function RaidMap()
        {
            super();
        }
        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            for (var i:int = 0; i < MAP_NAMES.length; i++) {
                _maps.push(MovieClip(_root.getChildByName(MAP_NAMES[i])));
            }
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function get mapNum():int
        {
            return _maps.length;
        }

        public function getMapPos(i:int):Point
        {
            var pos:Point = new Point(0,0);
            if (_maps[i]) {
                pos.x = _maps[i].x;
                pos.y = _maps[i].y;
            }
            return pos;
        }
        public function getMapWidth(i:int):int
        {
            var w:int = 0;
            if (_maps[i]) {
                w = _maps[i].width;
            }
            return  w;
        }
        public function getMapHeight(i:int):int
        {
            var h:int = 0;
            if (_maps[i]) {
                h = _maps[i].height;
            }
            return  h;
        }


    }

}
