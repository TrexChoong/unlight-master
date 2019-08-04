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


    public class SecondBG extends BaseImage
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
        [Embed(source="../../../../data/image/bg/bg_btl09a_far.swf")]
        private static var _mountain:Class;


        // 背景タイプの列挙配列
        private static var ClassArray:Array = [_castle, _forest, _road, _lakeside, _plane, _plane, _plane, _plane, _plane, _mountain];

        // 表示タイプ
        protected var _type:int;

        /**
         * コンストラクタ
         *
         */
        public function SecondBG(id:int)
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
    }
}

