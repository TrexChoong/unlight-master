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
    public class ResultStepImage extends BaseImage
    {

        // result表示元SWF
        [Embed(source="../../../../data/image/game/result/itemrank.swf")]

        private var _Source:Class;


        private const PREMIUM_RANK:String = "premiumrank";
        private const STAR:String         = "star";
        private const STAR_MASK:String    = "star_mask";
        private var _rankImage:MovieClip;
        private var _starImage:MovieClip;
        private var _starMaskImage:MovieClip;
        private var _rank:int;


        /**
         * コンストラクタ
         *
         */
        public function ResultStepImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _rankImage = MovieClip(_root.getChildByName(PREMIUM_RANK));
            _starImage = MovieClip(_root.getChildByName(STAR));
            _starMaskImage = MovieClip(_root.getChildByName(STAR_MASK));
            _starMaskImage.visible = false;
            _starImage.mask = _starMaskImage;

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function setRank(i:int):void
       {
           _rank = i;
            waitComplete(setRankMask);
        }

        private function setRankMask():void
        {
            if (_rank < 100)
            {
                log.writeLog(log.LV_FATAL, this, "set Rank", (_rank+4) /Const.REWARD_RANK_MAX,(_rank));
                _starMaskImage.scaleX = (_rank+4) /Const.REWARD_RANK_MAX;
            }else{
                log.writeLog(log.LV_FATAL, this, "set Rank", (_rank-100+4) /Const.REWARD_RANK_MAX,(_rank));
                _starMaskImage.scaleX = (_rank-100+4) /Const.REWARD_RANK_MAX;
            }
        }

    }

}