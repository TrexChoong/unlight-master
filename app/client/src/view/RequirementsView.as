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
    import model.CharaCard;
    import model.CharaCardDeck;
    import model.DeckEditor;
    import model.Growth;
    import model.GrowthTree;
    import model.Combine;
    import model.events.ExchangeEvent;
    import model.events.AvatarSaleEvent;
    import view.scene.common.Fade;
    import view.scene.common.CharaCardClip;
    import view.image.requirements.*;
    import controller.LobbyCtrl;
    import view.utils.*;

    /**
     * カード成長のビュークラス
     *
     */
    public class RequirementsView extends Thread
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

        CONFIG::LOCALE_JP
        private static const _TRANS_MSG:String = "__CN__を__SN__に変換してよろしいですか？";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG:String = "Are you sure convert __CN__ to __SN__?";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG:String = "要將__CN__換成__SN__嗎？";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG:String = "要将__CN__换成__SN__吗？";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG:String = "__CN__を__SN__に変換してよろしいですか？";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG:String = "Souhaitez-vous réellement changer __CN__ en __SN__ ?";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG:String = "__CN__を__SN__に変換してよろしいですか？";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG:String = "__CN__を__SN__に変換してよろしいですか？";

        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT_TITLE:String = "警告";
        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT_TITLE:String = "Warning";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT_TITLE:String = "警告";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT_TITLE:String = "警告";
        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT_TITLE:String = "경고";
        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT_TITLE:String = "Attention";
        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT_TITLE:String = "警告";
        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT_TITLE:String = "คำเตือน";


        // 親ステージ
        private var _stage:Sprite = new Sprite();

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // カードコンテナ
        private var _cardsContainer:UIComponent = new UIComponent();

        // カードロックコンテナ
        private var _lockContainer:UIComponent = new UIComponent();
        private var _lockNumContainer:UIComponent = new UIComponent();

        // フェードベース
        private var _fade:Fade = new Fade(0.2, 0.0);

        // BG
        private var _bg:BG = new BG();

        // 前回のキャラカードクリップ
        private var _growthDetailImage:GrowthDetailImage = new GrowthDetailImage();
        private var _growthDetailNumImage:GrowthDetailNumImage = new GrowthDetailNumImage();
        private var _bitSaleButtonImage:BitSaleButtonImage = new BitSaleButtonImage();

        // レベルアップのベース
        private var _levelUpBase:LevelUpBase = new LevelUpBase();

        // レベルアップのエフェクト
        private var _levelUpEffect:Array = [new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),
                                            new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),new LevelUpEffect(),];

        // キャラカードのID
        private var _id:int;


        // 表示中のID
        private var _currentGrowthId:int = -1;

        // 系統樹データ
        private var _growthTree:GrowthTree;

        // メインとなるキャラカードクリップ
        private var _ccc:CharaCardClip;

        // 自身の生成に必要とするキャラカードクリップの配列
        private var _cccSelect:CharaCardClip;
        private var _cccLow:Array = [];
        private var _labelLow:Array = [];
        private var _labelLowNum:Array = [];

        // 自身から派生するキャラカードクリップの配列
        private var _cccHigh:Array = [];
        private var _cccHighKey:Array = [];
        private var _labelHigh:Array = [];

        // 自分に必要なキャラカードIDと必要枚数の配列の配列
        private var _lowId:Array = [[1,10],[2,1],[2,1]];

        // 自分から派生するキャラカードIDと必要枚数の配列の配列
        private var _highId:Array = [[4,10],[5,1]];

        // ビューのステート
        private var _state:int;

        // デッキエディタ
        private var _deckEditor:DeckEditor = DeckEditor.instance;

        // カード成長
        private var _growth:Growth = Growth.instance;

        // レベルアップカード
        private var _lvupCard:CharaCardClip;

        // ステート定数
        private static const _START:int = 0;               // 開始
        private static const _WAIT:int = 1;                // 待機
        private static const _UPDATE:int = 2;              // 系統樹読み込み中
        private static const _GROWTH:int = 3;              // 成長画面を読み込み中
        private static const _LVUP:int = 4;                // レベルアップ演出
        private static const _CANCEL:int = 5;              // 成長画面をキャンセル
        private static const _END:int = 6;                 // 終了

        // 位置定数
        private static const _CCC_X:int = 580;                // 開始X
        private static const _CCC_Y:int = 38;                // 開始Y
        private static const _CCC_SCALE:Number = 1.0;         // 元のカード
        // 派生先カードのXYの配列（数によって位置を変化する）
        private static const _COMPO_CCC_X_SET:Array = [[246],[142,350],[38,246,454],[142,246,350,454],[38,142,246,350,454]];
        private static const _COMPO_CCC_Y:int = 160;
        private static const _COMPO_CCC_SCALE:Number = 0.5;  // 派生先のカード

