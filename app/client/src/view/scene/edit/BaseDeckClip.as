package view.scene.edit
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;
    import flash.utils.Dictionary;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.image.edit.DeckCase;
    import view.scene.BaseScene;
    import view.scene.common.CharaCardClip;
    import view.scene.common.ICardClip;

    import model.*;
    import model.events.*;

    /**
     * デッキ基底表示クラス
     *
     */
    public class BaseDeckClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_HELP_DECK	:String = "所持しているデッキです。\nデッキに存在するカードが表示されます。";

        CONFIG::LOCALE_EN
        private static const _TRANS_HELP_DECK	:String = "Your deck.\nThis shows which cards your deck is composed of.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_HELP_DECK	:String = "所擁有的牌組。\n顯示牌組中的卡片。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_HELP_DECK	:String = "所持有的卡组。\n显示卡组的卡片。";

        CONFIG::LOCALE_KR
        private static const _TRANS_HELP_DECK	:String = "소지하고 있는 덱입니다. \n덱에 존재하는 카드가 표시됩니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_HELP_DECK	:String = "Pioche\ncartes de la pioche";

        CONFIG::LOCALE_ID
        private static const _TRANS_HELP_DECK	:String = "所持しているデッキです。\nデッキに存在するカードが表示されます。";

        CONFIG::LOCALE_TH
        private static const _TRANS_HELP_DECK   :String = "สำรับที่ท่านครอบครองอยู่\nการ์ดที่มีอยู่ในสำรับจะถูกแสดงให้เห็น";

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_SORT_CHK:String = "モンスターカードはデッキの最初に配置できません";
        CONFIG::LOCALE_EN
        private static const _TRANS_SORT_CHK:String = "The first card of your deck cannot be a monster card.";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SORT_CHK:String = "怪物卡無法放置於牌組第一張。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SORT_CHK:String = "怪物卡无法放置於牌组第一张。";
        CONFIG::LOCALE_KR
        private static const _TRANS_SORT_CHK:String = "몬스터 카드는 덱의 첫번째에 배치 할 수 없습니다.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SORT_CHK:String = "The first card of your deck cannot be a monster card.";
        CONFIG::LOCALE_ID
        private static const _TRANS_SORT_CHK:String = "モンスターカードはデッキの最初に配置できません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SORT_CHK:String = "モンスターカードはデッキの最初に配置できません";

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT:String = "警告";
        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT:String = "Warning";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT:String = "警告";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT:String = "警告";
        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT:String = "경고";
        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT:String = "Attention";
        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT:String = "警告";
        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT:String = "คำเตือน";


        // エディットインスタンス
        protected var _deckEditor:DeckEditor = DeckEditor.instance;
        protected var _combine:Combine = Combine.instance;

        protected var _backContainer:UIComponent = new UIComponent();       // 表示コンテナ
        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ
        protected var _frontContainer:UIComponent = new UIComponent();       // 表示コンテナ
        protected var _deckCase:DeckCase = new DeckCase();            // デッキケース
        protected var _deck:IDeck;                                   // デッキのポインタ
