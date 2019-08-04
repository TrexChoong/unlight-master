package view.scene.edit
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;
    import mx.events.ListEvent;
    import mx.controls.ComboBox;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.image.edit.*;
    import view.scene.BaseScene;

    import model.DeckEditor;
    import model.InventorySet;
    import model.events.*;
    import controller.LobbyCtrl;

    /**
     * エディットのソートタブのビュークラス
     *
     */
    public class SortArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_SORT_ID	:String = "ID順に並び替えます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_SORT_AIU	:String = "あいうえお順に並び替えます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_SORT_LV	:String = "レベル順に並び替えます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_SORT_HP	:String = "ヒットポイント順に並び替えます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_SORT_ATK	:String = "攻撃力順に並び替えます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_SORT_DEF	:String = "防御力順に並び替えます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_SORT_RARE	:String = "レアリティ順に並び替えます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_NAME	:String = "名前";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_LV	:String = "レベル";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_ATK	:String = "攻撃力";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_DEF	:String = "防御力";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_COST	:String = "コスト";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_RARE	:String = "レアリティ";

        CONFIG::LOCALE_EN
        private static const _TRANS_SORT_ID	:String = "Sort by ID";
        CONFIG::LOCALE_EN
        private static const _TRANS_SORT_AIU	:String = "Sort alphabetically";
        CONFIG::LOCALE_EN
        private static const _TRANS_SORT_LV	:String = "Sort by level";
        CONFIG::LOCALE_EN
        private static const _TRANS_SORT_HP	:String = "Sort by HP";
        CONFIG::LOCALE_EN
        private static const _TRANS_SORT_ATK	:String = "Sort by attack power";
        CONFIG::LOCALE_EN
        private static const _TRANS_SORT_DEF	:String = "Sort by defensive power";
        CONFIG::LOCALE_EN
        private static const _TRANS_SORT_RARE	:String = "Sort by rarity";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_NAME	:String = "Name";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_LV	:String = "Level";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_ATK	:String = "Attack Power";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_DEF	:String = "Defense";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_COST	:String = "Cost";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_RARE	:String = "Rarity";

        CONFIG::LOCALE_TCN
        private static const _TRANS_SORT_ID	:String = "以ID的順序排序";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SORT_AIU	:String = "以發音順序排序";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SORT_LV	:String = "以等級高低排序";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SORT_HP	:String = "以生命值排序";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SORT_ATK	:String = "以攻擊力排序";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SORT_DEF	:String = "以防禦值排序";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SORT_RARE	:String = "以稀有度排序";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_NAME	:String = "名字";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_LV	:String = "等級";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_ATK	:String = "攻擊力";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_DEF	:String = "防禦力";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_COST	:String = "COST";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_RARE	:String = "稀有度";

        CONFIG::LOCALE_SCN
        private static const _TRANS_SORT_ID	:String = "按ID顺序排列。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SORT_AIU	:String = "按发音顺序排列。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SORT_LV	:String = "按等级高低排列。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SORT_HP	:String = "按体力值高低排列。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SORT_ATK	:String = "按攻击力强弱排列。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SORT_DEF	:String = "按防御力强弱排列。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SORT_RARE	:String = "按稀有程度排列。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_NAME	:String = "名字";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_LV	:String = "等级";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_ATK	:String = "攻击力";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_DEF	:String = "防御力";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_COST	:String = "成本";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_RARE	:String = "稀有度";

        CONFIG::LOCALE_KR
        private static const _TRANS_SORT_ID	:String = "ID순으로 정렬합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_SORT_AIU	:String = "가나다순으로 정렬합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_SORT_LV	:String = "레벨순으로 정렬합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_SORT_HP	:String = "히트 포인트 순으로 정렬합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_SORT_ATK	:String = "공격력순으로 정렬합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_SORT_DEF	:String = "방어력순으로 정렬합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_SORT_RARE	:String = "레어도순으로 정렬합니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_NAME	:String = "이름";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_LV	:String = "레벨";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_ATK	:String = "공격력";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_DEF	:String = "방어력";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_COST	:String = "コスト";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_RARE	:String = "레어도";

        CONFIG::LOCALE_FR
        private static const _TRANS_SORT_ID	:String = "Ranger par ID";
        CONFIG::LOCALE_FR
        private static const _TRANS_SORT_AIU	:String = "Ranger par ordre alphabétique";
        CONFIG::LOCALE_FR
        private static const _TRANS_SORT_LV	:String = "Ranger par niveau";
        CONFIG::LOCALE_FR
        private static const _TRANS_SORT_HP	:String = "Ranger par HP";
        CONFIG::LOCALE_FR
        private static const _TRANS_SORT_ATK	:String = "Ranger par Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_SORT_DEF	:String = "Ranger par Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_SORT_RARE	:String = "Ranger par Rareté ";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_NAME	:String = "Nom";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_LV	:String = "Niveau";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_ATK	:String = "Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_DEF	:String = "Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_COST	:String = "Coût";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_RARE	:String = "Rareté";

        CONFIG::LOCALE_ID
        private static const _TRANS_SORT_ID	:String = "ID順に並び替えます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_SORT_AIU	:String = "あいうえお順に並び替えます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_SORT_LV	:String = "レベル順に並び替えます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_SORT_HP	:String = "ヒットポイント順に並び替えます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_SORT_ATK	:String = "攻撃力順に並び替えます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_SORT_DEF	:String = "防御力順に並び替えます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_SORT_RARE	:String = "レアリティ順に並び替えます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_NAME	:String = "名前";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_LV	:String = "レベル";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_ATK	:String = "攻撃力";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_DEF	:String = "防御力";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_COST	:String = "コスト";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_RARE	:String = "レアリティ";

        CONFIG::LOCALE_TH
        private static const _TRANS_SORT_ID :String = "เรียงตามID";//"ID順に並び替えます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_SORT_AIU    :String = "เรียงตามตัวอักษร";//"あいうえお順に並び替えます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_SORT_LV :String = "เรียงตามเลเวล";//"レベル順に並び替えます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_SORT_HP :String = "เรียงตามHP";//"ヒットポイント順に並び替えます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_SORT_ATK    :String = "เรียงตามพลังโจมตี";//"攻撃力順に並び替えます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_SORT_DEF    :String = "เรียงตามพลังป้องกัน";//"防御力順に並び替えます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_SORT_RARE   :String = "เรียงตามลำดับความหายาก";//"レアリティ順に並び替えます。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_NAME   :String = "ชื่อ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_LV :String = "เลเวล";//"レベル";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_ATK    :String = "พลังโจมตี";//"攻撃力";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_DEF    :String = "พลังป้องกัน";//"防御力";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_COST   :String = "Cost";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_RARE   :String = "ระดับความหายาก";//"レアリティ";


        // エディットインスタンス
        private var _deckEditor:DeckEditor = DeckEditor.instance;
        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;                           // ゲームのコントローラー

        // ソートパネル
        private var _charaSorter:CharaSortComboBox   = new CharaSortComboBox();
        private var _equipSorter:EquipSortComboBox   = new EquipSortComboBox();
        private var _eventSorter:EventSortComboBox   = new EventSortComboBox();
        private var _monsterSorter:CharaSortComboBox = new CharaSortComboBox();
        private var _otherSorter:OtherSortComboBox   = new OtherSortComboBox();

        // 定数
        private static const _PANEL_X:int = 640;
        private static const _PANEL_Y:int = 56;
        private static const _OFFSET_Y:int = 40;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["ID順に並び替えます。",
//                 "あいうえお順に並び替えます。",
//                 "レベル順に並び替えます。",
//                 "ヒットポイント順に並び替えます。",
//                 "攻撃力順に並び替えます。",
//                 "防御力順に並び替えます。",
//                 "レアリティ順に並び替えます。"],
                [_TRANS_SORT_ID,
                 _TRANS_SORT_AIU,
                 _TRANS_SORT_LV,
                 _TRANS_SORT_HP,
                 _TRANS_SORT_ATK,
                 _TRANS_SORT_DEF,
                 _TRANS_SORT_RARE],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _EDIT_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function SortArea()
        {
//             Unlight.GCW.watch(_id);
//             Unlight.GCW.watch(_name);
//             Unlight.GCW.watch(_level);
//             Unlight.GCW.watch(_hp);
//             Unlight.GCW.watch(_ap);
//             Unlight.GCW.watch(_dp);
//             Unlight.GCW.watch(_rarity);
//             Unlight.GCW.watch(_charaSorter);
//             Unlight.GCW.watch(_equipSorter);
//             Unlight.GCW.watch(_eventSorter);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            // _toolTipOwnerArray.push([0,_id]);  //
            // _toolTipOwnerArray.push([1,_name]);  //
            // _toolTipOwnerArray.push([2,_level]);  //
            // _toolTipOwnerArray.push([3,_hp]);  //
            // _toolTipOwnerArray.push([4,_ap]);  //
            // _toolTipOwnerArray.push([5,_dp]);  //
            // _toolTipOwnerArray.push([6,_rarity]);  //
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
            // var array:Array = [_id, _name, _level, _hp, _ap, _dp, _rarity];
            // array.forEach(function(item:*, index:int, array:Array):void{initSortPanel(item, index)});

            initilizeToolTipOwners();
            updateHelp(_EDIT_HELP);

            _deckEditor.addEventListener(DeckEditor.CHANGE_TYPE, changeTypeHandler);
            _charaSorter.addEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _equipSorter.addEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _eventSorter.addEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _monsterSorter.addEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _otherSorter.addEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            addChild(_charaSorter);
            addChild(_equipSorter);
            addChild(_eventSorter);
            addChild(_monsterSorter);
            addChild(_otherSorter);
        }

        // 後処理
        public override function final():void
        {
            _deckEditor.removeEventListener(DeckEditor.CHANGE_TYPE, changeTypeHandler);
            _charaSorter.removeEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _equipSorter.removeEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _eventSorter.removeEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _monsterSorter.removeEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            _otherSorter.removeEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            removeChild(_charaSorter);
            removeChild(_equipSorter);
            removeChild(_eventSorter);
            removeChild(_monsterSorter);
            removeChild(_otherSorter);
        }


        private function changeTypeHandler(e:Event):void
        {
            switch (_deckEditor.editType)
            {
            case InventorySet.TYPE_CHARA:
                _charaSorter.visible = true;
                _equipSorter.visible = false;
                _eventSorter.visible = false;
                _monsterSorter.visible = false;
                _otherSorter.visible = false;
                break;
            case InventorySet.TYPE_WEAPON:
                _charaSorter.visible = false;
                _equipSorter.visible = true;
                _eventSorter.visible = false;
                _monsterSorter.visible = false;
                _otherSorter.visible = false;
                break;
            case InventorySet.TYPE_EVENT:
                _charaSorter.visible = false;
                _equipSorter.visible = false;
                _eventSorter.visible = true;
                _monsterSorter.visible = false;
                _otherSorter.visible = false;
                break;
            case InventorySet.TYPE_MONSTER:
                _charaSorter.visible = false;
                _equipSorter.visible = false;
                _eventSorter.visible = false;
                _monsterSorter.visible = true;
                _otherSorter.visible = false;
                break;
            case InventorySet.TYPE_OTHER:
                _charaSorter.visible = false;
                _equipSorter.visible = false;
                _eventSorter.visible = false;
                _monsterSorter.visible = false;
                _otherSorter.visible = true;
                break;
            }
        }

        private function changeDropDownListHandler(e:ListEvent):void
        {
            SE.playDeckTabClick();

            var select:Object = "ID";
            switch (_deckEditor.editType)
            {
            case InventorySet.TYPE_CHARA:
                select = _charaSorter.selectedItem;
                break;
            case InventorySet.TYPE_WEAPON:
                select = _equipSorter.selectedItem;
                break;
            case InventorySet.TYPE_EVENT:
                select = _eventSorter.selectedItem;
                break;
            case InventorySet.TYPE_MONSTER:
                select = _monsterSorter.selectedItem;
                break;
            case InventorySet.TYPE_OTHER:
                select = _otherSorter.selectedItem;
                break;
            }

            switch (select)
            {
            case "ID":
                _deckEditor.sort = DeckEditor.SORT_ID;
                break;
//            case "名前":
            case _TRANS_CASE_NAME:
                _deckEditor.sort = DeckEditor.SORT_NAME;
                break;
//            case "レベル":
            case _TRANS_CASE_LV:
                _deckEditor.sort = DeckEditor.SORT_LEVEL;
                break;
            case "HP":
                _deckEditor.sort = DeckEditor.SORT_HP;
                break;
//            case "攻撃力":
            case _TRANS_CASE_ATK:
                _deckEditor.sort = DeckEditor.SORT_AP;
                break;
//            case "防御力":
            case _TRANS_CASE_DEF:
                _deckEditor.sort = DeckEditor.SORT_DP;
                break;
            case _TRANS_CASE_COST:
                _deckEditor.sort = DeckEditor.SORT_COST;
                break;
//            case "レアリティ":
            case _TRANS_CASE_RARE:
                _deckEditor.sort = DeckEditor.SORT_RARITY;
                break;
            }
            _deckEditor.binderSort();
        }

        //
        public function initSortPanel(panel:*, index:int):void
        {
            panel.x = _PANEL_X;
            panel.y = _PANEL_Y + _OFFSET_Y * index;
//            addChild(panel);
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
            return new HideThread(this);
        }
    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import mx.controls.ComboBox;
import org.libspark.thread.Thread;

import model.DeckEditor;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.edit.SortArea;

class ShowThread extends BaseShowThread
{
    public function ShowThread(sa:SortArea, stage:DisplayObjectContainer, at:int)
    {
        super(sa, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(sa:SortArea)
    {
        super(sa);
    }

}


class CharaSortComboBox extends ComboBox
{
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_NAME	:String = "名前";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_LV	:String = "レベル";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_ATK	:String = "攻撃力";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_DEF	:String = "防御力";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_COST	:String = "コスト";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_RARE	:String = "レアリティ";

        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_NAME	:String = "Name";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_LV	:String = "Level";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_ATK	:String = "Attack Power";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_DEF	:String = "Defense Power";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_COST	:String = "Cost";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_RARE	:String = "Rarity";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_NAME	:String = "名字";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_LV	:String = "等級";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_ATK	:String = "攻擊力";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_DEF	:String = "防禦力";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_COST	:String = "COST";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_RARE	:String = "稀有度";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_NAME	:String = "名字";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_LV	:String = "等级";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_ATK	:String = "攻击力";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_DEF	:String = "防御力";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_COST	:String = "成本";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_RARE	:String = "稀有度";

        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_NAME	:String = "이름";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_LV	:String = "레벨";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_ATK	:String = "공격력";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_DEF	:String = "방어력";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_COST	:String = "コスト";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_RARE	:String = "레어도";

        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_NAME	:String = "Nom";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_LV	:String = "Niveau";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_ATK	:String = "Attaque";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_DEF	:String = "Défense";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_COST	:String = "Coût";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_RARE	:String = "Rareté";

        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_NAME	:String = "名前";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_LV	:String = "レベル";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_ATK	:String = "攻撃力";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_DEF	:String = "防御力";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_COST	:String = "コスト";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_RARE	:String = "レアリティ";

        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_NAME   :String = "ชื่อ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_LV :String = "เลเวล";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_ATK    :String = "พลังโจมตี";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_DEF    :String = "พลังป้องกัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_COST   :String = "Cost";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_RARE   :String = "ระดับความหายาก";


    public function CharaSortComboBox():void
    {

//        dataProvider = ["ID", "レベル", "コスト","HP", "攻撃力","防御力", "レアリティ", "名前"];
        dataProvider = ["ID", _TRANS_CASE_LV, _TRANS_CASE_COST, "HP", _TRANS_CASE_ATK,_TRANS_CASE_DEF,_TRANS_CASE_RARE, _TRANS_CASE_NAME];
        dropdownWidth = 95;
        x = 24;
        y = 423;
        width = 96;
        height =18;
        visible = false;
    }
}

class EquipSortComboBox extends ComboBox
{
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_NAME	:String = "名前";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_COST	:String = "コスト";

        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_NAME	:String = "Name";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_COST	:String = "Cost";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_NAME	:String = "名字";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_COST	:String = "COST";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_NAME	:String = "名字";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_COST	:String = "成本";

        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_NAME	:String = "이름";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_COST	:String = "Cost";

        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_NAME	:String = "Nom";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_COST	:String = "Coût";

        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_NAME	:String = "名前";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_COST	:String = "コスト";

        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_NAME   :String = "ชื่อ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_COST   :String = "Cost";


    public function EquipSortComboBox():void
    {
//        dataProvider = ["ID", "名前"];
//        dataProvider = ["ID", _TRANS_CASE_NAME];
        dataProvider = ["ID", _TRANS_CASE_COST, _TRANS_CASE_NAME];
        dropdownWidth = 95;
        x = 24;
        y = 423;
        width = 96;
        height =18;
        visible = false;
    }
}

class EventSortComboBox extends ComboBox
{
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_NAME	:String = "名前";
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_COST	:String = "コスト";

        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_NAME	:String = "Name";
        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_COST	:String = "Cost";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_NAME	:String = "名字";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_COST	:String = "COST";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_NAME	:String = "名字";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_COST	:String = "成本";

        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_NAME	:String = "이름";
        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_COST	:String = "Cost";

        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_NAME	:String = "Nom";
        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_COST	:String = "Coût";

        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_NAME	:String = "名前";
        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_COST	:String = "コスト";

        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_NAME   :String = "ชื่อ";
        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_COST   :String = "Cost";


    public function EventSortComboBox():void
    {
//        dataProvider = ["ID", "名前"];
//        dataProvider = ["ID", _TRANS_CASE_NAME];
        dataProvider = ["ID", _TRANS_CASE_COST,  _TRANS_CASE_NAME];
        dropdownWidth = 95;
        x = 24;
        y = 423;
        width = 96;
        height =18;
        visible = false;
    }
}

class OtherSortComboBox extends ComboBox
{
        CONFIG::LOCALE_JP
        private static const _TRANS_CASE_NAME	:String = "名前";

        CONFIG::LOCALE_EN
        private static const _TRANS_CASE_NAME	:String = "Name";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CASE_NAME	:String = "名字";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CASE_NAME	:String = "名字";

        CONFIG::LOCALE_KR
        private static const _TRANS_CASE_NAME	:String = "이름";

        CONFIG::LOCALE_FR
        private static const _TRANS_CASE_NAME	:String = "Nom";

        CONFIG::LOCALE_ID
        private static const _TRANS_CASE_NAME	:String = "名前";

        CONFIG::LOCALE_TH
        private static const _TRANS_CASE_NAME   :String = "ชื่อ";


    public function OtherSortComboBox():void
    {
//        dataProvider = ["ID", "名前"];
        dataProvider = ["ID", _TRANS_CASE_NAME];
        dropdownWidth = 95;
        x = 24;
        y = 423;
        width = 96;
        height =18;
        visible = false;
    }
}