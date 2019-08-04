package view.scene.edit
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;
    import flash.geom.*;
    import flash.utils.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.BaseScene;

    import controller.QuestCtrl;
    import view.utils.*


    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class EventCardSlotScene extends BaseScene
    {

        private static const _CARD_X:int = -73;                      // カードのX基本位置
        private static const _CARD_Y:int = 25;                       // カードのY基本位置
        private static const _CARD_OFFSET_X:int = 30;                // カードのXズレ
        private static const _CARD_OFFSET_Y:int = 65;                // カードのYズレ
        private static const _POS_OFFSET_X:int = 88;                // カードのXズレ

        protected var _containers:Vector.<UIComponent> = Vector.<UIComponent>([new UIComponent, new UIComponent, new UIComponent]);
        protected var _slotSets:Vector.<Vector.<SlotImage>> = Vector.<Vector.<SlotImage>>([new Vector.<SlotImage>(), new Vector.<SlotImage>(), new Vector.<SlotImage>()]);

        private static const DECK_NUM:int =3;
        private static const SLOT_NUM:int =6;

        // キャラカードの枚数による存在数
        private static const _CHARA_CARD_EXIST:Array = [[false,false,false],[true,false,false],[true,true,false], [true, true,true]];



        /**
         * コンストラクタ
         *
         */
        public function EventCardSlotScene()
        {
            for(var i:int = 0; i < DECK_NUM; i++){
                for(var j:int = 0; j < SLOT_NUM; j++){
                    _slotSets[i][j] = new SlotImage();
                    _slotSets[i][j].x = getXFromSlot(j,i);
                    _slotSets[i][j].y = getYFromSlot(j);
                    _containers[i].addChild(_slotSets[i][j]);
//                     Unlight.GCW.watch(_slotSets[i][j]);
//                     Unlight.GCW.watch(_containers[i]);
                }
                addChild(_containers[i]);
            }
//             Unlight.GCW.watch(_containers);
//             Unlight.GCW.watch(_slotSets);

        }

        private function getXFromSlot(slot:int, pos:int):int
        {
            return _CARD_X+_CARD_OFFSET_X*(slot%3) + _POS_OFFSET_X*pos;
        }

        private function getYFromSlot(slot:int):int
        {
            return  _CARD_Y+_CARD_OFFSET_Y * (int(slot/3));
        }


        public function updateSlots(a:Array,num:int):void
        {
//            log.writeLog(log.LV_FATAL, this, "111111111111111111111", i,j,a[i][j]);
            var v:Array = _CHARA_CARD_EXIST[num];
            for(var i:int = 0; i < DECK_NUM; i++)
            {
                _containers[i].visible = v[i];
                for(var j:int = 0; j < SLOT_NUM; j++)
                {
//                    log.writeLog(log.LV_FATAL, this, "111111111111111111111", i,j,a[i][j]);
                    _slotSets[i][j].updateType(a[i][j]);
                }
            }

        }

        override public  function final():void
        {
            for(var i:int = 0; i < DECK_NUM; i++){
                RemoveChild.all(_containers[i]);
                RemoveChild.apply(_containers[i]);
                    }
            _containers = null;
            _slotSets = null;

        }


    }
}

import flash.display.*;
import flash.geom.*;
import flash.filters.GlowFilter;


import view.image.game.CharaCardStar;
import view.utils.*
class SlotImage extends Sprite
{

    private static var __colorSet:Vector.<ColorTransform> = Vector.<ColorTransform>([
                                                                                        new ColorTransform(0.7,0.7,0.7), // なし
                                                                                        new ColorTransform(1,1,1), // 白
                                                                                        new ColorTransform(0,0,0), // 黒
                                                                                        new ColorTransform(1.0,0.0,0.0), // 赤
                                                                                        new ColorTransform(0.0,1.0,0.0), // 緑
                                                                                        new ColorTransform(0.0,0.0,1.0), // 青
                                                                                        new ColorTransform(1.0,1.0,0.0), // 黄
                                                                                        new ColorTransform(1.0,0.0,1.0) // 紫
                                                                                        ]);
    private static const W:int =28;
    private static const H:int =43;
    private static const STAR_X:int =9;
    private static const STAR_Y:int =16;

    private var _shape:Shape = new Shape;
    private var _star:CharaCardStar = CharaCardStar.instance;
    private var _starBitmap:Bitmap;


    public function SlotImage(type:int = 0)
    {
        _shape.graphics.clear();
        _shape.graphics.lineStyle(2, 0xFFFFFF);
        _shape.graphics.beginFill(0xFFFFFF, 0.6);
        _shape.graphics.drawRect(0,0,W,H);
        updateType(type);
        addChild(_shape);
        _starBitmap = _star.getBitmap(0);
        _starBitmap.filters = [new GlowFilter(0x222222, 1, 2, 2, 3, 1)];
        _starBitmap.x = STAR_X;
        _starBitmap.y = STAR_Y;
        addChild(_starBitmap);
    }


    public function updateType(type:int):void
    {
        transform.colorTransform = __colorSet[type];
        if (type==0)
        {
            RemoveChild.apply(_starBitmap);
        }else{
            addChild(_starBitmap)
        }
    }

    public function clearType():void
    {
//         _shape.graphics.clear();
//         _shape.graphics.lineStyle(1, 0x666666);
//         _shape.graphics.beginFill(0xFFFFFF, 0.0);
//         _shape.graphics.drawRect(0,0,W,H);
    }



}