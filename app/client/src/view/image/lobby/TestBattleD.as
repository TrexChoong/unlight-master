package view.image.lobby
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;

    import view.image.*;
    import flash.utils.*;

    /**
     * entrance表示クラス
     *
     */


    public class TestBattleD extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/lobby/test_battle_d.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        public static const LABEL:Array  = ["battle"];
        private var _battler:MovieClip;
        private var _dust_a:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function TestBattleD()
        {
            super();
        }


        override protected function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _battler = MovieClip(_root.getChildAt(0));
            _dust_a = MovieClip(_battler.getChildByName("dust_a"));
            _battler.stop();
            _dust_a.stop();
        }

        public function play():void
        {
            _battler.play();
            _dust_a.play();
        }
        public function stop():void
        {
            _battler.stop();
            _dust_a.stop();
        }

    }

}