//         private static const _CCC_OFFSET_X:int = -112;         // Xのずれ
//         private static const _CCC_OFFSET_Y:int = 233;         // Yのずれ
//         private static const _CCC_OFFSET_OFFSET_X:int = -231;   // xのカード分のずれ
//         private static const _CCC_OFFSET_OFFSET_Y:int = 484;   // Yのカード分のずれ

        private static const _LOCK_CCC_X:int = 580;                 // 開始X
        private static const _LOCK_CCC_Y:int = 0;                // 開始Y

        private static const _LOW_CCC_X:int = 422;                // 開始X
        private static const _LOW_CCC_Y:int = 103;                // 開始Y
        private static const _LOW_CCC_SCALE:Number = 0.5;         // 元のカード
        private static const _LOW_CCC_OFFSET_X:int = -100;         // Xのずれ

        private static const _LOW_LABEL_X:int = 413;               // 開始X
        private static const _LOW_LABEL_Y:int = 45;                // 開始Y
        private static const _LOW_LABEL_NUM_X:int = 412;           // 開始X
        private static const _LOW_LABEL_NUM_Y:int = 208;           // 開始Y
        private static const _LOW_LABEL_OFFSET_X:int = -100;        // 開始X

        private static const _HIGH_LABEL_X:int = 11;                // 開始X
        private static const _HIGH_LABEL_Y:int = 195;               // 開始Y

        private static const _LABEL_WIDTH:int = 100;            // ラベルの横幅
        private static const _LABEL_HEIGHT:int = 100;           // ラベルの縦幅
        private static const _LOW_LABEL_HEIGHT:int = 15;           // ラベルの縦幅

        private static const _LEVELUP_BUTTON_X:int = 435;     // レベルアップボタンX
        private static const _LEVELUP_BUTTON_Y:int = 445;     // レベルアップボタンY

        private static const _EXIT_BUTTON_X:int = 925;     // 終了ボタンX
        private static const _EXIT_BUTTON_Y:int = 700;     // 終了ボタンY

        private static const _DETAIL_X:int = 0;             // 終了ボタンX
        private static const _DETAIL_Y:int = 304;             // 終了ボタンY

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

        public function RequirementsView(stage:Sprite, id:int)
        {
            _id = id;
            _stage = stage;
            _state = _START;
            _bg.alpha = 0.0;
            _stage.addChild(_container);
            _container.addChild(_cardsContainer);
//            _container.addChild(_levelUpBase);
            Unlight.INS.topContainer.parent.addChild(_levelUpBase);

            _stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            _stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            _stage.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
            _growth.addEventListener(ExchangeEvent.EXCHANGE_SUCCESS, exchangeSuccessHandler);
            _growth.addEventListener(Growth.SELECT_CARD, selectCardHandler);
            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);

            _levelUpBase.alpha = 0.0;
            _levelUpBase.visible = false;

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

            _ccc = new CharaCardClip(CharaCard.ID(_id));
            _ccc.x = _CCC_X;
            _ccc.y = _CCC_Y;
            _ccc.scaleX = _ccc.scaleY = _CCC_SCALE;
            _ccc.alpha = 0.0;

            sExec.addThread(_bg.getShowThread(_container, 0));
            pExec.addThread(new BeTweenAS3Thread(_bg, {alpha:1.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(_ccc.getUnrotateShowThread(_cardsContainer));
            sExec.addThread(pExec);
            sExec.start();
            sExec.join();

            next(showButton);
        }

        // ボタンの表示
        private function showButton():void
        {
            _levelUpBase.ok.addEventListener(MouseEvent.CLICK, exitHandler);
            _bg.unlock.addEventListener(MouseEvent.CLICK, pushLevelUpHandler);
            _bg.upButton.addEventListener(MouseEvent.CLICK, pushUpHandler);
            _bg.downButton.addEventListener(MouseEvent.CLICK, pushDownHandler);
            next(waitLoading);
        }

        // 系統樹のデータが送られてくるのを待つ
        private function waitLoading():void
        {
            _cccLow = [];
            _cccHigh = [];
            _labelLow = [];
            _labelHigh = [];

            _growthTree = GrowthTree.ID(_id);
            // 系統樹の準備を待つ
            if (_growthTree.loaded == false)
            {
                _growthTree.wait();
            }
            next(waitLoading2);
        }

        // 系統樹のデータが送られてくるのを待つ
        private function waitLoading2():void
        {
            _highId = GrowthTree.ID(_id).up;

            for(var i:int = 0; i < _highId.length; i++)
            {
                _growthTree = GrowthTree.ID(_highId[i][0]);
                // 系統樹の準備を待つ
                if (_growthTree.loaded == false)
                {
                    _growthTree.wait();
                    break;
                }
            }
            if (_growthTree.loaded == false)
            {
                next(waitLoading2);
            }
            else
            {
               next(createCards);
            }

        }


        // カードを生成する
        private function createCards():void
        {
            var len:int = _highId.length;

            for(var i:int = 0; i < len; i++)
            {
                _cccHigh.push(new CharaCardClip(CharaCard.ID(_highId[i][0])));

                _cccHigh[i].x = _COMPO_CCC_X_SET[len-1][i];
                _cccHigh[i].y = _COMPO_CCC_Y;
                _cccHigh[i].alpha = 0.0;
                _cccHigh[i].scaleX = _cccHigh[i].scaleY = _COMPO_CCC_SCALE;

                _labelHigh.push(new Label());
                _labelHigh[i].x = _cccHigh[i].x + _HIGH_LABEL_X;
                _labelHigh[i].y = _cccHigh[i].y + _HIGH_LABEL_Y;
                _labelHigh[i].width = _LABEL_WIDTH;
                _labelHigh[i].height = _LABEL_HEIGHT;
                _labelHigh[i].text = "x"+_highId[i][1];
                _labelHigh[i].styleName = "CharaCardParam";
                _labelHigh[i].alpha = 0.0;
            }

            _bg.setDetail(_highId.length);

            next(showCards);
        }

        // キャラクターカードの表示
        private function showCards():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            _cccLow.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(item.getRequirementsShowThread(_cardsContainer))});
            _cccHigh.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(item.getRequirementsShowThread(_cardsContainer))});
            pExec.start();
            pExec.join();
            next(showCards2);
        }

        // キャラクターカードの表示
        private function showCards2():void
        {
            _labelLow.forEach(function(item:*, index:int, array:Array):void{_cardsContainer.addChild(item)});
            _labelHigh.forEach(function(item:*, index:int, array:Array):void{_cardsContainer.addChild(item)});

            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_ccc, {alpha:1.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            _cccHigh.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new BeTweenAS3Thread(item, {alpha:1.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true))});
            pExec.start();
            pExec.join();
            next(initGrowthDatail);
        }

        // キャラクターカードの表示
        private function initGrowthDatail():void
        {
            // RMItemShopの更新が必要であれば行う
            RealMoneyShopView.itemReset();
            shopButtonCheck();

            _lockContainer.visible = false;
            _lockNumContainer.visible = false;
            _lockContainer.addChild(_growthDetailImage);
            _lockContainer.addChild(_bitSaleButtonImage);
            _lockNumContainer.addChild(_growthDetailNumImage);
            _container.addChild(_lockContainer);
            _container.addChild(_lockNumContainer);
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
            else if(_state == _GROWTH)
            {
                next(growthSelect);
            }
            else if(_state == _LVUP)
            {
                next(lvup);
            }
            else if(_state == _CANCEL)
            {
                next(cancel);
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
            pExec.addThread(new BeTweenAS3Thread(_fade, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_bg, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_ccc, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_lockContainer, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_lockNumContainer, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new ClousureThread(function():void{RemoveChild.apply(_exchangeNumLabel)}));
            _cccLow.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false))});
            _cccHigh.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false))});
            _labelLow.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false))});
            _labelHigh.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(new BeTweenAS3Thread(item, {alpha:0.0}, null, 0.2 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false))});
            pExec.start();
            pExec.join();
            next(exit);
        }

        // 終了
        private function exit():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
