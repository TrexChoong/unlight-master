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

    public class CardSelectorBG extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/regist/make_3card.swf")]
        private var _Source:Class;
        private static const SCALE:Number = 1.0;
        private static const X:int = 0;
        private static const Y:int = 0;
        private static const NAME_CARDS:Array = ["card_a","card_b","card_c","card_d","card_e"];
        
        private static const LABEL_NORMAL:String = "normal";
        private static const LABEL_OVER:String = "over";
        private static const LABEL_ON:String = "on";

        private var _cards:Array = []; /* of SimpleButton */ ;

        /**
         * コンストラクタ
         *
         */
        public function CardSelectorBG()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
            NAME_CARDS.forEach(function(item:*, index:int, array:Array):void{_cards.push(SimpleButton(_root.getChildByName(item)))});

            _cards.forEach(function(item:*, index:int, array:Array):void{
//                    item.gotoAndStop(LABEL_NORMAL);
                });

            initializePos();
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

        public function cardsOn(index:int):void
        {
            for(var i:int = 0; i < _cards.length; i++)
            {
                if (i == index)
                {
                    _cards[i].visible = false;
                }
                else
                {
                    _cards[i].visible = true;
                }
            }
        }

        public function cardsNormal(index:int):void
        {
//                    _cards[index].visible = false;

        }
        public function cardsOver(index:int):void
        {
        }

        public function get cardFrames():Array /* of ElementType */ 
        {
            return _cards;
        }
    }

}

