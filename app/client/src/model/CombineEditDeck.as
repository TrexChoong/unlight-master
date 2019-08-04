package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    import model.*;
    import net.*;

    /**
     * デッキクラス
     *
     *
     */
    public class CombineEditDeck implements IDeck
    {
        public static const SET_SUCCESS:int           = 0;  // 成功
        public static const SET_ERR_LIST_OVER:int     = 1;  // リストがいっぱいです
        public static const SET_ERR_SAME_CARD:int     = 2;  // 既にリストにセットしてます
        public static const SET_ERR_CANT_USE:int      = 3;  // このカードは合成に使用できません
        public static const SET_ERR_NOT_BASE:int      = 4;  // ベースカードとしては使えません
        public static const SET_ERR_CANT_SET:int      = 5;  // ベースカードと合いません
        public static const SET_ERR_NOT_MAT:int       = 6;  // このカードは素材に使用できません
        public static const SET_ERR_CANT_CHANGE:int   = 7;  // この組み合わせは効果がありません
        public static const SET_ERR_BASE_IS_ONE:int   = 8;  // ベースカードは複数指定できません
        public static const SET_ERR_CANT_MORE:int     = 9;  // このカードをこれ以上追加できません
        public static const SET_ERR_USE_YET:int       = 10; // まだ使用できません
        public static const SET_ERR_CANT_MORE_PSV:int = 11; // パッシブスキルはこれ以上追加できません
        public static const SET_ERR_SAME_CHARA:int    = 12; // すでに__CNAME__専用武器になっています

        CONFIG::LOCALE_JP
        private static const _TRANS_ERR_TITLE:String   = "エラー";
        CONFIG::LOCALE_JP
        private static const _TRANS_ALERT_TITLE:String = "警告";
        CONFIG::LOCALE_EN
        private static const _TRANS_ERR_TITLE:String   = "Error";
        CONFIG::LOCALE_EN
        private static const _TRANS_ALERT_TITLE:String = "Warning";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ERR_TITLE:String   = "錯誤";
        CONFIG::LOCALE_TCN
        private static const _TRANS_ALERT_TITLE:String = "警告";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ERR_TITLE:String   = "错误";
        CONFIG::LOCALE_SCN
        private static const _TRANS_ALERT_TITLE:String = "警告";
        CONFIG::LOCALE_KR
        private static const _TRANS_ERR_TITLE:String   = "에러";
        CONFIG::LOCALE_KR
        private static const _TRANS_ALERT_TITLE:String = "경고";
        CONFIG::LOCALE_FR
        private static const _TRANS_ERR_TITLE:String   = "Erreur";
        CONFIG::LOCALE_FR
        private static const _TRANS_ALERT_TITLE:String = "Attention";
        CONFIG::LOCALE_ID
        private static const _TRANS_ERR_TITLE:String   = "エラー";
        CONFIG::LOCALE_ID
        private static const _TRANS_ALERT_TITLE:String = "警告";
        CONFIG::LOCALE_TH
        private static const _TRANS_ERR_TITLE:String   = "พบข้อผิดพลาด";
        CONFIG::LOCALE_TH
        private static const _TRANS_ALERT_TITLE:String = "คำเตือน";

        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_LIST_OVER:String     = "リストがいっぱいです";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_SAME_CARD:String     = "既にリストにセットしてます";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_CANT_USE:String      = "このカードは合成に使用できません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_NOT_BASE:String      = "ベースカードとしては使えません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_CANT_SET:String      = "ベースカードと合いません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_NOT_MAT:String       = "このカードは素材に使用できません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_CANT_CHANGE:String   = "この組み合わせは効果がありません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_BASE_IS_ONE:String   = "ベースカードは複数指定できません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_CANT_MORE:String     = "このカードをこれ以上追加できません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_USE_YET:String       = "このカードはまだ使用できません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_CANT_MORE_PSV:String = "パッシブスキルはこれ以上追加できません";
        CONFIG::LOCALE_JP
        private static const _TRANS_SET_ERR_SAME_CHARA:String    = "すでに__CNAME__専用武器になっています";

        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_LIST_OVER:String     = "List full";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_SAME_CARD:String     = "Already in list";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_CANT_USE:String      = "This card cannot be used for crafting";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_NOT_BASE:String      = "This card cannot be used as the base card";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_CANT_SET:String      = "This card is not compatible with the base card";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_NOT_MAT:String       = "This card cannot be used as a material";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_CANT_CHANGE:String   = "This combination has null effect";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_BASE_IS_ONE:String   = "Only 1 base card can be selected";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_CANT_MORE:String     = "This card can no longer be added";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_USE_YET:String       = "This card cannot be used yet";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_CANT_MORE_PSV:String = "パッシブスキルはこれ以上追加できません";
        CONFIG::LOCALE_EN
        private static const _TRANS_SET_ERR_SAME_CHARA:String    = "すでに__CNAME__専用武器になっています";

        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_LIST_OVER:String     = "清單已滿";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_SAME_CARD:String     = "已在清單中";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_CANT_USE:String      = "此卡片無法用來合成";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_NOT_BASE:String      = "此卡片無法當作基底卡";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_CANT_SET:String      = "此卡片與基底卡不合";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_NOT_MAT:String       = "此卡片無法當作素材使用";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_CANT_CHANGE:String   = "此組合並不會產生效果";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_BASE_IS_ONE:String   = "基底卡只能選擇一張";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_CANT_MORE:String     = "此卡片無法再追加";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_USE_YET:String       = "此卡片還無法使用";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_CANT_MORE_PSV:String = "被動技能無法再增加";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SET_ERR_SAME_CHARA:String    = "已經變成__CNAME__的専用武器了";

        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_LIST_OVER:String     = "清单已满";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_SAME_CARD:String     = "已在清单中";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_CANT_USE:String      = "此卡片无法用来合成";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_NOT_BASE:String      = "此卡片无法当作基底卡";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_CANT_SET:String      = "此卡片与基底卡不合";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_NOT_MAT:String       = "此卡片无法当作素材使用";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_CANT_CHANGE:String   = "此组合并不会产生效果";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_BASE_IS_ONE:String   = "基底卡只能选择一张";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_CANT_MORE:String     = "此卡片无法再追加";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_USE_YET:String       = "此卡片还无法使用";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_CANT_MORE_PSV:String = "被动技能无法再增加";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SET_ERR_SAME_CHARA:String    = "已經變成__CNAME__的専用武器了";

        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_LIST_OVER:String     = "リストがいっぱいです";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_SAME_CARD:String     = "既にリストにセットしてます";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_CANT_USE:String      = "このカードは合成に使用できません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_NOT_BASE:String      = "ベースカードとしては使えません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_CANT_SET:String      = "ベースカードと合いません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_NOT_MAT:String       = "このカードは素材に使用できません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_CANT_CHANGE:String   = "この組み合わせは効果がありません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_BASE_IS_ONE:String   = "ベースカードは複数指定できません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_CANT_MORE:String     = "このカードをこれ以上追加できません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_USE_YET:String       = "このカードはまだ使用できません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_CANT_MORE_PSV:String = "パッシブスキルはこれ以上追加できません";
        CONFIG::LOCALE_KR
        private static const _TRANS_SET_ERR_SAME_CHARA:String    = "すでに__CNAME__専用武器になっています";

        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_LIST_OVER:String     = "La liste est pleine.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_SAME_CARD:String     = "Déjà présent dans la liste.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_CANT_USE:String      = "Cette carte ne peut être combinée.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_NOT_BASE:String      = "Cette carte ne peut être utilisée comme une carte de base.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_CANT_SET:String      = "Cette carte ne peut être combinée avec la carte de base.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_NOT_MAT:String       = "Cette carte ne peut être utilisée seule.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_CANT_CHANGE:String   = "Cette combinaison n'est pas fructueuse.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_BASE_IS_ONE:String   = "Vous ne pouvez choisir plusieurs cartes de base.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_CANT_MORE:String     = "Vous ne pouvez ajouter plus de cartes.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_USE_YET:String       = "Vous ne pouvez pas encore utiliser cette carte.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_CANT_MORE_PSV:String = "パッシブスキルはこれ以上追加できません";
        CONFIG::LOCALE_FR
        private static const _TRANS_SET_ERR_SAME_CHARA:String    = "すでに__CNAME__専用武器になっています";

        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_LIST_OVER:String     = "リストがいっぱいです";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_SAME_CARD:String     = "既にリストにセットしてます";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_CANT_USE:String      = "このカードは合成に使用できません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_NOT_BASE:String      = "ベースカードとしては使えません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_CANT_SET:String      = "ベースカードと合いません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_NOT_MAT:String       = "このカードは素材に使用できません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_CANT_CHANGE:String   = "この組み合わせは効果がありません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_BASE_IS_ONE:String   = "ベースカードは複数指定できません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_CANT_MORE:String     = "このカードをこれ以上追加できません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_USE_YET:String       = "このカードはまだ使用できません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_CANT_MORE_PSV:String = "パッシブスキルはこれ以上追加できません";
        CONFIG::LOCALE_ID
        private static const _TRANS_SET_ERR_SAME_CHARA:String    = "すでに__CNAME__専用武器になっています";

        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_LIST_OVER:String     = "リストがいっぱいです";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_SAME_CARD:String     = "既にリストにセットしてます";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_CANT_USE:String      = "このカードは合成に使用できません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_NOT_BASE:String      = "ベースカードとしては使えません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_CANT_SET:String      = "ベースカードと合いません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_NOT_MAT:String       = "このカードは素材に使用できません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_CANT_CHANGE:String   = "この組み合わせは効果がありません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_BASE_IS_ONE:String   = "ベースカードは複数指定できません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_CANT_MORE:String     = "このカードをこれ以上追加できません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_USE_YET:String       = "このカードはまだ使用できません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_CANT_MORE_PSV:String = "パッシブスキルはこれ以上追加できません";
        CONFIG::LOCALE_TH
        private static const _TRANS_SET_ERR_SAME_CHARA:String    = "すでに__CNAME__専用武器になっています";

        public static const ERR_MASSAGES:Array = [
            {"msg":"","title":""}, // SET_SUCCESS
            {"msg":_TRANS_SET_ERR_LIST_OVER,     "title":_TRANS_ALERT_TITLE}, // SET_ERR_LIST_OVER
            {"msg":_TRANS_SET_ERR_SAME_CARD,     "title":_TRANS_ERR_TITLE},   // SET_ERR_SAME_CARD
            {"msg":_TRANS_SET_ERR_CANT_USE,      "title":_TRANS_ERR_TITLE},   // SET_ERR_CANT_USE
            {"msg":_TRANS_SET_ERR_NOT_BASE,      "title":_TRANS_ERR_TITLE},   // SET_ERR_NOT_BASE
            {"msg":_TRANS_SET_ERR_CANT_SET,      "title":_TRANS_ALERT_TITLE}, // SET_ERR_CANT_SET
            {"msg":_TRANS_SET_ERR_NOT_MAT,       "title":_TRANS_ERR_TITLE},   // SET_ERR_NOT_MAT
            {"msg":_TRANS_SET_ERR_CANT_CHANGE,   "title":_TRANS_ALERT_TITLE}, // SET_ERR_CANT_CHANGE
            {"msg":_TRANS_SET_ERR_BASE_IS_ONE,   "title":_TRANS_ERR_TITLE},   // SET_ERR_BASE_IS_ONE
            {"msg":_TRANS_SET_ERR_CANT_MORE,     "title":_TRANS_ALERT_TITLE}, // SET_ERR_CANT_MORE
            {"msg":_TRANS_SET_ERR_USE_YET,       "title":_TRANS_ALERT_TITLE}, // SET_ERR_USE_YET
            {"msg":_TRANS_SET_ERR_CANT_MORE_PSV, "title":_TRANS_ALERT_TITLE}, // SET_ERR_USE_YET
            {"msg":_TRANS_SET_ERR_SAME_CHARA,    "title":_TRANS_ERR_TITLE},   // SET_ERR_SAME_CHARA
            ];

        public static const LIST_MAX:int = 5;
        public static const USE_MAX_NUM:int = 10;

        // エディットインスタンス
        private var _deckEdit:DeckEditor = DeckEditor.instance;

        public static const UPDATE:String = 'update';  // 情報がアップデート
        private var _name:String;                      // デッキ名
        private var _cardInventories:Array = [];       // インベントリ付きカード
        private var _useNumList:Array = [];       // カード使用枚数

        private static var __errCharaId:int = 0;

        private static var __deck:CombineEditDeck;            //  CombineEditDeck

        public static function get deck():CombineEditDeck
        {
            return __deck;
        }
        public static function set deck(d:CombineEditDeck):void
        {
            __deck = d;
        }

        // エラー文章取得
        public static function getErrMsg(errId:int=SET_SUCCESS):String
        {
            var ret:String = "";
            log.writeLog(log.LV_FATAL, "CombineEditDeck", "getErrMsg",errId,__errCharaId);
            if (errId != SET_SUCCESS) {
                if (errId == SET_ERR_SAME_CHARA) {
                    if (__errCharaId != 0) {
                        var chara:Charactor = Charactor.ID(__errCharaId);
                        ret = ERR_MASSAGES[errId]["msg"].replace("__CNAME__",chara.name);
                    } else {
                        ret = ERR_MASSAGES[SET_ERR_CANT_CHANGE]["msg"];
                    }
                } else {
                    ret = ERR_MASSAGES[errId]["msg"];
                }
            }
            return ret;
        }

        // デッキのカードインベントリを初期化
        public static function initCombineEditInventory(cci:WeaponCardInventory):void
        {
            deck.cardInventories.push(cci);
        }

        // バインダーからデッキにカードインベントリを移す
        public static function binderToDeck(cci:WeaponCardInventory, index:int, charPos:int):void
        {
            log.writeLog(log.LV_DEBUG, "CombineEditDeck", "binderToDeck",cci,index,charPos);
            binder.removeWeaponCardInventory(cci);
            deck.addCombineEditInventory(cci,charPos);
        }

        // デッキからバインダーにカードインベントリを移す
        public static function deckToBinder(cci:WeaponCardInventory):void
        {
            log.writeLog(log.LV_DEBUG, "CombineEditDeck", "deckToBinder",cci);
            deck.removeCombineEditInventory(cci);
            binder.addWeaponCardInventory(cci);
        }

        // デッキを削除する
        public static function deleteDeck():void
        {
            log.writeLog(log.LV_DEBUG, "CombineEditDeck", "deleteDeck");
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = deck.cardInventories.length;
            log.writeLog(log.LV_DEBUG, "CombineEditDeck", "deleteDeck",deckLength);
            while (deck.cardInventories[0]) {
                DeckEditor.instance.deckToBinderWeaponCard(deck.cardInventories[0]);
            }
            // デッキを削除
            //decks.splice(index, 1);
            // 後ろにあるデッキのカードインベントリを修正する
            // for(i = index; i < decks.length; i++)
            // {
            //     deck.cardInventories.forEach(function(cci:WeaponCardInventory, index:int, array:Array):void{cci.index = i});
            // }
        }

        // デッキを削除する
        public static function allCardDeckToBinder(index:int):void
        {
            // デッキ内の全てのカードをバインダーに移す
            var deckLength:int = deck.cardInventories.length;
            for(var i:int = 0; i < deckLength; i++)
            {
                DeckEditor.instance.deckToBinderWeaponCard(deck.cardInventories[0]);
            }
        }

        // カードインベントリ一覧のゲッター
        public static function get binder():WeaponCardDeck
        {
            return WeaponCardDeck.binder;
        }

        // コンストラクタ
        public function CombineEditDeck(name:String="")
        {
            _name = name;
            deck = this;
        }

        // デッキにカードインベントリを追加
        public function addCombineEditInventory(cci:WeaponCardInventory,charPos:int=0):void
        {
            _cardInventories.push(cci);
            _useNumList.push(1);
        }

        // Listの内容が問題ないかチェック
        private function checkSetList():void
        {
            checkBaseCard();
            checkMaterialList();
        }

        // 先頭がベースカードとして問題ないかチェック
        private function checkBaseCard():void
        {
            CONFIG::WC_COMBINE_LIST_UNCHECK
            {
                return;
            }

            if (_cardInventories.length > 0) {
                // 先頭が素材なら抜く
                if (WeaponCard(_cardInventories[0].card).weaponType == Const.WEAPON_TYPE_MATERIAL) {
                    _deckEdit.deckToBinderWeaponCard(_cardInventories[0]);
                }
            }
        }
        private function checkMaterialList():void
        {
            CONFIG::WC_COMBINE_LIST_UNCHECK
            {
                return;
            }

            var moveInv:Array;
            moveInv = checkMaterialListTop();
            for (var i:int = 0; i < moveInv.length; i++) {
                _deckEdit.deckToBinderWeaponCard(moveInv[i]);
            }
        }
        // 先頭が問題ないかチェック 末尾までいったらTrueを返す
        private function checkMaterialListTop():Array
        {
            var retInv:Array = [];
            if (baseCardInv) {
                var baseWc:WeaponCard = WeaponCard(baseCardInv.card);
                var arrIdx:int;
                if (materialCardInvs.length > 0) {
                    for (var i:int = 0; i < materialCardInvs.length; i++) {
                        if (baseWc.weaponType == Const.WEAPON_TYPE_NORMAL) {
                            // ベースが合成武器でない場合、合成化素材か判定
                            if (materialCardInvs[i].cardId != Const.CMB_BASE_WC_CHANGE_ID) {
                                retInv.push(materialCardInvs[i]);
                            }
                        } else {
                            // ベースパラの上限を上げる素材の場合、ベース武器の最大値がすでに上がっているか判定
                            if (Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(materialCardInvs[i].cardId)!=-1) {
                                arrIdx = Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(materialCardInvs[i].cardId);
                                var setMax:int = Const.CMB_BASE_PARAM_MAX_UP_NUM[arrIdx];
                                if (canBaseTotalMax < setMax) {
                                    retInv.push(materialCardInvs[i]);
                                }
                            }
                            // 専用化素材の場合、ベースが合成武器でないなら弾く
                            else if (Const.CMB_CREST_MATERIAL_IDS.indexOf(materialCardInvs[i].cardId)!=-1) {
                                // ベースが設定レベル以下なら弾く
                                if (baseWc.level < Const.CMB_CREST_CAN_USE_LV) {
                                    retInv.push(materialCardInvs[i]);
                                }
                            }
                            // 通常上昇素材の場合
                            else if (Const.CMB_BASE_PARAM_UP_IDS.indexOf(materialCardInvs[i].cardId)!=-1) {
                                arrIdx = Const.CMB_BASE_PARAM_UP_IDS.indexOf(materialCardInvs[i].cardId);
                                var baseTotal:int = baseWc.baseTotal;
                                var idxBasePrm:int = baseWc.getBaseParamIdx(arrIdx);
                                var setNum:int = materialCardInvUseNums[i];
                                if ((baseTotal+setNum) > canBaseTotalMax) {
                                    retInv.push(materialCardInvs[i]);
                                } else if ((idxBasePrm+setNum) > Const.CMB_BASE_PARAM_UPPER_LIMIT) {
                                    retInv.push(materialCardInvs[i]);
                                }
                            }
                        }
                    }
                }
            }
            return retInv;
        }
        // 現在可能な範囲のBaseTotalMaxを取得
        private function get canBaseTotalMax():int
        {
            var baseWc:WeaponCard = WeaponCard(baseCardInv.card);
            var max:int = baseWc.baseMax;
            for (var i:int=0;i<materialCardInvs.length;i++) {
                // MAX
                if (Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(materialCardInvs[i].cardId)!=-1) {
                    var cstMaxArrIdx:int = Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(materialCardInvs[i].cardId);
                    // 順番に確認して、低い順に最大値UPアイテムが入ってるなら問題なし
                    if (max == Const.CMB_BASE_PARAM_MAX_UP_NUM[cstMaxArrIdx]-1) {
                        max = Const.CMB_BASE_PARAM_MAX_UP_NUM[cstMaxArrIdx];
                    }
                }
            }
            return max;
        }


        // バインダーのカードインベントリを削除
        public function removeCombineEditInventoryId(invId:int):void
        {
            var pos:int = -1;
            for(var i:int = 0; i < _cardInventories.length; i++)
            {
               if(_cardInventories[i].inventoryID == invId)
               {
                   _cardInventories.splice(i, 1);
                   _useNumList.splice(i, 1);
                   pos = i;
                   i--;
               }
            }
            // 抜いたのが先頭でまだリストがあるなら再度同じ動作をする
            if (pos == 0) {
                if (_cardInventories.length > 0) {
                    _deckEdit.deckToBinderWeaponCard(_cardInventories[0]);
                }
            } else {
                checkSetList();
            }
        }

        // デッキからカードを消去
        public function removeCombineEditInventory(cci:WeaponCardInventory):void
        {
            var position:int = _cardInventories.indexOf(cci);
            if(position != -1)
            {
                _cardInventories.splice(position, 1);
                _useNumList.splice(position, 1);
            }
            else
            {
                log.writeLog(log.LV_FATAL, this, "undefined position card");
            }
            // 抜いたのが先頭でまだリストがあるなら再度同じ動作をする
            if (position == 0) {
                if (_cardInventories.length > 0) {
                    _deckEdit.deckToBinderWeaponCard(_cardInventories[0]);
                }
            } else {
                checkSetList();
            }
         }

        // デッキからカードを消去
        public function removePositionInventory(position:int):void
        {
            if(position < _cardInventories.length)
            {
                // Binderのデッキ番号(0)を代入
                _cardInventories[position].index = 0;

                // デッキからインベントリを消去
                _cardInventories.splice(position, 1);
                _useNumList.splice(position, 1);

                // カードが抜けたポイントからのポジションを修正
                for(var i:int = position; i < _cardInventories.length; i++)
                {
                    _cardInventories[i].position = i;
                }
            }
            // 抜いたのが先頭でまだリストがあるなら再度同じ動作をする
            if (position == 0) {
                if (_cardInventories.length > 0) {
                    _deckEdit.deckToBinderWeaponCard(_cardInventories[0]);
                }
            } else {
                checkSetList();
            }
        }

        // デッキ名のゲッター
        public function get name():String
        {
            return _name;
        }

        // デッキ名のセッター
        public function set name(n:String):void
        {
            _name = n;
        }

        // カードインベントリ一覧のゲッター
        public function get cardInventories():Array
        {
            return _cardInventories;
        }

        // ポジションのカードを配列で返す
        public function getPositionCard(pos:int):Array
        {
            var ret:Array = [];
            var len:int = _cardInventories.length;
            for(var i:int = 0; i < len; i++){
                if (_cardInventories[i].position == pos)
                {ret.push(_cardInventories[i])}
            }
            return ret;
        }


        // カードインベントリにあるカードの枚数
        public function sortCombineEditId(id:int):int
        {
            var count:int = 0;
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{if(item.WeaponCard.id == id){count++}});
            return count;
        }
        public function getCardIdList():Array
        {
            var ret:Array = [];
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{if(ret.indexOf(item.card.id)==-1){ret.push(item.card.id)}});
            return ret;
        }
        public function getUseNum(idx:int):int
        {
            return _useNumList[idx];
        }
        public function addUseNum(idx:int,num:int):int
        {
            if (idx < _useNumList.length) {
                _useNumList[idx] += num;

                if (_useNumList[idx] > _cardInventories[idx].card.num) {
                    _useNumList[idx] = _cardInventories[idx].card.num;
                }
                if (_useNumList[idx] > USE_MAX_NUM) {
                    _useNumList[idx] = USE_MAX_NUM;
                }
                if (_useNumList[idx] <= 0) {
                    _useNumList[idx] = 1;
                }
            }
            return _useNumList[idx];
        }
        public function setUseNum(idx:int,num:int):int
        {
            if (idx < _useNumList.length) {
                _useNumList[idx] = num;

                if (_useNumList[idx] > _cardInventories[idx].card.num) {
                    _useNumList[idx] = _cardInventories[idx].card.num;
                }
                if (_useNumList[idx] > USE_MAX_NUM) {
                    _useNumList[idx] = USE_MAX_NUM;
                }
                if (_useNumList[idx] <= 0) {
                    _useNumList[idx] = 1;
                }
            }
            return _useNumList[idx];
        }
        public function get baseCardInv():WeaponCardInventory
        {
            return _cardInventories[0];
        }
        public function get materialCardInvs():Array
        {
            return _cardInventories.slice(1);
        }
        public function get materialCardInvUseNums():Array
        {
            return _useNumList.slice(1);
        }

        // キャラカードが取り除かれたとき後ろのインベントリをずらす
        public static function removeCharaCard(index:int, pos:int):void
        {
            // デッキから無くなったキャラカード位置のインベントリを取り出す
            var a:Array = deck.getPositionCard(pos);
            // 当該ポジションのカードを取り除く
             for(var i:int = 0; i < a.length; i++){
                 DeckEditor.instance.deckToBinderWeaponCard(a[i]);
             }
             // 当該ポジション以降のカードを一つつめる
             for(var j:int = pos+1; j < 3; j++){
                 a = deck.getPositionCard(j);
                 a.forEach(function(item:WeaponCardInventory, index:int, array:Array):void{
                         item.position = item.position-1;
                         log.writeLog(log.LV_FATAL,  "remove card pos",item.cardPosition,item.position);
                         DeckEditor.instance.deckToDeckWeaponCard(item,index,false); // セーブしないで変更（後で順番にセーブされることを期待している）
                             });
             }


        }

        // 総コストのゲッター
        public function get cost():int
        {
            var calc:int = 0
            _cardInventories.forEach(function(item:*, index:int, array:Array):void{calc += item.card.cost});
            return calc;
        }

        // 合成処理用に引き渡す文字列取得
        public function getCombineArray():Array
        {
            var ret:Array = [];
            for (var i:int = 0;i < LIST_MAX; i++) {
                if (_cardInventories[i]) {
                    // 1枚目はそのままインベントリのIDを保持
                    ret.push(_cardInventories[i].inventoryID);
                    if (_useNumList[i] > 1) {
                        // 1枚以上指定してる場合はバインダーからIDを取得
                        var cardInvList:Array = binder.getCardList(_cardInventories[i].cardId);
                        var addCnt:int = 1; // そのまま入れた1枚分込みで加算
                        for (var j:int = 0; j < cardInvList.length; j++) {
                            if (ret.indexOf(cardInvList[j].inventoryID)==-1) {
                                ret.push(cardInvList[j].inventoryID);
                                addCnt++;
                            }
                            // 必要個数取得したら抜ける
                            if (_useNumList[i] <= addCnt) {
                                break;
                            }
                        }
                    }
                }
            }
            return ret;
        }

        // リストに同様のカードがあるかチェック
        public function checkSameCardIn(ci:WeaponCardInventory):Boolean
        {
            log.writeLog(log.LV_DEBUG, this, "checkSameCardIn");
            return (getCardIdList().indexOf(ci.cardId)!=-1);
        }

        // 合成リストに追加する際に、追加可能か判定
        public function checkCardSetList(ci:WeaponCardInventory):int
        {
            log.writeLog(log.LV_DEBUG, this, "checkCardsetList");
            var ret:int = SET_SUCCESS;
            var i:int;
            var wc:WeaponCard;
            var cardIdList:Array = getCardIdList();
            log.writeLog(log.LV_DEBUG, this, "checkCardsetList 1", cardIdList.length);
            // リストが最大でない、同種のカードがリストにない、基本専用武器でない
            if (cardIdList.length >= LIST_MAX) {
                ret = SET_ERR_LIST_OVER;
            }
            // if (cardIdList.indexOf(ci.cardId)!=-1) {
            //     ret = SET_ERR_SAME_CARD;
            // }
            if (WeaponCard(ci.card).isNormalCharaSpecial) {
                ret = SET_ERR_CANT_USE;
            }

            CONFIG::WC_COMBINE_LIST_UNCHECK
            {
                return ret;
            }

            log.writeLog(log.LV_DEBUG, this, "checkCardsetList 2", ret);
            // ここまでエラーでてないなら詳しい判定
            if (ret == SET_SUCCESS) {
                wc = WeaponCard(ci.card);
                if (cardIdList.length == 0) {
                    // ベースカードの判定
                    // 素材カードじゃないことを確認
                    if (wc.weaponType == Const.WEAPON_TYPE_MATERIAL) {
                        ret = SET_ERR_NOT_BASE;
                    }
                } else {
                    // 素材カードの判定
                    var baseWc:WeaponCard = WeaponCard(baseCardInv.card);
                    if (baseWc) {
                        // 同様のカードがリストにある
                        if (cardIdList.indexOf(ci.cardId)!=-1) {
                            if (baseWc.id == ci.cardId) {
                                // ベースの場合
                                ret = SET_ERR_BASE_IS_ONE;
                            } else {
                                // 素材の場合
                                if (!addNumCheck(ci)) {
                                    ret = SET_ERR_CANT_MORE;
                                }
                            }
                        } else {
                            // ベースが合成武器でない
                            if (baseWc.weaponType == Const.WEAPON_TYPE_NORMAL) {
                                // 使用可能素材は合成化素材のみ
                                if (ci.cardId != Const.CMB_BASE_WC_CHANGE_ID) {
                                    ret = SET_ERR_CANT_SET;
                                }
                            } else {
                                var matIdArrIdx:int;
                                // ベースパラを上昇させる素材の場合、合計制限、上限を超えるなら弾く
                                if (Const.CMB_BASE_PARAM_UP_IDS.indexOf(ci.cardId)!=-1) {
                                    if (!baseParamCheck(ci)) {
                                        ret = SET_ERR_CANT_CHANGE;
                                    }
                                }
                                // ベースパラをシフトさせる素材の場合、上限を超えるなら弾く
                                else if (Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(ci.cardId)!=-1) {
                                    if (!baseParamCheck(ci)) {
                                        ret = SET_ERR_CANT_CHANGE;
                                    }
                                }
                                // ベースパラの上限を上げる素材の場合、ベース武器の最大値がすでに上がっているか判定
                                else if (Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(ci.cardId)!=-1) {
                                    var arrIdx:int = Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(ci.cardId);
                                    var setMax:int = Const.CMB_BASE_PARAM_MAX_UP_NUM[arrIdx];
                                    if (nowBaseTotalMax != setMax-1) {
                                        ret = SET_ERR_CANT_CHANGE;
                                    }
                                }
                                // モンスパラを上昇させる素材の場合、合成武器でない、上限を超えるなら弾く
                                else if (Const.CMB_MONSTER_PARAM_UP_IDS.indexOf(ci.cardId)!=-1) {
                                    if (baseWc.weaponType == Const.WEAPON_TYPE_CMB_WEAPON) {
                                        if (!addParamCheck(ci)) {
                                            ret = SET_ERR_CANT_CHANGE;
                                        }
                                    } else {
                                        ret = SET_ERR_CANT_SET;
                                    }
                                }
                                // 既存通常武器の場合、合成武器でない、上限を超えるなら弾く
                                else if (WeaponCard(ci.card).isNormalWeapon) {
                                    if (baseWc.weaponType == Const.WEAPON_TYPE_CMB_WEAPON) {
                                        if (!addParamCheck(ci)) {
                                            ret = SET_ERR_CANT_CHANGE;
                                        }
                                    } else {
                                        ret = SET_ERR_CANT_SET;
                                    }
                                }
                                // 専用化素材の場合、ベースが合成武器でないなら弾く
                                else if (Const.CMB_CREST_MATERIAL_IDS.indexOf(ci.cardId)!=-1) {
                                    if (baseWc.weaponType == Const.WEAPON_TYPE_CMB_WEAPON) {
                                        ret = checkCrest(ci);
                                    } else {
                                        ret = SET_ERR_CANT_SET;
                                    }
                                }
                                // パッシブ付加素材の場合、ベースが合成武器でないなら弾く
                                else if (Const.CMB_PASSIVE_MATERIAL_IDS.indexOf(ci.cardId)!=-1) {
                                    if (baseWc.weaponType == Const.WEAPON_TYPE_CMB_WEAPON) {
                                        ret = checkPassive(ci);
                                    } else {
                                        ret = SET_ERR_CANT_SET;
                                    }
                                }
                                // 経験値取得素材の場合、ベースが合成武器でないなら弾く
                                else if (Const.CMB_GET_EXP_IDS.indexOf(ci.cardId)!=-1) {
                                    if (baseWc.weaponType == Const.WEAPON_TYPE_CMB_WEAPON) {
                                        if (baseWc.level >= Const.SC_LEVEL_MAX) {
                                            ret = SET_ERR_CANT_MORE;
                                        }
                                    } else {
                                        ret = SET_ERR_CANT_SET;
                                    }
                                }
                                // 合成済みカードに合成化素材は入れれない
                                else if (ci.cardId == Const.CMB_BASE_WC_CHANGE_ID) {
                                    ret = SET_ERR_CANT_SET;
                                }
                            }
                        }
                    }
                }
            }
            return ret;
        }

        // 個数チェック
        private function addNumCheck(ci:WeaponCardInventory):Boolean
        {
            var ret:Boolean = false;
            var cardIdList:Array = getCardIdList();
            var idx:int = cardIdList.indexOf(ci.cardId);
            if (idx != -1) {
                var ci:WeaponCardInventory = cardInventories[idx];
                // 最大値のチェック
                var wc:WeaponCard = WeaponCard(ci.card);
                var maxNum:int = getNowUseMaxNum(idx);
                if (maxNum > wc.materialUseMaxNum) {
                    maxNum = wc.materialUseMaxNum;
                }
                if (maxNum > wc.num) {
                    maxNum = wc.num;
                }
                var nowNum:int = CombineEditDeck.deck.getUseNum(idx);
                // 加算時に最大値を超えない場合のみ処理
                if (nowNum+1 <= maxNum) {
                    ret = true;
                }
            }
            return ret;
        }

        // ベースパラメータチェック
        private function baseParamCheck(ci:WeaponCardInventory):Boolean
        {
            var wc:WeaponCard = WeaponCard(ci.card);

            var baseWc:WeaponCard = WeaponCard(baseCardInv.card);
            var matList:Array = materialCardInvs;
            var matUseNumList:Array = materialCardInvUseNums;

            // 総合値と各パラメータをチェック
            var total:int = baseWc.baseTotal;
            var baseMax:int = baseWc.baseMax;
            var baseParams:Array = [baseWc.baseSap,baseWc.baseSdp,baseWc.baseAap,baseWc.baseAdp];
            var matIdArrIdx:int;
            var x:int;
            var plusParams:Array = [0,0,0,0];
            var minusParams:Array = [0,0,0,0];
            for (var i:int = 0; i < matList.length; i++) {
                if (Const.CMB_BASE_PARAM_UP_IDS.indexOf(matList[i].cardId)!=-1) {
                    total += 1 * matUseNumList[i];
                    matIdArrIdx = Const.CMB_BASE_PARAM_UP_IDS.indexOf(matList[i].cardId);
                    plusParams[matIdArrIdx] += 1 * matUseNumList[i];
                }
                else if (Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(matList[i].cardId)!=-1) {
                    matIdArrIdx = Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(matList[i].cardId);
                    minusParams[matIdArrIdx] -= 1 * matUseNumList[i];
                }
                else if (Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(matList[i].cardId)!=-1) {
                    matIdArrIdx = Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(matList[i].cardId);
                    baseMax = Const.CMB_BASE_PARAM_MAX_UP_NUM[matIdArrIdx];
                }
            }

            // 追加予定の素材の補正
            if (Const.CMB_BASE_PARAM_UP_IDS.indexOf(wc.id)!=-1) {
                total += 1;
                matIdArrIdx = Const.CMB_BASE_PARAM_UP_IDS.indexOf(wc.id);
                plusParams[matIdArrIdx] += 1;
            }
            else if (Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(wc.id)!=-1) {
                matIdArrIdx = Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(wc.id);
                minusParams[matIdArrIdx] -= 1;
            }
            else if (Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(wc.id)!=-1) {
                matIdArrIdx = Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(wc.id);
                baseMax = Const.CMB_BASE_PARAM_MAX_UP_NUM[matIdArrIdx];
            }
            // 現在値に加算値を足して、最大値と比較
            if (total <= baseMax) {
                // 基礎パラメータを上げる素材なら上がるパラメータが上限を超えてないかを比較
                if (Const.CMB_BASE_PARAM_UP_IDS.indexOf(wc.id)!=-1) {
                    matIdArrIdx = Const.CMB_BASE_PARAM_UP_IDS.indexOf(wc.id);
                    if ((baseParams[matIdArrIdx]+plusParams[matIdArrIdx]) <= Const.CMB_BASE_PARAM_UPPER_LIMIT) {
                        return true;
                    }
                }
                // 基礎パラメータをずらす素材なら下がるパラメータが加減を超えてないかを比較
                else if (Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(wc.id)!=-1) {
                    matIdArrIdx = Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(wc.id);
                    if ((baseParams[matIdArrIdx]+minusParams[matIdArrIdx]) >= Const.CMB_BASE_PARAM_LOWER_LIMIT) {
                        return true;
                    }
                }
                // それ以外ならOK
                else {
                    return true;
                }
            }
            return false;
        }

        // 現在BaseTotalMaxを取得
        private function get nowBaseTotalMax():int
        {
            var baseWc:WeaponCard = WeaponCard(baseCardInv.card);
            var max:int = baseWc.baseMax;
            for (var i:int=0;i<materialCardInvs.length;i++) {
                // MAX
                if (Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(materialCardInvs[i].cardId)!=-1) {
                    var cstMaxArrIdx:int = Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(materialCardInvs[i].cardId);
                    max = Const.CMB_BASE_PARAM_MAX_UP_NUM[cstMaxArrIdx];
                }
            }
            return max;
        }

        // モンスパラメータチェック
        private function addParamCheck(ci:WeaponCardInventory):Boolean
        {
            var wc:WeaponCard = WeaponCard(ci.card);
            var baseWc:WeaponCard = WeaponCard(baseCardInv.card);

            var params:Array = [baseWc.addSap,baseWc.addSdp,baseWc.addAap,baseWc.addAdp];
            // 既にリストにある素材の合算値
            var i:int;
            var j:int;
            var matWc:WeaponCard;
            for (i = 0;i<materialCardInvs.length;i++) {
                // パラアップなら加算
                if (Const.CMB_MONSTER_PARAM_UP_IDS.indexOf(materialCardInvs[i].cardId)!=-1 || WeaponCard(materialCardInvs[i].card).isNormalWeapon) {
                    matWc = WeaponCard(materialCardInvs[i].card);
                    for (j = 0; j < WeaponCard.PARAM_NUM; j++) {
                        params[j] += matWc.getMatAddParamIdx(j) * materialCardInvUseNums[i];
                    }
                }
            }

            // 素材分も合算した際に、最大値を超えているか
            for (i = 0; i < WeaponCard.PARAM_NUM; i++) {
                // 追加予定素材で加算予定分のみチェック
                if (wc.getMatAddParamIdx(i) > 0) {
                    params[i] += wc.getMatAddParamIdx(i);
                    // 一つでも最大値を超えていれば、false
                    if (params[i] > baseWc.addMaxParam) {
                        return false;
                    }
                }
            }

            return true;
        }

        // 現在の選択できる最大値を取得
        public function getNowUseMaxNum(idx:int):int
        {
            var ret:int = 1;
            // ベースカードは増減できない
            if (idx == 0) {
                return ret;
            }

            var baseWc:WeaponCard = WeaponCard(baseCardInv.card);
            var matList:Array = materialCardInvs;
            var matUseNumList:Array = materialCardInvUseNums;

            // 総合値と各パラメータをチェック
            var total:int = baseWc.baseTotal;
            var baseMax:int = baseWc.baseMax;
            var baseParams:Array = [baseWc.baseSap,baseWc.baseSdp,baseWc.baseAap,baseWc.baseAdp];
            var addParams:Array = [baseWc.addSap,baseWc.addSdp,baseWc.addAap,baseWc.addAdp];
            var matIdArrIdx:int;
            var x:int;
            var plusParams:Array = [0,0,0,0];
            var minusParams:Array = [0,0,0,0];
            var i:int;
            for (i = 0; i < baseParams.length; i++) {
                minusParams[i] = Math.abs(Const.CMB_BASE_PARAM_LOWER_LIMIT - baseParams[i]);
            }
            for (i = 0; i < matList.length; i++) {
                if (Const.CMB_BASE_PARAM_UP_IDS.indexOf(matList[i].cardId)!=-1) {
                    total += 1 * matUseNumList[i];
                    matIdArrIdx = Const.CMB_BASE_PARAM_UP_IDS.indexOf(matList[i].cardId);
                    baseParams[matIdArrIdx] += 1 * matUseNumList[i];
                    plusParams[matIdArrIdx] += 1 * matUseNumList[i];
                }
                else if (Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(matList[i].cardId)!=-1) {
                    matIdArrIdx = Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(matList[i].cardId);
                    baseParams[matIdArrIdx] -= 1 * matUseNumList[i];
                    if (Const.CMB_BASE_PARAM_LOWER_LIMIT > baseParams[matIdArrIdx]) {
                        baseParams[matIdArrIdx] = Const.CMB_BASE_PARAM_LOWER_LIMIT;
                    }
                }
                else if (Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(matList[i].cardId)!=-1) {
                    matIdArrIdx = Const.CMB_BASE_PARAM_MAX_UP_IDS.indexOf(matList[i].cardId);
                    baseMax = Const.CMB_BASE_PARAM_MAX_UP_NUM[matIdArrIdx];
                }
                else if (Const.CMB_MONSTER_PARAM_UP_IDS.indexOf(matList[i].cardId)!=-1||WeaponCard(matList[i].card).isNormalWeapon) {
                    var matWc:WeaponCard = WeaponCard(matList[i].card);
                    for (x = 0; x < WeaponCard.PARAM_NUM; x++) {
                        addParams[x] += matWc.getMatAddParamIdx(x) * matUseNumList[i];
                    }
                }
            }

            var checkWc:WeaponCard = WeaponCard(cardInventories[idx].card);
            var checkUseNum:int = getUseNum(idx);
            var checkChPrm:int = plusParams[matIdArrIdx]-minusParams[matIdArrIdx];
            log.writeLog(log.LV_DEBUG, this, "getNowUseMaxNum 0",matIdArrIdx,plusParams,minusParams);
            if (Const.CMB_BASE_PARAM_UP_IDS.indexOf(checkWc.id)!=-1) {
                ret = baseMax - total + checkUseNum;
                matIdArrIdx = Const.CMB_BASE_PARAM_UP_IDS.indexOf(checkWc.id);
                if (ret > (Const.CMB_BASE_PARAM_UPPER_LIMIT - baseParams[matIdArrIdx] + checkUseNum)) {
                    ret = Const.CMB_BASE_PARAM_UPPER_LIMIT - baseParams[matIdArrIdx] + checkUseNum;
                }
            }
            else if (Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(checkWc.id)!=-1) {
                matIdArrIdx = Const.CMB_BASE_PARAM_SHIFT_IDS.indexOf(checkWc.id);
                var tmp:Array = [baseWc.baseSap,baseWc.baseSdp,baseWc.baseAap,baseWc.baseAdp];
                var basePrm:int = tmp[matIdArrIdx];
                log.writeLog(log.LV_DEBUG, this, "getNowUseMaxNum 1",minusParams);
                // ret = Math.abs(Const.CMB_BASE_PARAM_LOWER_LIMIT - baseParams[matIdArrIdx]) + checkChPrm;
                // ret = Math.abs(Const.CMB_BASE_PARAM_LOWER_LIMIT - basePrm);
                ret = minusParams[matIdArrIdx];
                log.writeLog(log.LV_DEBUG, this, "getNowUseMaxNum 2",matIdArrIdx,basePrm,ret);
                // log.writeLog(log.LV_DEBUG, this, "getNowUseMaxNum 2",matIdArrIdx,Const.CMB_BASE_PARAM_LOWER_LIMIT,baseParams,checkUseNum);
                // log.writeLog(log.LV_DEBUG, this, "getNowUseMaxNum 3",Const.CMB_BASE_PARAM_LOWER_LIMIT - baseParams[matIdArrIdx]);
                // log.writeLog(log.LV_DEBUG, this, "getNowUseMaxNum 4",Math.abs(Const.CMB_BASE_PARAM_LOWER_LIMIT - baseParams[matIdArrIdx]));
                // log.writeLog(log.LV_DEBUG, this, "getNowUseMaxNum 5",Math.abs(Const.CMB_BASE_PARAM_LOWER_LIMIT - baseParams[matIdArrIdx]) + checkUseNum);
                // if (ret > Math.abs(Const.CMB_BASE_PARAM_LOWER_LIMIT - baseParams[matIdArrIdx]) + checkChPrm) {
                //     ret = Math.abs(Const.CMB_BASE_PARAM_LOWER_LIMIT - baseParams[matIdArrIdx]) + checkChPrm;
                // }
            }
            else if (Const.CMB_MONSTER_PARAM_UP_IDS.indexOf(checkWc.id)!=-1||checkWc.isNormalWeapon) {
             ret = Const.CMB_ADD_PARAM_UPPER_LIMIT;
                var retArr:Array = [];
                for (x = 0; x < WeaponCard.PARAM_NUM; x++) {
                    var checkNum:int = Math.floor((baseWc.addMaxParam - addParams[x]) / checkWc.getMatAddParamIdx(x)) + checkUseNum;
                    if (checkNum > 0 && checkWc.getMatAddParamIdx(x) > 0 && ret > checkNum) {
                        ret = checkNum;
                    }
                }
            }
            log.writeLog(log.LV_DEBUG, this, "getNowUseMaxNum ret",ret);
            return ret;
        }

        // パッシブセット判定
        private function checkPassive(ci:WeaponCardInventory):int
        {
            var wc:WeaponCard = WeaponCard(ci.card);
            var baseWc:WeaponCard = WeaponCard(baseCardInv.card);

            // パッシブ枠チェック
            if (baseWc.passiveNumMax < 1) {
                return SET_ERR_USE_YET;
            }

            log.writeLog(log.LV_DEBUG, this, "checkCardsetList 3.5", baseWc.passiveNum, baseWc.passiveNumMax);
            if (baseWc.passiveNumMax - baseWc.passiveNum < 1) {
                return SET_ERR_CANT_MORE_PSV;
            }

            var setPsvId:int = Const.CMB_PASSIVE_SET[Const.CMB_PASSIVE_MATERIAL_SET[ci.cardId]][0];
            log.writeLog(log.LV_DEBUG, this, "checkCardsetList 3.6", setPsvId,baseWc.passiveId);
            if (baseWc.passiveId.indexOf(setPsvId) != -1) {
                return SET_ERR_CANT_MORE;
            }

            return SET_SUCCESS;
        }

        // 専用化素材判定
        private function checkCrest(ci:WeaponCardInventory):int
        {
            var wc:WeaponCard = WeaponCard(ci.card);
            var baseWc:WeaponCard = WeaponCard(baseCardInv.card);

            // 設定レベル以下なら使用不可
            if (baseWc.level < Const.CMB_CREST_CAN_USE_LV) {
                return SET_ERR_USE_YET;
            }

            var matList:Array = materialCardInvs;
            var matCnt:int = 0;
            var isCharaFixCrest:Boolean = false;
            for (var i:int = 0; i < matList.length; i++) {
                if (Const.CMB_CREST_MATERIAL_IDS.indexOf(matList[i].cardId)!=-1) {
                    matCnt++;
                }
                if (Const.CMB_CHARA_CREST_MATERIAL_SET[matList[i].cardId]) {
                    isCharaFixCrest = true;
                }
            }

            // 既に固定キャラ指定クレストがセットしてある状態のクレストは無効
            if (isCharaFixCrest&&Const.CMB_CREST_MATERIAL_IDS.indexOf(ci.cardId)!=-1) {
                return SET_ERR_CANT_CHANGE;
            }

            // 既にクレストがセットしてある時の固定キャラ指定クレストは無効
            if (matCnt > 0 && Const.CMB_CHARA_CREST_MATERIAL_SET[ci.cardId]) {
                return SET_ERR_CANT_CHANGE;
            }

            // 固定キャラ指定がある場合、ベースがその武器か判定する
            var fixCharaId:String = "";
            if (Const.CMB_CHARA_CREST_MATERIAL_SET[ci.cardId]) fixCharaId = Const.CMB_CHARA_CREST_MATERIAL_SET[ci.cardId];
            if (fixCharaId != ""&&baseWc.restriction.indexOf(fixCharaId) != -1) {
                __errCharaId = int(fixCharaId);
                return SET_ERR_SAME_CHARA;
            }

            // 今回の素材がクレストか
            if (Const.CMB_CREST_MATERIAL_IDS.indexOf(ci.cardId)!=-1) {
                matCnt++;
            }

            if (matCnt > Const.CMB_CREST_CAN_USE_NUM) {
                return SET_ERR_CANT_MORE;
            }

            return SET_SUCCESS;
        }


    }
}