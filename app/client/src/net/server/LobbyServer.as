package net.server
{
    import flash.events.Event;
    import flash.utils.Dictionary;
    import net.*;
    import net.command.*;
    import model.*;
    import model.utils.Cache;
    import model.utils.ClientLog;
    import model.events.*;
    import controller.LobbyCtrl;
    import view.*;
    import view.utils.*;


    /**
     * ロビーサーバからの通信を扱うクラス
     *
     */
    public class LobbyServer extends Server
    {
        private var _command:LobbyCommand;
        private var _crypted_sign:String;
        private var _ctrl:LobbyCtrl;
        private var _edit:DeckEditor;
        private var _growth:Growth;
        private var _combine:Combine;

        private static var __instance:LobbyServer;

        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_GET		:String = "を獲得しました。";
        CONFIG::LOCALE_JP
        private static const _TRANS_INFO	:String = "情報";
        CONFIG::LOCALE_JP
        private static const _TRANS_USE		:String = "を使用しました。";
        CONFIG::LOCALE_JP
        private static const _TRANS_FINISH_A	:String = "";
        CONFIG::LOCALE_JP
        private static const _TRANS_FINISH_B	:String = "の効果時間が終了したため失われました";
        CONFIG::LOCALE_JP
        private static const _TRANS_COPY	:String = "カードの複製に成功しました。";
        CONFIG::LOCALE_JP
        private static const _TRANS_SYNTHESIZE_A	:String = "合成結果";
        CONFIG::LOCALE_JP
        private static const _TRANS_SYNTHESIZE_B	:String = "合成できませんでした";

        CONFIG::LOCALE_EN
        private static const _TRANS_GET		:String = "You received ";
        CONFIG::LOCALE_EN
        private static const _TRANS_INFO	:String = "Information";
        CONFIG::LOCALE_EN
        private static const _TRANS_USE		:String = "You used ";
        CONFIG::LOCALE_EN
        private static const _TRANS_FINISH_A	:String = "You have lost ";
        CONFIG::LOCALE_EN
        private static const _TRANS_FINISH_B	:String = " because the effect has elapsed.";
        CONFIG::LOCALE_EN
        private static const _TRANS_COPY	:String = "Successfully copied card.";
        CONFIG::LOCALE_EN
        private static const _TRANS_SYNTHESIZE_A	:String = "合成結果";
        CONFIG::LOCALE_EN
        private static const _TRANS_SYNTHESIZE_B	:String = "合成できませんでした";

        CONFIG::LOCALE_TCN
        private static const _TRANS_GET	:String = "獲得了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_INFO	:String = "訊息";
        CONFIG::LOCALE_TCN
        private static const _TRANS_USE		:String = "使用了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_FINISH_A	:String = "效果時間結束，";
        CONFIG::LOCALE_TCN
        private static const _TRANS_FINISH_B	:String = "的效果消失了";
        CONFIG::LOCALE_TCN
        private static const _TRANS_COPY	:String = "已成功複製卡片。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SYNTHESIZE_A	:String = "合成結果";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SYNTHESIZE_B	:String = "合成失敗";

        CONFIG::LOCALE_SCN
        private static const _TRANS_GET		:String = "已获得";
        CONFIG::LOCALE_SCN
        private static const _TRANS_INFO	:String = "信息";
        CONFIG::LOCALE_SCN
        private static const _TRANS_USE		:String = "已使用";
        CONFIG::LOCALE_SCN
        private static const _TRANS_FINISH_A	:String = "有效时间到期，失去";
        CONFIG::LOCALE_SCN
        private static const _TRANS_FINISH_B	:String = "";
        CONFIG::LOCALE_SCN
        private static const _TRANS_COPY	:String = "成功复制卡片。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SYNTHESIZE_A	:String = "合成结果";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SYNTHESIZE_B	:String = "合成失败";

        CONFIG::LOCALE_KR
        private static const _TRANS_GET:String = "를 획득하였습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_INFO:String = "정보";
        CONFIG::LOCALE_KR
        private static const _TRANS_USE		:String = "을(를) 사용했습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_FINISH_A	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_FINISH_B	:String = "の効果時間が終了したため失われました";
        CONFIG::LOCALE_KR
        private static const _TRANS_COPY	:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_SYNTHESIZE_A	:String = "合成結果";
        CONFIG::LOCALE_KR
        private static const _TRANS_SYNTHESIZE_B	:String = "合成できませんでした";

        CONFIG::LOCALE_FR
        private static const _TRANS_GET		:String = "Vous recevez ";
        CONFIG::LOCALE_FR
        private static const _TRANS_INFO	:String = "Information";
        CONFIG::LOCALE_FR
        private static const _TRANS_USE		:String = "Vous avez utilisé ";
        CONFIG::LOCALE_FR
        private static const _TRANS_FINISH_A	:String = "Le temps de l'effet est terminé. ";
        CONFIG::LOCALE_FR
        private static const _TRANS_FINISH_B	:String = " est invalide.";
        CONFIG::LOCALE_FR
        private static const _TRANS_COPY	:String = "Vous avez réussi de copier la carte.";
        CONFIG::LOCALE_FR
        private static const _TRANS_SYNTHESIZE_A	:String = "Résultat de la synthèse";
        CONFIG::LOCALE_FR
        private static const _TRANS_SYNTHESIZE_B	:String = "La synthèse a échoué";

        CONFIG::LOCALE_ID
        private static const _TRANS_GET		:String = "を獲得しました。";
        CONFIG::LOCALE_ID
        private static const _TRANS_INFO	:String = "情報";
        CONFIG::LOCALE_ID
        private static const _TRANS_USE		:String = "を使用しました。";
        CONFIG::LOCALE_ID
        private static const _TRANS_FINISH_A	:String = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_FINISH_B	:String = "の効果時間が終了したため失われました";
        CONFIG::LOCALE_ID
        private static const _TRANS_COPY	:String = "カードの複製に成功しました。";
        CONFIG::LOCALE_ID
        private static const _TRANS_SYNTHESIZE_A	:String = "合成結果";
        CONFIG::LOCALE_ID
        private static const _TRANS_SYNTHESIZE_B	:String = "合成できませんでした";

        CONFIG::LOCALE_TH
        private static const _TRANS_GET     :String = "ได้รับ";
        CONFIG::LOCALE_TH
        private static const _TRANS_INFO    :String = "ข้อมูล";
        CONFIG::LOCALE_TH
        private static const _TRANS_USE     :String = "ใช";
        CONFIG::LOCALE_TH
        private static const _TRANS_FINISH_A    :String = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_FINISH_B    :String = "หายไปเนื่องจากหมดเวลาการใช้งาน";//"の効果時間が終了したため失われました";
        CONFIG::LOCALE_TH
        private static const _TRANS_COPY    :String = "การจำลองการ์ดสำเร็จแล้ว";
        CONFIG::LOCALE_TH
        private static const _TRANS_SYNTHESIZE_A	:String = "合成結果";
        CONFIG::LOCALE_TH
        private static const _TRANS_SYNTHESIZE_B	:String = "合成できませんでした";

        // アラートを出すか
        private static var __alertOn:Boolean = true;

        // 初期化 サーバを取得
        public function LobbyServer(caller:Function = null)
        {
             if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
             _command = new LobbyCommand(this);
             Shop.setLoaderFunc(getShopInfo);
        }
        public static function alertEnable(b:Boolean):void
        {
            __alertOn = b;
        }

        private static function createInstance():LobbyServer
        {
            return new LobbyServer(arguments.callee);
        }

        public static function get instance():LobbyServer
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        // コンフィグからのロード
        protected override function configLoad():void
        {
            log.writeLog(log.LV_INFO, this,"configload");
            address = Config.lobbyServerInfo.address;
            port = Config.lobbyServerInfo.port;
            CONFIG::DEBUG
            {
                Unlight.INS.updateSeverInfo("","LS["+address+":"+port.toString()+"]");
            }

        }

        // コマンドの登録
        protected override function get command():Command
        {
            return _command;
        }

        /**
         * サーバのスタート
         *
         */
        public function start(ctrl:LobbyCtrl):void
        {
            _ctrl= ctrl
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"lobby p_session", player.session);
            host.setSessionKey(player.session);
        }


        // 終了
        public override function exit():void
        {
            host.sendCommand(_command.logout());
            super.exit();
        }

        // オーバライド前提のHeartBeatHandler
        protected override function heartBeatHandler(e:Event):void
        {
            host.sendCommand(_command.csKeepAlive());
        }

        /**
         * 送信コマンド
         *
         */

        // アバターを作成する
        public function csCreateAvatar(name:String, parts:Array, cards:Array):void
        {
            log.writeLog(log.LV_INFO, this, "cs CreateAvatar inviteid",Player.instance.invitedPID);
            host.sendCommand(_command.csCreateAvatar(name, parts.join(","), cards.join(","), Player.instance.invitedPID));
        }

        // アバターの名前
        public function csCheckAvatarName(name:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs CheckAvatarName");
            host.sendCommand(_command.csCheckAvatarName(name));
        }

        // 合成可能かを調べる
        public function getExchangebleInfo(e:ExchangeEvent):void
        {
            log.writeLog(log.LV_INFO, this, "exchange info request");
            host.sendCommand(_command.csRequestExchangeableInfo(e.id, e.cid));
        }
        // 指定したIDのアバターパーツを取得する
        public function getShopInfo(id:int):void
        {
            log.writeLog(log.LV_INFO, this,"shop info request");
            host.sendCommand(_command.csRequestShopInfo(id));
        }

        public function updateCharaCardInventoryHandler(e:EditCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"cs charaCardInv update", e.cci.inventoryID, e.cci.index, e.cci.position, e.cci.cardId);
            var position:int = e.cci.position;
            // -1の場合、クライアント側のBinder移動処理の影響のみなので、0に戻す
            if (position < 0) {
                position = 0;
            }
            _ctrl.charaInvUpdating = true;
            host.sendCommand(_command.csUpdateCardInventoryInfo(e.cci.inventoryID, e.cci.index, position));
        }

        public function updateWeaponCardInventoryHandler(e:EditCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"cs weaponCardInv update", e.cci.inventoryID, e.cci.index, e.cci.position);
            _ctrl.slotInvUpdating = true;
            host.sendCommand(_command.csUpdateSlotCardInventoryInfo(Const.SCT_WEAPON,e.cci.inventoryID, e.cci.index, e.cci.position, e.cci.cardPosition));
        }

        public function updateEquipCardInventoryHandler(e:EditCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"cs equipCardInv update", e.cci.inventoryID, e.cci.index, e.cci.position);
            _ctrl.slotInvUpdating = true;
            host.sendCommand(_command.csUpdateSlotCardInventoryInfo(Const.SCT_EQUIP,e.cci.inventoryID, e.cci.index, e.cci.position, e.cci.cardPosition));
        }

        public function updateEventCardInventoryHandler(e:EditCardEvent):void
        {
            log.writeLog(log.LV_INFO, this,"cs eventCardInv update", e.cci.inventoryID, e.cci.index, e.cci.position);
            _ctrl.slotInvUpdating = true;
            host.sendCommand(_command.csUpdateSlotCardInventoryInfo(Const.SCT_EVENT,e.cci.inventoryID, e.cci.index, e.cci.position, e.cci.cardPosition));
        }



        // 指定したデッキの名前を更新する
        public function csUpdateDeckNameHandler(e:EditDeckEvent):void
        {
            log.writeLog(log.LV_INFO, this,"cs DeckName");
            host.sendCommand(_command.csUpdateDeckName(e.index, e.name));
        }

        // デッキを作成する
        public function csCreateDeckHandler(e:EditDeckEvent):void
        {
            log.writeLog(log.LV_INFO, this, "cs CreateDeck");
            host.sendCommand(_command.csCreateDeck());
        }

        // デッキを削除する
        public function csDeleteDeckHandler(e:EditDeckEvent):void
        {
            log.writeLog(log.LV_INFO, this, "cs DeleteDeck");
            host.sendCommand(_command.csDeleteDeck(e.index));
        }

        // カレントデッキの番号を変更する
        public function csUpdateCurrentDeckIndexHandler(e:EditDeckEvent):void
        {
            log.writeLog(log.LV_INFO, this, "cs UpdateCurrentDeckIndex");
            host.sendCommand(_command.csUpdateCurrentDeckIndex(e.index));
        }

        // カードを合成する
        public function csExchange(e:ExchangeEvent):void
        {
            log.writeLog(log.LV_INFO, this, "cs exchange");
            TopView.enable(false);
            host.sendCommand(_command.csRequestExchange(e.id, e.cid));

        }

        // カードを合成する
        public function csCombine(e:CombineEvent):void
        {
            log.writeLog(log.LV_INFO, this, "cs combine",e.invIds);
            TopView.enable(false);
            host.sendCommand(_command.csRequestCombine(e.invIds));

        }


        // アバターのアップデートをチェックする
        public function csAvatarUpdateCheck():void
        {
            log.writeLog(log.LV_INFO, this, "+cs avatar update check");
            host.sendCommand(_command.csAvatarUpdateCheck());
        }

        // アイテムを使用する
        public function csAvatarUseItem(invId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar use item");
            host.sendCommand(_command.csAvatarUseItem(invId));
        }

        // アイテムを購入
        public function csAvatarBuyItem(shopId:int, itemId:int, amount:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar buy item", shopId, itemId, amount);
            host.sendCommand(_command.csAvatarBuyItem(shopId, itemId, amount));
        }

        // スロットカードを購入
        public function csAvatarBuySlotCard(shopId:int, kind:int, cardId:int,amount:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar buy slot card", shopId, kind, cardId, amount);
            host.sendCommand(_command.csAvatarBuySlotCard(shopId, kind, cardId, amount));
        }

        // スロットカードを購入
        public function csAvatarBuyCharaCard(shopId:int, cardId:int, amount:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar buy chara card", shopId, cardId, amount);
            host.sendCommand(_command.csAvatarBuyCharaCard(shopId, cardId, amount));
        }

        // パーツを購入
        public function csAvatarBuyPart(shopId:int, cardId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs avatar buy chara card", shopId, cardId);
            host.sendCommand(_command.csAvatarBuyPart(shopId, cardId));
        }

        // 課金アイテムリストの要求
        public function csRequestRealMoneyItemInfo():void
        {

        }

        // 課金アイテムのチェック
        public function csRealMoneyItemResultCheck(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs request RealMoney item check");
            host.sendCommand(_command.csRealMoneyItemResultCheck(id));
        }

        // フレンドの申請
        public function csFriendApply(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs friend apply",id);
            host.sendCommand(_command.csFriendApply(id));
        }

        // フレンドの許可
        public function csFriendConfirm(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs friend confirm",id);
            host.sendCommand(_command.csFriendConfirm(id));
        }


        // フレンドの削除
        public function csFriendDelete(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs friend delete",id);
            host.sendCommand(_command.csFriendDelete(id));
        }

        // ブロックの追加
        public function csBlockApply(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs block apply",id);
            host.sendCommand(_command.csBlockApply(id));
        }


        // レアカードくじを引く
        public function csDrawLot(kind:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs draw lot",kind);
            host.sendCommand(_command.csDrawLot(kind));
        }

        // カードを増やす
        public function csCopyCard(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs copy card",id);
            host.sendCommand(_command.csCopyCard(id));
        }

        // レアカードくじを引く
        public function csSetAvatarPart(invID:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs set Avatar Part",invID);
            host.sendCommand(_command.csSetAvatarPart(invID));
        }

        // パーツ消滅チェック
        public function csPartsVanishCheck():void
        {
            log.writeLog(log.LV_INFO, this, "cs Parts Vanish Check");
            host.sendCommand(_command.csPartsVanishCheck());
        }

        // パーツをすてる
        public function csPartDrop(invID:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs Parts drop");
            host.sendCommand(_command.csPartDrop(invID));
        }

        // アチーブメントクリアチェック
        public function csAchievementClearCheck(noticeCheck:Boolean=true):void
        {
            log.writeLog(log.LV_INFO, this, "cs AchievementClearCheck");
            host.sendCommand(_command.csAchievementClearCheck(noticeCheck));
        }

        // アチーブメントクリアチェック
        public function csNoticeClear(n:int,args:String = ""):void
        {
            log.writeLog(log.LV_INFO, this, "cs NoticeClear");
            host.sendCommand(_command.csNoticeClear(n,args));
        }

        // セール時間情報の要求
        public function csRequestSaleLimitInfo():void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestSaleLimitInfo");
            host.sendCommand(_command.csRequestSaleLimitInfo());
        }

        // アチーブメント情報の要求
        public function csRequestAchievementInfo():void
        {
            log.writeLog(log.LV_INFO, this, "cs RequestAchievementInfo");
            host.sendCommand(_command.csRequestAchievementInfo());
        }

        // シリアルの送信
        public function csEventSerialCode(serial:String, pass:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs Serialcode");
            host.sendCommand(_command.csEventSerialCode(serial, pass));
        }

        // 新規取得渦チェック
        public function csNewProfoundInventoryCheck():void
        {
            log.writeLog(log.LV_INFO, this, "cs NewProfoundInventoryCheck");
            host.sendCommand(_command.csNewProfoundInventoryCheck());
        }

        // お気に入りキャラIDを変更
        public function csChangeFavoriteCharaId(charaId:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs ChangeFavoriteCharaId",charaId);
            host.sendCommand(_command.csChangeFavoriteCharaId(charaId));
        }

        // リザルト画像を変更
        public function csChangeResultImage(charaId:int, imageNo:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs ChangeResultImage",charaId, imageNo);
            host.sendCommand(_command.csChangeResultImage(charaId, imageNo));
        }

        // お気に入りキャラIDを変更
        public function csLobbyCharaDialogueStart():void
        {
            log.writeLog(log.LV_INFO, this, "cscsLobbyCharaDialogueStart");
            host.sendCommand(_command.csLobbyCharaDialogueStart());
        }

        // コラボイベントシリアル送信
        public function csInfectionCollaboSerialCode(serial:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs InfectionCollaboSerialCode");
            host.sendCommand(_command.csInfectionCollaboSerialCode(serial));
        }

        // クランプスクリック
        public function csClampsClick():void
        {
            log.writeLog(log.LV_INFO, this, "cs Clamps Click");
            host.sendCommand(_command.csClampsClick());
        }

        // クランプス出現チェック
        public function csClampsAppearCheck():void
        {
            log.writeLog(log.LV_INFO, this, "cs Clamps Appear Check");
            host.sendCommand(_command.csClampsAppearCheck());
        }

        // Noticeでの選択アイテムを取得
        public function csGetNoticeSelectableItem(args:String):void
        {
            log.writeLog(log.LV_INFO, this, "cs Get Notice Selectable Item",args);
            host.sendCommand(_command.csGetNoticeSelectableItem(args));
        }

        // 渦Noticeのみ削除
        public function csProfoundNoticeClear(num:int):void
        {
            log.writeLog(log.LV_INFO, this, "cs ProfoundNoticeClear");
            host.sendCommand(_command.csProfoundNoticeClear(num));
        }

        // デッキの所持上限チェック
        public function csDeckMaxCheck():void
        {
            log.writeLog(log.LV_INFO, this, "cs DeckMaxCheck");
            host.sendCommand(_command.csDeckMaxCheck());
        }

        /**
         * 受信コマンド
         *
         */

        // ネゴシエーション処理の返答
        public function negoCert(crypted_sign:String, ok:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"negotiated ");
            host.sendCommand(_command.login("yes, ok.",crypted_sign));
        }

        // ログインOK
        public function loginCert(msg:String, hash_key:String):void
        {
            log.writeLog(log.LV_INFO, this,"server cert");
            _edit = DeckEditor.instance;
            _edit.addEventListener(DeckEditor.START, editStartHandler);
            _edit.addEventListener(DeckEditor.END, editEndHandler);
            _growth = Growth.instance;
            _growth.addEventListener(Growth.START, growthStartHandler);
            _growth.addEventListener(Growth.END, growthEndHandler);
            _combine = Combine.instance;
            _combine.addEventListener(Combine.START, combineStartHandler);
            _combine.addEventListener(Combine.END, combineEndHandler);
            // 最初に一回かならずチェックを通す
//            csAchievementClearCheck();

        }

       // ログインOK
        public function loginFail():void
        {
            log.writeLog(log.LV_FATAL, this,"Login Failed!!");
        }


        // ニュースを受け取る
        public function scNews(news:String):void
        {
            log.writeLog(log.LV_INFO, this,"get news messeage", news);
        }

        public function scCreateAvatarSuccess(success:Boolean):void
        {
            if (success)
            {
                // アバターを作る(仮)
//                player.state = Player.STATE_LOBBY; // ！！！！！！！！！仮（）
            }else{
                // レジストやりなおしのやり直し（名前入力まで戻す）
                player.state = Player.STATE_REGIST;
            }
        }

        public function scCheckAvatarName(code:int):void
        {
            if (code == Avatar.NAME_INPUT_SUCCESS)
            {
                _ctrl.checkNameSuccess();
            }
            else
            {
                _ctrl.checkNameFailed(code);
            }
       }

        //
        // アバター情報を受け取る(obsolete)
        public function scAvatarInfo(id:int,
                                     name:String,
                                     gems:int,
                                     exp:int,
                                     level:int,
                                     energy:int,
                                     energyMax:int,
                                     recoveryInterval:int,
                                     remainTime:int,
                                     point:int,
                                     win:int,
                                     lose:int,
                                     draw:int,
                                     part_num:int,
                                     part_inv_id:String,
                                     part_array:String,
                                     part_used:String,
                                     part_end_at:String,
                                     item_num:int,
                                     item_inv_id:String,
                                     item_array:String,
                                     item_state_array:String,
                                     deck_num:int,
                                     deck_name:String,
                                     deck_kind:String,
                                     deck_level:String,
                                     deck_exp:String,
                                     deck_status:String,
                                     deck_cost:String,
                                     deck_max_cost:String,
                                     card_num:int,
                                     inv_id:String,
                                     card_array:String,
                                     deck_index:String,
                                     deck_position:String,
                                     slot_num:int,
                                     slot_inv_id:String,
                                     slot_array:String,
                                     slot_type:String,
                                     slotCombined:String,
                                     slotCombineData:String,
                                     slot_deck_index:String,
                                     slot_deck_position:String,
                                     slot_card_position:String,
                                     quest_max:int,
                                     quest_num:int,
                                     quest_inv_id:String,
                                     quest_array:String,
                                     quest_status:String,
                                     quest_find_time:String,
                                     questBaName:String,
                                     quest_flag:int,
                                     quest_clear_num:int,
                                     friend_max:int,
                                     part_max:int,
                                     free_duel_count:int,

                                     exp_pow:int,
                                     gems_pow:int,
                                     quest_find_pow:int,

                                     current_deck:int,
                                     saleType:int,
                                     saleLimitRestTime:int,
                                     favoriteCharaId:int,
                                     floorCount:int,
                                     eventQuestFlag:int,
                                     eventQuestClearNum:int,
                                     tutorialQuestFlag:int,
                                     tutorialQuestClearNum:int,
                                     charaVoteQuestFlag:int,
                                     charaVoteQuestClearNum:int):void
        {
            log.writeLog(log.LV_WARN, this, "scAvatarInfo!");

            // アバターが未登録の場合
            if ((name == "")&&(gems == 0)&&(deck_num==0))
            {
//                player.state = Player.STATE_REGIST;
            }else{
                // レジストならチュートリアルへ
                if(player.state == Player.STATE_REGIST)
                {
                    player.state = Player.STATE_TUTORIAL;
                }
                else
                {
                    player.state = Player.STATE_LOBBY;
                }
                _edit = DeckEditor.instance;
                _edit.addEventListener(DeckEditor.START, editStartHandler);
                _edit.addEventListener(DeckEditor.END, editEndHandler);
                _growth = Growth.instance;
                _growth.addEventListener(Growth.START, growthStartHandler);
                _growth.addEventListener(Growth.END, growthEndHandler);
                log.writeLog(log.LV_INFO, this, "part equip!", part_used,string2intArray(part_used));
                // 最初のロビーログインなら
                if (player. avatar == null)
                {
                    player.avatar = new Avatar(
                        0,
                        name,
                                               gems,
                                               exp,
                                               level,
                                               energy,
                                               energyMax,
                                               recoveryInterval,
                                               remainTime,
                                               point,
                                               win,
                                               lose,
                                               draw,
                                               part_num,
                                               string2intArray(part_inv_id),
                                               string2intArray(part_array),
                                               string2intArray(part_used),
                                               string2intArray(part_end_at),
                                               item_num,
                                               string2intArray(item_inv_id),
                                               string2intArray(item_array),
                                               string2intArray(item_state_array),
                                               deck_num,
                                               deck_name.split(/,/),
                                               deck_kind.split(/,/),
                                               deck_level.split(/,/),
                                               deck_exp.split(/,/),
                                               deck_status.split(/,/),
                                               deck_cost.split(/,/),
                                               deck_max_cost.split(/,/),
                                               card_num,
                                               string2intArray(inv_id),
                                               string2intArray(card_array),
                                               string2intArray(deck_index),
                                               string2intArray(deck_position),
                                               slot_num,
                                               string2intArray(slot_inv_id),
                                               string2intArray(slot_array),
                                               string2intArray(slot_type),
                                               string2BooleanArray(slotCombined),
                                               slotCombineData.split(/,/),
                                               string2intArray(slot_deck_index),
                                               string2intArray(slot_deck_position),
                                               string2intArray(slot_card_position),
                                               quest_max,
                                               quest_num,
                                               string2intArray(quest_inv_id),
                                               string2intArray(quest_array),
                                               string2intArray(quest_status),
                                               string2intArray(quest_find_time),
                                               questBaName.split(/,/),
                                               quest_flag,
                                               quest_clear_num,
                                               friend_max,
                                               part_max,
                                               free_duel_count,
                                               exp_pow,
                                               gems_pow,
                                               quest_find_pow,
                                               current_deck,
                                               saleType,
                                               saleLimitRestTime,
                                               favoriteCharaId,
                                               floorCount,
                                               eventQuestFlag,
                                               eventQuestClearNum,
                                               tutorialQuestFlag,
                                               tutorialQuestClearNum,
                                               charaVoteQuestFlag,
                                               charaVoteQuestClearNum);
                }else{
                    player.avatar.gems = gems;
                    player.avatar.exp = exp;
                    player.avatar.level = level;
                    player.avatar.energy= energy;
                    player.avatar.energyMax =energyMax;
                    player.avatar.remainTime = remainTime;
                    player.avatar.point = point;
                    player.avatar.win = win;
                    player.avatar.lose = lose;
                    player.avatar.draw = draw;
                    player.avatar.freeDuelCount = free_duel_count;
                    player.avatar.saleType = saleType;
                    player.avatar.updateSaleLimitRestTime(saleLimitRestTime);
                    player.avatar.favoriteCharaId = favoriteCharaId;
                    player.avatar.floorCount = floorCount;

                }
            }

        }

        // アバターアイテム情報を受け取る
        public function scAvataritemInfo(id:int, name:String, item_no:int, kind:int, subKind:String, cond:String, image:String, image_frame:int, effect_image:String, caption:String, version:int):void
        {
            AvatarItem.updateParam(id, name, item_no, kind, subKind, cond, image, image_frame, effect_image, caption, version);
        }


        // フレンド情報を受け取る
        public function scFriendList():void
        {
            log.writeLog(log.LV_INFO, this, "Failed!!: ");
        }

        // ショップ情報を受け取る
        public function scShopInfo(id:int, saleList:String):void
        {
            log.writeLog(log.LV_INFO, this, "shop info ", saleList);
            Shop.updateParam(id, arraySeparateNum(8, string2intArray(saleList)));
        }
        // 合成可能かを受け取る
        public function scExchangebleInfo(id:int, exchangeble:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "card exchangeble is", exchangeble);
        }

        // 追加のキャラカードインベントリ情報を受け取る
        public function scCharaCardInventoryInfo(inv_id:String, card_id:String):void
        {
            log.writeLog(log.LV_INFO, this,"get chara card inventory ID is", inv_id, card_id);

            var invID:Array = string2intArray(inv_id);
            var cardID:Array = string2intArray(card_id);

            invID.forEach(function(item:*, index:int, array:Array):void{CharaCardDeck.binder.addCharaCardInventory(new CharaCardInventory(item, CharaCard.ID(cardID[index]), 0, 0))});

        }

        // 合成結果を受け取る
        public function scExchangeResult(success:Boolean, cardId:int, invId:int, lostInvId:String):void
        {
            log.writeLog(log.LV_INFO, this, "sc exchange result", success);

            var lostInvIds:Array = string2intArray(lostInvId);

            if(success)
            {
                var lostCardIdNums:Dictionary = new Dictionary();
                for ( var i:int = 0; i < lostInvIds.length; i++ ) {
                    var card_id:String = String(CharaCardInventory.getInventory(lostInvIds[i]).cardId);
                    if ( lostCardIdNums[card_id] == null ) {
                        lostCardIdNums[card_id] = 1;
                    } else {
                        lostCardIdNums[card_id]++;
                    }
                }

                // カードの合成に成功
                CharaCardDeck.binder.addCharaCardInventory(new CharaCardInventory(invId, CharaCard.ID(cardId), 0, 0));
                _ctrl.getCharaCardSuccess(cardId);
                lostInvIds.forEach(function(item:*, index:int, array:Array):void{CharaCardDeck.binder.removeCharaCardInventoryId(item);});
                lostInvIds.forEach(function(item:*, index:int, array:Array):void{CharaCardInventory.deleteCharaCardInventory(item);});
                Growth.instance.exchangeSuccess();

                log.writeLog(log.LV_INFO, "lobbyserver exchangeresultp");

                // 合成結果をログに書き込む
                ClientLog.write(ClientLog.GOT_EXCH_CARD,cardId, true );
                ClientLog.write( ClientLog.GOT_CHARA_CARD, cardId, true );

                // 合成で消費したカードをログに書き込む
                for ( var key:Object in lostCardIdNums ) {
                    var setData:Array = [ key, lostCardIdNums[key] ];
                    ClientLog.write( ClientLog.VANISH_CARD, setData, true );
                }
            }
            else
            {
                // カードの合成に失敗
                new WaitThread(1000,TopView.enable, [true], true).start()
//LOCALE_JP <-フォント読み込みを防ぐ 修正が必要
                Alerter.showWithSize(_TRANS_SYNTHESIZE_B,_TRANS_SYNTHESIZE_A)
            }

        }

        // 合成結果を受け取る
        public function scCombineResult(success:Boolean, cardId:int, invId:int):void
        {
            log.writeLog(log.LV_INFO, this, "sc combine result", success,cardId);

            if(success)
            {
                log.writeLog(log.LV_DEBUG, this, "sc combine result", "success");
                // カードの合成に成功
                var lostInvIds:Array = CombineEditDeck.deck.getCombineArray();
                lostInvIds.shift(); // 先頭はベースカードなので省く
                CombineEditDeck.deleteDeck();
                var wc:WeaponCard;
                var wci:WeaponCardInventory = WeaponCardInventory.getInventory(invId);
                if (wci) {
                    if (wci.combined == false) {
                        wc = WeaponCard(wci.card).getUpdateCombineWeapon(cardId);
                        wc.num += 1;
                        wci.card = ICard(wc);
                    } else {
                        wc = WeaponCard(wci.card)
                    }
                } else {
                    wc = WeaponCard.createCombineWeapon(cardId);
                    WeaponCardDeck.binder.addWeaponCardInventory(new WeaponCardInventory(invId, wc, 0, 0, 0));
                }
                _ctrl.getWeaponCardSuccess(wc.id);
                lostInvIds.forEach(function(item:*, index:int, array:Array):void{WeaponCardDeck.binder.removeWeaponCardInventoryId(item);});
                lostInvIds.forEach(function(item:*, index:int, array:Array):void{WeaponCardInventory.deleteWeaponCardInventory(item);});
                Combine.instance.combineSuccess(cardId,invId);

                log.writeLog(log.LV_INFO, "lobbyserver combineresultp");

            }
            else
            {
                // カードの合成に失敗
                new WaitThread(1000,TopView.enable, [true], true).start()
//LOCALE_JP <-フォント読み込みを防ぐ 修正が必要
                Alerter.showWithSize(_TRANS_SYNTHESIZE_B,_TRANS_SYNTHESIZE_A)
            }

        }

        // コインの使用
        public function scUseCoin(inv_ids:String):void
        {
            var lostInvIds:Array = string2intArray(inv_ids);
            var lostCardIdNums:Dictionary = new Dictionary();

            for ( var i:int = 0; i < lostInvIds.length; i++ ) {
                var card_id:String = String(CharaCardInventory.getInventory(lostInvIds[i]).cardId);
                if ( lostCardIdNums[card_id] == null ) {
                    lostCardIdNums[card_id] = 1;
                } else {
                    lostCardIdNums[card_id]++;
                }
            }

            lostInvIds.forEach(function(item:*, index:int, array:Array):void{CharaCardDeck.binder.removeCharaCardInventoryId(item);});
            lostInvIds.forEach(function(item:*, index:int, array:Array):void{CharaCardInventory.deleteCharaCardInventory(item);});
            // 合成で消費したカードをログに書き込む
            for ( var key:Object in lostCardIdNums ) {
                var setData:Array = [ key, lostCardIdNums[key] ];
                ClientLog.write( ClientLog.VANISH_CARD, setData, true );
            }

        }

        // ログインボーナスを受け取る
        public function scLoginBonus(type:int, stype:int, id:int, value:int):void
        {
            player.avatar.loginBonus = [type, stype, id, value];
            log.writeLog(log.LV_INFO, this, "get login bonus !", type, stype, id, value);
            var setData:Object = [ type, stype, id, value ];
            ClientLog.write( ClientLog.GOT_LOGIN, setData, true );
        }

        // デッキを作るのに成功
        public function scCreateDeckSuccess(dn:String, dk:int,dl:int, de:int, ds:int, dc:int, dmc:int, cards:String ):void
        {
            log.writeLog(log.LV_INFO, this, "createdecksucc", dn, dk,dl, de, ds, dc, dmc, cards);
            _edit.createDeckSuccess(dn, dk,dl, de, ds, dc, dmc, arraySeparateTwo(string2intArray(cards)));
        }

        // デッキを消すのに成功
        public function scDeleteDeckSuccess(index:int):void
        {
            _edit.deleteDeckSuccess(index);
        }

        // カレントをかえるのに成功
        public function scUpdateCurrentDeckIndex(index:int):void
        {
            player.avatar.currentDeck = index;
        }

        // カードインベントリ情報更新に失敗
        public function scUpdateCardInventoryFailed(e:int, invId:int, index:int, positon:int):void
        {
//            _edit.updateCharaCardInventorySuccess(invId);
        }

        // カードインベントリ情報更新に失敗
        public function scUpdateSlotCardInventoryFailed(k:int, e:int, invId:int, index:int, dpositon:int, cpositon:int):void
        {
            scErrorNo(e);
            log.writeLog(log.LV_FATAL, this, "failed", k, invId, index, dpositon, cpositon);
            _edit.updateSlotCardInventoryFailed(k,invId, index, dpositon, cpositon);
        }

        // 行動力を更新
        public function scEnergyInfo(energy:int,remainTime:int):void
        {
            log.writeLog(log.LV_FATAL, this, "++scEnergyInfo", player, player.avatar,energy, remainTime);

            player.avatar.remainTime = remainTime;
            player.avatar.energy = energy;
        }

        // フリーデュエル回数更新
        public function scFreeDuelCountInfo(count:int):void
        {
            log.writeLog(log.LV_FATAL, this, "++scFreeDuelCount",count);
            player.avatar.freeDuelCount = count;
        }

        // 行動力MAXを更新
        public function scUpdateEnergyMax(energyMax:int):void
        {
            player.avatar.energyMax = energyMax;
        }

        // フレンドMAXを更新
        public function scUpdateFriendMax(friendMax:int):void
        {
            player.avatar.friendMax = friendMax;
        }

        // パーツMAXを更新
        public function scUpdatePartMax(partMax:int):void
        {
            player.avatar.partInventoryMax = partMax;
        }

        // 勝敗を更新
        public function scUpdateResult(point:int, win:int, lose:int, draw:int):void
        {
            log.writeLog(log.LV_INFO, this, "update!!!!!!!!!!!!");
            player.avatar.point = point;
            player.avatar.win = win;
            player.avatar.lose = lose;
            player.avatar.draw = draw;
        }

