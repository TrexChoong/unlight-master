package view.image.match
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;
    import view.utils.*;

    /**
     * BG表示クラス
     *
     */


    public class ChannelBase extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/match/btn_channel.swf")]
        private static var _Source:Class;

        public static const CROWDED:int = 4;
//         public static const CROWDED:int = 3;
//         public static const CROWDED:int = 2;
//         public static const CROWDED:int = 1;
//         public static const CROWDED:int = 0;

        private var _type:int;
        private var _capacityMC:MovieClip;
        private var _capacity:int;

        /**
         * コンストラクタ
         *
         */
        public function ChannelBase(type:int,cap:int)
        {
            _capacity = cap;
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
//            SwfNameInfo.toLog(_root);
            _capacityMC = MovieClip(_root.getChildByName("capacity"));
            // 2,緑、3黄色、4赤
            _capacityMC.gotoAndStop(_capacity);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function setCapacity():void
        {

        }
        public function initializePos():void
        {
//            SimpleButton(_root.getChildAt(1)).gotoAndStop(1);
//            _root.getChildByName(InsName[_type]).visible = true;
        }

        public function up():void
        {
//             log.writeLog(log.LV_FATAL, this, "upup");
//             log.writeLog(log.LV_FATAL, this, "num", _root.numChildren);
//            _root.getChildByName(InsName[_type]).visible = false;
        }

        public function down():void
        {
//             log.writeLog(log.LV_FATAL, this, "downdown");
//            _root.getChildByName(InsName[_type]).visible = true;
        }
    }

}
