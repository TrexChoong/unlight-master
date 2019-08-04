package view.image.game
{

    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;

    import flash.events.Event;
    import org.libspark.thread.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.utils.*;
    import view.image.BaseImage;
    import model.Duel;


    /**
     * BG表示クラス
     *
     */


    public class NearBG extends BG
    {
        // OKボタン 表示元SWF
        [Embed(source="../../../../data/image/bg/bg_btl00a_book.swf")]
        private static var _castle:Class;
        [Embed(source="../../../../data/image/bg/bg_btl01a_book.swf")]
        private static var _forest:Class;
        [Embed(source="../../../../data/image/bg/bg_btl00a_book.swf")]
        private static var _road:Class;
        [Embed(source="../../../../data/image/bg/bg_btl01a_book.swf")]
        private static var _lakeside:Class;
        [Embed(source="../../../../data/image/bg/bg_btl00a_book.swf")]
        private static var _plane:Class;
        [Embed(source="../../../../data/image/bg/bg_btl09a_book.swf")]
        private static var _mountain:Class;
        [Embed(source="../../../../data/image/bg/bg_btl10a_book.swf")]
        private static var _mlCastle:Class;
        [Embed(source="../../../../data/image/bg/bg_btl11a_book.swf")]
        private static var _moor:Class;
        [Embed(source="../../../../data/image/bg/bg_btl03b_mist.swf")]
        private static var _ubos:Class;
        [Embed(source="../../../../data/image/bg/bg_btl50a.swf")]
        private static var _gate:Class;

        // 背景タイプの列挙配列
        private static var ClassArray:Array = [_castle, _forest, _road, _lakeside, _plane, _plane, _plane, _plane, _plane, _mountain, _mlCastle, _moor, _ubos, _plane, _plane, _plane];
        private static var existSet:Array =   [true,    true,   false,   false,     false,  false,    false, false, false, true,     true,       true, true, false, false, false];

        /**
         * コンストラクタ
         *
         */
        public function NearBG(id:int)
        {
            super(id);
        }
        override protected function get Source():Class
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
//            log.writeLog(log.LV_FATAL, this, "BG IS COMMING", _type);
            if (!existSet[_type])
            {
                RemoveChild.all(this);
            }
                super.swfinit(event);

        }

    }
}
