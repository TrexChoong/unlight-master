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
    import model.Duel;
    import model.ActionCard;
    import model.events.*;
    import controller.*;
    import view.ClousureThread;
    import view.utils.RemoveChild;

    /**
     * AudienceHand表示クラス
     *
     */

    public class AudienceHand  extends BaseHand
    {
        private  const _X:int = 202;
        private  const _Y:int = 512;

        private static const _SPACING:int = 60; // カードが配られる時の間隔
        // private  const _SPACING:int = 20;
        private  const _TABLE_SPACING:int = -60;

        private static const _DIST_FOE_X:int = 650; // カードが相手に渡される目標点.X（Global
        private static const _DIST_FOE_Y:int = -40; // カードが相手に渡される目標点.Y（Global）

        private static const _HAND_WIDTH:int = 560;   // 手札の並びの最大幅
        private static const _HAND_HEIGHT:int = 95;   // 手札の並びの最大高さ

        private static const _DROP_WIDTH:int = 560;   // 置いた並びの最大幅
        private static const _DROP_HEIGHT:int = 95;   // 置いた並びの最大高さ

        private var distFoeP:Point;              // カードが渡される目標点（local）

        private var playedCards:int = 0;

        private var opened:Boolean = false;

        private var _updateTimer:Timer;                                 // ハートビート用のタイマー
        private var _updateFlag:Boolean =false;                                 // ハートビート用のタイマー

        /**
         * コンストラクタ
         *
         */
        public function AudienceHand(dropTable:DropTable, entrant:Entrant)
        {
            // サーバから見てコネクションが生きているかを確認するためのソケットKeepAliveTimer
            _updateTimer = new Timer(1000,0)
            super(dropTable, entrant);
            distFoeP = globalToLocal(new Point(_DIST_FOE_X, _DIST_FOE_Y));
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
            return globalToLocal(DropTable.PL_CARD_PT);
        }

        protected override  function get defFlip():Boolean
        {
            return true;
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
            return 1;
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
            log.writeLog(log.LV_DEBUG, this, "### setEntrant.");
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
            log.writeLog(log.LV_DEBUG, this, "### addHandler.");
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
//            log.writeLog(log.LV_FATAL, this, "************************card OPEN!!!", e.ACArray,e.DirArray);
            var b:Boolean;
            var aca:Array = e.ACArray.slice();
            var da:Array = e.DirArray.slice();

            for each (var acc:ActionCardClip in tableArray)
                     {
                         if (acc) {
                             if (e.Locked) {
                                 acc.setLarge(true);
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
            // log.writeLog(log.LV_FATAL, this, "get OpenTable cards thread", tableArray);

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
                    _dropPExec.addThread(new BeTweenAS3Thread(tableArray[i], {x:getDropX(i),y:getDropY(i) ,scaleX:dropCardsScale() ,scaleY:dropCardsScale()}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
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
            var w:Number = wait * 0.01 + 0.01; // wait0がだとスレッドが終わらない
            var fromOpPosition:Point;
            acArray.push(acc);
            fromOpPosition = globalToLocal(new Point(positionX, positionY));
//            log.writeLog(log.LV_FATAL, this, "STEAL DEAL globbal X:",positionX," Y:",positionY);

            acc.setDealStartPoint(fromOpPosition.x, fromOpPosition.y, defFlip, 1.0, true );


            addChild(acc);
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new DealThread(acc, registHandlers, w, getHandX(acArray.length-1),getHandY(acArray.length-1), handCardsScale(),0.1,0.01));
//            sExec.addThread(new DealThread(acc, registHandlers, w, acArray.length-1, spacing*align));
            sExec.addThread(updateHandMove());
            return sExec;
        }

        // 手札上のカードをその場で消す
        public override function getVanishHandCardsThread(ac:Array):Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var len:int  = acArray.length;
            var aca:Array = acArray.slice(); /* of ActioCardClip */ 

            // 表にしないので、後ろから順に枚数分消す
            for (var i:int = 0; i < ac.length ; i++) 
            {
                pExec.addThread(getVanishACThread(aca[len-1-i], i+1));
                removeFromHandArray(aca[len-1-i]);
            }
            return pExec;
        }


        // 相手側に向かっでカードを消す
        public override function getVanishACThread(acc:ActionCardClip, wait:Number):Thread
        {
//            return new TweenerThread (acc, { x:distFoeP.x, y:distFoeP.y, delay:0.2, scaleX:0.8, scaleY:0.8, transition:"easeOutQuart", time: 0.5, hide: true} );
            disposeHandlers(acc);
            return new BeTweenAS3Thread(acc, {x:distFoeP.x ,y:distFoeP.y ,scaleX:0.8 ,scaleY:0.8}, null, 0.5, BeTweenAS3Thread.EASE_OUT_QUART ,0.2 ,false );
        }



    }

}

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.scene.game.DropTable;
import view.scene.game.ActionCardClip;
import controller.*;


class DealThread extends Thread
{

    private  var  _movedDelay:Number = 0.1;
    private  var _moveTime:Number = 0.3;


    private var _acc:ActionCardClip;

    private var _handler:Function;

    private var _wait:Number;
    private var _x:int;
    private var _y:int;
    private var _scale:Number;

    // コンストラクタ
    public function DealThread(acc:ActionCardClip, hr:Function, wait:Number, xPosition:int, yPosition:int, scale:Number, moveTime:Number = 0.3,movedDelay :Number= 0.1)
    {
        log.writeLog(log.LV_INFO, this, "moveTime",moveTime,"movedDelay",movedDelay,wait);
        _acc = acc;
        _handler = hr;
        _wait = wait+0.01;
        _moveTime = moveTime;
        _movedDelay = movedDelay;

        _x = xPosition;
        _y = yPosition;
        _scale = scale;

    }

    override protected function run ():void
    {
        if (_acc.loaded())
        {
            next(deal)
        }
        else
        {
            next(run);
        }
    }
    private function deal():void
    {
        var cardAlphaTween:Thread = new BeTweenAS3Thread(_acc, {alpha:1.0}, null, _movedDelay, BeTweenAS3Thread.EASE_OUT_SINE ,_wait ,true );
        var cardMoveTween:Thread = new BeTweenAS3Thread(_acc, {x:_x ,y:_y ,scaleX:_scale ,scaleY:_scale}, null, _moveTime, BeTweenAS3Thread.EASE_OUT_SINE ,_wait ,true );
        var pExec:ParallelExecutor = new ParallelExecutor();
        pExec.addThread(SE.getThrowCardSEThread(_wait*0.9));
        pExec.addThread(cardMoveTween);
        pExec.addThread(cardAlphaTween);
        pExec.start();
        pExec.join();
        next(addEvent);
    }

    private function addEvent():void
    {
        _handler(_acc);
    }

    // 終了関数
    override protected  function finalize():void
    {
        _handler = null;
        _acc = null;
    }


}

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
                if (_accArray[count].locked)
                {
                    SE.playCardSetTable();
                }
                else
                {
                    SE.playOpenActionCard();
                }
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
                             pExec.addThread(new BeTweenAS3Thread(item, {y:_beforeY-_HIDE_Y}, null, 0.2, BeTweenAS3Thread.EASE_OUT_EXPO));
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
                             pExec.addThread(new BeTweenAS3Thread(item, {y:_beforeY+_HIDE_Y}, null, 0.2, BeTweenAS3Thread.EASE_OUT_EXPO));
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
