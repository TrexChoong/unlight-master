package controller
{
    import flash.events.*;
    import flash.utils.Timer;

    import mx.controls.Alert;

    import sound.bgm.LobbyBGM;
    import sound.bgm.TitleBGM;
    import sound.se.*;
    import sound.BaseSound;

    import net.server.*;
    import net.*;

    import model.*;
    import model.events.*;
    import view.*;
    import view.LobbyView;
    import view.image.common.FriendListButton;
    import view.scene.common.*;

    /**
     * ロビー画面コントロールクラス
     *
     */
    public class LobbyCtrl extends BaseCtrl
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS	:String = "ロビー";

        CONFIG::LOCALE_EN
        private static const _TRANS	:String = "Lobby";

        CONFIG::LOCALE_TCN
        private static const _TRANS	:String = "大廳";

        CONFIG::LOCALE_SCN
        private static const _TRANS	:String = "大厅";

        CONFIG::LOCALE_KR
        private static const _TRANS	:String = "로비";

        CONFIG::LOCALE_FR
        private static const _TRANS	:String = "Hall";

        CONFIG::LOCALE_ID
        private static const _TRANS	:String = "ロビー";

        CONFIG::LOCALE_TH
        private static const _TRANS :String = "ห้องรับรอง";

        CONFIG::LOCALE_JP
        private static const _TRANS_SERIAL_MSG:String = "シリアル番号の入力に成功しました。__ITEM__を取得";

        CONFIG::LOCALE_EN
        private static const _TRANS_SERIAL_MSG:String = "Get __ITEM__";

        CONFIG::LOCALE_TCN
        private static const _TRANS_SERIAL_MSG:String = "虛擬寶物序號輸入成功。您獲得__ITEM__";

        CONFIG::LOCALE_SCN
        private static const _TRANS_SERIAL_MSG:String = "序列号输入成功。您获得__ITEM__";

        CONFIG::LOCALE_KR
        private static const _TRANS_SERIAL_MSG:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_SERIAL_MSG:String = "Get __ITEM__";

        CONFIG::LOCALE_ID
        private static const _TRANS_SERIAL_MSG:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_SERIAL_MSG:String = "ได้รับ__ITEM__";

        CONFIG::LOCALE_JP
        private static const _TRANS_INFECTION_SERIAL_MSG:String = "Infectionコラボシリアル入力成功！__ITEM__を取得しました!";

        CONFIG::LOCALE_EN
        private static const _TRANS_INFECTION_SERIAL_MSG:String = "Successfully entered your serial number obtained in the Infection Collaboration Event. Collected __ITEM__!";

        CONFIG::LOCALE_TCN
        private static const _TRANS_INFECTION_SERIAL_MSG:String = "與Infection合作的序號輸入成功！得到__ITEM__了！";

        CONFIG::LOCALE_SCN
        private static const _TRANS_INFECTION_SERIAL_MSG:String = "与Infection合作的序列号输入成功！得到__ITEM__了！";

        CONFIG::LOCALE_KR
        private static const _TRANS_INFECTION_SERIAL_MSG:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_INFECTION_SERIAL_MSG:String = "Réussite de la collaboration avec le jeu Infection. Vous recevez l'objet suivant : __ITEM__.";

        CONFIG::LOCALE_ID
        private static const _TRANS_INFECTION_SERIAL_MSG:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_INFECTION_SERIAL_MSG:String = ""; // Infectionコラボシリアル入力成功！__ITEM__を取得しました!

        CONFIG::LOCALE_JP
        private static const _TRANS_CLAMPS_CLICK_MSG:String = "クランプスクリック入力成功！__ITEM__を取得しました！";

        CONFIG::LOCALE_EN
        private static const _TRANS_CLAMPS_CLICK_MSG:String = "Vous réussissez le Cramps Click ! Vous obtenez __ITEM__ !";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CLAMPS_CLICK_MSG:String = "點擊羊角獸成功！得到　__ITEM__！";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CLAMPS_CLICK_MSG:String = "点击羊角兽成功！得到　__ITEM__！";

        CONFIG::LOCALE_KR
        private static const _TRANS_CLAMPS_CLICK_MSG:String = "クランプスクリック入力成功！__ITEM__を取得しました!";

        CONFIG::LOCALE_FR
        private static const _TRANS_CLAMPS_CLICK_MSG:String = "Vous réussissez le Cramps Click ! Vous obtenez __ITEM__ !";

        CONFIG::LOCALE_ID
        private static const _TRANS_CLAMPS_CLICK_MSG:String = "クランプスクリック入力成功！__ITEM__を取得しました!";

        CONFIG::LOCALE_TH
        private static const _TRANS_CLAMPS_CLICK_MSG:String = "クランプスクリック入力成功！__ITEM__を取得しました!";

        CONFIG::LOCALE_JP
        private static const _TRANS_CLAMPS_CLICK_ERROR_MSG:String = "クランプスは胡乱な目で見つめている。";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CLAMPS_CLICK_ERROR_MSG:String = "羊角獸用可疑的眼神注視著你。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CLAMPS_CLICK_ERROR_MSG:String = "羊角兽用可疑的眼神注视着你。";

        CONFIG::LOCALE_KR
        private static const _TRANS_CLAMPS_CLICK_ERROR_MSG:String = "クランプスは胡乱な目で見つめている。";

        CONFIG::LOCALE_FR
        private static const _TRANS_CLAMPS_CLICK_ERROR_MSG:String = "Le Cramps vous regarde d'un air nonchalant.";

        CONFIG::LOCALE_EN
        private static const _TRANS_CLAMPS_CLICK_ERROR_MSG:String = "Cramps are staring at a uronic eye.";

        CONFIG::LOCALE_ID
        private static const _TRANS_CLAMPS_CLICK_ERROR_MSG:String = "クランプスは胡乱な目で見つめている。";

        CONFIG::LOCALE_TH
        private static const _TRANS_CLAMPS_CLICK_ERROR_MSG:String = "クランプスは胡乱な目で見つめている。";



        protected static var __instance:LobbyCtrl; // シングルトン保存用

        private var _server:LobbyServer;
        private var _view:LobbyView;

//        private var _bgm:LobbyBGM = new LobbyBGM();
        private var _bgm:LobbyBGM;
        private var _storyBgm:LobbyBGM;
        private var _registBgm:TitleBGM = new TitleBGM();

        private var _bgmPlaying:Boolean = false;
        private var _storyBgmPlaying:Boolean = false;
        private var _registBgmPlaying:Boolean = false;

        private var _player:Player = Player.instance;
        private var _connected:Boolean = false;        // Serverにコネクトしているか？

        private var _updateEnable:Boolean = true;

        private var _charaInvUpdating:Boolean = false;
        private var _slotInvUpdating:Boolean = false;

        private var _nameCheckErrCode:int = Avatar.NAME_INPUT_SUCCESS;

        public static const CHECK_NAME_SUCCESS:String = "check_name_success";
        public static const CHECK_NAME_FAILED:String = "check_name_failed";
        public static const REQUEST_COPY_CARD:String = "request_copy_card";
        public static const RARE_CARD_GET_EVENT_FINISH:String = "rare_card_get_event_finish";
        public static const CHANGE_FAVORITE_CHARA:String = "change_favorite_chara";
        public static const CLAMPS_APPEAR:String = "clamps_appear";

        // 再生するBGMのID
        public static const BGM_ID_LOBBY:int    = 0;
        public static const BGM_ID_TUTORIAL:int = 1;
        public static const BGM_ID_LOT:int      = 2;
        public static const BGM_ID_STORY:int    = 3;

        public function LobbyCtrl(caller:Function=null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            // ロビーサーバを登録
            _server = LobbyServer.instance;
            init();
        }

        private static function createInstance():LobbyCtrl
        {
            return new LobbyCtrl(arguments.callee);
        }

        public static function get instance():LobbyCtrl
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        protected override function get server():Server
        {
           return  _server;
        }

        /**
         * ロビーのスタート
         *
         */
        public function start(view:LobbyView):void
        {
            // ロビーサーバにつなぐ
            _server.connect();
            _view = view;
            waitConnectThread.start();
            Quest.getBlankQuest(); // ブランクだけは速攻で作る
            ActionCard.getBlankCard(); // ブランクカードだけは速攻で作る
            CharaCard.getBlankCard(); // ブランクカードだけは速攻で作る
            QuestLand.getBlankLand(); // ブランクだけは速攻で作る
        }

        // connecetwaitスレッドが使うスタートコマンド
        public override function waitStart():void
        {
            log.writeLog(log.LV_FATAL, this, "start", _server.state);
            _server.start(this);

        }

        protected override function get serverName():String
        {
//            return "ロビー";
            return _TRANS;
        }


        public  function alertEnable(b:Boolean):void
        {
            LobbyServer.alertEnable(b);
        }



//         // サーバ切断時イベントハンドラ
//         protected override function getServerDisconnectedHandler(evt:Event):void
//         {
//             log.writeLog (log.LV_FATAL,this,"Server Disconnected");
// //             server.removeEventListener(Server.DISCONNECT,getServerDisconnectedHandler); // 切断時
// //             connected = false;
// //             BaseCtrl.alarted = true;
// //             log.writeLog (log.LV_FATAL,this,"Alarted?",BaseCtrl.alarted);
// //             Alerter.showWithSize('サーバから切断されました。リロードをお願いします', 'Error', 4, null, Alerter.reloadWindow);

//         }


        // ロビーニュースの更新
        public function setNews(news:String):void
        {
//            _view.lobbyInfo(news);
        }

        public function registAvatar(name:String, parts:Array, cards:Array):void
        {
//            log.writeLog(log.LV_FATAL, this, "AVATAR REGIST",name,parts,cards );

            _server.csCreateAvatar(name, parts, cards);
        }

        public function checkAvatarName(name:String):void
        {
            _server.csCheckAvatarName(name);
        }

        // 名前登録に成功したとき
        public function checkNameSuccess():void
        {
            dispatchEvent(new Event(CHECK_NAME_SUCCESS));
        }

        // 名前登録に失敗したとき
        public function checkNameFailed(code:int):void
        {
            _nameCheckErrCode = code;
            dispatchEvent(new Event(CHECK_NAME_FAILED));
        }
        public function get nameChackErrCode():int
        {
            return _nameCheckErrCode;
        }


        public function playBGM(selBgm:int = BGM_ID_LOBBY):void
        {
            if (_bgmPlaying)
            {
                return;
            }else{
                if ( _bgm != null ) {
                    if ( _bgm.isSetChannel() ) {
                        _bgm.stopSound();
                        _bgm.removeCurrentChannel();
                    }
                    _bgm = null;
                }
                _bgm = new LobbyBGM(selBgm);
                _bgm.loopSound(0);
                _bgmPlaying = true;
            }

        }

        public function stopBGM(k:int=2):void
        {
            if ( _bgm != null ) _bgm.fade(0,k);
            _bgmPlaying = false;
        }

        public function playStoryBGM():void
        {
            if (_storyBgmPlaying)
            {
                return;
            }else{
                if ( _storyBgm != null ) {
                    if ( _storyBgm.isSetChannel() ) {
                        _storyBgm.stopSound();
                        _storyBgm.removeCurrentChannel();
                    }
                    _storyBgm = null;
                }
                _storyBgm = new LobbyBGM(BGM_ID_STORY);
                _storyBgm.loopSound(0);
                _storyBgmPlaying = true;
            }

        }

        public function stopStoryBGM(k:int=2):void
        {
            if ( _storyBgm != null ) _storyBgm.fade(0,k);
            _storyBgmPlaying = false;
        }

        public function playRegistBGM():void
        {
            if (_registBgmPlaying)
            {
                return;
            }else{
                _registBgm.loopSound(0);
                _registBgmPlaying = true;
            }

        }

        public function stopRegistBGM():void
        {
            _registBgm.fade(0,2);
            _registBgmPlaying = false;
        }

        // 使用した時
        override public function sendItem(id:int):void
        {
            _server.csAvatarUseItem(id);
        }

        // 使用した時
        override public function buyItem(shop:int, id:int, amount:int=1):void
        {
            _server.csAvatarBuyItem(shop,id,amount);
        }

        // スロットカードを買う
        public function buySlotCard(shop:int, kind:int, id:int, amount:int=1):void
        {
            _server.csAvatarBuySlotCard(shop, kind, id, amount);
        }

        // キャラカードを買う
        public function buyCharaCard(shop:int, id:int, amount:int=1):void
        {
            _server.csAvatarBuyCharaCard(shop, id, amount);
        }

        // キャラカードを買う
        public function buyPart(shop:int, id:int):void
        {
            _server.csAvatarBuyPart(shop, id);
        }

        // 使用した時
        public function setPart(id:int):void
        {
            _server.csSetAvatarPart(id);
        }
        // 外した
        public function removePart(id:int):void
        {
            _server.csSetAvatarPart(id);
        }

        // リアルマネーアイテム購入チェック
        public function realMoneyItemCheck(id:int):void
        {
            if (connected)
            {
                _server.csRealMoneyItemResultCheck(id);
            }
        }



        public function friendUpdate():void
        {
            FriendListContainer.update();
            FriendListButton.updateAlert();
        }

        public function friendDelete(id:int):void
        {
//                log.writeLog(log.LV_WARN, this, "cs friedexits", uid);
            if (connected)
            {
                _server.csFriendDelete(id);
            }

        }


        public function friendApply(id:int):void
        {
//                log.writeLog(log.LV_WARN, this, "cs friedexits", uid);
            if (connected)
            {
                _server.csFriendApply(id);
            }

        }
        public function friendConfirm(id:int):void
        {
//                log.writeLog(log.LV_WARN, this, "cs friedexits", uid);
            if (connected)
            {
                _server.csFriendConfirm(id);
            }

        }
        public function blockApply(id:int):void
        {
//                log.writeLog(log.LV_WARN, this, "cs friedexits", uid);
            if (connected)
            {
                _server.csBlockApply(id);
            }

        }


        public function equipPartsSucc(invID:int, unuseIDs:String,endAt:int,status:int):void
        {
            log.writeLog(log.LV_FATAL, this, "!!! equip parts succcc", invID,unuseIDs, endAt, status);
            AvatarPartInventory.equipPartsSucc(invID,unuseIDs,endAt,status);
            dispatchEvent(new AvatarPartEvent(AvatarPartEvent.EQUIP_PART, invID));
            AvatarView.getPlayerAvatar(AvatarView.CURRENT_TYPE).partsUpdate();
        }

        public function partsVanish(invID:int):void
        {
            var partID:int = AvatarPartInventory.ID(invID).avatarPart.id;
            AvatarPartInventory.vanish(invID);
            dispatchEvent(new AvatarPartEvent(AvatarPartEvent.VANISH_PART, partID));
        }

        // パーツの期限が来てないかチェック
        public function partsVanishCheck():void
        {
            if (connected)
            {
                _server.csPartsVanishCheck();
            }
        }
        public function achievementClearCheck(noticeCheck:Boolean=true):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "ACHICACAachie");
                _server.csAchievementClearCheck(noticeCheck);
            }
        }
        // パーツを捨てる
        public function partDrop(invID:int):void
        {
            if (connected)
            {
            _server.csPartDrop(invID);
            }
        }

        public function clearNotice(n:int,args:Array = null):void
        {
            if (connected)
            {
                if(args == null){args=[]};
                log.writeLog(log.LV_FATAL, this, "ClearNotice");
                _server.csNoticeClear(n,args.join(","));
            }
        }

        // アイテムの使用に成功したとき
        public function useItemSuccess(id:int):void
        {
            dispatchEvent(new AvatarItemEvent(AvatarItemEvent.USE_ITEM, id));
        }

        public function getItemSuccess(id:int):void
        {
            dispatchEvent(new AvatarItemEvent(AvatarItemEvent.GET_ITEM, id));
        }


        // 取得に成功したとき
        public function getCharaCardSuccess(id:int):void
        {
            // レアカード判定
            if(id <= 1000&&(id%10)>5)
            {
                Feed.clientAcitivityUpdateRareCard(id);
            }
            dispatchEvent(new CharaCardEvent(CharaCardEvent.GET_CHARA_CARD, id));
        }

        // 取得に成功したとき
        public function getEquipCardSuccess(id:int):void
        {
            dispatchEvent(new SlotCardEvent(SlotCardEvent.GET_EQUIP_CARD, id));
        }

        // 取得に成功したとき
        public function getWeaponCardSuccess(id:int):void
        {
            dispatchEvent(new SlotCardEvent(SlotCardEvent.GET_WEAPON_CARD, id));
        }

        // 取得に成功したとき
        public function getEventCardSuccess(id:int):void
        {
            dispatchEvent(new SlotCardEvent(SlotCardEvent.GET_EVENT_CARD, id));
        }

        // 取得に成功したとき
        public function getPartsSuccess(id:int):void
        {
            dispatchEvent(new AvatarPartEvent(AvatarPartEvent.GET_PART, id));
        }

        // レアカードくじをゲット
        public function gotRareCard(lotCardKind:int, lotCardID:int, lotCardNum:int, blankCard1Kind:int, blankCard1ID:int, blank1Num:int, blankCard2Kind:int, blankCard2ID:int, blank2Num:int):void
        {
            dispatchEvent(new DrawLotEvent(DrawLotEvent.SUCCESS,
                                           lotCardKind,
                                           lotCardID,
                                           lotCardNum,
                                           blankCard1Kind,
                                           blankCard1ID,
                                           blank1Num,
                                           blankCard2Kind,
                                           blankCard2ID,
                                           blank2Num));
        }

        // レアカード演出終了
        public function rareCardEventFinish():void
        {
            dispatchEvent(new Event(RARE_CARD_GET_EVENT_FINISH));
        }

        // レアカードくじを引く
        public function drawRareCardLot(kind:int = 0):void
        {
            if (connected)
            {
                _server.csDrawLot(kind);
            }
        }

        // カードをコピー
        public function requestCopyCard():void
        {
            dispatchEvent(new Event(REQUEST_COPY_CARD));
        }

        // カードをコピーする
        public function copyCard(id:int = 0):void
        {
            if (connected)
            {
                _server.csCopyCard(id);
            }
        }
        // カード複製に成功
        public function copyCardSuccess(id:int):void
        {
            dispatchEvent(new CharaCardEvent(CharaCardEvent.COPY_CHARA_CARD, id));
        }

        // アバターのアップデートをチェック
        public function avatarUpdateCheck():void
        {
            if (connected&&_updateEnable)
            {
                _server.csAvatarUpdateCheck();
                _updateEnable = false;
                new WaitThread(2000, enableAvatarUpdate).start();
            }
        }
        private function enableAvatarUpdate():void
        {
            _updateEnable = true;
        }

        public function updateSaleRestTime():void
        {
            _server.csRequestSaleLimitInfo();
        }
        public function saleFinishCheck():void
        {
            // セール時間の更新
            _server.csRequestSaleLimitInfo();
        }
        public function updateAchievementInfo():void
        {
            // アチーブメント情報の更新
            _server.csRequestAchievementInfo();
        }

        public function newProfoundInventoryCheck():void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "new  ProfoundInventoryCheck");
                _server.csNewProfoundInventoryCheck();
            }
        }

        public function changeFavoriteCharaId(charaId:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_DEBUG, this, "changeFavoriteCharaId",charaId);
                _server.csChangeFavoriteCharaId(charaId);
            }
        }

        public function changeResultImage(charaId:int,imageNo:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_DEBUG, this, "changeResultImage",charaId);
                _server.csChangeResultImage(charaId,imageNo);
            }
        }

        public function changeFavoriteChara(charaId:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "changeFavoriteChara",charaId);
            if (Player.instance && Player.instance.avatar) {
                Player.instance.avatar.favoriteCharaId = charaId;
                dispatchEvent(new Event(CHANGE_FAVORITE_CHARA));
            }
        }

        public function startLobbyTalk():void
        {
            if (connected)
            {
                log.writeLog(log.LV_DEBUG, this, "startLobbyTalk");
                _server.csLobbyCharaDialogueStart();
            }
        }

        public function dialogueMessage(lines:String):void
        {
            // log.writeLog(log.LV_DEBUG, this, "changeFavoriteChara",charaId);
            // if (Player.instance && Player.instance.avatar) {
            //     dispatchEvent(new Event(CHANGE_FAVORITE_CHARA));
            // }
        }


