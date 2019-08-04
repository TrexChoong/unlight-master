package view.scene.common
{

    import flash.display.*;
    import flash.events.Event;
    import flash.geom.*;
    import flash.events.MouseEvent;

    import flash.filters.DropShadowFilter;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;

    import view.image.common.AvatarImage;
    import view.utils.*;
    import view.image.common.AvatarPartImage;
    import view.scene.BaseScene;
    import view.*;

    /**
     * AvatarClip表示クラス
     *
     */

    public class AvatarClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "プレイヤーのアバターです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "The player's avatar.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "玩家的虛擬人物";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "玩家的虚拟人物";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "플레이어의 아바타 입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Avatar du Joueur";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "プレイヤーのアバターです。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "อวาตาร์ของผู้เล่น";


//         public static const TYPE_LOBBY:int = 0;
//         public static const TYPE_MATCH_ROOM:int = 1;
//         public static const TYPE_MATCH:int = 2;
//         public static const TYPE_EDIT:int = 3;
//         public static const TYPE_QUEST:int = 4;

        private static const CLIP_SIZE_WIDTH:int = 290;
        private static const CLIP_SIZE_HEIGT:int = 450;
        private static const CLIP_X_OFFSET:int = 130;
        private static const CLIP_Y_OFFSET:int = 410;

        private static const NORMAL_SCALE:Number = 1;
//        private static const NORMAL_SCALE:Number = 1;
        private static const NORMAL_CLIP_SIZE_WIDTH:int = int(CLIP_SIZE_WIDTH * NORMAL_SCALE);
        private static const NORMAL_CLIP_SIZE_HEIGT:int = int(CLIP_SIZE_HEIGT * NORMAL_SCALE);

        private static const LOBBY_SCALE:Number = 1.0;
//        private static const LOBBY_SCALE:Number = 1;
        private static const LOBBY_CLIP_SIZE_WIDTH:int = int(CLIP_SIZE_WIDTH * LOBBY_SCALE);
        private static const LOBBY_CLIP_SIZE_HEIGT:int = int(CLIP_SIZE_HEIGT * LOBBY_SCALE);
        private static const LOBBY_CLIP_X_OFFSET:int = int(CLIP_X_OFFSET * LOBBY_SCALE);
        private static const LOBBY_CLIP_Y_OFFSET:int = int(CLIP_Y_OFFSET * LOBBY_SCALE);

        private static const MATCH_CLIP_SCALE:Number = 1;
//        private static const MATCH_CLIP_SCALE:Number = 0.1;
        private static const MATCH_CLIP_SIZE_WIDTH:int = int(CLIP_SIZE_WIDTH * MATCH_CLIP_SCALE);
        private static const MATCH_CLIP_SIZE_HEIGT:int = int(CLIP_SIZE_HEIGT * MATCH_CLIP_SCALE);
        private static const MATCH_CLIP_X_OFFSET:int = int(CLIP_X_OFFSET * MATCH_CLIP_SCALE);
        private static const MATCH_CLIP_Y_OFFSET:int = int(CLIP_Y_OFFSET * MATCH_CLIP_SCALE);

        private static const MATCH_ROOM_CLIP_SCALE:Number = 1;
//        private static const MATCH_ROOM_CLIP_SCALE:Number = 0.1;
        private static const MATCH_ROOM_CLIP_SIZE_WIDTH:int = int(98);
        private static const MATCH_ROOM_CLIP_SIZE_HEIGT:int = int(120);
        private static const MATCH_ROOM_CLIP_X_OFFSET:int = int(CLIP_X_OFFSET * MATCH_ROOM_CLIP_SCALE-80);
        private static const MATCH_ROOM_CLIP_Y_OFFSET:int = int(CLIP_Y_OFFSET * MATCH_ROOM_CLIP_SCALE-70);


        private static const MATCH_CLIP_X:int = 35;
        private static const MATCH_CLIP_Y:int = 50;

        private static var CASHED_CONTAINER:Object = new Object();
        private static var CASHED_SIZE:int = 50;

//         private  static var __parts_type_set = new Array(65);

//         private static const MATCHROOM_CLIP_X:int = 50;
//         private static const MATCHROOM_CLIP_Y:int = 150;
//         private static const MATCHROOM_CLIP_SCALE:Number = 0.88;                           // アバターイメージ幅

        private var  _bitmapDataSet:Vector.<BitmapData> = new Vector.<BitmapData>(Const.PL_AVATAR_NUM);   // アバターのX位置

        // 表示コンテナ
        private var _container:UIComponent;;

        // アバターのベース
        private var _avatarImage:AvatarImage = new AvatarImage();

        // アバターの追加パーツベース
        private var _avatarPartClip:Vector.<AvatarPartClip > = new Vector.<AvatarPartClip>();

        // ヘルプ用のステート
        private static const _GAME_HELP:int = 0;

        //キャッシュ用ビットマップデータ
        private var _mainBitmapData:BitmapData;

        // matchロビー向けビットマップデータ
        private var _lobbyBitmapData:BitmapData;

        // matchロビー向けビットマップデータ
        private var _matchBitmapData:BitmapData;

        // matchロビー向けビットマップデータ
        private var _matchRoomBitmapData:BitmapData;

        // 描画用bitmapdata
        private var _mainBitmap:Bitmap;

        private var _type:int;

        //元アバター
        private var _avatar:IAvatarParts;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["プレイヤーのアバターです。"],
                [_TRANS_MSG],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private  var _toolTipOwnerArray:Array = [];

        /**
         * コンストラクタ
         *
         */
        public function AvatarClip(avatar:IAvatarParts, t:int = 0)
        {
            _avatar = avatar;
            _type = t;
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  // 本体
        }
        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        // 初期化
        public override function init():void
        {
//            log.writeLog(log.LV_FATAL, this, "init     ");
            var items:Array = _avatar.getEquipedParts();
            alpha = 0;

            if (CASHED_CONTAINER[items]==null)
            {
//                log.writeLog(log.LV_FATAL, this, "init not caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaash");
                _container = new UIComponent();
                var pExec:ParallelExecutor = new ParallelExecutor();
                var sExec:SerialExecutor = new SerialExecutor();
//            sExec.addThread(_avatarImage.getShowThread(_container));
                for(var i:int = 0; i < items.length; i++)
                {
                    _avatarPartClip.push(new AvatarPartClip(items[i]));
//                 pExec.addThread(_avatarPartClip[i].getAttachShowThread(_container));
                }

                sExec.addThread(AvatarPartClip.getAttachShowThread(_avatarPartClip,_container));
                sExec.addThread(new ClousureThread(createCashBitmapData));
                sExec.start();
                CASHED_CONTAINER[items] = _container;
            }else{
//                log.writeLog(log.LV_FATAL, this, "init caaaaashhhhhhhhhhhhhhhh",CASHED_CONTAINER[items]);
               _container = CASHED_CONTAINER[items];
                createCashBitmapData();
            }
            _container.visible = false;
            mouseEnabled = false;
            mouseChildren = false;
//            addChild(_container);
            initilizeToolTipOwners();
            updateHelp(_GAME_HELP);
        }

        private function createCashBitmapData():void
        {
            log.writeLog(log.LV_FATAL, this, "Create cashcbitmap data");
            // ロビー用
            _lobbyBitmapData = new BitmapData(LOBBY_CLIP_SIZE_WIDTH,LOBBY_CLIP_SIZE_HEIGT, true, 0x000000000);
            new DrawThread(_container, _lobbyBitmapData,
                                 new Matrix (LOBBY_SCALE,0,0,LOBBY_SCALE, LOBBY_CLIP_X_OFFSET, LOBBY_CLIP_Y_OFFSET),
                                 null,
                                 null,
                                 new Rectangle(0, 0, LOBBY_CLIP_SIZE_WIDTH,LOBBY_CLIP_SIZE_HEIGT),true
                ).start();

            _bitmapDataSet[Const.PL_AVATAR_LOBBY] = _lobbyBitmapData;
            _bitmapDataSet[Const.PL_AVATAR_MATCH] = _lobbyBitmapData;


            // マッチルームの顔アイコンアバターをつくる
            // マッチ中のアバターをつくる
            _matchRoomBitmapData = new BitmapData(MATCH_ROOM_CLIP_SIZE_WIDTH, MATCH_ROOM_CLIP_SIZE_HEIGT, true,  0x000000);
            new DrawThread(_container,_matchRoomBitmapData,
                                  new Matrix (-MATCH_ROOM_CLIP_SCALE,0,0,MATCH_ROOM_CLIP_SCALE, MATCH_ROOM_CLIP_X_OFFSET, MATCH_ROOM_CLIP_Y_OFFSET),
                                  null,
                                  null,
                                  new Rectangle(0, 0, MATCH_ROOM_CLIP_SIZE_WIDTH, MATCH_ROOM_CLIP_SIZE_HEIGT),true
            ).start();


            _bitmapDataSet[Const.PL_AVATAR_MATCH_ROOM] = _matchRoomBitmapData;

            // マッチ中のアバターをつくる
//            _matchBitmapData = new BitmapData(MATCH_CLIP_SIZE_WIDTH, MATCH_CLIP_SIZE_HEIGT, true,  0x00000000);


//             new DrawThread(_container,_matchBitmapData,
//                            new Matrix (MATCH_CLIP_SCALE,0,0,MATCH_CLIP_SCALE, MATCH_CLIP_X_OFFSET, MATCH_CLIP_Y_OFFSET),
//                            null,
//                            null,
//                            new Rectangle(0, 0, MATCH_CLIP_SIZE_WIDTH, MATCH_CLIP_SIZE_HEIGT),true
//             ).start();



//             _bitmapDataSet[2] = _matchBitmapData;


//             // ノーマル（元になるビットマップ）
//             _mainBitmapData = new BitmapData(CLIP_SIZE_WIDTH, CLIP_SIZE_HEIGT, true, 0xFFFF00FF);

//             new DrawThread(_container, _mainBitmapData,
//                                  new Matrix (0.25,0,0,0.25, 110, 400),
//                                  null,
//                                  null,
//                                  new Rectangle(-50, 0, CLIP_SIZE_WIDTH,CLIP_SIZE_HEIGT),true
//             ).start();

            _bitmapDataSet[Const.PL_AVATAR_EDIT] = _lobbyBitmapData;;
            _bitmapDataSet[Const.PL_AVATAR_QUEST] = _lobbyBitmapData;;

            _mainBitmap = new Bitmap(_mainBitmapData,"auto",true);
            updateType();
            addChild(_mainBitmap);
        }

        public function set type(i:int):void
        {
            _type = i;
        }

        public function updateType(t:int =-1):void
        {
            if (t !=-1)
            {
                _type= t;
            }
//            log.writeLog(log.LV_FATAL, this, "_type" , _mainBitmapData, _bitmapDataSet[_type]);
            if (_mainBitmap!= null)
            {
                _mainBitmap.bitmapData = _bitmapDataSet[_type];
            }
        }


        // 後処理
        public override function final():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            if (CASHED_CONTAINER.length>CASHED_SIZE)
            {


            }
            RemoveChild.apply(_mainBitmap);
            pExec.addThread(_avatarImage.getHideThread());
            pExec.start();
//            pExec.join();
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
//            _type = type;
            var sExec:SerialExecutor = new SerialExecutor();
            // かならずパーツがすべて読み込めていることが前提！！！
            sExec.addThread(_avatar.getWaitEquipedPartsDataThread());
            sExec.addThread(new ShowThread(this, stage));
//            sExec.addThread(new TweenerThread(this, { alpha: 1.0, transition:"easeOutSine", time: 0.15, show: true}));
            if (_type ==Const.PL_AVATAR_LOBBY)
            {
                var i:int = x;
                sExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0,x:i}, {alpha:0.0,x:i+200}, 2.1/Unlight.SPEED, BeTweenAS3Thread.EASE_IN_SINE, 0.0 ,true));
            }else{
                sExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.5/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            }
            return sExec;
        }

        public  function getPartsChangeShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var sExec:SerialExecutor = new SerialExecutor();
            // かならずパーツがすべて読み込めていることが前提！！！
            sExec.addThread(_avatar.getWaitEquipedPartsDataThread());
            sExec.addThread(new ShowThread(this, stage));
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.3/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            return sExec;
        }
        // 非表示スレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return super.getHideThread();
