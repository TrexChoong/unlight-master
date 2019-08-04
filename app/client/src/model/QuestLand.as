 // TODO:コンストラクタでIDだけ渡したい。なぜならロード失敗の時IDがわからないから。

package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * クエスト場所クラス
     * 情報を扱う
     *
     */
    public class QuestLand extends BaseModel
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_STAGE	:String = "レーデンベルグ城";
        CONFIG::LOCALE_JP
        private static const _TRANS_STAGE_NAME	:String = "魅惑の森";
        CONFIG::LOCALE_JP
        private static const _TRANS_EVENT	:String = "ダメージ床";
        CONFIG::LOCALE_JP
        private static const _TRANS_EVENT_NAME	:String = "回復の泉";

        CONFIG::LOCALE_EN
        private static const _TRANS_STAGE	:String = "Reighdenberg Castle";
        CONFIG::LOCALE_EN
        private static const _TRANS_STAGE_NAME	:String = "The Enchanted Forest";
        CONFIG::LOCALE_EN
        private static const _TRANS_EVENT	:String = "Damage floor";
        CONFIG::LOCALE_EN
        private static const _TRANS_EVENT_NAME	:String = "Fountain of Recovery";

        CONFIG::LOCALE_TCN
        private static const _TRANS_STAGE	:String = "雷德貝魯格城";
        CONFIG::LOCALE_TCN
        private static const _TRANS_STAGE_NAME	:String = "迷惑森林";
        CONFIG::LOCALE_TCN
        private static const _TRANS_EVENT	:String = "傷害區域";
        CONFIG::LOCALE_TCN
        private static const _TRANS_EVENT_NAME	:String = "回復之泉";

        CONFIG::LOCALE_SCN
        private static const _TRANS_STAGE	:String = "雷德贝鲁格城";
        CONFIG::LOCALE_SCN
        private static const _TRANS_STAGE_NAME	:String = "魅惑之森";
        CONFIG::LOCALE_SCN
        private static const _TRANS_EVENT	:String = "负伤区域";
        CONFIG::LOCALE_SCN
        private static const _TRANS_EVENT_NAME	:String = "恢复之泉";

        CONFIG::LOCALE_KR
        private static const _TRANS_STAGE	:String = "레덴베르그 성";
        CONFIG::LOCALE_KR
        private static const _TRANS_STAGE_NAME	:String = "매혹의 숲";
        CONFIG::LOCALE_KR
        private static const _TRANS_EVENT	:String = "데미지 바닥";
        CONFIG::LOCALE_KR
        private static const _TRANS_EVENT_NAME	:String = "회복의 샘";

        CONFIG::LOCALE_FR
        private static const _TRANS_STAGE	:String = "Château Reighdenberg";
        CONFIG::LOCALE_FR
        private static const _TRANS_STAGE_NAME	:String = "Forêt Enchantée";
        CONFIG::LOCALE_FR
        private static const _TRANS_EVENT	:String = "Sol Destructeur";
        CONFIG::LOCALE_FR
        private static const _TRANS_EVENT_NAME	:String = "Fontaine de Jouvence";

        CONFIG::LOCALE_ID
        private static const _TRANS_STAGE	:String = "レーデンベルグ城";
        CONFIG::LOCALE_ID
        private static const _TRANS_STAGE_NAME	:String = "魅惑の森";
        CONFIG::LOCALE_ID
        private static const _TRANS_EVENT	:String = "ダメージ床";
        CONFIG::LOCALE_ID
        private static const _TRANS_EVENT_NAME	:String = "回復の泉";

        CONFIG::LOCALE_TH
        private static const _TRANS_STAGE   :String = "ปราสาทเรเดนเบิร์ก";
        CONFIG::LOCALE_TH
        private static const _TRANS_STAGE_NAME  :String = "ป่ามนต์เสน่ห์";
        CONFIG::LOCALE_TH
        private static const _TRANS_EVENT   :String = "น้ำพุฟื้นพลัง";
        CONFIG::LOCALE_TH
        private static const _TRANS_EVENT_NAME  :String = "น้ำพุฟื้นพลัง";


        public static const INIT:String = 'init'; // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        private static var __loader:Function;         // パラムを読み込む関数
        private static var __questLands:Object =[];        // ロード済みのクエスト
        private static var __loadings:Object ={};     // ロード中のクエスト

        private var _name           :String;          // 名前
        private var _monsterNo      :int;             //モンスター番号（アイコン生成につかう。-1だと？）
        private var _treasureType      :int;             // 宝箱番号（宝箱の色分けに使う）
        private var _eventNo        :int;             // イベント番号
        private var _stage          :int;             // ステージ番号
        private var _caption        :String;          //キャプション
        private var _version        :int;

//        public static const STAGES_STR:Array = ["レーデンベルグ城", "魅惑の森"];
        public static const STAGES_STR:Array = [_TRANS_STAGE, _TRANS_STAGE_NAME];
