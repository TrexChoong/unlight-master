package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;
    import view.scene.game.EmptyCardBase;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    /**
     * カードのBGクラス
     *
     */


    public class BaseCard extends BaseImage
    {

//         // カードの下
//         [Embed(source="../../../../data/image/card_base.swf")]
        // カードの下
        [Embed(source="../../../../data/image/game/card_base.swf")]
        private var _Source:Class;

        // 現在のMAXカード表示
        private var _emptyCardBase:EmptyCardBase  = new EmptyCardBase();
        
        /**
         * コンストラクタ
         *
         */
        public function BaseCard()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            onDisable();
            initializePos();
//            pExec.addThread(_emptyCardBase.getHideThread());

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        override public function init():void
        {
            _emptyCardBase.getShowThread(this).start();
        }

        override public function final():void
        {
            _emptyCardBase.getHideThread().start();
        }

        public function initializePos():void
        {
            alpha = 0.0;
            visible = false;
        }

        // 有効に
        public function onEnable():void
        {
            waitComplete(setEnable);
        }

        // 有効に
        public function onDisable():void
        {
            waitComplete(setDisable);
        }

        private function setEnable():void
        {
            _root.gotoAndStop("en");
        }

        private function setDisable():void
        {
            _root.gotoAndStop("dis");
        }


        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
//            log.writeLog(log.LV_WARN, this, "bring on");
            return new BeTweenAS3Thread(this, {alpha:1.0}, {alpha:0.0}, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
        }

        // 実画面に表示するスレッドを返す
        public function getBringOffThread():Thread
        {
//            log.writeLog(log.LV_WARN, this, "bring off");
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
        }

        // 隠すスレッドを返す
        public override function getHideThread(type:String = ""):Thread
        {
            log.writeLog(log.LV_WARN, this, "hide");
            alpha = 0;
            visible = false;
            return super.getHideThread(type);
        }


    }

}
