package view.image.game
{

    import flash.display.*;
    import flash.geom.*;

    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * トラップ表示クラス
     *
     */


    public class TrapImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/game/effect_trap.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 416;
        private static const MAX_TURN:int = 2;
        private const CENTRE_X:int = 360;
        private const TRAP_START_MARGINE:int = 70;
        private const TRAP_MARGINE:int = 90;

        private var _trapMC:Array = [];

        public var _kind:int;
        public var _pos:int;
        public var _turn:int;

        private static const TRAP_KIND:Array = ["trap_a", "trap_b", "trap_c", "trap_d", "trap_e"];

        /**
         * コンストラクタ
         *
         */
        public function TrapImage()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            initializePos();
            log.writeLog(log.LV_DEBUG, this, "トラップswfinit");
            for (var i:int = 0; i < TRAP_KIND.length; i++)
            {
                _trapMC.push(MovieClip(_root.getChildByName(TRAP_KIND[_kind])));
                _trapMC[i].y = Y;
                log.writeLog(log.LV_DEBUG, this, "===== _kind", _kind);
                if (_kind == 4) {
                    _trapMC[i].y += 100;
                }
                _trapMC[i].y = Y;
                _trapMC[i].visible = false;
            }
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {

        }

        public function showTrap():void
        {
            if (_trapMC[_kind])
            {
                _trapMC[_kind].visible = true;
            }
        }

        public function hideTrap():void
        {
            if (_trapMC[_kind])
            {
                _trapMC[_kind].visible = false;
            }
        }

        public function getXPos():int
        {
            return _pos;
        }

        public function setTurn(turn:int):void
        {
            _turn = turn;
            waitComplete(_setTurn);
        }

        private function _setTurn():void
        {
            if (_trapMC[_kind])
            {
                if (0 < _turn && _turn < 3)
                {
                    _trapMC[_kind].visible = true;
                    _trapMC[_kind].gotoAndStop(MAX_TURN - _turn); //残りターン1のときフレーム1、残りターン2のときフレーム0
                }
                else if (_turn < 1)
                {
                    _trapMC[_kind].visible = false;
                }
            }
        }

        public function setXPos(pos:int):void
        {
            _pos = pos;
            if (!_trapMC[_kind]) return;

            _trapMC[_kind].x = _pos;
        }

        public function getTrapImage():MovieClip
        {
            return _trapMC[_kind];
        }

    }

}
