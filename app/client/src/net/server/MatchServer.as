package net.server
{
    import flash.events.Event;

    import net.*;
    import net.command.*;
    import model.*;
    import model.events.*;
    import view.*;
    import view.utils.*;
    import controller.*;


    /**
     * ゲームの情報を扱うクラス
     *
     */
    public class MatchServer extends Server
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_CLOSE	:String = "対戦ルームを閉じました";
        CONFIG::LOCALE_JP
        private static const _TRANS_SERVER	:String = "対戦サーバ";

        CONFIG::LOCALE_EN
        private static const _TRANS_CLOSE	:String = "You have left the battle room.";
        CONFIG::LOCALE_EN
        private static const _TRANS_SERVER	:String = "Battle Server";

        CONFIG::LOCALE_TCN
        private static const _TRANS_CLOSE	:String = "對戰大廳以關閉";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SERVER	:String = "對戰服務器";

        CONFIG::LOCALE_SCN
        private static const _TRANS_CLOSE	:String = "对战室已关闭";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SERVER	:String = "对战服务器";

        CONFIG::LOCALE_KR
        private static const _TRANS_CLOSE	:String = "대전룸을 닫았습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_SERVER	:String = "대전 서버";

        CONFIG::LOCALE_FR
        private static const _TRANS_CLOSE	:String = "Vous avez fermé la Salle de Duel";
        CONFIG::LOCALE_FR
        private static const _TRANS_SERVER	:String = "Battle Server";

        CONFIG::LOCALE_ID
        private static const _TRANS_CLOSE	:String = "対戦ルームを閉じました";
        CONFIG::LOCALE_ID
        private static const _TRANS_SERVER	:String = "対戦サーバ";

        CONFIG::LOCALE_TH
        private static const _TRANS_CLOSE   :String = "ปิดห้องประลองแล้ว";
        CONFIG::LOCALE_TH
        private static const _TRANS_SERVER  :String = "เซิฟเวอร์ประลอง";


        private var _command:MatchCommand;
        private var _crypted_sign:String;
        private var _ctrl:MatchCtrl;
        private var _match:Match;
        private var _duel:Duel;

        private static var __instance:MatchServer;

        // 初期化 サーバを取得
        public function MatchServer(caller:Function = null)
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
            _command = new MatchCommand(this);

            // ゲーム用ハートビートを使用する設定に変更
            host.setUseGameHeartBeatFlag();
        }

        private static function createInstance():MatchServer
        {
            return new MatchServer(arguments.callee);
        }

        public static function get instance():MatchServer
        {
            if( __instance == null ){
                __instance = createInstance();
            }
            return __instance;
        }


        protected override function get command():Command
        {
            return _command;
        }

        // 開始
        public function start(ctrl:MatchCtrl):void
        {
            _ctrl= ctrl;
            host.sendCommand(_command.negotiation(player.id));
            log.writeLog(log.LV_DEBUG, this,"game p_session", player.session);
            host.setSessionKey(player.session);
        }

        // 開始
        public override function exit():void
        {
            log.writeLog(log.LV_DEBUG, this,"exit start");
            super.exit()
        }

        // オーバライド前提のGameHeartBeatHandler
        protected override function gameHeartBeatHandler(e:Event):void
        {
            host.sendCommand(_command.csKeepAlive());
        }

        /**
         * 送信コマンド
         *
         */
        // マッチのリストを要求する
        public function csRequestMatchListInfo():void
        {
            log.writeLog(log.LV_INFO, this,"cs RequestChannelList info");
            host.sendCommand(_command.csRequestMatchListInfo());
        }

        // QuickMatchリストにプレイヤーを追加
        public function csAddQuickmatchList(rule:int):void
        {
            log.writeLog(log.LV_INFO, this,"cs Add QuickMatch List User!!", rule);
            host.sendCommand(_command.csAddQuickmatchList(rule));
        }

        // QuickMatchのマッチングをキャンセル依頼
        public function csQuickmatchCancel():void
        {
            log.writeLog(log.LV_INFO, this,"cs QuickMatch Cancel!!");
            host.sendCommand(_command.csQuickmatchCancel());
        }

        // 部屋を作る
        public function csCreateRoomHandler(e:MatchEvent):void
        {
            log.writeLog(log.LV_INFO, this,"cs Create ROOM!!", e.name, e.stage, e.rule);
            host.sendCommand(_command.csCreateRoom(e.name, e.stage, e.rule, 0 , 0));
        }

        // 部屋に入る
        public function csRoomJoin(id:String):void
        {
            log.writeLog(log.LV_INFO, this,"cs Room Join");
            host.sendCommand(_command.csRoomJoin(id));
        }

        // 部屋から出る
        public function csRoomExit(id:String):void
        {
            log.writeLog(log.LV_INFO, this,"cs Exit room");
            host.sendCommand(_command.csRoomExit());
        }

        // 部屋を削除
        public function csRoomDelete(id:String):void
        {
            log.writeLog(log.LV_INFO, this,"cs Delete room");
            host.sendCommand(_command.csRoomDelete(id));
        }

         // 部屋情報を要求
         public function csRequestMatchingInfo():void
         {
//             log.writeLog(log.LV_INFO, this,"cs CardInventorys info");
//             host.sendCommand(_command.csRequestMatchingInfo());
         }


        // マッチ終了
        public function csMatchFinish():void
        {
            log.writeLog(log.LV_INFO, this,"cs match finishi");
            host.sendCommand(_command.csMatchFinish());
        }

        // アチーブメントクリアチェック
        public function csAchievementClearCheck():void
        {
            log.writeLog(log.LV_INFO, this, "cs AchievementClearCheck");
            host.sendCommand(_command.csAchievementClearCheck());
        }

        // フレンドチェック
        public function csRoomFriendCheck(room_id:String, host_avatar_id:int, guest_avatar_id:int):void
        {
            host.sendCommand(_command.csRoomFriendCheck(room_id, host_avatar_id, guest_avatar_id));
        }

        /**
         * 受信コマンド
         *
         */

        // ネゴシエーション処理の返答
        public function negoCert(crypted_sign:String, ok:String):void
        {
            log.writeLog(log.LV_DEBUG, this,"negotiated");
            host.sendCommand(_command.login("yes, ok.",crypted_sign));
        }

        // ログインOK
        public function loginCert(msg:String, hash_key:String):void
        {
            log.writeLog(log.LV_INFO, this,"login cert");
            _match = Match.instance;
            matchStartHandler();
//            _match.addEventListener(Match.START, matchStartHandler);
        }

        // ログイン失敗
        public function loginFail():void
        {
            log.writeLog(log.LV_WARN, this,"Login Failed!!");
        }



        // チャンネルから退出する
        public function scChannelExitSuccess():void
        {
                _match.deleteRoomList();
        }

        // チャンネルから退出する
        public function scChannelJoinSuccess(channelID:int):void
        {
                Channel.currentChannelID = channelID;
                csRequestMatchListInfo();

        }

        // マッチングロビーの部屋の情報を受け取る
        public function scMatchingInfo(info:String):void
        {
            log.writeLog(log.LV_INFO, this,"scMatchingInfo", info);
            _match.initRoomList(arraySeparateNum(24,info.split(",")));
        }


        // 更新された部屋の情報を受け取る
        public function scMatchingInfoUpdate(info:String):void
        {
            log.writeLog(log.LV_INFO, this, "match info update","info:",info);
            _match.updateRoom(info.split(","));

//             _match.updateRoom(id,
//                               name,
//                               stage,
//                               rule,
//                               avatarName.split(','),
//                               string2intArray(avatarLevel),
//                               arraySeparateThree(string2intArray(avatarCc)),
//                               string2intArray(avatarId),
//                               string2intArray(avatarPoint),
//                               string2intArray(avatarWin),
//                               string2intArray(avatarLose),
//                               string2intArray(avatarDraw));
        }

        // 自身が制作した部屋のIDを受け取る
        public function scCreateRoomId(id:String):void
        {
            log.writeLog(log.LV_INFO, this, "create id is", id);
            _match.createSuccess(id);
        }

        // 削除された部屋のIDを受け取る
        public function scDeleteRoomId(id:String):void
        {
            log.writeLog(log.LV_INFO, this, "delete id is", id);
            _match.deleteRoom(id);
            // 自分のカレントルームだったら閉じる
            if (_match.currentRoomId == id&&(!Channel.list[Channel.current].isRadder) )
            {
                _ctrl.waitingForceStop();
                WaitingPanel.hide();
            }
        }
        public function scRoomExitSuccess():void
        {
            _ctrl.waitingForceStop();
            WaitingPanel.hide();
//            Alerter.showWithSize("対戦ルームを閉じました","対戦サーバ");
//            Alerter.showWithSize(_TRANS_CLOSE,_TRANS_SERVER);
        }


        public function scMatchJoinOk(id:String):void
        {

            log.writeLog(log.LV_FATAL, this, "join ok", id);
            DuelCtrl.instance.matchStart(id);
        }

        public function scQuickmatchJoinOk(id:String):void
        {
            log.writeLog(log.LV_FATAL, this, "quickmatch join ok", id);
            Match.instance.setQuickCurrentRoomId(id);
        }

        public function scQuickmatchCancel():void
        {
            log.writeLog(log.LV_FATAL, this, "CancelIsSuccel");
            _ctrl.quickmatchCancel(true);
        }

        public function scQuickmatchRegistOk():void
        {
            log.writeLog(log.LV_FATAL, this, "QuikcMatchRegist OK");
        }


