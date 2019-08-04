package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import controller.*;

    /**
     * ゲーム画面下部インフォバー
     *
     */


    public class InfoBarImage extends BaseImage
    {

        // 元SWF
        // ターン表示・タイマー
        [Embed(source="../../../../data/image/game/help.swf")]
        private var _Source:Class;



        /**
         * コンストラクタ
         *
         */
        public function InfoBarImage(left:Boolean = false)
        {
            super();
            alpha = 0.0;
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
//            return new TweenerThread(this, { alpha: 1.0, transition:"easeOutSine", time: 0.5, show:true} );
//            log.writeLog(log.LV_WARN, this, "bring on");
            return new BeTweenAS3Thread(this, {alpha:1.0}, {alpha:0.0}, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
        }

        // 実画面に表示するスレッドを返す
        public function getBringOffThread():Thread
        {
//            log.writeLog(log.LV_WARN, this, "bring off");
//            return new TweenerThread(this, { alpha: 0.0, transition:"easeOutSine", time: 0.5, hide:true} );
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
        }


        // 隠すスレッドを返す
        public override function getHideThread(type:String = ""):Thread
        {
            //            log.writeLog(log.LV_WARN, this, "hide");
            alpha = 0;
            return super.getHideThread(type);
        }







    }

}
