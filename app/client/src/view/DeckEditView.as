package view
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;
    import mx.core.MovieClipLoaderAsset;
    import mx.controls.Button;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.DeckEditor;
    import model.Growth;
    import model.Combine;
    import model.WeaponCardInventory;
    import model.events.*;
    import view.image.edit.*;
    import view.scene.edit.*;;
    import view.scene.common.*;;
    import view.RealMoneyShopView;

    import controller.LobbyCtrl;
    import controller.GlobalChatCtrl;
    
    // test
    import model.Player;
    import model.CharaCard;
    import model.InventorySet;
    import view.scene.common.CharaCardClip;
    import view.utils.*;

    /**
     * 編集画面のビュークラス
     *
     */
    public class DeckEditView extends Thread
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "デッキ編集";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Deck Editor";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "編輯牌組";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "卡组编辑";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "덱 편집";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Modification de votre pioche.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "デッキ編集";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "แก้ไขสำรับ";


        // コントローラ
        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;

        // エディットインスタンス
        private var _deckEdit:DeckEditor = DeckEditor.instance;

        // 成長インスタンス
        private var _growth:Growth = Growth.instance;

        // 合成インスタンス
        private var _combine:Combine = Combine.instance;

        // 親ステージ
        private var _stage:Sprite;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();
        // 合成コンテナ
        private var _compoContainer:UIComponent = new UIComponent();
        // アバタービューコンテナ
        private var _avatarContainer:UIComponent = new UIComponent();

        // 背景
        private var _bg:BG = new BG();

        // バインダー部分
        private var _ccBinderArea:BinderArea = BinderArea.getCharaCardBinder();
        private var _wpBinderArea:BinderArea = BinderArea.getWeaponCardBinder();
        private var _eqBinderArea:BinderArea = BinderArea.getEquipCardBinder();
        private var _evBinderArea:BinderArea = BinderArea.getEventCardBinder();
        private var _mcBinderArea:BinderArea = BinderArea.getMonsterCardBinder();
        private var _ocBinderArea:BinderArea = BinderArea.getOtherCardBinder();
        // バインダーの配列
        private var _binderArea:Array = [_ccBinderArea, _wpBinderArea, _eqBinderArea, _evBinderArea, _mcBinderArea, _ocBinderArea];

        // デッキ部分
        private var _ccDeckArea:DeckArea = DeckArea.getCharaCardDeck();
        private var _wpDeckArea:DeckArea = DeckArea.getWeaponCardDeck();
        //private var _eqDeckArea:DeckArea = DeckArea.getEquipCardDeck();
        private var _evDeckArea:DeckArea = DeckArea.getEventCardDeck();
        //private var _mcDeckArea:DeckArea = DeckArea.getMonsterCardDeck();
        //private var _ocDeckArea:DeckArea = DeckArea.getOtherCardDeck();
        // デッキの配列  # モンス・その他はキャラデッキを使う 2014/09/02
        private var _deckArea:Array = [_ccDeckArea, _wpDeckArea, null, _evDeckArea, null, null];

        // カードデータ部分
        private var _ccDataArea:DataArea = DataArea.getCharaCardData();
        private var _wpDataArea:DataArea = DataArea.getWeaponCardData();
        //private var _eqDataArea:DataArea = DataArea.getEquipCardData();
        private var _evDataArea:DataArea = DataArea.getEventCardData();
        //private var _mcDataArea:DataArea = DataArea.getMonsterCardData();
        //private var _ocDataArea:DataArea = DataArea.getOtherCardData();
        // カードデータの配列  # モンス・その他はキャラデータを使う 2014/09/02
        private var _dataArea:Array = [_ccDataArea, _wpDataArea, null, _evDataArea, null, null];

        // ソート表示
        private var _sortArea:SortArea = new SortArea();

        private var _selectArea:SelectArea = new SelectArea();

        // 複製確認パネル
        private var _dupeSendPanel:DupeSendPanel = new DupeSendPanel();

        // デッキセット
//        private var _deckSetButton:DeckSetButton = new DeckSetButton();

        // バインダーのタイプ
        private var _editType:int;

        // タイトル表示
        private var _title:Label = new Label();
        private var _titleJ:Label = new Label();

        // 系統樹
        private var _requirementsView:RequirementsView;
        // 合成
        private var _combinesView:CombinesView;

        private var _avatarView:AvatarView = AvatarView.getPlayerAvatar(Const.PL_AVATAR_EDIT);

        private var _player:Player = Player.instance;

        // 定数
        private const _TITLE_X:int = 15;
        private const _TITLE_Y:int = 5;
        private const _TITLE_WIDTH:int = 100;
        private const _TITLE_HEIGHT:int = 20;
        private const _J_TITLE_WIDTH:int = 100;
        private const _J_TITLE_HEIGHT:int = 20;

        // かけら販売フラグ
        private const _SELL_TIPS:Boolean = true;

        //テスト
