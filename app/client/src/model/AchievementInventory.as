package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import flash.events.IEventDispatcher;

    import flash.utils.ByteArray;

//     import model.events.AchievementEvent;
    import view.*;
    import controller.*;

    // インベントリつきのアバターアイテムクラス
    public class AchievementInventory extends BaseModel
    {
        private var _achievement:Achievement;    // アチーブメント
        private var _state:int;                  // 状態
        private var _progress:String;            // 達成度
        private var _endAtTime:Date;             // 終了時間
        private var _endAtTimeStr:String = "";   // 終了時間:String
        private var _code:String = "";        // 専用コード

        private static var __items:Array = [];      // Array of AchievementInventory

        private static var _ctrl:LobbyCtrl = LobbyCtrl.instance;  // ロビーのコントローラー


        public static function initializeInventory():void
        {
            __items = []
        }

        public static function get items():Array
        {
            return __items;
        }

        // 指定した種類のアチーブメントインベントリ配列を返す
        public static function getKindAchievements(kind:int):Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < __items.length; i++)
            {
                if(__items[i].achievement.kind == kind)
                {
                    ret.push(__items[i]);
                }
            }
            return ret;
        }

        // 指定したIDのアチーブメントのインベントリを取得
        public static function getInventory(id:int):AchievementInventory
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].achievement.id == id)
                {
                    return __items[i]
                }
            }
            return __items[0];
        }


        // アチーブメントを追加
        public static function addAchievementInventory(aid:int, state:int):void
        {
            new AchievementInventory(aid, state);
//            _ctrl.getItemSuccess(ai.id);
        }

        // アチーブメントが完了
        public static function finishAchievementInventory(a_id:int):void
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].achievement.id == a_id)
                {
                    __items[i].finishAchievement()
                }
            }
        }

        // アチーブメントを削除
        public static function deleteAchievementInventory(a_id:int):void
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].achievement.id == a_id)
                {
                    __items[i].state = Const.ACHIEVEMENT_STATE_FAILED;
//                    __items.splice(i, 1);
                }
            }
        }

        // アチーブメントを削除（配列から削除）
        public static function dropAchievementInventory(a_id:int):void
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].achievement.id == a_id)
                {
                    __items.splice(i, 1);
                }
            }
        }

        // コンストラクタ
        public function AchievementInventory(aid:int, state:int, progress:String = "0", endAt:String = "", c:String = "")
        {
            _achievement = Achievement.ID(aid);
            log.writeLog(log.LV_WARN, this, "constructa", _achievement);
            _state = state;
            _progress = progress;
            endAtTime = endAt;
            _code = c;
            __items.push(this);
            __items.sort();
            __items.sortOn("achievementId", Array.NUMERIC);
        }

        // インベントリIDを取得
        public function get state():int
        {
            return _state;
        }

        // インベントリIDを取得
        public function set state(i:int):void
        {
            _state = i;
        }
        // アチーブメントを取得
        public function get achievement():Achievement
        {
            return _achievement;
        }
        // アチーブメントのIDを取得
        public function get achievementId():int
        {
            return _achievement.id;
        }
        // アチーブメントのKindを取得
        public function get achievementKind():int
        {
            return _achievement.kind;
        }

        // 達成度を取得
        public function get progress():String
        {
            return _progress;
        }

        // 達成度を設定
        public function set progress(progress:String):void
        {
            _progress = progress;
        }

        // 達成度を取得
        public function get code():String
        {
            return _code;
        }

        // 達成度を設定
        public function set code(code:String):void
        {
            _code = code;
        }

        // 終了時間を取得:Date
        public function get endAtTimeDate():Date
        {
            return _endAtTime;
        }

        // 終了時間を取得:String
        public function get endAtTimeStr():String
        {
            return _endAtTimeStr;
        }

        // 終了時間を設定
        public function set endAtTime(endAt:String):void
        {
            if (endAt != "")
            {
                _endAtTime = new Date(endAt);
                _endAtTimeStr = TimeFormat.transDateStr(_endAtTime);
            } else {
                _endAtTime = null;
                _endAtTimeStr = endAt;
            }
        }

        // アチーブメントが達成
        public function finishAchievement():void
        {
            _state = Const.ACHIEVEMENT_STATE_FINISH;
        }


    }
}