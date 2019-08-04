package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * キャラチェンジ中アイコン
     *
     */


    public class DuelBonusMessImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/game/message_bonus.swf")]
        private var _Source:Class;

        private const CRITICAL:String = "bonus_cri";
        private const FEAT:String = "bonus_fea";
        private const INIT:String = "bonus_ini";
        private const SURVIVAL:String = "bonus_sur";
        private const NUM_B:String = "num_b";
        private const NUM_W:String = "num_w";

        private static const _X:int = -134;
        private static const _Y:int = 174;

        private var _critMC:MovieClip;
        private var _featMC:MovieClip;
        private var _initMC:MovieClip;
        private var _survMC:MovieClip;
        private var _mBonusMC:MovieClip;
        private var _wBonusMC:MovieClip;

        private var _mcSet:Array = []; /* of Array */ 

        private var _type:int;

        private var _value:int;

        /**
         * コンストラクタ
         *
         */
        public function DuelBonusMessImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

           _critMC = MovieClip(_root.getChildByName(CRITICAL));
           _featMC = MovieClip(_root.getChildByName(FEAT));
           _initMC = MovieClip(_root.getChildByName(INIT));
           _survMC = MovieClip(_root.getChildByName(SURVIVAL));
           _mBonusMC = MovieClip(_root.getChildByName(NUM_B));
           _mBonusMC.gotoAndStop(0);
           _mBonusMC.visible = false;
           _wBonusMC = MovieClip(_root.getChildByName(NUM_W));
           _wBonusMC.gotoAndStop(0);

           _mcSet[1] = _initMC;
           _mcSet[2] = _critMC;
           _mcSet[3] = _survMC;
           _mcSet[4] = _featMC;
           setBonus(0,0);
           initializePos();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            x = _X;
            y = _Y;
        }

        private function setBonusDo():void
        {
            _mcSet[1].visible = false;
            _mcSet[2].visible = false;
            _mcSet[3].visible = false;
            _mcSet[4].visible = false;
            if (_type > 0 && _type < 5)
            {
                _mcSet[_type].visible = true;
            }
//            frameStop(_mBonusMC,_value)
            _wBonusMC.gotoAndStop(_value)
            log.writeLog(log.LV_FATAL, this, "setBonus",_type, _value);

        }
        public function setBonus(type:int, value:int):void
        {
            _type = type;
            _value = value;
            waitComplete(setBonusDo);

        }



    }

}
