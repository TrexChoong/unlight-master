package view.scene.game
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.tweener.TweenerThread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Duel;
    import view.scene.BaseScene;
    import view.image.game.*;


    import controller.*;

    /**
     * ポジション表示クラス
     *
     */

    public class PositionArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_RANGE	:String = "プレイヤー同士の距離です。\n様々なアクションに影響します。";

        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_RANGE	:String = "The distance between players.\nThis affects various things, such as which attack cards you can play.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_RANGE	:String = "玩家之間的距離。\n影響各種行動。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_RANGE	:String = "玩家之间的距离。\n对各种行动有影响。";

        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_RANGE	:String = "플레이어 동시의 거리입니다.\n각종 액션에 영향을 미칩니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_RANGE	:String = "Distance séparant les joueurs.\nCette distance déterminera les actions possibles.";

        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_RANGE	:String = "プレイヤー同士の距離です。\n様々なアクションに影響します。";

        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_RANGE  :String = "ระยะห่างระหว่างผู้เล่น มีผลต่อการเคลื่อนไหว";//"プレイヤー同士の距離です。\n様々なアクションに影響します。";


        public static const _DEFAULT_DIST:int = 2;
        public static const DEFAULT_PA_X:int = 847+59;
        public static const DEFAULT_PA_Y:int = 459+45;
        private static const A:Number = 0.3;
        public static const SCALE:Number = 0.2;
        private static const  LABEL_X:int = 850;
        private static const  LABEL_Y:int = 462;
        private static const  LABEL_W:int = 60;
        private static const  LABEL_H:int = 60;

//        private var _BG:Shape = new Shape();
        private static const STAND:Array = ["<font size='24' color='#ff0000'>S</font>hort", "<font size='24' color='#11ee11'>M</font>iddle", "<font size='24' color='#11ee11'>L</font>ong"]; /* of String */

        //ポジション
//         private var _positionStage:PositionStage = new PositionStage();
//         private var _positionStageLine:PositionStageLine = new PositionStageLine();
//         private var _positionEnemy:PositionEnemy = new PositionEnemy();
//         private var _positionPlayer:PositionPlayer  = new PositionPlayer(rightButtonHandler, leftButtonHandler);

        private var _rangeImage:RangeImage = new RangeImage();


        private var _container:UIComponent = new UIComponent();
        // イニシアチブ負けた場合の表示
//         private var _waitLabel:Label = new Label();
//         private var _waitPanel:Panel = new Panel();
        // イニシアチブに買った場合の表示
//         private var _label:Label = new Label();
//         private var _doneButton:DoneButton = new DoneButton();


        // 現在の距離
//         private var _standLabel:Label = new Label();

        private var _duel:Duel = Duel.instance;

  //       // 移動予定距離(2~-2)
//         private var _movingDistance:int;

//         // 現在の距離(1~3)
         private var _currentDistance:int;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["プレイヤー同士の距離です。\n様々なアクションに影響します。"],   // 0
                [_TRANS_HELP_RANGE],   // 0
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function PositionArea()
        {
            alpha = 0.0;
            visible = false;

             updateDistance(2);
            addChild(_rangeImage);

            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
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


        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            updateDistance(2);
            return  new ShowThread(this, stage);
        }


        public function updateDistance(dist:int):void
        {
            _currentDistance = dist;
            distanceAt();
        }

        private function distanceAt():void
        {

            switch (_currentDistance)
            {
            case 1:
                _rangeImage.onShort();
                break;
            case 2:
                _rangeImage.onMiddle();
                break;
             case 3:
                _rangeImage.onLong();
                break;
            case 4:
                _rangeImage.onHiding();
            default:
            }
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            return new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
        }

        // 実画面に表示するスレッドを返す
        public function getBringOffThread():Thread
        {
            return new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false );
        }

        // 隠すスレッドを返す
        public override function getHideThread(type:String = ""):Thread
        {
            alpha = 0;
            return super.getHideThread(type)
        }



    }

}
import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
import flash.events.Event;

import mx.core.UIComponent;
import mx.containers.*;
import mx.controls.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;
import org.libspark.thread.threads.tweener.TweenerThread;

import model.Duel;
import view.scene.game.PositionArea;
import view.scene.BaseScene;
import view.BaseShowThread;

// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(bs:BaseScene, stage:DisplayObjectContainer)
    {
        super(bs, stage)
    }

    protected override function run():void
    {
//        addStageAt();
        next(close);
    }
}


// Moveモードへ
class OnMovePhaseThread extends Thread
{
    private static const _TIME:Number = 0.3;
    private static const _X:int = 480;
    private static const _Y:int = 330;
    private static const _SCALE:Number = 0.7;

    private var _positionArea:UIComponent;
    private var  _onCompleteFunc:Function;

    public function OnMovePhaseThread(pa:UIComponent, func:Function)
    {
        _positionArea = pa;
        _onCompleteFunc = func;;
    }