//        private var _testcccs:Array = []

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */
        public function DeckEditView(stage:Sprite)
        {
            _stage = stage;
            _dupeSendPanel.visible = false;
//            Unlight.GCW.watch(_bg,"BGです");
            RaidHelpView.instance.isUpdate = true;
        }

        // スレッドのスタート
        override protected  function run():void
        {
            _deckEdit.initialize();

            // RMItemShopの更新が必要であれば行う
            RealMoneyShopView.itemReset();

            // イベントの登録
             _avatarView.exitButton.addEventListener(MouseEvent.CLICK, pushExitButtonHandler);
            _bg.deckDelete.addEventListener(MouseEvent.CLICK, pushDeleteButtonHandler);
//            _deckSetButton.addEventListener(MouseEvent.CLICK, pushCurrentButtonHandler);
            _bg.back.addEventListener(MouseEvent.CLICK, pushLeftButtonHandler);
            _bg.next.addEventListener(MouseEvent.CLICK, pushRightButtonHandler);
            _bg.binderNext.addEventListener(MouseEvent.CLICK, pushNextButtonHandler);
            _bg.binderPrev.addEventListener(MouseEvent.CLICK, pushPrevButtonHandler);
            _dupeSendPanel.yesButton.addEventListener(MouseEvent.CLICK, pushYesDupeButtonHandler);
            _dupeSendPanel.noButton.addEventListener(MouseEvent.CLICK, pushNoDupeButtonHandler);
            _ctrl.addEventListener(LobbyCtrl.REQUEST_COPY_CARD, showDupeSendPanelHandler);
            _ctrl.addEventListener(CharaCardEvent.COPY_CHARA_CARD, copyDoneHandler);
            _deckEdit.addEventListener(DeckEditor.CHANGE_TYPE, chnageEditTypeHandler);
            _dataArea[InventorySet.TYPE_CHARA].storyButton = _bg.story;
            _dataArea[InventorySet.TYPE_CHARA].compoButton = _bg.compo;
            _dataArea[InventorySet.TYPE_CHARA].dupeButton = _bg.dupe;
            _deckArea[InventorySet.TYPE_CHARA].addEventListener(DeckUpdatedEvent.UPDATED_CHARA_CARD, deckUpdatedHandler);

            // 武器合成アリか
            CONFIG::WEAPON_COMBINE_ON
            {
                _dataArea[InventorySet.TYPE_WEAPON].compoButton = _bg.compo;
            }

            //_dataArea[InventorySet.TYPE_MONSTER].storyButton = _bg.story;
            //_dataArea[InventorySet.TYPE_MONSTER].compoButton = _bg.compo;
            //_dataArea[InventorySet.TYPE_MONSTER].dupeButton = _bg.dupe;
            //_deckArea[InventorySet.TYPE_MONSTER].addEventListener(DeckUpdatedEvent.UPDATED_CHARA_CARD, deckUpdatedHandler);
            //_dataArea[InventorySet.TYPE_OTHER].storyButton = _bg.story;
            //_dataArea[InventorySet.TYPE_OTHER].compoButton = _bg.compo;
            //_dataArea[InventorySet.TYPE_OTHER].dupeButton = _bg.dupe;
            //_deckArea[InventorySet.TYPE_OTHER].addEventListener(DeckUpdatedEvent.UPDATED_CHARA_CARD, deckUpdatedHandler);
            RealMoneyShopView.shopCloseButton.addEventListener(MouseEvent.CLICK, rmShopCloseclickHandler);

            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);

            // レイドヘルプイベント
            GlobalChatCtrl.instance.addEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);

            next(initTitle);
        }

        // タイトルの初期化
        private function initTitle():void
        {
            _avatarView.alpha = 0.0;
            _bg.alpha = 0.0;
            _sortArea.alpha = 0.0;
            _selectArea.alpha = 0.0;
            _binderArea[_editType].alpha = 0.0;
            // デッキとデータは一部共通化
            if (_editType == _deckEdit.substanceEditType(_editType))
            {
                _deckArea[_editType].alpha = 0.0;
                _dataArea[_editType].alpha = 0.0;
            }
//            _deckSetButton.alpha = 0.0;

            _title.x = _TITLE_X;
            _title.y = _TITLE_Y;
            _title.width = _TITLE_WIDTH;
            _title.height = _TITLE_HEIGHT;
            _title.text = "DeckEdit";
            _title.styleName = "EditTitleLabel";
            _title.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
            _title.alpha = 0.0;
            _title.mouseEnabled = false;
            _title.mouseChildren = false;

            _titleJ.x = _TITLE_X + 85;
            _titleJ.y = _TITLE_Y + 7;
            _titleJ.width = _J_TITLE_WIDTH;
            _titleJ.height = _J_TITLE_HEIGHT;
//            _titleJ.text = "デッキ編集";
            _titleJ.text = _TRANS_MSG;
            _titleJ.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            _titleJ.alpha = 0.0;
            _titleJ.mouseEnabled = false;
            _titleJ.mouseChildren = false;
            _avatarView.refreshType()

            next(show);
        }

        // 配置オブジェの表示
        private function show():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(_bg.getShowThread(_container, 0));           // 背景
//            pExec.addThread(_deckSetButton.getShowThread(_container, 1));           // デッキセットボタン
            pExec.addThread(_sortArea.getShowThread(_container, 21));     // ソート
            pExec.addThread(_selectArea.getShowThread(_container, 21));
            pExec.addThread(_dataArea[InventorySet.TYPE_CHARA].getShowThread(_container,     3));   // カードデータ
            pExec.addThread(_dataArea[InventorySet.TYPE_WEAPON].getShowThread(_container,    4));   // カードデータ
            //pExec.addThread(_dataArea[InventorySet.TYPE_EQUIP].getShowThread(_container,     5));   // カードデータ
            pExec.addThread(_dataArea[InventorySet.TYPE_EVENT].getShowThread(_container,     6));   // カードデータ
            //pExec.addThread(_dataArea[InventorySet.TYPE_MONSTER].getShowThread(_container,   7));   // カードデータ
            //pExec.addThread(_dataArea[InventorySet.TYPE_OTHER].getShowThread(_container,     8));   // カードデータ
            pExec.addThread(_binderArea[InventorySet.TYPE_CHARA].getShowThread(_container,   9));   // バインダー
            pExec.addThread(_binderArea[InventorySet.TYPE_WEAPON].getShowThread(_container,  10));   // バインダー
            pExec.addThread(_binderArea[InventorySet.TYPE_EQUIP].getShowThread(_container,   11));   // バインダー
            pExec.addThread(_binderArea[InventorySet.TYPE_EVENT].getShowThread(_container,   12));   // バインダー
            pExec.addThread(_binderArea[InventorySet.TYPE_MONSTER].getShowThread(_container, 13));   // バインダー
            pExec.addThread(_binderArea[InventorySet.TYPE_OTHER].getShowThread(_container,   14));   // バインダー
            pExec.addThread(_deckArea[InventorySet.TYPE_CHARA].getShowThread(_container,     15));   // デッキ
            pExec.addThread(_deckArea[InventorySet.TYPE_WEAPON].getShowThread(_container,    16));   // デッキ
            //pExec.addThread(_deckArea[InventorySet.TYPE_EQUIP].getShowThread(_container,     17));   // デッキ
            pExec.addThread(_deckArea[InventorySet.TYPE_EVENT].getShowThread(_container,     18));   // デッキ
            //pExec.addThread(_deckArea[InventorySet.TYPE_MONSTER].getShowThread(_container,   19));   // デッキ
            //pExec.addThread(_deckArea[InventorySet.TYPE_OTHER].getShowThread(_container,     20));   // デッキ