//        public static const EVENTS_STR:Array = ["", "ダメージ床", "回復の泉"];
        public static const EVENTS_STR:Array = ["", _TRANS_EVENT, _TRANS_EVENT_NAME];

        // EventNoの内容
        public static const EVENT_NO_NONE:int = 0;
        public static const EVENT_NO_BOSS:int = 1;

        public static function setLoaderFunc(loader:Function):void
        {
            QuestLand.getBlankLand(); // ブランクだけは速攻で作る
            __loader=loader;
        }

        private static function getData(id:int):void
        {
//             if (__loader == null)
//             {
//                 throw new Error("Warning: Loader is undefined.");
//             }else{
                var a:Array; /* of ElementType */
                if (ConstData.getData(ConstData.QUEST_LAND, id) != null)
                {
                    a = ConstData.getData(ConstData.QUEST_LAND, id)
                    updateParam(id, a[1], a[2], a[3], a[4], a[5], a[6], 0, true);
                }


//                 if (Cache.getCache(Cache.QUEST_LAND, id))
//                 {
//                     var a:Array = Cache.getDataParam(Cache.QUEST_LAND, id);
//                     updateParam(id, a[0], a[1], a[2], a[3],a[4], a[5], a[6], true);
// //                    log.writeLog(log.LV_FATAL, "CharaCard static", "get param cache", a);
//                 }else{
//                 __loadings[id] = true;
//                 new ReLoaderThread(__loader, QuestLand.ID(id)).start();
// //                new ReLoader(__loader, id).start();
// //                __loader(id);
//                 }
//             }
        }

        public static function clearData():void
        {
            __questLands.forEach(function(item:QuestLand, index:int, array:Array):void{if (item != null){item._loaded = false}});
        }

        // IDのQuestLandインスタンスを返す
        public static function ID(id:int):QuestLand
        {
            if (__questLands[id] == null)
            {
                if (id == 0)
                {
                    getBlankLand();
                }else{
                    __questLands[id] = new QuestLand(id);
                    getData(id);
                }
            }else{
                if (!(__questLands[id].loaded || __loadings[id]))
                {
                    getData(id);
                }
            }
            return __questLands[id];
        }

        // ローダがQuestLandのパラメータを更新する
        public static function updateParam(id:int,  name:String, monsterNo:int, treasureNo:int, eventNo:int, stage:int, caption:String, version:int, cache:Boolean=false):void
        {

            log.writeLog(log.LV_INFO, "static QuestLand" ,"update id",id, name, stage);

            if (__questLands[id] == null)
            {
                __questLands[id] = new QuestLand(id);
            }
            __questLands[id]._id        = id;
            __questLands[id]._name      = name;
            __questLands[id]._monsterNo  = monsterNo;
            __questLands[id]._treasureType = treasureNo;
            __questLands[id]._eventNo   = eventNo;
            __questLands[id]._stage   = stage;
            __questLands[id]._caption   = caption;

            __questLands[id]._version   = version;

            if (!cache)
            {
                Cache.setCache(Cache.QUEST_LAND, id, name, monsterNo, treasureNo, eventNo, stage, caption, version);
            }

            if (__questLands[id]._loaded)
            {
                __questLands[id].dispatchEvent(new Event(UPDATE));
//                log.writeLog(log.LV_INFO, "static QuestLand" ,"load update",id,__questLands[id]._loaded);
            }
            else
            {
                __questLands[id]._loaded  = true;
                __questLands[id].notifyAll();
                __questLands[id].dispatchEvent(new Event(INIT));
//                log.writeLog(log.LV_INFO, "static QuestLand" ,"load init",id,__questLands[id]);
            }
            __loadings[id] = false;

        }

        // ブランクランド
        public static function getBlankLand():QuestLand
        {
//            log.writeLog(log.LV_FATAL, "STATIC", "blank is here");
            if (__questLands[0] == null)
            {
                __questLands[0] = new QuestLand(0);
                __questLands[0]._id        = 0
                __questLands[0]._name      = "";
                __questLands[0]._monsterNo  = 0;
                __questLands[0]._treasureType = 0;
                __questLands[0]._stage = 0;
                __questLands[0]._eventNo   = 0;
                __questLands[0]._caption   = "";
                __questLands[0]._loaded        = true;
                __questLands[0].notifyAll();
            }
            return __questLands[0]
        }


        // コンストラクタ
        public function QuestLand(id:int)
        {
            _id = id;
        }

        public function get name():String
        {
            return _name;
        }

        public function get monsterNo():int
        {
            return _monsterNo;
        }
        public function get treasureType():int
        {
            return _treasureType;
        }
        public function get eventNo():int
        {
            return _eventNo;
        }

        public function get stage():int
        {
            return _stage;
        }

        public function get stageString():String
        {
            if(_id == 0)
            {
                return "";
            }
            else
            {
                return STAGES_STR[_stage];
            }
        }


        public function get caption():String
        {
            return _caption;
        }

        public function getLoader():Thread
        {
            return new ReLoaderThread(__loader, this);
        }

    }
}
// import org.libspark.thread.Thread;

// import model.QuestLand;

// // QuestLandのロードを待つスレッド
// class Loader extends Thread
// {
//     private var  _feat:QuestLand;

//     public function Loader(feat:QuestLand)
//     {
//         _feat =feat;
//     }

//     protected override function run():void
//     {
//         if (_feat.loaded == false)
//         {
//             _feat.wait()
//         }
//         next(close);
//     }

//     private function close ():void
//     {

//     }

// }
