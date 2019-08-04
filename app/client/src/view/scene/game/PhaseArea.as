package view.scene.game
{
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import controller.*;

    import model.Duel;
    import model.Entrant;
    import view.utils.*;
    import view.image.game.PhaseImage;
    import view.scene.BaseScene;
    import view.ClousureThread;


    /**
     * PhaseArea
     * 対戦時のアバターをまとめて管理する
     *
     */

    public class PhaseArea  extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_PHASE_DROW	:String = "現在はドローフェイズです。\n手札が５枚になるまでカードをドローします。";
        CONFIG::LOCALE_JP
        private static const _TRANS_PHASE_MOVE	:String = "現在は移動フェイズです。\n移動アクションが使用できます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_PHASE_ATK	:String = "現在は攻撃フェイズです。\n攻撃アクションが使用できます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_PHASE_DEF	:String = "現在は防御フェイズです。\n防御アクションが使用できます。";

        CONFIG::LOCALE_EN
        private static const _TRANS_PHASE_DROW	:String = "It is currently the Draw Phase.\nDraw until you have 5 cards in your hand.";
        CONFIG::LOCALE_EN
        private static const _TRANS_PHASE_MOVE	:String = "It is currently the Movement Phase.\nYou can play action cards.";
        CONFIG::LOCALE_EN
        private static const _TRANS_PHASE_ATK	:String = "It is currently the Attack Phase.\nYou can play attack cards.";
        CONFIG::LOCALE_EN
        private static const _TRANS_PHASE_DEF	:String = "It is currently the Defense Phase.\nYou can play defense cards.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_PHASE_DROW	:String = "現在是抽牌階段。\n可將手牌抽滿5張。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PHASE_MOVE	:String = "現在是移動階段態。\n可以使用移動卡。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PHASE_ATK	:String = "現在攻擊階段。\n可以使用攻擊卡。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PHASE_DEF	:String = "現在是防禦階段。\n可以使用防禦卡。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_PHASE_DROW	:String = "现在是抽卡环节。\n可抽取至手上满5张为止。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PHASE_MOVE	:String = "现在是移动环节。\n可使用行动卡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PHASE_ATK	:String = "现在是攻击环节。\n可使用攻击卡。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PHASE_DEF	:String = "现在是防御环节。\n可使用防御卡。";

        CONFIG::LOCALE_KR
        private static const _TRANS_PHASE_DROW	:String = "현재는 드로우페이즈 입니다.\n들고 있는 카드가 5장이 될때까지 카드를 드로우합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_PHASE_MOVE	:String = "현재는 이동페이즈 입니다.\n이동 액션을 사용할 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_PHASE_ATK	:String = "현재는 공격페이즈 입니다.\n공격 액션을 사용할 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_PHASE_DEF	:String = "현재는 방어페이즈 입니다.\n방어 액션을 사용할 수 있습니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_PHASE_DROW	:String = "Phase de Choix.\nTirez 5 cartes.";
        CONFIG::LOCALE_FR
        private static const _TRANS_PHASE_MOVE	:String = "Phase de Déplacement.\nUtilisez vos cartes de Déplacement.";
        CONFIG::LOCALE_FR
        private static const _TRANS_PHASE_ATK	:String = "Phase d'Attaque.\nUtilisez vos cartes d'Attaque.";
        CONFIG::LOCALE_FR
        private static const _TRANS_PHASE_DEF	:String = "Phase de Défense.\nUtilisez vos cartes de Défense.";

        CONFIG::LOCALE_ID
        private static const _TRANS_PHASE_DROW	:String = "現在はドローフェイズです。\n手札が５枚になるまでカードをドローします。";
        CONFIG::LOCALE_ID
        private static const _TRANS_PHASE_MOVE	:String = "現在は移動フェイズです。\n移動アクションが使用できます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_PHASE_ATK	:String = "現在は攻撃フェイズです。\n攻撃アクションが使用できます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_PHASE_DEF	:String = "現在は防御フェイズです。\n防御アクションが使用できます。";

        CONFIG::LOCALE_TH
        private static const _TRANS_PHASE_DROW  :String = "ขั้นตอนจั่วไพ่ จะจั่วไพ่จนกว่าจะครบ 5 ใบ";//"現在はドローフェイズです。\n手札が５枚になるまでカードをドローします。";
        CONFIG::LOCALE_TH
        private static const _TRANS_PHASE_MOVE  :String = "ขั้นตอนการเคลื่อนที่ ท่านสามารถใช้การ์ดเคลื่อนที่ได้ในขั้นตอนนี้";//"現在は移動フェイズです。\n移動アクションが使用できます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_PHASE_ATK   :String = "ขั้นตอนการโจมตี ท่านสามารถใช้การ์ดโจมตีได้ในขั้นตอนนี้";//"現在は攻撃フェイズです。\n攻撃アクションが使用できます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_PHASE_DEF   :String = "การป้องกัน ท่านสามารถใช้การ์ดป้องกันได้ในขั้นตอนนี้";//"現在は防御フェイズです。\n防御アクションが使用できます。";


        // ゲームのコントローラー

        // デュエルインスタンス
        private var _duel:Duel;

        // フェイズオブジェクト
        private var _phaseImage:PhaseImage = new PhaseImage();

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [""],
//                ["現在はドローフェイズです。\n手札が５枚になるまでカードをドローします。"],
//                ["現在は移動フェイズです。\n移動アクションが使用できます。"],
//                ["現在は攻撃フェイズです。\n攻撃アクションが使用できます。"],
//                ["現在は防御フェイズです。\n防御アクションが使用できます。"],
                [_TRANS_PHASE_DROW],
                [_TRANS_PHASE_MOVE],
                [_TRANS_PHASE_ATK],
                [_TRANS_PHASE_DEF],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _DEFAULT_HELP:int  = 0;
        private const _DRAW_HELP:int     = 1;
        private const _MOVE_HELP:int     = 2;
        private const _ATTACK_HELP:int   = 3;
        private const _DEFFENCE_HELP:int = 4;

        // フェイズ進行のカウンタ
        private var _counter:int = 0;


        /**
         * コンストラクタ
         *
         */
        public function PhaseArea()
        {
//            Unlight.GCW.watch(this);
            alpha = 0.0;
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,_phaseImage]);  //
        }

        //
        protected override function get helpTextArray():Array
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {
            _duel = Duel.instance;
            _duel.addEventListener(Duel.REFILL_PHASE, toRefillHandler);
            _duel.addEventListener(Duel.MOVE_CARD_DROP_PHASE_START,toMoveHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_ATTACK_PHASE_START, toAttackHandler);
            _duel.addEventListener(Duel.BATTLE_CARD_DROP_DEFFENCE_PHASE_START, toDeffenceHandler);

            _duel.addEventListener(Duel.BATTLE_CARD_DROP_WAITING_PHASE_START, toWaitingHandler);

            _duel.addEventListener(Duel.DETERMINE_BATTLE_POINT_PHASE, toBlankHandler);

            _phaseImage.init();
            addChild(_phaseImage);
            initilizeToolTipOwners();
            updateHelp(_DEFAULT_HELP);
        }


        public override function final():void
        {
            _duel.removeEventListener(Duel.REFILL_PHASE, toRefillHandler);
            _duel.removeEventListener(Duel.MOVE_CARD_DROP_PHASE_START,toMoveHandler);
            _duel.removeEventListener(Duel.BATTLE_CARD_DROP_ATTACK_PHASE_START, toAttackHandler);
            _duel.removeEventListener(Duel.BATTLE_CARD_DROP_DEFFENCE_PHASE_START, toDeffenceHandler);

            _duel.removeEventListener(Duel.BATTLE_CARD_DROP_WAITING_PHASE_START, toWaitingHandler);
            _duel.removeEventListener(Duel.DETERMINE_BATTLE_POINT_PHASE, toBlankHandler);
            _phaseImage.final();
            _toolTipOwnerArray = [];
            RemoveChild.apply(_phaseImage);
        }

        private function toBlankHandler(e:Event):void
        {
            updateHelp(_DEFAULT_HELP);
        }

        private function toRefillHandler(e:Event):void
        {
            _counter = 0;
            GameCtrl.instance.addViewSequence(SE.getPhaseSEThread(0));
            GameCtrl.instance.addViewSequence(new ClousureThread( _phaseImage.onRefill));
            updateHelp(_DRAW_HELP);
        }

        private function toMoveHandler(e:Event):void
        {
            _phaseImage.onMove();
            GameCtrl.instance.addViewSequence(SE.getPhaseSEThread(0));
            updateHelp(_MOVE_HELP);
        }

        private function toAttackHandler(e:Event):void
        {
            _phaseImage.battlePhaseUpdate(0,_duel.initi);
            GameCtrl.instance.addViewSequence(SE.getPhaseSEThread(0));
            updateHelp(_ATTACK_HELP);
        }
        private function toDeffenceHandler(e:Event):void
        {
            _phaseImage.battlePhaseUpdate(1,_duel.initi);
            GameCtrl.instance.addViewSequence(SE.getPhaseSEThread(0));
            updateHelp(_DEFFENCE_HELP);
        }


        private function toWaitingHandler(e:Event):void
        {
            // 最初のWaitingPhaseでかつ、負けていれば
            if (_counter == 0&&!(_duel.initi))
            {
                _phaseImage.onDeffenceSecond();
                updateHelp(_DEFFENCE_HELP);
            }
            // 二回目のWaitingPhaseで勝っていれば
            else if (_counter == 1&&_duel.initi)
            {
                _phaseImage.onDeffenceFirst();
                updateHelp(_DEFFENCE_HELP);
            }
            _counter ++;
        }


        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage);
        }

        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            alpha = 0;
            return new HideThread(this);
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



    }

}

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.scene.game.PhaseArea;
import view.BaseShowThread;
import view.BaseHideThread;

import model.Duel;

// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(pa:PhaseArea, stage:DisplayObjectContainer)
    {
        super(pa, stage);
    }

    protected override function run():void
    {
        // デュエルの準備を待つ
        if (Duel.instance.inited == false)
        {
            Duel.instance.wait();
        }

        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(pa:PhaseArea)
    {
        super(pa);
    }
}
