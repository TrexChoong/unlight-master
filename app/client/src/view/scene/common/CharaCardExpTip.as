package view.scene.common
{

    import flash.display.*;
    import flash.text.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.*;
    import model.CharaCard;
    import model.GrowthTree;

    /**
     * CharaCardExpTipクラス
     *
     */

    public class CharaCardExpTip extends BaseScene
    {
        private static var __shape:Shape = new Shape();

        private static var __colorSet:Vector.<ColorTransform> = Vector.<ColorTransform>([new ColorTransform(0.4,0.3,0.3),new ColorTransform(0.3,0.4,0.3),new ColorTransform(0.3,0.0,0.4)]);
        private static var __gettedColorSet:Vector.<ColorTransform> = Vector.<ColorTransform>([new ColorTransform(0.9,0,0),new ColorTransform(0.0,0.9,0) ,new ColorTransform(0.0,0.0,0.9)]);
        private static const __colorNum:int = 3;

        private static var __bitMapdataSet:Dictionary = new Dictionary();


        private static const WIDTH:int = 112;
        private static const HEIGHT:int =3;

        private var _bitmap:Bitmap;
        private var _bitmapData:BitmapData;

        // 必要総数
        private var _max:int = 0;

        // 取得済みCCカードの枚数
        private var _gettedSet:Array = []; /* of int */
        // 必要なCCカードのそれぞれの枚数
        private var _maxSet:Array = []; /* of int */

        private var _needCards:Array = [];
        private var _nextGrowthTree:GrowthTree;
        private var _nextCC:CharaCard;

        private var _currentNum:int = 0;
        private var _ccNum:int; // 必要なカードの種類数

        /**
         * コンストラクタ
         *
         */
        public function CharaCardExpTip(nextCC:CharaCard)
        {
//            log.writeLog(log.LV_FATAL, this, "+cc1",nextCC.id, nextCC.loaded);
            _nextCC = nextCC;
//            log.writeLog(log.LV_FATAL, this, "+cc2",GrowthTree.ID(nextCC.id), GrowthTree.ID(nextCC.id).loaded);
             _nextGrowthTree = GrowthTree.ID(nextCC.id);
             if (__bitMapdataSet[nextCC] == null)
             {
                new ModelWaitThread(this, nextCC).start();
             }else{
                 init();
            }
        }

        // bitmapを実際にセットする
        private function setBitmap():void
        {
                _bitmap = new Bitmap(__bitMapdataSet[_nextCC]);
                _bitmap.x = 54;
                _bitmap.y = 35;
                addChild(_bitmap);
        }

        public override function init():void
        {
//            log.writeLog(log.LV_FATAL, this, "+cc3");
            var a:Array = _nextGrowthTree.down; /* of int */ 
            var len:int = a.length;
//            log.writeLog(log.LV_FATAL, this, "+cc2",a,len);
            if (len>0)
            {
                for(var i:int = 0; i < len; i++){
                    var cc:CharaCard = CharaCard.ID(a[i][0]);
                    _max += a[i][1];
                    _maxSet[i] = a[i][1];
                    _gettedSet[i]  =  (a[i][1] < cc.num) ? a[i][1] : cc.num;
                    _needCards.push(cc);
                    cc.addEventListener(CharaCard.UPDATE_NUM, updateHandler, false, 0, true);
//                    log.writeLog(log.LV_FATAL, this, "add event ",cc.id);
                }
            }
            _ccNum= len;
//            log.writeLog(log.LV_FATAL, this, "EXP TIP init", a, len);
            initShape();
            initBitmap();
        }

        public override function final():void
        {
            _needCards.forEach(function(item:*, index:int, array:Array):void{item.removeEventListener(CharaCard.UPDATE_NUM,updateHandler)});
        }


        private function update():void
        {
            var a:Array = _nextGrowthTree.down; /* of int */ 
            var len:int = a.length;
            _max = 0;
            if (len>0)
            {
                for(var i:int = 0; i < len; i++){
                    var cc:CharaCard = CharaCard.ID(a[i][0]);
                    _max += a[i][1];
                    _maxSet[i] = a[i][1];
                    _gettedSet[i]  =  (a[i][1] < cc.num) ? a[i][1] : cc.num;
                }
            }
            _ccNum= len;
//            log.writeLog(log.LV_FATAL, this, "EXP TIP", a, _gettedSet);
            initShape();
            initBitmap();
        }

        private function updateHandler(e:Event):void
        {
//            log.writeLog(log.LV_FATAL, this, "+++++++++++++++++++aaaaaaaaaaaaaaaaaaaa update num!!!",_nextCC.id);
            update()
        }

        private function initShape():void
        {
            __shape.graphics.clear();
            __shape.graphics.lineStyle(0, 0x000000);
            __shape.graphics.beginFill(0xFFFFFF);
            __shape.graphics.drawRect(0,0,WIDTH/_max,HEIGHT);
        }

        private function initBitmap():void
        {
            _bitmapData = new BitmapData(112, 5,true, 0x00000000);

//             // MAX分塗っていく
            var addNum:int = 0;
            for(var j:int = 0; j < _ccNum; j++){
                for(var i:int = 0; i < _maxSet[j]; i++){
                  // 取得済みなら取得済みの色でぬる
                    if (i<_gettedSet[j])
                    {
//                        _bitmapData.draw(__shape, new Matrix(1,0,0,1,i*WIDTH/_max), __gettedColorSet[__colorNum%(j+__colorNum)]);
                        _bitmapData.draw(__shape, new Matrix(1,0,0,1,addNum*WIDTH/_max), __gettedColorSet[(j+__colorNum)%__colorNum]);
                    }else {
//                        _bitmapData.draw(__shape, new Matrix(1,0,0,1,i*WIDTH/_max), __colorSet[__colorNum%(j+__colorNum)]);
                        _bitmapData.draw(__shape, new Matrix(1,0,0,1,addNum*WIDTH/_max), __colorSet[(j+__colorNum)%__colorNum]);
                    }
                    addNum +=1;
                }
            }
            __bitMapdataSet[_nextCC] = _bitmapData;
            setBitmap();
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            return new ModelWaitShowThread(this, stage,_nextGrowthTree);
        }
    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.BaseModel;
import model.GrowthTree;

import view.BaseShowThread;
import view.IViewThread;
import view.scene.common.AvatarClip;

class ModelWaitThread extends Thread
{
    private var _m:BaseModel;
    private var _v:IViewThread;

    public function ModelWaitThread(view:IViewThread, m:BaseModel)
    {
        _m = m;
        _v = view;
    }

    protected override function run():void
    {
//        log.writeLog(log.LV_INFO, this, "run?");
        if (_m.loaded == false)
        {
            _m.wait();
        }
        next(waitTree);
    }

    private function waitTree():void
    {
//         log.writeLog(log.LV_INFO, this, "+++++++run?");

        if (GrowthTree.ID(_m.id).loaded == false)
        {
            GrowthTree.ID(_m.id).wait();
        }
        next(close);
    }



    private function close():void
    {
        _v.init();
    }
}

