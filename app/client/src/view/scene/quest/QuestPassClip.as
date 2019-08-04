package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.*;


    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class QuestPassClip extends BaseScene
    {

        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private static const _PASS_X_SET:Vector.<int> = Vector.<int>([80,176,272]);                         // 地形のX位置
        private static const _PASS_Y_SET:Vector.<int> = Vector.<int>([136,216,296,376]);              // 地形のY基本位置

        private static const _Y:int =20
;

        private static const POS_LEFT:int =0;
        private static const POS_CENTER:int =1;
        private static const POS_RIGHT:int =2;

        private static const LEFT_BIT:int = 4; //0b100
        private static const CENTER_BIT:int = 2;// 0b010
        private static const RIGHT_BIT:int = 1;//0b001

        // 自分か出る値をbit0,他人から来る値をBit1,相手に向かう値をBit2
        //                                                          000,001,010,011,100,101,110,111,
        private static const LEFT_TYPE:Vector.<int> = Vector.<int>([000,000,000,002,000,001,003,004]);
        //                                                          000,001,010,011,100,101,110,111,
        private static const RIGHT_TYPE:Vector.<int> = Vector.<int>([000,000,000,002,000,001,003,004]);
        //                                                            0000,0001,0010,0011,0100,0101,0110,0111,1000,1001,1010,1011,1100,1101,1110,1111,
        private static const CENTER_TYPE:Vector.<int> = Vector.<int>([0000,0000,0000,0003,0000,0001,0010,0005,0000,0002,0008,0006,0009,0004,0011,0007]);



        private var _passImage:MapPassImage;

        // 一定数
        private static const _NAME_X:int = 72;
        private static const _NAME_Y:int = 0;

        private var _start:Boolean;
        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [""],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function QuestPassClip(row:int,column:int, l:int = 0, c:int =0, r:int=0)
        {
            x = _PASS_X_SET[row];
            y = _PASS_Y_SET[column]+20;
            _passImage = new MapPassImage(row, judgeType(row,l,c,r));
            addChild(_passImage);

        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
        }

        protected override function get helpTextArray():Array /* of String or Null */ 
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */ 
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {
                initilizeToolTipOwners();
                updateHelp(_QUEST_HELP);
        }

        // 後始末処理
        public override function final():void
        {
        }

        // 道のタイプを判定する。それぞれに続く道が存在するかをチェックしていく
        //
        // #道とビット位置の関係
        //  0        0         0
        //    1    3   1     1
        //  2        2         2
        //

        private function judgeType(row:int,l:int = 0, c:int =0, r:int=0):int
        {
            var ret:int =0;
            var type:int =0;
            switch (row)
            {
            case POS_LEFT:
                // 自分から下に出てるか？
                if (checkLeftOn(l)){ret    |=5};  // 0b101
                // 自分から中央に出てるか？
                if (checkCenterOn(l)){ret  |=3};  // 0b011
                // 自分から右に出てるか？
                if (checkRightOn(l)){ret   |=3};  // 0b011
                // 中央から来てるか
                if (checkLeftOn(c)){ret    |=6};  // 0b110
                // 右から来てるか
                if (checkLeftOn(r)){ret    |=6};  // 0b110
                type = LEFT_TYPE[ret];
                break;
            case POS_CENTER:
                // 自分から下に出てるか？
                if (checkCenterOn(c)){ret  |=5};  // 0b101
                // 自分から左に出てるか？
                if (checkLeftOn(c))  {ret  |=9};  // 0b1001
                // 自分から右に出てるか？
                if (checkRightOn(c)){ret   |=3};  // 0b0011
                // 左から来てるか
                if (checkCenterOn(l)) {ret |=12}; // 0b1100
                // 右から来てるか
                if (checkCenterOn(r)){ret  |=6};  // 0b0110
                // 左から右に向かって来てるか
                if (checkRightOn(l)) {ret |=10};  // 0b1010
                // 右から来てるか
                if (checkLeftOn(r)){ret  |=10};    // 0b1010
                type = CENTER_TYPE[ret];
                break;
            case POS_RIGHT:
                // 自分から下に出てるか？
                if (checkRightOn(r)){ret   |=5}; // 0b101};
                // 自分から中央に出てるか？
                if (checkCenterOn(r)){ret  |=3}; // 0b011};
                // 自分から左に出てるか？
                if (checkLeftOn(r)){ret    |=3}; // 0b010};
                // 中央から来てるか
                if (checkRightOn(c)){ret   |=6}; // 0b110;
                // 左から来てるか 
                if (checkRightOn(l)){ret   |=6}; // 0b110};
                type = RIGHT_TYPE[ret];
                break;
            default:
            }
            return type;
        }

        private function checkLeftOn(i:int):Boolean
        {
            return ((LEFT_BIT&i)!=0)
        }

        private function checkCenterOn(i:int):Boolean
        {
            return ((CENTER_BIT&i) != 0)
        }

        private function checkRightOn(i:int):Boolean
        {
            return ((RIGHT_BIT&i) != 0)
        }
        private function checkOn(i:int):Boolean
        {
            return (i != 0)
        }



    }
}


