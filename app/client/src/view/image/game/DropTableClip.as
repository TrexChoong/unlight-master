package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ドロップテーブルクラス
     *
     */


    public class DropTableClip extends BaseImage
    {

        // ドロップテーブル表示元SWF
        [Embed(source="../../../../data/image/game/space.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const ATTACK_WAIT_PHASE:int = 0;
        private static const ATTACK_PHASE:int = 1;
        private var _beforePhase:int = 0;

//         private var _blankMC:MovieClip;
//         private var _atkSwdMC:MovieClip;
//         private var _defMC:MovieClip;
//         private var _waitDefMC:MovieClip;
//         private var _waitAtkMC:MovieClip;
//         private var _movMC:MovieClip;
//         private var _mov3MC:MovieClip;
//         private var _drwMC:MovieClip;
//         private var _atkArwMC:MovieClip;
//         private var _changeMC:MovieClip;


        /**
         * コンストラクタ
         *
         */
        public function DropTableClip()
        {
            super();
            x = X;
            y = Y;
        }

        override protected function swfinit(event: Event): void 
        {

            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function onBlank():void
        {
            waitComplete(setBlank)
        }

        public function onAttackSword():void
        {
            waitComplete(setAttackSword);
        }
        public function onAttackArrow():void
        {
            waitComplete(setAttackArrow);
        }
        public function onAttackAll():void
        {
            waitComplete(setAttackAll);
        }

        public function onDeffence():void
        {
            waitComplete(setDeffence);
        }

        public function onMove():void
        {
            waitComplete(setMove);
        }

        public function onDraw():void
        {
            waitComplete(setDraw);
        }

        public function onEvent():void
        {
            waitComplete(setEvent);
        }

        public function onMoveThree():void
        {
            waitComplete(setMoveThree);
        }

        public function onWait():void
        {
            // 最後のフェイズが攻撃だったならば防御待機
            if (_beforePhase == ATTACK_PHASE)
            {
                waitComplete(setAtkWait);
            }else{
                waitComplete(setDefWait);
            }
        }

        public function onCharaChange():void
        {
            waitComplete(setCharaChange);
        }

        private function setBlank():void
        {
            _root.gotoAndStop("blank");
        }

        private function setAttackSword():void
        {
            _root.gotoAndStop("atk");
            _beforePhase = ATTACK_PHASE;
        }

        private function setAttackArrow():void
        {
            _root.gotoAndStop("atk_l");
            _beforePhase = ATTACK_PHASE;
        }

        private function setAttackAll():void
        {
            _root.gotoAndStop("atk_all");
            _beforePhase = ATTACK_PHASE;
        }

        private function setDeffence():void
        {
            _root.gotoAndStop("def");
        }
        private function setMove():void
        {
            _root.gotoAndStop("mov");
        }

        private function setDraw():void
        {
            _root.gotoAndStop("drw_act");
        }

        private function setEvent():void
        {
            _root.gotoAndStop("drw_evt");
        }

        private function setMoveThree():void
        {
            _root.gotoAndStop("mov3on3");
        }

        private function setAtkWait():void
        {
            _root.gotoAndStop("wait_atk");
            _beforePhase = ATTACK_WAIT_PHASE;

        }
        private function setDefWait():void
        {
            _root.gotoAndStop("wait_def");
        }

        private function setCharaChange():void
        {
            _root.gotoAndStop("change");
        }



    }

}
