package view.scene.edit
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;


    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import model.*;

    import model.events.*;

    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.ClousureThread;
    import view.image.edit.*;
    import view.image.requirements.*;
    import view.DeckEditView;
    import controller.LobbyCtrl;

    /**
     * 合成画面のバインダー部分のビュークラス
     *
     */
    public class CombineListArea extends BaseScene
    {

        // エディットインスタンス
        private var _deckEditor:DeckEditor = DeckEditor.instance;
        // 系統樹
        private var _combine:Combine = Combine.instance;

        private var _listImage:CombineListImage = new CombineListImage();

        // オブジェクト
        private var _binder:CharaCardDeck;              // カードバインダーのポインタ
        private var _page:int;                          // 現在のページ数

        private var _cardContainers:Array = [];         // Array of UIComponent
        private var _paramSet:Array = [];               // Array of label
        private var _numBGSet:Array = [];               // Array of CardStock

        private var _cccDic:Dictionary = new Dictionary(); // Dictionary of CCC Key:CharaCard
        private var _cccDicCacheUpdate:Array = []; // Dictionary of CCC Key:CharaCard
        private const _CCC_CACHE_MAX:int = 18*3; // Dictionary of CCC Key:CharaCard

        private var _invSet:Array;                      // Array of InventorySet
        private var _currentPageInvSet:Array;           // Array of InventorySet

        private var _leftContainer:UIComponent = new UIComponent();   // 左ページ表示コンテナ
        private var _rightContainer:UIComponent = new UIComponent();  // 右ページ表示コンテナ

        private var _binderBase:UIComponent = new UIComponent();    // バインダーのベース

        private var _pageNo:Label = new Label();
        private var _pageReloadingThread:PageReloadThread;
        private var _type:int = 0;
        private var _forceReload:Boolean = false;

        private var _currentCharaCardPos:int = 0;

        // コントローラ
        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;


        // 定数
        public static const BINDER_TYPE_CHARA:int = 0;
        public static const BINDER_TYPE_WEAPON:int = 1;
        public static const BINDER_TYPE_EQUIP:int = 2;
        public static const BINDER_TYPE_EVENT:int = 3;
        public static const BINDER_TYPE_MONSTAR:int = 4;
        public static const BINDER_TYPE_OTHER:int = 5;

        private static const _PAGE_SIZE:int = 18;       // 1ページに表示するカード
        private static const _START_PAGE:int = 0;       // 最初に表示するページの番号


        private static const _COLUMN:int = 3;           // 縦列数
        private static const _ROW:int = 3;              // 横列数
        private static const _INV_X:int = 24;           // 初期位置X
        private static const _INV_Y:int = 55;           // 初期位置Y
        private static const _OFFSET_X:int = 88;        // Xのズレ
        private static const _OFFSET_Y:int = 122;       // Yのズレ
        private static const _CARD_SCALE:Number = 0.5;  // カードの大きさ

        private static const _CONTAINAR_X:int = 264;    // コンテナの初期位置X（＃右ページ初期位置）

        private static const _DECK_X:int = 50;            // デッキエリアの開始X
        private static const _DECK_Y:int = 472;          // デッキエリアの開始Y
        private static const _DECK_X2:int = 490;          // デッキエリアの終端X
        private static const _DECK_Y2:int = 722;         // デッキエリアの終端Y

        private static const _DECK_CHARA_LINE1:int = 230;          // デッキエリアのキャラカード判定に使うX位置1

        private static const _DECK_CHARA_LINE2:int = 319;         // デッキエリアのキャラカード判定に使うX位置2

        private static const _BINDER_X:int = 5;            // バインダーの位置X
        private static const _BINDER_Y:int = 42;            // バインダーの位置Y
        private static const _BINDER_WIDTH:int = 652;       // バインダーの横幅
        private static const _BINDER_HEIGHT:int = 382;      // バインダーの縦幅

        private static const _CARD_NUM_X:int = 32;           // カード枚数ーの位置X
        private static const _CARD_NUM_Y:int = 90;          // カード枚数の位置Y
        private static const _CARD_NUM_WIDTH:int = 56;       // カード枚数の横幅
        private static const _CARD_NUM_HEIGHT:int = 20;      // カード枚数の縦幅






        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                //CONFIG::LOCALE_JP <-漢字をチェックを無視する
                ["カードファイルです。\n所持しているキャラクターカードが表示されます。"],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _EDIT_HELP:int = 0;

        // GCtest

//         private var _gcTestObj:GCItem;
//         private var _gcTestCC:CharaCardClip;

        public static function getCharaCardBinder():CombineListArea
        {
            log.writeLog(log.LV_INFO, "chara card binder");
            return new CombineListArea(InventorySet.TYPE_CHARA);
        }
        public static function getWeaponCardBinder():CombineListArea
        {
            log.writeLog(log.LV_INFO, "weapon card binder");
            return new CombineListArea(InventorySet.TYPE_WEAPON);
        }
        public static function getEquipCardBinder():CombineListArea
        {
            log.writeLog(log.LV_INFO,  "equip card binder");
            return new CombineListArea(InventorySet.TYPE_EQUIP);
        }
        public static function getEventCardBinder():CombineListArea
        {
            log.writeLog(log.LV_INFO,  "equip card binder");
            return new CombineListArea(InventorySet.TYPE_EVENT);
        }
        public static function getMonsterCardBinder():CombineListArea
        {
            log.writeLog(log.LV_INFO, "monster card binder");
            return new CombineListArea(InventorySet.TYPE_MONSTER);
        }
        public static function getOtherCardBinder():CombineListArea
        {
            log.writeLog(log.LV_INFO, "other card binder");
            return new CombineListArea(InventorySet.TYPE_OTHER);
        }
        /**
         * コンストラクタ
         *
         */
        public function CombineListArea(type:int)
        {
            _type = type;

            InventorySet.init(_type);
            _invSet = InventorySet.inventories;

            addChild(_listImage);

            initBinder();

            _leftContainer.x = _CONTAINAR_X;
            addChild(_rightContainer);
            addChild(_leftContainer);

            _pageNo.x = 258;
            _pageNo.y = 424;
            _pageNo.width = 60;
            _pageNo.height = 20;
            _pageNo.styleName ="PageLabel"
//            _pageNo.text = "1";
            _pageNo.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            addChild(_pageNo);
            _page = _START_PAGE;
            loadPage();
            show();
            _pageReloadingThread = new PageReloadThread(this);
            _pageReloadingThread.start();
            // Unlight.GCWatch(_pageReloadingThread);
            // Unlight.GCWatch(_cccDic);
            // Unlight.GCWatch(_leftContainer);
            // Unlight.GCWatch(_rightContainer);
            // Unlight.GCWatch(_binderBase);
            // Unlight.GCWatch(_pageNo);
            // Unlight.GCWatch(_cardContainers);
            // Unlight.GCWatch(_paramSet);
            // Unlight.GCWatch(_numBGSet);

        }



        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,_binderBase]);  //
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
        public function addSortHandler():void
        {
            _deckEditor.addEventListener(EditDeckEvent.BINDER_SORT, binderSortHandler);
        }

        public function removeSortHandler():void
        {
            _deckEditor.removeEventListener(EditDeckEvent.BINDER_SORT, binderSortHandler);
        }


        // 初期化
        public override function init():void
        {
            addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            _ctrl.addEventListener(CharaCardEvent.COPY_CHARA_CARD, reloadHandler);
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_CHARA, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_CHARA, binderToDeckHandler);
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_WEAPON, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_WEAPON, binderToDeckHandler);
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_EVENT, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_EVENT, binderToDeckHandler);
            _deckEditor.addEventListener(EditDeckEvent.DELETE_DECK_SUCCESS, deleteDeckHandler);
            _deckEditor.addEventListener(EditDeckEvent.CREATE_DECK_SUCCESS, createDeckHandler);
            // _growth.addEventListener(ExchangeEvent.EXCHANGE_SUCCESS, exchangeSuccessHandler);

            visible = false;

            initilizeToolTipOwners();
            updateHelp(_EDIT_HELP);
            page = _START_PAGE;
        }

        // 後処理
        public override function final():void
        {
            hide();
            initPage();
            InventorySet.final();
            removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            _ctrl.removeEventListener(CharaCardEvent.COPY_CHARA_CARD, reloadHandler);
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_CHARA, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_CHARA, binderToDeckHandler);
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_WEAPON, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_WEAPON, binderToDeckHandler);
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_EVENT, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_EVENT, binderToDeckHandler);
            _deckEditor.removeEventListener(EditDeckEvent.DELETE_DECK_SUCCESS, deleteDeckHandler);
            _deckEditor.removeEventListener(EditDeckEvent.CREATE_DECK_SUCCESS, createDeckHandler);
            _deckEditor.removeEventListener(EditDeckEvent.BINDER_SORT, binderSortHandler);
            // _growth.removeEventListener(ExchangeEvent.EXCHANGE_SUCCESS, exchangeSuccessHandler);
            for (var key:Object in _cccDic)
            {
                _cccDic[key].getHideThread().start();
                delete _cccDic[key];
            }
            _cccDic = null;
        }

        // バインダーを初期化
        public function initBinder():void
        {
            _binderBase.x = _BINDER_X;
            _binderBase.y = _BINDER_Y;
            _binderBase.width = _BINDER_WIDTH;
            _binderBase.height = _BINDER_HEIGHT;
            addChild(_binderBase);
        }

        // バインダーの内容を更新
        public function loadPage():void
        {
            // ロード時をShowスレッドが待てるようにloadThreadを作る
            _currentPageInvSet = InventorySet.getPageSet(_PAGE_SIZE, page, _type);
            _currentPageInvSet.forEach(function(invSet:InventorySet, index:int, array:Array):void
                                       {
                                           loadInventory(invSet, index);
                                       }
                );

            // // キャッシュ用に一ページ先を先読み(やめた。おそい)
            // var nextInvCCSet:Array;
            // nextInvCCSet = InventorySet.getPageSet(_PAGE_SIZE, pageCount(page+1), _type);
            // nextInvCCSet.forEach(function(invSet:InventorySet, index:int, array:Array):void
            //                            {
            //                                var cc:ICard = invSet.card;
            //                                setCCC(cc,index,false);
            //                            }
            //     );

        }

        // インベントリを内容を更新
        public function loadInventory(invSet:InventorySet, index:int):void
        {
            // ICard
            var cc:ICard = invSet.card;
//            log.writeLog(log.LV_FATAL, this, "load inventory" );

            if(_cardContainers.length <= index)
            {
                log.writeLog(log.LV_FATAL, this, "load inventory new card", index);
                _cardContainers.push(new UIComponent());
                setCCC(cc,index);
                _paramSet.push(new Label());
                _numBGSet.push(new CardStock());
            }

            _cccDic[cc].scaleX = _CARD_SCALE;
            _cccDic[cc].scaleY = _CARD_SCALE;
            // _cardContainers[index].scaleX = _CARD_SCALE
            // _cardContainers[index].scaleY = _CARD_SCALE

            // ICardClipに変更
            _cccDic[cc].cardInventory = invSet.cardInventory;

            _paramSet[index].x = _CARD_NUM_X;
            _paramSet[index].y = _CARD_NUM_Y;
            _paramSet[index].width = _CARD_NUM_WIDTH;
            _paramSet[index].height = _CARD_NUM_HEIGHT;
            _paramSet[index].styleName = "CharaCardValueNum";
            _paramSet[index].htmlText = invSet.fileLength + "/" + invSet.length;
            _paramSet[index].filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1),];
            _paramSet[index].mouseEnabled = false;
            _paramSet[index].mouseChildren = false;

            _cardContainers[index].x = _INV_X + _OFFSET_X * (index % _ROW);
            _cardContainers[index].y = _INV_Y + _OFFSET_Y * int(index / _COLUMN) - int(_PAGE_SIZE / 2 - 1 < index) * _OFFSET_Y * _COLUMN;

            if(invSet.fileLength)
            {
                _cardContainers[index].addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
                _cardContainers[index].addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                _cardContainers[index].alpha = 1.0;
            }
            else
            {
                _cardContainers[index].removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
                _cardContainers[index].removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                _cardContainers[index].alpha = 0.3;
            }
            //_cccDic[cc].setCaution(bc,ch);
        }

        // DicにCharaCardClipを格納
        // ICardに変更
        private function setCCC(cc:ICard,index:int):void
        {
//            log.writeLog(log.LV_INFO, this, "set ccc type", _type);

//            log.writeLog(log.LV_FATAL, this, "set ccc",_cccDic[cc], cc.id);
            if (_cccDicCacheUpdate.length > _CCC_CACHE_MAX)
            {
                var dcc:ICard;
                dcc = _cccDicCacheUpdate.shift();
                _cccDic[dcc].getHideThread().start();
                delete _cccDic[dcc];
            }

            if (_cccDic[cc] ==null)
            {
//                Unlight.GCWOn();

                // ここはタイプで分ける
                switch (_type)
                {
                case InventorySet.TYPE_CHARA:
                case InventorySet.TYPE_MONSTER:
                case InventorySet.TYPE_OTHER:
                    _cccDic[cc] = new CharaCardClip(CharaCard(cc));
//                Unlight.GCW.watch(_cccDic[cc] );
                    break;
                case InventorySet.TYPE_WEAPON:
                     _cccDic[cc] = new WeaponCardClip(WeaponCard(cc));
                     log.writeLog(log.LV_INFO, this, "set weapon card");
//                Unlight.GCW.watch(_cccDic[cc] );
                    break;
                case InventorySet.TYPE_EQUIP:
                    _cccDic[cc] = new EquipCardClip(EquipCard(cc));
                    log.writeLog(log.LV_INFO, this, "set equip card");
                    break;
                case InventorySet.TYPE_EVENT:
                     _cccDic[cc] = new EventCardClip(EventCard(cc));
                     log.writeLog(log.LV_INFO, this, "set event card");
//                     Unlight.GCW.watch(_cccDic[cc] );
                    break;
                }
                _cccDicCacheUpdate.push(cc);
                _cccDic[cc].getEditShowThread(_cardContainers[index],0).start();
                // Unlight.GCWatch(_cccDic[cc] );
            }else{
                var i:int = _cccDicCacheUpdate.indexOf(cc);
                var ci:ICard = _cccDicCacheUpdate[i];
                _cccDicCacheUpdate.splice(i,1);
                _cccDicCacheUpdate.push(ci);
            }


        }

        // バインダーの内容を初期化
        public function initPage():void
        {
//            log.writeLog(log.LV_FATAL, this, "initPage" );
            initInventory();
        }

        // インベントリを内容を初期化
        public function initInventory():void
        {
            _cardContainers.forEach(function(item:*, index:int, array:Array):void{
                    item.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
                    item.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                })

            _paramSet = [];
            _cardContainers = [];
        }


        // バインダーの内容を表示(更新用)
        public function show():void
        {
            _currentPageInvSet.forEach(showInventory);
        }

        // カードセットを表示する
        public function showInventory(invSet:InventorySet, index:int, array:Array):void
        {
            log.writeLog(log.LV_FATAL, this, "show", index);
            if(_cccDic[invSet.card] == null){loadInventory(invSet,index)}
            _cardContainers[index].addChildAt(_cccDic[invSet.card],0);
            _cardContainers[index].addChild(_numBGSet[index]);
            _cardContainers[index].addChild(_paramSet[index]);
            _cccDic[invSet.card].addDeckUpdatedEventHandler();

            if(index < _PAGE_SIZE / 2)
            {
                _rightContainer.addChild(_cardContainers[index]);
            }
            else
            {
                _leftContainer.addChild(_cardContainers[index]);
            }
            var selectIndex:int = DeckEditor.instance.selectIndex;
            _cccDic[invSet.card].setCaution(CharaCardDeck.decks[selectIndex].baseCost,
                                            CharaCardDeck.decks[selectIndex].charactors,
                                            CharaCardDeck.decks[selectIndex].parents);
        }

        // バインダーの内容を隠す
        public function hide():void
        {
            _currentPageInvSet.forEach(hideInventory);
        }

        // カードセットを隠す
        public function hideInventory(invSet:InventorySet, index:int, array:Array):void
        {
            // ここICardInventory
            _cccDic[invSet.card].cardInventory = null;
            _cccDic[invSet.card].removeDeckUpdatedEventHandler();

             _cardContainers[index].removeChild(_paramSet[index]);

            if(index < _PAGE_SIZE / 2)
            {
                _rightContainer.removeChild(_cardContainers[index]);
            }
            else
            {
                _leftContainer.removeChild(_cardContainers[index]);
            }
        }

        // リロードに使う関数のセット
        public function reload():void
        {
           log.writeLog(log.LV_FATAL, this, "reload");
            hide();
            initPage();
            loadPage();
            show();
        }

        // リロードハンドラ
        public function reloadHandler(e:Event):void
        {
            InventorySet.init(_type);
            _invSet = InventorySet.inventories;
            _deckEditor.binderSort();
        }

        // ホイールハンドラ
        private function mouseWheelHandler(e:MouseEvent):void
        {
            if(e.delta >= 3)
            {
                page = page-1;
            }
            else if(e.delta <= -3)
            {
                page = page+1;
            }
        }

        // マウスダウン処理
        private function mouseDownHandler(e:MouseEvent):void
        {
//            log.writeLog(log.LV_FATAL, this, "mouse down ");
            SE.playDeckCardClick();
            e.currentTarget.startDrag();
            e.currentTarget.parent.setChildIndex(e.currentTarget, e.currentTarget.parent.numChildren-1);
            e.currentTarget.parent.parent.setChildIndex(e.currentTarget.parent, e.currentTarget.parent.parent.numChildren-1);
            e.currentTarget.parent.parent.parent.setChildIndex(e.currentTarget.parent.parent, e.currentTarget.parent.parent.parent.numChildren-1);
            e.currentTarget.alpha = 0.5;
        }

        // マウスアップ処理
        private function mouseUpHandler(e:MouseEvent):void
        {
            var index:int = _cardContainers.indexOf(e.currentTarget);
            e.currentTarget.stopDrag();
            e.currentTarget.alpha = 1.0;

            if(collision(e))
            {
                log.writeLog(log.LV_DEBUG, this, "removeCard!!",index,e.currentTarget);
                removeCard(UIComponent(e.currentTarget), index);
            }
            else
            {
                new BeTweenAS3Thread(e.currentTarget,{x:_INV_X+_OFFSET_X*(index%_ROW) ,y:_INV_Y+_OFFSET_Y*int(index/_COLUMN)-int(_PAGE_SIZE/2-1<index)*_OFFSET_Y*_COLUMN}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE).start();
            }
        }

        // バインダーとの当たり判定を返す関数
        private function collision(e:MouseEvent):Boolean
        {
            log.writeLog(log.LV_DEBUG, this, "e.x is", e.stageX, "e.y is", e.stageY);
            log.writeLog(log.LV_DEBUG, this, "CharaCardDeck.decks.length <= 1", (CharaCardDeck.decks.length <= 1));
            log.writeLog(log.LV_DEBUG, this, "_DECK_X",_DECK_X,"_DECK_X2",_DECK_X2,"_DECK_Y",_DECK_Y,"_DECK_Y2",_DECK_Y2);
            if(CharaCardDeck.decks.length <= 1)
            {
                return false;
            }
            else if(e.stageX > _DECK_X && e.stageX < _DECK_X2 && e.stageY > _DECK_Y && e.stageY < _DECK_Y2)
            {
                log.writeLog(log.LV_DEBUG, this, "collision!!!!!");
                if(e.stageX < _DECK_CHARA_LINE1)
                {
                    _currentCharaCardPos = 0;
                }else if(e.stageX < _DECK_CHARA_LINE2)
                {
                    _currentCharaCardPos = 1;
                }else{
                    _currentCharaCardPos = 2;
                }
                return true;
            }
            else
            {
                return false;
            }
        }

        // カードを追加する(ICardInventoyに変更)
        private function addCard(cci:ICardInventory):void
        {
            _currentPageInvSet.forEach(function(item:*, index:int, array:Array):void{if(item.id == cci.card.id){loadInventory(item, index)}});
        }

        // カードを消去する
        private function removeCard(uic:UIComponent, index:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "type",_type,InventorySet.TYPE_WEAPON);
            // ここはTYPEを分ける
                // ここはタイプで分ける
                switch (_type)
                {
                case InventorySet.TYPE_CHARA:
                case InventorySet.TYPE_MONSTER:
                case InventorySet.TYPE_OTHER:
                    // カードからインベントリ情報を引き出して渡す
                    _deckEditor.binderToDeckCharaCard(CharaCardInventory(CharaCardClip(uic.getChildAt(0)).cardInventory), _deckEditor.selectIndex);
                    break;
                 case InventorySet.TYPE_WEAPON:
                     _deckEditor.binderToCombineListWeaponCard(WeaponCardClip(uic.getChildAt(0)).cardInventory, _deckEditor.selectIndex, _currentCharaCardPos);
                     log.writeLog(log.LV_INFO, this, "set weapon card");
                      break;
//                 case InventorySet.TYPE_EQUIP:
//                     _cccDic[cc] = new EquipCardClip(EquipCard(cc));
//                     log.writeLog(log.LV_INFO, this, "set equip card");
//                     break;
                case InventorySet.TYPE_EVENT:
                     _deckEditor.binderToDeckEventCard(EventCardClip(uic.getChildAt(0)).cardInventory, _deckEditor.selectIndex, _currentCharaCardPos);
                     log.writeLog(log.LV_INFO, this, "set event card");
                    break;

                }

            loadInventory(_currentPageInvSet[index], index);
        }

        // バインダーを更新
        public function update():void
        {
            InventorySet.init(_type);
            _invSet = InventorySet.inventories;
            _deckEditor.binderSort();
        }

        // カードが追加される
        public function deckToBinderHandler(e:EditCardEvent):void
        {
            addCard(e.cci);
        }

        // カードが除外される
        public function binderToDeckHandler(e:EditCardEvent):void
        {
            // 必要なところだけリロードする
            switch (e.type)
            {
            case EditCardEvent.BINDER_TO_DECK_CHARA:
                if (e.cci.card.kind == Const.CC_KIND_CHARA)
                {
                    if (_type != BINDER_TYPE_CHARA) return;
                }
                else if (e.cci.card.kind == Const.CC_KIND_MONSTAR)
                {
                    if (_type != BINDER_TYPE_MONSTAR) return;
                }
                break;
            case EditCardEvent.BINDER_TO_DECK_WEAPON:
                if (_type != BINDER_TYPE_WEAPON) return;
                break;
            case EditCardEvent.BINDER_TO_DECK_EQUIP:
                if (_type != BINDER_TYPE_EQUIP) return;
                break;
            case EditCardEvent.BINDER_TO_DECK_EVENT:
                if (_type != BINDER_TYPE_EVENT) return;
                break;
            }
            forceReload = true;
        }

        // デッキが消去される
        private function deleteDeckHandler(e:EditDeckEvent):void
        {
//            reload();
        }

        private function createDeckHandler(e:EditDeckEvent):void
        {
            InventorySet.init(_type);
            forceReload = true;
        }

        // カードがソートされる
        public function binderSortHandler(e:EditDeckEvent):void
        {
            // log.writeLog(log.LV_INFO, "sort");
            // if (page == _START_PAGE)
            // {
                forceReload = true;
            // }else{
            //     page = _START_PAGE;
            // }
        }

        // カードが合成される
        public function exchangeSuccessHandler(e:ExchangeEvent):void
        {
            update();
            forceReload = true;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            if (_pageReloadingThread != null)
            {
                _pageReloadingThread.interrupt();
            }
            return new HideThread(this);
        }

        // ページのゲッター
        public function get page():int
        {
            return _page;
        }
        // ページのゲッター
        public function get forceReload():Boolean
        {
            return _forceReload;
        }
        public function set forceReload(s:Boolean):void
        {
            _forceReload = s;
        }

        // ページのセッター
        public function set page(p:int):void
        {
            _page = pageCount(p);
            var pageNum:int = Math.ceil(_invSet.length / _PAGE_SIZE);
            var pageNumStr:String = pageNum>0 ? pageNum.toString():"1";
            _pageNo.text = (_page+1).toString()+"/"+pageNumStr;
        }

        private function pageCount(p:int):int
        {
            var ret:int;
            if(p < _START_PAGE)
            {
                ret = int((_invSet.length-1) / _PAGE_SIZE);
            }
            else if(p > (_invSet.length-1) / _PAGE_SIZE)
            {
                ret = _START_PAGE;
            }
            else
            {
                ret = p;
            }
            return ret;

        }

    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.DeckEditor;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.edit.CombineListArea;

class ShowThread extends BaseShowThread
{
    public function ShowThread(ba:CombineListArea, stage:DisplayObjectContainer, at:int)
    {
        super(ba, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(ba:CombineListArea)
    {
        super(ba);
    }

}

class PageReloadThread extends Thread
{
    private var _ba:CombineListArea;
    private var _oldPage:int = 0;

    public function PageReloadThread(ba:CombineListArea)
    {
        _ba = ba;
        super;
    }
    override protected function run():void
    {
        // 割り込まれていた場合終了
        interrupted(loadInterrupted);
        if (_oldPage != _ba.page || _ba.forceReload)
        {
            _ba.reload();
            if (_ba.forceReload )
            {
                _ba.forceReload = false;
               sleep(1 * 1000);
            }else{
               sleep(1 * 1000);
            }
            _oldPage = _ba.page;
        }
        next(reload);
    }

    private function reload():void
    {
        // CountThread に対して割り込みを掛ける
        // 繰り返す
        // 割り込まれていた場合終了
        interrupted(loadInterrupted);
        sleep(1 * 100);
        next(run);
    }

    private function loadInterrupted():void
    {
        // Interrupted!! を表示して終了
        // trace('Interrupted!!');
        return;
    }

}

