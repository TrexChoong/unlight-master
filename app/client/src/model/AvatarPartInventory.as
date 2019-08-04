
package model
{
    import flash.utils.*;
    import flash.events.*;
    import flash.utils.ByteArray;
    import org.libspark.thread.Thread;
    import org.libspark.thread.*;

    import view.*;
    import controller.*;

    // インベントリつきのアバターパーツクラス
    public class AvatarPartInventory
    {
        private var _inventoryID:int;            // 固有のインベントリID

        private var _avatarPart:AvatarPart;    // アバターのパーツ


        private var _used:int = 0;       // 使用フラグ
        private var _endAt:Date;    // アイテムが無くなってしまうまでの時間

        public static var __items:Array = [];      // Array of AvatarPartInventory
        public static var __dic:Object = {};      // Array of AvatarPartInventory

        private static var __remainTimeSet:Array = [];
        private static var __lastTimerDate:Date;
        private static var __waitThread:Thread;

        public static function initializeInventory():void
        {
            __items = []
        }

        public static function get items():Array
        {
            return __items;
        }

        // AvatarPartIDでソート
        public static function sortAvatarPartId():void
        {
            __items.sortOn("avatarPartId", Array.NUMERIC);
        }

        // タイプでソートでソート
        public static function sortType():void
        {
            __items.sort(sortByPartsType);
        }

        // 所持パーツのIDリストを取得
        public static function getPartIdList():Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < __items.length; i++)
            {
                ret.push(__items[i].avatarPartId);
            }
            return ret;
        }

        public static function ID(id:int): AvatarPartInventory
        {
            return __dic[id];
        }

        public static function vanish(id:int):void
        {
//            log.writeLog(log.LV_WARN, "AvatarPartInventory", "vanish part",__dic[id]);

            var delIndex:int = -1;
            for(var i:int = 0; i < __items.length; i++)
            {
                if(__items[i] == __dic[id])
                {
                    delIndex = i;
                    break;
                }
            }
            if (delIndex != -1)
            {
//                log.writeLog(log.LV_WARN, "AvatarPartInventory", "delete index", i);
                __items.splice(delIndex,1);
            }

            delete __dic[id];
        }

        private static function sortByPartsType(a:AvatarPartInventory,b:AvatarPartInventory):int
        {
            if (a.avatarPart.type > b.avatarPart.type)
            {
                return -1;
            }
            else if (a.avatarPart.type < b.avatarPart.type)
            {
                return 1;
            }
            else
            {
                return 0;
            }

        }

        public static function getPartsInventoryID(ap:AvatarPart):int
        {
            var ret:int = 0;

            for(var i:int = 0; i < __items.length; i++)
            {
                if(__items[i].avatarPart == ap)
                {
                    ret = __items[i].inventoryID;
                    break;
                }
            }
            return ret;

        }

        public static function getPartsInventory(ap:AvatarPart):AvatarPartInventory
        {
            var ret:AvatarPartInventory;

            for(var i:int = 0; i < __items.length; i++)
            {
                if(__items[i].avatarPart == ap)
                {
                    ret = __items[i];
                    break;
                }
            }
            return ret;

        }

        // 種類をソートしたのち、指定した種類のアバターパーツ配列を返す
        public static function getTypeItems(type:int):Array
        {
            var ret:Array = [];
            for(var i:int = 0; i < __items.length; i++)
            {
                if(__items[i].avatarPart.type == type)
                {
                    ret.push(__items[i]);
                }
            }

            return ret;
        }

        // 種類をソートしたのち、指定したジャンルのアバターパーツ配列を返す
        public static function getGenreItems(genre:int):Array
        {
            var typeFrom:int = AvatarPart.PARTS_GENRE_ID[genre];
            var typeEnd:int = AvatarPart.PARTS_GENRE_ID[genre]+10;
//            log.writeLog(log.LV_FATAL, "AvatarPartsInventory:Static"   , "get gnere items!", __items.length,"genre:",genre);
            var ret:Array = [];
            for(var i:int = 0; i < __items.length; i++)
            {
                if(__items[i].avatarPart.type >= typeFrom && __items[i].avatarPart.type < typeEnd)
                {
                    ret.push(__items[i]);
                }
            }
//            log.writeLog(log.LV_FATAL, "AvatarPartsInventory:Static"   , "get gnere items!!!",ret);
            return ret;
        }

        private function setEndAt(endAt:int):void
        {
//            log.writeLog(log.LV_INFO, this, "setEndAt", endAt);
            if (endAt>0)
            {
//                log.writeLog(log.LV_INFO, this, "setEndAt date start");
                var now:Date = new Date();
                _endAt = new Date(now.getTime()+endAt*1000);

//                log.writeLog(log.LV_INFO, this, "setEndAt date", _endAt,__remainTimeSet.length);

                var added:Boolean = true;
                // 今までにスタックされたdateに10秒以下の差のものがあれば足さない
                for(var i:int = 0; i < __remainTimeSet.length; i++)
                {
                    var n:int = int(Math.abs(__remainTimeSet[i].time - _endAt.time)/10000);
//                    log.writeLog(log.LV_FATAL, this, "timer set ",i,__remainTimeSet[i], n);
                    if (n ==0 )
                    {
                        added = false;
                        break;
                    }
                }
//                 _invList.filter((function(item:*, index:int, ary:Array):Boolean{return item.index == 0})).length;                i
                if (added)
                {
                    __remainTimeSet.push(_endAt);
                    timerCheck();
                }
            }
        }

        private  function sortByDateTime(a:Date,b:Date):int
        {
            if (a.time > b.time)
            {
                return 1;
            }
            else if (a.time < b.time)
            {
                return -1;
            }
            else
            {
                return 0;
            }

        }

        public function timerCheck():void
        {
            // 配列に時間がセットされてなければ、チェックしない
            if (__remainTimeSet.length <= 0)
            {
                return;
            }

            if ( __remainTimeSet.length <= 0 ) return ;
//            log.writeLog(log.LV_INFO, this, "timer Check start");
            __remainTimeSet.sort(sortByDateTime );

//             // 内容をちょっと確認
//             for(var i:int = 0; i < __remainTimeSet.length; i++)
//             {
//            log.writeLog(log.LV_FATAL, this, "timer check ",__remainTimeSet[0],"result",__lastTimerDate == null,__lastTimerDate !=null, __lastTimerDate < __remainTimeSet[0])));
//             }


            // もし最後のタイマーの起動時間が最新の最短チェック時間より後ならば
            // 最後のチェック時間を調べる
            if(__lastTimerDate == null||(__lastTimerDate !=null&&__lastTimerDate.time > __remainTimeSet[0].time))
            {
//                log.writeLog(log.LV_FATAL, this, "timercheck",__lastTimerDate, __remainTimeSet[0],__remainTimeSet.length );
                __lastTimerDate = __remainTimeSet[0];
                var delay:int = calcRemainTime(__remainTimeSet[0]);
                if (__waitThread != null && __waitThread.state != ThreadState.TERMINATED)
                {
                    __waitThread.interrupt();
                }
//                log.writeLog(log.LV_FATAL, this, "timer set delay time", delay );
                __waitThread = new WaitThread(delay+1500, vanishCheck);
                __waitThread.start();
//                 __waitThread = new WaitThread(delay+2000, LobbyCtrl.instance.partsVanishCheck);
//                 __waitThread.start();
            }



        }

        public function vanishCheck():void
        {
            // ここでとりあげる
          LobbyCtrl.instance.partsVanishCheck();
//            log.writeLog(log.LV_FATAL, this, "vanish parts check",__remainTimeSet[0]);
            __remainTimeSet.shift();
            __lastTimerDate = null;
//            log.writeLog(log.LV_FATAL, this, "vanishcheck",__lastTimerDate, __remainTimeSet[0],__remainTimeSet.length );
            timerCheck();
        }


        // 装備中のアバターパーツ配列を返す
        public static function getEquipItems():Array
        {
            sortType();
            var ret:Array = [];
            for(var i:int = 0; i < __items.length; i++)
            {
                if(__items[i].equiped)
                {
                    ret.push(__items[i].avatarPart);
                }
            }
            return ret;
        }

        // パーツを削除
        public static function deleteAvatarPartInventory(inv_id:int):void
        {
            for(var i:int; i < __items.length; i++)
            {
                if(__items[i].inventoryID == inv_id)
                {
                    __items.splice(i, 1);
                    i--;
                }
            }
            delete __dic[inv_id];
        }

        // コンストラクタ
        public function AvatarPartInventory(inv_id:int, ap:AvatarPart,used:int = 0,endAt:int = 0)
        {
//            log.writeLog(log.LV_FATAL, this, "part used",used);
            _inventoryID = inv_id;
            setEndAt(endAt)
            _avatarPart = ap;


            _used = used;

            __items.push(this);
            __dic[_inventoryID] = this;
        }

        // インベントリIDを取得
        public function get inventoryID():int
        {
            return _inventoryID;
        }
        // アバターパーツを取得
        public function get avatarPart():AvatarPart
        {
            return _avatarPart;
        }
        // パーツIDを取得
        public function get avatarPartId():int
        {
            return _avatarPart.id;
        }

        // 終了時間を返す
        public function get getRemainTime():Number
        {
            var ret:Number =0;

            if (_endAt != null)
            {
                ret = calcRemainTime(_endAt)
            }
            if (ret<0)
            {
                return 0;
            }else{
                return ret;
            }

        }

        private function calcRemainTime(endAt:Date):Number
        {
            var now:Date = new Date();
            return endAt.getTime()-now.getTime();
        }




        // 使用フラグ
        public function get equiped():Boolean
        {
            return (_used & Const.APS_USED) == Const.APS_USED;
        }

        // アクティべーテッドフラグ
        public function get activated():Boolean
        {
            return (_used & Const.APS_ACTIVATED) == Const.APS_ACTIVATED;
        }


        public static function equipPartsSucc(invID:int, unuseIDs:String, endAt:int,status:int):void
        {
            if(invID != 0)
            {
                __dic[invID]._used =status;
                __dic[invID].setEndAt(endAt);
            }

            if (unuseIDs != "")
            {
                var unsuseSet:Array = unuseIDs.split(","); /* of int */ 
//                log.writeLog(log.LV_INFO, "STATIC", "UNUSEESET !!!!!!!!!!!!!!!? ", unsuseSet);
                for(var i:int; i < unsuseSet.length; i++)
                {
                    if(__dic[unsuseSet[i]].equiped)
                    {
                        __dic[unsuseSet[i]]._used ^=Const.APS_USED;
                    }
                };
            }
        }

        public static function getPart(invID:int, partID:int):void
        {
            new AvatarPartInventory(invID, AvatarPart.ID(partID));
        }


        //指定したアバターアイテムの数を返す
        public static function getItemsNum(id:int):int
        {
            var count:int = 0;
            var num :int =  __items.length
            for(var i:int = 0; i < num; i++)
            {
                if(__items[i].avatarPart.id == id)
                {
                    count ++;
                }
            }
            return count;
        }



    }
}