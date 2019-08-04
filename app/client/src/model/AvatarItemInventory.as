
package model
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    import flash.events.IEventDispatcher;

    import flash.utils.ByteArray;

    import model.events.AvatarItemEvent;
    import view.*;
    import controller.*;

    // インベントリつきのアバターアイテムクラス
    public class AvatarItemInventory extends BaseModel
    {
        private var _inventoryID:int;            // 固有のインベントリID
        private var _avatarItem:AvatarItem;    // アバターのアイテム
        private var _state:int;

        private static var __items:Array = [];      // Array of AvatarItemInventory

        private static var _ctrl:LobbyCtrl = LobbyCtrl.instance;  // ロビーのコントローラー

        private static var __resultImages:Object = {};  // 選択中のリザルトイメージリスト
        public static var ITEM_STATE_NOT_USE:int = 0;
        public static var ITEM_STATE_USING:int = 1;
        public static var ITEM_STATE_USED:int = 2;


        public static function initializeInventory():void
        {
            __items = []
        }

        public static function get items():Array
        {
            return __items;
        }

        // 選択されているリザルト画像を取得
        public static function get resultImages():Object
        {
            return __resultImages;
        }

        // AvatarItemIDでソート
        public static function sortAvatarItemId():void
        {
            __items.sortOn("avatarItemId", Array.NUMERIC);
        }

        // itemのタイプ(kind)で降順ソート
        public static function sortAvatarItemType():void
        {
            __items.sortOn("avatarItemType", Array.NUMERIC|Array.DESCENDING);
        }

        // 種類をソートしたのち、指定した種類のアバターアイテム配列を返す
        public static function getTypeItems(type:int):Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < __items.length; i++)
            {
                if(__items[i].avatarItem.type == type)
                {
                    ret.push(__items[i]);
                }
            }
            return ret;
        }

        // 指定したIDのアイテムのインベントリを取得
        public static function getInventory(id:int):int
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].avatarItem.id == id)
                {
                    return __items[i].inventoryID
                }
            }
            return -1;
        }

        // インベントリIDでソートしてアイテムを取得
        public static function getAvatarItem(inv_id:int):AvatarItem
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].inventoryID == inv_id)
                {
                    return __items[i].avatarItem;
                }
            }
            return AvatarItem.ID(1);
        }

        // アイテムを追加
        public static function addAvatarItemInventory(inv_id:int, ai:AvatarItem):void
        {
            new ModelWaitThread(ai,sendAddAvatarItemInventory,[inv_id, ai]).start();
        }
        private static function sendAddAvatarItemInventory(inv_id:int, ai:AvatarItem):void
        {
            new AvatarItemInventory(inv_id, ai);
            _ctrl.getItemSuccess(ai.id);
        }

        // アイテムを削除
        public static function removeAvatarItemInventory(inv_id:int):void
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].inventoryID == inv_id)
                {
                    var avi:AvatarItemInventory = __items.splice(i, 1)[0];
                    _ctrl.useItemSuccess(avi.avatarItem.id);
                    QuestCtrl.instance.useItemSuccess(avi.avatarItem.id);
                    i--;
                }
            }
        }

        //指定したアバターアイテムの数を返す
        public static function getItemsNum(id:int):int
        {
            var count:int = 0;
            var num :int =  __items.length
            for(var i:int = 0; i < num; i++)
            {
                if(__items[i].avatarItem.id == id)
                {
                    count ++;
                }
            }
            log.writeLog(log.LV_INFO, "aii", "len", count, num);
            return count;
        }








        // コンストラクタ
        public function AvatarItemInventory(inv_id:int, ai:AvatarItem, state:int=0)
        {
            _inventoryID = inv_id;
            _avatarItem = ai;
            _state = state;
            //log.writeLog(log.LV_DEBUG, this, "AvatarItemInventory", ai.id,ai);

            __items.push(this);

            if (ai.type == AvatarItem.ITEM_RESULT)
            {
                var charactorId:int = int(ai.cond);
                __resultImages[charactorId]=_state;
            }
        }

        public static function changeResultImage(charactorId:int, imageNo:int):void
        {
            if (imageNo == 0)
            {
                __resultImages[charactorId] = ITEM_STATE_NOT_USE;
            }
            else
            {
                __resultImages[charactorId] = ITEM_STATE_USING;
            }
        }

        // インベントリIDを取得
        public function get inventoryID():int
        {
            return _inventoryID;
        }
        // アバターアイテムを取得
        public function get avatarItem():AvatarItem
        {
            return _avatarItem;
        }
        // アイテムIDを取得
        public function get avatarItemId():int
        {
            return _avatarItem.id;
        }
        // アイテムNoを取得
        public function get avatarItemNo():int
        {
            return _avatarItem.no;
        }
        // アイテムの種類を取得
        public function get avatarItemType():int
        {
            return _avatarItem.type;
        }
        // 使用状態を取得
        public function get state():int
        {
            return _state;
        }



    }
}