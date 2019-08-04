package view.scene.game
{
    // TODO:表示とシーンのスレッドをわける。いまはParal

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.*;
    import mx.managers.DragManager;

    import org.libspark.thread.Thread;
    import org.libspark.thread.ThreadState;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.ActionCard;
    import model.Entrant;
    import model.Duel;
    import model.events.*;
    import view.image.game.*;
    import view.scene.BaseScene;
    import view.SleepThread;
    import view.ClousureThread;
    import controller.*;

    /**
     * BaseHand表示クラス
     *
     */

    public class BaseHand  extends BaseScene
    {
        protected static var lastDealPoint:Point;

        private static const _X:int = 0;              // 手札の位置（オーバーライド前提）
        private static const _Y:int = 0;              // 手札の位置（オーバーライド前提）
        private static const _FROM_X:int = 40;       // カードが配られる出発点.X（Global
        private static const _FROM_Y:int = 105;       // カードが配られる出発点.Y（Global）
        private static const _SPACING:int = 40;       // カードが配られる時の間隔(Override済み)
        private static const _DIST_X:int = 40;        // カードが捨てられる目標点.X（Global
        private static const _DIST_Y:int = 105;       // カードが捨てられ目標点.Y（Global）

        private static const _SCALE_MIN:Number = 0.68;       // カードの縮小率の最小値
        private static const _SCALE_MAX:Number = 1.0;       // カードの縮小率の最大値

        private static const _DROP_SCALE_MIN:Number = 0.7;       // カードの縮小率の最小値
        private static const _DROP_SCALE_MAX:Number = 1.0;       // カードの縮小率の最大値

        public static const _MOVED_CARDS_DELAY:Number = 0.3; // カードが配られる時のタメ
        private static const _WIPE_CARDS_DELAY:Number = 0.04; // カードが配られる時のタメ


        protected var fromP:Point;              // カードが配られる出発点（local）
        protected var distP:Point;              // カードが捨てられる目標点（local）

        protected var acArray:Array = [];       // 手札の配列
        protected var tableArray:Array = [];    // ドロップテーブルに出したカードの配列
        protected var overIndex:int;            // 移動中のカードのインデックス

        protected var dropTable:DropTable;

        protected var _dropPExec:ParallelExecutor;
        private var _handPExec:ParallelExecutor;

        protected var _entrant:Entrant;

        protected var _dragEnable:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function BaseHand(d:DropTable, entrant:Entrant)
        {
            x = startX;
            y = startY;
            fromP = globalToLocal(new Point(_FROM_X, _FROM_Y));
            distP = globalToLocal(new Point(_DIST_X, _DIST_Y));
            dropTable = d;
            setEntrant(entrant);
        }

        protected function setEntrant(entrant:Entrant):void
        {
            _entrant = entrant;
        }


        public override function final():void
        {
            dropTable = null;
            acArray.forEach(function(item:ActionCardClip, index:int, array:Array):void{item.final();
                    disposeHandlers(item)});
            tableArray.forEach(function(item:ActionCardClip, index:int, array:Array):void{item.final(); disposeHandlers(item)});

            acArray.splice(-1);
            tableArray.splice(-1);
            acArray.length = 0;
            tableArray.length = 0;
            ActionCardClip.clearCache();
//             dropTable = null;
        }

        protected  function get startX():int
        {
            return _X;
        }

        protected  function get startY():int
        {
            return _Y;
        }

        public function get endX():int
        {
            return startX + spacing * acArray.length*align;
//            return getHandX(acArray.length-1);
        }

        public function get endY():int
        {
//            return getHandY(acArray.length-1);
            return startY;
        }

        protected  function get fromX():int
        {
            return fromP.x;
        }

        protected  function get fromY():int
        {
            return fromP.y;
        }
        protected  function get distX():int
        {
            return distP.x;
        }

        protected  function get distY():int
        {
            return distP.y;
        }

        protected  function get defFlip():Boolean
        {
            return true;
        }

        protected function get spacing():int
        {
            return _SPACING;
        }

        protected function get dropPoint():Point
        {
            return null;
        }

        protected function get handWidth():int
        {
            return 0;
        }

        protected function get handHeight():int
        {
            return 0;
        }

        protected function get dropWidth():int
        {
            return 0;
        }

        protected function get dropHeight():int
        {
            return 0;
        }

        protected function get align ():int
        {
            return 1;
        }

        public function dragOn():void
        {
            _dragEnable = true;
        }

        public function dragOff():void
        {
            _dragEnable = false;
        }

        // ===========================================
        //    手札用関数
        // ===========================================

        // 手札の拡大関数
        public function handCardsScale():Number
        {
            return  getScale(handWidth, spacing, acArray.length, _SCALE_MIN, _SCALE_MAX);
        }


        // 手札の現在のインデックスによる桁判定
        public function handCardRaw(i:int):int
        {
            return  getCardsRaw(handWidth, spacing, i, _SCALE_MIN);
        };

        // 手札の現在のインデックスによる列判定
        public function handCardCollumn(i:int):int
        {
            return  getCardsCollumn(handWidth, spacing, i, _SCALE_MIN);
        };

        // 現在の特定インデックスの手札のX位置を返す
        protected function getHandX(i:int):int
        {
            return handCardCollumn(i) * spacing * handCardsScale()*align;
        }

        // 現在の特定インデックスの手札のY位置を返す
        protected function getHandY(i:int):int 
       {
            var startY:int = (handCardRaw(acArray.length)-1)*handHeight/2*_SCALE_MIN*-1;
            return startY + (handCardRaw(i)-1)*handHeight*_SCALE_MIN;
        }


        // ===========================================
        //    ドロップカード用関数
        // ===========================================

        // ドロップテーブルの拡大関数
        public function dropCardsScale():Number
        {
            return  getScale(dropWidth, spacing, tableArray.length, _DROP_SCALE_MIN, _DROP_SCALE_MAX);
        }

        // ドロップテーブルの現在のインデックスによる桁判定
        public function dropCardRaw(i:int):int
        {
            return  getCardsRaw(dropWidth, spacing, i, _DROP_SCALE_MIN);
        };

        // ドロップの現在のインデックスによる列判定
        public function dropCardCollumn(i:int):int
        {
            return  getCardsCollumn(dropWidth, spacing, i, _DROP_SCALE_MIN);
        };

        // インデックスから現在行の枚数を返す
        public function dropCollumnNum(i:int):int
        {
            var maxNum:int = Math.ceil(dropWidth/spacing/_DROP_SCALE_MIN);
            if (i<Math.floor(tableArray.length/maxNum)*maxNum)
            {
            return maxNum;
            }else{
            return tableArray.length%maxNum;
            }
        }

        // 現在の特定インデックスのテーブルのX位置を返す
        protected function getDropX(i:int):int
        {
            // 中心から
            var startX:int = dropPoint.x - ((dropCollumnNum(i))-1)*spacing/2*align*dropCardsScale();

            return startX +(dropCardCollumn(i) * spacing * dropCardsScale()*align) ;
        }

        // 現在の特定インデックスのテーブルのY位置を返す
        protected function getDropY(i:int):int
       {
//            var startY:int =  + (dropCardRaw(tableArray.length)-1)*dropHeight/2*_SCALE_MIN*-1;
            return dropPoint.y + (dropCardRaw(i)-1)*dropHeight*_DROP_SCALE_MIN;
        }


        // ===========================================
        //    汎用カード用関数
        // ===========================================

        // カードの桁数計算
        private function getCardsRaw(bWidth:int, cWidth:int, num:int, scale_min:Number):int
        {
            return int(Math.ceil(cWidth/bWidth*scale_min*num+0.0001));
        }

        // カードの列数計算
        private function getCardsCollumn(bWidth:int, cWidth:int, num:int, scale_min:Number):int
        {
            return num % Math.ceil(bWidth/cWidth/scale_min);
        }

        // カードの縮小率計算
        private function getScale(bWidth:int, cWidth:int, num:int, scale_min:Number, scale_max:Number):Number
        {
            var scale:Number;
            scale = bWidth/num/cWidth;
            // 縮小率が最小値より小さければ最小値,1より大きければ１
            if (scale > scale_max)
            {
                scale = scale_max;
            }else if(scale < scale_min)
            {
                scale = scale_min;
            }
            return scale;
        }


        // カードを手元に追加する
        public function getAddACThread(acc:ActionCardClip, wait:Number):Thread
        {
            var w:Number = wait * _MOVED_CARDS_DELAY + 0.01; // wait0がだとスレッドが終わらない
            acArray.push(acc);
            acc.setDealStartPoint(fromX, fromY, defFlip, 0.0, false )
            addChild(acc);
            var sExec:SerialExecutor = new SerialExecutor();
//             sExec.addThread(new DealThread(acc, registHandlers, w, acArray.length-1, spacing*align));
            sExec.addThread(new DealThread(acc, registHandlers, w, getHandX(acArray.length-1), getHandY(acArray.length-1), handCardsScale()));
            sExec.addThread(updateHandMove());
            return sExec;
        }

        // イベントカードを手元に追加する
        public function getAddEventACThread(acc:ActionCardClip, wait:Number):Thread
        {
            log.writeLog(log.LV_FATAL, this, "getAddEventACard acc",acc);
            var w:Number = wait * _MOVED_CARDS_DELAY + 0.01; // wait0がだとスレッドが終わらない
            acArray.push(acc);
            acc.setDealStartPoint(getHandX(acArray.length-1), getHandY(acArray.length-1), defFlip, 0.0, false);
            addChild(acc);
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(acc, {alpha:1.0,scaleX:handCardsScale(),scaleY:handCardsScale()}, null, 0.4 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE ,0.1 / Unlight.SPEED ,true ));
            sExec.addThread(new ClousureThread(registHandlers,[acc]));
            sExec.addThread(updateHandMove());
            log.writeLog(log.LV_FATAL, this, "getAddEventACard acc end",acc);
            return sExec;
        }

        // 墓地からカードを手元に追加する
        public function getAddACFromGraveThread(acc:ActionCardClip, wait:Number):Thread
        {
            var w:Number = wait * _MOVED_CARDS_DELAY + 0.1; // wait0がだとスレッドが終わらない
            acArray.push(acc);
            acc.setDealStartPoint(fromX, fromY+100, defFlip, 0.0, false )
            addChild(acc);
            var sExec:SerialExecutor = new SerialExecutor();
            if (Duel.instance.hasOverrideActionCard(acc.cardID.toString()))
            {
                var values:Object = Duel.instance.getOverrideActionCardValues(acc.cardID.toString());
                sExec.addThread(new ClousureThread(updateCardValue, [acc.cardID, values["u_value"], values["b_value"]]));
            }
            sExec.addThread(new DealThread(acc, registHandlers, w, getHandX(acArray.length-1),getHandY(acArray.length-1), handCardsScale()));
//            sExec.addThread(new DealThread(acc, registHandlers, w, acArray.length-1, spacing*align));
            sExec.addThread(updateHandMove());
            return sExec;
        }

        // 相手からカードを手元に追加する
        public function getAddACFromStealThread(acc:ActionCardClip, wait:Number, positionX:int, positionY:int):Thread
        {
            var w:Number = wait * 0.01 + 0.01; // wait0がだとスレッドが終わらない
            var fromOpPosition:Point;
            acArray.push(acc);
            fromOpPosition = globalToLocal(new Point(positionX, positionY));
//            log.writeLog(log.LV_FATAL, this, "STEAL DEAL globbal X:",positionX," Y:",positionY);

            acc.setDealStartPoint(fromOpPosition.x, fromOpPosition.y, defFlip, 1.0, true );


            addChild(acc);
            var sExec:SerialExecutor = new SerialExecutor();
            if (Duel.instance.hasOverrideActionCard(acc.cardID.toString()))
            {
                var values:Object = Duel.instance.getOverrideActionCardValues(acc.cardID.toString());
                sExec.addThread(new ClousureThread(updateCardValue, [acc.cardID, values["u_value"], values["b_value"]]));
            }
            sExec.addThread(new DealThread(acc, registHandlers, w, getHandX(acArray.length-1),getHandY(acArray.length-1), handCardsScale(),0.1,0.01));
//            sExec.addThread(new DealThread(acc, registHandlers, w, acArray.length-1, spacing*align));
            sExec.addThread(updateHandMove());
            return sExec;
        }

        // 該当するIDのカードの値を更新する
        public function updateCardValue(id:int, uv:int, bv:int, reset:Boolean=false):void
        {
            var aca:Array = reset ? tableArray : acArray;
            for each (var acc:ActionCardClip in aca)
                     {
                         if (acc.cardID == id)
                         {
                             acc.updateCardValue(uv, bv);
                             break;
                         }
                     }
        }

        // 当該IDのカードをロック
        public function cardLock(id:int):void
        {
            for each (var acc:ActionCardClip in acArray)
                     {
                         if (acc && acc.cardID == id){
                             var pExec:ParallelExecutor = new ParallelExecutor();
                             pExec.addThread(new FlipCardsThread([acc]));
                             GameCtrl.instance.addViewSequence(pExec);
                             //acc.flip = false;
                         }
                     }
        }

        public function cardUnlock():void
        {
            for each (var acc:ActionCardClip in acArray)
                     {
                         if (acc && acc.locked){
                             var pExec:ParallelExecutor = new ParallelExecutor();
                             pExec.addThread(new FlipCardsThread([acc]));
                             GameCtrl.instance.addViewSequence(pExec);
                             //acc.flip = false;
                         }
                     }
        }

        // テーブル上のカードのすべてを画面外にとばす
        public function getWipeAllTableCardsThread(ac:Array):Thread
        {
            // 捨てるべきActionCardの配列を受け取り、Tableの上のActioCardClipを取り除く
            // 捨てるべきでないActionCardは手札に返す
            var pExec:ParallelExecutor = new ParallelExecutor();
            var len:int  = tableArray.length;
            var ta:Array = tableArray.slice(); /* of ActioCardClip */ 

            for (var i:int = 0; i < len ; i++)
            {
                if(ac.indexOf(ta[i].ac) != -1 || ta[i].locked)
                {
                    // 捨てるべきカードがテーブルにある場合
                    // カードを画面外にとばすスレッドを追加
                    pExec.addThread(getWipeACThread(ta[i], i+1));
                    // テーブルから削除する
                    removeFromTableArray(ta[i]);
                }
                else
                {
                    // 捨てるべきカードでない場合
                    // 手札に返す
                    swapActionCard(ta[i], tableArray, acArray);
                    // 返すスレッドを追加
                    pExec.addThread(updateHandMove());
                }
            }
            return pExec;
        }

        protected function removeFromTableArray(acc:ActionCardClip):void
        {
            tableArray.splice(tableArray.indexOf(acc),1)
        }

        protected function removeFromHandArray(acc:ActionCardClip):void
        {
            acArray.splice(acArray.indexOf(acc),1)
        }

        // テーブル上の特定のカードを画面外にとばす
        public function getWipeTableCardsThread(ac:Array):Thread
        {
            // 捨てるべきActionCardの配列を受け取り、Tableの上のActioCardClipを取り除く
            // 捨てるべきでないActionCardはそのまま
            var pExec:ParallelExecutor = new ParallelExecutor();
            var len:int  = tableArray.length;
            var ta:Array = tableArray.slice(); /* of ActioCardClip */ 
            for (var i:int = 0; i < len ; i++) 
            {
                if(ac.indexOf(ta[i].ac) != -1)
                {
                    // 捨てるべきカードがテーブルにある場合
                    // カードを画面外にとばすスレッドを追加
                    pExec.addThread( getWipeACThread(ta[i], i+1));
                    // テーブルから削除する
                    removeFromTableArray(ta[i]);
                }

            }
            return pExec;
        }

        // 手札上の特定のカードを画面外にとばす
        public function getWipeHandCardsThread(ac:Array):Thread
        {
            // 捨てるべきActionCardの配列を受け取り、手札の上のActioCardClipを取り除く
            // 捨てるべきでないActionCardはそのまま
            var pExec:ParallelExecutor = new ParallelExecutor();
            var len:int  = acArray.length;
            var aca:Array = acArray.slice(); /* of ActioCardClip */ 

            for (var i:int = 0; i < len ; i++) 
            {
                if(ac.indexOf(aca[i].ac) != -1)
                {
                    // 捨てるべきカードがテーブルにある場合
                    // カードを画面外にとばすスレッドを追加
                    pExec.addThread( getWipeACThread(aca[i], i+1));
                    // テーブルから削除する
                    removeFromHandArray(aca[i]);
                }

            }
            return pExec;
        }

        // 手札上のカードをその場で消す
        public function getVanishHandCardsThread(ac:Array):Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var len:int  = acArray.length;
            var aca:Array = acArray.slice(); /* of ActioCardClip */ 

            for (var i:int = 0; i < len ; i++) 
            {
                if(ac.indexOf(aca[i].ac) != -1)
                {
                    pExec.addThread(getVanishACThread(aca[i], i+1));
                    removeFromHandArray(aca[i]);
                }
            }
            return pExec;
        }

        // 終了時手札をすべて消す
        public function getVanishAllHandCards():Thread
        {
            return getVanishHandCardsThread(acArray);
        }

        // 画面外にカードをとばす
        public function getWipeACThread(acc:ActionCardClip, wait:Number):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var w:Number = wait*_WIPE_CARDS_DELAY;
            var pExec:ParallelExecutor = new ParallelExecutor();
            disposeHandlers(acc);
            if (acc.isRewritten())
            {
                sExec.addThread(new SleepThread(600 / Unlight.SPEED));
                sExec.addThread(new ClousureThread(acc.resetCardValue));
                sExec.addThread(new SleepThread(300 / Unlight.SPEED));
            }
            pExec.addThread(SE.getThrowCardSEThread(w*0.7));
            pExec.addThread(new BeTweenAS3Thread(acc, {x:distX ,y:distY ,scaleX:1.0 ,scaleY:1.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_EXPO ,w / Unlight.SPEED ,false ));
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(disposeHandlers,[acc]))
            return sExec;
        }


        // その場でカードを消す(ovverRide前提)
        public function getVanishACThread(acc:ActionCardClip, wait:Number):Thread
        {
//            return new TweenerThread (acc, {transition:"easeOutExpo", time: 0.1} );
            disposeHandlers(acc);
            if (acc.isRewritten())
            {
                sExec.addThread(new SleepThread(600 / Unlight.SPEED));
                sExec.addThread(new ClousureThread(acc.resetCardValue));
                sExec.addThread(new SleepThread(300 / Unlight.SPEED));
            }
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(acc, {x:acc.x}, null, 0.1 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_EXPO ));
            sExec.addThread(new ClousureThread(disposeHandlers,[acc]));
            return sExec;
        }

        // マウスのイベントの登録(override前提)
        protected function registHandlers(acc:ActionCardClip):void
        {
//             acc.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
//             acc.addEventListener(MouseEvent.MOUSE_OUT,mouseRemoveHandler);
        }

        // マウスのイベントの削除(override前提)
        protected function disposeHandlers(acc:ActionCardClip):void
        {
//             acc.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
//             acc.removeEventListener(MouseEvent.MOUSE_OUT,mouseRemoveHandler);
        }

        // マウスオーバ時のハンドラ
        protected function mouseOverHandler(e:MouseEvent):void
        {
            overIndex = acArray.indexOf(e.currentTarget);
        }

        // マウスリムーブ時のハンドラ
        protected function mouseRemoveHandler(e:MouseEvent):void
        {
             overIndex = acArray.indexOf(e.currentTarget);
        }

        // アクションカードのスワップ
        protected function swapActionCard(s:Object, a:Array, b:Array):void
        {
            log.writeLog(log.LV_INFO, this, "!!!!! swaoactioncard",s);
            a.splice(a.indexOf(s), 1);
            b.push(s);
        }

       private function open():void
        {

        }

        protected function dropDetect(x:Number, y:Number, acc:ActionCardClip):Boolean
        {
            return false;

        }

        // 手札の再配置
        protected function updateHandMove():Thread
        {
            _handPExec = new ParallelExecutor();
            var acSet:Array = acArray.slice(); /* of actioncard */ 
            var len:int = acArray.length;
            // 配列をソートしてスレッドの合成
            for(var i:int = 0; i < len; i++)
            {
                if (acSet[i] != null)
                {
                    var sExec:SerialExecutor = new SerialExecutor();
                    sExec.addThread(new BeTweenAS3Thread(acSet[i], {x:getHandX(i) ,y:getHandY(i) ,scaleX:handCardsScale() ,scaleY:handCardsScale()}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                    sExec.addThread(new ClousureThread(acSet[i].clickOn));
                    _handPExec.addThread(sExec);
                    // 手元のカードはすべて非アクティブに
                    acSet[i].valueOff();
                    acSet[i].clickOff();
                }
            }
//             log.writeLog(log.LV_DEBUG, this, "### updateHandMove return PExec.", _handPExec);
            return _handPExec;
        }



        // ドロップテーブルの再配置
        protected function updateDropCardMove():Thread
        {
//             // 中心から
//             var startX:int = dropPoint.x - ((tableArray.length/2-0.5)*spacing*dropCardsScale());

//             if(_dropPExec == null || _dropPExec.state == ThreadState.TERMINATED)
//             {
            var taSet:Array = tableArray.slice(); /* of actioncard */ 
            _dropPExec = new ParallelExecutor();
            for(var i:int = 0; i < taSet.length; i++)
            {
                if (taSet[i]!=null)
                {
                    // ドロップされたカードの描画順位を変更する（最初に配られたものが最前面）
                    setChildIndex(taSet[i],(numChildren-1-i));
                    _dropPExec.addThread(new BeTweenAS3Thread(taSet[i], {x:getDropX(i) ,y:getDropY(i) ,scaleX:dropCardsScale() ,scaleY:dropCardsScale()}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                }
            }
            return _dropPExec;
//             }
//             else
//             {
//                 return new Thread();
//             }
        }

        protected function getDealThread(acc:ActionCardClip, hr:Function, wait:Number, xPosition:int, yPosition:int, scale:Number, moveTime:Number = 0.3,movedDelay :Number= 0.1):Thread
        {
            return new DealThread(acc, hr, wait, xPosition, yPosition, scale,moveTime, movedDelay);
        }

        public function getBringOffThread():Thread
        {
//            return new TweenerThread(this, {alpha:0.0, transition:"easeOutSine", time: 0.5, hide:true});
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
        }

    }




}


import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;
import model.Duel;
import view.scene.game.DropTable;

// 手札のカードを反転させるスレッド
class FlipCardsThread extends Thread
{
    private var _accArray:Array;
    private var count:int = 0;
    private static const _WAIT:int = 10; // ms
    private static const _LAST_WAIT:int = 300; // ms

    public function FlipCardsThread(accArray:Array)
    {
        _accArray = accArray;
    }

    protected override function run():void
    {
        next(flipCard);
    }

    private function flipCard():void
    {
        if (count == _accArray.length)
        {
            next(waitEnd);
        }
        else
        {
            if (_accArray[count].locked)
            {
                if (_accArray[count].locked )
                {
                    SE.playCardSetTable();
                }
                else
                {
                    SE.playOpenActionCard();
                }
//                _accArray[count].parent.addChild(_accArray[count]);
                _accArray[count].unlock();
                _accArray[count].setLarge(false);
                _accArray[count].flip = true;
                sleep(_WAIT);
            }
            else
            {
                SE.playOpenActionCard();
//                _accArray[count].parent.addChild(_accArray[count]);
                _accArray[count].lockCard();
                _accArray[count].setLarge(true);
                _accArray[count].flip = true;
                sleep(_WAIT);
            }
            count +=1;
            next(flipCard);
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


import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

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
        var cardAlphaTween:Thread = new BeTweenAS3Thread(_acc, {alpha:1.0}, null, _movedDelay / Unlight.SPEED , BeTweenAS3Thread.EASE_OUT_SINE ,_wait ,true );
        var cardMoveTween:Thread = new BeTweenAS3Thread(_acc, {x:_x ,y:_y ,scaleX:_scale ,scaleY:_scale}, null, _moveTime / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE ,_wait,true );
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
