package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.utils.*;

    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.core.UIComponent;
    import mx.controls.*

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import controller.*;

    /**
     * ターン表示クラス
     *
     */

    public class RaidScoreNum extends UIComponent
    {
        private var LEFT_X:int = 760;

        private static const _X:int = 510;
        private static const _Y:int = 645;

        private static const _LABEL_WIDTH:int = 170;                              // ラベルの幅
        private static const _LABEL_HEIGHT:int = 100;                              // ラベルの高さ

        private static const _W:int = 344;
        private static const _H:int = 7;

        private var _scaleX:Number = 1;

        protected var _messLabel:Text = new Text();                               // 表示メッセージ用ラベル
        private var _bonsuNum:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function RaidScoreNum()
        {
             super();

            _messLabel.styleName = "RaidScoreLabel";
            resetScore();
            _messLabel.width = _LABEL_WIDTH;
            _messLabel.height = _LABEL_HEIGHT;
            _messLabel.filters  = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1),
                                   new DropShadowFilter(5, 270, 0x000000, 0.3, 8, 8, 1, 1, true),
                                   new DropShadowFilter(2, 70, 0x000000, 0.7, 1, 1, 1, 1, false)];
            _messLabel.x = _X;
            _messLabel.y = _Y;
            _messLabel.visible = true;
            _messLabel.alpha = 1.0;

            addChild(_messLabel);
        }



        public function setScore( value:int):void
        {
            _bonsuNum =value;
            var v:String = _bonsuNum.toString();
            //_messLabel.text = "Score "+ v;
            _messLabel.text = v.toString();
            BetweenAS3.serial(
                BetweenAS3.to(_messLabel,{_glowFilter:{color:0x000000}},0.001),
                BetweenAS3.to(_messLabel,{_glowFilter:{blurX:10, blurY:10, color:0x000000}},0.15),
                BetweenAS3.to(_messLabel,{_glowFilter:{blurX:2, blurY:2, color:0x00000 }},0.05),
                BetweenAS3.to(_messLabel,{_glowFilter:{blurX:2, blurY:2, color:0xFFFFFF}},0.001)
                ).play();
        }

        public function resetScore():void
        {
            _bonsuNum = 0;
            setScore(0);
        }



    }
}