//            pExec.addThread(_fade.getHideThread());
            pExec.addThread(_bg.getHideThread());
            pExec.addThread(_ccc.getHideThread());
            if(_cccSelect)
            {
                pExec.addThread(_cccSelect.getHideThread());
            }
            if(_lvupCard)
            {
                pExec.addThread(_lvupCard.getHideThread());
            }

            _cccLow.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(item.getRequirementsHideThread())});
            _cccHigh.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(item.getRequirementsHideThread())});
            pExec.start();
            pExec.join();

            _labelLow.forEach(function(item:*, index:int, array:Array):void{_lockContainer.removeChild(item)});
            _labelLowNum.forEach(function(item:*, index:int, array:Array):void{_lockNumContainer.removeChild(item)});

            _container.removeChild(_lockContainer);
            _container.removeChild(_lockNumContainer);
            _container.removeChild(_cardsContainer);

            RemoveChild.apply(_levelUpBase);
            _levelUpEffect.forEach(function(item:*, index:int, array:Array):void{RemoveChild.apply(item)});

            _stage.removeChild(_container);

            Player.instance.avatar.removeEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
            _bg.unlock.removeEventListener(MouseEvent.CLICK, pushLevelUpHandler);
            _levelUpBase.ok.removeEventListener(MouseEvent.CLICK, exitHandler);
            _bg.upButton.removeEventListener(MouseEvent.CLICK, pushUpHandler);
            _bg.downButton.removeEventListener(MouseEvent.CLICK, pushDownHandler);

            _stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            _stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            _stage.removeEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);

            _growth.removeEventListener(ExchangeEvent.EXCHANGE_SUCCESS, exchangeSuccessHandler);
            _growth.removeEventListener(Growth.SELECT_CARD, selectCardHandler);
        }

        // 終了関数
        override protected  function finalize():void
        {
            log.writeLog (log.LV_WARN,this,"RequirementsView end");
        }

        // 終了時のハンドラ
        public function exitHandler(e:MouseEvent):void
        {
            if(_lvupCard)
            {
                SE.playClick();
                _lvupCard.getHideThread().start();
            }
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            _levelUpBase.visible = false;
            _state = _END;
            _growth.waiting();
            Combine.instance.waiting();
        }

        // レベルアップハンドラ
        private function pushLevelUpHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "levelup");
            _lockContainer.visible = false;
            _lockNumContainer.visible = false;
            for(var i:int = 0; i < _lowId.length; i++)
            {
                if(CharaCardDeck.binder.sortCharaCardId(_lowId[i][0]) < _lowId[i][1])
                {
                    _lockContainer.visible = true;
                    _lockNumContainer.visible = true;
                }
            }
            if(!_lockContainer.visible)
            {
                log.writeLog(log.LV_INFO, this, "levelup 1", _growth.selectCardId != Const.EX_TIPS_CARD_ID);
                if (_growth.selectCardId != Const.EX_TIPS_CARD_ID) {
                    for(var j:int = 0; j < _exchangeNum; j++){
                        _growth.exchange(_growth.selectCardId, _ccc.charaCard.id);
                    }
                } else {
                    var cname:String = _ccc.charaCard.nameSet;
                    var resultCard:CharaCard = CharaCard.ID(_growth.selectCardId);
                    var rname:String = resultCard.nameSet;
                    var text:String = _TRANS_MSG.replace("__CN__",cname).replace("__SN__",rname);
                    ConfirmPanel.show(_TRANS_ALERT_TITLE, text, confirmYesHandler, this, null, false, false, confirmNoHandler);
                }
            }
        }

        private function confirmYesHandler():void
        {
            for(var j:int = 0; j < _exchangeNum; j++){
                _growth.exchange(_growth.selectCardId, _ccc.charaCard.id);
            }
        }

        private function confirmNoHandler():void
        {
            _growth.unselectCard();
            _state = _CANCEL;
        }

        // レベルアップハンドラ
        private function pushUpHandler(e:MouseEvent):void
        {
            if (_exchangeNum< maxNum)
            {
                _exchangeNum+=1;
                _bg.buttonShow(_exchangeNum, maxNum);
                _exchangeNumLabel.text = _exchangeNum.toString();

            }
        }
        // レベルアップハンドラ
        private function pushDownHandler(e:MouseEvent):void
        {
            if (_exchangeNum > 1 )
            {
                _exchangeNum-=1;
                _bg.buttonShow(_exchangeNum, maxNum);
                _exchangeNumLabel.text = _exchangeNum.toString();
            }

        }


        // マウスドラッグの開始ハンドラ
        private function mouseDownHandler(e:MouseEvent):void
        {
            //_cardsContainer.startDrag();
        }

        // マウスドラッグの終了ハンドラ
        private function mouseUpHandler(e:MouseEvent):void
        {
            //_cardsContainer.stopDrag();
        }

        // カードが選択された時のハンドラ
        private function selectCardHandler(e:Event):void
        {
            if(_state != _UPDATE && _currentGrowthId != _growth.selectCardId)
            {
                SE.playClick();
                _state = _GROWTH;
            }
        }

        // ショップボタンのチェック
        CONFIG::PAYMENT
        public function shopButtonCheck():void
        {
            log.writeLog(log.LV_FATAL, this, "shop button check");
            _bitSaleButtonImage.buttonVisible = true;
            _bitSaleButtonImage.setButtonFunc(shopButtonClickHandler);
            _bitSaleButtonImage.setViewSaleClipFlag(Player.instance.avatar.isSaleTime);
        }

        // ショップボタンのチェック
        CONFIG::NOT_PAYMENT
        public function shopButtonCheck():void
        {
            log.writeLog(log.LV_FATAL, this, "shop button check");
            _bitSaleButtonImage.buttonVisible = false;
        }

        public function shopButtonClickHandler():void
        {
            log.writeLog(log.LV_DEBUG, this, "shop skip button handler");
            RealMoneyShopView.show(RealMoneyShopView.TYPE_EX_CARD);
        }

        // セールの終了判定が出たときのハンドラ
        private function saleFinishHandler(e:AvatarSaleEvent):void
        {
            // log.writeLog (log.LV_INFO,this,"saleFinish!");
            _bitSaleButtonImage.setViewSaleClipFlag(Player.instance.avatar.isSaleTime);
            // ショップアイテムリストの更新
            RealMoneyShopView.itemReset();
        }

        // カード選択に戻る
        private function cancel():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new ClousureThread(function():void{RemoveChild.apply(_exchangeNumLabel)}));
            sExec.addThread(new ClousureThread(_bg.buttonHide));
            sExec.start();
            sExec.join();
            _state = _WAIT;
            for(var i:int = 0; i < _cccHigh.length; i++)
            {
                _cccHigh[i].baseFocusOff();
            }
            _currentGrowthId = -1;
            next(waiting);
        }

        // 成長ビューを表示させる
        private function growthSelect():void
        {
            for(var i:int = 0; i < _cccHigh.length; i++)
            {
                log.writeLog(log.LV_INFO, this, "_growth.selectCardId", _growth.selectCardId);
                if(_cccHigh[i].charaCard.id == _growth.selectCardId)
                {
                    _cccHigh[i].baseFocusOn();
                }
                else
                {
                    _cccHigh[i].baseFocusOff();
                }
            }
            next(growth);
        }

        // 成長ビューを表示させる
        private function growth():void
        {
            log.writeLog(log.LV_INFO, this, "_growth");
            _growthTree = GrowthTree.ID(_growth.selectCardId);
            // 系統樹の準備を待つ
            if (_growthTree.loaded == false)
            {
                _growthTree.wait();
            }
            next(growth2);
        }

        // 成長ビューを表示させる
        private function growth2():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var suspend:Boolean = true;

            if(_ccc.charaCard.kind == Const.CC_KIND_MONSTAR)
            {
                // モンスターコインの成長ビューを呼び出す
                switch(_growth.selectCardId)
                {
                case Const.COIN_GOLD_ID:
                    // ゴールドコイン
                    _lowId = [[_ccc.charaCard.id, 3]];
                    break;
                case Const.COIN_PLATINUM_ID:
                    // プラチナコイン
                    var lv1ID:int = _ccc.charaCard.id - _ccc.charaCard.level + 1
                    _lowId = [[lv1ID, 1],[lv1ID+1, 1],[lv1ID+2, 1]];
                    break;
                default:
                    // ノーマルコイン
                    _lowId = [[_ccc.charaCard.id, 1]];
                }
            }
            else if(_growth.selectCardId == Const.EX_TIPS_CARD_ID)
            {
                // EXかけら
                _lowId = [[_ccc.charaCard.id, 1]];
            }
            else
            {
                // 通常
                _lowId = _growthTree.down;
            }

            //_growthDetailImage.setDetail(_lowId.length);
            _currentGrowthId = _growth.selectCardId;

            if(_lowId.length)
            {
                _lockContainer.x = _DETAIL_X;
                _lockContainer.y = _DETAIL_Y;
                _lockContainer.alpha = 0.0;
                _lockContainer.visible = true;
                _lockNumContainer.x = _DETAIL_X;
                _lockNumContainer.y = _DETAIL_Y;
                _lockNumContainer.alpha = 0.0;
                _lockNumContainer.visible = true;

                if(_cccSelect)
                {
                    pExec.addThread(_cccSelect.getHideThread());
                    _cccSelect = null;
                }
                _cccSelect = new CharaCardClip(CharaCard.ID(_growth.selectCardId));
                _cccSelect.x = _LOCK_CCC_X;
                _cccSelect.y = _LOCK_CCC_Y;
                pExec.addThread(_cccSelect.getShowThread(_lockContainer));

                _cccLow.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(item.getHideThread())});
                _labelLow.forEach(function(item:*, index:int, array:Array):void{_lockContainer.removeChild(item)});
                _labelLowNum.forEach(function(item:*, index:int, array:Array):void{_lockNumContainer.removeChild(item)});
                _cccLow = [];
                _labelLow = [];
                _labelLowNum = [];
                _maxNumSet = []
                for(var i:int = 0; i < _lowId.length; i++)
                {
                    var num:int = CharaCardDeck.binder.sortCharaCardId(_lowId[i][0]);

                    _cccLow.push(new CharaCardClip(CharaCard.ID(_lowId[i][0]),true));
                    _cccLow[i].x = _LOW_CCC_X + _LOW_CCC_OFFSET_X * i;
                    _cccLow[i].y = _LOW_CCC_Y;
                    _cccLow[i].scaleX = _cccLow[i].scaleY = _LOW_CCC_SCALE;
                    pExec.addThread(_cccLow[i].getUnrotateShowThread(_lockContainer));

                    _labelLow.push(new Label());
                    _labelLow[i].x = _LOW_LABEL_X + _LOW_LABEL_OFFSET_X * i;
                    _labelLow[i].y = _LOW_LABEL_Y;
                    _labelLow[i].width = _LABEL_WIDTH;
                    _labelLow[i].height = _LABEL_HEIGHT;
                    _labelLow[i].filters = [new GlowFilter(0x000000, 1, 3, 3, 16, 1)];
                    _labelLow[i].text = _lowId[i][1];
                    _labelLow[i].setStyle("fontSize",48);

                    _lockContainer.addChild(_labelLow[i]);

                    _labelLowNum.push(new Label());
                    _labelLowNum[i].x = _LOW_LABEL_NUM_X + _LOW_LABEL_OFFSET_X * i;
                    _labelLowNum[i].y = _LOW_LABEL_NUM_Y;
                    _labelLowNum[i].width = _LABEL_WIDTH;
                    _labelLowNum[i].height = _LOW_LABEL_HEIGHT;
                    _labelLowNum[i].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
//                    _labelLowNum[i].text = "所持数×" + num;
                    _labelLowNum[i].text = _TRANS + num;
                    _labelLowNum[i].styleName = "UnlockCharaCardNumLabel";
                    _labelLowNum[i].mouseEnabled = false;
                    _labelLowNum[i].mouseChildren = false;

                    _lockNumContainer.addChild(_labelLowNum[i]);

                    if(num >= _lowId[i][1])
                    {
                        _labelLow[i].styleName = "UnlockCharaCardLabel";
                        _maxNumSet.push(int(num / _lowId[i][1]))
                    }
                    else
                    {
                        suspend = false;
                        _labelLow[i].styleName = "LockCharaCardLabel";
                    }
                }
                _exchangeNumLabel.filters = [new GlowFilter(0x000000, 1, 3, 3, 16, 1)];

                log.writeLog(log.LV_INFO, this, "maxNumset!", _maxNumSet,maxNum);

                sExec.addThread(pExec);
                sExec.addThread(new BeTweenAS3Thread(_lockContainer, {alpha:1.0 ,x:_DETAIL_X}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE));
                sExec.addThread(new BeTweenAS3Thread(_lockNumContainer, {alpha:1.0 ,x:_DETAIL_X}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE));

                if(suspend)
                {
                    _exchangeNum = 1;
                    _exchangeNumLabel.text = "1";
                    sExec.addThread(new ClousureThread(_bg.buttonShow,[_exchangeNum, maxNum]));
                    sExec.addThread(new ClousureThread(function():void{_container.addChild(_exchangeNumLabel)}));

//                     _bg.unlock.visible= true;
//                     _bg.lock.visible= false;
                }
                else
                {
                    _exchangeNumLabel.text = "";
                    sExec.addThread(new ClousureThread(function():void{RemoveChild.apply(_exchangeNumLabel)}));
                    sExec.addThread(new ClousureThread(_bg.buttonHide));
//                     _bg.lock.visible = true;
//                     _bg.unlock.visible = false;
                }

                sExec.start();
                sExec.join();
            }
            else
            {
                _lockContainer.visible = false;
                _lockNumContainer.visible = false;
            }

            _state = _WAIT;
            next(waiting);
        }

        private function get maxNum():int
        {

            var ret:int = _maxNumSet.sort(Array.NUMERIC)[0];
            ret = ret < 1 ? 1:ret;
            ret = ret > _EXCH_MAX ? _EXCH_MAX:ret;
            return ret;
        }

        // レベルアップ演出
        private function lvup():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            _lvupCard = new CharaCardClip(CharaCard.ID(_growth.selectCardId));
            _lvupCard.x = 204;
            _lvupCard.y = 347;
            _lvupCard.alpha = 0.0;
            _lvupCard.scaleX = _lvupCard.scaleY = 1.0;

            sExec.addThread(_lvupCard.getChainShowThread(_levelUpBase));

            pExec.addThread(new BeTweenAS3Thread(_lvupCard, {alpha:1.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_levelUpBase, {alpha:1.0}, null, 0.5 / Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE));

            sExec.addThread(pExec);
            sExec.start();
            sExec.join();

            next(lvup2);
        }

        // レベルアップ演出のつづき
        private function lvup2():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();

            sExec.addThread(new ClousureThread(_lvupCard.unlockChain));
            sExec.addThread(new SleepThread(500));

            _levelUpEffect.forEach(function(item:*, index:int, array:Array):void
                                   {
                                       item.x = 210 + Math.random() * 145;
                                       item.y = 376 + Math.random() * 215;
                                       item.visible = true;

                                       sExec.addThread(new SleepThread(200));
                                       sExec.addThread(new ClousureThread(item.onAnime));
                                   });


            sExec.start();
            sExec.join();

            _state = _WAIT;
            next(waiting);
        }

        // 合成に成功した時のイベント
        private function exchangeSuccessHandler(e:ExchangeEvent):void
        {
            SE.playChain();
            _deckEditor.selectCard(_id);

            _levelUpBase.visible = true;
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;

            _bg.buttonHide();
//            RemoveChild.apply(_exchangeNumLabel);
            _state = _LVUP;
        }

   }
}
