package view.image.common
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * SocialLogTab表示クラス
     *
     */

    public class SocialLogTab extends BaseImage
    {
        // 表示元SWF
        [Embed(source="../../../../data/image/common/log_tab.swf")]
        private var _Source:Class;

        // テキストラベル
        private var _label:Label = new Label();
        private var _text:String;

        /**
         * コンストラクタ
         *
         */
        public function SocialLogTab(str:String)
        {
            _text = str;
            super();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            initLabel();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function initLabel():void
        {
            _label.x = 0;
            _label.y = 4;
            _label.height = 20;
            _label.width = 80;
            _label.text = _text;
            _label.styleName = "SocialLogTabLabel";
            _label.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1),];

            _label.mouseChildren = _label.mouseEnabled = false;
            addChild(_label);
        }

    }

}
