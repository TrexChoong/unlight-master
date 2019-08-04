package view.scene.game
{
    import flash.display.*;
    import flash.display.DisplayObjectContainer;
    import flash.utils.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.*;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;
    import org.libspark.betweenas3.core.easing.IEasing;
    import org.libspark.betweenas3.events.TweenEvent;

    import model.Duel;
    import model.events.DetermineMoveEvent;
    import model.Entrant;
    import model.events.BuffEvent;
    import view.image.game.MoveArrowImage;
    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;
    import view.SleepThread;
    import controller.*;

    /**
     * 移動矢印シーンクラス
     *
     */

    public class MoveArrow extends BaseScene
    {
        // デュエルインスタンス
        private var _duel:Duel = Duel.instance;

        // 表示オブジェクト
        private var _arrow:MoveArrowImage = new MoveArrowImage();

              // ゲームのコントローラ

        private static const _PLAYER_X:int = 162;
        private static const _PLAYER_Y:int = 260;
        private static const _FOE_X:int = Unlight.WIDTH-_PLAYER_X;
        private static const _FOE_Y:int = _PLAYER_Y;

        private static var _ARROW_DIST:int = 20;
        private static var _ARROW_VANISH:int = Unlight.WIDTH/2;

        // 変数
        private var _id:int;
        private var _value:int;
        private var _turn:int;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [""],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        /**
         * コンストラクタ
         *
         */
        public function MoveArrow()
        {
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray = [];
            _toolTipOwnerArray.push([0,this]);  //
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

        public override function init():void
        {
            _duel.addEventListener(DetermineMoveEvent.UPDATE, updateHandler);
            log.writeLog(log.LV_FATAL, this, "init?");
             initilizeToolTipOwners();
//             var a:DisplayObject = _arrow.getLeftArrow();
//             var b:DisplayObject = _arrow.getRightArrow();
//             a.x = b.x = 50;
//             a.y = b.y = 50;
//             addChild(a);
//             addChild(b);

        }

        public override function final():void
        {
            log.writeLog(log.LV_FATAL, this, "remove handler");
            _duel.removeEventListener(DetermineMoveEvent.UPDATE, updateHandler)
        }
        private function updateHandler(e:DetermineMoveEvent):void
        {
            var plArrows:Vector.<DisplayObject> = createArrows(e.pow);
            var foeArrows:Vector.<DisplayObject> = createArrows(e.foePow*-1);
            var pow:int = e.pow;
            var foePow:int = e.foePow;

            var pT:ITween;
            var plTweenArray:Array = []; /* of ITween*/ 
            var foeTweenArray:Array = []; /* of ITween*/ 
            var vanishTweenArray:Array = []; /* of ITween*/ 
            var hideTweenArray:Array = []; /* of ITween*/ 

            log.writeLog(log.LV_FATAL, this, "Arrow Show", plArrows.length, e.pow, e.foePow);

             for(var i:int = 0; i < plArrows.length; i++)
             {
                 plArrows[i].alpha = 0.0;
                 plArrows[i].x = _PLAYER_X+i*_ARROW_DIST;
                 plArrows[i].y = _PLAYER_Y;
                 addChild (plArrows[i]);
                 plTweenArray.push(BetweenAS3.delay(createShowTween(plArrows[i]),i*0.1));
                 hideTweenArray.push(BetweenAS3.serial(BetweenAS3.to(plArrows[i], {alpha:0},0.2),BetweenAS3.removeFromParent(plArrows[i])));
             }
            log.writeLog(log.LV_FATAL, this, "Arrow Show", foeArrows.length, e.pow, e.foePow);

             for(var j:int = 0; j < foeArrows.length; j++)
             {
                 foeArrows[j].alpha = 0.0;
                 foeArrows[j].x = _FOE_X-j*_ARROW_DIST;
                 foeArrows[j].y = _FOE_Y;
                 addChild (foeArrows[j]);
                 foeTweenArray.push(BetweenAS3.delay(createShowTween(foeArrows[j]),j*0.1));
                 hideTweenArray.push(BetweenAS3.serial(BetweenAS3.to(foeArrows[j], {alpha:0},0.2),BetweenAS3.removeFromParent (foeArrows[j])));
             }

             // 符号が異なるとき相殺する(-3:1, 3:-5, 5:-1)
             if (((pow>0)&&(foePow<0))||((pow<0)&&(foePow>0)))
             {
                 var num:int =  Math.abs(pow)<Math.abs(foePow) ? Math.abs(pow):Math.abs(foePow)
                     for(var k:int = 0; k < num; k++)
                     {
//                         log.writeLog(log.LV_FATAL, this, "Arrow vanishi pl", plArrows[plArrows.length-1-k]);
                         vanishTweenArray.push(BetweenAS3.delay(createVanishTween(plArrows[plArrows.length-1-k],1),k*0.1));
//                         log.writeLog(log.LV_FATAL, this, "Arrow vanishi foe", foeArrows[foeArrows.length-1-k]);
                         vanishTweenArray.push(BetweenAS3.delay(createVanishTween(foeArrows[foeArrows.length-1-k],-1),k*0.1));
                     }
             }

//             BetweenAS3.parallel(BetweenAS3.parallelTweens(plTweenArray),BetweenAS3.parallelTweens(foeTweenArray)).play();
//             if (BetweenAS3.parallelTweens(plTweenArray).l)
//             GameCtrl.instance.addViewSequence(new BTThread(BetweenAS3.parallel(BetweenAS3.parallelTweens(plTweenArray),BetweenAS3.parallelTweens(foeTweenArray))));
             if (plTweenArray.length>0){GameCtrl.instance.addNoWaitViewSequence(new BTThread(BetweenAS3.parallelTweens(plTweenArray)));};
             if (foeTweenArray.length>0){GameCtrl.instance.addNoWaitViewSequence(new BTThread(BetweenAS3.parallelTweens(foeTweenArray)))}
             if (hideTweenArray.length>0){ GameCtrl.instance.addViewSequence(new SleepThread(800));}
             if (vanishTweenArray.length >0)
             {
                 log.writeLog(log.LV_FATAL, this, "vanishTweenArray", vanishTweenArray);
                 GameCtrl.instance.addViewSequence(new BTThread(BetweenAS3.parallelTweens(vanishTweenArray)));
                 GameCtrl.instance.addViewSequence(new SleepThread(800));
             }
             if (hideTweenArray.length>0){GameCtrl.instance.addViewSequence(new BTThread(BetweenAS3.parallelTweens(hideTweenArray)))};



        }

        private function createArrows(pow:int):Vector.<DisplayObject>
        {
            var ret:Vector.<DisplayObject> = new Vector.<DisplayObject>(); /* of do */ 
            var num :int = Math.abs(pow);
            for(var i:int = 0; i < num ; i++)
            {
                if (pow > 0)
                {
                    ret.push(_arrow.getLeftArrow());
                }else{
                    ret.push(_arrow.getRightArrow());
                }
            }
            return ret;
        }

        private function createShowTween(d:DisplayObject):ITween
        {

            return BetweenAS3.serial(
                BetweenAS3.to(d,{alpha:1.0,_glowFilter:{blurX:10, blurY:10, color:0xFFFF99}},0.2),
                BetweenAS3.to(d,{_glowFilter:{blurX:0, blurY:0, color:0xFFFF99}},0.1)
                );

        }
        private function createVanishTween(d:DisplayObject, dist:int):ITween
        {
            var distX:int = 150*dist;
//            return  BetweenAS3.to(d,{x:523,_blurFilter:{blurX:40, blurY:40, color:0xFFFF99}},0.2)
            return  BetweenAS3.to(d,{x:_ARROW_VANISH, alpha:0.0},0.2)
//             return BetweenAS3.parallel(
// //                BetweenAS3.to(d,{alpha:0},0.3)

//                 );

        }

    }

}


