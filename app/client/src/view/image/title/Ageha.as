package view.image.title
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * HP表示クラス
     *
     */


    public class Ageha extends BaseImage
    {

        // HP表示元SWF
        [Embed(source="../../../../data/image/ageha.swf")]
        private var _Source:Class;
        private static const SCALE:Number = 0.9;
        private static const X:int = 513;
        private static const Y:int = -200;

        /**
         * コンストラクタ
         *
         */
        public function Ageha()
        {
            super();
        }

        override protected function swfinit(event: Event): void 
        {
            super.swfinit(event);
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
        }


        // アゲハチョウを追う
        public function mouseOverHandler(e:Event):void
        {
            if (x>(root.mouseX-24+Math.round(48*Math.random())))
            {
                x-=5;
            } else {
                x+=3;
            }

            if (y>(root.mouseY-24+Math.round(48*Math.random())))
            {
                y-=5;
            } else {
                y+=3;
            };


        }

    }

}
