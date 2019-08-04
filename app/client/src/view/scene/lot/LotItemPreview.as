package view.scene.lot
{
    import flash.display.*;
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.utils.*;
    import flash.net.URLRequest;
    import flash.geom.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.*;
    import model.utils.*;
    import model.events.*;

    import view.scene.*;
    import view.*;
    import view.scene.common.*;

    import view.image.rmshop.*;
    import view.image.lot.*;
    import view.utils.*;


    /**
     * レアカードクジプレビュー
     *
     */
    public class LotItemPreview extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const GENRE_ON:Boolean = true;

        CONFIG::LOCALE_EN
        private static const GENRE_ON:Boolean = true;

        CONFIG::LOCALE_TCN
        private static const GENRE_ON:Boolean = true;

        CONFIG::LOCALE_SCN
        private static const GENRE_ON:Boolean = true;

        CONFIG::LOCALE_KR
        private static const GENRE_ON:Boolean = false;

        CONFIG::LOCALE_FR
        private static const GENRE_ON:Boolean = true;

        CONFIG::LOCALE_ID
        private static const GENRE_ON:Boolean = true;

        CONFIG::LOCALE_TH
        private static const GENRE_ON:Boolean = true;

        private static var __list:Vector.<LotItemPreview> = new Vector.<LotItemPreview>(RareCardLot.KIND_LENGTH);
        private static var __initBitmap:Boolean;
        private static const COLOR_SET:Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x0000FF, 0xFFFFFF]; /* of int */


        private var _bitmapDataSet:Vector.<BitmapData>;
        private var _mainBitmapData:BitmapData;
        private var _bitmap:Bitmap;
        private var _container:UIComponent = new UIComponent();
        private var _kind:int;
        private var _num:int;
        private var _scrollThread:ScrollThread;
        private var _lotInfoImage:LotInfoImage = new LotInfoImage();


        private var _loaded:Boolean = false;
        private static var __scrolling:Boolean = false;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [""],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _NORMAL_HELP:int = 0;

        public static function getLotItemPreview(kind:int):LotItemPreview
        {
            initBitmap();
//            _lotInfoImage.visible = false;
            return __list[kind];
        }

        public static function initBitmap():void
        {
            log.writeLog(log.LV_INFO, "LotItemPreview", "initBitmap");
            if (__initBitmap == false)
            {
                for (var i:int = 0; i < RareCardLot.KIND_LENGTH; i++)
                {
                    log.writeLog(log.LV_INFO, "LotItemPreview", i);
                    __list[i] = new LotItemPreview(i);
                }
                __initBitmap = true;
            }
        }

        /**
         * コンストラクタ
         *
         */
        public function LotItemPreview(kind:int)
        {
            x =142;
            y = 470;
//             x = 0;
//             y = 0;
            log.writeLog(log.LV_INFO, this, "initialize",kind);
           var pExec:ParallelExecutor = new ParallelExecutor();
           var sExecMain:SerialExecutor = new SerialExecutor();
            _kind = kind;
            var sets:Array = RareCardLot.getLotList(kind);
            // 最後を最初にしてみる
            var l:RareCardLot =sets.pop();
            sets.unshift(l);
            l =sets.pop();
            sets.unshift(l);

            _num = sets.length;
            _bitmapDataSet = new Vector.<BitmapData>(_num);
//            log.writeLog(log.LV_INFO, this, "sets is",sets);
            log.writeLog(log.LV_INFO, this, "sets",sets);
            sets.forEach(function(item:RareCardLot, index:int, array:Array):void{
                    var card:BaseScene;
                    var sExec:SerialExecutor = new SerialExecutor();
                    var container:UIComponent = new UIComponent;
                    container.visible = false;
                    Unlight.INS.topContainer.addChild(container);
                    switch (item.articleKind)
                    {
                    case Const.LOT_ARTICLE_ITEM:
                        card =  new ItemCardClip(AvatarItem.ID(item.articleID),item.num);
                        sExec.addThread(card.getShowThread(container));
                        break;
                    case Const.LOT_ARTICLE_PART:
                        log.writeLog(log.LV_INFO, this, "PARTS SETTTT!!!",item.articleID);
                        card = new PartCardClip(AvatarPart.ID(item.articleID));
                        sExec.addThread(card.getShowThread(container));
                        break;
                    case Const.LOT_ARTICLE_EVENT:
                        card = new EventCardClip(EventCard.ID(item.articleID));
                        sExec.addThread(card.getShowThread(container));
                        break;
                    case Const.LOT_ARTICLE_WEAPON:
                        card = new WeaponCardClip(WeaponCard.ID(item.articleID));
                        sExec.addThread(card.getShowThread(container));
                        break;
                    case Const.LOT_ARTICLE_CHARA:
                         if (item.visibleState == 0)
                         {
                             card = new CharaCardClip(CharaCard.ID(item.articleID),false,item.num);
                            sExec.addThread(card.getShowThread(container));
                         }else{
                             card = new CharaCardClip(CharaCard.ID(item.articleID));
                             sExec.addThread(CharaCardClip(card).getSepiaShowThread(container));
                         }
                        break;
                    default:
                        card = new CharaCardClip(CharaCard.ID(1));
                    }
//                   log.writeLog(log.LV_INFO, this, "item id", item.articleID, item.articleKind);
                    if (GENRE_ON)
                    {
                        sExec.addThread(new ClousureThread(container.addChild,[getGenreFrame(item.color, item.start, item.finish)]));
                    }
                    sExec.addThread(new WaitThread(2000,drawBitmap,[container, index]));
                    pExec.addThread(sExec)
                }
                );
            sExecMain.addThread(pExec);
            sExecMain.addThread(new ClousureThread(loaded));

            sExecMain.start();
            visible = false;
            _bitmap = new Bitmap(null,"auto",true);
            _lotInfoImage.alpha = 0;
            addChild(_bitmap);
            if (GENRE_ON)
            {
                addChild(_lotInfoImage);
            }
        }

        private function getGenreFrame(color:int, st:Boolean = false, fin:Boolean = false):Shape
        {
            var frame:Shape = new Shape();
            frame.graphics.lineStyle(8, COLOR_SET[color]);
            frame.graphics.lineTo(170, 0);
            if(st)
            {
                frame.graphics.moveTo(2, 0);
                frame.graphics.lineTo(2, 240);
            }
            if(fin)
            {
                frame.graphics.moveTo(168, 0);
                frame.graphics.lineTo(168, 240);
            }
            frame.graphics.moveTo(0, 240);
            frame.graphics.lineTo(170, 240);
            return frame;
        }



        private function drawBitmap(container:UIComponent, index:int):void
        {
            // _bitmapDataSet[index] = new BitmapData(85, 120, true,  0xFF0000);
            _bitmapDataSet[index] = new BitmapData(127, 180, true,  0xFF0000);
            _bitmapDataSet[index].draw(container,
                             new Matrix (0.75, 0, 0, 0.75, 0, 0),
                             null,
                             null,
                             new Rectangle(0, 0, 127,180),
                             // new Rectangle(0, 0, 85,120),
                             true
                );
            RemoveChild.apply(container);
        }

        private function loaded():void
        {
            _loaded =true;
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
        }

        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {
        }



        public function showStart():void
        {
            if(_loaded&&(__scrolling == false))
            {
                var _pExec:ParallelExecutor = new ParallelExecutor();
                _mainBitmapData = new BitmapData(520, 180, true,  0xFF0000);
                _bitmap.bitmapData= _mainBitmapData;
                visible = true;
                _bitmap.alpha = 0;
                new BeTweenAS3Thread(_bitmap, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE).start();;
                new BeTweenAS3Thread(_lotInfoImage, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE).start();;
                _scrollThread = new ScrollThread(_mainBitmapData,_bitmapDataSet);
                _scrollThread.start();
                __scrolling = true;

            }
            if(! _loaded)
            {
                new WaitThread(1000, showStart).start();
            }
        }
        public function showStop():void
        {
            if (__scrolling == true && _scrollThread != null)
            {
                _scrollThread.interrupt();
                __scrolling = false;
            }

            new BeTweenAS3Thread(_bitmap, {alpha:0.0}, null, 0.31, BeTweenAS3Thread.EASE_OUT_SINE).start();;
            new BeTweenAS3Thread(_lotInfoImage, {alpha:0.0}, null, 0.31, BeTweenAS3Thread.EASE_OUT_SINE).start();;
        }



    }
}


