package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * フェイズ表示クラス
     *
     */


    public class PhaseImage extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/game/phase.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const BLANK:String = "blk";
        private static const DRAW:String = "drw";
        private static const MOVE:String = "mov";
        private static const ATTACK_A:String = "atk_a";
        private static const ATTACK_B:String = "atk_b";
        private static const ATTACK_C:String = "atk_c";
        private static const DEFFENCE_A:String = "def_a";
        private static const DEFFENCE_B:String = "def_b";
        private static const DEFFENCE_C:String = "def_c";

        private var _func_set:Array = [];
        private var _state:String;

        /**
         * コンストラクタ
         *
         */
        public function PhaseImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            init();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        override public function init():void
        {
            _func_set =[[onAttackFirst, onDeffenceFirst, onBlankFirst],[onAttackSecond,onDeffenceSecond, onBlankSecond]];
            onBlank();
        }

        override public function final():void
        {
            _func_set = null;
        }

        public function onBlank():void
        {
            waitComplete(setBlank)
        }

        public function onRefill():void
        {
            waitComplete(setRefill)
        }

        public function onMove():void
        {
            waitComplete(setMove)
        }

        public function battlePhaseUpdate(phase:int, initi:Boolean):void
        {
            if (initi)
            {
               _func_set[0][phase].apply(this);
            }else{
               _func_set[1][phase].apply(this);
            }
        }

        public function onAttackFirst():void
        {
            waitComplete(setAttackFirst)
        }

        public function onDeffenceFirst():void
        {
            waitComplete(setDeffenceFirst)
        }

        public function onBlankFirst():void
        {
            waitComplete(setBlankFirst)
        }


        public function onAttackSecond():void
        {
            waitComplete(setAttackSecond)
        }

        public function onDeffenceSecond():void
        {
            waitComplete(setDeffenceSecond)
        }

        public function onBlankSecond():void
        {
            waitComplete(setBlankSecond)
        }

        private function setBlank():void
        {
            if (_state != BLANK)
            {
                _root.gotoAndPlay(BLANK);
                _state = BLANK;
            }
        }
        private function setMove():void
        {
            if (_state != MOVE)
            {
                _root.gotoAndPlay(MOVE);
                _state = MOVE;
            }
        }
        private function setRefill():void
        {
            if (_state != DRAW)
            {
                _root.gotoAndPlay(DRAW);
                _state = DRAW;
            }
        }

        private function setAttackFirst():void
        {
            if (_state != ATTACK_A)
            {
                _root.gotoAndPlay(ATTACK_A);
                _state = ATTACK_A;
            }
        }
        private function setDeffenceFirst():void
        {
            if (_state != ATTACK_B)
            {
                _root.gotoAndPlay(ATTACK_B);
                _state = ATTACK_B;
            }

        }
        private function setBlankFirst():void
        {
            if (_state != ATTACK_C)
            {
                _root.gotoAndPlay(ATTACK_C);
                _state = ATTACK_C;
            }

        }

        private function setDeffenceSecond():void
        {
            if (_state != DEFFENCE_A)
            {
                _root.gotoAndPlay(DEFFENCE_A);
                _state = DEFFENCE_A;
            }
        }
        private function setAttackSecond():void
        {
            if (_state != DEFFENCE_B)
            {
                _root.gotoAndPlay(DEFFENCE_B);
                _state = DEFFENCE_B;
            }
        }
        private function setBlankSecond():void
        {
            if (_state != DEFFENCE_C)
            {
                _root.gotoAndPlay(DEFFENCE_C);
                _state = DEFFENCE_C;
            }

        }


    }

}
