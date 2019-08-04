
package view.scene.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.core.UIComponent;
    import mx.controls.*

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.AvatarItemEvent;

    import view.*;
    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.utils.*;
    import view.image.game.*;
    import view.scene.item.WindowItemListPanel;
    import controller.*;

    /**
     * 結果表示クラス
     *
     */
    public class ResultScene extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_WL	:String = "勝敗結果です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_GETCARD	:String = "手に入れることの出来るカードです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_WL	:String = "Outcome of the battle.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_GETCARD	:String = "Cards you can collect.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_WL	:String = "對戰結果。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_GETCARD	:String = "可以獲得的卡片。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_WL	:String = "胜负结果。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_GETCARD	:String = "可获得的卡片。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_WL	:String = "승부 결과 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_GETCARD	:String = "입수 가능한 카드입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_WL	:String = "Résultat";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_GETCARD	:String = "Vous pouvez obtenir cette carte.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_WL	:String = "勝敗結果です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_GETCARD	:String = "手に入れることの出来るカードです。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_WL  :String = "ผลการต่อสู้";//"勝敗結果です。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_GETCARD :String = "การ์ดที่สามารถครอบครองได้";//"手に入れることの出来るカードです。";


        private static const _FRAME_X:int = 0;                                    // 最終結果表示の枠組みX
        private static const _FRAME_Y:int = 5;                                    // 最終結果表示の枠組みY

        protected static const _IMAGE_X:int = Unlight.WIDTH/2;                                  // Win/Lose表示X
        protected static const _IMAGE_Y:int = 250;                                  // Win/Lose表示Y

        private static const _CCC_X:int = 296;                                    // 取得決定カードX
        private static const _CCC_Y:int = 335;                                    // 取得決定カードY*
        private static const _CCC_NUM_X:int = 296;                                // 取得カードの枚数X -30
        private static const _CCC_NUM_Y:int = 293;                                // 取得カードの枚数Y -43

        private static const _NEXT_CARD_X:int = 480;                              // 取得したカードのX位置
        private static const _NEXT_CARD_Y:int = 455;                              // 取得したカードのY位置*
        private static const _NEXT_CARD_OFFSET_X:int = 86;                        // 取得したカードのXずれ
        private static const _NEXT_CARD_NUM_X:int = 393;                          // 取得したカードのX位置
        private static const _NEXT_CARD_NUM_Y:int = 432;                          // 取得したカードのY位置+120
        private static const _NEXT_CARD_NUM_OFFSET_X:int = 86;                    // 取得したカードのXずれ
        private static const _NEXT_CARD_SCALE:Number = 0.5;                       // 取得したカードのサイズ

        private static const _PREV_CARD_X:int = 195;                              // 破棄したカードのX位置
        private static const _PREV_CARD_Y:int = _NEXT_CARD_Y;                     // 破棄したカードのY位置
        private static const _PREV_CARD_OFFSET_X:int = 86;                        // 破棄したカードのXずれ
        private static const _PREV_CARD_NUM_X:int = 107;                          // 取得したカードのX位置
        private static const _PREV_CARD_NUM_Y:int = _NEXT_CARD_NUM_Y;              // 取得したカードのY位置
        private static const _PREV_CARD_NUM_OFFSET_X:int = 86;                    // 取得したカードのXずれ
        private static const _PREV_CARD_SCALE:Number = 0.5;                       // 取得したカードのサイズ
        private static const _PREV_CARD_MAX:int = 3;                              // 通過したカードの最大記憶数


        private static const _LABEL_WIDTH:int = 170;                              // ラベルの幅
        private static const _LABEL_HEIGHT:int = 40;                              // ラベルの高さ

        private static const _RESULT_BUTTON_X:int = 576;                          // 終了ボタンX
        private static const _RESULT_BUTTON_Y:int = 600;                          // 終了ボタンY
        protected static const _FIN_RESULT_BUTTON_X:int = 576;                          // 終了ボタンX
        protected static const _FIN_RESULT_BUTTON_Y:int = 600;                          // 終了ボタンY

        protected static const _WIN:int = 0;                                        // 勝ち
        protected static const _LOSE:int = 1;                                       // 負け
        protected static const _DRAW:int = 2;                                       // 引き分け

        private static const _CCC_DIST_X:int = 296;                                    // 取得決定カードX
        private static const _CCC_DIST_Y:int = 190;                                    // 取得決定カードY
        private static const _CCC_DIST_NUM_X:int = 315;                                // 取得カードの枚数X
        private static const _CCC_DIST_NUM_Y:int = 408;                                // 取得カードの枚数Y

        private static const _RESULT_SCENE_SPEED:int = Unlight.SPEED + 4;              // アニメーション倍速

        // private static const _CCC_DIST_X:int = 80;                                    // 取得決定カードX
        // private static const _CCC_DIST_Y:int = 408;                                    // 取得決定カードY
        // private static const _CCC_DIST_NUM_X:int = 110;                                // 取得カードの枚数X
        // private static const _CCC_DIST_NUM_Y:int = 616;                                // 取得カードの枚数Y




        protected var _result:int = -1;                                             // 試合結果 0.win 1.lose 2.draw
        protected var _gems:int = 0;                                                // 取得gem:Total
        protected var _exp:int = 0;                                                 // 取得exp:Total

        protected var _baseGems:int  = 0;                                           // Gem:Base
        protected var _gemsPower:int = 0;                                           // Gem:Power
        protected var _baseExp:int   = 0;                                           // Exp:Base
        protected var _expBonus:int  = 0;                                           // Exp:Bonus
        protected var _expPower:int  = 0;                                           // Exp:Power

        protected var _gemsCardPower:int = 100;                                     // Gem:CardPower:初期値100％
        protected var _expCardPower:int  = 100;                                     // Exp:CardPower:初期値100％

        protected var _resultImage:ResultImage;                                     // win/lose表示
        protected var _resultRollImage:ResultRollImage = new ResultRollImage();     // success/failed表示

        protected var _fade:Shape = new Shape();                                    // フェード
        protected var _frame:ResultFrame = new ResultFrame();                       // リザルトの最後の画面のベースを表示
        protected var _frameContainer:UIComponent = new UIComponent();              // リザルトの最後の画面の数字