    protected override function run():void
    {
//        var thread:Thread = new TweenerThread(_positionArea, { x:_X, y:_Y, scaleX: _SCALE, scaleY: _SCALE, transition:"easeOutSine", time: _TIME, show: true});
        var thread:Thread = new BeTweenAS3Thread(_positionArea, {x:_X ,y:_Y ,scaleX:_SCALE ,scaleY:_SCALE}, null, _TIME, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();
        next(setMove);
    }

    private function setMove():void
    {
        _onCompleteFunc();
    }
}
// MoveモードOFF
class OffMovePhaseThread extends Thread
{
    private static const _TIME:Number = 0.3;
//     private static const _X:int = 300;
//     private static const _Y:int = 330;
//    private static const _SCALE:Number = 0.7;

    private var _positionArea:UIComponent;
    private var  _onCompleteFunc:Function;

    public function OffMovePhaseThread(pa:UIComponent, func:Function)
    {
        _positionArea = pa;
        _onCompleteFunc = func;;
    }

    protected override function run():void
    {
//        var thread:Thread = new TweenerThread(_positionArea, { x:PositionArea.DEFAULT_PA_X, y:PositionArea.DEFAULT_PA_Y, scaleX: PositionArea.SCALE, scaleY: PositionArea.SCALE, transition:"easeOutSine", time: _TIME, show: true});
        var thread:Thread = new BeTweenAS3Thread(_positionArea, {x:PositionArea.DEFAULT_PA_X ,y:PositionArea.DEFAULT_PA_Y ,scaleX:PositionArea.SCALE ,scaleY:PositionArea.SCALE}, null, _TIME, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();
        next(setMove);
    }

    private function setMove():void
    {
        _onCompleteFunc();
    }
}

// 移動ポイントが０でポジション変更なしの場合のスレッド
class ThruPositionThread extends Thread
{
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_NOMOVE	:String = "移動ポイント０のため移動はありません";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_NOMOVE	:String = "You cannot move because you have no movement points.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_NOMOVE	:String = "移動點數為0，沒有移動。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_NOMOVE	:String = "移动点数为0，无法移动。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_NOMOVE	:String = "이동 포인트가 0이기 때문에 이동을 할 수 없습니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_NOMOVE	:String = "Point de Déplacement 0. Vous ne pouvez pas vous déplacer.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_NOMOVE	:String = "移動ポイント０のため移動はありません";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_NOMOVE  :String = "ไม่สามารถเคลื่อนที่ได้เนื่องจากแต้มเคลื่อนที่เป็น 0";//"移動ポイント０のため移動はありません";


    private var _label:Label;
    private var _duel:Duel = Duel.instance;
    private var _panel:Sprite;
    private var  _onCompleteFunc:Function;

    public function ThruPositionThread(panel:Sprite, label:Label, func:Function)
    {
        _panel = panel;
        _label = label;
        _onCompleteFunc = func;
    }

    protected override function run():void
    {
        next(repeat);
    }

    private function repeat():void
    {
        _panel.visible = true;
//        var textTween:Thread = new TweenerThread(_label, { _text: "移動ポイント０のため移動はありません", delay:0.2, transition:"easeOutSine", time: 1.0} );
        var textTween:Thread = new TweenerThread(_label, { _text: _TRANS_MSG_NOMOVE, delay:0.2, transition:"easeOutSine", time: 1.0} );
        _label.text = "";
        textTween.start();
        textTween.join();
        next(waiting);
    }
    private function waiting():void
    {
        sleep(2000);
        next(complete);
    }
    private function complete():void
    {
        _onCompleteFunc();
    }
}




// 相手の終了を待つスレッド
class OnWaitingThread extends Thread
{
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_WAIT	:String = "相手プレイヤの移動を待っています";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_WAIT	:String = "Waiting for opponent.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_WAIT	:String = "等待對方的移動。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_WAIT	:String = "等待对手的移动。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_WAIT	:String = "상대 플레이어의 이동을 기다리고 있습니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_WAIT	:String = "Attendez que votre adversaire ait bougé.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_WAIT	:String = "相手プレイヤの移動を待っています";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_WAIT    :String = "รอการเคลื่อนที่ของฝ่ายตรงข้าม";//"相手プレイヤの移動を待っています";


    private var _label:Label;;

    private var  _onCompleteFunc:Function;
    private var _duel:Duel = Duel.instance;

    public function OnWaitingThread(label:Label, func:Function)
    {
        _label = label;
        _onCompleteFunc = func;
    }

    protected override function run():void
    {
        next(repeat);
    }

    private function repeat():void
    {
//        var textTween:Thread = new TweenerThread(_label, { _text: "相手プレイヤの移動を待っています", delay:0.2, transition:"easeOutSine", time: 1.0} );
        var textTween:Thread = new TweenerThread(_label, { _text: _TRANS_MSG_WAIT, delay:0.2, transition:"easeOutSine", time: 1.0} );
        _label.text = "";
        textTween.start();
//        event(_duel, Duel.MOVE_PHASE_FINISH,finish);
    }

//         textTween.join();
//         if (_duel.state == Duel.MOVE)
//         {
//         }
//         else
//         {
//             next(repeat);
//         }

    private function finish(e:Event):void
    {
        _onCompleteFunc();
    }

}
