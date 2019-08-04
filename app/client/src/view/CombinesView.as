package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;

    import mx.core.UIComponent;
    import mx.containers.Panel;
    import mx.controls.Label;
    import mx.controls.Button;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Player;
    import model.DeckEditor;
    import model.WeaponCard;
    import model.WeaponCardInventory;
    import model.Combine;
    import model.CombineEditDeck;
    import model.events.ExchangeEvent;
    import model.events.CombineEvent;
    import model.events.EditCardEvent;
    import view.scene.common.Fade;
    import view.scene.common.WeaponCardClip;
    import view.scene.edit.BinderArea;
    import view.scene.edit.DeckArea;
    import view.scene.edit.CombineSetArea;
    import view.scene.edit.CombineDataArea;
    import view.scene.edit.CombineResult;
    import view.image.requirements.*;
    import controller.LobbyCtrl;
    import view.utils.*;

    /**
     * 武器合成のビュークラス
     *
     */
    public class CombinesView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "所持数×";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Own * ";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "所持數x";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "持有数x";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "소지수 * ";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Possession * ";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "所持数×";

        CONFIG::LOCALE_TH
        private static const _TRANS :String = "จำนวนที่ครอบครองอยู่ x ";


        // 親ステージ
        private var _stage:Sprite = new Sprite();

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // カードロックコンテナ
        private var _lockContainer:UIComponent = new UIComponent();
        private var _lockNumContainer:UIComponent = new UIComponent();

        // フェードベース
        private var _fade:Fade = new Fade(0.2, 0.0);

        // BG
        private var _bg:BG = new BG(BG.TYPE_WEAPON);

        private var _listArea:BinderArea;// = BinderArea.getWeaponCardBinder();

        // レベルアップのベース
        private var _levelUpBase:LevelUpBase = new LevelUpBase();
        private var _combineResult:CombineResult = new CombineResult();

        // レベルアップのエフェクト
        private var _levelUpEffect:Array = [new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),
                                            new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),];

        // 合成候補
        private var _combineSetArea:CombineSetArea = CombineSetArea.getWeaponCardDeck();
        private var _deckArea:DeckArea = DeckArea.getWeaponCardDeck();

        // 選択カード表示
        private var _combineDataArea:CombineDataArea = CombineDataArea.getWeaponCardData();

        // ビューのステート
        private var _state:int;

        // デッキエディタ
        private var _deckEditor:DeckEditor = DeckEditor.instance;
        private var _combineEditDeck:CombineEditDeck = new CombineEditDeck();

        // カード成長
        private var _combine:Combine = Combine.instance;

        // レベルアップカード
        private var _lvupCard:WeaponCardClip;

        private var _startBaseCardInvId:int;

        // ステート定数
        private static const _START:int          = 0; // 開始
        private static const _WAIT:int           = 1; // 待機
        private static const _UPDATE:int         = 2; // 系統樹読み込み中
        private static const _COMBINE:int        = 4; // 合成演出
        private static const _COMBINE_RESULT:int = 5; // 合成演出
        private static const _END:int            = 6; // 終了

        private static const _LABEL_WIDTH:int = 100;            // ラベルの横幅
        private static const _LABEL_HEIGHT:int = 100;           // ラベルの縦幅
        private static const _EXCH_NUM_X:int = 568;
        private static const _EXCH_NUM_Y:int = 560;
        private static const _EXCH_MAX:int =10;

        private var _player:Player = Player.instance;

        private var _maxNumSet:Array; /* of Int */;
        private var _exchangeNumLabel:Label = new Label();
        private var _exchangeNum:int = 1;

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function CombinesView(stage:Sprite, id:int,binderArea:BinderArea)
        {
            log.writeLog (log.LV_DEBUG,this,"CombinesView start");

            _startBaseCardInvId = id;
            _stage = stage;
            _listArea = binderArea;
            _state = _START;
            _bg.alpha = 0.0;
            _stage.addChild(_container);
            Unlight.INS.topContainer.parent.addChild(_levelUpBase);

            _combine.addEventListener(CombineEvent.COMBINE_SUCCESS, combineSuccessHandler);
            _deckEditor.addEventListener(EditCardEvent.COMBINE_TO_BINDER_WEAPON, changeListHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_COMBINE_WEAPON, changeListHandler);

            _levelUpBase.alpha = 0.0;
            _levelUpBase.visible = false;
            _combineResult.alpha = 0.0;
            _combineResult.hide();

            _levelUpEffect.forEach(function(item:*, index:int, array:Array):void
                                   {
                                       item.visible = false;
                                       Unlight.INS.topContainer.parent.addChild(item);
                                   });
            _exchangeNumLabel.x  = _EXCH_NUM_X;
            _exchangeNumLabel.y  = _EXCH_NUM_Y;
            _exchangeNumLabel.styleName = "UnlockCharaCardLabel";
            _exchangeNumLabel.setStyle("fontSize",  48);
            _exchangeNumLabel.width = _LABEL_WIDTH;
            _exchangeNumLabel.height = _LABEL_HEIGHT;
            _exchangeNumLabel.mouseEnabled = false;
            _exchangeNumLabel.mouseChildren = false;
            _exchangeNumLabel.filters = [new GlowFilter(0x000000, 1, 3, 3, 16, 1)];
            _exchangeNumLabel.text = _exchangeNum.toString();
            _exchangeNumLabel.visible = false;
            _container.addChild(_exchangeNumLabel);
        }

        // スレッドのスタート
        override protected function run():void
        {
            next(fadein);
        }

        // フェードの表示
        private function fadein():void
        {
            next(createCard);
        }

        // カードを生成する
        private function createCard():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            sExec.addThread(_bg.getShowThread(_container, 0));
            sExec.addThread(_listArea.getShowThread(_container, 1));
            sExec.addThread(_combineSetArea.getShowThread(_container, 2));
            sExec.addThread(_combineDataArea.getShowThread(_container, 3));
            sExec.addThread(_combineResult.getShowThread(_container, 10));
            pExec.addThread(new BeTweenAS3Thread(_bg, {alpha:1.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_listArea, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_combineSetArea, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_combineDataArea, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            sExec.addThread(pExec);
            sExec.start();
            sExec.join();

            // 選択中のカードをベースに入れておく
            var wci:WeaponCardInventory = WeaponCardInventory.getInventory(_startBaseCardInvId);
            _deckEditor.binderToDeckWeaponCard(wci,0,0);

            next(showButton);
        }

        // ボタンの表示
        private function showButton():void
        {
            _levelUpBase.ok.addEventListener(MouseEvent.CLICK, combineResultHandler);
            _combineResult.okBtn.addEventListener(MouseEvent.CLICK, exitCombineHandler);
            _bg.compo.addEventListener(MouseEvent.CLICK, pushCombineHandler);
            // _exchangeNumLabel.visible = true;

            next(initGrowthDatail);
       }

        // キャラクターカードの表示
        private function initGrowthDatail():void
        {
            _state = _WAIT;
            next(waiting);
        }

        // ループ部分
        private function waiting():void
        {

            // ステートでループ
            if (_player.state == Player.STATE_LOGOUT)
            {
                 next(hide);
            }else if(_state == _WAIT)
            {
                next(waiting);
            }
            else if(_state == _COMBINE)
            {
                next(combine);
            }
            else if(_state == _COMBINE_RESULT)
            {
                next(combineResult);
            }
            else if(_state == _END)
            {
                next(hide);
            }
            if (checkInterrupted())
            {
                next(hide);
            }


        }

        // 描画オブジェクトを消去
        private function hide():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_combineResult, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_combineDataArea, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_combineSetArea, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_fade, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_bg, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new ClousureThread(function():void{RemoveChild.apply(_exchangeNumLabel)}));
            pExec.start();
            pExec.join();
            next(exit);
        }

        // 終了
        private function exit():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
