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
    import view.*;

    /**
     * FriendStateImage表示クラス
     *
     */

    public class FriendStateImage extends BaseImage
    {

        // 表示元SWF
        [Embed(source="../../../../data/image/friend/friendlist_state.swf")]
        private var _Source:Class;

        private var _label:Label = new Label();
        private var _text:String;

        /**
         * コンストラクタ
         *
         */
        public function FriendStateImage()
        {
            super();
        }


        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);

        }

        override protected function get Source():Class
        {
            return _Source;
        }



    }

}