//        protected var _ccSet:Array = [];                               // Array of CardClip
        protected  var _cccDic:Dictionary = new Dictionary(); // Dictionary of CCC Key:CharaCard
        private var _viewType:String = "";                             // デッキの表示タイプ

        private static const _CARD_X:int = -72;                      // カードのX基本位置
        private static const _CARD_Y:int = 20;                         // カードのY基本位置
        private static const _CARD_OFFSET_X:int = 89;                // カードのXズレ
        private static const _CARD_SCALE:Number = 0.50;             // カード表示サイズ

        private static const _DECK_CARD1_X:int = 143;  // デッキカード1の開始X
        private static const _DECK_CARD1_X2:int = 228; // デッキカード1の終端X
        private static const _DECK_CARD2_X:int = 232;  // デッキカード2の開始X
        private static const _DECK_CARD2_X2:int = 317; // デッキカード2の終端X
        private static const _DECK_CARD3_X:int = 321;  // デッキカード3の開始X
        private static const _DECK_CARD3_X2:int = 406; // デッキカード3の終端X
        private static const _DECK_CARD_Y:int = 489;   // デッキカードの開始Y
        private static const _DECK_CARD_Y2:int = 610;  // デッキカードの終端Y
        private static const _BINDER_X:int = 5;        // バインダーの開始X
        private static const _BINDER_Y:int = 42;       // バインダーの開始Y
        private static const _BINDER_X2:int = 657;     // バインダーの終端X
        private static const _BINDER_Y2:int = 424;     // バインダーの終端Y

        private static const _COL_TYPE_CARD1:int  = 0;
        private static const _COL_TYPE_CARD2:int  = 1;
        private static const _COL_TYPE_CARD3:int  = 2;
        private static const _COL_TYPE_BINDER:int = 9;
        private static const _COL_TYPE_OTHER:int  = -1;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["所持しているデッキです。\nデッキに存在するカードが表示されます。"],
                [_TRANS_HELP_DECK],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _EDIT_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function BaseDeckClip(cardDeck:IDeck)
        {
            _deck = cardDeck;
//             Unlight.GCW.watch(_container);
//             Unlight.GCW.watch(_deckCase);
//             Unlight.GCW.watch(_cccDic);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
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

        // 初期化処理
        public override function init():void
        {
//            log.writeLog(log.LV_FATAL, this, "deck clip init",_deck);
            if(_deck)
            {
                _deck.cardInventories.forEach(function(cci:ICardInventory, index:int, array:Array):void{clipInitialize(cci)});
            }
//             _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_CHARA, deckToBinderHandler);
//             _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_CHARA, binderToDeckHandler);
            _deckCase.addEventListener(DeckCase.CHANGE_CHARA, pushTabCharaHandler);
            _deckCase.addEventListener(DeckCase.CHANGE_EQUIP, pushTabEquipHandler);
            _deckCase.addEventListener(DeckCase.CHANGE_EVENT, pushTabEventHandler);

            _container.addChild(_deckCase);
            addChild(_backContainer);
            addChild(_container);
            addChild(_frontContainer);

            initilizeToolTipOwners();
            updateHelp(_EDIT_HELP);
        }

        // 後始末処理
        public override function final():void
        {
            removeMouseEventHandler();
            for (var key:Object in _cccDic)
            {
                clipFinalize(_cccDic[key]);
                delete _cccDic[key];
            }
            _cccDic = null;
//             _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_CHARA, deckToBinderHandler);
//             _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_CHARA, binderToDeckHandler);
            _deckCase.removeEventListener(DeckCase.CHANGE_CHARA, pushTabCharaHandler);
            _deckCase.removeEventListener(DeckCase.CHANGE_EQUIP, pushTabEquipHandler);
            _deckCase.removeEventListener(DeckCase.CHANGE_EVENT, pushTabEventHandler);
            _deckCase.finalizeEvent();
            removeChild(_frontContainer);
            removeChild(_container);
            removeChild(_backContainer);
        }

        // クリップの初期化
        protected function clipInitialize(cci:ICardInventory):void
        {
//             var cc:CharaCardClip = new CharaCardClip(CharaCard(cci.card));

//             cc.cardInventory = cci;
//             cc.x = _CARD_X + _CARD_OFFSET_X * CharaCardInventory(cc.cardInventory).position;
//             cc.y = _CARD_Y;
//             cc.scaleX = _CARD_SCALE;
//             cc.scaleY = _CARD_SCALE;
//             cc.getEditShowThread(_container).start();
//             _ccSet.push(cc);
        }

        // クリップの後始末処理
        protected function clipFinalize(cc:ICardClip):void
        {
//            cc.getEditHideThread().start();
        }

        // クリップの更新
        protected function clipUpdate(cc:ICardClip):void
        {
//            new TweenerThread(cc, {x:_CARD_X + _CARD_OFFSET_X * cc.charaCardInventory.position, y:_CARD_Y, transition:"easeOutSine", time:0.20}).start();
            new BeTweenAS3Thread(cc, {x:_CARD_X+_CARD_OFFSET_X*CharaCardInventory(cc.cardInventory).position ,y:_CARD_Y}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE).start();
        }

        // クリップの更新
        public function update():void
        {
            for (var key:Object in _cccDic)
            {
                clipUpdate(_cccDic[key])
            }
        }

        protected function clipUpdateNow(cc:ICardClip):void
        {
//            new TweenerThread(cc, {x:_CARD_X + _CARD_OFFSET_X * cc.charaCardInventory.position, y:_CARD_Y, transition:"easeOutSine", time:0.20}).start();
            DisplayObject(cc).x = _CARD_X+_CARD_OFFSET_X*CharaCardInventory(cc.cardInventory).position;
            DisplayObject(cc).y = _CARD_Y;
        }
        // クリップの更新即時更新（TWEENを使わない）
        public function updateNow():void
        {
            for (var key:Object in _cccDic)
            {
                clipUpdateNow(_cccDic[key])
            }
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;

            if(type == "edit")
            {
                return new EditShowThread(this, stage, at);
            }
            else
            {
                return new ShowThread(this, stage, at);
            }
        }

        // 非表示スレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        // マウスイベントを付加する
        public function addMouseEventHandler():void
        {
            for (var key:Object in _cccDic)
            {
                _cccDic[key].addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
                _cccDic[key].addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            };
        }

        // マウスイベントを削除する
        public function removeMouseEventHandler():void
        {
            for (var key:Object in _cccDic)
            {
                _cccDic[key].removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
                _cccDic[key].removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            };
        }

        // 配置変更ができるタブか
        private function canPosEditTab():Boolean
        {
            return (_deckEditor.editType == InventorySet.TYPE_CHARA||_deckEditor.editType == InventorySet.TYPE_MONSTER||_deckEditor.editType == InventorySet.TYPE_OTHER);
        }

        // マウスダウン処理
        private function mouseDownHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_DEBUG, this, "mouseDownHandler","basedeckclip");
            SE.playDeckCardClick();
            var point:Point = e.currentTarget.localToGlobal(new Point(e.currentTarget.x,e.currentTarget.y));

            e.currentTarget.startDrag();
