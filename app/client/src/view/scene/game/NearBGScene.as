package view.scene.game
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
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
    import view.ClousureThread;
    import view.image.game.*;
    import view.scene.BaseScene;
    import controller.*;



    /**
     * NearBGScene表示クラス
     *
     */


    public class NearBGScene  extends BaseScene
    {
        private var _nearBG:NearBG;

        private var _duel:Duel = Duel.instance;

        private var _type:int;

        /**
         * コンストラクタ
         *
         */
        public function NearBGScene(id:int)
        {
            _type = id;
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
            _nearBG = new NearBG(_type);
            addChild(_nearBG)
            // イベントを追加
            _duel.addEventListener(Duel.DISTANCE_UPDATE, distanceUpdateHandler);
        }

        public override function final():void
        {
            removeChild(_nearBG);
            _nearBG = null;
            _duel.removeEventListener(Duel.DISTANCE_UPDATE, distanceUpdateHandler);
        }


        private function distanceUpdateHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "eventDone");
            _nearBG.updateDistance(_duel.distance);
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
