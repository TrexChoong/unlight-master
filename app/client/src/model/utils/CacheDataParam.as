package model.utils
{
    import flash.events.EventDispatcher;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.net.SharedObject;
    import flash.utils.ByteArray;

// モデルのキャッシュデータクラス

// モデルのインスタンスパラメータのクラス
    public class CacheDataParam
    {
        private var _version:int;         // インスタンスのデータのバージョン
        private var _param:Array;         // 実際のパラム
        private var _check:Boolean;       // データの整合性のチェックが必要か？
        private var _updateTime:int;      // 保存時の時間

        public function CacheDataParam(v:int = 0, pa:Array=null, c:Boolean=true, updateTime:int=0)
        {
            _version = v;
            _param = pa;
            _check = c;
            _updateTime = updateTime;

        }

        public function updateData(v:int = 0, pa:Array=null, c:Boolean=true, updateTime:int=0):void
        {
            _version = v;
            _param = pa;
            _check = c;
            _updateTime = updateTime;
        }

        public function get version():int
        {
            return _version;
        }

        public function get param():Array
        {
            return _param;
        }

        public function get check():Boolean
        {
            return _check;
        }

        public function get updateTime():int
        {
            return _updateTime;
        }

        public function getParamByteArray():ByteArray
        {
            var ba:ByteArray = new ByteArray();
            ba.writeObject(_param);
            return ba;
        }


    }
}