package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import view.image.common.*;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.game.BuffClip;
    import view.scene.ModelWaitShowThread;
    import view.utils.*;

    /**
     * PartCardClipのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class PartCardClip extends BaseScene
    {
        // イメージ
        private var _image:AvatarPartIcon;
        private var _avatarPart:AvatarPart;
        private var _cardFrame:CardFrame;
        private var _name:Label = new Label();
        private var _caption:Text = new Text();

        /**
         * コンストラクタ
         *
         */
        public function PartCardClip(ai:AvatarPart)
        {
            _avatarPart = ai;
        }

        // 初期化
        public override function init():void
        {
            _cardFrame = new CardFrame(CardFrame.FRAME_GREEN);

             _image.x = 20;
             _image.y = 35;
             _image.scaleX = 1;
             _image.scaleY = 1;

            _name.x = 0;
            _name.y = 5;
            _name.width = 164;
            _name.height = 100;
            _name.text = _avatarPart.name;
            _name.styleName = "ResultNameLabel";
            _name.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            _caption.x = 15;
            _caption.y = 180;
            _caption.width = 144;
            _caption.height = 90;
            _caption.text = _avatarPart.caption;
            _caption.styleName = "ResultTextLabel";
            _caption.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            addChildAt(_cardFrame,0);
            addChild(_name);
            addChild(_caption);
        }

        // 後処理
        public override function final():void
        {
            _image.getHideThread().start();
            RemoveChild.apply(_cardFrame);
            RemoveChild.apply(_name);
            RemoveChild.apply(_caption);
        }

        public function imageInitialize():Thread
        {
             _image = new AvatarPartIcon(_avatarPart);
             return _image.getShowThread(this);
//             return AvatarPartClip.getAttachShowThread(Vector.<AvatarPartClip>([_image]), this);
        }
        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(_avatarPart, this, stage  );
        }

        public  function get partID():int
        {
            return _avatarPart.id;
        }

    }

}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import model.AvatarPart;
import view.scene.common.PartCardClip;
import view.BaseShowThread;
import view.BaseHideThread;
import controller.LobbyCtrl;



// 表示スレッド
class ShowThread extends BaseShowThread
{
    protected var _ai:AvatarPart;
    protected var _icc:PartCardClip;

    public function ShowThread(ai:AvatarPart, icc:PartCardClip, stage:DisplayObjectContainer)
    {
        _ai = ai;
        _icc = icc;
        super(icc,stage)
    }

    protected override function run():void
    {
        // キャラカードの準備を待つ
        if (_ai.loaded == false)
        {
            _ai.wait();
        }
        next(init);
    }


    private function init ():void
    {
        var thread:Thread;
        thread =  _icc.imageInitialize();
        thread.start();
        thread.join();
        next(close);
    }

}