//         // ゲームのセッションの決定
//         public function scDetermineSession(id:int, foe:String, playerCharaID:String, foeCharaID:String, startDialogue:String):void
//         {
//             log.writeLog(log.LV_INFO, this,"Determine GameSession", id, foe,"plccid:", playerCharaID,"foeccid:",foeCharaID,"starDialogue:", startDialogue);
//             Dialogue.instance.setMessage(startDialogue);
//             _duel = Duel.instance;
//             // チャットコントローラに決定済みの
//             ChatCtrl.instance.foeID = id;
// //             _duel.addEventListener(Duel.START, duelStartHandler);
// //             _duel.addEventListener(Duel.END, duelEndHandler);
// //             _duel.initialize(string2intArray(playerCharaID),string2intArray(foeCharaID));
//         }


        public function scUpdateCount(num:int):void
        {
            log.writeLog(log.LV_WARN, this, "channel count is +++ ",num);
        }

        //
        public function scAchievementClear(achiID:int, itemType:int, itemID:int, itemNum:int, cType:int):void
        {
            log.writeLog(log.LV_INFO, this, "scAchievementClear", achiID, itemType, itemID, itemNum, cType);
            LobbyNotice.setAchievementSuccessInfo(achiID, itemType, itemID, itemNum, cType);
            AchievementInventory.finishAchievementInventory(achiID);
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

        public function scRoomFriendInfo(roomId:String, hostIsFriend:Boolean, guestIsFriend:Boolean):void
        {
            Match.instance.updateRoomFriendInfo(roomId, hostIsFriend, guestIsFriend);
        }


        // ==============
        // Error
        // ==============
        // エラーウインドを出す
        public function scErrorNo(e:int):void
        {

            log.writeLog(log.LV_WARN, this,"Error no is", e);
            WaitingPanel.hide();
            _ctrl.errorAlert(e);

        }
        public function scKeepAlive():void
        {
            log.writeLog(log.LV_WARN, this, "HEART BEAT. +++");
        }



        // ==============
        // Handler
        // ==============

        // Matchが初期化された場合のイベントハンドラ
        private function matchStartHandler():void
        {
            // Matchのイベントをリッスン
            _match.addEventListener(MatchEvent.CREATE_ROOM, csCreateRoomHandler);
        }

        // Matchが終了した場合のイベントハンドラ
        private function matchEndHandler(e:Event):void
        {
            // Matchのイベントをはずす
            _match.removeEventListener(MatchEvent.CREATE_ROOM, csCreateRoomHandler);
        }


    }

}