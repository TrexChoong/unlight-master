package view.scene.game
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.ActionCard;
    import model.Entrant;
    import model.events.CardSuccessEvent;
    import model.Duel;

    import view.image.game.*;
    import view.WaitThread;
    import controller.*;

    /**
     * PlayerHand表示クラス
     *
     */

    public class PlayerHand  extends BaseHand
    {

        private static const _X:int = 202;
        private static const _Y:int = 512;


        private static const _DIST_FOE_X:int = 650; // カードが相手に渡される目標点.X（Global
        private static const _DIST_FOE_Y:int = -40; // カードが相手に渡される目標点.Y（Global）

        private static const _HAND_WIDTH:int = 560;   // 手札の並びの最大幅
        private static const _HAND_HEIGHT:int = 95;   // 手札の並びの最大高さ

        private static const _DROP_WIDTH:int = 560;   // 置いた並びの最大幅
        private static const _DROP_HEIGHT:int = 95;   // 置いた並びの最大高さ


        protected var distFoeP:Point;              // カードが渡される目標点（local）

        private static const _SPACING:int = 60; // カードが配られる時の間隔
        private var _pExec:ParallelExecutor = new ParallelExecutor();
        private var _currentACC:ActionCardClip;

        /**
         * コンストラクタ
         *
         */

        public function PlayerHand(dropTable:DropTable, entrant:Entrant)
        {
            super(dropTable, entrant);
            distFoeP = globalToLocal(new Point(_DIST_FOE_X, _DIST_FOE_Y));
            _entrant.addEventListener(CardSuccessEvent.MOVE_ADD,addCardSuccesHandler);
            _entrant.addEventListener(CardSuccessEvent.MOVE_REMOVE,removeCardSuccesHandler);
            _entrant.addEventListener(CardSuccessEvent.BATTLE_ADD,addCardSuccesHandler);
            _entrant.addEventListener(CardSuccessEvent.BATTLE_REMOVE,removeCardSuccesHandler);
        }

        public override function final():void
        {
            super.final();
            _entrant.removeEventListener(CardSuccessEvent.MOVE_ADD,addCardSuccesHandler);
            _entrant.removeEventListener(CardSuccessEvent.MOVE_REMOVE,removeCardSuccesHandler);
            _entrant.removeEventListener(CardSuccessEvent.BATTLE_ADD,addCardSuccesHandler);
            _entrant.removeEventListener(CardSuccessEvent.BATTLE_REMOVE,removeCardSuccesHandler);
            _currentACC = null;
        }


        protected override function get startX():int
        {
            return _X;
        }

        protected override function get startY():int
        {
            return _Y;
        }

        protected override  function get defFlip():Boolean
        {
            return true;
        }

        protected override function get spacing():int
        {
            return _SPACING;
        }

        protected override function get dropPoint():Point
        {
            return globalToLocal(DropTable.PL_CARD_PT);
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

        // マウスのイベントの登録
        protected override function registHandlers(acc:ActionCardClip):void
        {
            acc.setOnTable(false);
            if ( !Duel.instance.isWatch ) {
                acc.setRotateButtonHandler(rotateButtonClick);
                acc.addEventListener(MouseEvent.CLICK, mouseClickHandler,false, 0, true);
                acc.addEventListener(MouseEvent.MOUSE_OVER, acMouseOverHandler,false, 0, true);
                acc.addEventListener(MouseEvent.MOUSE_OUT, acMouseOutHandler,false, 0, true);
            }
        }

        // マウスのイベントの削除
        protected override function disposeHandlers(acc:ActionCardClip):void
        {
            if ( !Duel.instance.isWatch ) {
                acc.removeRotateButtonHandler();
                acc.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
                acc.removeEventListener(MouseEvent.MOUSE_OVER, acMouseOverHandler);
                acc.removeEventListener(MouseEvent.MOUSE_OUT, acMouseOutHandler);
            }
        }

        // マウスボタンダウン時のハンドラ
        private function mouseClickHandler(e:MouseEvent):void
        {
            if (_dragEnable)
            {
                var acc:ActionCardClip = ActionCardClip(e.currentTarget);
//                acc.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
                dragOff();
                new WaitThread(250,dragOn,[],true).start();
                e.currentTarget.parent.setChildIndex(e.currentTarget, e.currentTarget.parent.numChildren-1);
                _currentACC = acc;
                clickCard(ActionCardClip(e.currentTarget));
            }
        }
        private function addMouseEvent(acc:ActionCardClip):void
        {
            acc.addEventListener(MouseEvent.CLICK, mouseClickHandler,false, 0, true);
        }

        private function acMouseOverHandler(e:MouseEvent):void
        {
            if (_dragEnable)
            {
                e.currentTarget.setButtonVisible(true);
            }
        }

        private  function acMouseOutHandler(e:MouseEvent):void
        {
            e.currentTarget.setButtonVisible(false);
        }

        public override function dragOff():void
        {
            _dragEnable = false;
            acArray.forEach(offButton);
            tableArray.forEach(offButton);
        }
        public override function dragOn():void
        {
            if (!dropTable.isDone)
            {
                _dragEnable = true;
                acArray.forEach(onButton);
                tableArray.forEach(onButton);
            }
        }

        private function offButton(item:*, index:int, array:Array):void
        {
            item.clickOff();
        }

        private function onButton(item:*, index:int, array:Array):void
        {
            item.clickOn();
        }



        // ローテートボタンクリック用のハンドラ
        public function rotateButtonClick(ac:ActionCard, up:Boolean):void
        {
//            log.writeLog(log.LV_FATAL, this, "click rotatebutton");
            if (_dragEnable)
            {
                _entrant.cardRotate(ac, up);
            }
        }


        // カードをクリックした
        private function clickCard(acc:ActionCardClip):void
        {
            if (tableArray.indexOf(acc)==-1)
            {
                acc.setOnTable(true);
                // ない場合はテーブルに追加する
                dropTable.addCard(acc,acc.ac.up);
            }
            else
            {
                acc.setOnTable(false);
                dropTable.removeCard(acc);
            }

        }

        // 追加に成功した
        private function addCardSuccesHandler(e:CardSuccessEvent):void
        {
            // indexが-1は失敗
            if (e.index != -1)
            {
                // カードを交換する
                swapActionCard(ActionCardClip.getInstance(e.id), acArray, tableArray);
                SE.getThrowCardSEThread(0.0).start();
            }
            // ドロップテーブルに配置するTween
            updateDropCardMove().start();
            // 手札テーブルを再配置するTween
            GameCtrl.instance.addViewSequence(updateHandMove());
//            updateHandMove().start();
        }

        private function addClickEvent():void
        {
            
        }


        // 取り除きに成功した
        private function removeCardSuccesHandler(e:CardSuccessEvent):void
        {
            // indexが-1は失敗
            if (e.index != -1)
            {
                // カードを交換する
                swapActionCard(ActionCardClip.getInstance(e.id), tableArray, acArray);
                SE.getThrowCardSEThread(0.0).start();
            }

            // ドロップテーブルに配置するTween
            updateDropCardMove().start();
            // 手札テーブルを再配置するTween
            GameCtrl.instance.addViewSequence(updateHandMove());
//            updateHandMove().start();
        }

        // 手札上のカードをその場で消す
        public override function getVanishHandCardsThread(ac:Array):Thread
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


        // 相手側に向かっでカードを消す
        public override function getVanishACThread(acc:ActionCardClip, wait:Number):Thread
        {
//            return new TweenerThread (acc, { x:distFoeP.x, y:distFoeP.y, delay:0.2, scaleX:0.8, scaleY:0.8, transition:"easeOutQuart", time: 0.5, hide: true} );
            disposeHandlers(acc);
            return new BeTweenAS3Thread(acc, {x:distFoeP.x ,y:distFoeP.y ,scaleX:0.8 ,scaleY:0.8}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_QUART ,0.2 / Unlight.SPEED ,false );
        }



    }

}
