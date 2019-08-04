package view.scene.game
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;

    import mx.core.UIComponent;
    import mx.containers.Box;
    import mx.controls.Label;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;

    import model.Feat;
    import view.image.game.*;
    import view.scene.BaseScene;
    import view.utils.*;

    /**
     * Feat表示クラス
     *
     */


    public class FeatClip extends BaseScene
    {
        private var _container:UIComponent = new UIComponent(); // 表示コンテナ
        private var _feat:Feat;
        private var _image:FeatImage;

        private var _box:Box = new Box();
        private var _name:Label = new Label();

        private static var __feats:Array = []; /* of Feat Clip */ 
        private var _id:int;
        private static const URL:String = "/public/image/";


        // 必殺技のIDからクリップを作って返す。作成済みならそれを返す。
        public static function getInstance(id:int):FeatClip
        {
            if (__feats[id] == null)
            {
                __feats[id] =  new FeatClip(Feat.ID(id));
            }
            return __feats[id];
        }

        public static function clearCache():void
        {
            for (var key:Object in __feats)
            {
                RemoveChild.apply(__feats[key]);
                __feats[key].final();
                delete __feats[key];
            }
            log.writeLog(log.LV_FATAL, "Clear FeatClip",__feats);
        }

        /**
         * コンストラクタ
         *
         */
        public function FeatClip(feat:Feat)
        {
            _feat = feat;
            if (_feat.loaded)
            {
                _image = new FeatImage(URL+_feat.image);
                log.writeLog(log.LV_DEBUG,this,"++++++++++++++ feat img url : "+ URL+_feat.image);
            }
            else
            {
                _feat.addEventListener(Feat.INIT, featInitHandler);
            }
        }

        private function featInitHandler(e:Event):void
        {
            _image = new FeatImage(URL+_feat.image);
        }

        public override function final():void
        {
                _feat.removeEventListener(Feat.INIT, featInitHandler);
        }

        public function clipInitialize():Thread
        {
//            var plThread:ParallelExecutor = new ParallelExecutor();
//            plThread.addThread(_image.getShowThread(this));

            return _image.getShowThread(this);
        }

        public function labelInitialize():void
        {
//             _name.x = 30;
//             _name.y = 8;
//             _name.styleName = "FeatInfoLabelFlash"
//             _name.width = 200;
//             _name.height = 40;
//             _name.text = _feat.name;

//             //_container.addChild(_name);
//             addChild(_container);
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(_feat, this, stage);
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        // 左右反転
        public function setAnime(player:Boolean):void
        {
            if(player)
            {
                _image.plAnime();
            }
            else
            {
                _image.foeAnime();
            }
        }

        public function get feat():Feat
        {
            return _feat;
        }

        public override function get name():String
        {
            return _name.text;
        }

    }

}

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import org.libspark.thread.Thread;

import model.Feat;
import view.scene.game.FeatClip;
import view.BaseShowThread;
import view.utils.*;

class ShowThread extends BaseShowThread
{
    private var _feat:Feat;
    private var _featClip:FeatClip;

    public function ShowThread(feat:Feat, featClip:FeatClip, stage:DisplayObjectContainer)
    {
        _feat = feat;
        _featClip = featClip;
        super(featClip,stage)
    }

    protected override function run():void
    {
        // 必殺技の準備を待つ
        if (_feat.loaded == false)
        {
            _feat.wait();
        }
        next(init);
    }

    private function init ():void
    {
        var thread:Thread;
        thread = _featClip.clipInitialize();
        thread.start();
        thread.join();
        next(waiting);
    }

    private function waiting():void
    {
        next(close);
    }

    protected override function close ():void
    {
        _featClip.labelInitialize();
        addStageAt();
    }
}

// 非表示用のスレッド
class HideThread extends Thread
{
    private var _featClip:FeatClip;

    public function HideThread(featClip:FeatClip)
    {
        _featClip = featClip;
        name = "feat cli"
    }

    protected override function run():void
    {
//         // ステージに追加されてたらデータを消す
//         if(_featClip.parent != null)
//         {
//             next(hide);
//         }
//         else
//         {
//             next(run);
//         }
        next(exit)
    }

    private function hide():void
    {
        next(exit);
    }

    private function exit():void
    {
        RemoveChild.apply(_featClip);
    }
}
