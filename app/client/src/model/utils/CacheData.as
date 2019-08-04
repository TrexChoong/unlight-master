package model.utils
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.net.SharedObject;
    /**
     * モデルのキャッシュ制御クラス
     * 仕様上の制限：寿命は2週間まで（バージョン管理の関係）
     *
     */
    public class CacheData
    {
        private var _version:int;     // 全体データのバージョン
        private var _paramSet:Array = []; // 個々のモデルインスタンスのデータセット

        public function CacheData(v:int)
        {
            _version = v;
        }

        public function get version():int
        {
            return _version;
        }

        public function get paramSet():Array  /* of CacheDataParam */ 
        {
            return _paramSet;
        }

        public function reset():void
        {
            _paramSet = [];
        }

        public function setParam(sets:Array,update:Boolean, so:Object):void
        {
            var num:int  = sets.length;

            for(var i:int = 0; i < num; i++)
            {
                if (sets[i] != null)
                {
                    var ba:ByteArray = sets[i][1];
                    var u:Boolean = sets[i][2] ? true:update;
//                    log.writeLog(log.LV_WARN, this, "set param", ba,i);
                    ba.position = 0;
                    _paramSet[i] = new CacheDataParam(sets[i][0],ba.readObject(), u, sets[i][3]);
                    so.sets[i][2]= u;
                }
            }
        }

        public function dataParam(id:int):CacheDataParam
        {
            if (_paramSet[id] == null)
            {
                _paramSet[id]  = new CacheDataParam();
            }
            return _paramSet[id];
        }

    }
}

