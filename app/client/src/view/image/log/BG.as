package view.image.log
{

    import flash.display.*;
    import flash.events.Event;
    import mx.events.*;
    import model.DeckEditor;
    import model.events.*;
    import view.image.BaseImage;
    import flash.events.MouseEvent;
    import mx.controls.ComboBox;

    /**
     * BG表示クラス
     *
     */


    public class BG extends BaseImage
    {
        // HP表示元SWF
        [Embed(source="../../../../data/image/log/log_game.swf")]
        private var _Source:Class;

        private static const X:int = 0;
        private static const Y:int = 0;

        // 定数
        private const LOG:String = "log"

        private var _bg:MovieClip;

        private var _closeButton:SimpleButton;
        private var _prevButton:SimpleButton;
        private var _nextButton:SimpleButton;

        private var _closeFunc:Function;
        private var _prevFunc:Function;
        private var _nextFunc:Function;

        private var _logListSortComboBox:LogListSortComboBox = new LogListSortComboBox();
        private var _listSortFunc:Function;

        private static const _LIST_SORT_BOX_X:int = 392;
        private static const _LIST_SORT_BOX_Y:int = 27;

        private var _max:int;
        private var _page:int;
        private var _num:int;
        private var _currentNum:int;


        /**
         * コンストラクタ
         *
         */
        public function BG()
        {
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _closeButton = SimpleButton(_root.getChildByName("btn_close"));
            _prevButton = SimpleButton(_root.getChildByName("btn_back"));
            _nextButton = SimpleButton(_root.getChildByName("btn_next"));

            _closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
            _prevButton.addEventListener(MouseEvent.CLICK, prevHandler);
            _nextButton.addEventListener(MouseEvent.CLICK, nextHandler);

            _logListSortComboBox.x = _LIST_SORT_BOX_X;
            _logListSortComboBox.y = _LIST_SORT_BOX_Y;

            addChild(_logListSortComboBox);
            _logListSortComboBox.addEventListener(ListEvent.CHANGE, listSortHandler);
        }

        override public  function final():void
        {
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function  setCloseHandler(handler:Function):void
        {
             _closeFunc = handler;
        }

        public function  setPrevHandler(handler:Function):void
        {
             _prevFunc = handler;
        }

        public function  setNextHandler(handler:Function):void
        {
             _nextFunc = handler;
        }

        public function  setListSortHandler(handler:Function):void
        {
             _listSortFunc = handler;
        }

        public function pageButtonVisible(max:int , page:int):void
        {
            _max = max;
            _page = page;

            waitComplete(setPageButtonVisible);
        }

        public function setPageButtonVisible():void
        {
            if (_max == 1)
            {
                _nextButton.visible = false;
                _prevButton.visible = false;
            }
            else if (_max <= _page)
            {
                _nextButton.visible = false;
                _prevButton.visible = true;
            }else if(_page == 1)
            {
                _nextButton.visible = true;
                _prevButton.visible = false;
            }else{
                _nextButton.visible = true;
                _prevButton.visible = true;
            }
        }

        public function closeHandler(e:MouseEvent):void
        {
            if (_closeFunc !=null)
            {
                _closeFunc();
            }

        }

        public function prevHandler(e:MouseEvent):void
        {
            if (_prevFunc !=null)
            {
                _prevFunc();
            }

        }

        public function nextHandler(e:MouseEvent):void
        {
            if (_nextFunc !=null)
            {
                _nextFunc();
            }

        }

        public function listSortHandler(e:ListEvent):void
        {
            if (_listSortFunc !=null)
            {
                _listSortFunc(LogListSortComboBox.TAB_TYPE_SET[_logListSortComboBox.selectedIndex]);
            }

        }

    }

}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import mx.controls.ComboBox;
import org.libspark.thread.Thread;

import view.scene.edit.SortArea;
import model.utils.ClientLog;

class LogListSortComboBox extends ComboBox
{
    CONFIG::LOCALE_JP
    private static const _LOG_EXCH_CARD_NAME    :String = "合成";
    CONFIG::LOCALE_JP
    private static const _LOG_GOT_LOT           :String = "レアカードクジ";
    CONFIG::LOCALE_JP
    private static const _LOG_GOT_LOGIN         :String = "ログインボーナス";
    CONFIG::LOCALE_JP
    private static const _LOG_BOUGHT_ITEM       :String = "アイテム購入";
    CONFIG::LOCALE_JP
    private static const _LOG_BOUGHT_RMITEM     :String = "課金アイテム購入";
    CONFIG::LOCALE_JP
    private static const _LOG_GOT_ITEM          :String = "アイテム取得";
    CONFIG::LOCALE_JP
    private static const _LOG_GOT_LEVEL         :String = "レベルアップ";
    CONFIG::LOCALE_JP
    private static const _LOG_GOT_SLOT_CARD     :String = "武器/ｲﾍﾞﾝﾄｶｰﾄﾞ取得";
    CONFIG::LOCALE_JP
    private static const _LOG_GOT_CHARA_CARD    :String = "キャラカード取得";
    CONFIG::LOCALE_JP
    private static const _LOG_GOT_AVATAR_PART   :String = "アバターパーツ取得";
    CONFIG::LOCALE_JP
    private static const _LOG_SUCC_ACHIEVEMENT  :String = "レコード達成";
    CONFIG::LOCALE_JP
    private static const _LOG_SUCC_INVITE       :String = "招待成功";
    CONFIG::LOCALE_JP
    private static const _LOG_VANISH_ITEM       :String = "アイテム使用";
    CONFIG::LOCALE_JP
    private static const _LOG_VANISH_CARD       :String = "カード消滅";

    CONFIG::LOCALE_EN
    private static const _LOG_EXCH_CARD_NAME    :String = "Synthesize";
    CONFIG::LOCALE_EN
    private static const _LOG_GOT_LOT           :String = "Gamble";
    CONFIG::LOCALE_EN
    private static const _LOG_GOT_LOGIN         :String = "Login bonus";
    CONFIG::LOCALE_EN
    private static const _LOG_BOUGHT_ITEM       :String = "Buy item";
    CONFIG::LOCALE_EN
    private static const _LOG_BOUGHT_RMITEM     :String = "Buy real-money item";
    CONFIG::LOCALE_EN
    private static const _LOG_GOT_ITEM          :String = "Take item";
    CONFIG::LOCALE_EN
    private static const _LOG_GOT_LEVEL         :String = "Level up";
    CONFIG::LOCALE_EN
    private static const _LOG_GOT_SLOT_CARD     :String = "Take weapon/event card";
    CONFIG::LOCALE_EN
    private static const _LOG_GOT_CHARA_CARD    :String = "Take character card";
    CONFIG::LOCALE_EN
    private static const _LOG_GOT_AVATAR_PART   :String = "Take avatar parts";
    CONFIG::LOCALE_EN
    private static const _LOG_SUCC_ACHIEVEMENT  :String = "Achievement recorded";
    CONFIG::LOCALE_EN
    private static const _LOG_SUCC_INVITE       :String = "Invitation succeeded";
    CONFIG::LOCALE_EN
    private static const _LOG_VANISH_ITEM       :String = "Use item";
    CONFIG::LOCALE_EN
    private static const _LOG_VANISH_CARD       :String = "Destroy card";

    CONFIG::LOCALE_TCN
    private static const _LOG_EXCH_CARD_NAME    :String = "合成";
    CONFIG::LOCALE_TCN
    private static const _LOG_GOT_LOT           :String = "抽獎";
    CONFIG::LOCALE_TCN
    private static const _LOG_GOT_LOGIN         :String = "登錄獎勵";
    CONFIG::LOCALE_TCN
    private static const _LOG_BOUGHT_ITEM       :String = "購買道具";
    CONFIG::LOCALE_TCN
    private static const _LOG_BOUGHT_RMITEM     :String = "購買現金道具";
    CONFIG::LOCALE_TCN
    private static const _LOG_GOT_ITEM          :String = "得到道具";
    CONFIG::LOCALE_TCN
    private static const _LOG_GOT_LEVEL         :String = "等級提升";
    CONFIG::LOCALE_TCN
    private static const _LOG_GOT_SLOT_CARD     :String = "武器/事件卡取得";
    CONFIG::LOCALE_TCN
    private static const _LOG_GOT_CHARA_CARD    :String = "得到了角色卡片";
    CONFIG::LOCALE_TCN
    private static const _LOG_GOT_AVATAR_PART   :String = "得到了虛擬人物零件";
    CONFIG::LOCALE_TCN
    private static const _LOG_SUCC_ACHIEVEMENT  :String = "成就達成";
    CONFIG::LOCALE_TCN
    private static const _LOG_SUCC_INVITE       :String = "邀請成功";
    CONFIG::LOCALE_TCN
    private static const _LOG_VANISH_ITEM       :String = "使用道具";
    CONFIG::LOCALE_TCN
    private static const _LOG_VANISH_CARD       :String = "卡片消滅";

    CONFIG::LOCALE_SCN
    private static const _LOG_EXCH_CARD_NAME    :String = "合成";
    CONFIG::LOCALE_SCN
    private static const _LOG_GOT_LOT           :String = "抽奖";
    CONFIG::LOCALE_SCN
    private static const _LOG_GOT_LOGIN         :String = "登陆奖励";
    CONFIG::LOCALE_SCN
    private static const _LOG_BOUGHT_ITEM       :String = "购买道具";
    CONFIG::LOCALE_SCN
    private static const _LOG_BOUGHT_RMITEM     :String = "购买付费道具";
    CONFIG::LOCALE_SCN
    private static const _LOG_GOT_ITEM          :String = "获得道具";
    CONFIG::LOCALE_SCN
    private static const _LOG_GOT_LEVEL         :String = "升级";
    CONFIG::LOCALE_SCN
    private static const _LOG_GOT_SLOT_CARD     :String = "获得武器/活动卡";
    CONFIG::LOCALE_SCN
    private static const _LOG_GOT_CHARA_CARD    :String = "获得角色卡";
    CONFIG::LOCALE_SCN
    private static const _LOG_GOT_AVATAR_PART   :String = "获得虚拟人物配件";
    CONFIG::LOCALE_SCN
    private static const _LOG_SUCC_ACHIEVEMENT  :String = "达成纪录";
    CONFIG::LOCALE_SCN
    private static const _LOG_SUCC_INVITE       :String = "邀请成功";
    CONFIG::LOCALE_SCN
    private static const _LOG_VANISH_ITEM       :String = "道具使用";
    CONFIG::LOCALE_SCN
    private static const _LOG_VANISH_CARD       :String = "卡片失效";


    CONFIG::LOCALE_KR
    private static const _LOG_EXCH_CARD_NAME    :String = "合成";
    CONFIG::LOCALE_KR
    private static const _LOG_GOT_LOT           :String = "レアカードクジ";
    CONFIG::LOCALE_KR
    private static const _LOG_GOT_LOGIN         :String = "ログインボーナス";
    CONFIG::LOCALE_KR
    private static const _LOG_BOUGHT_ITEM       :String = "アイテム購入";
    CONFIG::LOCALE_KR
    private static const _LOG_BOUGHT_RMITEM     :String = "課金アイテム購入";
    CONFIG::LOCALE_KR
    private static const _LOG_GOT_ITEM          :String = "アイテム取得";
    CONFIG::LOCALE_KR
    private static const _LOG_GOT_LEVEL         :String = "レベルアップ";
    CONFIG::LOCALE_KR
    private static const _LOG_GOT_SLOT_CARD     :String = "武器/ｲﾍﾞﾝﾄｶｰﾄﾞ取得";
    CONFIG::LOCALE_KR
    private static const _LOG_GOT_CHARA_CARD    :String = "キャラカード取得";
    CONFIG::LOCALE_KR
    private static const _LOG_GOT_AVATAR_PART   :String = "アバターパーツ取得";
    CONFIG::LOCALE_KR
    private static const _LOG_SUCC_ACHIEVEMENT  :String = "レコード達成";
    CONFIG::LOCALE_KR
    private static const _LOG_SUCC_INVITE       :String = "招待成功";
    CONFIG::LOCALE_KR
    private static const _LOG_VANISH_ITEM       :String = "アイテム使用";
    CONFIG::LOCALE_KR
    private static const _LOG_VANISH_CARD       :String = "カード消滅";

    CONFIG::LOCALE_FR
    private static const _LOG_EXCH_CARD_NAME    :String = "Synthèse";
    CONFIG::LOCALE_FR
    private static const _LOG_GOT_LOT           :String = "Loterie de cartes rares";
    CONFIG::LOCALE_FR
    private static const _LOG_GOT_LOGIN         :String = "Bonus Login";
    CONFIG::LOCALE_FR
    private static const _LOG_BOUGHT_ITEM       :String = "Achat d'un objet";
    CONFIG::LOCALE_FR
    private static const _LOG_BOUGHT_RMITEM     :String = "Achat d'un objet taxé";
    CONFIG::LOCALE_FR
    private static const _LOG_GOT_ITEM          :String = "Obtention d'un objet";
    CONFIG::LOCALE_FR
    private static const _LOG_GOT_LEVEL         :String = "Level Up";
    CONFIG::LOCALE_FR
    private static const _LOG_GOT_SLOT_CARD     :String = "Obtention d'un équipement/d'une carte événement";
    CONFIG::LOCALE_FR
    private static const _LOG_GOT_CHARA_CARD    :String = "Obtention d'une carte personnage";
    CONFIG::LOCALE_FR
    private static const _LOG_GOT_AVATAR_PART   :String = "Obtention d'un accessoire pour votre Avatar";
    CONFIG::LOCALE_FR
    private static const _LOG_SUCC_ACHIEVEMENT  :String = "Mission accomplie";
    CONFIG::LOCALE_FR
    private static const _LOG_SUCC_INVITE       :String = "Invitation réussie";
    CONFIG::LOCALE_FR
    private static const _LOG_VANISH_ITEM       :String = "Utilisation de l'objet";
    CONFIG::LOCALE_FR
    private static const _LOG_VANISH_CARD       :String = "Suppression de la carte";

    CONFIG::LOCALE_ID
    private static const _LOG_EXCH_CARD_NAME    :String = "合成";
    CONFIG::LOCALE_ID
    private static const _LOG_GOT_LOT           :String = "レアカードクジ";
    CONFIG::LOCALE_ID
    private static const _LOG_GOT_LOGIN         :String = "ログインボーナス";
    CONFIG::LOCALE_ID
    private static const _LOG_BOUGHT_ITEM       :String = "アイテム購入";
    CONFIG::LOCALE_ID
    private static const _LOG_BOUGHT_RMITEM     :String = "課金アイテム購入";
    CONFIG::LOCALE_ID
    private static const _LOG_GOT_ITEM          :String = "アイテム取得";
    CONFIG::LOCALE_ID
    private static const _LOG_GOT_LEVEL         :String = "レベルアップ";
    CONFIG::LOCALE_ID
    private static const _LOG_GOT_SLOT_CARD     :String = "武器/ｲﾍﾞﾝﾄｶｰﾄﾞ取得";
    CONFIG::LOCALE_ID
    private static const _LOG_GOT_CHARA_CARD    :String = "キャラカード取得";
    CONFIG::LOCALE_ID
    private static const _LOG_GOT_AVATAR_PART   :String = "アバターパーツ取得";
    CONFIG::LOCALE_ID
    private static const _LOG_SUCC_ACHIEVEMENT  :String = "レコード達成";
    CONFIG::LOCALE_ID
    private static const _LOG_SUCC_INVITE       :String = "招待成功";
    CONFIG::LOCALE_ID
    private static const _LOG_VANISH_ITEM       :String = "アイテム使用";
    CONFIG::LOCALE_ID
    private static const _LOG_VANISH_CARD       :String = "カード消滅";

    CONFIG::LOCALE_TH
    private static const _LOG_EXCH_CARD_NAME    :String = "ผสมไอเท็ม";//"合成";
    CONFIG::LOCALE_TH
    private static const _LOG_GOT_LOT           :String = "สลากเสี่ยงแรร์การ์ด"; // レアカードクジ
    CONFIG::LOCALE_TH
    private static const _LOG_GOT_LOGIN         :String = "Login Bonus";//"ログインボーナス";
    CONFIG::LOCALE_TH
    private static const _LOG_BOUGHT_ITEM       :String = "ซื้อไอเท็ม";//"アイテム購入";
    CONFIG::LOCALE_TH
    private static const _LOG_BOUGHT_RMITEM     :String = "ซื้อไอเท็มด้วยระบบ Billing";//"課金アイテム購入";
    CONFIG::LOCALE_TH
    private static const _LOG_GOT_ITEM          :String = "ได้รับไอเท็ม";//"アイテム取得";
    CONFIG::LOCALE_TH
    private static const _LOG_GOT_LEVEL         :String = "เลเวลอัพ";//"レベルアップ";
    CONFIG::LOCALE_TH
    private static const _LOG_GOT_SLOT_CARD     :String = "ได้รับอาวุธ/อีเวนท์การ์ด";//"武器/ｲﾍﾞﾝﾄｶｰﾄﾞ取得";
    CONFIG::LOCALE_TH
    private static const _LOG_GOT_CHARA_CARD    :String = "ได้รับการ์ดตัวละคร";//"キャラカード取得";
    CONFIG::LOCALE_TH
    private static const _LOG_GOT_AVATAR_PART   :String = "ได้รับชิ้นส่วนอวาตาร์";//"アバターパーツ取得";
    CONFIG::LOCALE_TH
    private static const _LOG_SUCC_ACHIEVEMENT  :String = "บันทึกความสำเร็จ";//"レコード達成";
    CONFIG::LOCALE_TH
    private static const _LOG_SUCC_INVITE       :String = "อัญเชิญสำเร็จ";//"招待成功";
    CONFIG::LOCALE_TH
    private static const _LOG_VANISH_ITEM       :String = "ใช้ไอเท็ม";//"アイテム使用";
    CONFIG::LOCALE_TH
    private static const _LOG_VANISH_CARD       :String = "การ์ดหายไป";//"カード消滅";


    public static const TAB_TYPE_SET:Array = [
        ClientLog.ALL,
        ClientLog.GOT_EXCH_CARD,
        ClientLog.GOT_LOT,
        ClientLog.GOT_LOGIN,
//        ClientLog.BOUGHT_ITEM,
//        ClientLog.BOUGHT_RMITEM,
        ClientLog.GOT_ITEM,
        ClientLog.GOT_LEVEL,
        ClientLog.GOT_SLOT_CARD,
        ClientLog.GOT_CHARA_CARD,
        ClientLog.GOT_AVATAR_PART,
        ClientLog.SUCC_ACHIEVEMENT,
        ClientLog.SUCC_INVITE,
        ClientLog.VANISH_ITEM,
        ClientLog.VANISH_CARD
        ]; /* of ElementType */

    public function LogListSortComboBox():void
    {
        //dataProvider = ["ID", "名前", "レベル", "HP", "攻撃力","防御力","レアリティ"];
        dataProvider = [
            "Log", _LOG_EXCH_CARD_NAME, _LOG_GOT_LOT, _LOG_GOT_LOGIN, //_LOG_BOUGHT_ITEM, _LOG_BOUGHT_RMITEM,
            _LOG_GOT_ITEM, _LOG_GOT_LEVEL, _LOG_GOT_SLOT_CARD, _LOG_GOT_CHARA_CARD, _LOG_GOT_AVATAR_PART,
            _LOG_SUCC_ACHIEVEMENT, _LOG_SUCC_INVITE, _LOG_VANISH_ITEM, _LOG_VANISH_CARD,
            ];

        dropdownWidth = 127;
        rowCount = ClientLog.TYPE_NUM;
        x = 0;
        y = 0;
        width = 128;
        height =18;
        visible = true;
    }
}

