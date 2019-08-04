package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Avatar;
    import model.AvatarPart;
    import model.AvatarPartInventory;
    import view.image.common.AvatarImage;
    import view.image.common.AvatarPartImage;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;

    /**
     * AvatarPartの表示クラス
     * 
     */

    public class AvatarPartClip extends BaseScene
    {
        private static var __ai:AvatarImage = new AvatarImage();
        // イメージ
        // （基点、未設定はnull）
        public static const TYPE_PRIORITY:Array = [
            null,                // 0
            AvatarImage.FOOT_L,  // 1

            AvatarImage.FOOT_L,  // 2
            AvatarImage.FOOT_L,  // 3
            AvatarImage.FOOT_L,  // 4
            AvatarImage.FOOT_L,  // 5
            AvatarImage.FOOT_L,  // 6
            AvatarImage.FOOT_L,  // 7
            AvatarImage.FOOT_L,  // 8
            AvatarImage.FOOT_L,  // 9

            AvatarImage.MIDDLE,  // 10
            AvatarImage.MIDDLE,  // 11

            AvatarImage.CHEST,   // 12
            AvatarImage.CHEST,   // 13
            AvatarImage.CHEST,   // 14

            AvatarImage.HEAD,    // 15
            AvatarImage.HEAD,    // 16
            AvatarImage.HEAD,    // 17

            AvatarImage.HEAD,    // 18
            AvatarImage.HEAD,    // 19
            AvatarImage.HEAD,    // 20

            AvatarImage.CHEST,   // 21
            AvatarImage.CHEST,   // 22
            AvatarImage.CHEST,   // 23

            AvatarImage.HAND_L,  // 24
            AvatarImage.HAND_L,  // 25
            AvatarImage.HAND_L,  // 26

            AvatarImage.HAND_L,  // 27

            AvatarImage.HAND_L,  // 28
            AvatarImage.HAND_L,  // 29
            AvatarImage.HAND_L,  // 30

            AvatarImage.ARM_F_L, // 31
            AvatarImage.ARM_F_L, // 32
            AvatarImage.ARM_U_L, // 33
            AvatarImage.HAND_L,  // 34
            AvatarImage.ARM_U_L, // 35
            AvatarImage.ARM_U_L, // 36

            AvatarImage.HEAD,    // 37
            AvatarImage.HEAD,    // 38
            AvatarImage.HEAD,    // 39

            AvatarImage.CHEST,   // 40
            AvatarImage.MIDDLE,  // 41
            AvatarImage.FOOT_L,  // 42

            AvatarImage.MIDDLE,  // 43

            AvatarImage.THIGH_L, // 44

            AvatarImage.MIDDLE,  // 45
            AvatarImage.MIDDLE,  // 46
            AvatarImage.MIDDLE,  // 47

            AvatarImage.SHIN_L,  // 48
            AvatarImage.SHIN_L,  // 49
            AvatarImage.SHIN_L,  // 50

            AvatarImage.FOOT_L,  // 51
            AvatarImage.FOOT_L,  // 52

            AvatarImage.MIDDLE,  // 53
            AvatarImage.MIDDLE,  // 54
            AvatarImage.THIGH_R, // 55

            AvatarImage.MIDDLE,  // 56
            AvatarImage.MIDDLE,  // 57
            AvatarImage.MIDDLE,  // 58

            AvatarImage.SHIN_R,  // 59
            AvatarImage.SHIN_R,  // 60
            AvatarImage.SHIN_R,  // 61

            AvatarImage.FOOT_R,  // 62
            AvatarImage.FOOT_R,  // 63

            AvatarImage.MIDDLE,  // 64
            AvatarImage.MIDDLE,  // 65
            AvatarImage.MIDDLE,  // 66

            AvatarImage.CHEST,   // 67
            AvatarImage.CHEST,   // 68
            AvatarImage.MIDDLE,  // 69
            AvatarImage.MIDDLE,  // 70
            AvatarImage.MIDDLE,  // 71

            AvatarImage.CHEST,   // 72
            AvatarImage.CHEST,   // 73
            AvatarImage.CHEST,   // 74

            AvatarImage.CHEST,   // 75
            AvatarImage.CHEST,   // 76
            AvatarImage.CHEST,   // 77

            AvatarImage.HAND_R,  // 78
            AvatarImage.HAND_R,  // 79
            AvatarImage.HAND_R,  // 80

            AvatarImage.HAND_R,  // 81

            AvatarImage.HAND_R,  // 82
            AvatarImage.HAND_R,  // 83
            AvatarImage.HAND_R,  // 84

            AvatarImage.ARM_F_R, // 85
            AvatarImage.ARM_F_R, // 86
            AvatarImage.ARM_U_R, // 87

            AvatarImage.ARM_U_R, // 88
            AvatarImage.ARM_U_R, // 89
            AvatarImage.ARM_U_R, // 90

            AvatarImage.CHEST,   // 91
            AvatarImage.CHEST,   // 92
            AvatarImage.CHEST,   // 93

            AvatarImage.HEAD,    // 94
            AvatarImage.HEAD,    // 95
            AvatarImage.HEAD,    // 96

            AvatarImage.HEAD,    // 97

            AvatarImage.HEAD,    // 98
            AvatarImage.HEAD,    // 99
            AvatarImage.HEAD,    // 100

            AvatarImage.HEAD,    // 101
            AvatarImage.HEAD,    // 102
            AvatarImage.HEAD,    // 103

            AvatarImage.HEAD,    // 104
            AvatarImage.HEAD,    // 105
            AvatarImage.HEAD,    // 106

            AvatarImage.CHEST,   // 107

            AvatarImage.HEAD,    // 108
            AvatarImage.HEAD,    // 109
            AvatarImage.HEAD,    // 110

            AvatarImage.HEAD,    // 111
            AvatarImage.HEAD,    // 112
            AvatarImage.HEAD,    // 113
            AvatarImage.HEAD,    // 114
            AvatarImage.HEAD,    // 115
            AvatarImage.HEAD,    // 116
            AvatarImage.HEAD,    // 117
            AvatarImage.HEAD,    // 118

            AvatarImage.FOOT_L,  // 119
            AvatarImage.FOOT_L,  // 120
            AvatarImage.FOOT_L,  // 121
            AvatarImage.FOOT_L,  // 122
            AvatarImage.FOOT_L,  // 123
            AvatarImage.FOOT_L,  // 124
            AvatarImage.FOOT_L,  // 125
            AvatarImage.FOOT_L,  // 126

            AvatarImage.FOOT_L,  // 127
            ]; /* of int */ 

        private var _images:Array = [];    // Array of AvatarPartImage

        protected var _avatarPart:AvatarPart;


        /**
         * コンストラクタ
         *
         */
        public function AvatarPartClip(ap:AvatarPart)
        {
            _avatarPart = ap;
//            initializeImage();
        }

        private function initializeImage():void
        {
//            log.writeLog(log.LV_WARN, this, "initialized", _avatarPart.loaded, _avatarPart.id, _avatarPart.image);
            if (_avatarPart.loaded)
            {
                var strList:Array = _avatarPart.image.split("+");
                for(var i:int = 0; i < strList.length; i++)
                {
                    var api:AvatarPartImage = new AvatarPartImage(strList[i].toString());
                    _images.push(api);
                }
            }
        }

        public function setImage():void
        {
//            log.writeLog(log.LV_WARN, this, "initialized", _avatarPart.loaded, _avatarPart.id, _avatarPart.image);
            if (_avatarPart.loaded)
            {
                var strList:Array = _avatarPart.image.split("+");
                for(var i:int = 0; i < strList.length; i++)
                {
                    var api:AvatarPartImage = new AvatarPartImage(strList[i].toString());
                    _images.push(api);
                }
            }
        }

        // 初期化
        public override function init():void
        {
//             var strList:Array = _avatarPart.image.split("+");

//             for(var i:int = 0; i < strList.length; i++)
//             {
//                 var api:AvatarPartImage = new AvatarPartImage(strList[i].toString());
//                 _images.push(api);
//             }
//             _images.forEach(function(item:*, index:int, array:Array):void{addChild(item)});
//             _loaded = true;
//             notifyAll();
        }


        // 後処理
        public override function final():void
        {
//             var pExec:ParallelExecutor = new ParallelExecutor();
//             _images.forEach(function(item:*, index:int, array:Array):void{pExec.addThread(item.getHideThread())});
//             pExec.start();
        }

        public function get avatarPart():AvatarPart
        {
            return _avatarPart;
        }

        public function get images():Array
        {
            return _images;
        }


        // パーツをすべてもらい、重複を調整しながらベースにアタッチしながら表示するスレッド(出したい複数のクリップを並び替える)
        // このスレッドを介していないと表示できない

        public static function getAttachShowThread(clips:Vector.<AvatarPartClip >, stage:DisplayObjectContainer):Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            var typeList:Array = [];

            // すべてのパーツを念のため一度待つ
            for(var i:int = 0; i < clips.length; i++)
            {
//                log.writeLog(log.LV_FATAL, this,"clips", clips.length);
                pExec.addThread(new AvatarPartModelWaitThread(clips[i],typeList,stage, __ai));
            }
            return pExec;
        }



        public  function get partID():int
        {
            return _avatarPart.id;
        }

    }

}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;

