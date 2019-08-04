package view.scene.raid
{
    import flash.geom.*;
    import flash.utils.*;

    /**
     *  渦表示位置管理クラス
     *
     */
    public class ProfoundPositionsManager
    {
        private const _POS_CHECK_CNT:int = 30;
        private const _MAP_PRF_ROW_MAX:int = 5;
        private const _MAP_PRF_COL_MAX:int = 2;

        private static var __instance:ProfoundPositionsManager;

        private var _posObjList:Vector.<MapPosObj> = new Vector.<MapPosObj>();
        private var _posUsedPointIdx:Vector.<Dictionary> = new Vector.<Dictionary>();

        // インスタンスを取る
        public static function get instance():ProfoundPositionsManager
        {
            if (__instance == null) __instance = createInstance();
            return __instance;
        }
        // インスタンス作成
        public static function createInstance():ProfoundPositionsManager
        {
            return new ProfoundPositionsManager(arguments.callee);
        }

        public function ProfoundPositionsManager(caller:Function=null):void
        {
            if( caller != createInstance ) throw new ArgumentError("Cannot user access constructor.");
        }

        // RaidMapから表示座標の基準リストを登録
        public function setPointStandard(mapId:int,pos:Point):void
        {
            log.writeLog(log.LV_DEBUG, this,"setPointStandard",pos.x,pos.y);
            _posObjList.push(new MapPosObj(mapId,pos));
            _posUsedPointIdx.push(new Dictionary());
        }

        // Indexから表示Pointを取得
        public function getPosPoint(prfId:int,mapId:int,index:int):Point
        {
            // log.writeLog(log.LV_FATAL, this,"getPosPoint !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",mapId,index);
            var setIndex:int = checkAvailableIndex(mapId,index);
            var ret:Point = getSetPoint(prfId,mapId,setIndex);

            // 座標が0,0になることはないので、その場合Nullを返す
            if  (ret.x == 0 && ret.y == 0) return null;

            // 使用する座標Indexに渦IDを入れる
            _posUsedPointIdx[mapId][setIndex] = prfId;

            log.writeLog(log.LV_DEBUG, this,"getPosPoint",ret.x,ret.y);
            return ret;
        }
        // Indexの使用可能チェック
        private function checkAvailableIndex(mapId:int,idx:int):int
        {
            var cnt:int = 0;
            var ok:Boolean = false;
            var ret:int = idx;
            while (ok == false && cnt < _POS_CHECK_CNT) {
                if (_posUsedPointIdx[mapId][ret]>0) {
                    ret++;
                    if (ret >= _MAP_PRF_ROW_MAX*_MAP_PRF_COL_MAX) ret = 0;
                } else {
                    ok = true;
                }
                cnt++;
            }
            if (ok==false) {ret=-1}
            return ret;
        }
        // 表示座標の選抜
        private function getSetPoint(prfId:int,mapId:int,idx:int):Point
        {
            var setPos:Point = new Point(0,0);
            if (idx>=0) {
                setPos = getPoint(mapId,idx);
            }
            return setPos;
        }
        // 表示座標の算出
        private function getPoint(mapId:int,idx:int):Point
        {
            var ret:Point = new Point(0,0);
            var posObj:MapPosObj = _posObjList[mapId];
            if (posObj) {
                if (idx > 0) {
                    ret.x = posObj.left + posObj.prfW * Math.floor(idx % _MAP_PRF_ROW_MAX);
                    ret.y = posObj.top + posObj.prfH * Math.floor(idx / _MAP_PRF_ROW_MAX) + posObj.prfH / 2 * Math.floor(idx % _MAP_PRF_ROW_MAX % 2);
                } else {
                    ret.x = posObj.left;
                    ret.y = posObj.top;
                }
            }
            log.writeLog(log.LV_DEBUG, this,"getPoint",ret.x,ret.y);
            return ret;
        }
        // 使用状態を解除
        public function useFlagUnlock(prfId:int,mapId:int):void
        {
            for ( var idx:Object in _posUsedPointIdx[mapId]) {
                if (_posUsedPointIdx[mapId][int(idx)]==prfId) {
                    _posUsedPointIdx[mapId][int(idx)] = 0;
                }
            }
        }
    }

}

import flash.geom.*;
import flash.utils.*;

class MapPosObj
{
    private const _WIDTH_LIST:Array  = [
        180, // グランデレニア
        80,  // ロンズブラウ
        150, // ルビオナ
        130, // コルガー
        150, // フォンデラ
        130, // バラク
        150, // メルツバウ
        100, // ミリガディア
        80,  // バーンサイド
        80,  // マイオッカ
        110, // インペローダ
        100, // カナーン
        ];
    private const _HEIGHT_LIST:Array = [
        90, // グランデレニア
        30,  // ロンズブラウ
        100, // ルビオナ
        50,  // コルガー
        80,  // フォンデラ
        50,  // バラク
        80,  // メルツバウ
        80,  // ミリガディア
        0,  // バーンサイド
        0,  // マイオッカ
        110, // インペローダ
        100, // カナーン
        ];


    private const PRF_IMG_W:int = 40;
    private const PRF_IMG_H:int = 30;

    private var _pos:Point = new Point(0,0);
    private var _center:Point = new Point(0,0);
    private var _width:int = 0;
    private var _height:int = 0;

    public function MapPosObj(mapId:int,pos:Point)
    {
        _center = pos;
        _width = _WIDTH_LIST[mapId];
        _height = _HEIGHT_LIST[mapId];
        _pos.x = _center.x - _width / 2;
        _pos.y = _center.y - _height / 2;
    }
    public function get left():int
    {
        return _pos.x;
    }
    public function get right():int
    {
        return _pos.x + _width;
    }
    public function get top():int
    {
        return _pos.y;
    }
    public function get bottom():int
    {
        return _pos.y + _height;
    }
    public function get width():int
    {
        return _width;
    }
    public function get height():int
    {
        return _height;
    }
    public function get pos():Point
    {
        return  _pos;
    }
    public function get prfW():int
    {
        return PRF_IMG_W;
    }
    public function get prfH():int
    {
        return PRF_IMG_H;
    }
}