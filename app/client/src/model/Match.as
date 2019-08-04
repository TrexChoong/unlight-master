package model
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import model.events.MatchEvent;
    import model.events.MatchButtonEvent;
    import model.events.MatchRoomFriendEvent;
    import model.Player;
    import model.FriendLink;
    import net.server.GameServer;

    /**
     * マッチングロビー管理クラス
     *
     */
    public class Match extends BaseModel
    {
        // インスタンス
        private static var __instance:Match;                                  // シングルトンインスタンス

        // 選択中の部屋のID
        private var _currentRoomId:String;
        // フォーカス中の部屋のID
        private var _overRoomId:String;

        // チャンネルID
        private var _currentChannelId:int = -1;

        // イベント
        public static const START:String  = 'start';                          // ゲームロビーを開始
        public static const END:String    = 'end';                            // ゲームロビーを終了
        public static const LOADING:String    = 'loading';                    // ローディングを知らせる
        public static const ROOM_OVER:String  = 'room_over';                  // 部屋に触れた時のイベント
        public static const ROOM_OUT:String  = 'room_out';                    // 部屋から離れた時のイベント
        public static const ROOM_CLICK:String = 'room_click';                 // 部屋を選択した時のイベント
        public static const CONNECT_CANCEL:String = 'connect_cancel';         // マッチをキャンセルした時のイベント
        public static const RECONNCT:String = 'reconnect';                    // デュエル後再接続時のイベント
        private var _isQuick:Boolean = false;

        /**
         * シングルトンインスタンスを返すクラス関数
         *
         */
        public static function get instance():Match
        {
            if( __instance == null )
            {
                __instance = createInstance();
            }
            return __instance;
        }

        // 本当のコンストラクタ
        private static function createInstance():Match
        {
            return new Match(arguments.callee);
        }

        /**
         * コンストラクタ
         * シングルトンなので外から呼び出すと例外
         *
         */
        public function Match(caller:Function=null)
        {
            if(caller != createInstance) throw new ArgumentError("Cannot user access constructor.");
            log.writeLog (log.LV_INFO,this,"create new Match instance.");
        }

        // 初期化
        public function initialize():void
        {
            // 選択中の部屋IDを初期化
            _currentRoomId = "-1";
            _overRoomId = "-1";
            _currentChannelId = -1;


            // サーバー側でイベントを登録
            dispatchEvent(new Event(START));
        }

        // 後処理
        public function finalize():void
        {
            // サーバー側でイベントを消去
            dispatchEvent(new Event(END));
        }

        // 部屋を初期化する
        // avatar*はArrayのArrayなんで注意
//        public function initRoomList(id:Array, name:Array, stage:Array, rule:Array, avatarName:Array, avatarLevel:Array, avatarCcId:Array, avatarId:Array, avatarPoint:Array, avatarWin:Array, avatarLose:Array, avatarDraw:Array):void
        public function initRoomList(info:Array):void
        {
            MatchRoom.clearRoomList();
            var roomInfo:Array; /* of strmentType */ 

            // 全ての部屋を更新
            for(var i:int = 0; i < info.length; i++)
            {
                roomInfo = info[i];
                // 不正なIDなら処理しない かつ　ブロック済みなら処理しない
                if(roomInfo[0] != "-1" && !blockCheck([int(roomInfo[4]),int(roomInfo[14])]) )
                {
                    new MatchRoom(roomInfo[0], // id
                                  roomInfo[1], // room_name
                                  roomInfo[2], // stage_no
                                  roomInfo[3], // rule
                                  [int(roomInfo[4]),int(roomInfo[14])], // avatar_id set
                                  [roomInfo[5].replace("_rename",""),roomInfo[15].replace("_rename","")],           // avatar_name set
                                  [int(roomInfo[6]),int(roomInfo[16])], // avatar_level set
                                  [int(roomInfo[7]),int(roomInfo[17])], // avatar_point set
                                  [int(roomInfo[8]),int(roomInfo[18])], // avatar_win set
                                  [int(roomInfo[9]),int(roomInfo[19])], // avatar_lose set
                                  [int(roomInfo[10]),int(roomInfo[20])], // avatar_draw set
                                  [[int(roomInfo[11]),int(roomInfo[12]),int(roomInfo[13])],[int(roomInfo[21]),int(roomInfo[22]),int(roomInfo[23])]] // avatar_cc set
                        )
                }
            }
            _loaded = true;
            notifyAll();
            dispatchEvent(new MatchEvent(MatchEvent.INIT));
        }

        // ブロックされたかチェック
        private function blockCheck(avatarIDs:Array):Boolean
        {
            // ラダーマッチの時ブロックを無視する
            if(Channel.list[Channel.current].isRadder)
            {
                return false;
            }

            // 自分がらみはブロックを無視する
            if (avatarIDs[0] == Player.instance.avatar.id ||avatarIDs[1] == Player.instance.avatar.id )
            {
                return false;
            }

            // ブロックのチェック
            var fl:FriendLink;
            fl = FriendLink.getLink(int(avatarIDs[0]));
            if (fl != null && fl.isBlock)
            {
                return true;
            }
            fl = FriendLink.getLink(int(avatarIDs[1]));
            if (fl != null && fl.isBlock)
            {
                return true;
            }
            return false;
        }

        // 全ての部屋を削除する
        public function deleteRoomList():void
        {
            // ルームを消す
            _loaded = false;
            MatchRoom.clearRoomList();
            dispatchEvent(new MatchEvent(MatchEvent.EXIT));
        }

        // 新しい部屋を作成
        public function createRoom(name:String, stage:int, rule:int):void
        {
            dispatchEvent(new MatchEvent(MatchEvent.CREATE_ROOM, "", name, stage, rule));
        }

        // 新しい部屋を作成
        public function createCpuRoom(name:String, stage:int, rule:int):void
        {
            dispatchEvent(new MatchEvent(MatchEvent.CREATE_CPU_ROOM, "", name, stage, rule));
        }

        // IDの部屋に入室
        public function joinRoom(roomId:String):void
        {
            dispatchEvent(new MatchEvent(MatchEvent.JOIN_ROOM, roomId));
        }

        // 部屋から抜ける
        public function exitRoom():void
        {
            dispatchEvent(new MatchEvent(MatchEvent.EXIT_ROOM));
        }

        // 特定の部屋をアップデートする
        public function updateRoom(info:Array):void
        {
            // IDが存在しない場合あたらしく追加を行い、IDが存在する場合部屋をアップデート
            if (MatchRoom.list[info[0]]==null)
            {
                // ブロック済みならなにもしない、ただし、ラダーマッチの場合はそのまま進める  かつ自分がらみもそのまま進める
                if(!blockCheck([int(info[4]),int(info[14])]))
                {
                    new MatchRoom(
                    info[0], // id
                    info[1], // room_name
                    info[2], // stage_no
                    info[3], // rule
                    [int(info[4]),int(info[14])], // avatar_id set
                    [info[5].replace("_rename",""),info[15].replace("_rename","")],           // avatar_name set
                    [int(info[6]),int(info[16])], // avatar_level set
                    [int(info[7]),int(info[17])], // avatar_point set
                    [int(info[8]),int(info[18])], // avatar_win set
                    [int(info[9]),int(info[19])], // avatar_lose set
                    [int(info[10]),int(info[20])], // avatar_draw set
                    [[int(info[11]),int(info[12]),int(info[13])],[int(info[21]),int(info[22]),int(info[23])]]
                    );
                }
            }else{
                // ブロックされていたら削除、ただし、ラダーマッチの場合はなにもしない
                if(blockCheck([int(info[4]),int(info[14])]) )
                {
                    deleteRoom(info[0]);
                }else{
                    MatchRoom.list[info[0]].updateRoom(
                    info[1], // room_name
                    info[2], // stage_no
                    info[3], // rule
                    [int(info[4]),int(info[14])], // avatar_id set
                    [info[5].replace("_rename",""),info[15].replace("_rename","")],           // avatar_name set
                    [int(info[6]),int(info[16])], // avatar_level set
                    [int(info[7]),int(info[17])], // avatar_point set
                    [int(info[8]),int(info[18])], // avatar_win set
                    [int(info[9]),int(info[19])], // avatar_lose set
                    [int(info[10]),int(info[20])], // avatar_draw set
                    [[int(info[11]),int(info[12]),int(info[13])],[int(info[21]),int(info[22]),int(info[23])]]
                    );
                }
            }

                if(!blockCheck([int(info[4]),int(info[14])]) )
                {
                    dispatchEvent(new MatchEvent(MatchEvent.UPDATE_ROOM, info[0]));
                    if( _currentRoomId == info[0]&&(!Channel.list[Channel.current].isRadder))
                    {
                        dispatchEvent(new Event(ROOM_CLICK));

                    };
                }

        }

        public function updateRoomFriendInfo(roomId:String, hostIsFriend:Boolean, guestIsFriend:Boolean):void
        {
            dispatchEvent(new MatchRoomFriendEvent(MatchRoomFriendEvent.UPDATE, roomId, hostIsFriend, guestIsFriend));
        }

        // 部屋を作ることに成功
        public function createSuccess(id:String):void
        {
            _currentRoomId = id;
            if(Channel.list[Channel.current].isRadder)
            {
                _isQuick = true;
            }else{
                _isQuick = false;
            }
            dispatchEvent(new MatchEvent(MatchEvent.CREATE_SUCCESS, id));
        }

        // IDで指定した部屋を削除する
        public function deleteRoom(id:String):void
        {
            // IDの部屋を消去する処理
            if(MatchRoom.list[id])
            {
                MatchRoom.list[id].deleteRoom();
                dispatchEvent(new MatchEvent(MatchEvent.DELETE_ROOM, id));
            }
            if( _currentRoomId == id){dispatchEvent(new MatchEvent(MatchEvent.EXIT_ROOM));};

        }

        // マッチをキャンセルしたことを知らせる
        public function connectChancel():void
        {
            dispatchEvent(new Event(CONNECT_CANCEL));
        }

        // 選択中ルームのIDを取得する
        public function get currentRoomId():String
        {
            return _currentRoomId;
        }

        // 選択中ルームのIDを設定する
        public function set currentRoomId(id:String):void
        {
            _currentRoomId = id;
            _isQuick =false;
            dispatchEvent(new Event(ROOM_CLICK));
        }
        // 選択中ルームのIDを設定する
        public function setQuickCurrentRoomId(id:String):void
        {
            _currentRoomId = id;
            _isQuick = true;
        }

        public function get isQuick():Boolean
        {
            return  _isQuick;
        }
        // 選択中ルームのIDを取得する
        public function get overRoomId():String
        {
            return _overRoomId;
        }

        // ローディング中を知らせる
        public function loading(id:int):void
        {
            _currentChannelId = id;
            dispatchEvent(new Event(LOADING));
        }

        // チャンネルIDを取得
        public function get currentChannelId():int
        {
            return _currentChannelId;
        }

        // 選択中ルームのIDを設定する
        public function set overRoomId(id:String):void
        {
            if(id == "-1"||id == "")
            {
                _overRoomId = id;
                dispatchEvent(new Event(ROOM_OUT));
            }
            else
            {
                _overRoomId = id;
                dispatchEvent(new Event(ROOM_OVER));
            }
        }

        // デュエル後の再接続時のイベント
        public function reconnect():void
        {
            dispatchEvent(new Event(RECONNCT));
        }

    }
}