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

    public class DuelBonusNum extends UIComponent
    {

//         private static const BONUS_TYPE_MESS:Array = ["null","First Attack Bonus","Strike","Surviver Bonus","FeatBonus Bonus","Over Killing Bonus"]; /* of String */ 
//         private static const COLOR_B_TIME:Number = 0.3; // カラーBになるタイミング

        private var LEFT_X:int = 760;

        private static const _X:int = 10;
        private static const _Y:int = 150;

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
        public function DuelBonusNum()
        {
             super();

            _messLabel.styleName = "DuelBonusLabel";
            resetBonus();
            _messLabel.width = _LABEL_WIDTH;
            _messLabel.height = _LABEL_HEIGHT;
            _messLabel.filters  = [new GlowFilter(0x000000, 1, 4, 4, 16, 1),
                                   new DropShadowFilter(5, 270, 0x000000, 0.3, 8, 8, 1, 1, true),
                                   new DropShadowFilter(2, 70, 0x000000, 0.7, 1, 1, 1, 1, false)];
            _messLabel.x = _X;
            _messLabel.y = _Y;
            _messLabel.visible = true;
            _messLabel.alpha = 1.0;

            addChild(_messLabel);
        }



        public function setBonus( value:int):void
        {
            _bonsuNum +=value;
            var v:String = _bonsuNum.toString();
            _messLabel.text = "Bonus "+ v;

        }

        public function resetBonus():void
        {
            _bonsuNum = 0;
            setBonus(0);
        }

//         public function getUpdateHPThread(hp:int):Thread
//         {
//             _hp = hp;
//             return new BeTweenAS3Thread(this,
//                               {scaleX:1*_scaleX*(_hp/_maxHp)},
//                                              null,
//                                              0.1,
//                                              BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true)

//         }



    }

}
