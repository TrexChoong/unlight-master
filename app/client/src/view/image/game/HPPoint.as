package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.utils.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.filters.GlowFilter;

    import mx.controls.Label;
    import mx.core.UIComponent;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;
    import view.*;
    import controller.*;

    /**
     * HPPoint表示クラス
     *
     */


    public class HPPoint extends UIComponent
    {

        private var _HPLabel:Label = new Label();

        private static const HP_LABEL_X:int = 0;
        private static const HP_LABEL_Y:int = -8;
        private static const HP_LABEL_WIDTH:int = 39;
        private static const HP_LABEL_HEIGHT:int = 40;

        private var _MaxHPLabel:Label = new Label();

        private static const MAXHP_LABEL_X:int = 39;
        private static const MAXHP_LABEL_Y:int = 9;
        private static const MAXHP_LABEL_WIDTH:int = 39;
        private static const MAXHP_LABEL_HEIGHT:int = 40;

        private static const FOE_X:int = 600;

        private static const _X:int = 10;
        private static const _Y:int = 405;

        private var _hpLabel:Label = new Label();

        private var _maxHpDigit:int = 2;

        private var _maxHp:int;
        private var _hp:int;

        /**
         * コンストラクタ
         *
         */
        public function HPPoint(enemy:Boolean = false)
        {
            x = _X;
            y = _Y;

            var align:String = "left";
            if(enemy)
            {
                x = FOE_X;
                align = "right";
            }

            // _HPLabel.width = HP_LABEL_WIDTH;
            // _HPLabel.height = HP_LABEL_HEIGHT;
            // _HPLabel.x = HP_LABEL_X;
            // _HPLabel.y = HP_LABEL_Y;
            // _HPLabel.styleName = "HitPoint";
            // _HPLabel.filters = [
            //     new GlowFilter(0x111111, 1, 2, 2, 16, 1),
            //     ];

            // _MaxHPLabel.width = MAXHP_LABEL_WIDTH;
            // _MaxHPLabel.height = MAXHP_LABEL_HEIGHT;
            // _MaxHPLabel.x = MAXHP_LABEL_X;
            // _MaxHPLabel.y = MAXHP_LABEL_Y;
            // _MaxHPLabel.styleName = "MaxHitPoint";
            // _MaxHPLabel.filters = [
            //     new GlowFilter(0x111111, 1, 2, 2, 16, 1),
            //     ];

            _hpLabel.width = 150;
            _hpLabel.height = HP_LABEL_HEIGHT;
            _hpLabel.x = HP_LABEL_X;
            _hpLabel.y = HP_LABEL_Y;
            _hpLabel.styleName = "MaxHitPoint";
            _hpLabel.setStyle("textAlign",align);
            _hpLabel.filters = [
                new GlowFilter(0x111111, 1, 2, 2, 16, 1),
                ];

            // addChild(_HPLabel);
            // addChild(_MaxHPLabel);
            addChild(_hpLabel);
            log.writeLog(log.LV_FATAL, this, "hp label parent", _HPLabel.parent);
            super();
        }

        private function initPoint():void
        {
        }

        public function setHP(hp:int, maxHP:int):void
        {
            _maxHp = maxHP;
            _hp = hp;

            _maxHpDigit = maxHP.toString().length;

            // _MaxHPLabel.text = _maxHp.toString();
            // _HPLabel.text = _hp.toString();
            _hpLabel.htmlText = '<font size="36" color="#FFFFFF">' + hpString + "</font>/" + _maxHp.toString();
        }

        public function getUpdateHPThread(hp:int):Thread
        {
            return new ClousureThread(updateHp, [hp])
        }

        private function updateHp(hp:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "hp update", hp);
            visible  =true;
            _hp = hp;

//             if(_hp >= _maxHp)
//             {
//                 _HPLabel.styleName = "HitPoint";
//             }
//             else if(_hp > _maxHp / 2)
//             {
//                 _HPLabel.styleName = "HitPointYellow";
//             }
//             else
//             {
//                 _HPLabel.styleName = "HitPointRed";
//             }
            // _HPLabel.text = _hp.toString();
            _hpLabel.htmlText = '<font size="36" color="#FFFFFF">' + hpString + "</font>/" + _maxHp.toString();
        }

        private function get hpString():String
        {
            var str:String = _hp.toString();
            while (str.length < _maxHpDigit) {
                str = " " + str;
            }
            return str;
        }


    }

}
