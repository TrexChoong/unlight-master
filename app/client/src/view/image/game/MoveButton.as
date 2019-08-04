package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import mx.core.UIComponent;

    import flash.events.MouseEvent;
    import view.image.BaseImage;
    import model.Duel;

    /**
     * MoveButton表示クラス
     *
     */

    public class MoveButton extends BaseImage
    {
        // OKボタン 表示元SWF
        [Embed(source="../../../../data/image/move_f.swf")]
        private static var _fb:Class;
        [Embed(source="../../../../data/image/move_b.swf")]
        private static var _bb:Class;
        [Embed(source="../../../../data/image/move_s.swf")]
        private static var _sb:Class;
        [Embed(source="../../../../data/image/move_c.swf")]
        private static var _cb:Class;

        // 条件チップの配列
        private static var ClassArray:Array = [_fb, _bb, _sb, _cb];

        // 表示タイプ
        private var _type:int;

        // 定数
        public static const FRONT:int = 0;                // 前移動
        public static const BACK:int = 1;                 // 後移動
        public static const STAY:int = 2;                 // 待機
        public static const CHANGE:int = 3;               // キャラ変更

        //public static const Y:int= 261;
        public static const Y:int= 258;
        private var _frame:int=0;
        /**
         * コンストラクタ
         *
         */
        public function MoveButton(type:int)
        {
            y = Y;
            _type = type;
            super();
        }

        override protected function get Source():Class
        {
            return ClassArray[_type];
        }

        // 初期化関数
        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
        }

        // 位置の初期化
        public function initPosition(rule:int):void
        {
            if(rule == Duel.RULE_3VS3)
            {
                switch (_type)
                {
                case FRONT:
                    x = 440;
                    break;
                case BACK:
                    x = 272;
                    break;
                case STAY:
                    x = 328;
                    break;
                case CHANGE:
                    x = 384;
                    break;
                }

            }
            else
            {
                switch (_type)
                {
                case FRONT:
                    x = 412;
                    break;
                case BACK:
                    x = 300;
                    break;
                case STAY:
                    x = 356;
                    break;
                case CHANGE:
                    x = -1000;
                    break;
                }
            }
        }

        public function setFrame(f:int=0):void
        {
            visible = true;
            _frame = f;
            if (f == 0)
            {
                enabled = true;
            }
            else
            {
                enabled = false;
            }
            waitComplete(frameStoppp);
        }

        private function frameStoppp():void
        {
            MCRoot.gotoAndStop(_frame);
        }
    }
}
