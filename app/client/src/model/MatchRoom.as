package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;

    // マッチルームクラス
    public class MatchRoom
    {
        private static var __currentStartedRoom:MatchRoom;
        private var _id:String;             // 部屋のID
        private var _name:String;           // ルーム名
        private var _stage:int;             // ステージ番号
        private var _rule:int;              // ルール
        private var _avatarName:Array;      // Array of String
        private var _avatarLevel:Array;     // Array of int
        private var _avatarCcId:Array;      // Array of int
        private var _avatarId:Array;      // Array of int
        private var _avatarPoint:Array;      // Array of String
        private var _avatarWin:Array;     // Array of int
        private var _avatarLose:Array;      // Array of int
        private var _avatarDraw:Array;      // Array of int

        public static var list:Object = {};   // Hash of MatchRoom

        public static function clearRoomList():void
        {
            list = {};
        }

        // コンストラクタ
        public function MatchRoom(id:String,
                                  name:String,
                                  stage:int,
                                  rule:int,
                                  avatarId:Array,
                                  avatarName:Array,
                                  avatarLevel:Array,
                                  avatarPoint:Array,
                                  avatarWin:Array,
                                  avatarLose:Array,
                                  avatarDraw:Array,
                                  avatarCcId:Array)
        {
            _id = id;
            _name = name;
            _stage = stage;
            _rule = rule;
            _avatarName = avatarName;
            _avatarLevel = avatarLevel;
            _avatarCcId = avatarCcId;
            _avatarId = avatarId;
            _avatarPoint = avatarPoint;
            _avatarWin = avatarWin;
            _avatarLose = avatarLose;
            _avatarDraw = avatarDraw;

            log.writeLog(log.LV_INFO, this, "matchrooom!!!", avatarName, avatarLevel, avatarCcId,avatarId,avatarPoint,avatarWin,avatarLose,avatarDraw);

            list[id] = this;
            deleteBlockAvatarRoom();
        }

        // 部屋を更新する
        public function updateRoom(name:String, stage:int, rule:int, avatarId:Array, avatarName:Array, avatarLevel:Array, avatarPoint:Array, avatarWin:Array, avatarLose:Array, avatarDraw:Array, avatarCcId:Array):void
        {
            _name = name;
            _stage = stage;
            _rule = rule;
            _avatarName = avatarName;
            _avatarLevel = avatarLevel;
            _avatarCcId = avatarCcId;
            _avatarId = avatarId;
            _avatarPoint = avatarPoint;
            _avatarWin = avatarWin;
            _avatarLose = avatarLose;
            _avatarDraw = avatarDraw;
            deleteBlockAvatarRoom();
        }

        // ブロックしているデータを削除
        private function deleteBlockAvatarRoom():void
        {
            
            // if (FriendLink.getBlockNameList().hasOwnProperty(_avatarName[0]) || FriendLink.getBlockNameList().hasOwnProperty(_avatarName[1]))
            // {
            //     MatchRoom.list[this.id] = null;
            // }
        }

        // 部屋を消去する
        public function deleteRoom():void
        {
            // 自分で消去している可能性があるので（ブロック機能により）
            if (MatchRoom.list[this.id] !=null)
            {
                MatchRoom.list[this.id] = null;
            }
        }

        // 部屋の長さを返す
        public static function get hashLength():int
        {
            var count:int = 0
            for(var key:String in MatchRoom.list)
            {
                if(MatchRoom.list[key])
                {
                    count++;
                }
            }
            return count;
        }

        // 部屋内の人数を返す
        public function get length():int
        {
            var count:int = 0;
            for(var i:int = 0; i < _avatarLevel.length; i++)
            {
                if(_avatarLevel[i] != -1)
                {
                    count++;
                }
            }
            return count;
        }

        public static function get currentStartedRoom ():MatchRoom
        {
            return __currentStartedRoom;
            
        }

        public static function registCurrentStartedRoom ():void
        {
            __currentStartedRoom = MatchRoom.list[Match.instance.currentRoomId];
        }



        public function get id():String
        {
            return _id;
        }
        public function get name():String
        {
            return _name;
        }
        public function get stage():int
        {
            return _stage;
        }
        public function get rule():int
        {
            return _rule;
        }
        public function get avatarName():Array
        {
            return _avatarName;
        }
        public function get avatarLevel():Array
        {
            return _avatarLevel;
        }
        public function get avatarCcId():Array
        {
            return _avatarCcId;
        }
        public function get avatarId():Array
        {
            return _avatarId;
        }
        public function get avatarPoint():Array
        {
            return _avatarPoint;
        }
        public function get avatarWin():Array
        {
            return _avatarWin;
        }
        public function get avatarLose():Array
        {
            return _avatarLose;
        }
        public function get avatarDraw():Array
        {
            return _avatarDraw;
        }
    }
}