package view.image.regist
{

    import flash.display.*;
    import flash.events.Event;

    import org.libspark.thread.Thread;
    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.BaseImage;

    /**
     * 名前入力背景
     *
     */

    public class CharaSelectImage extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/regist/make_3chara.swf")]
        private var _Source:Class;
        private static const SCALE:Number = 1.0;
        private static const X:int = 0;
        private static const Y:int = 0;

        private static const NAME_CHARAS:Array = ["chara_a", "chara_b", "chara_c", "chara_d", "chara_e"];


        private var _charas:Array = []; /* of SimpleButton */ ;

        /**
         * コンストラクタ
         *
         */
        public function CharaSelectImage ()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);

            NAME_CHARAS.forEach(function(item:*, index:int, array:Array):void{_charas.push(MovieClip(_root.getChildByName(item)))});
            // _charas.forEach(initCardsPos);

            // initializePos();
            charasOn(-1);
        }
        private function initCardsPos(item:*, index:int, array:Array):void
        {
            item.x = 355;
        }
        override protected function get Source():Class
        {
            return _Source;
        }

        public function initializePos():void
        {
            scaleX = SCALE;
            scaleY = SCALE;
            x = X;
            y = Y;
            alpha = 1.0;
        }

        public function charasOn(index:int):void
        {
            for(var i:int = 0; i < _charas.length; i++)
            {
                if (i == index)
                {
                    _charas[i].visible = true;
                }
                else
                {
                    _charas[i].visible = false;
                }
            }
        }

        public function charasNormal(index:int):void
        {
//                    _charas[index].visible = false;

        }
        public function charasOver(index:int):void
        {
        }

        public function get cardFrames():Array /* of ElementType */ 
        {
            return _charas;
        }
    }

}

