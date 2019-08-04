package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.filters.GlowFilter;

    import mx.controls.Label;

    import view.image.BaseImage;

    /**
     * StageOk表示クラス
     *
     */


    public class CharaCardSelectTabImage extends BaseImage
    {
///        [Embed(source="../../../../data/image/game/tab_card.swf")]
        [Embed(source="../../../../data/image/game/chara_status.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
//         private static const TAB_E:String = "tab_e";
//         private static const TAB_P:String = "tab_p";

        private var _plMC:MovieClip;
        private var _foeMC:MovieClip;
        private var _isFoe:Boolean;
        private var _tabMC:MovieClip;

        private var _isDead:Boolean = false;
        private var _deadPanel:MovieClip;

        private var _lvLabel:Label = new Label();
        private var _atkLabel:Label = new Label();
        private var _defLabel:Label = new Label();
        private var _maxHPLabel:Label = new Label();

        private var _textSet:Array = [_lvLabel, _atkLabel, _defLabel, _maxHPLabel];

        private static const LABEL_WIDTH:int = 19;
        private static const LABEL_HEIGHT:int = 14;

//         private static const LABEL_WIDTH:int = 20;
//         private static const LABEL_HEIGHT:int = 20;

        private static const LV_LABEL_X:int = 14;
        private static const ATK_LABEL_X:int = 61;
        private static const DEF_LABEL_X:int = 100;
        private static const MAXHP_LABEL_X:int = 150;

        private static const LABEL_Y:int = 19;

        private static const LABEL_X_SET:Array = [LV_LABEL_X, ATK_LABEL_X, DEF_LABEL_X, MAXHP_LABEL_X];
        private static const LABEL_BLACK_SET:Array = [true,true,true,false];


        private var _HPLabel:Label = new Label();
        private static const HP_LABEL_X:int = 138;
        private static const HP_LABEL_Y:int = -2;
        private static const HP_LABEL_WIDTH:int = 30;
        private static const HP_LABEL_HEIGHT:int = 25;

        private var _nameLabel:Label = new Label();
        private static const NAME_LABEL_X:int = 8;
        CONFIG::LOCALE_JP
            private static const NAME_LABEL_Y:int = -1;
        CONFIG::LOCALE_EN
            private static const NAME_LABEL_Y:int = 2;
        CONFIG::LOCALE_TCN
            private static const NAME_LABEL_Y:int = 2;
        CONFIG::LOCALE_SCN
            private static const NAME_LABEL_Y:int = 2;
        CONFIG::LOCALE_KR
            private static const NAME_LABEL_Y:int = -1;
        CONFIG::LOCALE_FR
            private static const NAME_LABEL_Y:int = 2;
        CONFIG::LOCALE_ID
            private static const NAME_LABEL_Y:int = 2;
        CONFIG::LOCALE_TH
            private static const NAME_LABEL_Y:int = 2;

        private static const NAME_LABEL_WIDTH:int = 130;
        private static const NAME_LABEL_HEIGHT:int = 18;

        /**
         * コンストラクタ
         *
         */
        public function CharaCardSelectTabImage(isFoe:Boolean = false)
        {
            super();
            _isFoe = isFoe;
            _textSet.forEach(function(item:*, index:int, array:Array):void{setLabel(item, LABEL_X_SET[index], LABEL_Y, LABEL_BLACK_SET[index])});

            _HPLabel.width = HP_LABEL_WIDTH;
            _HPLabel.height = HP_LABEL_HEIGHT;
            _HPLabel.x = HP_LABEL_X;
            _HPLabel.y = HP_LABEL_Y;
            _HPLabel.styleName = "CharaCardParam";
            // _HPLabel.filters = [
            //     new GlowFilter(0x111111, 1, 2, 2, 16, 1),
            //     ];

            addChild(_HPLabel);

            _nameLabel.width = NAME_LABEL_WIDTH;
            _nameLabel.height = NAME_LABEL_HEIGHT;
            _nameLabel.x = NAME_LABEL_X;
            _nameLabel.y = NAME_LABEL_Y;
            _nameLabel.styleName = "CharaCardStatusTabNameLabel";
            // _nameLabel.filters = [
            //     new GlowFilter(0x111111, 1, 2, 2, 16, 1),
            //     ];

            callLater(fontSizeAdjust,[_nameLabel])
            addChild(_nameLabel);
        }

        private function setLabel(t:Label, tx:int, ty:int, black:Boolean):void
        {
            t.width = LABEL_WIDTH;
            t.height = LABEL_HEIGHT;
            t.x = tx;
            t.y = ty;
            t.text = "?";
            t.styleName = "CharaCardStatusTabLabel";
            if (black) t.setStyle("color","#4c4c4c");
            addChild(t);
        }

        // 名前が全部はいるように調整
        private function fontSizeAdjust(label:Label):void
        {
            var w:int = label.width;
            label.validateNow();
            while (label.textWidth > w)
            {
                label.validateNow();
                label.setStyle("fontSize",  int(label.getStyle("fontSize"))-1);
                label.setStyle("paddingTop",  int(label.getStyle("paddingTop"))+1);
            }
        }

        override protected function swfinit(event: Event): void
        {
             super.swfinit(event);

             _deadPanel = MovieClip(_root.getChildByName("death"));
             _deadPanel.visible = false;
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function set level(i:int):void
        {
            _lvLabel.text = i.toString();
        }
        public function set atk(i:int):void
        {
            _atkLabel.text = i.toString();
        }
        public function set def(i:int):void
        {
            _defLabel.text = i.toString();
        }
        public function set maxHP(i:int):void
        {
            _maxHPLabel.text = (i < Const.DUEL_CC_VIEW_HP_MAX) ? i.toString() : "∞";
            // _maxHPLabel.text = i.toString();
        }

        public function set HP(i:int):void
        {
            _HPLabel.text = (i < Const.DUEL_CC_VIEW_HP_MAX) ? i.toString() : Const.OVER_HP_STR;
            if (i <= 0 && _maxHPLabel.text != "?") {
                _deadPanel.visible = true;
                _HPLabel.visible = false;
            }
        }

        public function set charaName(s:String):void
        {
            _nameLabel.text = s;
        }

        public function get charaName():String
        {
            return  _nameLabel.text;
        }

        public function get HPLabel():Label
        {
            return _HPLabel;
        }

        public function HPReview():void
        {
            _deadPanel.visible = false;
            _HPLabel.visible = true;
        }

//         public function mouseOver():void
//         {
// //            waitComplete(setEnable);
//         }


//         private function setEnable():void
//         {
//             if (!_isDead)
//             {
//                 _tabMC.gotoAndStop("en");
//             }
//         }


//         public function mouseOut():void
//         {
// //            waitComplete(setDisable);
//         }


//         private function setDisable():void
//         {
//             if (!_isDead)
//             {
//                 _tabMC.gotoAndStop("dis");
//             }
//         }

//         public function dead():void
//         {
// //            waitComplete(setDead);
//         }


//         private function setDead():void
//         {
//             _tabMC.gotoAndStop("dead");
//             _isDead = true;
//         }

    }

}
