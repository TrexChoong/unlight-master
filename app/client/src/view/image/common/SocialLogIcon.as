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
     * SocialLogIcon表示クラス
     *
     */

    public class SocialLogIcon extends BaseImage
    {

        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/common/log_icon.swf")]
        private var _Source:Class;
        private var _frame:int;


        private var startMC:MovieClip;
        private var battleMC:MovieClip;
        private var resultC:MovieClip;
        private var duelWinMC:MovieClip;
        private var duelLoseMC:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function SocialLogIcon()
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
