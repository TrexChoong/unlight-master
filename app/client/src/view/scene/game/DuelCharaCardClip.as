package view.scene.game
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;

    import model.CharaCard;
    import model.CharaCardInventory;
    import model.DeckEditor;
    import model.Growth;
    import model.GrowthTree;
    import view.image.game.*;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.game.BuffClip;
    import view.scene.common.CharaCardClip;

    /**
     * CharaCardClip表示クラス
     *
     */


    public class DuelCharaCardClip  extends CharaCardClip
    {
        /**
         * コンストラクタ
         *
         */
        private static const PL_X:int  = 0;
        private static const PL_Y:int  = -32;
        private static const FOE_X:int = 0;
        private static const FOE_Y:int = 240;

        private static const DEAD_COLOR:Number = 0.5;
        private static const ALIVE_COLOR:Number = 1.0;
        private var dark:Boolean = false;

        private var _tab:CharaCardSelectTabImage;

        public function DuelCharaCardClip(cc:CharaCard, foe:Boolean = false, raidBoss:Boolean = false)
        {
            super(cc,foe);
            _tab = new CharaCardSelectTabImage(_foe);
            _buffSetTurn = !raidBoss;
        }
        public override function labelInitialize():void
        {
            super.labelInitialize();
            // もしUNKNOWカードなら
            if (_charaCard.id == 0)
            {
            }
            else
            {
                _tab.maxHP = _charaCard.hp;
                _tab.atk = _charaCard.ap;
                _tab.def = _charaCard.dp;
                _tab.level = _charaCard.level;
                _tab.charaName= _charaCard.name;
                _tab.HP = _charaCard.hp;
            }
        }



      public function setTab(num:int = 0):void
        {
            if (_foe)
            {
                _tab.x = FOE_X;
                _tab.y = FOE_Y

            }else{
                _tab.x = PL_X;
                _tab.y = PL_Y;
            }
            addChild(_tab);
        }

        public function removeTab():void
        {
            log.writeLog(log.LV_FATAL, this, "remove");
            if(_tab.parent ==this)
            {
                removeChild(_tab)
            }
            addChild(_metaContainer);
        }

        public function onTab():void
        {
//            _tab.mouseOver();
            addChild(_metaContainer);
        }

        public function offTab():void
        {
            log.writeLog(log.LV_FATAL, this, "offtab");
//            _tab.mouseOut();
//             if(_metaContainer.parent ==this)
//             {
//                 removeChild(_metaContainer);
//             }

        }

        public override function set alpha(a:Number):void
        {
            _metaContainer.alpha = a;
        }


        public function dead():void
        {
            toDark();
        }

        public override function set hp(h:int):void
        {
            super.hp = h;

            if(h >= _charaCard.hp)
            {
                _tab.HPLabel.styleName = "CharaCardParam";
            }
            else if(h >= _charaCard.hp / 2)
            {
                _tab.HPLabel.styleName = "CharaCardParamYellow";
            }
            else
            {
                _tab.HPLabel.styleName = "CharaCardParamRed";
            }
            _tab.HP = h;
        }

        public function get feats():Array
        {
            return _charaCard.feats;
        }

        public function HPReview():void
        {
            if (dark)
            {
                toLight();
            }
            _tab.HPReview();
        }

        private function toDark():void
        {
            BetweenAS3.tween(_metaContainer,
                             { transform: {colorTransform: { redMultiplier:DEAD_COLOR, greenMultiplier:DEAD_COLOR, blueMultiplier:DEAD_COLOR}}},
                             null,
                             0.5).play();
            dark = true;
        }

        private function toLight():void
        {
            BetweenAS3.tween(_metaContainer,
                             { transform: {colorTransform: { redMultiplier:ALIVE_COLOR, greenMultiplier:ALIVE_COLOR, blueMultiplier:ALIVE_COLOR}}},
                             null,
                             0.5).play();
            dark = false;
        }

    }
}

