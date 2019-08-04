package view.scene.game
{
    import flash.display.*;
    import flash.display.DisplayObjectContainer;
    import flash.utils.*;

    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.*;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;
    import org.libspark.betweenas3.core.easing.IEasing;
    import org.libspark.betweenas3.events.TweenEvent;

    import model.Duel;
    import model.events.DuelBonusEvent;
    import model.Entrant;
    import model.events.BuffEvent;
    import view.image.game.*;
    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;
    import view.SleepThread;
    import view.utils.*;
    import controller.*;

    /**
     * 移動矢印シーンクラス
     *
     */

    public class BonusMessScene extends BaseScene
    {
        // プレイヤーエントラント
        private var _duel:Duel;

        // 表示されるX
        private static const _MESS_X:int = 10;
        private static const _START_MESS_X:int = -140;

        // メッセージのイメージ
        private var _mess:DuelBonusMessImage;
        private var _num:DuelBonusNum;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [""]
                ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        private var _copyRight:Label = new Label();

        /**
         * コンストラクタ
         *
         */
        public function BonusMessScene()
        {
            _mess = new DuelBonusMessImage();
            _num = new DuelBonusNum();

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
            addChild(_mess);
            addChild(_num);
            _duel = Duel.instance;
            log.writeLog(log.LV_FATAL, this, "init?",_duel);
            initilizeToolTipOwners();
            _duel.addEventListener(DuelBonusEvent.GET, bonusGetHandler);
            visible =true;
            alpha =0.0;
            _num.resetBonus();
        }

        public override function final():void
        {
            log.writeLog(log.LV_FATAL, this, "remove handler");
            if (_duel!=null)
            {
                _duel.removeEventListener(DuelBonusEvent.GET, bonusGetHandler);
            }
            _num.resetBonus();
            RemoveChild.apply(_num);
        }

        private function bonusGetHandler(e:DuelBonusEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "Bonus Mess Show",  e.kind, e.value);
            _mess.setBonus(e.kind, e.value);
            GameCtrl.instance.addViewSequence(new BTThread(createShowTween(_mess)));
            GameCtrl.instance.addViewSequence(new BTThread(createVanishTween(_mess,e.value)));

        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            return new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
        }
        public function getBringOffThread():Thread
        {
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
        }

        private function createShowTween(d:DisplayObject):ITween
        {
            return BetweenAS3.serial(
//                BetweenAS3.tween(d,{x:_MESS_X},{x:-134},0.1, Bounce.easeIn),
                BetweenAS3.tween(d,{x:_MESS_X},{x:_START_MESS_X},0.1, Bounce.easeIn),
//                BetweenAS3.to(d,{x:160},0.1),
                BetweenAS3.to(d,{alpha:1.0,_glowFilter:{blurX:10, blurY:10, color:0xFFFFFF}},0.2),
                BetweenAS3.delay(
                    BetweenAS3.to(d,{_glowFilter:{blurX:0, blurY:0, color:0xFFFFFF}},0.1),
                    1.0)
                
                );

        }
        private function createVanishTween(d:DisplayObject,num:int):ITween
        {
            return BetweenAS3.serial(BetweenAS3.tween(d,{x:_START_MESS_X},{x:_MESS_X},0.1, Quad.easeIn),
                                     BetweenAS3.func(_num.setBonus,[num]))

//             return  BetweenAS3.to(d,{x:0, alpha:0.0},0.2)


        }

    }

}


