package view.scene.edit
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.geom.*;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    import flash.filters.GlowFilter;
    import flash.text.*;

    import mx.core.UIComponent;
    import mx.controls.*;
    import mx.managers.*;
    import mx.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import view.scene.edit.BaseDeckClip;
    import view.scene.common.CharaCardClip;
    import view.utils.*;

    import model.*;
    import model.events.*;
    import controller.LobbyCtrl;

    /**
     * エディット画面のデッキ部分のクラス
     *
     */
    public class DeckArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_DECK_MSG	:String = "所持しているデッキが表示されます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_DECK_NAME	:String = "デッキの名前です。";
        CONFIG::LOCALE_JP
        private static const _TRANS_DECK_NUM	:String = "デッキの番号です。";

        CONFIG::LOCALE_EN
        private static const _TRANS_DECK_MSG	:String = "Decks you own will be displayed.";
        CONFIG::LOCALE_EN
        private static const _TRANS_DECK_NAME	:String = "The name of the deck.";
        CONFIG::LOCALE_EN
        private static const _TRANS_DECK_NUM	:String = "The number of the deck.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_DECK_MSG	:String = "顯示所擁有的牌組。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DECK_NAME	:String = "牌組的名稱。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_DECK_NUM	:String = "牌組的編號。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_DECK_MSG	:String = "显示所拥有的卡组。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DECK_NAME	:String = "卡组的名称。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_DECK_NUM	:String = "卡组的编号。";

        CONFIG::LOCALE_KR
        private static const _TRANS_DECK_MSG	:String = "소지하고 있는 덱이 표시됩니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_DECK_NAME	:String = "덱의 이름입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_DECK_NUM	:String = "덱의 번호입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_DECK_MSG	:String = "Voir les pioches.";
        CONFIG::LOCALE_FR
        private static const _TRANS_DECK_NAME	:String = "Nom de la pioche.";
        CONFIG::LOCALE_FR
        private static const _TRANS_DECK_NUM	:String = "Numéro de la pioche.";

        CONFIG::LOCALE_ID
        private static const _TRANS_DECK_MSG	:String = "所持しているデッキが表示されます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_DECK_NAME	:String = "デッキの名前です。";
        CONFIG::LOCALE_ID
        private static const _TRANS_DECK_NUM	:String = "デッキの番号です。";

        CONFIG::LOCALE_TH
        private static const _TRANS_DECK_MSG    :String = "แสดงสำรับที่มีในครอบครอง";
        CONFIG::LOCALE_TH
        private static const _TRANS_DECK_NAME   :String = "ชื่อสำรับ";
        CONFIG::LOCALE_TH
        private static const _TRANS_DECK_NUM    :String = "หมายเลขสำรับ";


        // エディットインスタンス
        private var _deckEditor:DeckEditor = DeckEditor.instance;

        // オブジェクト
