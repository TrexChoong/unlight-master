package view.image.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.ColorTransform;

    import view.image.BaseImage;

    /**
     * ドロップテーブル数字クラス
     *
     */


    public class DropTableNum extends BaseImage
    {

        // ドロップテーブル数字表示元SWF
        [Embed(source="../../../../data/image/game/num_btl_p.swf")]
        private var _Source:Class;
        private static const X:int = 0;
        private static const Y:int = 0;


        private static const WIDTH:int = 40;
        private var _num:int = 0;
        private var _pos:int = 0;
        private var _digit:int = 1;
        private var _center:int = 0;
        private var _enemy:Boolean = false;


        /**
         * コンストラクタ
         *
         */
        public function DropTableNum(center:int,enemy:Boolean = false)
        {
            super();
            if (enemy)
            {
                var transform1:ColorTransform = new ColorTransform( -1, -1, -1, 1, 255, 255, 255, 0);
                this.transform.colorTransform = transform1;
            }
            _enemy = enemy;
            _center = center;

        }

        // 桁分の数字クリップをもらって正しい位置に数字を出す
        public static function setNumber(numArray:Array /* of DropTableNum */,number:int ):void
        {
            var digit:int = 1;
            if (number < 10)
            {
                digit = 1;
            }else if (number < 100)
            {
                digit = 2;
            }else if (number < 1000)
            {
                digit = 3;
            }else if (number < 10000)
            {
                digit = 4;
            }
//            digit = Math.log(number)*LN10
            var num:int = number;
            for(var i:int = 0; i < numArray.length; i++)
            {
                if (i < digit)
                {
                    numArray[i].onNum(num%10,i+1,digit);
                    num = num/10;
                    numArray[i].visible = true;
                }else {
                    numArray[i].visible = false;
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


        // 桁とポジションをもらって再配置
        public function onNum(num:int, pos:int, digit:int):void
        {
            _pos = pos;
            _digit = digit;
            if (num < 10)
            {
                _num = num;
                waitComplete(setNum);
            }
        }

        private function setNum():void
        {
            // 終点を中心から計算して現在のポジションを決定する
            x = (_center + WIDTH/2*_digit)-_pos*WIDTH;
            // 3桁以上の場合ははみ出るので中寄せにする]
            if (_digit > 2) {
                var reverse:int = -1;
                if (_enemy){
                    reverse = 1;
                }
                x += ( (_digit - 2) * WIDTH/2 ) * reverse;
            }
            _root.gotoAndStop(_num+1);
        }



    }

}