import model.BaseModel;

import view.BaseShowThread;
import view.IViewThread;
import view.scene.common.AvatarClip;
import view.scene.common.AvatarPartClip;
import view.image.common.AvatarImage;
import view.image.common.AvatarPartImage;

class ShowThread extends BaseShowThread
{
    private var _m:BaseModel;
    private var _imageGetThreadGetFunc:Function;

    public function ShowThread(view:IViewThread, stage:DisplayObjectContainer, at:int)
    {
        super(view, stage);
    }

    protected override function run():void
    {
        next(close);
    }

}

class AvatarImageWaitShowThread extends BaseShowThread
{
    private var _ai:AvatarImage;
    private var _api:AvatarPartImage;
    private var _type:int;

    public function AvatarImageWaitShowThread(view:AvatarPartImage, stage:DisplayObjectContainer, ai:AvatarImage, type:int)
    {
//        log.writeLog(log.LV_FATAL, this, view, stage ,ai, type);
        _ai = ai;
        _api = view;
        _type = type;
        super(view, stage);
    }

    // イメージのロードを待つ
    protected override function run():void
    {
//        log.writeLog(log.LV_INFO, this, "wait ai?",_ai.loaded);
        if (_ai.loaded == false)
        {
//            log.writeLog(log.LV_INFO, this, "waiting?",_ai.loaded);
            _ai.wait();
        }
        next(setStage);
    }

