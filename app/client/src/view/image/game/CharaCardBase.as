package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.ClousureThread;
    import view.image.BaseImage;
    import controller.*;

    /**
     * 結果表示枠クラス
     *
     */
    public class CharaCardBase extends BaseImage
    {
        // result表示元SWF
        [Embed(source="../../../../data/image/compo/compo_cardbase.swf")]
        private var _Source:Class;

        /**
         * コンストラクタ
         *
         */
        public function CharaCardBase()
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

        public function onAnime():void
        {
            waitComplete(onAnimeComplete);
        }
        public function onAnimeComplete():void
        {
//            MovieClip(_root.getChildAt(0)).gotoAndStop("on");
        }

        public function offAnime():void
        {
            waitComplete(offAnimeComplete);
        }
        public function offAnimeComplete():void
        {
//            MovieClip(_root.getChildAt(0)).gotoAndStop("off");
        }
    }
}
