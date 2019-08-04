package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import mx.core.UIComponent;

    import flash.events.MouseEvent;
    import view.image.BaseImage;

    /**
     * ActionCardAttack表示クラス
     *
     */

    public class ActionCardValue extends BaseImage
    {
        // ActionCard近接表示元SWF
        [Embed(source="../../../../data/image/game/acswd.swf")]
        private static var Swd:Class;
        // ActionCard遠距離表示元SWF
        [Embed(source="../../../../data/image/game/acbow.swf")]
        private static var Arw:Class;
        // ActionCard防御表示元SWF
        [Embed(source="../../../../data/image/game/acdef.swf")]
        private static var Def:Class;
        // ActionCard移動表示元SWF
        [Embed(source="../../../../data/image/game/acmove.swf")]
        private static var Move:Class;
        // ActionCard特殊表示元SWF
        [Embed(source="../../../../data/image/game/acstar.swf")]
        private static var Star:Class;
        // ActionCard特殊表示元SWF
        [Embed(source="../../../../data/image/game/acchance.swf")]
        private static var Chance:Class;

        private static var ClassArray:Array = [Swd, Arw,Def, Move, Star, Chance];
        private static const MARK_NAME:Array = ["on_atk", "on_bow","on_def", "on_mov", "on_str", ""];
        private var _onMark:MovieClip;
        private var _value:int;
        private var _type:int;
        private var _on:Boolean;

        /**
         * コンストラクタ
         *
         */
        public function ActionCardValue(type:int)
        {
            _type = type - 1;
            super();
//            if( (type > ClassArray.length) || type < 1) throw new ArgumentError("Invalid Type No."); 
        }

        override protected function get Source():Class
        {
            return ClassArray[_type];
        }

        // 初期化関数
        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            if (_type != 5)
            {
                _onMark = MovieClip(_root.getChildAt(1));
//            _onMark = MovieClip(_root.getChildByName(MARK_NAME[_type]));
                _onMark.visible = false;
            }
        }
        public function atValue(v:int):void
        {
            if (v > 9)
            {
                _value = 9;
            }else if (v < 1)
            {
                _value = 9+Math.abs(v);
            }else{
                _value = v;
            }
            waitComplete(setValue)
        }

        public function get type():int
        {
            
            return _type;
        }

        private function setValue():void
        {
//          _root.stop()
          _root.gotoAndStop(_value);
//              _root.gotoAndStop(3);

       }

        public function set onMark(b:Boolean):void
        {
            _on = b;
            waitComplete(setMark)
        }

        private function setMark():void
        {
            if (_onMark!=null)
            {
                _onMark.visible = _on;
            }

       }

    }

}
