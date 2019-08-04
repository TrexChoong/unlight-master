package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import mx.core.UIComponent;

    import view.image.BaseImage;
    import controller.*;

    /**
     * 結果表示クラス
     *
     */
    public class ResultCardFrame extends BaseImage
    {

        // result表示元SWF
        [Embed(source="../../../../data/image/game/result/frame_card.swf")]
        private var _Source:Class;


        private const FRAME_CARD:String = "frame_card";
        private const NORMAL:String = "normal";
        private const GET:String = "get";
        private var _cardFrame:MovieClip;

        /**
         * コンストラクタ
         *
         */
        public function ResultCardFrame()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _cardFrame = MovieClip(_root.getChildByName(FRAME_CARD));
            _cardFrame.gotoAndStop(NORMAL);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function goGet():void
        {
            waitComplete(gotoGetFrame);
        }

        private function gotoGetFrame():void
        {
            _cardFrame.gotoAndPlay(GET);
        }

        public function goNormal():void
        {
            waitComplete(gotoNormalFrame);
        }

        private function gotoNormalFrame():void
        {
            _cardFrame.gotoAndStop(NORMAL);
        }
    }

}