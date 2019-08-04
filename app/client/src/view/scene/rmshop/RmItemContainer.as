package view.scene.rmshop
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.utils.SerialExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;

    import model.*;
    import model.events.*;

    import view.image.rmshop.*;
    import view.scene.*;
    import view.*;
    import view.utils.*;


    /**
     * クエストキャラ表示クラス
     *
     */
    public class RmItemContainer extends BaseScene
    {
        private static const _TRANS_MSG	:String = "";

        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ
        private var _rmTabContainerSet:Array = []; /* of Array */
        private var _rmItemClipSet:Array = []; /* of Array */
        private var _type:int = 0;

        private var _isSale:Boolean = false;


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [_TRANS_MSG],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _NORMAL_HELP:int = 0;

        private var _id:int;

        /**
         * コンストラクタ
         *
         */
        public function RmItemContainer()
        {
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
            log.writeLog(log.LV_FATAL, this, "init");
            // セール中かどうかを保存しておく
            _isSale = Player.instance.avatar.isSaleTime;

            // タブ種類ごとに読み出してそれぞれのコンテナに格納する
            for(var i:int = 0; i < RealMoneyShopView.TYPE_LENGTH; i++){
                _rmTabContainerSet.push(new UIComponent());
                _rmItemClipSet.push([]);
                var list:Array = RealMoneyItem.getTabList(i);
                for(var j:int = 0; j < list.length; j++)
                {
                    var x:RealMoneyItem = list[j];
                    _rmItemClipSet[i].push(new RmItemClip(x));
                    // log.writeLog(log.LV_FATAL, this, "init ", _rmItemClipSet[i][_rmItemClipSet[i].length-1],x.id,_rmItemClipSet.length,new RmItemClip(x));
                    _rmItemClipSet[i][_rmItemClipSet[i].length-1].getShowThread(_rmTabContainerSet[i]).start();
                }
                addChild(_rmTabContainerSet[i]);
            }
            positonUpdate();
        }
        private function positonUpdate():void
        {
            for(var i:int = 0; i < _rmItemClipSet.length; i++)
            {
              var x:Object = _rmItemClipSet[i];

                for(var j:int = 0; j < x.length; j++)
                {
                  var y:Object = x[j];
                    y.y = 220;
                    y.x= 110*j;
                }

                _rmTabContainerSet[i].x = (Unlight.WIDTH-x.length*110)/2

            }

        }


        public function setTab(t:int):void
        {
//            log.writeLog(log.LV_FATAL, this, "+++setTab");
            for(var i:int = 0; i < _rmTabContainerSet.length; i++)
            {
                if (i==t)
                {
                    _rmTabContainerSet[i].visible = true;
                }else{
                    _rmTabContainerSet[i].visible = false;

                }
            }
            _type = t;
        }


        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            // log.writeLog(log.LV_FATAL, this, "getShowThread");
            return new ModelWaitThread(this,stage);
        }

        // アイテムを読み込みなおす
        private function resetContainer():void
        {
            // log.writeLog(log.LV_FATAL, this, "sale item reset");
            var isSaleTime:Boolean = Player.instance.avatar.isSaleTime;
            // 状態が変わってなければ、読み直しをしない
            if ( _isSale == isSaleTime ) {
                return;
            }
            _isSale = isSaleTime;

            // 一度すべて開放する
            var i:int = 0, j:int = 0;
            for(i = 0; i < _rmTabContainerSet.length; i++){
                RemoveChild.apply(_rmTabContainerSet[i]);
            }
            _rmTabContainerSet.length = 0;
            _rmItemClipSet.length = 0;

            // log.writeLog(log.LV_FATAL, this, "sale item init");

            // タブ種類ごとに読み出してそれぞれのコンテナに格納する
            for(i = 0; i < RealMoneyShopView.TYPE_LENGTH; i++){
                _rmTabContainerSet.push(new UIComponent());
                _rmItemClipSet.push([]);
                var list:Array = RealMoneyItem.getTabList(i);
                for(j = 0; j < list.length; j++)
                {
                    var x:RealMoneyItem = list[j];
                    _rmItemClipSet[i].push(new RmItemClip(x));
                    // log.writeLog(log.LV_FATAL, this, "init ", _rmItemClipSet[i][_rmItemClipSet[i].length-1],x.id,_rmItemClipSet.length,new RmItemClip(x));
                    _rmItemClipSet[i][_rmItemClipSet[i].length-1].getShowThread(_rmTabContainerSet[i]).start();
                }
                _rmTabContainerSet[i].visible = false;
                _rmTabContainerSet[i].alpha = 1.0;
                addChild(_rmTabContainerSet[i]);
            }

            positonUpdate();
            setTab(_type);
        }

        public function itemReset():void
        {
            // log.writeLog(log.LV_FATAL, this, "sale itemReset");
            resetContainer();
        }


    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.BaseModel;
import model.RealMoneyItem;

import view.BaseShowThread;
import view.IViewThread;
import view.scene.common.AvatarClip;

class ModelWaitThread extends BaseShowThread
{
    private var _v:IViewThread;

    public function ModelWaitThread(view:IViewThread,stage:DisplayObjectContainer)
    {
        _v = view;
        super(view, stage);
    }

    protected override function run():void
    {
//        log.writeLog(log.LV_INFO, this, "run?");
        if (RealMoneyItem.inited)
        {
            next(close);
        }else{
            next(waitItemInfo);
        }
    }

    private function waitItemInfo():void
    {
        if (RealMoneyItem.inited)
        {
            next(close);
        }else{
            next(waitItemInfo);
        }
    }



}
