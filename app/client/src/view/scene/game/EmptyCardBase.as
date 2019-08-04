package view.scene.game
{
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;

    import flash.filters.*;
    import flash.filters.GradientBevelFilter;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.CharaCard;
    import model.Duel;
    import model.Entrant;
    import model.events.DamageEvent;
    import view.*;
    import view.image.game.*;
    import view.scene.BaseScene;
    import controller.*;



    /**
     * FarBGScene表示クラス
     *
     */


    public class EmptyCardBase  extends BaseScene
    {
        private var _emptyCardBaseImageSet:Vector.<EmptyCardBaseImage> = new Vector.<EmptyCardBaseImage>();

        private var _duel:Duel = Duel.instance;

        private var _cardsMax:int;
        private var _container:UIComponent;



        /**
         * コンストラクタ
         *
         */
        public function EmptyCardBase()
        {
            super();
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return  new ShowThread(this, stage);
        }

        public override function init():void
        {
            _cardsMax = _duel.plEntrant.cardsMax;
            var setLen:int = _emptyCardBaseImageSet.length;

            if (_cardsMax > setLen)
                // 一度も初期化されていない場合
            {
                for(var i:int = 0; i < _cardsMax; i++){
                    // カードが未登録なら作って足す
                    if (setLen-1 <i){ _emptyCardBaseImageSet.push(new EmptyCardBaseImage())};
                    addChild(_emptyCardBaseImageSet[i]);
                    _emptyCardBaseImageSet[i].x = 202+i*60;
                    _emptyCardBaseImageSet[i].y = 512;
                }
            }else{
                decrementEmptySet(_cardsMax);
            }
            // イベントを追加
           _duel.addEventListener(Duel.REFILL_PHASE, refillPhaseHandler);
        }

        private function updateCardsMax(m:int, wait:int =0 ):void
        {
            if (_emptyCardBaseImageSet.length < m)
            {
                for (var i:uint=_emptyCardBaseImageSet.length; i < m; i++)
                {
                    _emptyCardBaseImageSet.push(new EmptyCardBaseImage());
                    addChild(_emptyCardBaseImageSet[i]);
                    _emptyCardBaseImageSet[i].x = 202+(i)*60;
                    _emptyCardBaseImageSet[i].y = 512;
                    GameCtrl.instance.addViewSequence(new SleepThread(wait));
                    GameCtrl.instance.addViewSequence(new ClousureThread(_emptyCardBaseImageSet[i].onAddCard));
                }
            }else if (_emptyCardBaseImageSet.length > m)
            {
                decrementEmptySet(m);
            }

        }

        private function decrementEmptySet(max:int):void
        {
            var len:int  = _emptyCardBaseImageSet.length - max;
            for(var i:int = 0; i <len  ; i++)
            {
                removeChild(_emptyCardBaseImageSet.pop());
            }
        }


        public override function final():void
        {
            _emptyCardBaseImageSet.forEach(function(item:EmptyCardBaseImage, index:int, array:Vector.<EmptyCardBaseImage>):void{removeChild(item)});
            _emptyCardBaseImageSet.length = 0;
            _duel.removeEventListener(Duel.REFILL_PHASE, refillPhaseHandler);
        }


        private function refillPhaseHandler(e:Event):void
        {
            updateCardsMax(_duel.plEntrant.cardsMax,500);
        }


    }
}


// Duelのinitを待つShowスレッド

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.utils.*;
import org.libspark.thread.Thread;

import model.Duel;
import view.scene.BaseScene;
import view.BaseShowThread;

class ShowThread extends BaseShowThread
{
    private var _sc:BaseScene;

    public function ShowThread(sc:BaseScene, stage:DisplayObjectContainer)
    {
        _sc = sc;
        super(sc,stage)
    }

    protected override function run():void
    {
        // ロードを待つ
        if (Duel.instance.inited == false)
        {
            Duel.instance.wait();
        }
        next(close);
    }

}