    private function setStage():void
    {
        // アタッチすべきムービークリップをセットする
        var s:DisplayObjectContainer = _ai.getIns(AvatarPartClip.TYPE_PRIORITY[_type]);
        //
        if (s !=null)
        {
            _api.x = s.x;
            _api.y = s.y;
        }
        next(close);
    }

}

class AvatarPartModelWaitThread extends Thread
{
    private var _apc:AvatarPartClip;
    private var _typeList:Array;  
    private var _stage:DisplayObjectContainer;
    private var _ai:AvatarImage;
    public function AvatarPartModelWaitThread(apc:AvatarPartClip, typeList:Array, stage:DisplayObjectContainer, ai:AvatarImage )
    {
        _apc = apc;
        _typeList = typeList;
        _ai = ai;
        _stage = stage;
    }

    // modelのロードを待つ
    protected override function run():void
    {

        if (_apc.avatarPart.loaded == false)
        {
            _apc.avatarPart.wait();
        }
        next(setImage);
    }

//     private function waitingDraw():void
//     {
//         sleep(500);
//         next(setImage);
//     }

    private function setImage():void
    {
//        log.writeLog(log.LV_INFO, this, "+set imagwe",_apc.avatarPart.loaded);
        _apc.setImage();
//        log.writeLog(log.LV_INFO, this, "set imagwe",_apc.avatarPart.image);


        var strList:Array = _apc.avatarPart.image.split("+");
        var pExec:ParallelExecutor = new ParallelExecutor();
        for(var j:int = 0; j < strList.length; j++)
        {
            // 再考の余地あり
//            var type:int = strList[j].slice(strList[j].search(/_p/)+2 ,strList[j].search(/\./));
            var t:Array = strList[j].match(/[0-9]*$/);
            var type:int = t!=null ? t[0]:999;

//             // 同じ位置になにかあったら足さない
//             if (_typeList[type] == null)
//             {
                // タイプは優先度でもあるので深度につっこむ
                _apc.images[j].depthAt = type;
                _apc.images[j].transform.colorTransform = _apc.avatarPart.colorTransform;
                pExec.addThread(new AvatarImageWaitShowThread(_apc.images[j], _stage, _ai, type));
                _typeList[type] = true;
//                next(close);
//             }
        }

        pExec.join();
        pExec.start();
        next(close)
    }

    private function close():void
    {
        return
    }











}
