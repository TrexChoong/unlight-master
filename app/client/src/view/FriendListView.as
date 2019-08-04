package view
{

    import flash.display.*;
    import flash.filters.*;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;
    import mx.events.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.Shop;
    import model.Player;

    import view.scene.common.*;
    import view.image.common.*;
    import view.utils.*;

    import model.*;
    import controller.*;

    /**
     * ショップビューのビュークラス
     *
     */
    public class FriendListView extends UIComponent
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "最低";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "文字必要です";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "Please use at least ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = " characters.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "最少需要";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "個字";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "不少于";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "个字";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "최소 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = " 문자가 필요합니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Vous avez besoin de plus de ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = " lettres";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "最低";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "文字必要です";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "ตัวอักษรต้องไม่ต่ำกว่า";//"最低";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "ตัว";//"文字必要です";


        CONFIG::LOCALE_JP
        private static const _TRANS_INVITE	:String = "招待";

        CONFIG::LOCALE_EN
        private static const _TRANS_INVITE	:String = "Invite";

        CONFIG::LOCALE_TCN
        private static const _TRANS_INVITE	:String = "邀請";

        CONFIG::LOCALE_SCN
        private static const _TRANS_INVITE	:String = "邀请";

        CONFIG::LOCALE_KR
        private static const _TRANS_INVITE	:String = "초대";

        CONFIG::LOCALE_FR
        private static const _TRANS_INVITE	:String = "Invitation";

        CONFIG::LOCALE_ID
        private static const _TRANS_INVITE	:String = "招待";

        CONFIG::LOCALE_TH
        private static const _TRANS_INVITE  :String = "ชวนเพื่อน";


        CONFIG::LOCALE_JP
        private static const _TRANS_INVITE_CODE	:String = "招待コード";

        CONFIG::LOCALE_EN
        private static const _TRANS_INVITE_CODE	:String = "Invitation code";

        CONFIG::LOCALE_TCN
        private static const _TRANS_INVITE_CODE	:String = "邀請Code";

        CONFIG::LOCALE_SCN
        private static const _TRANS_INVITE_CODE	:String = "邀请Code";

        CONFIG::LOCALE_KR
        private static const _TRANS_INVITE_CODE	:String = "초대";

        CONFIG::LOCALE_FR
        private static const _TRANS_INVITE_CODE	:String = "InvitationCode";

        CONFIG::LOCALE_ID
        private static const _TRANS_INVITE_CODE	:String = "招待Code";

        CONFIG::LOCALE_TH
        private static const _TRANS_INVITE_CODE  :String = "ชวนเพื่อน code";



        CONFIG::LOCALE_JP
        private static const _TRANS_SEARCH	:String = "検索";

        CONFIG::LOCALE_EN
        private static const _TRANS_SEARCH	:String = "Search";

        CONFIG::LOCALE_TCN
        private static const _TRANS_SEARCH	:String = "搜索";

        CONFIG::LOCALE_SCN
        private static const _TRANS_SEARCH	:String = "搜索";

        CONFIG::LOCALE_KR
        private static const _TRANS_SEARCH	:String = "검색";

        CONFIG::LOCALE_FR
        private static const _TRANS_SEARCH	:String = "Rechercher";

        CONFIG::LOCALE_ID
        private static const _TRANS_SEARCH	:String = "検索";

        CONFIG::LOCALE_TH
        private static const _TRANS_SEARCH  :String = "ค้นหา";


        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_PRESENT	:String = "送る友達を選んでください";

        CONFIG::LOCALE_EN
        private static const _TRANS_PRESENT	:String = "Please choose the recipient of this gift.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_PRESENT	:String = "請選擇你要贈送任務禮物的朋友";

        CONFIG::LOCALE_SCN
        private static const _TRANS_PRESENT	:String = "请选择要赠送礼物的朋友";

        CONFIG::LOCALE_KR
        private static const _TRANS_PRESENT	:String = "送る友達を選んでください";

        CONFIG::LOCALE_FR
        private static const _TRANS_PRESENT	:String = "Choisissez l'ami auquel vous souhaitez envoyer ce cadeau.";

        CONFIG::LOCALE_ID
        private static const _TRANS_PRESENT	:String = "送る友達を選んでください";

        CONFIG::LOCALE_TH
        private static const _TRANS_PRESENT :String = "กรุณาเลือกชื่อเพื่อนที่จะส่งของขวัญให้";


        CONFIG::LOCALE_JP
        private static const _TRANS_SEARCHING	:String = "検索中";
        CONFIG::LOCALE_EN
        private static const _TRANS_SEARCHING	:String = "Searching";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SEARCHING	:String = "檢索中";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SEARCHING	:String = "检索中";
        CONFIG::LOCALE_KR
        private static const _TRANS_SEARCHING	:String = "検索中";
        CONFIG::LOCALE_FR
        private static const _TRANS_SEARCHING	:String = "Recherche";
        CONFIG::LOCALE_ID
        private static const _TRANS_SEARCHING	:String = "Searching";
        CONFIG::LOCALE_TH
        private static const _TRANS_SEARCHING   :String = "Searching";




        private static var __friendView:FriendListView;
//        private static var __friendButton:RmShopButton;
        private static var __enable:Boolean;

        private static var __updateEnable:Boolean = true;

        private static var __updatedTime:int = 0;
        private static var _UPDATE_INTERVAL:int = 5*60*1000; // 5分

        private static const _START_Y:int = -120;
        private static const _X:int = 125;
        private static const _Y:int = 150;

        // ロビーのコントローラ
        private var _lobbyCtrl:LobbyCtrl = LobbyCtrl.instance;

        private static var __type:int;
        private var _bg:FriendListImage = new FriendListImage();
        private var _inviteButton:FriendButton = new FriendButton(_TRANS_INVITE);
        private var _searchButton:FriendButton = new FriendButton(_TRANS_SEARCH);
        private var _inviteButton2:FriendButton = new FriendButton(_TRANS_INVITE_CODE);
        private var _invitePanel:NewInvitePanel = new NewInvitePanel();

        private var _searchText:TextInput = new TextInput();
        private var _beforeString:String = "";
        private var _presentLabel:Label = new Label();




//        private var _friendContainer:RmItemContainer = new RmItemContainer();
        private var _bgContainer:UIComponent = new UIComponent;
        private var _forContainer:UIComponent = new UIComponent;
        private var _loginStatusUpdateTimer:Timer;

        // 初期化（まっさきに先読みさせる）
        public static function initiData():void
        {
            if (__friendView == null){initView()}
        }


        // ショップビューを呼び出す
        public static function show():void
        {
            // 初期化されていない場合は作る
            if (__friendView == null){initView()}

            // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
            BetweenAS3.serial(
                BetweenAS3.addChild(__friendView, Unlight.INS.topContainer.parent),
                 BetweenAS3.to(__friendView,{y:_Y},0.3, Quad.easeOut)
                ).play();
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            __friendView.setFriendTabOnlyEnable(false);
            __enable = true;
            __friendView.timerStart();
            updateFriendInfo();
            __friendView._inviteButton.visible = true;
            __friendView._inviteButton2.visible = true;
            __friendView._presentLabel.visible = false;
                __friendView._inviteButton.visible = false;
                __friendView._inviteButton2.visible = false;
            __friendView._bg.tabReset();
            __friendView.tabHandeler(FriendListContainer.TAB_FRIEND);

        }


        // ショップビューを呼び出す
        public static function showSendQuest():void
        {
            // 初期化されていない場合は作る
            if (__friendView == null){initView()}

            // 作ったVIEWをトップビューに突っ込んで背景はクリックできなくする
            BetweenAS3.serial(
                BetweenAS3.addChild(__friendView, Unlight.INS.topContainer.parent),
                 BetweenAS3.to(__friendView,{y:_Y},0.3, Quad.easeOut)
                ).play();
//             Unlight.INS.topContainer.parent.addChild(__friendView);
            Unlight.INS.topContainer.mouseEnabled = false;
            Unlight.INS.topContainer.mouseChildren = false;
            __friendView.setFriendTabOnlyEnable(true);
            __enable = true;
            __friendView.timerStart();
//             LobbyCtrl.instance.requestFriendsInfo();
//             LobbyCtrl.instance.friendUpdate();
            updateFriendInfo();
            __friendView._inviteButton.visible = false;
            __friendView._presentLabel.visible = true;
        }


        private static function updateFriendInfo():void
        {
            var now:int = getTimer();
            if (__updateEnable && now-__updatedTime > _UPDATE_INTERVAL)
            {
                __updatedTime = now;
                // DataCtrl.instance.requestFriendsInfo();
                new WaitThread(3000,LobbyCtrl.instance.friendUpdate).start();
            }
        }



        public static function get enable():Boolean
        {
            return __enable;
        }

        public static function hide():void
        {

            LobbyCtrl.instance.achievementClearCheck();
            // 念のため最後にRMアイテムの更新をチェックする
//            LobbyCtrl.instance.realMoneyItemCheck(0)
//            log.writeLog(log.LV_FATAL, "static rmshopView", "hide++++");
            __friendView.timerStop();
//            RemoveChild.apply(__friendView);
            BetweenAS3.serial(
                BetweenAS3.tween(__friendView, {y:_START_Y}, null, 0.15, Sine.easeOut),
                BetweenAS3.removeFromParent(__friendView)
                ).play()
            Unlight.INS.topContainer.mouseEnabled = true;
            Unlight.INS.topContainer.mouseChildren = true;
            __enable = false;
            // チャットのブロックリストをリセットする
            FriendLink.clearBlockNameList();
        }

        private static function initView():void
        {
            __friendView = new FriendListView()
        }

        /**
         * コンストラクタ
         * @param stage 親ステージ
         */

        public function FriendListView()
        {
            //          log.writeLog(log.LV_FATAL, this, "+++++++++++++++++++++++++++++++++++++");
            _presentLabel.text = _TRANS_PRESENT;
            _presentLabel.x = 190;
            _presentLabel.y = 376;
            _presentLabel.height = 20;
            _presentLabel.width = 170;
            _presentLabel.styleName = "FriendButton";
            _presentLabel.filters = [new GlowFilter(0x0000000, 1, 2, 2, 16, 1),];

            x = _X;
            y = _START_Y;
            _bg.setCloseHandler(hide);
            _bg.setTabHandler(tabHandeler)
            _bg.getShowThread(this, 0).start();
            _bg.addChild(_inviteButton);
            _bg.addChild(_inviteButton2);
            _bg.addChild(_searchButton);
            _bg.addChild(_searchText);

            _bg.addChild(FriendListContainer.instance);
            _bg.addChild(_presentLabel);

            _inviteButton2.x = 280;
            _inviteButton2.y = 381;
            _inviteButton2.setClickHandler(_invitePanel.show);

            _searchButton.x = 280;
            _searchButton.y = 381;

            _searchButton.setClickHandler(searchHandler);
            _searchText.x = 170;
            _searchText.y = 381;
            _searchText.addEventListener(FlexEvent.ENTER,enterHandler);

            _searchText.width = 100;
            _searchText.height = 21;
            _searchText.maxChars = 12;
            _searchText.visible = false;
            _searchText.setStyle("focusThickness",  0);
            _searchButton.visible = false;

            _bg.setNextHandler(FriendListContainer.instance.nextPage);
            _bg.setPrevHandler(FriendListContainer.instance.prevPage);
            FriendListContainer.instance.setPageBtnVisibleFunc(pageBtnUpdate);
            _loginStatusUpdateTimer = new Timer(_UPDATE_INTERVAL,0)
            _loginStatusUpdateTimer.addEventListener(TimerEvent.TIMER, updateHandler);
        }

        private function tabHandeler(tabType:int):void
        {
            // サーチ中はアップデートしない
            if (tabType == FriendListContainer.TAB_SEARCH)
            {
                __updateEnable = false;
                if (_searchText.text == "")
                {
                    FriendLink.clearSeachResult();
                    FriendListContainer.update();
                }
                _searchText.visible = true;
                _searchButton.visible = true;
                // _inviteButton.visible = false;
                // _inviteButton2.visible = false;
                inviteButtonVisible = false;
                FriendListContainer.instance.resetPage();
            }else{
                __updateEnable = true;
                _searchText.text = "";
                _beforeString = "";
                _searchText.visible = false;
                _searchButton.visible = false;
                // _inviteButton.visible = true;
                // _inviteButton2.visible = true;
                inviteButtonVisible = true;
            }
            FriendListContainer.instance.setTab(tabType);
        }

        private function set inviteButtonVisible(f:Boolean):void
        {
            _inviteButton.visible = f;
            _inviteButton2.visible = f;
        }

        private function searchHandler():void
        {
            if (_searchText.text != "" && _beforeString != _searchText.text)
            {

                if (_searchText.text.length < Const.NAME_MIN)
                {
                    Alerter.showWithSize(_TRANS_MSG1+Const.NAME_MIN.toString()+_TRANS_MSG2, 'Error', 4, null, null);
                }else{
                    DataCtrl.instance.searchAvatar(_searchText.text);
                    _beforeString = _searchText.text;
                    _searchText.text = _TRANS_SEARCHING;
                    _searchText.enabled = false;
                }
            }
        }

        public static function searchEnd():void
        {
            if (__friendView._searchText != null)
            {
                __friendView._searchText.text = __friendView._beforeString;;
                __friendView._searchText.enabled = true;
            }
        }


         private  function enterHandler(e:Event):void
         {
             searchHandler();
         }


        private function updateHandler(e:TimerEvent):void
        {
            FriendListView.updateFriendInfo()
        }

        public function timerStop():void
        {
            _loginStatusUpdateTimer.stop();
        }

        public function timerStart():void
        {
            _loginStatusUpdateTimer.start();
        }

        public function setFriendTabOnlyEnable(b:Boolean):void
        {
            FriendListContainer.presentMode = b;
            _bg.setTabEnableFriedOnly(b);
            inviteButtonVisible = (b) ? false : true;
        }
//         public function get closeButton():UIComponent
//         {
//             return _shopPanel.closeButton;
//         }

        private function pageBtnUpdate(next:Boolean,prev:Boolean):void
        {
            if (_bg) {
                _bg.nextVisible = next;
                _bg.prevVisible = prev;
            }
        }
    }
}
