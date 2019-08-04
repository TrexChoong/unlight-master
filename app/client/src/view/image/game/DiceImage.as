package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.image.BaseImage;

    /**
     * ダイス表示クラス
     *
     */

    public class DiceImage extends BaseImage
    {
        // atkダイス表示元SWF
        [Embed(source="../../../../data/image/dice_atk.swf")]
        private static var _atk:Class;
        // defダイス表示元SWF
        [Embed(source="../../../../data/image/dice_def.swf")]
        private static var _def:Class;

        // 条件チップの配列
        private static var ClassArray:Array = [_atk, _def];

        // 表示タイプ
        private var _type:int;

        /**
         * コンストラクタ
         *
         */
        public function DiceImage(type:int)
        {
            _type = type;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            waitComplete(normalComplete);
        }

        override protected function get Source():Class
        {
            return ClassArray[_type];
        }

        public function crash():void
        {
            waitComplete(crashComplete);
        }

        public function normal():void
        {
            waitComplete(normalComplete);
        }

        public function hit():void
        {
            waitComplete(hitComplete);
        }

        public function crashComplete():void
        {
            if(_type == 0)
            {
                MovieClip(_root.getChildByName("dice_atk")).gotoAndPlay("pake");
            }
            else
            {
                MovieClip(_root.getChildByName("dice_def")).gotoAndPlay("pake");
            }
        }

        public function normalComplete():void
        {
//             if(_type == 0)
//             {
//                 MovieClip(_root.getChildByName("dice_atk")).gotoAndPlay("normal");
//             }
//             else
//             {
//                 MovieClip(_root.getChildByName("dice_def")).gotoAndPlay("normal");
//             }
        }

        public function hitComplete():void
        {
            if(_type == 0)
            {
                MovieClip(_root.getChildByName("dice_atk")).gotoAndPlay("hit");
            }
            else
            {
//                 MovieClip(_root.getChildByName("dice_def")).gotoAndPlay("hit");
            }
        }
    }
}