//            return new Thread();
        }
        public function getPartsChangeHideThread(type:String=""):Thread
        {
            var sExec:SerialExecutor = new SerialExecutor();
//            sExec.addThread(new SleepThread(500));
            sExec.addThread(new BeTweenAS3Thread(this, {alpha:0.0}, null, 0.3/Unlight.SPEED, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            sExec.addThread(super.getHideThread());
            return sExec;
        }

    }

}


import flash.display.*;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;

import view.scene.BaseScene;
import view.BaseShowThread;
import view.BaseHideThread;
import view.*;

import view.image.BaseImage;
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
        log.writeLog(log.LV_FATAL,this, "start avatarclip show")
        next(close);
    }
}


// 諸般の事情でウェイトしながら描画。クソが。(いくらやってもだめなんで3秒ほど再描画したる)
class DrawThread extends Thread
{
    private var _d:DisplayObject;
    private var _bd:BitmapData;
    private var _offset:Matrix;
    private var _counter:int = 0;
    private static const _WAIT_FRAME:int = 8;
    private var _colorTransform:ColorTransform;
    private var _blendMode:String;
    private var _clipRect:Rectangle;
    private var _smoothing:Boolean = false;

    public function DrawThread(d:DisplayObject, b:BitmapData, offset:Matrix = null, colorTransform:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false)
    {
        _d = d;
        _bd = b;
        _offset = offset;
        _colorTransform = _colorTransform;
        _blendMode      = _blendMode;
        _clipRect       = _clipRect;
        _smoothing      = _smoothing;
    }

    protected override function run():void
    {
        next(draw);
    }

    private function draw():void
    {
        if (_counter > _WAIT_FRAME)
        {
            _bd.draw(_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing);
            var sExec:SerialExecutor = new SerialExecutor();
            sExec.addThread(new SleepThread(1000));
            sExec.addThread(new ClousureThread(_bd.draw,[_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing]));
            // sExec.addThread(new SleepThread(1000));
            // sExec.addThread(new ClousureThread(_bd.draw,[_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing]));
            // sExec.addThread(new SleepThread(1000));
            // sExec.addThread(new ClousureThread(_bd.draw,[_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing]));
            // sExec.addThread(new SleepThread(1000));
            // sExec.addThread(new ClousureThread(_bd.draw,[_d, _offset,_colorTransform, _blendMode, _clipRect, _smoothing]));
            sExec.start();
            return;
        }else{
            _counter +=1;
            next(draw)
                }
    }
}