//         // チャンネル情報を要求
//         public function requestChannelInfo():void
//         {
//             if (connected)
//             {
//                 _server.csRequestChannelListInfo();
//             }
//         }

        // 課金ショップ情報を要求
        public function requestRealMoneyItemInfo():void
        {
            RealMoneyItem.initData();
            RealMoneyItem.inited = true;
        }

        // 課金ショップ情報を要求
        public function serialCodeSend(serial:String, pass:String):void
        {
            if (connected)
            {
                _server.csEventSerialCode(serial,pass);
            }
        }
        // 課金ショップ情報を要求
        public function serialCodeSuccess(itemInfo:String):void
        {
            var str:String = _TRANS_SERIAL_MSG.replace("__ITEM__", itemInfo)
	    Alerter.showWithSize(str, "Info");
        }
        public function infectionCollaboSerialSend(serial:String):void
        {
            if (connected)
            {
                _server.csInfectionCollaboSerialCode(serial);
            }
        }
        public function infectionCollaboSerialSuccess(itemInfo:String):void
        {
            log.writeLog(log.LV_DEBUG, this, "infectionCollaboSerialSuccess ",itemInfo);
            var str:String = _TRANS_INFECTION_SERIAL_MSG.replace("__ITEM__", itemInfo)
            Alerter.showWithSize(str, "Info");
        }
        public function clampsClick():void
        {
            if (connected)
            {
                _server.csClampsClick();
            }
        }
        public function clampsAppearCheck():void
        {
            if (connected)
            {
                _server.csClampsAppearCheck();
            }
        }
        public function clampsAppear():void
        {
            dispatchEvent(new Event(CLAMPS_APPEAR));
        }

        public function clampsClickSuccess(itemInfo:String):void
        {
            var str:String;
            if (itemInfo == "ERROR")
            {
                // 通常の操作ではここには到達しない
                str = _TRANS_CLAMPS_CLICK_ERROR_MSG;
            }
            else
            {
                log.writeLog(log.LV_DEBUG, this, "clamps click succes ",itemInfo);
                str = _TRANS_CLAMPS_CLICK_MSG.replace("__ITEM__", itemInfo);
            }
            Alerter.showWithSize(str, "Info");
        }

        // Noticeでの選択アイテムを取得
        public function getNoticeSelectableItem(args:Array):void
        {
            if (connected)
            {
                _server.csGetNoticeSelectableItem(args.join(","));
            }
        }

        public function profoundNoticeClear(n:int):void
        {
            if (connected)
            {
                log.writeLog(log.LV_FATAL, this, "profoundNoticeClear");
                _server.csProfoundNoticeClear(n);
            }
        }

        public function set charaInvUpdating(f:Boolean):void
        {
            _charaInvUpdating = f;
        }
        public function set slotInvUpdating(f:Boolean):void
        {
            _slotInvUpdating = f;
        }
        public function get cardInvUpdating():Boolean
        {
            return (_charaInvUpdating||_slotInvUpdating);
        }

        public override function get connected():Boolean
        {
            return (_server.host.serverState() == Host.CONNECT_AUTHED);
        }

        public override function set connected(b:Boolean):void
        {
             _connected = b;
        }

        public function restart():void
        {
            if (!connected)
            {
                _server.connect();
                waitConnectThread.start();
            }
        }

        // サーバ切断時イベントハンドラ
        protected override function getServerDisconnectedHandler(evt:Event):void
        {
            _server.connect();
//            waitConnectThread.start();

//            _view.interrupt();
//            super.getServerDisconnectedHandler(evt);
//            Unlight.isLogin = false;
//            _player.state = Player.STATE_LOGOUT;
//             // 他のサーバも問答無用でたたきおとす
//             GameCtrl.instance.exit();
//             ChatCtrl.instance.exit();

        }

        // アラートの多重起動を防ぐハンドラ
        protected override function logoutAlertOffHandler(event:Event):void
        {
            BaseCtrl.alarted = false;
//            _view.interrupt();
        }

        public function deckMaxCheck():void
        {
            _server.csDeckMaxCheck();
        }

        public function deckMaxCheckResult(ok:Boolean):void
        {
            log.writeLog(log.LV_DEBUG, this, "deck max 応答", ok);
            dispatchEvent(new DeckMaxCheckEvent(DeckMaxCheckEvent.RESULT, ok));
        }

    }
}