//            if (canPosEditTab()) {
            if (_combine.state != Combine.COMBINES) {
                e.currentTarget.parent.setChildIndex(e.currentTarget, e.currentTarget.parent.numChildren-1);
                e.currentTarget.parent.parent.setChildIndex(e.currentTarget.parent, e.currentTarget.parent.parent.numChildren-1);
                e.currentTarget.parent.parent.parent.setChildIndex(e.currentTarget.parent.parent, e.currentTarget.parent.parent.parent.numChildren-1);
            }
            e.currentTarget.parent.parent.parent.parent.parent.setChildIndex(e.currentTarget.parent.parent.parent.parent, e.currentTarget.parent.parent.parent.parent.parent.numChildren-1);

            e.currentTarget.alpha = 0.5;
        }

        // // マウスアップ処理
        // private function mouseUpHandler(e:MouseEvent):void
        // {
        //     var cc:BaseScene = BaseScene(e.currentTarget);
        //     cc.stopDrag();
        //     cc.alpha = 1.0;

        //     if (collision(e))
        //     {
        //         removeCard(ICardClip(cc));
        //     }
        //     else
        //     {
        //         clipUpdate(ICardClip(cc));
        //     }
        // }

        // // バインダーとの当たり判定を返す関数
        // private function collision(e:MouseEvent):Boolean
        // {
        //     log.writeLog(log.LV_DEBUG, this, "e x",e.stageX, "e y",e.stageY);
        //     if(e.stageX > _BINDER_X && e.stageX < _BINDER_X2 && e.stageY > _BINDER_Y && e.stageY < _BINDER_Y2)
        //     {
        //         log.writeLog(log.LV_DEBUG, this, "collision binder hit");
        //         return true;
        //     }
        //     else
        //     {
        //         log.writeLog(log.LV_DEBUG, this, "collision binder or deck card not hit");
        //         return false;
        //     }
        // }

        // マウスアップ処理
        private function mouseUpHandler(e:MouseEvent):void
        {
            var c_type:int = 0;  // By_K2
            var c_pos:int = 0;   // By_K2
            var c_index:int = 0; // By_K2
            var cc:BaseScene = BaseScene(e.currentTarget);
            cc.stopDrag();
            cc.alpha = 1.0;

            // デッキ内カード移動
            c_type = collision(e);

            if (canPosEditTab() && (c_type == _COL_TYPE_CARD1 || c_type == _COL_TYPE_CARD2 || c_type == _COL_TYPE_CARD3))
            {
                c_pos = CharaCardInventory(ICardClip(cc).cardInventory).position;
                c_index = CharaCardInventory(ICardClip(cc).cardInventory).index;

                if (c_pos == c_type || CharaCardDeck.decks[c_index].cardInventories.length < 3)
                {
                    clipUpdate(ICardClip(cc));
                }
                else
                {
                    var cci1:CharaCardInventory = CharaCardDeck.decks[c_index].cardInventories[c_pos];
                    var cci2:CharaCardInventory = CharaCardDeck.decks[c_index].cardInventories[c_type];
                    var ch_monstar:Boolean = false;

                    // モンスターカードは先頭に配置はできない
                    if (c_type == _COL_TYPE_CARD1 && (cci1.charaCard.kind == Const.CC_KIND_MONSTAR || cci1.charaCard.kind == Const.CC_KIND_RARE_MONSTAR))
                    {
                        ch_monstar = true;
                        Alerter.showWithSize(_TRANS_SORT_CHK, _TRANS_ALERT);
                    }
                    else if (c_pos == _COL_TYPE_CARD1 && (cci2.charaCard.kind == Const.CC_KIND_MONSTAR || cci2.charaCard.kind == Const.CC_KIND_RARE_MONSTAR))
                    {
                        ch_monstar = true;
                        Alerter.showWithSize(_TRANS_SORT_CHK, _TRANS_ALERT);
                    }

                    if (ch_monstar == true)
                    {
                        clipUpdate(ICardClip(cc));
                    }
                    else
                    {
                        var ccw1:Array = WeaponCardDeck.decks[c_index].getPositionCard(c_pos);
                        var ccw2:Array = WeaponCardDeck.decks[c_index].getPositionCard(c_type);
                        var cce1:Array = EventCardDeck.decks[c_index].getPositionCard(c_pos);
                        var cce2:Array = EventCardDeck.decks[c_index].getPositionCard(c_type);

                        cci1.position = c_type;
                        cci2.position = c_pos;

                        ccw1.forEach(function(item:WeaponCardInventory, index:int, array:Array):void{
                                item.position = c_type;
                            });

                        ccw2.forEach(function(item:WeaponCardInventory, index:int, array:Array):void{
                                item.position = c_pos;
                            });

                        cce1.forEach(function(item:EventCardInventory, index:int, array:Array):void{
                                item.position = c_type;
                            });

                        cce2.forEach(function(item:EventCardInventory, index:int, array:Array):void{
                                item.position = c_pos;
                            });

                        CharaCardDeck.decks[c_index].sortDeck();

                        changePosCard(c_index);
                    }
                }
            }
            else if (c_type == _COL_TYPE_BINDER)
            {
                removeCard(ICardClip(cc));
            }
            else
            {
                clipUpdate(ICardClip(cc));
            }
        }

        // バインダーとの当たり判定を返す関数
        private function collision(e:MouseEvent):int
        {
            log.writeLog(log.LV_DEBUG, this, "e x",e.stageX, "e y",e.stageY);
            if (e.stageX > _DECK_CARD1_X && e.stageX < _DECK_CARD1_X2 && e.stageY > _DECK_CARD_Y && e.stageY < _DECK_CARD_Y2)
            {
                log.writeLog(log.LV_DEBUG, this, "collision deck card 1 hit");
                return _COL_TYPE_CARD1;
            }
            else if (e.stageX > _DECK_CARD2_X && e.stageX < _DECK_CARD2_X2 && e.stageY > _DECK_CARD_Y && e.stageY < _DECK_CARD_Y2)
            {
                log.writeLog(log.LV_DEBUG, this, "collision deck card 2 hit");
                return _COL_TYPE_CARD2;
            }
            else if (e.stageX > _DECK_CARD3_X && e.stageX < _DECK_CARD3_X2 && e.stageY > _DECK_CARD_Y && e.stageY < _DECK_CARD_Y2)
            {
                log.writeLog(log.LV_DEBUG, this, "collision deck card 3 hit");
                return _COL_TYPE_CARD3;
            }
            else if(e.stageX > _BINDER_X && e.stageX < _BINDER_X2 && e.stageY > _BINDER_Y && e.stageY < _BINDER_Y2)
            {
                log.writeLog(log.LV_DEBUG, this, "collision binder hit");
                return _COL_TYPE_BINDER;
            }
            else
            {
                log.writeLog(log.LV_DEBUG, this, "collision binder or deck card not hit");
                return _COL_TYPE_OTHER;
            }
        }

        // カードを足す
        protected function addCard(cci:ICardInventory):void
        {
            clipInitialize(cci);
            addMouseEventHandler();
            update();
        }

        // カードを瞬時に足す
        protected function addCardNow(cci:ICardInventory):void
        {
            clipInitialize(cci);
            addMouseEventHandler();
            updateNow();
        }

        // カードを消す
        protected function removeCard(cc:ICardClip):void
        {
//            _deckEditor.deckToBinderCharaCard(CharaCardInventory(cc.cardInventory));
        }

        protected function changePosCard(index:int):void
        {
        }

        // コスト計算用の枠を表示する
        public function getShowCostFrame():Thread
        {
            return _deckCase.getShowCostFrameThread();
        }

        // タブ切り替えイベント
        public function pushTabCharaHandler(e:Event):void
        {
            _deckEditor.setEditType(InventorySet.TYPE_CHARA);
        }

        // タブ切り替えイベント
        public function pushTabEquipHandler(e:Event):void
        {
            _deckEditor.setEditType(InventorySet.TYPE_WEAPON);
        }

        // タブ切り替えイベント
        public function pushTabEventHandler(e:Event):void
        {
            _deckEditor.setEditType(InventorySet.TYPE_EVENT);
        }

        // カードが追加される
        public function binderToDeckHandler(e:EditCardEvent):void
        {
//             if(CharaardDeck.decks[e.cci.index] == _deck)
//             {
//                 addCard(e.cci);
//             }
        }
        // カードが追加される
        public function deckToDeckHandler(e:EditCardEvent):void
        {
//             if(CharaardDeck.decks[e.cci.index] == _deck)
//             {
//                 addCard(e.cci);
//             }
        }

        // カードが除外される
        public function deckToBinderHandler(e:EditCardEvent):void
        {
            for (var key:Object in _cccDic)
            {
                if(_cccDic[key] && _cccDic[key].cardInventory == e.cci)
                {
                    clipFinalize(_cccDic[key]);
                    delete _cccDic[key];
                }
            }
            update();
        }

    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.DeckEditor;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.edit.BaseDeckClip;

// デッキのShowThread
class ShowThread extends BaseShowThread
{
    public function ShowThread(ccdc:BaseDeckClip, stage:DisplayObjectContainer, at:int)
    {
        super(ccdc, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(ccdc:BaseDeckClip)
    {
        ccdc.removeMouseEventHandler();
        super(ccdc);
    }
}

// ドラッグできるデッキのShowThread
class EditShowThread extends BaseShowThread
{
    private var _ccdc:BaseDeckClip;

    public function EditShowThread(ccdc:BaseDeckClip, stage:DisplayObjectContainer, at:int)
    {
        _ccdc = ccdc;
        super(ccdc, stage);
    }

    protected override function run():void
    {
        _ccdc.init();
        _ccdc.addMouseEventHandler();
        addStageAt();
    }
}
