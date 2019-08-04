
package view
{
    import flash.filters.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;

    import flash.events.Event;
    import org.libspark.thread.*;

    import view.image.BaseLoadImage;

    import mx.containers.Panel;
    import mx.controls.*;
    import mx.core.UIComponent;
    import mx.core.*;
    import mx.managers.*;

    import mx.events.StateChangeEvent;
    import mx.controls.textClasses.TextRange;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Player;
    import controller.*;
    import view.scene.game.*;
    import view.image.game.*;

    /**
     * 表示テストのビュークラス
     *
     */

   public class TestView extends Thread
    {



        private var _stage:Sprite;
        private var _container:UIComponent = new UIComponent(); // 表示コンテナ

        private var _bg:BG = new BG(0); // リザルト表示クラス
        private var _perspective:PerspectiveProjection;

//         private var _resultScene:ResultScene; // リザルト表示クラス

//         private var _dropTable:DropTable = new DropTable(); // ドロップテーブルクラス
//         private var _deckArea:DeckArea = new DeckArea();
                



//         private var _dice:DiceManager; // ダイスを管理するクラス
//         private var _deck:Deck; // デッキを管理するクラス

//         private var _diceManager2:DiceManager; // ダイスを管理するクラス

// //         // 次のビュースレッド
// //         private var _nextView:NextView; // 仮

//         /**
//          * コンストラクタ
//          * @param stage 親ステージ
//          *
//          */
        public function TestView(stage:Sprite)
        {
             _stage = stage;
             _bg.getShowThread(stage).start();

//              _perspective =  stage.root.transform.perspectiveProjection;
//              stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
  
        }


        // スレッドのスタート
        override protected  function run():void
        {
//            _diceManager.getRollDiceThread().start();
//            next(dropTableShow);
//            next(deckAreaShow);
//            next(diceShow);
        }


        private function onMouseDownHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "garnd pers",_perspective,e.stageX,e.stageY);
           _perspective.projectionCenter = new Point(e.stageX, e.stageY);
            _perspective.fieldOfView = 75;

        }








//         // ==============================================================
//         // ドロップテーブルのテスト
//         // ==============================================================
//         private function dropTableShow():void
//         {
//             _container.addChild(_dropTable);
// //            _dropTable.getSetInitiativePhaseThread().start();
//             next(dropTableSetActionCard);
//         }

//         private function dropTableSetActionCard():void
//         {
// //            _dropTable.xxx();
//         }

//         // ==============================================================
//         // デッキのテスト
//         // ==============================================================

//         private function deckAreaShow():void
//         {
//             _container.addChild(_deckArea);
//             _deckArea.getShowThread(_stage).start();
//             next(deckAreaInitDeck);
//         }


//         private function deckAreaInitDeck():void
//         {
//             _deckArea.initDeck(20).start();
//         }



//         // ==============================================================
//         // ==============================================================


//         // 色々表示させる
//         private function diceShow():void
//         {
//             // _nextView = new NextView(_stage);
// //            var deckTween:Thread = new TweenerThread(_deck, { alpha: 1.0, transition:"easeOutSine", time: 1, show: true } );
// //            var deckTween:Thread = new BeTweenAS3Thread(_deck, {alpha:1.0}, null, 1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
//             var pExec:ParallelExecutor = new ParallelExecutor();
// //            pExec.addThread(deckTween);
// //            pExec.addThread(diceManagerTween);
//             _diceManager.eyeArray = [6,6,6,6,6,6];
//             pExec.addThread(_diceManager.getRollDiceThread());
//             pExec.addThread(_diceManager2.getRollDiceThread());
//             pExec.addThread(_resultScene.getResultThread(1,1,1,1));
//             pExec.addThread(_deck.getDeckThread());

//             pExec.start();
//             // 終了を待つ
//             pExec.join();
//             // 1フレームごとの処理を追加
//             _stage.addEventListener(Event.ENTER_FRAME,_deck.render);
// //            _stage.addEventListener(Event.ENTER_FRAME,_diceManager.render);
//             // 待機へ
//             next(waiting);
//         }

//         // 待機
//         private function waiting():void
//         {
//             var player:Player = Player.instance
//                 next(toNext);
//             if (/* 次のViewに行く条件を書く*/ 0)
//             {
//                 next(hide);
//             }

//             // ステージのステートチェンジイベントをリッスン。ただしここでは無効
//             event(player, Player.AUTH_SUCCESS, authHandler);
//         }

//         private function authHandler(event:Event):void
//         {
//             next(hide);
//         }

//         // 終了
//         private function hide():void
//         {
//              log.writeLog (log.LV_INFO,this, "あああ");
//             var diceManagerTween:Thread = new TweenerThread(_diceManager, { alpha: 0.0, transition:"easeOutSine", time: 1.0, hide: true } );
//             var diceManagerTween:Thread = new BeTweenAS3Thread(_diceManager, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
//             var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.addThread(diceManagerTween);
//             pExec.start();
//             pExec.join();
//             next(toNext);
//         }

//         // 次の画面へ
//         private function toNext():void
//         {
//              log.writeLog (log.LV_INFO,this, "next start");
// //            var diceManagerTween:Thread = new TweenerThread(_diceManager, { alpha: 1.0, transition:"easeOutSine", time: 3.5, show: true } );
// //            var diceManagerTween:Thread = new BeTweenAS3Thread(_diceManager, {alpha:1.0}, null, 3.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
//             var pExec:ParallelExecutor = new ParallelExecutor();
//              _diceManager.eyeArray = [4,4,3,4,5,2,1,2,3,2,5,4,4,3,6,1,2,2,5,2,6,1,1,];
//             pExec.addThread(_diceManager.getRollDiceThread());
//             pExec.start();
//             pExec.join();
// //             _nextView.start();
// //             _nextView.join();
// //             next(show);

//             next(toNext2);
// //            interrupted(pushOut);
//         }

//         // さらに次の画面へ
//         private function toNext2():void
//         {
//             log.writeLog(log.LV_INFO, this, "next2 start");

//             var pExec:ParallelExecutor = new ParallelExecutor();
//             pExec.start();
//             pExec.join();

//             interrupted(pushOut);
//         }

//         // 強制終了割り込み
//         private function pushOut():void
//         {
// //             _nextView.interrupt();
// //             _nextView.join();
// //             next(show);
//         }

//         // 終了関数
//         override protected  function finalize():void
//         {
//              log.writeLog (log.LV_WARN,this,"test end");
//         }
    }
}
