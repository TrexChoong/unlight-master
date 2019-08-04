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

    /**
     * ItemCardClipのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class ItemCardClip extends BaseScene
    {
        // イメージ
        private var _image:AvatarItemImage;
        private var _avatarItem:AvatarItem;
        private var _cardFrame:CardFrame;
        private var _name:Label = new Label();
        private var _caption:Text = new Text();
        private var _num:int;
        private var _number:Label = new Label();

        /**
         * コンストラクタ
         *
         */
        public function ItemCardClip(ai:AvatarItem, num:int = 1)
        {
            _avatarItem = ai;
            _num = num;
        }

        // 初期化
        public override function init():void
        {
            _cardFrame = new CardFrame(CardFrame.FRAME_GREEN);

            _image.x = 83;
            _image.y = 100;

            _name.x = 0;
            _name.y = 5;
            _name.width = 164;
            _name.height = 100;
            _name.text = _avatarItem.name;
            _name.styleName = "ResultNameLabel";
            _name.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            _caption.x = 15;
            _caption.y = 180;
            _caption.width = 144;
            _caption.height = 90;
            _caption.text = _avatarItem.caption;
            _caption.styleName = "ResultTextLabel";
            _caption.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];

            addChildAt(_cardFrame,0);
            addChild(_name);
            addChild(_caption);

            if (_num>1)
            {
                _number.x = -35;
                _number.y = 180;
                _number.width = 190;
                _number.height = 100;
                _number.htmlText = "x<FONT SIZE =\"54\" >"+_num.toString()+"</FONT>";
                _number.styleName = "ResultCardNumLabel";
                _number.filters = [new GlowFilter(0xFF0000, 1, 6, 6, 3, 1)];
                addChild(_number)

            }
        }

        // 後処理
        public override function final():void
        {
            _image.getHideThread().start();
            if (_cardFrame.parent ==this){ removeChild(_cardFrame)};
            if (_name.parent == this){ removeChild(_name)};
            if (_caption.parent == this){ removeChild(_caption)};
        }

        public function imageInitialize():Thread
        {
            _image = new AvatarItemImage(_avatarItem.image, _avatarItem.imageFrame);
            return _image.getShowThread(this);

        }
        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(_avatarItem, this, stage  );
        }

        public  function get itemID():int
        {
            return _avatarItem.id;
        }

    }

}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import model.AvatarItem;
import view.scene.common.ItemCardClip;
import view.BaseShowThread;
import view.BaseHideThread;
import controller.LobbyCtrl;



// 表示スレッド
class ShowThread extends BaseShowThread
{
    protected var _ai:AvatarItem;
    protected var _icc:ItemCardClip;

    public function ShowThread(ai:AvatarItem, icc:ItemCardClip, stage:DisplayObjectContainer)
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