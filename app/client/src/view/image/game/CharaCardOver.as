package view.image.game
{

    import flash.display.*;
    import flash.geom.*;
    import flash.events.Event;
    import mx.core.UIComponent;

    import flash.events.MouseEvent;
    import view.image.BaseImage;
    import view.utils.*;

    import model.CharaCard;
    /**
     * CharaCardOver表示クラス
     *
     */


    public class CharaCardOver extends BaseImage
    {

        // CharaCardOver表示元SWF
        [Embed(source="../../../../data/image/ccframe_a_over.swf")]
        private var _NormalFrameSource:Class;
        [Embed(source="../../../../data/image/ccframe_b_over.swf")]
        private var _RebornFrameSource:Class;
        [Embed(source="../../../../data/image/ccframe_c_over.swf")]
        private var _EpisodeFrameSource:Class;

        public static const CLIP_AREA:Rectangle = new Rectangle(-0,-0,70,15);
        public static const STAR_POINT_SET:Array = [new Point(56,0),new Point(45,0),new Point(34,0),new Point(23,0),new Point(12,0),new Point(1,0)];
        private const RARE:String = "rare";
        private  static var __characardStar:CharaCardStar =  CharaCardStar.instance;

        private var _rarity:int;
        private var _colors:Array; /* of int */ 
        private var _cardID:int;
        private var _level:int;
        private var _kind:int;
        private var _turn:Boolean = true;
        private var _obverse:Boolean = false;
        private var _colorMC:MovieClip;
        private var _starBitmapData:BitmapData;
        private var _colorStarBitmap:Bitmap;

        private var _atkPlusMC:MovieClip;
        private var _atkSPlusMC:MovieClip;
        private var _atkLPlusMC:MovieClip;
        private var _atkBonus:Array; /* of int */

        private var _defPlusMC:MovieClip;
        private var _defSPlusMC:MovieClip;
        private var _defLPlusMC:MovieClip;
        private var _defBonus:Array; /* of int */

        private var _weaponBonusesNumBaseY:int; // デフォルトのY座標を保存

        /**
         * コンストラクタ
         *
         */
        public function CharaCardOver(kind:int)
        {
            _kind = kind;
            super();
//            _mc.addEventListener(MouseEvent.CLICK,clickHandler);
            _starBitmapData = new BitmapData(CLIP_AREA.width,CLIP_AREA.height,true,0x00000000);

        }

        override protected function get Source():Class
        {
            switch (_kind) {
            case Const.CC_KIND_REBORN_CHARA:
                return _RebornFrameSource;
                break;
            case Const.CC_KIND_EPISODE:
                return _EpisodeFrameSource;
                break;
            default:
                return _NormalFrameSource;
            }
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            _colorMC = MovieClip(_root.getChildByName(RARE));
            _colorMC.gotoAndStop(1);
            _starBitmapData.draw(_colorMC);
            _colorStarBitmap = new Bitmap(_starBitmapData);
            _colorStarBitmap.x = 96;
            _colorStarBitmap.y = 24;

            _atkPlusMC = MovieClip(_root.getChildByName("atk_plus"));
            _atkPlusMC.gotoAndStop(10);
            _atkSPlusMC = MovieClip(_root.getChildByName("atk_plus_s"));
            _atkSPlusMC.gotoAndStop(10);
            _atkLPlusMC = MovieClip(_root.getChildByName("atk_plus_l"));
            _atkLPlusMC.gotoAndStop(10);

            _defPlusMC = MovieClip(_root.getChildByName("def_plus"));
            _defPlusMC.gotoAndStop(10);
            _defSPlusMC = MovieClip(_root.getChildByName("def_plus_s"));
            _defSPlusMC.gotoAndStop(10);
            _defLPlusMC = MovieClip(_root.getChildByName("def_plus_l"));
            _defLPlusMC.gotoAndStop(10);
            _weaponBonusesNumBaseY = _defLPlusMC.y;

            addChild(_colorStarBitmap);
            RemoveChild.apply(_colorMC);

//             Unlight.GCW.watch(_starBitmapData);
        }

        override public function final(): void
        {
            _starBitmapData.dispose();
            __characardStar.clearSetStar();
            _colorStarBitmap = null;
            _starBitmapData = null;
        }

        private function clickHandler(e:MouseEvent):void
        {

           if (_obverse==true)
            {
                onReverse();
                _obverse = false;
            }
            else
            {
                onObverse();
                _obverse = true;
            }
        }

        public function onObverse():void
        {
            waitComplete(setObverse)
        }

        private function setObverse():void
        {
            _root.gotoAndStop(1);
        }

        public function onReverse():void
        {
            waitComplete(setReverse);
        }

        private function setReverse():void
        {
            _root.gotoAndStop(2);
        }

        public function setTurn(t:Boolean):void
        {
            _turn = t;
            waitComplete(setTurnComplete);
        }
        private function setTurnComplete():void
        {
            _root.getChildByName("turn").visible = _turn;
        }


        public function setLevel(level:int):void
        {
            _level = level;
            if(_level > 5){_level = 5}
            waitComplete(setLevelComplete);
        }

        private function setLevelComplete():void
        {
            _root.gotoAndStop(_level);
        }

        public function setCardID(cardID:int = 0):void
        {
            _cardID = cardID;
            waitComplete(setCardIDComplete);
        }

        private function setCardIDComplete():void
        {
            var val:int = 0;
            // カードIDに応じてフレームを設定
            if(_cardID == 0)
            {
                val = 6;
            }
            else if(CharaCard.ID(_cardID).kind == Const.CC_KIND_CHARA ||CharaCard.ID(_cardID).kind == Const.CC_KIND_REBORN_CHARA || CharaCard.ID(_cardID).kind == Const.CC_KIND_RARE_MONSTAR)
            {
                val = _level;
                val += (_cardID%10)>5 || _cardID%10 == 0 ? 6:0;
            }
            else
            {
                val = _level + 11;
            }
            _root.gotoAndStop(val);
        }

//         public function setRarity(rarity:int):void
//         {
//             _rarity = rarity;
//             waitComplete(setRarityComplete);
//         }

        public function setColorSlot(colors:Array):void
        {
//            _rarity = rarity;
            _colors = colors.sort();
//            log.writeLog(log.LV_FATAL, this, "color sort",_colors);
            waitComplete(waitStar);
        }

        private function waitStar():void
        {
            __characardStar.setStar(setRarityComplete);
        }

        private function setRarityComplete():void
        {
//            MovieClip(_root.getChildByName("rare")).gotoAndStop(_rarity);
            var p:int = 0
            _colors.forEach(function(item:*, index:int, array:Array):void
                           {
                               if (item!=0)
                               {
                                   _starBitmapData.copyPixels(__characardStar.getStarBitmapData(item),CharaCardStar.CLIP_AREA,STAR_POINT_SET[p]);
                                   p++;
                               }
                           });
        }

        public function setAtkBonus(atk:Array):void
        {
            _atkBonus = atk;
            waitComplete(setAtkBonusComplete);
        }

        private function setAtkBonusComplete():void
        {
            // 数値の設定
            if(_atkBonus[0] == _atkBonus[2])
            {
                _atkPlusMC.gotoAndStop(10+_atkBonus[0]);
                _atkSPlusMC.gotoAndStop(10);
                _atkLPlusMC.gotoAndStop(10);
            }
            else if(_atkBonus[2] == 0)
            {
                _atkPlusMC.gotoAndStop(10);
                _atkSPlusMC.gotoAndStop(10+_atkBonus[0]);
                _atkSPlusMC.y = _weaponBonusesNumBaseY;
                _atkLPlusMC.gotoAndStop(10);
            }
            else if(_atkBonus[0] == 0)
            {
                _atkPlusMC.gotoAndStop(10);
                _atkSPlusMC.gotoAndStop(10);
                _atkLPlusMC.gotoAndStop(10+_atkBonus[2]);
            }
            else if(_atkBonus[0] != 0 && _atkBonus[2] != 0) {
                _atkPlusMC.gotoAndStop(10);
                _atkSPlusMC.gotoAndStop(10+_atkBonus[0]);
                _atkSPlusMC.y = _weaponBonusesNumBaseY - 10;
                _atkLPlusMC.gotoAndStop(10+_atkBonus[2]);
            }
        }

        public function setDefBonus(def:Array):void
        {
            _defBonus = def;
            waitComplete(setDefBonusComplete);
        }

        private function setDefBonusComplete():void
        {
            // 数値の設定
            if(_defBonus[0] == _defBonus[2])
            {
                _defPlusMC.gotoAndStop(10+_defBonus[0]);
                _defSPlusMC.gotoAndStop(10);
                _defLPlusMC.gotoAndStop(10);
            }
            else if(_defBonus[2] == 0)
            {
                _defPlusMC.gotoAndStop(10);
                _defSPlusMC.gotoAndStop(10+_defBonus[0]);
                _defSPlusMC.y = _weaponBonusesNumBaseY;
                _defLPlusMC.gotoAndStop(10);
            }
            else if(_defBonus[0] == 0)
            {
                _defPlusMC.gotoAndStop(10);
                _defSPlusMC.gotoAndStop(10);
                _defLPlusMC.gotoAndStop(10+_defBonus[2]);
            }
            else if(_defBonus[0] != 0 && _defBonus[2] != 0) {
                _defPlusMC.gotoAndStop(10);
                _defSPlusMC.gotoAndStop(10+_defBonus[0]);
                _defSPlusMC.y = _weaponBonusesNumBaseY - 10;
                _defLPlusMC.gotoAndStop(10+_defBonus[2]);
            }

        }

    }

}