//             _testcccs.forEach(function(item:*, index:int, array:Array):void{item.getShowThread(_container).start()})

            pExec.start();
            pExec.join();

            _stage.addChildAt(_container, 1);
            _stage.addChildAt(_compoContainer, 2);
            _stage.addChildAt(_avatarContainer, 3);
            _stage.addChildAt(_dupeSendPanel, 4);

            _deckEdit.waiting();

            _avatarContainer.addChild(_title);
            _avatarContainer.addChild(_titleJ);

            next(show2);
        }

        // 配置オブジェの表示
        private function show2():void
        {
            _bg.tabChara.addEventListener(MouseEvent.CLICK, charaCardTabClickHandler);
            _bg.tabEquip.addEventListener(MouseEvent.CLICK, weaponCardTabClickHandler);
            _bg.tabEvent.addEventListener(MouseEvent.CLICK, eventCardTabClickHandler);
            _bg.tabMonster.addEventListener(MouseEvent.CLICK, monsterCardTabClickHandler);
            _bg.tabOther.addEventListener(MouseEvent.CLICK, otherCardTabClickHandler);

            _deckEdit.setEditType(InventorySet.TYPE_CHARA);

            var pExec:ParallelExecutor = new ParallelExecutor();
//            _stage.addChildAt(_deckSetButton, 3);
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_bg, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_sortArea, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_selectArea, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_dataArea[_deckEdit.substanceEditType(_editType)], {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_binderArea[_editType], {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_deckArea[_deckEdit.substanceEditType(_editType)], {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
//             pExec.addThread(new BeTweenAS3Thread(_avatarView, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(_avatarView.getShowThread(_avatarContainer,0));           // アバター情報
//            pExec.addThread(new BeTweenAS3Thread(_deckSetButton, {alpha:1.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            pExec.start();
            pExec.join();

            next(initPayment);
        }

        CONFIG::PAYMENT
        private function initPayment():void
        {
            if(_SELL_TIPS)
            {
                _container.addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_EX_CARD));
            }
            next(waiting);
        }

        CONFIG::NOT_PAYMENT
        private function initPayment():void
        {
//            addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_EX_CARD));
            next(waiting);
        }

        // ループ
        private function waiting():void
        {
            // ステートでループ
            if (_player.state == Player.STATE_LOGOUT)
            {
                 next(hide);
            }else  if(_deckEdit.state == DeckEditor.END)
            {
                next(hide);
            }
            else if(_growth.state == Growth.REQUIREMENTS)
            {
                next(requirements);
            }
            else if(_combine.state == Combine.COMBINES)
            {
                next(combines);
            }
            else
            {
                next(waiting);
            }


        }

        // 系統樹を表示
        private function requirements():void
        {
            RaidHelpView.instance.isUpdate = false;

            var pExec:ParallelExecutor = new ParallelExecutor();
            _requirementsView = new RequirementsView(_compoContainer, _growth.requirementsCardId)

            pExec.addThread(_requirementsView);

//            _deckSetButton.visible = false;
//            _avatarView.exitButton.visible = false;

            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, pushExitButtonHandler);
            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, _requirementsView.exitHandler);

            _container.removeChild(_binderArea[_editType]);
            _binderArea[_editType].visible =false;
            _avatarView.stopUpdateTimer();
            RealMoneyShopView.offShopButton(RealMoneyShopView.TYPE_AVATAR);
            pExec.start();
            pExec.join();
            next(requirementFinish)

        }

        private function requirementFinish():void
        {
//            _deckSetButton.visible = true;
            _binderArea[_editType].visible =true;
            _container.addChild(_binderArea[_editType]);

//            _avatarView.exitButton.visible = true;
            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, _requirementsView.exitHandler);
            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, pushExitButtonHandler);
            _requirementsView = null;

            _binderArea[_editType].show();
            // 選択済みのカードが枚数０だったら消す
            if (CharaCard.ID(_dataArea[_deckEdit.substanceEditType(_editType)].ccc.charaCard.id).num > 0)
            {
                _dataArea[_deckEdit.substanceEditType(_editType)].showCard();
            }else{
                _dataArea[_deckEdit.substanceEditType(_editType)].clearCard();
            }

            _avatarView.startUpdateTimer();

            _deckEdit.waiting();

            RaidHelpView.instance.isUpdate = true;

            next(waiting);
        }

        // 合成画面を表示
        private function combines():void
        {
            RaidHelpView.instance.isUpdate = false;

            var pExec:ParallelExecutor = new ParallelExecutor();
            var selInvId:int = 0;
            var wci:WeaponCardInventory = _dataArea[_editType].selectInventory;
            if (wci) {
                selInvId = wci.inventoryID;
            }
            _combinesView = new CombinesView(_compoContainer, selInvId,_binderArea[_editType])

            pExec.addThread(_combinesView);

            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, pushExitButtonHandler);
            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, _combinesView.exitHandler);

            _container.removeChild(_binderArea[_editType]);
            _binderArea[_editType].visible =false;
            setTabBtnEnableCombine(false);
            pExec.start();
            pExec.join();
            next(combineFinish)

        }

        private function combineFinish():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            _binderArea[_editType].visible =true;
            _container.addChild(_binderArea[_editType]);

            _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, _combinesView.exitHandler);
            _avatarView.exitButton.addEventListener(MouseEvent.CLICK, pushExitButtonHandler);
            _combinesView = null;

            _binderArea[_editType].alpha = 1.0;
            _binderArea[_editType].show();
            setTabBtnEnableCombine(true);

            _deckEdit.waiting();
            pExec.start();
            pExec.join();
            tabDataAreaUpdate(InventorySet.TYPE_WEAPON);

            RaidHelpView.instance.isUpdate = true;

            next(waiting);
        }
        private function setTabBtnEnableCombine(f:Boolean):void
        {
            _bg.tabChara.mouseEnabled = f;
            _bg.tabEquip.mouseEnabled = f;
            _bg.tabEvent.mouseEnabled = f;
            _bg.tabMonster.mouseEnabled = f;
            _bg.tabOther.mouseEnabled = f;
        }

        private function deckUpdatedHandler(e:DeckUpdatedEvent):void
        {
            _deckEdit.updateCautions(e);
        }

        // 左にデッキ切り替え
        private function pushLeftButtonHandler(e:MouseEvent):void
        {
            var subType:uint = _deckEdit.substanceEditType(_editType);
            if(_deckArea[subType].flag)
            {
                SE.playClick();
                _deckArea[subType].currentIndex = _deckArea[subType].currentIndex - 1;

                _deckArea[InventorySet.TYPE_CHARA].changeDeck(true);
                _deckArea[InventorySet.TYPE_WEAPON].changeDeck(true);
                //_deckArea[InventorySet.TYPE_EQUIP].changeDeck(true);
                _deckArea[InventorySet.TYPE_EVENT].changeDeck(true);
                //_deckArea[InventorySet.TYPE_MONSTER].changeDeck(true);
                //_deckArea[InventorySet.TYPE_OTHER].changeDeck(true);
            }
        }

        // 右にデッキ切り替え
        private function pushRightButtonHandler(e:MouseEvent):void
        {
            var subType:uint = _deckEdit.substanceEditType(_editType);
            if(_deckArea[subType].flag)
            {
                SE.playClick();
                _deckArea[subType].currentIndex = _deckArea[subType].currentIndex + 1;

                _deckArea[InventorySet.TYPE_CHARA].changeDeck(false);
                _deckArea[InventorySet.TYPE_WEAPON].changeDeck(false);
                //_deckArea[InventorySet.TYPE_EQUIP].changeDeck(false);
                _deckArea[InventorySet.TYPE_EVENT].changeDeck(false);
                //_deckArea[InventorySet.TYPE_MONSTER].changeDeck(false);
                //_deckArea[InventorySet.TYPE_OTHER].changeDeck(false);
            }
        }

        // デッキを作成
        private function pushCreateButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            _deckEdit.createDeck();
            log.writeLog(log.LV_INFO, this, "push create deck");
        }

        // デッキを削除
        private function pushDeleteButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            _deckEdit.deleteDeck(_deckEdit.selectIndex);
            log.writeLog(log.LV_INFO, this, "push create deck");
        }

        // カレントデッキ変更
        private function pushCurrentButtonHandler(e:MouseEvent):void
        {
            SE.playClick();

            _deckEdit.changeCurrentDeck(_deckEdit.selectIndex);
            log.writeLog(log.LV_INFO, this, "push current change");
        }

        // 終了
        private function pushExitButtonHandler(e:MouseEvent):void
        {
            SE.playClick();
            _deckEdit.finalize();
            log.writeLog(log.LV_INFO, this, "push exit");
        }

        //  タブのデータエリアをON/OFFする
        private function tabDataAreaUpdate(t:int):void
        {
            // 現在タブのカードのみ出す
            log.writeLog(log.LV_INFO, this, "SHOWCARD TYPE",t);
            log.writeLog(log.LV_INFO, this, "_dataarea size?",_dataArea.length);
            // 他タブのカードを隠す
            _dataArea.forEach(function(item:DataArea, index:int, array:Array):void{
                    if(t != index && _deckEdit.substanceEditType(t) != index && item != null)
                       {
                           log.writeLog(log.LV_INFO, this, "HIDE TYPE",index);
                           item.hideCard();
                       }
                });
            _dataArea[_deckEdit.substanceEditType(t)].showCard();

        }

        // キャラカードを選択
        private function charaCardTabClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "set edit type chara!!");
            _deckEdit.setEditType(InventorySet.TYPE_CHARA);
            tabDataAreaUpdate(InventorySet.TYPE_CHARA);
        }

        // 武器カードを選択
        private function weaponCardTabClickHandler(e:MouseEvent):void
        {
            _deckEdit.setEditType(InventorySet.TYPE_WEAPON);
            tabDataAreaUpdate(InventorySet.TYPE_WEAPON);
        }

        // 装備カードを選択
        private function equipCardTabClickHandler(e:MouseEvent):void
        {
            _deckEdit.setEditType(InventorySet.TYPE_EQUIP);
            tabDataAreaUpdate(InventorySet.TYPE_EQUIP);
        }

        // イベントカードを選択
        private function eventCardTabClickHandler(e:MouseEvent):void
        {
            _deckEdit.setEditType(InventorySet.TYPE_EVENT);
            tabDataAreaUpdate(InventorySet.TYPE_EVENT);
        }

        // モンスターカードを選択
        private function monsterCardTabClickHandler(e:MouseEvent):void
        {
            _deckEdit.setEditType(InventorySet.TYPE_MONSTER);
            tabDataAreaUpdate(InventorySet.TYPE_MONSTER);
        }

        // その他カードを選択
        private function otherCardTabClickHandler(e:MouseEvent):void
        {
            _deckEdit.setEditType(InventorySet.TYPE_OTHER);
            tabDataAreaUpdate(InventorySet.TYPE_OTHER);
        }

        // 編集タイプを変更
        private function chnageEditTypeHandler(e:Event):void
        {
            setEditType(_deckEdit.editType);
        }

        // バインダーを進める
        private function pushNextButtonHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_DEBUG,this,"binder next");
            _binderArea[_editType].page -=1;
        }

        // バインダーを戻す
        private function pushPrevButtonHandler(e:MouseEvent):void
        {
            log.writeLog (log.LV_DEBUG,this,"binder prev");
            _binderArea[_editType].page +=1;
        }

        // 複製確認パネルを表示
        private function showDupeSendPanelHandler(e:Event):void
        {
            _container.mouseEnabled = false;
            _container.mouseChildren = false;
            _dupeSendPanel.visible = true;
        }

        // 複製YES
        private function pushYesDupeButtonHandler(e:MouseEvent):void
        {
            // 表示中のカードをコピー
            if (_editType == InventorySet.TYPE_CHARA || _editType == InventorySet.TYPE_MONSTER || _editType == InventorySet.TYPE_OTHER) {
                _ctrl.copyCard(_dataArea[_deckEdit.substanceEditType(_editType)].ccc.charaCard.id);
            }
            _container.mouseEnabled = true;
            _container.mouseChildren = true;
            _dupeSendPanel.visible = false;
        }

        // 複製NO
        private function pushNoDupeButtonHandler(e:MouseEvent):void
        {
            _container.mouseEnabled = true;
            _container.mouseChildren = true;
            _dupeSendPanel.visible = false;
        }

        // 複製完了後ハンドラ
        private function copyDoneHandler(e:Event):void
        {
            if (_editType == InventorySet.TYPE_CHARA || _editType == InventorySet.TYPE_MONSTER || _editType == InventorySet.TYPE_OTHER) {
                _dataArea[_deckEdit.substanceEditType(_editType)].reloadDupeCount();
            }
        }

        // セールの終了判定が出たときのハンドラ
        private function saleFinishHandler(e:AvatarSaleEvent):void
        {
            // log.writeLog (log.LV_INFO,this,"saleFinish!");
            RealMoneyShopView.hideButtonSaleMC(RealMoneyShopView.TYPE_EX_CARD);
            // ショップアイテムリストの更新
            RealMoneyShopView.itemReset();
        }

        // レイドヘルプハンドラ
        private function helpAcceptHandler(e:RaidHelpEvent):void
        {
            _deckEdit.finalize();
            log.writeLog(log.LV_INFO, this, "raid help");
        }

        // バインダーを戻す
        private function setEditType(val:int):void
        {
           switch (val)
           {
           case InventorySet.TYPE_CHARA:
               _binderArea[InventorySet.TYPE_CHARA].visible = true;
               _binderArea[InventorySet.TYPE_WEAPON].visible = false;
               _binderArea[InventorySet.TYPE_EQUIP].visible = false;
               _binderArea[InventorySet.TYPE_EVENT].visible = false;
               _binderArea[InventorySet.TYPE_MONSTER].visible = false;
               _binderArea[InventorySet.TYPE_OTHER].visible = false;

               _binderArea[InventorySet.TYPE_CHARA].addSortHandler();
               _binderArea[InventorySet.TYPE_WEAPON].removeSortHandler();
               _binderArea[InventorySet.TYPE_EQUIP].removeSortHandler();
               _binderArea[InventorySet.TYPE_EVENT].removeSortHandler();
               _binderArea[InventorySet.TYPE_MONSTER].removeSortHandler();
               _binderArea[InventorySet.TYPE_OTHER].removeSortHandler();

               _deckArea[InventorySet.TYPE_CHARA].visible = true;
               _deckArea[InventorySet.TYPE_WEAPON].visible = false;
               //_deckArea[InventorySet.TYPE_EQUIP].visible = false;
               _deckArea[InventorySet.TYPE_EVENT].visible = false;
               //_deckArea[InventorySet.TYPE_MONSTER].visible = false;
               //_deckArea[InventorySet.TYPE_OTHER].visible = false;
               // 選ばれたデッキは最前線に送る
               _container.setChildIndex(_deckArea[InventorySet.TYPE_CHARA],_container.numChildren-1);

               _dataArea[InventorySet.TYPE_CHARA].visible = true;
               _dataArea[InventorySet.TYPE_WEAPON].visible = false;
               //_dataArea[InventorySet.TYPE_EQUIP].visible = false;
               _dataArea[InventorySet.TYPE_EVENT].visible = false;
               //_dataArea[InventorySet.TYPE_MONSTER].visible = false;
               //_dataArea[InventorySet.TYPE_OTHER].visible = false;

               _dataArea[InventorySet.TYPE_CHARA].dupeCount.visible = false;

               _bg.tabChara.visible = false;
               _bg.tabEquip.visible = true;
               _bg.tabEvent.visible = true;
               _bg.tabMonster.visible = true;
               _bg.tabOther.visible = true;
               _bg.setCharaParameter();
               break;
           case InventorySet.TYPE_WEAPON:
               _binderArea[InventorySet.TYPE_CHARA].visible = false;
               _binderArea[InventorySet.TYPE_WEAPON].visible = true;
               _binderArea[InventorySet.TYPE_EQUIP].visible = false;
               _binderArea[InventorySet.TYPE_EVENT].visible = false;
               _binderArea[InventorySet.TYPE_MONSTER].visible = false;
               _binderArea[InventorySet.TYPE_OTHER].visible = false;

               _binderArea[InventorySet.TYPE_CHARA].removeSortHandler();
               _binderArea[InventorySet.TYPE_WEAPON].addSortHandler();
               _binderArea[InventorySet.TYPE_EQUIP].removeSortHandler();
               _binderArea[InventorySet.TYPE_EVENT].removeSortHandler();
               _binderArea[InventorySet.TYPE_MONSTER].removeSortHandler();
               _binderArea[InventorySet.TYPE_OTHER].removeSortHandler();

               _deckArea[InventorySet.TYPE_CHARA].visible = true;
               _deckArea[InventorySet.TYPE_WEAPON].visible = true;
               //_deckArea[InventorySet.TYPE_EQUIP].visible = false;
               _deckArea[InventorySet.TYPE_EVENT].visible = false;
               //_deckArea[InventorySet.TYPE_MONSTER].visible = false;
               //_deckArea[InventorySet.TYPE_OTHER].visible = false;
               // 選ばれたデッキは最前線に送る
               _container.setChildIndex(_deckArea[InventorySet.TYPE_WEAPON],_container.numChildren-1);


               _dataArea[InventorySet.TYPE_CHARA].visible = false;
               _dataArea[InventorySet.TYPE_WEAPON].visible = true;
               //_dataArea[InventorySet.TYPE_EQUIP].visible = false;
               _dataArea[InventorySet.TYPE_EVENT].visible = false;
               //_dataArea[InventorySet.TYPE_MONSTER].visible = false;
               //_dataArea[InventorySet.TYPE_OTHER].visible = false;

               _bg.compo.visible = false;
                _bg.story.visible = false;
                _bg.dupe.visible = false;
               _bg.tabChara.visible = true;
               _bg.tabEquip.visible = false;
               _bg.tabEvent.visible = true;
               _bg.tabMonster.visible = true;
               _bg.tabOther.visible = true;
               _bg.setEquipParameter();
               break;
           case InventorySet.TYPE_EQUIP:
               _binderArea[InventorySet.TYPE_CHARA].visible = false;
               _binderArea[InventorySet.TYPE_WEAPON].visible = false;
               _binderArea[InventorySet.TYPE_EQUIP].visible = true;
               _binderArea[InventorySet.TYPE_EVENT].visible = false;
               _binderArea[InventorySet.TYPE_MONSTER].visible = false;
               _binderArea[InventorySet.TYPE_OTHER].visible = false;

               _binderArea[InventorySet.TYPE_CHARA].removeSortHandler();
               _binderArea[InventorySet.TYPE_WEAPON].removeSortHandler();
               _binderArea[InventorySet.TYPE_EQUIP].addSortHandler();
               _binderArea[InventorySet.TYPE_EVENT].removeSortHandler();
               _binderArea[InventorySet.TYPE_MONSTER].removeSortHandler();
               _binderArea[InventorySet.TYPE_OTHER].removeSortHandler();


               _deckArea[InventorySet.TYPE_CHARA].visible = false;
               _deckArea[InventorySet.TYPE_WEAPON].visible = false;
               //_deckArea[InventorySet.TYPE_EQUIP].visible = true;
               _deckArea[InventorySet.TYPE_EVENT].visible = false;
               //_deckArea[InventorySet.TYPE_MONSTER].visible = false;
               //_deckArea[InventorySet.TYPE_OTHER].visible = false;
               // 選ばれたデッキは最前線に送る
               _container.setChildIndex(_deckArea[InventorySet.TYPE_EQUIP],_container.numChildren-1);

               _dataArea[InventorySet.TYPE_CHARA].visible = false;
               _dataArea[InventorySet.TYPE_WEAPON].visible = false;
               //_dataArea[InventorySet.TYPE_EQUIP].visible = true;
               _dataArea[InventorySet.TYPE_EVENT].visible = false;
               //_dataArea[InventorySet.TYPE_MONSTER].visible = false;
               //_dataArea[InventorySet.TYPE_OTHER].visible = false;
                _bg.compo.visible = false;
               _bg.story.visible = false;
               _bg.dupe.visible = false;
               _bg.tabChara.visible = true;
               _bg.tabEquip.visible = false;
               _bg.tabEvent.visible = true;
               _bg.tabMonster.visible = true;
               _bg.tabOther.visible = true;
               _bg.setEquipParameter();
               break;
           case InventorySet.TYPE_EVENT:
               _binderArea[InventorySet.TYPE_CHARA].visible = false;
               _binderArea[InventorySet.TYPE_WEAPON].visible = false;
               _binderArea[InventorySet.TYPE_EQUIP].visible = false;
               _binderArea[InventorySet.TYPE_EVENT].visible = true;
               _binderArea[InventorySet.TYPE_MONSTER].visible = false;
               _binderArea[InventorySet.TYPE_OTHER].visible = false;

               _binderArea[InventorySet.TYPE_CHARA].removeSortHandler();
               _binderArea[InventorySet.TYPE_WEAPON].removeSortHandler();
               _binderArea[InventorySet.TYPE_EQUIP].removeSortHandler();
               _binderArea[InventorySet.TYPE_EVENT].addSortHandler();
               _binderArea[InventorySet.TYPE_MONSTER].removeSortHandler();
               _binderArea[InventorySet.TYPE_OTHER].removeSortHandler();

               _deckArea[InventorySet.TYPE_CHARA].visible = true;
               _deckArea[InventorySet.TYPE_WEAPON].visible = false;
               //_deckArea[InventorySet.TYPE_EQUIP].visible = false;
               _deckArea[InventorySet.TYPE_EVENT].visible = true;
               //_deckArea[InventorySet.TYPE_MONSTER].visible = false;
               //_deckArea[InventorySet.TYPE_OTHER].visible = false;
               // 選ばれたデッキは最前線に送る
               _container.setChildIndex(_deckArea[InventorySet.TYPE_EVENT],_container.numChildren-1);

               _dataArea[InventorySet.TYPE_CHARA].visible = false;
               _dataArea[InventorySet.TYPE_WEAPON].visible = false;
               //_dataArea[InventorySet.TYPE_EQUIP].visible = false;
               _dataArea[InventorySet.TYPE_EVENT].visible = true;
               //_dataArea[InventorySet.TYPE_MONSTER].visible = false;
               //_dataArea[InventorySet.TYPE_OTHER].visible = false;
               _bg.compo.visible = false;
               _bg.story.visible = false;
               _bg.dupe.visible = false;
               _bg.tabChara.visible = true;
               _bg.tabEquip.visible = true;
               _bg.tabEvent.visible = false;
               _bg.tabMonster.visible = true;
               _bg.tabOther.visible = true;
               _bg.setEventParameter();
               break;
           case InventorySet.TYPE_MONSTER:
               _binderArea[InventorySet.TYPE_CHARA].visible = false;
               _binderArea[InventorySet.TYPE_WEAPON].visible = false;
               _binderArea[InventorySet.TYPE_EQUIP].visible = false;
               _binderArea[InventorySet.TYPE_EVENT].visible = false;
               _binderArea[InventorySet.TYPE_MONSTER].visible = true;
               _binderArea[InventorySet.TYPE_OTHER].visible = false;

               _binderArea[InventorySet.TYPE_CHARA].removeSortHandler();
               _binderArea[InventorySet.TYPE_WEAPON].removeSortHandler();
               _binderArea[InventorySet.TYPE_EQUIP].removeSortHandler();
               _binderArea[InventorySet.TYPE_EVENT].removeSortHandler();
               _binderArea[InventorySet.TYPE_MONSTER].addSortHandler();
               _binderArea[InventorySet.TYPE_OTHER].removeSortHandler();

               _deckArea[InventorySet.TYPE_CHARA].visible = true;
               _deckArea[InventorySet.TYPE_WEAPON].visible = false;
               //_deckArea[InventorySet.TYPE_EQUIP].visible = false;
               _deckArea[InventorySet.TYPE_EVENT].visible = false;
               //_deckArea[InventorySet.TYPE_MONSTER].visible = false;
               //_deckArea[InventorySet.TYPE_OTHER].visible = false;
               // 選ばれたデッキは最前線に送る
                _container.setChildIndex(_deckArea[InventorySet.TYPE_CHARA],_container.numChildren-1);

               _dataArea[InventorySet.TYPE_CHARA].visible = true;
               _dataArea[InventorySet.TYPE_WEAPON].visible = false;
               //_dataArea[InventorySet.TYPE_EQUIP].visible = false;
               _dataArea[InventorySet.TYPE_EVENT].visible = false;
               //_dataArea[InventorySet.TYPE_MONSTER].visible = true;
               //_dataArea[InventorySet.TYPE_OTHER].visible = false;

               _dataArea[InventorySet.TYPE_CHARA].dupeCount.visible = false;

               _bg.tabChara.visible = true;
               _bg.tabEquip.visible = true;
               _bg.tabEvent.visible = true;
               _bg.tabMonster.visible = false;
               _bg.tabOther.visible = true;
               _bg.setMonsterParameter();
               break;
           case InventorySet.TYPE_OTHER:
               _binderArea[InventorySet.TYPE_CHARA].visible = false;
               _binderArea[InventorySet.TYPE_WEAPON].visible = false;
               _binderArea[InventorySet.TYPE_EQUIP].visible = false;
               _binderArea[InventorySet.TYPE_EVENT].visible = false;
               _binderArea[InventorySet.TYPE_MONSTER].visible = false;
               _binderArea[InventorySet.TYPE_OTHER].visible = true;

               _binderArea[InventorySet.TYPE_CHARA].removeSortHandler();
               _binderArea[InventorySet.TYPE_WEAPON].removeSortHandler();
               _binderArea[InventorySet.TYPE_EQUIP].removeSortHandler();
               _binderArea[InventorySet.TYPE_EVENT].removeSortHandler();
               _binderArea[InventorySet.TYPE_MONSTER].removeSortHandler();
               _binderArea[InventorySet.TYPE_OTHER].addSortHandler();

               _deckArea[InventorySet.TYPE_CHARA].visible = true;
               _deckArea[InventorySet.TYPE_WEAPON].visible = false;
               //_deckArea[InventorySet.TYPE_EQUIP].visible = false;
               _deckArea[InventorySet.TYPE_EVENT].visible = false;
               //_deckArea[InventorySet.TYPE_MONSTER].visible = false;
               //_deckArea[InventorySet.TYPE_OTHER].visible = true;
               // 選ばれたデッキは最前線に送る
               _container.setChildIndex(_deckArea[InventorySet.TYPE_CHARA],_container.numChildren-1);

               _dataArea[InventorySet.TYPE_CHARA].visible = true;
               _dataArea[InventorySet.TYPE_WEAPON].visible = false;
               //_dataArea[InventorySet.TYPE_EQUIP].visible = false;
               _dataArea[InventorySet.TYPE_EVENT].visible = false;
               //_dataArea[InventorySet.TYPE_MONSTER].visible = false;
               //_dataArea[InventorySet.TYPE_OTHER].visible = true;

               _dataArea[InventorySet.TYPE_CHARA].dupeCount.visible = false;

               _bg.tabChara.visible = true;
               _bg.tabEquip.visible = true;
               _bg.tabEvent.visible = true;
               _bg.tabMonster.visible = true;
               _bg.tabOther.visible = false;
               _bg.setOtherParameter();
               break;
           }

           _editType = val;

           // タブがキャラの時だけ、表示
           if (_editType == InventorySet.TYPE_CHARA) {
               _bg.search = true;
           } else {
               _bg.search = false;
           }
        }

        CONFIG::PAYMENT
        private function hide():void
        {
            if(_SELL_TIPS)
            {
                _container.removeChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_EX_CARD));
            }
            next(hide2);
        }

        CONFIG::NOT_PAYMENT
        private function hide():void
        {
//            addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_EX_CARD));
            next(hide2);
        }

        private function hide2():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_dupeSendPanel, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_title, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_titleJ, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_bg, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_sortArea, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_selectArea, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_dataArea[_deckEdit.substanceEditType(_editType)], {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_binderArea[_editType], {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_deckArea[_deckEdit.substanceEditType(_editType)], {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_deckArea[InventorySet.TYPE_CHARA], {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
//            pExec.addThread(new BeTweenAS3Thread(_deckSetButton, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_avatarView, {alpha:0.0}, null, 0.8/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));

            pExec.start();
            pExec.join();

            if (_ctrl.cardInvUpdating) {
                Unlight.INS.loadingReset();
                Unlight.INS.loadingStart();
                next(updateWait);
            } else {
                next(hide3);
            }
            // next(hide3);
        }

        // データ更新待ち
        private function updateWait():void
        {
            log.writeLog(log.LV_DEBUG, this, "updateWait");
            if (_ctrl.cardInvUpdating) {
                next(updateWait);
            } else {
                log.writeLog(log.LV_DEBUG, this, "updateWait end");
                Unlight.INS.loadingEnd();
                next(loadWait);
            }
        }

        // ロードオブジェ待ち
        private function loadWait():void
        {
            log.writeLog(log.LV_DEBUG, this, "loadWait");
            if (Unlight.INS.loadingDisable()) {
                log.writeLog(log.LV_DEBUG, this, "loadWait end");
                next(hide3);
            } else {
                next(loadWait);
            }
        }

        // 配置オブジェの表示
        private function hide3():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(_bg.getHideThread());           // 背景
            pExec.addThread(_ccDataArea.getHideThread());   // データ
            pExec.addThread(_wpDataArea.getHideThread());   // データ
            //pExec.addThread(_eqDataArea.getHideThread());   // データ
            pExec.addThread(_evDataArea.getHideThread());   // データ
            //pExec.addThread(_mcDataArea.getHideThread());   // データ
            //pExec.addThread(_ocDataArea.getHideThread());   // データ
            pExec.addThread(_ccBinderArea.getHideThread());   // バインダー
            pExec.addThread(_wpBinderArea.getHideThread());   // バインダー
            pExec.addThread(_eqBinderArea.getHideThread());   // バインダー
            pExec.addThread(_evBinderArea.getHideThread());   // バインダー
            pExec.addThread(_mcBinderArea.getHideThread());   // バインダー
            pExec.addThread(_ocBinderArea.getHideThread());   // バインダー
            pExec.addThread(_ccDeckArea.getHideThread());   // デッキ
            pExec.addThread(_wpDeckArea.getHideThread());   // デッキ
            //pExec.addThread(_eqDeckArea.getHideThread());   // デッキ
            pExec.addThread(_evDeckArea.getHideThread());   // デッキ
            //pExec.addThread(_mcDeckArea.getHideThread());   // デッキ
            //pExec.addThread(_ocDeckArea.getHideThread());   // デッキ
            pExec.addThread(_selectArea.getHideThread());
            pExec.addThread(_sortArea.getHideThread());     // ソート
            pExec.addThread(_avatarView.getHideThread());     // デッキ
//            pExec.addThread(_deckSetButton.getHideThread());     // デッキ

            pExec.start();
            pExec.join();

            next(exit);
        }


        private function exit():void
        {
            // イベントの消去
//             _bg.exit.removeEventListener(MouseEvent.CLICK, pushExitButtonHandler);
//             _bg.deckCreate.removeEventListener(MouseEvent.CLICK, pushCreateButtonHandler);
            RealMoneyShopView.shopCloseButton.removeEventListener(MouseEvent.CLICK, rmShopCloseclickHandler);
             _avatarView.exitButton.removeEventListener(MouseEvent.CLICK, pushExitButtonHandler);
            _ctrl.removeEventListener(LobbyCtrl.REQUEST_COPY_CARD, showDupeSendPanelHandler);
            _ctrl.removeEventListener(CharaCardEvent.COPY_CHARA_CARD, copyDoneHandler);
            _dupeSendPanel.yesButton.removeEventListener(MouseEvent.CLICK, pushYesDupeButtonHandler);
            _dupeSendPanel.noButton.removeEventListener(MouseEvent.CLICK, pushNoDupeButtonHandler);
            _bg.deckDelete.removeEventListener(MouseEvent.CLICK, pushDeleteButtonHandler);
            _bg.back.removeEventListener(MouseEvent.CLICK, pushLeftButtonHandler);
            _bg.next.removeEventListener(MouseEvent.CLICK, pushRightButtonHandler);
            _bg.binderNext.removeEventListener(MouseEvent.CLICK, pushNextButtonHandler);
            _bg.binderPrev.removeEventListener(MouseEvent.CLICK, pushPrevButtonHandler);
            _bg.tabChara.removeEventListener(MouseEvent.CLICK, charaCardTabClickHandler);
            _bg.tabEquip.removeEventListener(MouseEvent.CLICK, weaponCardTabClickHandler);
            _bg.tabEvent.removeEventListener(MouseEvent.CLICK, eventCardTabClickHandler);
            _bg.tabMonster.removeEventListener(MouseEvent.CLICK, monsterCardTabClickHandler);
            _bg.tabOther.removeEventListener(MouseEvent.CLICK, otherCardTabClickHandler);
            _deckEdit.removeEventListener(DeckEditor.CHANGE_TYPE, chnageEditTypeHandler);
            Player.instance.avatar.removeEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
            // レイドヘルプイベント
            GlobalChatCtrl.instance.removeEventListener(RaidHelpEvent.ACCEPT,helpAcceptHandler);
//            _deckSetButton.removeEventListener(MouseEvent.CLICK, pushCurrentButtonHandler);
            _bg.final();
            _bg = null;
            log.writeLog(log.LV_INFO, this, "edit exit");
        }

        // 終了関数
        override protected function finalize():void
        {
            RemoveChild.apply(_title);
            RemoveChild.apply(_titleJ);
            RemoveChild.apply(_dupeSendPanel);
            RemoveChild.apply(_compoContainer);
            RemoveChild.apply(_avatarContainer);
            RemoveChild.apply(_container);

            log.writeLog (log.LV_WARN,this,"edit end");
        }

        // バインダーを更新
        private function rmShopCloseclickHandler(e:Event):void
        {
            _binderArea[_editType].update();
        }



   }

}