import flash.display.*;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;


class ScrollThread extends Thread
{
    private var _source:BitmapData;

    private var _counter:int;
    private var _w:int;
    private var _h:int;
    private var _cardWidth:int;

    private var _rect:Rectangle;
    private var _pointSet:Vector.<Point>;
    private var _bitmapDataSet:Vector.<BitmapData>;
    private var _setNum:int;
    private var _speed:int = 10;
    private var _cardCount:int =0;
    private var _pointNum:int = 0;
    private var _currentCardSet:Array; /* of int */
    private var _maskShape:Shape = new Shape();
    private var _maskBitmapData:BitmapData;
    private var _maskRect:Rectangle;
    private var _maskPoint:Point = new Point(0,0);
    public function ScrollThread(s:BitmapData, dataSet:Vector.<BitmapData>)
    {
        _source = s;

        _w =  s.width;
        _h = s.height;

        _cardWidth = dataSet[0].width;
        _bitmapDataSet = dataSet;
        _setNum = dataSet.length;
        log.writeLog(log.LV_INFO, this, "width",_cardWidth);
        _counter = 0;
        _rect = new Rectangle(0,0,dataSet[0].width,dataSet[0].height);
        _pointSet = new Vector.<Point>()
        for(var i:int = 0; i < _cardWidth; i+=_speed){
            _pointSet.push (new Point(-(i),0));
        }
        _currentCardSet = [0,1,2,3,4,5,6,7,8,9];
        _pointNum = _pointSet.length;
        _maskRect = new Rectangle(0,0,_w,_h);
//        copyPixels();
        createMask();
    }

