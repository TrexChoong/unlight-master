package view.scene.common
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import flash.utils.Dictionary;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.AvatarItemEvent;

    import view.image.common.*;

    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * SocialLogClipの表示クラス
     *
     */

    public class SocialLogClip extends BaseScene
    {
        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // ログの出力モード
        private var _mode:int;
        // ログの内容
        private var _content:String;

        // 表示枠
        private var _logIcon:*;
        private var _textBase:SocialLogTextBase = new SocialLogTextBase();

        // 表示内容
        private var _label:Text = new Text();

        /**
         * コンストラクタ
         *
         */
        public function SocialLogClip(ql:QuestLog)
        {
            _mode = ql.type;
            _content = ql.body;
            log.writeLog(log.LV_FATAL, this, "social log clip init", _mode, _content);
            switch (_mode)
            {
            case Const.LOG_AVATAR:
                _logIcon = new SocialLogIcon();
                _logIcon.x = 5;
                _logIcon.y = 5;
                break;
            case Const.LOG_CHARA:
                _logIcon = new SocialLogIcon();
                _logIcon.x = 5;
                _logIcon.y = 5;
                break;
            case Const.LOG_QUEST:
                _logIcon = new SocialLogIcon();
                _logIcon.x = 5;
                _logIcon.y = 5;
                break;
            case Const.LOG_SYSTEM:
                _logIcon = new SocialLogIcon();
                _logIcon.x = 5;
                _logIcon.y = 5;
                break;
            case Const.LOG_SYSTEM:
                _logIcon = new SocialLogIcon();
                _logIcon.x = 5;
                _logIcon.y = 5;
                break;
            default:
                _logIcon = new SocialLogIcon();
                _logIcon.x = 5;
                _logIcon.y = 5;
            }

            _logIcon.getShowThread(_container).start();

            _textBase.x = 45;
            _textBase.y = 5;
            _textBase.scaleY = 1.0;

            _label.text = _content;
            _label.x = 70;
            _label.y = 10;
            _label.width = 240;
            _label.height = 60;
            _label.styleName = "SocialLogTextLabel";

            _container.addChild(_textBase);
            _container.addChild(_label);

            addChild(_container);
        }

        // 初期化
        public override function init():void
        {
//             switch (_mode)
//             {
//             case Const.LOG_QUEST:
//                 _logIcon = new SocialLogIcon();
//                 _logIcon.x = 5;
//                 _logIcon.y = 5;
//                 break;
//             case Const.LOG_SYSTEM:
//                 _logIcon = new SocialLogIcon();
//                 _logIcon.x = 5;
//                 _logIcon.y = 5;
// //                 _logIcon = new AvatarClip();
// //                 _logIcon.scaleX = 0.5;
// //                 _logIcon.scaleY = 0.5;
//                 break;
//             default:
//             }

//             _logIcon.getShowThread(_container).start();

//             _textBase.x = 45;
//             _textBase.y = 5;
//             _textBase.scaleY = 1.0;

//             _label.text = _content;
//             _label.x = 70;
//             _label.y = 10;
//             _label.width = 240;
//             _label.height = 60;
//             _label.styleName = "SocialLogTextLabel";

//             _container.addChild(_textBase);
//             _container.addChild(_label);

//             addChild(_container);
        }

//         private function createCashBitmapData():void
//         {
//             _mainBitmapData = new BitmapData(CLIP_SIZE_WIDTH, CLIP_SIZE_HEIGT, true, 0x00000000);
//             _mainBitmapData.draw(_container,new Matrix (-0.35,0,0,0.35, 50, 400),null,null,new Rectangle(-50, 0, CLIP_SIZE_WIDTH, CLIP_SIZE_HEIGT),true);
//             // マッチのアバターをつくる
//             _matchBitmapData = new BitmapData(MATCH_CLIP_SIZE_WIDTH, MATCH_CLIP_SIZE_HEIGT, true, 0x00000000);
//             _matchBitmapData.draw(_container,new Matrix (-0.35,0,0,0.35, 50, 400),null,null,new Rectangle(-50, 0, CLIP_SIZE_WIDTH, CLIP_SIZE_HEIGT),true);
// //             _matchBitmapData.copyPixels(_mainBitmapData, new Rectangle(MATCH_CLIP_X, MATCH_CLIP_Y, MATCH_CLIP_SIZE_WIDTH, MATCH_CLIP_SIZE_HEIGT),new Point(0,0));
//             // マッチルームの顔アバターをつくる
//             _matchRoomBitmapData = new BitmapData(MATCHROOM_CLIP_SIZE_WIDTH, MATCHROOM_CLIP_SIZE_HEIGT, true, 0x00000000);
//             _matchRoomBitmapData.draw(_container,
//                                       new Matrix (0.33,0,0,0.33, 50, 362),
//                                       null,
//                                       null,
//                                       new Rectangle(0, 0, CLIP_SIZE_WIDTH, CLIP_SIZE_HEIGT)
//                 );
//             _mainBitmap = new Bitmap(_mainBitmapData,"auto",true);
//             setType()
//             addChild(_mainBitmap);
//         }

        // 後処理
        public override function final():void
        {
            _container.removeChild(_textBase);
            _container.removeChild(_logIcon);
            _container.removeChild(_label);
            removeChild(_container);
        }


        // モードを返す
        public function get mode():int
        {
            return _mode;
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }
    }

}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.BaseModel;

import view.BaseShowThread;
import view.IViewThread;
import view.scene.common.AvatarClip;

class ShowThread extends BaseShowThread
{
    public function ShowThread(view:IViewThread, stage:DisplayObjectContainer, at:int)
    {
        super(view, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}