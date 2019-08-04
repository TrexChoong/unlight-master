package view.scene
{

    import flash.display.*;
    import mx.core.UIComponent;

    import org.libspark.thread.*;

    import view.IViewThread;

    import model.Option;

    /**
     * SWFのムービークリップを使用したシーンの基底クラス
     * シーンの各クラスはレイアウトを提供する（Imageのようにローダを持たない）
     * imageの協調動作が必要な時につくる
     *
     */


    public class BaseScene extends UIComponent  implements IViewThread
    {
        protected var _depthAt:int;
        protected var _option:Option = Option.instance;
        private var _helpTextArray:Array = []; /* of String or Null */ 
        private var _toolTipOwnerArray:Array = []; /* of UIComponent */
        protected var _finished:Boolean = false;

        public function BaseScene()
        {
//            Unlight.GCW.watch(this);
        }


        // 表示用のスレッドを返す
        public function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _finished = false;
            _depthAt = at;
            return  new ShowThread(this, stage);
        }

        // 表示用のスレッドを返す
        public function getHideThread(type:String=""):Thread
        {
            return  new HideThread(this);
        }

        // 並びを返す
        public function get depthAt():int
        {
            return _depthAt;
        }

        // hideスレッドの後処理メソッド
        public function final():void
        {
            _finished =true;
        }


        // showスレッドの後処理メソッド
        public function init():void
        {
            if(_finished){
                log.writeLog(log.LV_WARN, this, "------------------- イニシャライズ前にファイナライズがすでに走っている！！！！！");
                final();
            };
        }

        protected function get helpTextArray():Array /* of String or Null */ 
        {
            return _helpTextArray;
        }

        protected function get toolTipOwnerArray():Array /* of String or Null */ 
        {
            return _toolTipOwnerArray;
        }


        // ヘルプをアップデート
        protected function updateHelp(helpState:int):void
        {
            toolTipOwnerArray.forEach(function(item:*, index:int, array:Array):void{item[1].toolTip = helpTextArray[helpState][item[0]]});
        }

    }

}

import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.scene.BaseScene;
import view.BaseShowThread;
import view.BaseHideThread;


// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(bs:BaseScene, stage:DisplayObjectContainer)
    {
        super(bs, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(bs:BaseScene)
    {
        super(bs);
    }

}




