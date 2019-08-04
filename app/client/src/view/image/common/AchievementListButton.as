package view.image.common
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
    import view.*;

    /**
     * AchievementListButton表示クラス
     *
     */

    public class AchievementListButton extends BaseImage
    {

        // 表示元SWF
        [Embed(source="../../../../data/image/achievement/btn_achi.swf")]

        private var _Source:Class;
        /**
         * コンストラクタ
         *
         */
        public function AchievementListButton()
        {
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            addEventListener(MouseEvent.CLICK, clickHandler);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function clickHandler(e:MouseEvent):void
        {

            AchievementListView.show();
        }



    }

}
