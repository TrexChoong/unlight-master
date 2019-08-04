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

    /**
     * SocialLogTextBase表示クラス
     *
     */

    public class SocialLogTextBase extends BaseImage
    {

        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/common/log_hukidashi.swf")]
        private var _Source:Class;
        private var _frame:int;

        /**
         * コンストラクタ
         *
         */
        public function SocialLogTextBase()
        {
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

    }

}