//        private var _deck:CharaCardDeck;                              // デッキのポインタ
        private var _no:Label = new Label();                                // デッキナンバー表示ラベル
        private var _name:ValidTextInput = new ValidTextInput(true, ValidTextInput.DECK_NAME);                      // デッキ名表示ラベル
        private var _level:Label = new Label();                                // コスト表示ラベル
        private var _exp:Label = new Label();                                    // コスト表示ラベル
        private var _cost:Label = new Label();                                   // コスト表示ラベル
        private var _costCorrection:Array = [new TextField(),new TextField(),new TextField()];    // コスト倍率表示ラベル
        private var _middleCost:Array = [new TextField(),new TextField(),new TextField()];    // 中間コスト表示ラベル
        private var _deckClips:Array = [];                             // Array of CharaCardDeckClip
        private var _costSet:Object;                                      // コスト関連の連想配列

        private var _ccdDic:Dictionary = new Dictionary();             // Dictionary of CCD Key:CharaCardDeck

        private var _container:UIComponent = new UIComponent();       // コンテナ

        private var _timer:Timer = new Timer(200,1);                   // アニメーションタイマー


        private var _type:int;                                        // デッキエリアのタイプ
        private var _movinFlag:Boolean = true;                                   // デッキ移動中かどうか

        // 定数
        private static const _DECK_X:int = 215;                      // デッキコンテナX位置
        private static const _DECK_Y:int = 443;                      // デッキコンテナY位置
        private static const _DECK_OFFSET_X:int = 225;                   // デッキXずれ
        private static const _DECK_OFFSET_X2:int = 52;                // デッキXずれ
        private static const _DECK_OFFSET_Y:int = 15;                   // デッキYずれ
        private static const _DECK_SCALE_MAX:Number = 1.0;          // デッキコンテナ最大サイズ
        private static const _DECK_SCALE_OFFSET:Number = 0.3;          // デッキコンテナ最小サイズ
        private static const _DECK_ROTATE:Array = [-80,0,70];             // デッキ回転角

        private static const _NO_X:int = 60;                         // デッキ番号X
        private static const _NO_Y:int = 636;                        // デッキ番号Y
        private static const _NO_WIDTH:int = 100;                   // デッキ番号の幅
        private static const _NO_HEIGHT:int = 18;                   // デッキ番号の高さ

        private static const _NAME_X:int = 80;                         // デッキ名X
        private static const _NAME_Y:int = 636;                        // デッキ名Y
        private static const _NAME_WIDTH:int = 110;                   // デッキ名の幅
        private static const _NAME_HEIGHT:int = 17;                   // デッキ名の高さ

        private static const _LEVEL_X:int = 338;                         // デッキレベルX
        private static const _LEVEL_Y:int = 635;                        // デッキレベルY
        private static const _LEVEL_WIDTH:int = 80;                   // デッキレベルの幅
        private static const _LEVEL_HEIGHT:int = 18;                   // デッキレベルの高さ

        private static const _EXP_X:int = 425;                         // デッキ経験値X
        private static const _EXP_Y:int = 635;                        // デッキ経験値Y
        private static const _EXP_WIDTH:int = 180;                   // デッキ経験値の幅
        private static const _EXP_HEIGHT:int = 24;                   // デッキ経験値の高さ

        private static const _COST_X:int = 412;                         // デッキコストX
        private static const _COST_Y:int = 600;                        // デッキコストY
        private static const _COST_WIDTH:int = 150;                   // デッキコストの幅
        private static const _COST_HEIGHT:int = 32;                   // デッキコストの高さ

        private static const _MIDDLE_COST_X:int = 110;                     // 中間コスト 基点 X
        private static const _MIDDLE_COST_MARGIN_X:int = 89;               // 中間コスト 間隔 X
        private static const _MIDDLE_COST_Y:int = 605;                     // 中間コスト 基点 Y
        private static const _MIDDLE_COST_WIDTH:int = 150;                 // コストの幅
        private static const _MIDDLE_COST_HEIGHT:int = 24;                 // コストの高さ

        private static const _COST_CORRECTION_X:int = 110;                 // コスト倍率 基点 X
        private static const _COST_CORRECTION_MARGIN_X:int = 89;           // コスト倍率 間隔 X
        private static const _COST_CORRECTION_Y:int = 613;                 // コスト倍率 基点 Y
        private static const _COST_CORRECTION_WIDTH:int = 150;             // デッキコストの幅
        private static const _COST_CORRECTION_HEIGHT:int = 24;             // デッキコストの高さ

        private static const _CONTENT_FONT_SIZE_CORRECTION:int = 16;       // 本文のフォントサイズ
        private static const _CONTENT_FONT_SIZE_MIDDLE:int = 26;           // 本文のフォントサイズ
        private static const _CONTENT_FONT_FACE:String = "bradley";        // フォント種
        private static const _CONTENT_FONT_COLOR_NORMAL:uint = 0xFFFFFF;    // フォント色 通常
        private static const _CONTENT_FONT_COLOR_YELLOW:uint = 0xDFBC27;    // フォント色 黄
        private static const _CONTENT_FONT_COLOR_RED:uint = 0xBA0000;       // フォント色 赤
        private static const _MAX_CHARS:int = 23;                      // 入力可能な文字数

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["所持しているデッキが表示されます。",
//                 "デッキの名前です。",
//                 "デッキの番号です。",],
                [_TRANS_DECK_MSG,
                 _TRANS_DECK_NAME,
                 _TRANS_DECK_NUM,],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _EDIT_HELP:int = 0;

        public static function getCharaCardDeck():DeckArea
        {
            log.writeLog(log.LV_INFO, "chara card deck");
            return new DeckArea(InventorySet.TYPE_CHARA);
        }
        public static function getWeaponCardDeck():DeckArea
        {
            log.writeLog(log.LV_INFO, "weapon card deck");
            return new DeckArea(InventorySet.TYPE_WEAPON);
        }
        public static function getEquipCardDeck():DeckArea
        {
            log.writeLog(log.LV_INFO,  "equip card deck");
            return new DeckArea(InventorySet.TYPE_EQUIP);
        }
        public static function getEventCardDeck():DeckArea
        {
            log.writeLog(log.LV_INFO,  "equip card deck");
            return new DeckArea(InventorySet.TYPE_EVENT);
        }
        public static function getMonsterCardDeck():DeckArea
        {
            log.writeLog(log.LV_INFO, "monster card deck");
            return new DeckArea(InventorySet.TYPE_MONSTER);
        }
        public static function getOtherCardDeck():DeckArea
        {
            log.writeLog(log.LV_INFO, "other card deck");
            return new DeckArea(InventorySet.TYPE_OTHER);
        }






        /**
         * コンストラクタ
         *
         */
        public function DeckArea(type:int)
        {
            _type = type;

            currentIndex = _deckEditor.currentIndex;

            initDeck();
            initProperty();
            loadDeck();
            show();

            addChild(_container);
//            Unlight.GCW.watch(_no);
//            Unlight.GCW.watch(_name);
//            Unlight.GCW.watch(_deckClips);
//            Unlight.GCW.watch(_ccdDic);
//            Unlight.GCW.watch(_container);
//            Unlight.GCW.watch(_timer);


        }

        // 初期化するパーツの各種プロパティを初期化する
        private function initProperty():void
        {
            // レベル関連
            _level.x = _LEVEL_X;
            _level.y = _LEVEL_Y;
            _level.width = _LEVEL_WIDTH;
            _level.height = _LEVEL_HEIGHT;
            _level.styleName = "DeckDataLabelSmall";

            // EXP関連
            _exp.x = _EXP_X;
            _exp.y = _EXP_Y;
            _exp.width = _EXP_WIDTH;
            _exp.height = _EXP_HEIGHT;
            _exp.styleName = "DeckDataLabelSmall";

            // コスト関連
            _cost.x = _COST_X;
            _cost.y = _COST_Y;
            _cost.width = _COST_WIDTH;
            _cost.height = _COST_HEIGHT;
            _cost.styleName = "DeckCostLabelForDeckArea";
            _cost.filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),];

            // コスト補正関連
            var tfm:TextFormat = new TextFormat();
            tfm.font = _CONTENT_FONT_FACE;
            tfm.align = "center";

            for (var i:int=0; i < 3; i++) {
                tfm.size = _CONTENT_FONT_SIZE_CORRECTION;
                _costCorrection[i].embedFonts = true;
                _costCorrection[i].defaultTextFormat = tfm;
                _costCorrection[i].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),];
                if (Option.instance.CVVolume < 50)
                {
                    _costCorrection[i].text = " (0)";
                }
                else
                {
                    _costCorrection[i].text = " 0";
                }
                _costCorrection[i].textColor = _CONTENT_FONT_COLOR_NORMAL;
                _costCorrection[i].y = _COST_CORRECTION_Y;
                _costCorrection[i].width = _COST_CORRECTION_WIDTH;
                _costCorrection[i].height = _COST_CORRECTION_HEIGHT;
                _costCorrection[i].alpha = 0;
                _costCorrection[i].mouseEnabled = false;

                // 中間コスト関連
                tfm.size = _CONTENT_FONT_SIZE_MIDDLE;
                _middleCost[i].embedFonts = true;
                _middleCost[i].defaultTextFormat = tfm;
                _middleCost[i].filters = [new GlowFilter(0x000000, 1, 2, 2, 16, 1),];
                _middleCost[i].text = "0";
                _middleCost[i].textColor = _CONTENT_FONT_COLOR_NORMAL;
                _middleCost[i].y = _MIDDLE_COST_Y;
                _middleCost[i].width = _MIDDLE_COST_WIDTH;
                _middleCost[i].height = _MIDDLE_COST_HEIGHT;
                _middleCost[i].visible = false;
                _middleCost[i].mouseEnabled = false;
            }
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  //
            _toolTipOwnerArray.push([1,_name]);  //
            _toolTipOwnerArray.push([2,_no]);  //
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

        // 初期化
        public override function init():void
        {
            visible = false;
            _deckEditor.addEventListener(EditDeckEvent.CHANGE_CURRENT_DECK, changeCurrentDeckHandler);
            _deckEditor.addEventListener(EditDeckEvent.RENAME_DECK, renameDeckHandler);
            _deckEditor.addEventListener(EditDeckEvent.CREATE_DECK_SUCCESS, createDeckHandler);
            _deckEditor.addEventListener(EditDeckEvent.DELETE_DECK_SUCCESS, deleteDeckHandler);
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_CHARA, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_CHARA, binderToDeckHandler);
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_EVENT, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_EVENT, binderToDeckHandler);
            _deckEditor.addEventListener(EditCardEvent.DECK_TO_BINDER_WEAPON, deckToBinderHandler);
            _deckEditor.addEventListener(EditCardEvent.BINDER_TO_DECK_WEAPON, binderToDeckHandler);
            _deckEditor.addEventListener(DeckEditor.CHANGE_TYPE, changeTypeHandler);

            _deckEditor.addEventListener(DeckEditor.DECK_COST_UPDATE, deckCostUpdateHandler);

            initilizeToolTipOwners();
            updateHelp(_EDIT_HELP);
        }

        // 後処理
        public override function final():void
        {
            finalDeck();
            _deckEditor.removeEventListener(EditDeckEvent.CHANGE_CURRENT_DECK, changeCurrentDeckHandler);
            _deckEditor.removeEventListener(EditDeckEvent.RENAME_DECK, renameDeckHandler);
            _deckEditor.removeEventListener(EditDeckEvent.CREATE_DECK_SUCCESS, createDeckHandler);
            _deckEditor.removeEventListener(EditDeckEvent.DELETE_DECK_SUCCESS, deleteDeckHandler);
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_CHARA, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_CHARA, binderToDeckHandler);
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_EVENT, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_EVENT, binderToDeckHandler);
            _deckEditor.removeEventListener(EditCardEvent.DECK_TO_BINDER_WEAPON, deckToBinderHandler);
            _deckEditor.removeEventListener(EditCardEvent.BINDER_TO_DECK_WEAPON, binderToDeckHandler);
            _deckEditor.removeEventListener(DeckEditor.CHANGE_TYPE, changeTypeHandler);

            _deckEditor.removeEventListener(DeckEditor.DECK_COST_UPDATE, deckCostUpdateHandler);

            _name.removeEventListener(ValidTextInput.VALID_OK, enterKeyDownHandler);

            for (var key:Object in _ccdDic)
            {
                _ccdDic[key].getHideThread().start();
                delete _ccdDic[key];
            }
            _ccdDic = null;
        }

        // デッキを初期化
        private function initDeck():void
        {
            addDeckContainer(true, prevIndex);
            addDeckContainer(true, currentIndex, "edit");
            addDeckContainer(true, nextIndex);
            updateEventHandler();
        }

        // デッキを全て消す
        private function finalDeck():void
        {
            removeEventHandler();
            removeDeckContainer(true);
            removeDeckContainer(true);
            removeDeckContainer(true);
        }


        // DicにCharaCardDeckClipを格納
        // IDeckに変更予定
        private function setCCD(ccd:IDeck, type:String):void
        {
//            log.writeLog(log.LV_INFO, this, "set ccc type", _type);
//            log.writeLog(log.LV_FATAL, this, "set ccc",_cccDic[cc], cc.id);
            if (_ccdDic[ccd] ==null)
            {
                // ここはタイプで分ける
                switch (_type)
                {
                case InventorySet.TYPE_CHARA:
                case InventorySet.TYPE_MONSTER:
                case InventorySet.TYPE_OTHER:
                    _ccdDic[ccd] = new CharaCardDeckClip(ccd);
                    break;
                case InventorySet.TYPE_WEAPON:
//                    _ccdDic[ccd] = new CharaCardDeckClip(ccd);
                    _ccdDic[ccd] = new WeaponCardDeckClip(ccd);
                    break;
                case InventorySet.TYPE_EQUIP:
                    _ccdDic[ccd] = new EquipCardDeckClip(ccd);
                    break;
                case InventorySet.TYPE_EVENT:
                    _ccdDic[ccd] = new EventCardDeckClip(ccd);
                    break;
                }
                _ccdDic[ccd].getShowThread(_container,0,type).start();
            }
        }


        // デッキコンテナを作成
        private function addDeckContainer(dir:Boolean, index:int, type:String = ""):void
        {
            // カレントデッキ
            var deck:IDeck;
            // ここはタイプで分ける
            switch (_type)
                {
                case InventorySet.TYPE_CHARA:
                case InventorySet.TYPE_MONSTER:
                case InventorySet.TYPE_OTHER:
                    deck = CharaCardDeck.decks[index];
                    break;
                case InventorySet.TYPE_WEAPON:
                    deck = WeaponCardDeck.decks[index];
                    break;
                case InventorySet.TYPE_EQUIP:
                    deck = EquipCardDeck.decks[index];
                    break;
                case InventorySet.TYPE_EVENT:
                    deck = EventCardDeck.decks[index];
                    break;
                };

            // デッキを作成
//            log.writeLog(log.LV_FATAL, this, "deck",deck);
            setCCD(deck, type);

            _ccdDic[deck].scaleX = 0.3;
            _ccdDic[deck].scaleY = 0.3;
            _ccdDic[deck].alpha = 0.0;
            if(dir)
            {
                _ccdDic[deck].x = _DECK_X - _DECK_OFFSET_X;
                _ccdDic[deck].y = _DECK_Y + _DECK_OFFSET_Y;
                _deckClips.push(_ccdDic[deck]);
            }
            else
            {
                _ccdDic[deck].x = _DECK_X + _DECK_OFFSET_X;
                _ccdDic[deck].y = _DECK_Y + _DECK_OFFSET_Y;
                _deckClips.unshift(_ccdDic[deck]);
            }

        }

        // デッキコンテナを消去
        private function removeDeckContainer(dir:Boolean = true):void
        {
            var deckClip:BaseDeckClip;
            if(dir)
            {
                deckClip = _deckClips.pop();
                deckClip.removeMouseEventHandler();
                deckClip.visible = false;
//                 deckClip.getHideThread().start();
            }
            else
            {
                deckClip = _deckClips.shift();
                deckClip.removeMouseEventHandler();
                deckClip.visible = false;
//                 deckClip = _deckClips.shift();
//                 deckClip.getHideThread().start();
            }
//            reload();
        }

        // デッキの内容を更新
        private function loadDeck():void
        {
            loadDeckName();
            loadDeckData();
        }

        // デッキ名を更新
        private function loadDeckName():void
        {
            _no.x = _NO_X;
            _no.y = _NO_Y;
            _no.width = _NO_WIDTH;
            _no.height = _NO_HEIGHT;

            _name.x = _NAME_X;
            _name.y = _NAME_Y;
            _name.width = _NAME_WIDTH;
            _name.height = _NAME_HEIGHT;
            _name.maxChars = _MAX_CHARS;
            _name.restrict = "^\",";

            if(CharaCardDeck.decks[currentIndex])
            {
                _no.text = currentIndex + ". ";
                _name.text = CharaCardDeck.decks[currentIndex].name;
            }
            else
            {
                _no.text = "X. ";
                _name.text = "Create Deck";
            }

            if(currentIndex == _deckEditor.currentIndex)
            {
                _no.styleName = "CurrentDeckNameLabelForDeckArea";
                _name.styleName = "CurrentDeckNameLabelForDeckArea";
            }
            else
            {
                _no.styleName = "DeckNameLabelForDeckArea";
                _name.styleName = "DeckNameLabelForDeckArea";
            }
            // _no.filters = [new GlowFilter(0xffffff, 1, 2, 2, 16, 1),]
            // _name.filters = [new GlowFilter(0xffffff, 1, 2, 2, 16, 1),]

        }

        // デッキデータを更新
        private function loadDeckData(kind:int=0):void
        {
            _costSet = CharaCardDeck.decks[currentIndex].cost;
            var deckLevel:int = CharaCardDeck.decks[currentIndex].level;
            var costCalc:int = _costSet["total"] + EventCardDeck.decks[currentIndex].cost + WeaponCardDeck.decks[currentIndex].cost;
            var costMax:int = CharaCardDeck.decks[currentIndex].maxCost;

            // Lvを更新
            _level.htmlText = String(deckLevel);

            // EXP更新
            _exp.htmlText = CharaCardDeck.decks[currentIndex].exp + "/" + Const.DECK_LEVEL_EXP_TABLE[deckLevel];

            // コスト更新
            // _cost.styleName = costCalc > costMax ? "DeckCostLabelRedForDeckArea" : "DeckCostLabelForDeckArea";
            _cost.styleName = "DeckCostLabelForDeckArea";
            // _cost.htmlText = costCalc + "/" + CharaCardDeck.decks[currentIndex].maxCost;
            _cost.htmlText = costCalc.toString();

            // ここから先はキャラカードのみ
            if (kind < 0)
            {
                return;
            }

            // コスト補正の更新
            var corrected:Boolean = false;
            var correction_width:Array = [];
            var middle_cost_width:int = 0;
            var pExec:ParallelExecutor = new ParallelExecutor();

            for (var i:uint = 0; i < _costCorrection.length; i++) {
                if (_costSet["correction"].length-1 < i) {
                    _costCorrection[i].alpha = 0.0;
                    _costCorrection[i].text = " 0";
                }
                else {
                    corrected = _costSet["correction"][i] != 0;
                    if (!corrected) {
                        _costCorrection[i].alpha = 0.0;
                        _costCorrection[i].text = " 0";
                        correction_width.push(0);
                    }
                    else
                    {
                        var correctionStr:String = String(_costSet["correction"][i]);

                        _costCorrection[i].htmlText = " +" + correctionStr;
                        correction_width.push(_costCorrection[i].textWidth);

                        var tmp_text:String = _middleCost[i].text;
                        _middleCost[i].text = _costSet["middle"][i];
                        middle_cost_width = _middleCost[i].textWidth;
                        _middleCost[i].text = tmp_text;

                        var a:uint = Math.round(middle_cost_width/2);
                        _costCorrection[i].x = _COST_CORRECTION_X + _COST_CORRECTION_MARGIN_X * i + a;

                        if (_costCorrection[i].alpha == 0.0)
                        {
                            pExec.addThread(new BeTweenAS3Thread(_costCorrection[i],
                                                                 {alpha:1.0},
                                                                 {alpha:0.0},
                                                                 0.5,
                                                                 BeTweenAS3Thread.EASE_OUT_EXPO,
                                                                 0.0,
                                                                 true));
                        }
                    }
                }
            }

            // 中間コストの更新
            for (i = 0; i < 3; i++) {
                if (_costSet["base"].length-1 < i) {
                    _middleCost[i].visible = false;
                    _middleCost[i].text = "0";
                    _middleCost[i].x =  _MIDDLE_COST_X + _MIDDLE_COST_MARGIN_X * i;
                }
                else {
                    if (_deckEditor.editType == InventorySet.TYPE_CHARA || _deckEditor.editType == InventorySet.TYPE_MONSTER)
                    {
                        _middleCost[i].visible = true;
                    }
                    var b:uint = Math.round(correction_width[i]/2);
                    var beforeCost:uint = 0;
                    if (_middleCost[i].text != null) {
                        beforeCost = parseInt(_middleCost[i].text);
                    }
                    if (_middleCost[i].text != "")
                    {
                        _middleCost[i].x = _MIDDLE_COST_X + _MIDDLE_COST_MARGIN_X * i - b;

                        if (beforeCost != _costSet["base"][i])
                        {
                            _middleCost[i].text = _costSet["base"][i]
                            if (_ccdDic[CharaCardDeck.decks[currentIndex]]) {
                                var costFrameThread:Thread =_ccdDic[CharaCardDeck.decks[currentIndex]].getShowCostFrame();
                                if (costFrameThread) {
                                    pExec.addThread(costFrameThread);
                                }
                            }
                        }

                        var color:uint = 0;
                        var g:Array = [];
                        switch (_costSet["correction"][i])
                        {
                        case 5:
                            color = _CONTENT_FONT_COLOR_YELLOW;
                            break;

                        case 10:
                            color = _CONTENT_FONT_COLOR_RED;
                            break;

                        default:
                            color = _CONTENT_FONT_COLOR_NORMAL;
                        }
                        _middleCost[i].textColor = color;
                    }
                    else
                    {
                        _middleCost[i].htmlText = _costSet["base"][i];
                        _middleCost[i].x =  _MIDDLE_COST_X + _MIDDLE_COST_MARGIN_X * i - b;
                    }
                }
            }

            dispatchEvent(new DeckUpdatedEvent(DeckUpdatedEvent.UPDATED_CHARA_CARD, _costSet["charactors"], _costSet["parents"], _costSet["base"]));
            pExec.start();

        }

        public function costSet():Object
        {
            return _costSet;
        }

        // デッキの内容を表示
        public function show():void
        {
            showName();
            showData();
            _deckClips.forEach(function(dc:BaseDeckClip, index:int, array:Array):void{showInventory(dc, index)});
        }

        // 名前を表示
        public function showName():void
        {
            _name.addEventListener(ValidTextInput.VALID_OK, enterKeyDownHandler);
            _container.addChild(_no);
            _container.addChild(_name);
        }

        // デッキ情報を表示
        public function showData():void
        {
            // _container.addChild(_level);
            // _container.addChild(_exp);
            _container.addChild(_cost);
            for (var i:int = 0; i < _costCorrection.length; i++) {
                _container.addChild(_costCorrection[i]);
            }
            for (i = 0; i < _middleCost.length; i++) {
                _container.addChild(_middleCost[i]);
            }
        }

        // インベントリを表示
        public function showInventory(dc:BaseDeckClip, index:int):void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var sExec:SerialExecutor = new SerialExecutor();

            sExec.addThread(new SetFlagThread(this, false));
            pExec.addThread(new BeTweenAS3Thread(dc, {x:_DECK_X+_DECK_OFFSET_X*(index-1)+_DECK_OFFSET_X2*((index+1)%2) ,y:_DECK_Y+_DECK_OFFSET_Y*((index+1)%2) ,rotationY:_DECK_ROTATE[index], scaleX:_DECK_SCALE_MAX-_DECK_SCALE_OFFSET*((index+1)%2) ,scaleY:_DECK_SCALE_MAX-_DECK_SCALE_OFFSET*((index+1)%2) ,alpha:1.0}, null, 0.15, BeTweenAS3Thread.EASE_IN_SINE));
            sExec.addThread(pExec);
            if(index == 1)
            {
                sExec.addThread(new InitMatrixThread(dc, _DECK_X+_DECK_OFFSET_X*(index-1)+_DECK_OFFSET_X2*((index+1)%2), _DECK_Y+_DECK_OFFSET_Y*((index+1)%2)));
            }
            sExec.addThread(new SetFlagThread(this, true));
            sExec.start();
        }

        // デッキの内容を隠す
        public function hide():void
        {
            hideName();
            hideData();
        }

        // 名前を隠す
        public function hideName():void
        {
            // 全く関係のないところにフォーカスをセット
            _no.setFocus();
            _name.removeEventListener(ValidTextInput.VALID_OK, enterKeyDownHandler);
            _container.removeChild(_no);
            _container.removeChild(_name);
        }

        // デッキ情報を隠す
        public function hideData():void
        {
            RemoveChild.apply(_level);
            RemoveChild.apply(_exp);
            RemoveChild.apply(_cost);
            // _container.removeChild(_level);
            // _container.removeChild(_exp);
            // _container.removeChild(_cost);
        }

        // 再読み込みのセット
        private function reload():void
        {
            hide();
            loadDeck();
            show();
        }


        // カードが追加される
        public function binderToDeckHandler(e:EditCardEvent):void
        {
            if (e.cci.card.cost > 0)
            {
                loadDeckData(e.cci.card.kind);
            }
            SE.playDeckSet()
        }

        // カードが除外される
        public function deckToBinderHandler(e:EditCardEvent):void
        {
            if (e.cci.card.cost > 0)
            {
                loadDeckData(e.cci.card.kind);
            }
            SE.playDeckSet()
        }

        // カレントデッキが変更される
        public function changeCurrentDeckHandler(e:EditDeckEvent):void
        {
            reload();
        }

        // カレントデッキが変更される
        public function renameDeckHandler(e:EditDeckEvent):void
        {
            reload();
        }

        private function changeTypeHandler(e:Event):void
        {
            if (_type != InventorySet.TYPE_CHARA) return;

            switch (_deckEditor.editType) {
            case InventorySet.TYPE_CHARA:
            case InventorySet.TYPE_MONSTER:
            case InventorySet.TYPE_OTHER:
                setMiddleCostLabelVisibility(true);
                break;
            default:
                setMiddleCostLabelVisibility(false);
            }
        }

        private function deckCostUpdateHandler(e:Event):void
        {
            loadDeckData(1);
        }

        private function setMiddleCostLabelVisibility(val:Boolean):void
        {
            for (var i:int=0; i < _middleCost.length; i++) {
                _middleCost[i].visible = val && (_middleCost[i].text != "0");
                _costCorrection[i].visible = val;
            }
        }

        // イベント

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        // イベントハンドラをアップデートする
        private function updateEventHandler():void
        {
            _deckClips[0].removeMouseEventHandler();
            _deckClips[1].addMouseEventHandler();
            _deckClips[2].removeMouseEventHandler();
        }

        // イベントハンドラを外す
        private function removeEventHandler():void
        {
            _deckClips[0].removeMouseEventHandler();
            _deckClips[1].removeMouseEventHandler();
            _deckClips[2].removeMouseEventHandler();
        }

        // デッキを切り替える
        public function changeDeck(flag:Boolean):void
        {
            if(flag)
            {
//                currentIndex -= 1;
                removeDeckContainer(true);
                addDeckContainer(false, prevIndex);
            }
            else
            {

//                currentIndex += 1;
                removeDeckContainer(false);
                addDeckContainer(true, nextIndex);
            }

            removeEventHandler();
//            updateEventHandler();

            _timer.addEventListener(TimerEvent.TIMER, timerHandler);
            _timer.start();

            reload();
        }

        // キーボードイベント
        private function enterKeyDownHandler(e:Event):void
        {
            _deckEditor.renameDeck(_deckEditor.selectIndex, _name.text);
        }

        // デッキ作成イベント
        private function createDeckHandler(e:EditDeckEvent):void
        {
            // finalDeck();
            // initDeck();
            reload();
        }

        // デッキ削除イベント
        private function deleteDeckHandler(e:EditDeckEvent):void
        {
            finalDeck();
            initDeck();
            reload();
        }

        // ホイールハンドラをセットする
        private function timerHandler(t:TimerEvent):void
        {
            updateEventHandler();
            _timer.removeEventListener(TimerEvent.TIMER, timerHandler);
        }

        // デッキ番号をセットする
        public function set currentIndex(i:int):void
        {
            _deckEditor.selectIndex = i;
        }

        // デッキ番号を取得する
        public function get currentIndex():int
        {
            return _deckEditor.selectIndex;
        }

        // 次のデッキ番号を取得する
        private function get nextIndex():int
        {
            return _deckEditor.nextIndex;
        }

        // 前のデッキ番号を取得する
        private function get prevIndex():int
        {
            return _deckEditor.prevIndex;
        }

        // デッキ移動フラグ
        public function set flag(f:Boolean):void
        {
            _movinFlag = f;
        }
        // デッキ移動フラグ
        public function get flag():Boolean
        {
            return _movinFlag;
        }
    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;

import model.DeckEditor;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.edit.DeckArea;
import view.scene.edit.BaseDeckClip;


class ShowThread extends BaseShowThread
{
    public function ShowThread(da:DeckArea, stage:DisplayObjectContainer, at:int)
    {
        super(da, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(da:DeckArea)
    {
        super(da);
     }

}

// Matirixを初期化するスレッド
class InitMatrixThread extends Thread
{
    private var _ccdc:BaseDeckClip;
    private var _x:int;
    private var _y:int;

    public function InitMatrixThread(ccdc:BaseDeckClip, x:int = 0, y:int = 0)
    {
        _ccdc = ccdc;
        _x = x;
        _y = y;
    }

    protected override function run():void
    {
        _ccdc.transform.matrix3D = null;
        _ccdc.x = _x;
        _ccdc.y = _y;
    }
}

// フラグを設定するスレッド
class SetFlagThread extends Thread
{
    private var _da:DeckArea;
    private var _flag:Boolean;

    public function SetFlagThread(da:DeckArea, flag:Boolean)
    {
        _da = da;
        _flag = flag;
    }

    protected override function run():void
    {
        _da.flag = _flag;
//        log.writeLog(log.LV_INFO, this, "set flag!!", _da.flag);
    }
}