//            pExec.addThread(_fade.getHideThread());
            pExec.addThread(_combineResult.getHideThread());
            pExec.addThread(_combineDataArea.getHideThread());
            pExec.addThread(_combineSetArea.getHideThread());
            pExec.addThread(_bg.getHideThread());
            if(_lvupCard)
            {
                pExec.addThread(_lvupCard.getHideThread());
            }

            pExec.start();
            pExec.join();

            RemoveChild.apply(_levelUpBase);
            RemoveChild.apply(_combineResult);
            _levelUpEffect.forEach(function(item:*, index:int, array:Array):void{RemoveChild.apply(item)});

            _stage.removeChild(_container);

            _bg.compo.removeEventListener(MouseEvent.CLICK, pushCombineHandler);
            _levelUpBase.ok.removeEventListener(MouseEvent.CLICK, exitCombineHandler);
            _combineResult.okBtn.removeEventListener(MouseEvent.CLICK, exitCombineHandler);

            _deckEditor.removeEventListener(EditCardEvent.COMBINE_TO_BINDER_WEAPON, changeListHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_COMBINE_WEAPON, changeListHandler);
            _combine.removeEventListener(CombineEvent.COMBINE_SUCCESS, combineSuccessHandler);
        }

        // 終了関数
        override protected  function finalize():void
        {
            log.writeLog (log.LV_WARN,this,"CombinesView end");
        }

        // 終了時のハンドラ
        public function exitHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_WARN,this,"exithandler");
            if(_lvupCard)
            {
                SE.playClick();
                _lvupCard.getHideThread().start();
            }
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            _levelUpBase.visible = false;
            _combineResult.hide();
            _combineSetArea.resetSetList();
            _state = _END;
            _combine.waiting();
        }

        // 合成結果に移動するハンドラ
        public function combineResultHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_WARN,this,"combineResultHandler");
            if(_lvupCard)
            {
                SE.playClick();
                _lvupCard.getHideThread().start();
            }
            // Unlight.INS.topContainer.mouseEnabled = true;
            // Unlight.INS.topContainer.mouseChildren = true;
            _levelUpBase.visible = false;
            _state = _COMBINE_RESULT;
        }

        // 合成終了時のハンドラ
        public function exitCombineHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_WARN,this,"exitCombinehandler");
            if(_lvupCard)
            {
                SE.playClick();
                _lvupCard.getHideThread().start();
            }
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            _levelUpBase.visible = false;
            _combineResult.hide();
            _state = _WAIT;
            _combine.combines();

            // 結果カードを再度ベースとして入れる
            _deckEditor.binderToDeckWeaponCard(WeaponCardInventory.getInventory(_combine.resultCardInvId),_deckEditor.selectIndex,0);
        }

        // レベルアップハンドラ
        private function pushCombineHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "levelup",CombineEditDeck.deck.getCardIdList().length,CombineEditDeck.deck.getCardIdList());
            var cardIdList:Array = CombineEditDeck.deck.getCardIdList();
            if (cardIdList.length > 0) {
                 if (cardIdList.length <= CombineEditDeck.LIST_MAX) {
                     // 合成開始処理
                     _combine.combine(CombineEditDeck.deck.getCombineArray());
                }
            } else {
                // カードが選択されてないエラー
            }
        }


        // 合成演出
        private function combine():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            var wci:WeaponCardInventory = WeaponCardInventory.getInventory(_combine.resultCardInvId);
            _lvupCard = new WeaponCardClip(WeaponCard(wci.card));
            _lvupCard.x = 204;
            _lvupCard.y = 347;
            _lvupCard.alpha = 0.0;
            _lvupCard.scaleX = _lvupCard.scaleY = 1.0;

            sExec.addThread(_lvupCard.getShowThread(_levelUpBase));

            pExec.addThread(new BeTweenAS3Thread(_lvupCard, {alpha:1.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_levelUpBase, {alpha:1.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE));

            sExec.addThread(pExec);
            sExec.start();
            sExec.join();

            _state = _WAIT;
            next(waiting);
        }

        // 合成結果表示
        private function combineResult():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(_combineResult.show());

            sExec.addThread(pExec);
            sExec.start();
            sExec.join();

            next(combineResult2);
        }
        // 合成結果表示2
        private function combineResult2():void
        {
            var sExec:SerialExecutor = new SerialExecutor();

            sExec.addThread(new SleepThread(500));

            sExec.start();
            sExec.join();

            _state = _WAIT;
            next(waiting);
        }

        // 合成に成功した時のイベント
        private function combineSuccessHandler(e:CombineEvent):void
        {
            log.writeLog (log.LV_DEBUG,this,"combineSuccessHandler",CombineEditDeck.deck.getCardIdList().length);
            SE.playChain();
            //_deckEditor.selectCard(_id);

            _levelUpBase.visible = true;
//            _combineResult.visible = true;
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;

            _bg.buttonHide();
            _state = _COMBINE;
        }

        private function changeListHandler(e:Event):void
        {
            log.writeLog (log.LV_WARN,this,"changelisthandler",CombineEditDeck.deck.getCardIdList().length);
            if (CombineEditDeck.deck.getCardIdList().length <= 1) {
                log.writeLog (log.LV_WARN,this,"changelisthandler hide");
                _bg.compo.visible = false;
                _exchangeNumLabel.visible = false
            } else {
                log.writeLog (log.LV_WARN,this,"changelisthandler show");
                _bg.compo.visible = true;
                _exchangeNumLabel.visible = true;
            }
        }

   }
}
