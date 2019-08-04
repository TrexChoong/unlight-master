package view.scene.regist
{

    import flash.display.*;
    import flash.events.*;

    import mx.containers.*;
    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.CharaCard;
    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;
    import view.image.regist.*;
    import view.utils.*;
    import view.*;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

//    import model


    /**
     *カード選択クラス
     *
     */


    public class CardSelector extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_EVA		:String = "野心をもった知謀に優れる帝國騎士";
        CONFIG::LOCALE_JP
        private static const _TRANS_GRU		:String = "暗く破滅的な衝動にとりつかれた黒き王子";
        CONFIG::LOCALE_JP
        private static const _TRANS_ABEL	:String = "力を求め世界をさまよう剣聖の息子";
        CONFIG::LOCALE_JP
        private static const _TRANS_SHELI	:String = "闇に生きる不滅の人形";
        CONFIG::LOCALE_JP
        private static const _TRANS_EIN		:String = "失った光を取り戻すために戦う異界の少女";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "カードを一枚選択してください";

        CONFIG::LOCALE_EN
        private static const _TRANS_EVA		:String = "An ambitious and surpassingly resourceful imperial knight.";
        CONFIG::LOCALE_EN
        private static const _TRANS_GRU		:String = "An evil prince who indulges disturbing and destructive impulses.";
        CONFIG::LOCALE_EN
        private static const _TRANS_ABEL	:String = "The son of a great swordsman, traveling the world in search of power.";
        CONFIG::LOCALE_EN
        private static const _TRANS_SHELI	:String = "Immortal automatons that live in the dark.";
        CONFIG::LOCALE_EN
        private static const _TRANS_EIN		:String = "Young girl from another world fighting the recollect the fading light.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "Please select a card.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_EVA		:String = "雄心壯志，智勇雙全的帝國騎士。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_GRU		:String = "受毀滅衝動所控制的黑暗王子。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ABEL	:String = "追求力量，流浪世界的劍聖之子。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SHELI	:String = "存在於黑暗裡的不滅人偶";
        CONFIG::LOCALE_TCN
        private static const _TRANS_EIN		:String = "為了奪回失去的光明而戰的異界少女";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "請選擇一張卡片。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_EVA		:String = "拥有雄心壮志的足智多谋的帝国骑士。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_GRU		:String = "被黑暗的破灭性冲动所控制的黑暗王子。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ABEL	:String = "为寻求力量而游走世界的剑圣之子。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SHELI	:String = "存在于黑暗里的不灭人偶";
        CONFIG::LOCALE_SCN
        private static const _TRANS_EIN		:String = "为了夺回失去的光明而战的异界少女";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "请选择1张卡片。";

        CONFIG::LOCALE_KR
        private static const _TRANS_EVA		:String = "야심을 가진 지략에 뛰어난 제국 기사.";
        CONFIG::LOCALE_KR
        private static const _TRANS_GRU		:String = "어둡고 파멸적인 행동에 미료된 검은 왕자.";
        CONFIG::LOCALE_KR
        private static const _TRANS_ABEL	:String = "힘을 손에 넣기 위해 세상을 방황하는 검성의 아들.";
        CONFIG::LOCALE_KR
        private static const _TRANS_SHELI	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_EIN		:String = "失った光を取り戻すために戦う異界の少女";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "카드를 한장 선택해 주십시오.";

        CONFIG::LOCALE_FR
        private static const _TRANS_EVA		:String = "Chevalier intelligent et ambitieux";
        CONFIG::LOCALE_FR
        private static const _TRANS_GRU		:String = "Prince obsédé par de sombres désirs destructeurs.";
        CONFIG::LOCALE_FR
        private static const _TRANS_ABEL	:String = "Fils du plus puissant des escrimeurs de ce monde, voyageant pour aiguiser sa technique";
        CONFIG::LOCALE_FR
        private static const _TRANS_SHELI	:String = "Jeune fille d'un monde parallèle combattant pour retrouver la Lumière perdue.";
        CONFIG::LOCALE_FR
        private static const _TRANS_EIN		:String = "Jeune fille d'un monde parallèle combattant pour retrouver la Lumière perdue.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Sélectionnez une Carte";

        CONFIG::LOCALE_ID
        private static const _TRANS_EVA		:String = "野心をもった知謀に優れる帝國騎士。";
        CONFIG::LOCALE_ID
        private static const _TRANS_GRU		:String = "暗く破滅的な衝動にとりつかれた黒き王子。";
        CONFIG::LOCALE_ID
        private static const _TRANS_ABEL	:String = "力を求め世界をさまよう剣聖の息子。";
        CONFIG::LOCALE_ID
        private static const _TRANS_SHELI	:String = "力を求め世界をさまよう剣聖の息子。";
        CONFIG::LOCALE_ID
        private static const _TRANS_EIN		:String = "失った光を取り戻すために戦う異界の少女";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "カードを一枚選択してください";

        CONFIG::LOCALE_TH
        private static const _TRANS_EVA     :String = "อัศวินประจำอาณาจักรผู้เฉลียวฉลาดและทะเยอทะยาน";
        CONFIG::LOCALE_TH
        private static const _TRANS_GRU     :String = "เจ้าชายนิลกาฬผู้ถูกครอบงำด้วยแรงกระตุ้นที่ดำมืด";
        CONFIG::LOCALE_TH
        private static const _TRANS_ABEL    :String = "บุตรของเทพแห่งดาบที่หลงวนเวียนอยู่ในโลกแห่งกำลัง";
        CONFIG::LOCALE_TH
        private static const _TRANS_SHELI	:String = "力を求め世界をさまよう剣聖の息子。";
        CONFIG::LOCALE_TH
        private static const _TRANS_EIN		:String = "失った光を取り戻すために戦う異界の少女";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "กรุณาเลือกการ์ด 1 ใบ";


        private static const CARD_X:int = 172;
        private static const CARD_Y:int = 208;
        private static const CARD_SPACE:int = 192;

        // ヘルプ用のステート
        private static const _GAME_HELP:int = 0;

        private var _bg:CardSelectorBG = new CardSelectorBG();

        private var _charas:CharaSelectImage = new CharaSelectImage();

        private var _selectedCard:int = -1; /* of Int */

        // private var _registCardList:Array; /* of CharaCard */
        // private var _CCCList:Array =[]; /* of CharaCardClip */

        private var _introTexts:Array = [new Text(), new Text(), new Text(), new Text(), new Text()]; /* of Text */

        // 初期カードの解説（上記HELPステート分必要）
        private var  _introTextArray:Array =
            [
                [_TRANS_EVA],
                [_TRANS_GRU],
                [_TRANS_ABEL],
                [_TRANS_SHELI],
                [_TRANS_EIN],
            ];


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["カードを一枚選択してください"],
                [_TRANS_MSG],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private  var _toolTipOwnerArray:Array = [];


        // 初期リストは登録済み？
       private var _registed:Boolean =false;

        /**
         * コンストラクタ
         *
         */

        public function CardSelector()
        {
            super();
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  // 本体
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
            var registCardList:Array = [0,1,2,3,4];
            // ****** ここでカードからレジスト用カードリストをもらって更新する
//            log.writeLog(log.LV_FATAL, this, "++ 7", _registed);
            // _charas.getShowThread(this).start();
             // if (_registed==false)
             // {
                 var sExec:SerialExecutor = new SerialExecutor();
                 var c:ClousureThread = new ClousureThread(registCardsLoad);
                 sExec.addThread(_charas.getShowThread(this));
                 sExec.addThread(c);

                 sExec.start();
                 sExec.join();
             //    _registed = true;
             // }
            _bg.cardFrames[0].addEventListener(MouseEvent.CLICK, card1ClickHandler);
            _bg.cardFrames[1].addEventListener(MouseEvent.CLICK, card2ClickHandler);
            _bg.cardFrames[2].addEventListener(MouseEvent.CLICK, card3ClickHandler);
            _bg.cardFrames[3].addEventListener(MouseEvent.CLICK, card4ClickHandler);
            _bg.cardFrames[4].addEventListener(MouseEvent.CLICK, card5ClickHandler);
            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
            _bg.cardsOn(-1);
            textOn(-1);

        }

        public override function final():void
        {
            // _CCCList.forEach(function(item:CharaCardClip, index:int, array:Array):void{item.getHideThread().start();});
            RemoveChild.all(this);
            _bg.cardFrames[0].removeEventListener(MouseEvent.CLICK, card1ClickHandler);
            _bg.cardFrames[1].removeEventListener(MouseEvent.CLICK, card2ClickHandler);
            _bg.cardFrames[2].removeEventListener(MouseEvent.CLICK, card3ClickHandler);
            _bg.cardFrames[3].removeEventListener(MouseEvent.CLICK, card4ClickHandler);
            _bg.cardFrames[4].removeEventListener(MouseEvent.CLICK, card5ClickHandler);
        }

        private function registCardsLoad():void
        {
            for(var i:int = 0; i < _introTexts.length; i++){
                _introTexts[i].x = 490;
                _introTexts[i].y = 542;;
                _introTexts[i].width = 280;
                _introTexts[i].height = 100;
                _introTexts[i].styleName = "RegistCharaCardInfoLabel";
                _introTexts[i].text = _introTextArray[i];
                addChild(_introTexts[i]);
            }

        }

        private function textOn(index:int):void
        {
            for(var i:int = 0; i < _introTexts.length; i++)
            {
                if (i == index)
                {
                    BetweenAS3.parallel
                        (
                            BetweenAS3.tween(_charas.cardFrames[i],
                                             {alpha:1.0},
                                             null,
                                             0.1,
                                             BeTweenAS3Thread.EASE_IN_QUAD
                                ),
                            BetweenAS3.tween(_introTexts[i],
                                             {alpha:1.0},
                                             null,
                                             0.1,
                                             BeTweenAS3Thread.EASE_IN_QUAD
                                )
                            ).play();
                }
                else
                {
                    BetweenAS3.parallel
                        (
                            BetweenAS3.tween(_charas.cardFrames[i],
                                             {alpha:0.0},
                                             null,
                                             0.1,
                                             BeTweenAS3Thread.EASE_IN_QUAD
                                ),
                            BetweenAS3.tween(_introTexts[i],
                                             {alpha:0.0},
                                             null,
                                             0.1,
                                             BeTweenAS3Thread.EASE_IN_QUAD
                                )
                            ).play();
                }
            }
        }

        // 選んだカードのIDを返す
        public function get selectedCard():int
        {
            return _selectedCard;

        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _selectedCard = -1;
            _depthAt = at;
            var pExec:ParallelExecutor = new ParallelExecutor();744
            var sExec:SerialExecutor = new SerialExecutor();
            pExec.addThread(_bg.getShowThread(this, 0));
            sExec.addThread(pExec);
            sExec.addThread(super.getShowThread(stage,at,type));
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return sExec;
        }

        // 消去のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.15, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            sExec.addThread(super.getHideThread());
            return sExec;
        }

        private function card1ClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "clic");
            _bg.cardsOn(0);
            textOn(0);
            _bg.cardsNormal(1);
            _bg.cardsNormal(2);
            _bg.cardsNormal(3);
            _bg.cardsNormal(4);
            _charas.charasOn(0);
            _selectedCard = 1;
        }

        private function card2ClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "clic");
            _bg.cardsNormal(0);
            _bg.cardsOn(1);
            textOn(1);
            _bg.cardsNormal(2);
            _bg.cardsNormal(3);
            _bg.cardsNormal(4);
            _charas.charasOn(1);
            _selectedCard = 21;
        }

        private function card3ClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "clic");
            _bg.cardsNormal(0);
            _bg.cardsNormal(1);
            _bg.cardsOn(2);
            textOn(2);
            _bg.cardsNormal(3);
            _bg.cardsNormal(4);
            _charas.charasOn(2);
            _selectedCard = 31;
        }

        private function card4ClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "clic");
            _bg.cardsNormal(0);
            _bg.cardsNormal(1);
            _bg.cardsNormal(2);
            _bg.cardsOn(3);
            textOn(3);
            _bg.cardsNormal(4);
            _charas.charasOn(3);
            _selectedCard = 101;
        }

        private function card5ClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "clic");
            _bg.cardsNormal(0);
            _bg.cardsNormal(1);
            _bg.cardsNormal(2);
            _bg.cardsNormal(3);
            _bg.cardsOn(4);
            textOn(4);
            _charas.charasOn(4);
            _selectedCard = 111;
        }



    }

}

