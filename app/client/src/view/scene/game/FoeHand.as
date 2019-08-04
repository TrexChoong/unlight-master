package view.scene.game
{
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.events.*;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import org.libspark.thread.Thread;
    import org.libspark.thread.ThreadState;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Entrant;
    import model.ActionCard;
    import model.Duel;
    import model.events.*;
    import controller.*;
    import view.ClousureThread;
    import view.utils.RemoveChild;

    /**
     * FoeHand表示クラス
     *
     */

    public class FoeHand  extends BaseHand
    {
        private  const _X:int = 730;
        private  const _Y:int = -6;

        private  const _SPACING:int = 20;
        private  const _TABLE_SPACING:int = -60;

        private static const _HAND_WIDTH:int = 460;   // 手札の並びの最大幅
        private static const _HAND_HEIGHT:int = 55;   // 手札の並びの最大高さ

        private static const _DROP_WIDTH:int = 420;   // 置いた並びの最大幅
        private static const _DROP_HEIGHT:int = 55;   // 置いた並びの最大高さ

        private var playedCards:int = 0;

        private var opened:Boolean = false;

        private var _updateTimer:Timer;                                 // ハートビート用のタイマー
        private var _updateFlag:Boolean =false;                                 // ハートビート用のタイマー

        /**
         * コンストラクタ
         *
         */
        public function FoeHand(dropTable:DropTable, entrant:Entrant)
        {
            // サーバから見てコネクションが生きているかを確認するためのソケットKeepAliveTimer
            _updateTimer = new Timer(1000,0)
            super(dropTable, entrant);
        }

        protected override function get startX():int
        {
            return _X;
        }

        protected override function get startY():int
        {
            return _Y;
        }

        protected override function get spacing():int
        {
            return _SPACING;
        }

        protected function get tableSpacing():int
        {
            return _TABLE_SPACING;
        }

        protected override function get dropPoint():Point
        {
            return globalToLocal(DropTable.FE_CARD_PT);
        }

        protected override  function get defFlip():Boolean
        {
            return false;
        }


        protected override function get handWidth():int
        {
            return _HAND_WIDTH;
        }

        protected override function get handHeight():int
        {
            return _HAND_HEIGHT;
        }

        protected override function get dropWidth():int
        {
            return _DROP_WIDTH;
        }

        protected override function get dropHeight():int
        {
            return _DROP_HEIGHT;
        }
        protected override function get align ():int
        {
            return -1;
        }

        public override function dropCardsScale():Number
        {
            return 1.0;
        }


        public override function init():void
        {
            super.init();
//             _updateTimer.addEventListener(TimerEvent.TIMER, updateHandler);
//             _updateTimer.start();
        }
        public override function final():void
        {
            super.final();

            _entrant.removeEventListener(ReplaceCardEvent.ADD_MOVE_TABLE,addHandler);
            _entrant.removeEventListener(ReplaceCardEvent.REMOVE_MOVE_TABLE,removeHandler);
            _entrant.removeEventListener(OpenTableCardsEvent.OPEN_MOVE_CARDS,openCardsHandler);

            _entrant.removeEventListener(ReplaceCardEvent.ROTATE,rotateHandler);

            _entrant.removeEventListener(ReplaceCardEvent.ADD_BATTLE_TABLE,addHandler)
            _entrant.removeEventListener(ReplaceCardEvent.REMOVE_BATTLE_TABLE,removeHandler)

            _entrant.removeEventListener(OpenTableCardsEvent.OPEN_BATTLE_CARDS,openCardsHandler);
            _entrant.removeEventListener(OpenTableCardsEvent.OPEN_EVENT_CARDS,openEventCardsHandler);
            _entrant.removeEventListener(OpenTableCardsEvent.OPEN_DISCARD_CARDS,openDiscardCardsHandler);
            _entrant.removeEventListener(OpenTableCardsEvent.CLOSE_DISCARD_CARDS,closeDiscardCardsHandler);
//             _updateTimer.removeEventListener(TimerEvent.TIMER, updateHandler);

        }

        protected override function setEntrant(entrant:Entrant):void
        {
            _entrant = entrant;
            _entrant.addEventListener(ReplaceCardEvent.ADD_MOVE_TABLE,addHandler);
            _entrant.addEventListener(ReplaceCardEvent.REMOVE_MOVE_TABLE,removeHandler);
            _entrant.addEventListener(OpenTableCardsEvent.OPEN_MOVE_CARDS,openCardsHandler);

            _entrant.addEventListener(ReplaceCardEvent.ROTATE,rotateHandler);

            _entrant.addEventListener(ReplaceCardEvent.ADD_BATTLE_TABLE,addHandler)
            _entrant.addEventListener(ReplaceCardEvent.REMOVE_BATTLE_TABLE,removeHandler)

            _entrant.addEventListener(OpenTableCardsEvent.OPEN_BATTLE_CARDS,openCardsHandler);
            _entrant.addEventListener(OpenTableCardsEvent.OPEN_EVENT_CARDS,openEventCardsHandler);
            _entrant.addEventListener(OpenTableCardsEvent.OPEN_DISCARD_CARDS,openDiscardCardsHandler);
            _entrant.addEventListener(OpenTableCardsEvent.CLOSE_DISCARD_CARDS,closeDiscardCardsHandler);


        }

        private function addHandler (e:ReplaceCardEvent):void
        {
            swapActionCard(acArray[0], acArray, tableArray);
//             var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.addThread(SE.getThrowCardSEThread(0));
//             pExec.addThread(updateDropCardMove());
//             pExec.addThread(updateHandMove());
//             GameCtrl.instance.addViewSequence(pExec);
            
//             swapActionCard(acArray[e.index], acArray, tableArray);
// //            GameCtrl.instance.addViewSequence(new ClousureThread(swapActionCard, [acArray[e.index], acArray, tableArray]));
//             _updateFlag = true;

//            GameCtrl.instance.addViewSequence(new ClousureThread(updateHandAll));
//              var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.addThread(SE.getThrowCardSEThread(0));
//             pExec.addThread(updateDropCardMove());
//             pExec.addThread(updateHandMove());
//             GameCtrl.instance.addViewSequence(pExec);

             updateDropCardMove().start();
             updateHandMove().start();
        }

        private function removeHandler (e:ReplaceCardEvent):void
        {
            swapActionCard(tableArray[0], tableArray, acArray);
//             var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.addThread(SE.getThrowCardSEThread(0));
//             pExec.addThread(updateDropCardMove());
//             pExec.addThread(updateHandMove());
//             GameCtrl.instance.addViewSequence(pExec);

// //            log.writeLog(log.LV_FATAL, this, "!!!!!!!!!!, REMOVE !!!!!!!!!!!!!!!!!!");
//             swapActionCard(tableArray[e.index], tableArray, acArray);
// //             GameCtrl.instance.addViewSequence(new ClousureThread(swapActionCard, [tableArray[e.index], tableArray, acArray]));
//             _updateFlag = true;

//            GameCtrl.instance.addViewSequence(new ClousureThread(updateHandAll));
//             var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.addThread(SE.getThrowCardSEThread(0));
//             pExec.addThread(updateDropCardMove());
//             pExec.addThread(updateHandMove());
//             GameCtrl.instance.addViewSequence(pExec);

             updateDropCardMove().start();
             updateHandMove().start();
        }

        private function updateHandAll():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(SE.getThrowCardSEThread(0));
            pExec.addThread(updateDropCardMove());
            pExec.addThread(updateHandMove());
//            GameCtrl.instance.addViewSequence(
            pExec.start();

//             var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.addThread(SE.getThrowCardSEThread(0));
//             pExec.addThread(updateDropCardMove());
//             pExec.addThread(updateHandMove());
//             GameCtrl.instance.addViewSequence(pExec);

        }

        // ハートビート信号のハンドラ
        private function updateHandler(event:Event):void
        {
            //
             if (_updateFlag)
             {
                updateHandAll();
                _updateFlag = false;
             }
        }


        private function rotateHandler (e:ReplaceCardEvent):void
        {
            if (e.table == Entrant.TABLE_HAND)
            {
                if (acArray[e.index]) {
                    acArray[e.index].forceRotateTween();
                }
            }else{
                if (tableArray[e.index]) {
                    tableArray[e.index].forceRotateTween();
                }
            }

        }


        // Entrantのオープンイベントを聞いて相手の手札を差し替える
        private function openCardsHandler (e:OpenTableCardsEvent):void
        {
//            log.writeLog(log.LV_FATAL, this, "card OPEN!!!", e.ACArray,e.DirArray);
            var b:Boolean;
            var aca:Array = e.ACArray.slice();
            var da:Array = e.DirArray.slice();
            var locked:Boolean = e.Locked;

            for each (var acc:ActionCardClip in tableArray)
                     {
                         if (acc) {
                             // クライアント更新で解決するための、臨時的な措置
                             if (locked) {
                                 acc.lockCard();
                             }
                             else
                             {
                                 if (da.length > 0)
                                 {
                                     acc.foeRotate(da.shift());
                                 }

                                 acc.updateCardInfo(aca.shift());

                                 if (Duel.instance.hasOverrideActionCard(acc.cardID.toString()))
                                 {
                                     var val:Object = Duel.instance.getOverrideActionCardValues(acc.cardID.toString());
                                     acc.updateCardValue(val["u_value"], val["b_value"] );
                                 }
                             }
                         }
                     }
        }

        protected function openEventCardsHandler (e:OpenTableCardsEvent):void
        {
//            log.writeLog(log.LV_FATAL, this, "Event Card OPEN!!!", e.ACArray,e.DirArray);
            var b:Boolean;
            var aca:Array = e.ACArray.slice();
            var da:Array = e.DirArray.slice();

            tableArray[tableArray.length-1].foeRotate(da.shift());
            tableArray[tableArray.length-1].updateCardInfo(aca.shift());
            GameCtrl.instance.addViewSequence(getOpenEventCardThread());
        }

        protected function openDiscardCardsHandler (e:OpenTableCardsEvent):void
        {
//            log.writeLog(log.LV_FATAL, this, "Event Card OPEN!!!", e.ACArray,e.DirArray);
            var b:Boolean;
            var aca:Array = e.ACArray.slice();
            var da:Array = e.DirArray.slice();

            acArray[acArray.length-1].foeRotate(da.shift());
            acArray[acArray.length-1].updateCardInfo(aca.shift());
            GameCtrl.instance.addViewSequence(getOpenDiscardCardThread());
//            log.writeLog(log.LV_FATAL, this, "open discard", e);
        }

        private function closeDiscardCardsHandler(e:OpenTableCardsEvent):void
        {
//            log.writeLog(log.LV_FATAL, this, "Event Card CLOSE!!!", e.ACArray,e.DirArray);
            var b:Boolean;
            var aca:Array = e.ACArray.slice();
            var da:Array = e.DirArray.slice();

            RemoveChild.apply(acArray[acArray.length-1]);
            acArray.pop();
        }



        protected override function mouseOverHandler(e:MouseEvent):void
        {

        }

        protected override function mouseRemoveHandler(e:MouseEvent):void
        {
       }

        public function getOpenTableCardsThread():Thread
        {
            var accArray:Array = tableArray.slice();
            var pExec:ParallelExecutor = new ParallelExecutor();
            _dropPExec = null;
            pExec.addThread(updateOpenDropCardMove());
//            log.writeLog(log.LV_FATAL, this, "get OpenTable cards thread", tableArray);

            pExec.addThread(new OpenTableCardsThread(accArray));
            return pExec;
        }

        public function getOpenEventCardThread():Thread
        {
            return new OpenTableCardsThread(tableArray.slice(-1));
        }

        public function getOpenDiscardCardThread():Thread
        {
            return new OpenTableCardsThread(acArray.slice(-1));
        }


        // オープン時ドロップテーブルの再配置
        protected function updateOpenDropCardMove():Thread
        {

            var startX:int = dropPoint.x - ((tableArray.length/2-0.5)*tableSpacing*dropCardsScale());

            if(_dropPExec == null || _dropPExec.state == ThreadState.TERMINATED)
            {
                _dropPExec = new ParallelExecutor();
                for(var i:int = 0; i < tableArray.length; i++)
                {
                    // ドロップされたカードの描画順位を変更する（最初に配られたものが最前面）
                    setChildIndex(tableArray[i],(numChildren-1-i));
//                    _dropPExec.addThread(new TweenerThread(tableArray[i], {x:startX + i * tableSpacing * dropCardsScale(), y:dropPoint.y, scaleX:dropCardsScale(), scaleY:dropCardsScale(), transition:"easeOutSine", time: 0.2, show: true}));
                    _dropPExec.addThread(new BeTweenAS3Thread(tableArray[i], {x:startX+i*tableSpacing*dropCardsScale() ,y:dropPoint.y ,scaleX:dropCardsScale() ,scaleY:dropCardsScale()}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                }
                return _dropPExec;
            }
            else
            {
                return new Thread();
            }
        }

        // 相手からカードを手元に追加する
        public override function getAddACFromStealThread(acc:ActionCardClip, wait:Number, positionX:int, positionY:int):Thread
        {
            var fromOpPosition:Point;
            acArray.push(acc);
            fromOpPosition = globalToLocal(new Point(positionX, positionY));
//            log.writeLog(log.LV_FATAL, this, "STEAL DEAL globbal X:",positionX," Y:",positionY);
            acc.setDealStartPoint(0, -100, defFlip, 1.0, true );
            addChild(acc);
            var sExec:SerialExecutor = new SerialExecutor();
//            sExec.addThread(getDealThread(acc, registHandlers, 0, acArray.length-1, spacing));
            sExec.addThread(getDealThread(acc, registHandlers, 0, getHandX(acArray.length-1), getHandY(acArray.length-1), handCardsScale(),0.1,0.01));
            sExec.addThread(updateHandMove());
            return sExec;
        }



    }

}

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;
import model.Duel;
import view.scene.game.DropTable;

// テーブルのカードをオープンするスレッド
class OpenTableCardsThread extends Thread
{
    private var _accArray:Array;
    private var count:int = 0;
    private static const _WAIT:int = 100; // ms
    private static const _LAST_WAIT:int = 300; // ms

    public function OpenTableCardsThread(accArray:Array)
    {
        _accArray = accArray;
    }

    protected override function run():void
    {
        next(openCard);
    }

    private function openCard():void
    {
        if (count == _accArray.length)
        {
            next(waitEnd);
        }
        else
        {
//            log.writeLog(log.LV_FATAL, this, "flip before ");
//            log.writeLog(log.LV_FATAL, this, "acc id ", _accArray[count].ac.id);
            if (_accArray[count].flip != true)
            {
                if (_accArray[count].locked )
                {
                    SE.playCardSetTable();
                }
                else
                {
                    SE.playOpenActionCard();
                }
                _accArray[count].parent.addChild(_accArray[count]);
                _accArray[count].flip = true;
                sleep(_WAIT);
            }
            count +=1;
            next(openCard);
        }
    }

    private function waitEnd():void
    {
        sleep(_LAST_WAIT);
        next(end);
    }

    private function end():void
    {
    }


}

// 手札を一度引っ込めるスレッド
class HideOnceHandCardsThread extends Thread
{
    private var _accArray:Array;
    private var count:int = 0;
    private static const _HIDE_Y:int = 130; // ms
    private static const _WAIT:int = 1000; // ms
    private static const _LAST_WAIT:int = 500; // ms
    private var _beforeY:int; 

    public function HideOnceHandCardsThread(accArray:Array) /* of ActionCardClip */ 
    {
        _accArray = accArray;
    }

    protected override function run():void
    {
        next(hideHand);
    }

    private function hideHand():void
    {
        var pExec:ParallelExecutor = new ParallelExecutor();

        _accArray.forEach(function(item:*, index:int, array:Array):void
                         {
                             _beforeY = item.y
//                             pExec.addThread(new TweenerThread (item, {y:_beforeY-_HIDE_Y, transition:"easeOutExpo", time: 0.2}));
                             pExec.addThread(new BeTweenAS3Thread(item, {y:_beforeY-_HIDE_Y}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_EXPO));
                         });
        pExec.join();
        pExec.start();
        next(dealWait);
    }

    private function dealWait():void
    {
        sleep(_WAIT);
        next(showHand);
    }

    private function showHand():void
    {
        var pExec:ParallelExecutor = new ParallelExecutor();

        _accArray.forEach(function(item:*, index:int, array:Array):void
                         {
                             _beforeY = item.y
//                             pExec.addThread(new TweenerThread (item, {y:_beforeY+_HIDE_Y, transition:"easeOutExpo", time: 0.2}));
                             pExec.addThread(new BeTweenAS3Thread(item, {y:_beforeY+_HIDE_Y}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_EXPO));
                         });
        pExec.join();
        pExec.start();
        next(dealWait);
    }

    private function waitEnd():void
    {
        sleep(_LAST_WAIT);
        next(end);
    }

    private function end():void
    {
    }


}
