package view.image.quest
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.Text;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * TreasureCardFrame表示クラス
     *
     */

    public class TreasureCardFrame extends BaseImage
    {

        // CharaTreasureCardFrame表示元SWF
        [Embed(source="../../../../data/image/quest/quest_treasure.swf")]

        private var _Source:Class;
        private var _frame:int;

//         public static const FRAME_RED:int = 5;
//         public static const FRAME_BLUE:int = 0;
//         public static const FRAME_GREEN:int = 3;


        /**
         * コンストラクタ
         *
         */
        public function TreasureCardFrame()
        {
//             _frame = frame;
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
//             _root.gotoAndStop(_frame);
//             _root.getChildByName("rare").visible = false;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

    }

}
