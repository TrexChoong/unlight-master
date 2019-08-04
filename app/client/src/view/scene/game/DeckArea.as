package view.scene.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.threads.tweener.TweenerThread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import view.ClousureThread;
    import controller.*;


    /**
     * カードデッキ表示クラス
     *
     */

    public class DeckArea extends BaseScene
    {

        private static const X:int = -38;
        private static const Y:int = 31;
        private static const A:Number = 0.3;
        private static const DECK_X:int = -45;
        private static const DECK_Y:int = -90;
        private static const _DEC_WAIT:Number = 0.33;
        private static const _INC_WAIT:Number = 0.02;
        private static const LABEL_W:int = 163;
        private static const LABEL_H:int = 40;
        private static const LABEL_X:int = 32;
        private static const LABEL_Y:int = 22;

        private var _label:Label = new Label();
        private var _BG:Shape = new Shape();
        private var _deck:Deck;

        private var _num:int = 0;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [""],   // 0
                [""],   // 1
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function DeckArea()
        {
            x = X;
            y  =Y;
            alpha = 0.0;
            visible = false;

//             _BG.graphics.beginFill(0x111111);
//             _BG.graphics.drawRoundRect(10, 0, 95, 88,5);
//             _BG.graphics.endFill();
//             _BG.alpha = A;

            _label.width = LABEL_W;
            _label.height = LABEL_H;
            _label.x = LABEL_X;
            _label.y = LABEL_Y;
            _label.text = "0";
            _label.styleName = "DeckLabel";
            _label.filters = [
//                new GlowFilter(0x000000, 1, 2, 2, 16, 1),
                new DropShadowFilter(1, 45, 0x000000, 1, 2, 2, 4)
                ];

//            addChild(_BG);
            _deck = new Deck();
            _deck.x =DECK_X;
            _deck.y =DECK_Y;
            _deck.filters = [
                new GlowFilter(0x000000, 1, 2, 2, 16, 1),
//              new DropShadowFilter(2, 45, 0x000000, 1, 2, 2, 16)
                ];


            addChild(_label);

            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  //
            _toolTipOwnerArray.push([1,_deck]);  //
        }

        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        public function decrementThread(wait:Number):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            if (_num > 0)
            {
                _num -= 1;
                sExec.addThread(new TweenerThread(_label, {_text:_num.toString(), delay:wait*_DEC_WAIT+0.01} ));
                sExec.addThread(new ClousureThread(_deck.dec));
            }
            return  sExec;
        }

        public function incrementThread(wait:Number):Thread
        {
            _num += 1;
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new TweenerThread(_label, { _text:_num.toString(), delay:wait*_INC_WAIT+0.01} ));
            sExec.addThread(new ClousureThread(_deck.inc));
            return  sExec;
        }

        public function initDeck(num:int):Thread
        {
            // log.writeLog (log.LV_INFO,this,"update decknum",num);
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (num > 0)
            {
                pExec.addThread(SE.getCardSetSEThread((num > 5) ? 5 : num));
            }
            for (var i:int = 0; i < num; i++)
            {
                pExec.addThread(incrementThread(i));
            }
            return pExec;
        }

        public function resetDeck(num:int):Thread
        {
            // log.writeLog (log.LV_INFO,this,"reset decknum",num);
            var sExec:SerialExecutor = new SerialExecutor();
            var prevExec:ParallelExecutor = new ParallelExecutor();

            var i:int;
            var prevNum:int = _num;
            prevExec.addThread(SE.getCardSetSEThread(prevNum));
            for ( i = 0; i < prevNum; i++)
            {
                prevExec.addThread(decrementThread(0));
            }
            sExec.addThread(prevExec);

            var newExec:ParallelExecutor = new ParallelExecutor();
            newExec.addThread(SE.getCardSetSEThread(num));
            for ( i = 0; i < num; i++)
            {
                newExec.addThread(incrementThread(i));
            }
            sExec.addThread(newExec);
            return sExec;
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
//            return new TweenerThread(this, { alpha: 1.0, transition:"easeOutSine", time: 0.5, show:true} );
            return new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
        }

        // 実画面から消去するスレッドを返す
        public function getBringOffThread():Thread
        {
//            return new TweenerThread(this, { alpha: 0.0, transition:"easeOutSine", time: 0.5, hide:true} );
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _label.text = "0";
            _num = 0;
            var sExec:SerialExecutor = new SerialExecutor()
            var plThread:ParallelExecutor = new ParallelExecutor();
            plThread.addThread(super.getShowThread(stage,at));
            plThread.addThread(_deck.getShowThread(this));
            sExec.addThread(plThread);
            var _stage:DisplayObjectContainer = this;
            sExec.addThread(new ClousureThread(function():void{_label.visible = true;}));
            return sExec;
        }

        // 表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            var _stage:DisplayObjectContainer = this;
            var plThread:ParallelExecutor = new ParallelExecutor();
            plThread.addThread(super.getHideThread());
            plThread.addThread(_deck.getHideThread());
            plThread.addThread(new ClousureThread(function():void{_label.visible = false;}));
            alpha = 0;
            return plThread;
        }


    }

}