//        protected var _stepLabel:Label = new Label();                               // ステップ数
        protected var _resultStep:ResultStepImage = new ResultStepImage();           // ステップ数

        private var _ccc:*;                                                       // 取得カード
        private var _cccNum:Label;                                                // 取得カード枚数
        private var _nextCards:Array = [];                                        // Array of CharaCardClip 取得候補カード表示
        private var _nextCardsNum:Array = [];                                     // Array of Label 取得候補カードの枚数表示
        private var _prevCards:Array = [];                                        // Array of CharaCardClip 取得候補カード表示
        private var _prevCardsNum:Array = [];                                     // Array of Label 取得候補カードの枚数表示

        protected var _cardFrame:ResultCardFrame = new ResultCardFrame();         //
        protected var _standChara:StandCharaImage;                                // キャラの立ち絵
        protected var _levelUpImage:ResultAvatarLevelUpImage = new ResultAvatarLevelUpImage();


        protected var _resultButton:ResultButton = new ResultButton();            // 終了ボタン

        private var _resultDiceManager:ResultDiceManager;                         // リザルトダイス
        private var _nextDiceNum:int;                                             // 次回のダイス

        protected var _container:UIComponent = new UIComponent();                 // 描画コンテナ
        private var _cardsContainer:UIComponent = new UIComponent();              // 描画コンテナ

        protected var _reward:Reward;                                               // 報酬取得クラス

        private static const URL:String = "/public/image/";
        protected var _duel:Duel = Duel.instance;

        // アバターアイテムのビュー
//        private var _itemList:AvatarItemList = new AvatarItemList(AvatarItemList.MODE_USE, AvatarItemList.TAB_DUEL);
        private var _itemList:WindowItemListPanel;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
