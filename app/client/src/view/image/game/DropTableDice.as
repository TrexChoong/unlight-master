package view.image.game
{

    import flash.display.*;
    import flash.events.Event;

    import view.image.BaseImage;

    /**
     * ドロップテーブルダイスクラス
     *
     */


    public class DropTableDice extends BaseImage
    {

        // ドロップテーブル数字表示元SWF
        [Embed(source="../../../../data/image/dice_p.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        public static const ATK:int = 1;
        private static const ATK_S:int = 2;

        public static const DEF:int = 3;
        private static const DEF_S:int = 4;

        private static const S_WIDTH:int = 16;
        private static const B_WIDTH:int = 27;
        private static const HEIGHT:int = 28;

        private var _type:int;


        private var _num:int = 0;
        private var _pos:int = 0;
        private var _digit:int = 1;
        private var _center:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function DropTableDice()
        {
            super();
        }

        public static function getDiceTable(x:int, y:int, container:Sprite):Array /* of DropTableDice */ 
        {

            var retArray:Array = []; /* of DropTableDice */

            for(var i:int = 0; i < 9; i++)
            {
                retArray.push(new DropTableDice());
                retArray[i].x = x+i*S_WIDTH;
                retArray[i].y = y+HEIGHT;
                retArray[i].visible = false;
                container.addChild(retArray[i]);
            }

            for(var j:int = 0; j < 5; j++)
            {
                retArray.push(new DropTableDice());
                retArray[i+j].x = x+j*B_WIDTH;
                retArray[i+j].y = y
                retArray[i].visible = false;
                container.addChild(retArray[i+j]);
            }
            return retArray;
        }


        // ダイスのArrayをもらって正しくONOFFする
        public static function setNumber(diceArray:Array /* of DropTableDice */,number:int, type:int):void
        {
            var num:int = number;
            var digit:int = 2;
            var smallNum:int = num%10;
            var bigNum:int = num/10%10;

            for(var i:int = 0; i < 9; i++)
            {
                if (i<smallNum)
                {
                    diceArray[i].onType(type+1);
                    diceArray[i].visible = true;
                }else{
                    diceArray[i].visible = false;
                }

            }

            for(var j:int = 0; j < 5; j++)
            {
                if (j<bigNum)
                {
                    diceArray[i+j].onType(type);
                    diceArray[i+j].visible = true;
                }else{
                    diceArray[i+j].visible = false;
                }

            }

        }


        override protected function swfinit(event: Event): void 
        {

            super.swfinit(event);
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        private function onType(type:int):void
        {
            _type = type;
            waitComplete(setType);
        }

        private function setType():void
        {
            _root.gotoAndStop(_type);
        }



    }

}

