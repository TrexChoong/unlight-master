
package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import flash.events.IEventDispatcher;

    import flash.utils.ByteArray;

    import model.events.AvatarQuestEvent;
    import controller.QuestCtrl;

    // インベントリつきのアバタークエストクラス
    public class AvatarQuestInventory extends BaseModel
    {
        public static const STATUS_UPDATE:String = "status_update";
        public static const FIND_AT_UPDATE:String = "find_at_update";
        private var _inventoryID:int;            // 固有のインベントリID
        private var _quest:Quest;    // アバターのクエスト
        private var _findAt:Date;    // アバターのクエスト
        private var _baName:String = null; // BeforeAvatarName
        private var _status:int      // クエストの状態

        private static var __quests:Array = [];      // Array of AvatarQuestInventory

        private static var _ctrl:QuestCtrl = QuestCtrl.instance;  // ロビーのコントローラー


        public static function initializeInventory():void
        {
            __quests = []
        }

        public static function get quests():Array
        {
            return __quests;
        }

        // AvatarQuestIDでソート
        public static function sortAvatarQuestId():void
        {
            __quests.sortOn("questId", Array.NUMERIC);
        }

        // 種類をソートしたのち、指定した種類のアバタークエスト配列を返す
        public static function getTypeQuests(type:int):Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < __quests.length; i++)
            {
                if(__quests[i].quest.type == type)
                {
                    ret.push(__quests[i]);
                }
            }
            return ret;
        }

        // 指定したIDのクエストのインベントリを取得
        public static function getInventory(id:int):int
        {
            for(var i:int; i < __quests.length; i++)
            {
                if(__quests[i].quest.id == id)
                {
                    return __quests[i].inventoryID
                }
            }
            return -1;
        }

        // クエストを追加
        public static function addAvatarQuestInventory(inv_id:int, ai:Quest, timer:int,pow:int,qs:int = Const.QS_NEW, baName:String='n'):void
        {
            log.writeLog(log.LV_FATAL, "Quest inventory ", timer,qs);
            if (ID(inv_id)==null)
            {
                if (timer == 0)
                {
                    _ctrl.getQuestSuccess(new AvatarQuestInventory(inv_id, ai, 0, qs, baName));
                }else{
                    _ctrl.getQuestSuccess(new AvatarQuestInventory(inv_id, ai, int(Const.QFT_SET[timer]*60*(pow/100)), Const.QS_PENDING, baName));
                }
            }
        }
        // 指定したIDのインベントリを取得
        public static function ID(id:int):AvatarQuestInventory
        {
            for(var i:int; i < __quests.length; i++)
            {
                if(__quests[i].inventoryID == id)
                {
                    return __quests[i]
                }
            }
            return null;
        }

        // クエストを削除
        public static function removeAvatarQuestInventory(inv_id:int):void
        {
            var deleteIndex:int = -1;

            for(var i:int; i < __quests.length; i++)
            {
                if(__quests[i].inventoryID == inv_id)
                {
                    deleteIndex = i;
                    break;
                }
            }
            if (deleteIndex > -1)
            {
                _ctrl.useQuestSuccess(__quests.splice(deleteIndex, 1)[0].inventoryID);
            }
        }

        // コンストラクタ
        public function AvatarQuestInventory(inv_id:int, ai:Quest, timer:int, status:int = Const.QS_NEW, baName:String = Const.QUEST_PRESENT_AVATAR_NAME_NIL)
        {
            var now:Date = new Date();
            _inventoryID = inv_id;
            _quest = ai;
            _status = status;
            _findAt = new Date(now.getTime()+timer*1000);
            _baName = baName.replace("_rename","");
            log.writeLog(log.LV_FATAL, this, "QUEST inventory ", _status, timer);
            __quests.push(this);
        }


        // インベントリIDを取得
        public function get inventoryID():int
        {
            return _inventoryID;
        }
        // アバタークエストを取得
        public function get quest():Quest
        {
            return _quest;
        }
        // クエストIDを取得
        public function get questId():int
        {
            return _quest.id;
        }

        public function get status():int
        {
            return _status;
        }
        public function set status(i:int):void
        {
            if (_status != i)
            {
                _status = i;
                dispatchEvent(new Event(STATUS_UPDATE));
            }

        }

        public function get baName():String
        {
            return _baName;
        }

        public function updateFindAt(t:int):void
        {
            var now:Date = new Date();
            _findAt = new Date(now.getTime()+t*1000);
            dispatchEvent(new Event(FIND_AT_UPDATE));
        }


        public function findQuest(qid:int):void
        {
            _quest = Quest.ID(qid);
            log.writeLog(log.LV_FATAL, this, "findQuest ", _status, _quest);
        }

        public function get getRemainTime():int
        {
            var now:Date = new Date();
            var ret:int = int((_findAt.getTime()-now.getTime()));

            if (ret<0)
            {
                return 0;
            }else{
                return ret;
            }

        }

        public static function get findingNum():int
        {
            var fNum:int = 0;
            for(var i:int = 0; i < __quests.length; i++)
            {
              var x:AvatarQuestInventory = __quests[i];
                if (x.getRemainTime>0)
                {
                    fNum +=1;
                }
            }
            return fNum;
        }

    }
}