//         // 行動力を回復
//         public function scRecoveryEnergy(energy:int):void
//         {
//             player.avatar.energy = energy;
//         }

        // 経験値を回復
        public function scGetExp(exp:int):void
        {
//             log.writeLog(log.LV_INFO, this, "sc get exp");
//             player.avatar.exp = exp;
        }

        // レベルアップ
        public function scLevelUp(level:int):void
        {
//             log.writeLog(log.LV_INFO, this, "sc level up");
//             player.avatar.level = level;
            ClientLog.write( ClientLog.GOT_LEVEL, level, true );
        }

        // 経験値を回復
        public function scGetDeckExp(deck_exp:int):void
        {
            log.writeLog(log.LV_INFO, this, "sc deck get exp", deck_exp);
            CharaCardDeck.decks[player.avatar.currentDeck].exp = deck_exp;
//            player.avatar.getCurrentDeck.exp = deck_exp;
        }

        // レベルアップ
        public function scDeckLevelUp(deck_level:int):void
        {
            log.writeLog(log.LV_INFO, this, "sc deck level up", deck_level);
            CharaCardDeck.decks[player.avatar.currentDeck].maxCost += deck_level - CharaCardDeck.decks[player.avatar.currentDeck].level;
            CharaCardDeck.decks[player.avatar.currentDeck].level = deck_level;
//            player.avatar.getCurrentDeck.level = deck_level;
        }

        // ジェムの更新
        public function scUpdateGems(gems:int):void
        {
            log.writeLog(log.LV_INFO, this, "sc update gems");
            player.avatar.gems = gems;
        }

        // アイテムの取得
        public function scGetItem(inv_id:int,item_id:int):void
        {
            if (__alertOn)
            {
                // new ModelWaitThread(AvatarItem.ID(item_id),waitShowAlert,[item_id]).start();
                waitShowAlert( AvatarItem.ID(item_id).name );
            }
            AvatarItemInventory.addAvatarItemInventory(inv_id, AvatarItem.ID(item_id));
            ClientLog.write( ClientLog.GOT_ITEM, item_id, true );
        }


        CONFIG::LOCALE_JP
        private function waitShowAlert(name:String):void
        {
//            Alerter.showWithSize(AvatarItem.ID(itemID).name + "を獲得しました。", "情報")
            Alerter.showWithSize(name +_TRANS_GET, _TRANS_INFO)
        }

        CONFIG::LOCALE_EN
        private function waitShowAlert(name:String):void
        {
            Alerter.showWithSize(_TRANS_GET+name, _TRANS_INFO)
        }

        CONFIG::LOCALE_TCN
        private function waitShowAlert(name:String):void
        {
            Alerter.showWithSize(_TRANS_GET+name, _TRANS_INFO)
        }

        CONFIG::LOCALE_SCN
        private function waitShowAlert(name:String):void
        {
            Alerter.showWithSize(_TRANS_GET+name, _TRANS_INFO)
        }

        CONFIG::LOCALE_KR
        private function waitShowAlert(name:String):void
        {
            Alerter.showWithSize(name +_TRANS_GET, _TRANS_INFO)
        }

        CONFIG::LOCALE_FR
        private function waitShowAlert(name:String):void
        {
            Alerter.showWithSize(_TRANS_GET+name, _TRANS_INFO)
        }

        CONFIG::LOCALE_ID
        private function waitShowAlert(name:String):void
        {
            Alerter.showWithSize(_TRANS_GET+name, _TRANS_INFO)
        }

        CONFIG::LOCALE_TH
        private function waitShowAlert(name:String):void
        {
            Alerter.showWithSize(_TRANS_GET+name, _TRANS_INFO)
        }


        // アイテムの使用
        CONFIG::LOCALE_JP
        public function scUseItem(inv_id:int):void
        {
//            Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name + "を使用しました。", "情報");
            log.writeLog(log.LV_WARN, this, "scUseItem",inv_id);
            if (__alertOn)
            {
                Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name  + _TRANS_USE, _TRANS_INFO);
            }

            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アイテムの使用
        CONFIG::LOCALE_EN
        public function scUseItem(inv_id:int):void
        {
            if (__alertOn)
            {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            }
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アイテムの使用
        CONFIG::LOCALE_TCN
        public function scUseItem(inv_id:int):void
        {
            if (__alertOn)
            {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            }
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アイテムの使用
        CONFIG::LOCALE_SCN
        public function scUseItem(inv_id:int):void
        {
            if (__alertOn)
            {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            }
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        CONFIG::LOCALE_KR
        public function scUseItem(inv_id:int):void
        {
            if (__alertOn)
            {
                Alerter.showWithSize(AvatarItemInventory.getAvatarItem(inv_id).name  + _TRANS_USE, _TRANS_INFO);
            }

            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        // アイテムの使用
        CONFIG::LOCALE_FR
        public function scUseItem(inv_id:int):void
        {
            if (__alertOn)
            {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            }
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        CONFIG::LOCALE_ID
        public function scUseItem(inv_id:int):void
        {
            if (__alertOn)
            {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            }
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }

        CONFIG::LOCALE_TH
        public function scUseItem(inv_id:int):void
        {
            if (__alertOn)
            {
            Alerter.showWithSize(_TRANS_USE+AvatarItemInventory.getAvatarItem(inv_id).name, _TRANS_INFO);
            }
            ClientLog.write( ClientLog.VANISH_ITEM, inv_id, true );
            AvatarItemInventory.removeAvatarItemInventory(inv_id);
        }






        // アイテムの取得
        public function scGetSlotCard(inv_id:int, kind:int, card_id:int):void
        {
            switch (kind+1)
            {
            case InventorySet.TYPE_WEAPON:
                WeaponCardInventory.addWeaponCardInventory(inv_id, WeaponCard.ID(card_id));
                break;
            case InventorySet.TYPE_EQUIP:
                EquipCardInventory.addEquipCardInventory(inv_id, EquipCard.ID(card_id));
                break;
            case InventorySet.TYPE_EVENT:
                EventCardInventory.addEventCardInventory(inv_id, EventCard.ID(card_id));
                break;
            }
            var type:int = kind+1;
            var setData:Array = [ type, card_id ];
            ClientLog.write( ClientLog.GOT_SLOT_CARD, setData, true );
        }

        // アイテムの取得
        public function scGetCharaCard(inv_id:int, card_id:int):void
        {
           log.writeLog(log.LV_INFO, this,"get chara card inventory ID is (a)", inv_id, card_id);
           CharaCardDeck.binder.addCharaCardInventory(new CharaCardInventory(inv_id, CharaCard.ID(card_id), 0, 0));
//            CharaCardInventory.addCharaCardInventory(inv_id, CharaCard.ID(card_id));
            _ctrl.getCharaCardSuccess(card_id);
            ClientLog.write( ClientLog.GOT_CHARA_CARD, card_id, true );
        }

        // パーツの取得
        public function scGetPart(inv_id:int,part_id:int):void
        {
            new AvatarPartInventory(inv_id, AvatarPart.ID(part_id));
            if (__alertOn)
            {
                waitShowAlert( AvatarPart.ID(part_id).name );
            }
            _ctrl.getPartsSuccess(part_id)
            ClientLog.write( ClientLog.GOT_AVATAR_PART, part_id, true );
        }


//         // チャンネルリスト情報を受け取る
//         public function scChannelListInfo(id:String, name:String, rule:String, max:String, host:String, port:String, duel_host:String, duel_port:String, chat_host:String, chat_port:String, state:String, caption:String,count:String):void
//         {
//             log.writeLog(log.LV_INFO, this, "id is", id, "name is", name, "rule is", rule, "max is", max, "host is", host, "port is", port, "duel_host is", duel_host, "duel_port is", duel_port, "chat_host is", chat_host, "chat_port is", chat_port, "state is", state, "caption is", caption,"count is",count);

//             Channel.initChannelList(string2intArray(id),
//                                     name.split(","),
//                                     string2intArray(rule),
//                                     string2intArray(max),
//                                     host.split(","),
//                                     string2intArray(port),
//                                     duel_host.split(","),
//                                     string2intArray(duel_port),
//                                     chat_host.split(","),
//                                     string2intArray(chat_port),
//                                     string2intArray(state),
//                                     caption.split(","),
//                                     string2intArray(count)
//                 );

//         }

        // リアルマネー情報を受け取る
        public function scRealMoneyItemInfo(num:int, list:String):void
        {
//             var sl:Array = arraySeparateNum(num,list.split(","));
//             for(var i:int = 0; i < num; i++)
//             {
//                 RealMoneyItem.updateParam(sl[0][i], sl[1][i], sl[2][i], sl[3][i], sl[4][i], sl[5][i],sl[6][i], sl[7][i], sl[8][i], sl[9][i], sl[10][i]);
//             }

//             for(var i:int = 0; i < num; i++)
//             {
//                 RealMoneyItem.updateParam(sl[0][i], sl[1][i], sl[2][i], sl[3][i], sl[4][i], sl[5][i],sl[6][i], sl[7][i], sl[8][i], sl[9][i], sl[10][i]);
//             }
        }



        // フレンドが認証中に変更
        public function scFriendApplySuccess(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "Friend Apply succ", id);
            FriendLink.changeStatus(id,FriendLink.FR_ST_OTHER_CONFIRM)
            _ctrl.friendUpdate();
        }

        public function scFriendConfirmSuccess(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "Friend Confirm succ", id);
            FriendLink.changeStatus(id,FriendLink.FR_ST_FRIEND);
            _ctrl.friendUpdate();
        }

        public function scFriendDeleteSuccess(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "Friend Delete succ", id);
            FriendLink.deleteLink(id);
            _ctrl.friendUpdate();
        }

        public function scFriendBlockSuccess(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "Friend Block succ", id);
            FriendLink.changeStatus(id,FriendLink.FR_ST_BLOCK);
            _ctrl.friendUpdate();
        }

        // レアカードクジを引くのを成功
        public function scDrawRareCardSuccess(lotCardKind:int,lotCardID:int, lotCardNum:int, blankCard1Kind:int, blankCard1ID:int, blankCard1Num:int, blankCard2Kind:int, blankCard2ID:int, blankCard2Num:int ):void
        {
            log.writeLog(log.LV_INFO, this, "lot card get", lotCardKind,lotCardID,lotCardNum, blankCard1Kind, blankCard1ID, blankCard1Num, blankCard2Kind, blankCard2ID, blankCard2Num);
            _ctrl.gotRareCard(lotCardKind,lotCardID,lotCardNum, blankCard1Kind, blankCard1ID, blankCard1Num, blankCard2Kind, blankCard2ID, blankCard2Num);

            // 取得内容をログに書き込み
            var logData:Object = [ lotCardKind, lotCardID ];
            new WaitThread(6000, ClientLog.write,[ClientLog.GOT_LOT, logData, true ]).start();
        }

        // カード複製に成功
        public function scCopyCardSuccess(id:int):void
        {
            log.writeLog(log.LV_INFO, this, "dupe success", id);
            Alerter.showWithSize(_TRANS_COPY, _TRANS_INFO);
            _ctrl.copyCardSuccess(id);
        }

        // アクティビティの送信
        public function scActivityFeed(type:int):void
        {
        }

        public function scEquipChangeSucc(id:int, unuse_api:String, end_at:int, status:int):void
        {
            log.writeLog(log.LV_INFO, this, "scEquipChangeSucc ", id, unuse_api,end_at,status);
            _ctrl.equipPartsSucc(id,unuse_api,end_at,status);
        }



        public function scUpdateRecoveryInterval(time:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateRecInterval ", time);
            player.avatar.recoveryInterval = time;
        }


        public function scUpdateQuestInvMax(i:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateQuestMax", i);
            player.avatar.questMax = i;
        }

        public function scUpdateExpPow(pow:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateExpPow", pow);
            player.avatar.expPow = pow;
        }

        public function scUpdateGemPow(pow:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateGemsPow", pow);
            player.avatar.gemsPow = pow;
        }


        public function scUpdateQuestFindPow(pow:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateQuestFindPow", pow);
            player.avatar.questFindPow = pow;
        }


        public function scVanishPart(invID:int, alert:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "scVanishPart", invID, alert);
            if (alert)
            {
                Alerter.showWithSize(_TRANS_FINISH_A + AvatarPartInventory.ID(invID).avatarPart.name + _TRANS_FINISH_B);
            }
            _ctrl.equipPartsSucc(0,invID.toString(),0,0);
            _ctrl.partsVanish(invID);

        }

        //
        public function scAchievementClear(achiID:int, itemType:int, itemID:int, itemNum:int, cType:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAchievementClear", achiID, itemType, itemID, itemNum, cType);
            LobbyNotice.setAchievementSuccessInfo(achiID, itemType, itemID, itemNum, cType);
            AchievementInventory.finishAchievementInventory(achiID);
            ClientLog.write( ClientLog.SUCC_ACHIEVEMENT, achiID, true );
        }

        public function scAddNewAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAddNewAchievement", achiID);
            LobbyNotice.setAchievementNewInfo(achiID);

            new AchievementInventory(achiID, Const.ACHIEVEMENT_STATE_START)
        }
        public function scDeleteAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scDeleteAchievement", achiID);
            AchievementInventory.deleteAchievementInventory(achiID);
        }
        public function scDropAchievement(achiID:int):void
        {
            log.writeLog(log.LV_INFO, this, "scDropAchievement", achiID);
            AchievementInventory.dropAchievementInventory(achiID);
        }

        public function scAddNotice(body:String):void
        {
            log.writeLog(log.LV_INFO, this, "scAddNotice", body);
            // コマンドごとに割る
            var c_set:Array =  body.split("|");
            c_set.forEach(function(item:*, index:int, array:Array):void
                          {
                              var arg_set:Array = item.split(":");
                              log.writeLog(log.LV_INFO, this, "scAddNotice", arg_set[0],arg_set[1]);
                              var n_type:int = int(arg_set[0]);
                              // 渦関連のノーティスは別
                              if (LobbyNotice.PRF_TYPES.indexOf(n_type) != -1) {
                                  ProfoundNotice.setNotice(arg_set[0],arg_set[1]);
                              } else {
                                  LobbyNotice.setNotice(arg_set[0],arg_set[1]);
                              }
                              if ( arg_set[0] == LobbyNotice.TYPE_INVITE_SUCC ) {
                                  ClientLog.write( ClientLog.SUCC_INVITE, arg_set[1], true );
                              }
                          });


        }

        // セール終了までの時間をアップデート
        public function scUpdateSaleRestTime(saleType:int,restTime:int):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateSaleRestTime", restTime);
            Player.instance.avatar.saleType = saleType;
            Player.instance.avatar.updateSaleLimitRestTime(restTime);
        }

        // アチーブメント情報をアップデート
        public function scUpdateAchievementInfo(achievements:String,achievementsState:String,achievementsProgress:String,achievementsEndAt:String,achievementsCode:String):void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateAchievementInfo", achievements,achievementsState,achievementsProgress,achievementsEndAt,achievementsCode);
            if (Player.instance && Player.instance.avatar) {
                Player.instance.avatar.achievementUpdate(string2intArray(achievements),
                                                         string2intArray(achievementsState),
                                                         achievementsProgress.split(/_/),
                                                         achievementsEndAt.split(","),
                                                         achievementsCode.split(",")
                    );
            }
        }

        public function scSerialCodeSuccess(item:String):void
        {
            _ctrl.serialCodeSuccess(item);
        }
        public function scInfectionCollaboSerialSuccess(item:String):void
        {
            _ctrl.infectionCollaboSerialSuccess(item);
        }
        public function scClampsAppear():void
        {
            _ctrl.clampsAppear();
        }
        public function scClampsClickSuccess(item:String):void
        {
            _ctrl.clampsClickSuccess(item);
        }


        public function scChangeFavoriteCharaId(charaId:int):void
        {
            log.writeLog(log.LV_INFO, this, "scChangeFavoriteCharaId", charaId);
            _ctrl.changeFavoriteChara(charaId);
        }

        public function scLobbyCharaDialogue(lines:String):void
        {
            log.writeLog(log.LV_INFO, this, "scLobbyCharaDialogue", lines);
            _ctrl.dialogueMessage(lines);
        }

        public function scLobbyCharaSelectPanel(choices:String):void
        {
            log.writeLog(log.LV_INFO, this, "scLobbyCharaSelectPanel", choices);
        }

        public function scUpdateCombineWeaponData(invId:int,cardId:int,baseSap:int,baseSdp:int,baseAap:int,baseAdp:int,baseMax:int,addSap:int,addSdp:int,addAap:int,addAdp:int,addMax:int,passiveId:String,restriction:String,cntStr:String,cntMaxStr:String,level:int,exp:int,psvNumMax:int,passivePassSet:String,vanishPsvIds:String):void
        {

            log.writeLog(log.LV_INFO, this, "scUpdateCombineWeaponData", invId,cardId,baseSap,baseSdp,baseAap,baseAdp,baseMax,addSap,addSdp,addAap,addAdp,addMax,passiveId,restriction,cntStr,cntMaxStr,level,exp,psvNumMax,passivePassSet,vanishPsvIds);
            var wc:WeaponCard;
            var wci:WeaponCardInventory = WeaponCardInventory.getInventory(invId);
            if (wci) {
                if (wci.combined) {
                    wc = WeaponCard(wci.card);
                } else {
                    wc = WeaponCard.createCombineWeapon(cardId);
                    wc.num += 1;
                }
                wc.setCombineWeaponParam(cardId,baseSap,baseSdp,baseAap,baseAdp,baseMax,addSap,addSdp,addAap,addAdp,addMax,passiveId,restriction,cntStr,cntMaxStr,level,exp,psvNumMax,passivePassSet);
                wci.card = ICard(wc);
            } else {
                wc = WeaponCard.createCombineWeapon(cardId);
                wc.setCombineWeaponParam(cardId,baseSap,baseSdp,baseAap,baseAdp,baseMax,addSap,addSdp,addAap,addAdp,addMax,passiveId,restriction,cntStr,cntMaxStr,level,exp,psvNumMax,passivePassSet);
                WeaponCardDeck.binder.addWeaponCardInventory(new WeaponCardInventory(invId, wc, 0, 0, 0));
            }
            var vanishPsvSet:Array = vanishPsvIds.split("|");
            log.writeLog(log.LV_INFO, this, "scUpdateCombineWeaponData!!!",vanishPsvSet.length,vanishPsvSet);
            if (vanishPsvSet.length > 0&&wc) {
                var psvNameSet:Array = [];
                for (var i:int = 0; i < vanishPsvSet.length; i++) {
                    if (vanishPsvSet[i]&&int(vanishPsvSet[i])>0) {
                        var psvId:int = int(vanishPsvSet[i]);
                        var passive:PassiveSkill = PassiveSkill.ID(psvId);
                        psvNameSet.push(passive.name);
                    }
                }
                if (psvNameSet.length > 0) {
                    Alerter.showWithSize(Const.TRANS_CMB_PASSIVE_VANISH_MSG.replace("__WC_NAME__",wc.name).replace("__PSV_NAME__",psvNameSet.join(",")));
                }
            }
        }

        public function scUpdateCardInventoryInfoFinish():void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateCardInventoryInfoFinish");
            _ctrl.charaInvUpdating = false;
        }
        public function scUpdateSlotCardInventoryInfoFinish():void
        {
            log.writeLog(log.LV_INFO, this, "scUpdateSlotCardInventoryInfoFinish");
            _ctrl.slotInvUpdating = false;
        }

        public function scInventoryUpdateCheck(charaCardInvInfo:Boolean,slotCardInvInfo:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "scInventoryUpdateCheck",charaCardInvInfo,slotCardInvInfo);
            _ctrl.charaInvUpdating = charaCardInvInfo;
            _ctrl.slotInvUpdating = slotCardInvInfo;
        }

        public function scDeckMaxCheckResult(ok:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "scDeckMaxCheckResult", ok);
            _ctrl.deckMaxCheckResult(ok);
        }


        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {
            _ctrl.errorAlert(e);
            // チケット不足の時に終了イベントを送る
            if (e==70)
            {
                _ctrl.rareCardEventFinish();
            }

//            _ctrl.waitingStop();
        }

        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }




        // DeckEditorのイベントハンドラを登録
        private function editStartHandler(e:Event):void
        {
            _edit.addEventListener(EditCardEvent.UPDATE_CHARA_CARD, updateCharaCardInventoryHandler);
            _edit.addEventListener(EditCardEvent.UPDATE_WEAPON_CARD, updateWeaponCardInventoryHandler);
            _edit.addEventListener(EditCardEvent.UPDATE_EQUIP_CARD, updateEquipCardInventoryHandler);
            _edit.addEventListener(EditCardEvent.UPDATE_EVENT_CARD, updateEventCardInventoryHandler);

            _edit.addEventListener(EditDeckEvent.RENAME_DECK, csUpdateDeckNameHandler);
            _edit.addEventListener(EditDeckEvent.CREATE_DECK, csCreateDeckHandler);
            _edit.addEventListener(EditDeckEvent.DELETE_DECK, csDeleteDeckHandler);
            _edit.addEventListener(EditDeckEvent.CHANGE_CURRENT_DECK, csUpdateCurrentDeckIndexHandler);

            _growth.initialize();
            _combine.initialize();
        }

        // DeckEditorのイベントハンドラを消去
        private function editEndHandler(e:Event):void
        {
            _edit.removeEventListener(EditCardEvent.UPDATE_CHARA_CARD, updateCharaCardInventoryHandler);
            _edit.removeEventListener(EditCardEvent.UPDATE_WEAPON_CARD, updateWeaponCardInventoryHandler);
            _edit.removeEventListener(EditCardEvent.UPDATE_EQUIP_CARD, updateEquipCardInventoryHandler);
            _edit.removeEventListener(EditCardEvent.UPDATE_EVENT_CARD, updateEventCardInventoryHandler);

            _edit.removeEventListener(EditDeckEvent.RENAME_DECK, csUpdateDeckNameHandler);
            _edit.removeEventListener(EditDeckEvent.CREATE_DECK, csCreateDeckHandler);
            _edit.removeEventListener(EditDeckEvent.DELETE_DECK, csDeleteDeckHandler);
            _edit.removeEventListener(EditDeckEvent.CHANGE_CURRENT_DECK, csUpdateCurrentDeckIndexHandler);

            _growth.finalize();
            _combine.finalize();
        }

        // growthのイベントハンドラを登録
        private function growthStartHandler(e:Event):void
        {
            _growth.addEventListener(ExchangeEvent.EXCHANGE_INFO, getExchangebleInfo);
            _growth.addEventListener(ExchangeEvent.EXCHANGE, csExchange);
        }

        // growthのイベントハンドラを消去
        private function growthEndHandler(e:Event):void
        {
            _growth.removeEventListener(ExchangeEvent.EXCHANGE_INFO, getExchangebleInfo);
            _growth.removeEventListener(ExchangeEvent.EXCHANGE, csExchange);
        }

        // combineのイベントハンドラを登録
        private function combineStartHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this, " combine start handlerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr!!!!!!!!!!!!!!!!!!!");
            _combine.addEventListener(CombineEvent.COMBINE, csCombine);
        }

        // combineのイベントハンドラを消去
        private function combineEndHandler(e:Event):void
        {
            _combine.removeEventListener(CombineEvent.COMBINE, csCombine);
        }

    }
}