    private function createMask():void
    {
        var fillType:String = GradientType.LINEAR;
        var colors:Array = [0xFFFFFF, 0xFFFFFF];
        var alphas:Array = [0, 1];
        var ratios:Array = [0x00, 0xFF];
        var matr:Matrix = new Matrix();
        matr.createGradientBox(240, _h, 0, 0, 0);
        var spreadMethod:String = SpreadMethod.REFLECT;
        _maskShape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
        _maskShape.graphics.drawRect(0,0,520,180);
        _maskBitmapData =  new BitmapData(520, 180, true,  0x000000);
        _maskBitmapData.draw(_maskShape,
                             new Matrix (1.0,0,0,1.0, 0, 0),
                             null,
                             null,
                             new Rectangle(0, 0, 520, _h),
                             true
            );
//         _maskBitmapData.fillRect(new Rectangle(0, 0, 80, _h),0x00000000);
         _maskBitmapData.fillRect(new Rectangle(_w-40, 0, 40 , _h),0x00000000);

    }

    protected override function run():void
    {
        next(scrolling);
    }

    private function incCardSet():void
    {
        var newSet:Array;
        newSet = [
            _currentCardSet[1],
            _currentCardSet[2],
            _currentCardSet[3],
            _currentCardSet[4],
            _currentCardSet[5],
            _currentCardSet[6],
            _currentCardSet[7],
            _currentCardSet[8],
            _currentCardSet[9],
            _currentCardSet[9]+1,
            ];
        if (newSet[9]>_setNum-1)
        {
            newSet[9] = 0;
        }
        _currentCardSet = newSet;
    }

    private function copyPixels():void
    {
        _currentCardSet.forEach(function(item:*, index:int, array:Array):void
                                {
                                    var _p:Point = _pointSet[_counter].clone();
                                    _p.offset(_cardWidth*index,0);
                                    _source.copyPixels(_bitmapDataSet[item], _rect,_p);
                                }
            );
//          var _p:Point = _pointSet[_counter].clone();
//          _p.offset(_cardWidth*9,0);
//          _source.copyPixels(_bitmapDataSet[ _currentCardSet[9]], _rect,_p);
    }

    private function scrolling():void
    {
        _source.lock()
        if (_counter > _pointNum-1)
        {
            _counter = 0;
            incCardSet();
        }
//        _source.scroll(-(_speed),0);
        copyPixels();
        _counter++;
        _source.merge(_maskBitmapData, _maskRect ,_maskPoint, 0,0,0,255);
//        _source.merge(_maskBitmapData, _maskRect ,_maskPoint, 255,255,255,255);
        _source.unlock()
        next(waitFrame);
    }

    private function waitFrame():void
    {
        if (checkInterrupted())
        {
            return;
        }
        next(scrolling);
    }
}