////                ["勝敗結果です。"],   // 0
//                [_TRANS_MSG_WL],   // 0
//                ["手に入れることの出来るカードです。"],   //
                [_TRANS_MSG_GETCARD],   //
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int = 0;

        protected var _levelupCount:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function ResultScene()
        {
            // フェード用シェイプ
            _fade.alpha = 0.0;
            _fade.graphics.beginFill(0x000000);
            _fade.graphics.drawRect(0, 0, 1024, 768);
            _fade.visible =false;

            // 外枠
            _frame.x = _FRAME_X;
            _frame.y = _FRAME_Y;
//            _frame.alpha = 0.0;

            // ラベルの設定
//             _stepLabel.styleName = "ResultLabel";
//             _stepLabel.x = 300;
//             _stepLabel.y = 20;
//             _stepLabel.width = _LABEL_WIDTH;
//             _stepLabel.height = _LABEL_HEIGHT;


            // 各種ボタンの初期化
            _resultButton.x = _RESULT_BUTTON_X;
            _resultButton.y = _RESULT_BUTTON_Y;
            _resultButton.buttonEnabled = false;
            _resultButton.visible = false;
            _resultButton.alpha = 0.0;

            // フレームの設定
//            _frame.visible = false;
//            _frame.alpha = 0.0;

            // ステージに入れる
            _container.addChild(_fade);
            _container.addChild(_frame);
            _container.addChild(_cardsContainer);
//            _container.addChild(_stepLabel);
            _container.addChild(_resultButton);
            _resultDiceManager = new ResultDiceManager(_container);
//            addChild(_container);

            // ヘルプの初期化
            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
//            _toolTipOwnerArray.push([0,_container]);  //
            _toolTipOwnerArray.push([0,_cardsContainer]);  //
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
        public function setReward(r:Reward):void
        {
            _reward = r;
            _reward.addEventListener(Reward.START, startHandler);
            _reward.addEventListener(Reward.UPDATE_BOTTOM_DICE, updateBottomDiceHandler);
            _reward.addEventListener(Reward.HIGH_LOW_WIN, highLowWinHandler);
            _reward.addEventListener(Reward.HIGH_LOW_LOSE, highLowLoseHandler);
            _reward.addEventListener(Reward.UPDATE_RESULT_DICE, resultDiceRollHandler);
            _reward.addEventListener(Reward.FINAL_RESULT, cancelResultHandler);
        }


        // 初期化処理
        public override function init():void
        {
            itemListInitialize();
            RealMoneyShopView.shopCloseButton.addEventListener(MouseEvent.CLICK, rmShopCloseclickHandler)
            _cardFrame.alpha = 0.0;
            _cardFrame.visible = false;

            _resultStep.alpha = 0.0;
            _resultStep.visible = false;
            _resultStep.mouseEnabled = false;

            _cardFrame.getShowThread(_container,10).start();
//            _itemList.getShowThread(_container,11).start();
            _resultStep.getShowThread(_container,11).start();
            _levelUpImage.getShowThread(_container,100).start();
//             _stepLabel.alpha = 1.0;

            // リザルトOKのイベント
            _resultButton.addEventListener(MouseEvent.CLICK,resultButtonHandler);
            _frame.addEventListener(ResultFrame.HIGH, pushUpButtonHandler);
            _frame.addEventListener(ResultFrame.LOW, pushDownButtonHandler);
            _frame.addEventListener(ResultFrame.NEXT, pushNextButtonHandler);
            _frame.addEventListener(ResultFrame.GET, pushCancelButtonHandler);
            _frame.addEventListener(ResultFrame.ITEM, pushItemButtonHandler);
            _frame.addEventListener(ResultFrame.EXIT, pushCancelButtonHandler);
            _resultRollImage.addEventListener(MouseEvent.MOUSE_OVER, resultRollMouseOverHandler);
            _resultRollImage.addEventListener(MouseEvent.MOUSE_OUT, resultRollMouseOutHandler);

            // _gemsPowLabel.htmlText = "100%" ;
            // _expPowLabel.htmlText = "100%" ;

            log.writeLog(log.LV_INFO, this, "init!!!!!!!!");
        }

        private function itemListInitialize():void
        {
            if (_itemList != null)
            {
                _itemList.y = 25;
                _itemList.x = -125;
                _itemList.alpha = 0.0;
                _itemList.visible = false;
                _itemList.getHideThread().start();

            }

            _itemList = new WindowItemListPanel();
            _itemList.setCloseHandler(closeItemlistHandler);

            // アイテムの初期化
            _itemList.x = -125;
            _itemList.y = 25;
            _itemList.alpha = 0.0;
            _itemList.visible = false;
            _itemList.getShowThread(_container,12).start();
        }

        private function rmShopCloseclickHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "++++++++++++shhop closeeee");
            itemListInitialize();
        }


        // 後処理
        public override function final():void
        {
            log.writeLog(log.LV_FATAL, this, "final!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            // アイテムを消す
            _itemList.getHideThread().start();
            _cardFrame.getHideThread().start();
            _resultStep.getHideThread().start();

            // フェードを消す
            _fade.alpha = 0.0;
            _fade.visible  = false;

            // WIN/LOSEを消す
            if (_resultImage != null)
            {
                _resultImage.getHideThread().start();
            }
            // フレーム表示とEXP・ジェムを消す
            _frame.visible  = false;
            _resultButton.visible = false;
//            _stepLabel.visible = false;

            _gems = 0;
            _exp = 0;

            // GET表示を消す
//            _getLabel.visible = false;

            // ボタンをけす
            _resultButton.buttonEnabled = false;

            // 立ちキャラを消す
            if(_standChara)
            {
                _standChara.getHideThread().start()
                RemoveChild.apply(_standChara);
                _standChara = null;
            }
//            log.writeLog(log.LV_FATAL, this, "2");

            // カードの枚数ラベルを消す
            if(_cccNum)
            {
                _cccNum.visible = false;
                _cccNum.text = "";
                _cccNum = null;
            }
            _nextCardsNum = [];
            _prevCardsNum = [];

            // 作られたキャラカードクリップを消す
            if(_ccc)
            {
                getHideCCCThread(_ccc).start();
                _ccc = null;
            }


            // ResultFrameを最初の状態にもどす
            _frame.frameReset();


            _nextCards = [];
            _prevCards = [];
//            log.writeLog(log.LV_FATAL, this, "3");

            // イベントをはずす
            _resultButton.removeEventListener(MouseEvent.CLICK,resultButtonHandler);
            _resultButton.removeEventListener(MouseEvent.CLICK,finishResultButtonHandler);
            _frame.removeEventListener(ResultFrame.HIGH, pushUpButtonHandler);
            _frame.removeEventListener(ResultFrame.LOW, pushDownButtonHandler);
            _frame.removeEventListener(ResultFrame.NEXT, pushNextButtonHandler);
            _frame.removeEventListener(ResultFrame.GET, pushCancelButtonHandler);
            _frame.removeEventListener(ResultFrame.ITEM, pushItemButtonHandler);
            _frame.removeEventListener(ResultFrame.EXIT, pushCancelButtonHandler);
            _resultRollImage.removeEventListener(MouseEvent.MOUSE_OVER, resultRollMouseOverHandler);
            _resultRollImage.removeEventListener(MouseEvent.MOUSE_OUT, resultRollMouseOutHandler);


            RealMoneyShopView.shopCloseButton.removeEventListener(MouseEvent.CLICK, rmShopCloseclickHandler)

            if (_reward !=null)
            {
            _reward.removeEventListener(Reward.START, startHandler);
            _reward.removeEventListener(Reward.UPDATE_BOTTOM_DICE, updateBottomDiceHandler);
            _reward.removeEventListener(Reward.HIGH_LOW_WIN, highLowWinHandler);
            _reward.removeEventListener(Reward.HIGH_LOW_LOSE, highLowLoseHandler);
            _reward.removeEventListener(Reward.UPDATE_RESULT_DICE, resultDiceRollHandler);
            _reward.removeEventListener(Reward.FINAL_RESULT, cancelResultHandler);

            }

            _levelUpImage.getHideThread().start();


//            RemoveChild.all(_container);
            RemoveChild.apply(_container);

//            log.writeLog(log.LV_FATAL, this, "4");
            log.writeLog(log.LV_INFO, this, "final!!!!!!!!");

            _itemList = null;
        }

        // キャラカードクリップがあればHideThreadを呼ぶ
        private function getHideCCCThread(ccc:*):Thread
        {
            if(ccc)
            {
                var sExec:SerialExecutor = new SerialExecutor();
//                sExec.addThread(new TweenerThread(ccc, {alpha:0.0, transition:"easeOutSine", time:0.5, hide:true}));
                sExec.addThread(new BeTweenAS3Thread(ccc, {alpha:0.0}, null, 0.5 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
                sExec.addThread(ccc.getHideThread());
                ccc.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
                ccc.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
                return sExec;
            }
            else
            {
                return new Thread();
            }
        }

        public function disposeObj():void
        {
            _frame.final();
            RemoveChild.apply(_frame);
            _frame = null;
            RemoveChild.apply(_resultButton);
            _resultButton = null;

        }

        // 挑戦決定ボタンハンドラ
        private function pushNextButtonHandler(e:Event):void
        {
            SE.playBonusClickSE();
            _reward.retry();
            // ビューの更新
            GameCtrl.instance.addViewSequence(_frame.getNextGameThread());
        }

        // アップボタンハンドラ
        private function pushUpButtonHandler(e:Event):void
        {
            _resultRollImage.getTempHideThread(0.0).start();
            SE.playBonusClickSE();
            _reward.up();
        }

        // ダウンボタンハンドラ
        private function pushDownButtonHandler(e:Event):void
        {
            _resultRollImage.getTempHideThread(0.0).start();
            SE.playBonusClickSE();
            _reward.down();

        }

        private function resultRollMouseOverHandler(e:MouseEvent):void
        {
            _resultRollImage.getTempHideThread(0.2).start();
        }

        private function resultRollMouseOutHandler(e:MouseEvent):void
        {
            _resultRollImage.getTempHideThread(1.0).start();
        }

        // キャンセルボタンハンドラ
        private function pushCancelButtonHandler(e:Event):void
        {
            SE.playBonusClickSE();
            // 確定
            _reward.cancel();
        }

        // アイテムボタンハンドラ
        private function pushItemButtonHandler(e:Event):void
        {
//            log.writeLog(log.LV_INFO, this, "push item!!!!",_itemList.parent, _itemList.visible, _itemList.x, _itemList.alpha, _resultStep.parent);
            log.writeLog(log.LV_INFO, this, "push item!!!!",_resultStep.mouseEnabled);
            SE.playBonusClickSE();

            // アイテムのビューを呼ぶ
            if(_itemList.visible)
            {
//                log.writeLog(log.LV_INFO, this, "push item!!!!",_itemList.parent, _itemList.visible, _itemList.x, _itemList.alpha, _resultStep.parent);
                new BeTweenAS3Thread(_itemList, {x:-250, alpha:0.0}, null, 0.3 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ).start();
            }
            else
            {
//                log.writeLog(log.LV_INFO, this, "push item!!!!",_itemList.parent, _itemList.visible, _itemList.x, _itemList.alpha, _resultStep.parent);
                new BeTweenAS3Thread(_itemList, {x:25, alpha:1.0}, null, 0.3 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ).start();
            }
        }
        // アイテムクローズ
        private function closeItemlistHandler():void
        {
            // アイテムのビューを呼ぶ
            if(_itemList&&_itemList.visible)
            {
                SE.playClick();
                new BeTweenAS3Thread(_itemList, {x:-250, alpha:0.0}, null, 0.3 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ).start();
            }
        }

        // アイテムボタンハンドラ
        private function useItemHandler(e:Event):void
        {
            SE.playClick();
            new BeTweenAS3Thread(_itemList, {x:-250, alpha:0.0}, null, 0.3 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ).start();
        }

        private function gemAndExpFade():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(_frame.fadeExpAndGem());
            pExec.addThread(new BeTweenAS3Thread(_resultButton, {alpha:0.0}, null, 0.2 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }


        // 最終リザルトOKボタン
        protected function resultButtonHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "resultButtonHandler!!");
            SE.playClick();
            GameCtrl.instance.addViewSequence(getInitRewardThread(_reward.gettedCards, _reward.cards1, _reward.cards2, _reward.cards3));
        }

        // 最終リザルトOKボタン
        protected function levelupResultButtonHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "levelupResultButtonHandler!!");
            SE.playClick();
            GameCtrl.instance.addViewSequence(getLevelUpThread());
        }

        // 最終リザルトOKボタン
        protected function finishResultButtonHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "finishResultButtonHandler!!");
            SE.playClick();
            _levelUpImage.hideAll();
            GameCtrl.instance.stopViewSequence();
            _resultButton.removeEventListener(MouseEvent.CLICK,resultButtonHandler);
        }

        // スタートハンドラ
        private function startHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "reward start !");
           addChild(_container);
            // フレームを初期化する
            _frame.initializeResult();
        }

        // 目標ダイスの値設定ハンドラ
        private function updateBottomDiceHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(getBottomDiceThread(_reward.bottomDice));
        }
        // 勝利ハンドラ
        private function highLowWinHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(SE.getBonusWinSEThread(0));
            GameCtrl.instance.addViewSequence(new SleepThread(100));
            GameCtrl.instance.addViewSequence(getRewardWinnerThread(_reward.cards3, _reward.bonus));
        }
        // 敗北ハンドラ
        private function highLowLoseHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(SE.getBonusLoseSEThread(0));
            GameCtrl.instance.addViewSequence(new SleepThread(100));
            GameCtrl.instance.addViewSequence(getRewardLoserThread());
        }
        // ダイスの結果ハンドラ
        private function resultDiceRollHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(getRewardResultDiceThread(_reward.resultDice));
        }
        // キャンセル（確定）ハンドラ
        protected function cancelResultHandler(e:Event):void
        {
            GameCtrl.instance.addViewSequence(getResultCancelThread(_reward.gettedCards,_reward.totalGems,_reward.totalExp,_reward.addPoint));

            // 取得カードがEXPやGEMの倍増カードならば倍率を更新する

        }

        // カードを見てその種類のオブジェクトとラベルと表示スレッドを作る
        private function getRewardCardClip(cards:Array):Array
        {
            var type:int = cards[0];
            var id:int = cards[1];
            var num:int = cards[2];

            var rewardObject:*;
            var label:Label = new Label();
            var thread:Thread;

            // 数量ラベルの初期化
            label.x = label.y = 0;
            label.width = _LABEL_WIDTH;
            label.height = _LABEL_HEIGHT;
            label.styleName = "ResultCardNumLabel";
            // カードを追加
            switch (type)
            {
              case Reward.EXP:
                  rewardObject = new ExpCardClip(num);
                  thread = ExpCardClip(rewardObject).getShowThread(_cardsContainer) ;
                  break;
              case Reward.GEM:
                  rewardObject = new GemCardClip(num);
                  thread = GemCardClip(rewardObject).getShowThread(_cardsContainer) ;
                  break;
              case Reward.ITEM:
                  rewardObject = new ItemCardClip(AvatarItem.ID(id));
                  label.text = "x" + num.toString();
                  thread = ItemCardClip(rewardObject).getShowThread(_cardsContainer) ;
                  break;
              case Reward.CARD:
                  rewardObject = new CharaCardClip(CharaCard.ID(id));
                  label.text = "x" + num.toString();
//                  log.writeLog(log.LV_FATAL, this, "add card", id);
                  thread = CharaCardClip(rewardObject).getRewardShowThread(_cardsContainer);
                  break;
              case Reward.RANDOM:
                  rewardObject = new CharaCardClip(CharaCard.ID(id));
                  label.text = "x" + num.toString();
//                  log.writeLog(log.LV_FATAL, this, "add card", id);
                  thread = CharaCardClip(rewardObject).getRewardShowThread(_cardsContainer);
                  break;
              case Reward.RARE:
                  rewardObject = new CharaCardClip(CharaCard.ID(id));
                  label.text = "x" + num.toString();
//                  log.writeLog(log.LV_FATAL, this, "add card", id);
                  thread = CharaCardClip(rewardObject).getRewardShowThread(_cardsContainer);
                  break;
              case Reward.EVENT_CARD:
                  rewardObject = new EventCardClip(EventCard.ID(id));
                  label.text = "x" + num.toString();
//                  log.writeLog(log.LV_FATAL, this, "add card", id);
                  thread = EventCardClip(rewardObject).getShowThread(_cardsContainer);
                  break;
              case Reward.WEAPON_CARD:
                  rewardObject = new WeaponCardClip(WeaponCard.ID(id));
                  label.text = "x" + num.toString();
//                  log.writeLog(log.LV_FATAL, this, "add card", id);
                  thread = WeaponCardClip(rewardObject).getShowThread(_cardsContainer);
                  break;
              default:
            }

//            log.writeLog(log.LV_FATAL, this, "object cards", rewardObject, label, thread);

            return [rewardObject, label, thread];
        }

        // 共通のリザルトスレッドを返す
        public function getResultThread(result:int, gems:int, exp:int, expBonus:int, gemsPow:int, expPow:int, totalGems:int, totalExp:int):Thread
        {
            // RMItemShopの更新が必要であれば行う
            RealMoneyShopView.itemReset();

            _result = result;

            // 表示スレッド
            var sExec:SerialExecutor = new SerialExecutor();

            _frame.showExpAndGem();
            // キャライメージ
            _standChara = new StandCharaImage(true, _duel.playerCharaCard.standImage);
            _standChara.x = -500;
            _standChara.y = 0;
            _standChara.visible = false;
            _standChara.getShowThread(_container,0);
            _container.addChildAt(_standChara, 1);

            // リザルトイメージ
            _resultImage = new ResultImage(ResultImage.RESULT_IDX[result]);
            _resultImage.x = _IMAGE_X;
            _resultImage.y = _IMAGE_Y;

            // 経験値とジェムを保管する
            setResult(gems,exp,expBonus,gemsPow,expPow,totalGems,totalExp);
            log.writeLog(log.LV_FATAL, this, "QUEST RESULT THREAD", _exp,_result);
            _levelupCount = Player.instance.avatar.levelUpNum(_exp);
            if (_result == _WIN)
            {
                sExec.addThread(SE.getWinSEThread(0));
            }else{
                sExec.addThread(SE.getLoseSEThread(0));

            }
            // スレッドを足す
            sExec.addThread(new FadeThread(_fade));

            sExec.addThread(_resultImage.getShowThread(_container));

            log.writeLog(log.LV_INFO, this, "getResultThread!!!!!!!!!!!!!!",_frame,_frame.visible,_frame.alpha);
            // Frameのロードを待つ
            sExec.addThread(_frame.getWaitCompleteThread());

            // 新しいリザルト表示（EXP他を最初に出す）
            // フレームのtextresultを出す
            _frame.visible = true;
            sExec.addThread(_frame.getTextResultShowThread(_baseGems,_baseExp,_expBonus,_gemsPower,_expPower,_gems,_exp,_result));


            // 新しいリザルト表示（ボタン表示）
            _resultButton.x = _RESULT_BUTTON_X;
            _resultButton.y = _RESULT_BUTTON_Y;
            sExec.addThread(new ObjectShowThread(_resultButton));
            sExec.addThread(new ClousureThread(function():void{_resultButton.buttonEnabled = true}));




            // sExec.addThread(_frame.getFadeThread());

            // // Rewardのスレッド
            sExec.addThread(new ClousureThread(_standChara.upImage));
            sExec.addThread(new BeTweenAS3Thread(_standChara, {x:0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ));

            // // ダブルアップのスレッドを返す
            // sExec.addThread(getInitRewardThread(_reward.gettedCards, _reward.cards1, _reward.cards2, _reward.cards3));


            return sExec;
        }

        // 最初のRewardスレッドを返す
        public function getInitRewardThread(gettedCards:Array, cards1:Array, cards2:Array, cards3:Array):Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();


            // 新しいリザルト（表示中のものを消す）
            var pDelExec:ParallelExecutor = new ParallelExecutor();
            _resultButton.buttonEnabled = false;
            pDelExec.addThread(new ObjectHideThread(_resultButton));
            pDelExec.addThread(_resultImage.getHideThread());
            sExec.addThread(pDelExec);

            // 新しいリザルト（TextResultを移動する）
            sExec.addThread(_frame.getFadeThread());
            sExec.addThread(_frame.getTextResultMoveThread());


            var cards:Array = [cards1, cards2, cards3];

            // カードの配列を空に
            _nextCards = [];
            _nextCardsNum = [];

            // 次のカードを取得候補カードにする
            var rewardObject:Array = getRewardCardClip(gettedCards);
            _ccc = rewardObject[0];
            _ccc.x = _CCC_X;
            _ccc.y = _CCC_Y;
            _ccc.scaleX = _ccc.scaleY = 1.0;

            // ラベルもコピーする
            _cccNum = rewardObject[1];
            _cccNum.x = _CCC_NUM_X;
            _cccNum.y = _CCC_NUM_Y;
            _cccNum.alpha = 0.0;
            _cardsContainer.addChild(_cccNum);

            pExec.addThread(new BeTweenAS3Thread(_cccNum, {alpha:1.0}, null, 2.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(rewardObject[2]);

            // カードの値を初期化
            for(var i:int = 0; i < cards.length; i++)
            {
                rewardObject = getRewardCardClip(cards[i]);
                // カードを追加
                _nextCards.push(rewardObject[0]);
                _nextCards[i].x = _NEXT_CARD_X + _NEXT_CARD_OFFSET_X * i + 1024;
                _nextCards[i].y = _NEXT_CARD_Y;
                _nextCards[i].scaleX = _nextCards[i].scaleY = _NEXT_CARD_SCALE;
                _nextCards[i].addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
                _nextCards[i].addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
                pExec.addThread(rewardObject[2]);
                pExec.addThread(new BeTweenAS3Thread(_nextCards[i], {x:_NEXT_CARD_X+_NEXT_CARD_OFFSET_X*i}, null, 2.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

                // 枚数ラベルを追加
                _nextCardsNum.push(rewardObject[1]);
                _nextCardsNum[i].x = _NEXT_CARD_NUM_X + _NEXT_CARD_NUM_OFFSET_X * i + 1024;
                _nextCardsNum[i].y = _NEXT_CARD_NUM_Y;
                _cardsContainer.addChild(_nextCardsNum[i]);
                pExec.addThread(new BeTweenAS3Thread(_nextCardsNum[i], {x:_NEXT_CARD_NUM_X+_NEXT_CARD_NUM_OFFSET_X*i}, null, 2.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }
            // リザルトステップの初期化
//            log.writeLog(log.LV_FATAL, this, "!!!!!!!!!!!!!! init bonus is",_reward.bonus);
            _resultStep.setRank(_reward.bonus);
            pExec.addThread(new BeTweenAS3Thread(_cardFrame, {alpha:1.0}, null, 2.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_resultStep, {alpha:1.0}, null, 2.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // リザルトを画面に入れる
            pExec.addThread(_frame.getBonusGameThread());

            // カードとリザルトを画面イン
            sExec.addThread(pExec);

            // ラベルを作る
//            sExec.addThread(new BeTweenAS3Thread(_resultStep, {alpha:1.0}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            return sExec;
        }

        // 目標ダイス設定スレッドを返す
        public function getBottomDiceThread(bottomDice:Array):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            // ステップ数の更新
//            _stepLabel.text = "STEP "+ _reward.bonus.toString();
//            _resultStep.seRank(_reward.bonus);

            log.writeLog(log.LV_INFO, this, "bottomDiceThread!!!!", bottomDice);
            // ダイスの値を設定
            _nextDiceNum = bottomDice[0] + bottomDice[1];
            sExec.addThread(new SetRollNumThread(_frame, _nextDiceNum));
            sExec.addThread(_frame.getNextGameThread());
            sExec.addThread(new BeTweenAS3Thread(_itemList, {x:-250, alpha:0.0}, null, 0.3 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ));

            return sExec;
        }

        // ハイローで勝った時のスレッド返す
        public function getRewardWinnerThread(nextCards:Array, step:int):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var i:int = 0;

            // Success!!
//            sExec.addThread(_frame.getSuccessThread());


            // 新しいリザルト
            sExec.addThread(_resultRollImage.getSuccessThread(_container));

            // 次のダイスを設定する
//            sExec.addThread(new SetRollNumThread(_frame, _nextDiceNum));
            // 次のゲームを表示する
            sExec.addThread(_frame.getSelectGameThread());

            // ステップ数の更新
//            _stepLabel.text = "STEP "+ _reward.bonus.toString();
            sExec.addThread(new ClousureThread(_resultStep.setRank,[_reward.bonus]));
            // カードが存在するなら
            if(_ccc)
            {
                // 前回のカード郡にプッシュする
                _prevCards.push(_ccc);
                _prevCards[_prevCards.length-1].addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
                _prevCards[_prevCards.length-1].addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
                // スレッドを合成
                pExec.addThread(new BeTweenAS3Thread(_prevCards[_prevCards.length-1], {x:_PREV_CARD_X ,y:_PREV_CARD_Y ,scaleX:_PREV_CARD_SCALE ,scaleY:_PREV_CARD_SCALE}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                // 枚数ラベルを追加
                _prevCardsNum.push(_cccNum);
                // スレッドを合成
                pExec.addThread(new BeTweenAS3Thread(_prevCardsNum[_prevCardsNum.length-1], {x:_PREV_CARD_NUM_X ,y:_PREV_CARD_NUM_Y}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

                // 前のカードを削除
                if(_prevCards.length > _PREV_CARD_MAX)
                {
                    var obj:* = _prevCards.shift();
                    pExec.addThread(getHideCCCThread(obj));
                }
                // 前のラベルを削除
                if(_prevCardsNum.length > _PREV_CARD_MAX)
                {
                    obj = _prevCardsNum.shift();
                    pExec.addThread(new ObjectHideThread(obj));
                }

                // 前回のカードの位置を合わせる
                for(i = 0; i < _prevCards.length-1; i++)
                {
                    pExec.addThread(new BeTweenAS3Thread(_prevCards[i], {x:_PREV_CARD_X+_PREV_CARD_OFFSET_X*i-_PREV_CARD_OFFSET_X*(_prevCards.length-1)}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                    pExec.addThread(new BeTweenAS3Thread(_prevCardsNum[i], {x:_PREV_CARD_NUM_X+_PREV_CARD_NUM_OFFSET_X*i-_PREV_CARD_NUM_OFFSET_X*(_prevCards.length-1)}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                }
            }

            // 次のカードを取得候補カードにする
            _ccc = _nextCards.shift();
            _ccc.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            _ccc.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);

            pExec.addThread(new BeTweenAS3Thread(_ccc, {x:_CCC_X ,y:_CCC_Y ,scaleX:1.0 ,scaleY:1.0}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // ラベルもコピーする
            _cccNum = _nextCardsNum.shift();
            pExec.addThread(new BeTweenAS3Thread(_cccNum, {x:_CCC_NUM_X ,y:_CCC_NUM_Y ,scaleX:1.0 ,scaleY:1.0}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));



            // 新しい候補カードを足す
            var rewardObject:Array = getRewardCardClip(nextCards);
            _nextCards.push(rewardObject[0]);
            _nextCards[_nextCards.length-1].x = _NEXT_CARD_X + _NEXT_CARD_OFFSET_X * (_nextCards.length-1);
            _nextCards[_nextCards.length-1].y = _NEXT_CARD_Y;
            _nextCards[_nextCards.length-1].scaleX = _nextCards[_nextCards.length-1].scaleY = _NEXT_CARD_SCALE;
            _nextCards[_nextCards.length-1].addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            _nextCards[_nextCards.length-1].addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            _nextCards[_nextCards.length-1].alpha = 0.0;
            pExec.addThread(rewardObject[2]);
            pExec.addThread(new BeTweenAS3Thread(_nextCards[_nextCards.length-1], {alpha:1.0}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // 候補カードのラベルを足す
            _nextCardsNum.push(rewardObject[1]);
            _nextCardsNum[_nextCardsNum.length-1].x = _NEXT_CARD_NUM_X + _NEXT_CARD_NUM_OFFSET_X * (_nextCardsNum.length-1);
            _nextCardsNum[_nextCardsNum.length-1].y = _NEXT_CARD_NUM_Y;
            _nextCardsNum[_nextCardsNum.length-1].alpha = 0.0;
            _cardsContainer.addChild(_nextCardsNum[_nextCardsNum.length-1]);
            pExec.addThread(new BeTweenAS3Thread(_nextCardsNum[_nextCardsNum.length-1], {alpha:1.0}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            // 前回のカードの位置を合わせる
            for(i = 0; i < _nextCards.length-1; i++)
            {
                pExec.addThread(new BeTweenAS3Thread(_nextCards[i], {x:_NEXT_CARD_X+_NEXT_CARD_OFFSET_X*i}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                pExec.addThread(new BeTweenAS3Thread(_nextCardsNum[i], {x:_NEXT_CARD_NUM_X+_NEXT_CARD_NUM_OFFSET_X*i}, null, 1.0 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }

            // 次のゲームを表示しつつカードを移動させる
            sExec.addThread(pExec);

            return sExec;
        }

        // 結果ダイスの更新スレッドを返す
        public function getRewardResultDiceThread(resultDice:Array):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();

            // コンテナを隠す
            //_container.alpha = 0.0;
            // ダイススレッドを返す
            _resultDiceManager.eyeArray = resultDice;
            sExec.addThread(_resultDiceManager.getRollDiceThread());
            // コンテナを表示する
//            //sExec.addThread(new TweenerThread(_container, {alpha:1.0, transition:"easeOutSine", time:0.1}));
            //sExec.addThread(new BeTweenAS3Thread(_container, {alpha:1.0}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE));

            // ダイス数値の更新
//            _diceNum.visible = false;
            _nextDiceNum = resultDice[0] + resultDice[1];

            return sExec;
        }

        // ハイローで負けた時のスレッド返す
        public function getRewardLoserThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            // failed!!
//            sExec.addThread(_frame.getFailedThread());

            // 新しいリザルト
            sExec.addThread(_resultRollImage.getFailedThread(_container));

            // ボーナスゲームにしっぱいスレッド
            sExec.addThread(_frame.getFailedSelectGameThread());

            return sExec;
        }

        // ハイローをやめた時のスレッド返す
        public function getResultCancelThread(getCard:Array,totalGems:int,totalExp:int,addPoint:int):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();

            // ステップを消す
            sExec.addThread(new BeTweenAS3Thread(_resultStep, {alpha:0.0}, null, 0.2 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            if(getCard.length)
            {
                // GETを表示
//                sExec.addThread(new ShowGetThread(_cardFrame, this));
                sExec.addThread(new ClousureThread(_cardFrame.goGet));
                sExec.addThread(new SleepThread(1000));
                // 作られたキャラカードクリップを消す
                _nextCardsNum.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new ObjectHideThread(item))});
                _prevCardsNum.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new ObjectHideThread(item))});
                _nextCards.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(getHideCCCThread(item))});
                _prevCards.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(getHideCCCThread(item))});
                // リザルトを消す
                sExec.addThread(_resultRollImage.getHideThread());
                // ダイスを消す
                sExec.addThread(new FinishDiceThread(_resultDiceManager));
                // カードを消す
                sExec.addThread(pExec);
                // ボタンを表示
                sExec.addThread(_frame.getResultThread());
                // GETを隠す
//                sExec.addThread(new HideGetThread(_cardFrame));
                sExec.addThread(new BeTweenAS3Thread(_cardFrame, {alpha:0.0}, null, 0.5 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                sExec.addThread(new ClousureThread(_cardFrame.goNormal));
                // カードを表示
                pExec2.addThread(new BeTweenAS3Thread(_ccc, {x:_CCC_DIST_X ,y:_CCC_DIST_Y}, null, 0.5 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                pExec2.addThread(new BeTweenAS3Thread(_cccNum, {x:_CCC_DIST_NUM_X ,y:_CCC_DIST_NUM_Y}, null, 0.5 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                sExec.addThread(pExec2);

                var type:int = getCard[0];
                var num:int = getCard[2];
                var fontSize:int = 48;
                if (num>999)
                {
                    fontSize = 30;
                }
                var rslt:int = 0;
                switch (type)
                {
                case Reward.EXP:
                    rslt = _exp + addPoint;
//                    rslt = _exp+int((num-100)*0.01*_exp);
                    _levelupCount = _levelupCount+Player.instance.avatar.levelUpNum(addPoint);

                    _expCardPower = num;
                    _exp = totalExp;
                    _frame.setCardPowerNum(_gemsCardPower,_expCardPower,_gems,_exp);
                    break;
                case Reward.GEM:
//                    rslt = _gems + int( (num - 100) * 0.01 * _gems);
//                    rslt = _gems+int((num-100)*0.01*_gems);

                    _gemsCardPower = num;
                    _gems = totalGems;
                    _frame.setCardPowerNum(_gemsCardPower,_expCardPower,_gems,_exp);
                  break;

                default :

                }

                // ボタンの位置を修正
                _resultButton.x = _FIN_RESULT_BUTTON_X;
                _resultButton.y = _FIN_RESULT_BUTTON_Y;


                // 新しいリザルト（ボタンのハンドラーを付け直す）
                _resultButton.removeEventListener(MouseEvent.CLICK,resultButtonHandler);
                if (_levelupCount > 0) {
                    _resultButton.addEventListener(MouseEvent.CLICK,levelupResultButtonHandler);
                } else {
                    _resultButton.addEventListener(MouseEvent.CLICK,finishResultButtonHandler);
                }

                // ジェムと経験値を表示
                sExec.addThread(_frame.getExpAndGemsShowThread());

                sExec.addThread(new ObjectShowThread(_resultButton));
                sExec.addThread(new ClousureThread(function():void{_resultButton.buttonEnabled = true}));
            }
            else
            {
                // 作られたキャラカードクリップを消す
                _nextCardsNum.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new ObjectHideThread(item))});
                _prevCardsNum.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new ObjectHideThread(item))});
                _nextCards.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(getHideCCCThread(item))});
                _prevCards.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(getHideCCCThread(item))});
                if(_ccc)
                {
                    pExec.addThread(getHideCCCThread(_ccc));
                    pExec.addThread(new ObjectHideThread(_cccNum));
                }
                // 枠を消す
                pExec.addThread(new BeTweenAS3Thread(_cardFrame, {alpha:0.0}, null, 0.5 / _RESULT_SCENE_SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
                // リザルトを消す
                sExec.addThread(_resultRollImage.getHideThread());
                // ダイスを消す
                sExec.addThread(new FinishDiceThread(_resultDiceManager));
                // カードを消す
                sExec.addThread(pExec);
                // いろいろ消す
                sExec.addThread(_frame.getResultThread());

                // ジェムと経験値を表示
                sExec.addThread(_frame.getExpAndGemsShowThread());

                // レベルアップ
                if (_levelupCount > 0) {
                    // 新しいリザルト（ボタンのハンドラーを付け直す）
                    _resultButton.removeEventListener(MouseEvent.CLICK,resultButtonHandler);
                    _resultButton.addEventListener(MouseEvent.CLICK,levelupResultButtonHandler);
                    sExec.addThread(getLevelUpThread());
                } else {
                    // 新しいリザルト（ボタンのハンドラーを付け直す）
                    _resultButton.removeEventListener(MouseEvent.CLICK,resultButtonHandler);
                    _resultButton.addEventListener(MouseEvent.CLICK,finishResultButtonHandler);

                    sExec.addThread(new ObjectShowThread(_resultButton));
                    sExec.addThread(new ClousureThread(function():void{_resultButton.buttonEnabled = true}));
                }
            }

            return sExec;
        }

        // レベルアップしたときのスレッドを返す
        public function getLevelUpThread():Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            // カードを非表示
            pExec.addThread(new ObjectHideThread(_resultButton));
            pExec.addThread(new ClousureThread(function():void{_resultButton.buttonEnabled = false}));
            pExec.addThread(new BeTweenAS3Thread(_ccc, {alpha:0.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_cccNum, {alpha:0.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            sExec.addThread(pExec);

            // LvUpを表示
            sExec.addThread(_levelUpImage.getPlayThread(_levelupCount));

            // resultButtonの位置調整・再表示
            sExec.addThread(new ClousureThread(function():void{
                        _resultButton.removeEventListener(MouseEvent.CLICK,levelupResultButtonHandler);
                        _resultButton.addEventListener(MouseEvent.CLICK,finishResultButtonHandler);
                        _resultButton.x = _RESULT_BUTTON_X;
                        _resultButton.y = _RESULT_BUTTON_Y;
                    }));
            sExec.addThread(new ObjectShowThread(_resultButton));
            sExec.addThread(new ClousureThread(function():void{_resultButton.buttonEnabled = true}));

            return sExec;
        }

        // ジェムと経験値をセットする
        protected function setResult(gems:int, exp:int, expBonus:int, gemsPow:int, expPow:int, totalGems:int, totalExp:int):void
        {
            log.writeLog(log.LV_FATAL, this, "***************************************************");
            log.writeLog(log.LV_INFO, this, "DEFAULT EXP & EXP BONUS!!!!!!!!!!!!!!", "DefaultExp",exp, "ExpBonus",expBonus);
            log.writeLog(log.LV_FATAL, this, "***************************************************");

            _baseGems  = gems;
            _gemsPower = gemsPow;
            _gemsCardPower = 100;
            _baseExp = exp;
            _expBonus = expBonus;
            _expPower  = expPow;
            _expCardPower = 100;

            _gems = totalGems;
            _exp = totalExp;
        }

        // キャラカードにマウスが触れた時のハンドラ
        private function mouseOverHandler(e:MouseEvent):void
        {
//            e.currentTarget.parent.addChild(e.currentTarget);
//            e.currentTarget.getScaleThread(0.9/_NEXT_CARD_SCALE).start();
        }

        // キャラカードからマウスが離れた時のハンドラ
        private function mouseOutHandler(e:MouseEvent):void
        {
//            e.currentTarget.getScaleThread(1.0).start();
        }
        protected function getLabelShowThread(l:Label):Thread
        {
            return new LabelShowThread(l);
        }
    }

}

import flash.display.*

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;
import org.libspark.thread.threads.between.BeTweenAS3Thread;
import mx.controls.*
import mx.core.UIComponent;

import view.image.game.ResultFrame;
import view.scene.game.ResultDiceManager;
import controller.*;


class FadeThread extends Thread
{
    private var _fs:DisplayObject;

    public function FadeThread(fs:DisplayObject)
    {
        _fs = fs;
    }
    protected override function run():void
    {
        _fs.visible = true;
//        var thread:Thread = new TweenerThread(_fs, {alpha:0.5, transition:"easeOutSine", time:0.5, show:true});
        var thread:Thread = new BeTweenAS3Thread(_fs, {alpha:0.5}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();
        next(waiting);
    }

    private function waiting():void
    {
    }

    private function exit():void
    {

    }
}

class FrameShowThread extends Thread
{
    private var _fr:ResultFrame;

    public function FrameShowThread(fr:ResultFrame)
    {
        _fr = fr;
    }
    protected override function run():void
    {
        next(waiting);
    }

    private function waiting():void
    {
        _fr.visible  =false;
//        var thread:Thread = new TweenerThread(_fr, {alpha:1, transition:"easeOutSine", time:1, show:true});
        var thread:Thread = new BeTweenAS3Thread(_fr, {alpha:1}, null, 1 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();
    }

    private function exit():void
    {

    }
}

class ObjectShowThread extends Thread
{
    private var _object:DisplayObject;

    public function ObjectShowThread(object:DisplayObject)
    {
        _object = object;
    }

    protected override function run():void
    {
        _object.visible = false;
        _object.alpha = 0.0;
//        var thread:Thread = new TweenerThread(_object, {alpha:1, transition:"easeOutSine", time:0.5, show:true});
        var thread:Thread = new BeTweenAS3Thread(_object, {alpha:1}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true);
        thread.start();
        thread.join();

        next(waiting);
    }

    private function waiting():void
    {
    }

    private function exit():void
    {
    }
}

class ObjectHideThread extends Thread
{
    private var _object:DisplayObject;

    public function ObjectHideThread(object:DisplayObject)
    {
        _object = object;
    }

    protected override function run():void
    {
//        var thread:Thread = new TweenerThread(_object, {alpha:0, transition:"easeOutSine", time:0.5, hide:true});
        var thread:Thread = new BeTweenAS3Thread(_object, {alpha:0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false);
        thread.start();
        thread.join();

        next(waiting);
    }

    private function waiting():void
    {
    }
}

class LabelShowThread extends Thread
{
    private var _label:Label;

    public function LabelShowThread(label:Label)
    {
        _label = label;
    }

    protected override function run():void
    {
        var sExec:SerialExecutor = new SerialExecutor();
        var pExec:ParallelExecutor = new ParallelExecutor();
        var text:String = ""; // 現在のテキスト
        var num:Array = [];
        var count:int = 0;

        // テキストを1の桁からバラバラにして配列に格納
        for(var i:int = _label.text.length-1; i >= 0; i--)
        {
            num.push(int(_label.text.charAt(i)));
        }

        // テキストを空にして表示させる
        _label.text = "";
        _label.visible = true;
        _label.alpha = 1.0;

        //
        for(i = 0; i < num.length; i++)
        {
            // ランダム表示
            for(count = 0; count < 10; count++)
            {
//                 sExec.addThread(SE.getGemSEThread(0));
//                 sExec.addThread(new TextThread(_label, String(int(count)+text)));
//                 pExec.addThread(SE.getGemSEThread(0.08*count));
                pExec.addThread(new TextThread(_label, String(int(count)+text), 80*count));
            }
            text = String(num[i]) + text;
//             pExec.addThread(SE.getGemSEThread(0.08*11));

            pExec.addThread(new TextThread(_label, text,11*80));
            sExec.addThread(pExec);

        }

        // ランダム表示
        for(var j:int = 0; j < 10; j++)
        {
            pExec.addThread(SE.getGemSEThread(0.08*j));
        }


        sExec.start();
        sExec.join();
        next(waiting);
    }

    private function waiting():void
    {
    }

    private function exit():void
    {
    }
}

class TextThread extends Thread
{
    private var _label:Label;
    private var _text:String;
    private var _wait:int;
    public function TextThread(label:Label, text:String, wait:int = 0)
    {
        _label = label;
        _text = text;
        _wait = wait;
    }

    protected override function run():void
    {
        sleep(_wait);
        next(text)

    }
    private function text():void
    {
        _label.text = _text;
    }}

class SetRollNumThread extends Thread
{
    private var _fr:ResultFrame;
    private var _num:int;

    public function SetRollNumThread(fr:ResultFrame, num:int)
    {
        log.writeLog(log.LV_INFO, this, "set Roll num Thread!!!!", num);
        _fr = fr;
        _num = num;
    }

    protected override function run():void
    {
        _fr.setRollNum(_num);
    }
}

class FinishDiceThread extends Thread
{
    private var _rm:ResultDiceManager;

    public function FinishDiceThread(rm:ResultDiceManager)
    {
        _rm = rm;
    }

    protected override function run():void
    {
        _rm.finish3D();
    }
}

