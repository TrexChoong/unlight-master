package model
{
//     import net.*;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.libspark.thread.Thread;

    import model.utils.*;

    /**
     * パッシブスキルクラス
     * 情報を扱う
     *
     */
    public class PassiveSkill extends BaseModel
    {
        public static const INIT:String = 'init';     // 情報をロード
        public static const UPDATE:String = 'update'; // 情報をロード
        private static var __loader:Function;         // パラムを読み込む関数
        private static var __passiveSkills:Object =[];        // ロード済みのパッシブスキル
        private static var __loadings:Object ={};     // ロード中のパッシブスキル

        private var _name          :String; // 名前
        private var _no            :int;    // no
        private var _image         :String; // パッシブのSWF名
        private var _caption       :String; // キャプション
        private var _version       :int;

        public static function setLoaderFunc(loader:Function):void
        {
            __loader=loader;
        }

        private static function getData(id:int):void
        {
            var a:Array; /* of ElementType */
            a = ConstData.getData(ConstData.PASSIVE_SKILL, id);
            if (a != null)
            {

                if (__passiveSkills[id] == null)
                {
                    __passiveSkills[id] = new PassiveSkill(id);
                }
                __passiveSkills[id]._id            = id;
                __passiveSkills[id]._no            = a[1];
                __passiveSkills[id]._name          = a[2];
                __passiveSkills[id]._caption       = a[3];
                __passiveSkills[id]._image         = a[4];
                if (__passiveSkills[id]._loaded)
                {
                    __passiveSkills[id].dispatchEvent(new Event(UPDATE));
                }
                else
                {
                    __passiveSkills[id]._loaded  = true;
                    __passiveSkills[id].notifyAll();
                    __passiveSkills[id].dispatchEvent(new Event(INIT));
                }
                __loadings[id] = false;
            }

        }

        public static function clearData():void
        {
        }

        // IDのPassiveSkillインスタンスを返す
        public static function ID(id:int):PassiveSkill
        {
            if (__passiveSkills[id] == null)
            {
                __passiveSkills[id] = new PassiveSkill(id);
                getData(id);
            }
            return __passiveSkills[id];
        }

        // パラメータを更新する
        public static function updateParam(id:int,  name:String, image:String, caption:String, version:int, cache:Boolean=false):void
        {
        }


        // コンストラクタ
        public function PassiveSkill(id:int)
        {
            _id = id;
        }
        public function get no():int
        {
            return _no;
        }
        public function get name():String
        {
            return _name;
        }
        public function get image():String
        {
            return _image;
        }
        public function get caption():String
        {
            return _caption;
        }

    }
}
