package view.scene.match
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;
    import mx.containers.*;
    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Match;
    import model.MatchRoom;
    import model.Channel;
    import model.events.*;

    import view.image.match.LoadingPanel;

    import view.scene.BaseScene;
    import view.utils.*;
    import view.scene.common.ScrollBar;
    import controller.*;


    /**
     * マッチング画面の部屋表示部分のクラス
     *
     */
    public class RoomArea extends BaseScene
    {
        // マッチインスタンス
        private var _match:Match = Match.instance;

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // 部屋ごとのクリップ
        private var _roomClip:Array = [];                           // Array of RoomClip

        // スクロールバー
        private var _scrollBar:ScrollBar  = new ScrollBar();

        // 実体
        private var _roomStart:int = 0;                               // 部屋表示の開始位置

        // チャンネル名
        private var _name:Label = new Label();
        private var _pageNo:Label = new Label();

//         // ボタン
//         private var _createRoomButton:SimpleButton;                // 部屋を作る
//         private var _quickStartButton:SimpleButton;                // クイックスタート


        // 定数
        private const _SCROLL_BAR_X:int = 436;                      // スクロールバーのX位置
        private const _SCROLL_BAR_Y:int = 56;                       // スクロールバーのY位置
        private const _SCROLL_BAR_HEIGHT:int = 330;                 // スクロールバーの高さ
        private const _SCROLL_BAR_WIDTH:int = 13;                   // スクロールバー幅
        private const _SCROLL_BAR_OFFSET:Number = 0.9;              // スクロール調整用の値

        private const _X:int = 16;                                 // 部屋の基本位置X
        private const _Y:int = 56;                                  // 部屋の基本位置Y

        private const _OFFSET_Y:int = 42;                           // 部屋のYの幅
        private const _ROOM_MAX:int = 8;                            // 部屋表示(RoomClip)の最大数 // 7
        private const _START_Y:int = _Y - _OFFSET_Y;                // 部屋の基本位置X
        private const _END_Y:int = _Y + _ROOM_MAX * _OFFSET_Y;      // 部屋の基本位置X
        private static const _START_PAGE:int = 0;       // 最初に表示するページの番号
        private var _page:int;                          // 現在のページ数
        // ゲームのコントローラ

        // ローディングパネル
//        private var _loadingPanel:LoadingPanel = new LoadingPanel();

        /**
         * コンストラクタ1
         *
         */
        public function RoomArea()
        {
            _name.x = -6;
            _name.y = -25;
            _name.width = 250;
            _name.height = 15;
            _name.styleName = "GameLobbyChannelNameLabel";
            _name.filters = [new GlowFilter(0x404040, 1, 2, 2, 16, 1)];

            _container.x = _X;
            _container.y = _Y;
            addChild(_container);
            _scrollBar.x = _SCROLL_BAR_X;
            _scrollBar.y = _SCROLL_BAR_Y;
            _scrollBar.height = _SCROLL_BAR_HEIGHT;
            _scrollBar.width = _SCROLL_BAR_WIDTH;

            // スクロールバー内のデータの数を更新
            _scrollBar.dataCap = _ROOM_MAX;
            _scrollBar.dataAll = MatchRoom.hashLength;
            _roomStart = (_scrollBar.dataAll - _scrollBar.dataCap) * _scrollBar.percent;

            LoadingPanel.offLoading();
//            _loadingPanel.visible = false;
//            addChild(_loadingPanel);
            _pageNo.x = 135;
            _pageNo.y = 342;
            _pageNo.width = 60;
            _pageNo.height = 20;
            _pageNo.styleName ="PageLabel"

            _pageNo.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
            
//             page = _START_PAGE;
        }

        // 初期化
        public override function init():void
        {
            _container.addChild(_name);

            _match.addEventListener(Match.LOADING, loadingHandler);
            _match.addEventListener(Match.RECONNCT, reconnectHandler);
            _match.addEventListener(Match.ROOM_CLICK, currentChangeHandler);
            _match.addEventListener(MatchEvent.INIT, initializeRoomClipHandler);
            _match.addEventListener(MatchEvent.EXIT, hideRoomClipHandler);
            _match.addEventListener(MatchEvent.UPDATE_ROOM, updateRoomClipHandler);
            _match.addEventListener(MatchEvent.DELETE_ROOM, deleteRoomClipHandler);
            initializeRoomClip();

            _container.addChild(_pageNo)

        }

        // 終了
        public override function final():void
        {
            _container.removeChild(_name);

            _match.removeEventListener(Match.LOADING, loadingHandler);
            _match.removeEventListener(Match.RECONNCT, reconnectHandler);
            _match.removeEventListener(Match.ROOM_CLICK, currentChangeHandler);
            _match.removeEventListener(MatchEvent.INIT, initializeRoomClipHandler);
            _match.removeEventListener(MatchEvent.EXIT, hideRoomClipHandler);
            _match.removeEventListener(MatchEvent.UPDATE_ROOM, updateRoomClipHandler);
            _match.removeEventListener(MatchEvent.DELETE_ROOM, deleteRoomClipHandler);
            finalizeRoomClip();
            RemoveChild.apply(_pageNo);
//            hideRoomClip();
//             _roomClip = null;
//             _scrollBar = null;

        }

        // ローディング
        private function loadingHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "loading handler");
//            showLoading();
        }

        // デュエル後の再接続
        private function reconnectHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "reconnect handler");

            // チャンネル名の再設定
            _name.text = Channel.list[Channel.current].name;

            showLoading();

            finalizeButton();
            hideRoomClip();
            initializeButton();
            new WaitLoadingThread(this).start();
//            initializeRoomClip();
        }

        // ボタンの初期化
        private function initializeButton():void
        {
            if ( Channel.list[Channel.current].isRadder ) {
                MatchCtrl.instance.quickButtonsEnable(true);
                MatchCtrl.instance.createButtonsEnable(false);
            } else {
                MatchCtrl.instance.quickButtonsEnable(false);
                MatchCtrl.instance.createButtonsEnable(true);
            }
            _pageNo.visible = true;
        }

        // ボタンの後処理
        private function finalizeButton():void
        {
            if ( Channel.list[Channel.current].isRadder) {
                MatchCtrl.instance.quickButtonsEnable(false);
                MatchCtrl.instance.createButtonsEnable(false);
            } else {
                MatchCtrl.instance.quickButtonsEnable(false);
                MatchCtrl.instance.createButtonsEnable(false);
            }
//            MatchCtrl.instance.createButtonsEnable(false);
            _pageNo.visible = false;
        }

        // ルームが初期化されたときのハンドラ
        private function initializeRoomClipHandler(e:MatchEvent):void
        {
            log.writeLog(log.LV_FATAL, this, "initializeRoomCliphandler");

            _name.text = Channel.list[Channel.current].name;

            visible = false;
            log.writeLog(log.LV_FATAL, this, "initilizeroom");

            showLoading();

            new WaitLoadingThread(this).start();
            initializeButton();
//            initializeRoomClip();
        }

        // ルームを初期化
        public function initializeRoomClip():void
        {
            _roomStart = 0;
            var oldRoomClip:Array = _roomClip.slice() ; /* of RoomClip */  
            var deleteRoomClip:Array; /* of RoomClip */  

            _roomClip = [];

            for(var key:String in MatchRoom.list)
            {
                if(MatchRoom.list[key])
                {
                    _roomClip.unshift(RoomClip.getRoom(key));
                    _roomClip[0].getShowThread(_container).start();
                    _roomClip[0].hide();
                }
            }

            // スクロールバー内のデータの数を更新
            _scrollBar.dataAll = MatchRoom.hashLength;

            // 古い部屋を探し出して消す
            deleteRoomClip = oldRoomClip.filter(function(item:*, index:int, array:Array):Boolean{
                    return (_roomClip.indexOf(item) == -1)
                });

            log.writeLog(log.LV_FATAL, this, "remain room losta. delete. ", deleteRoomClip);
            deleteRoomClip.forEach(function(item:RoomClip, index:int, array:Array):void{
                    item.visible = false;
                    item.getHideThread().start()
                        });
            update();
            visible = true;
            hideLoading();
        }

        // ルームを全て隠す
        public function hideRoomClip():void
        {
            _roomClip.forEach(function(item:RoomClip, index:int, array:Array):void{item.hide()});
        }


        // ルームを全消去
        private function finalizeRoomClip():void
        {
            _roomClip.forEach(function(item:RoomClip, index:int, array:Array):void{item.getHideThread().start()});
        }



        // ルームが全消去されたときのハンドラ
        private function hideRoomClipHandler(e:MatchEvent):void
        {
            finalizeButton();
            hideRoomClip();
//            _scrollBar.removeEventListener(ScrollBar.UPDATE, scrollHandler);
        }

        // ルームが更新されたときのハンドラ
        private function updateRoomClipHandler(e:MatchEvent):void
        {
            // ルームの長さをコピー
            var length:int = _roomClip.length;

            // スクロールバー内のデータの数を更新
            _scrollBar.dataAll = MatchRoom.hashLength;

            // ルームを更新or作成
            if (length == 0)
            {
                _roomClip.unshift(RoomClip.getRoom(e.id));
                _roomClip[0].getShowThread(_container).start();
                _roomClip[0].x = 0;
                _roomClip[0].y = -_OFFSET_Y;
                _roomClip[0].show();
                update();
            }
            else
            {
                for(var i:int = 0; i < length; i++)
                {
                    if(e.id == _roomClip[i].rid)
                    {
                        _roomClip[i].update();
                        break;
                    }
                    else if(length-1 <= i)
                    {
                        _roomClip.unshift(RoomClip.getRoom(e.id));
                        _roomClip[0].x = 0;
                        _roomClip[0].y = -_OFFSET_Y;
                        _roomClip[0].getShowThread(_container).start();
                        update();
                    }
                }
            }
        }

        // ルームが削除されたときのハンドラ
        private function deleteRoomClipHandler(e:MatchEvent):void
        {
            // ルームの長さをコピー
            var length:int = _roomClip.length;

            // スクロールバーのデータの数を更新
            _scrollBar.dataAll = MatchRoom.hashLength;


            // 受け取ったIDのルームを削除
            for(var i:int = 0; i < length; i++)
            {
                if(_roomClip[i] && e.id == _roomClip[i].rid)
                {
                    _roomClip[i].getHideThread().start();
                    _roomClip[i].hide();
                    _roomClip.splice(i, 1);
                    // ルームのスタート位置が更新されてたらアップデート
                    if(_roomStart > MatchRoom.hashLength-1)
                    {
                        _roomStart -= _ROOM_MAX;
                        if(_roomStart < 0)
                        {
                            _roomStart = 0;
                        }
                    }
//                    _roomStart = 0;
                    update();
                }
            }
        }

        // カレントルームが変わったときのハンドラ
        private function currentChangeHandler(e:Event):void
        {
            if(_match.currentRoomId != "")
            {
                RoomClip.currentChange(_match.currentRoomId);
            }
        }

        // 部屋の配置の更新
        public function update():void
        {
            var j:int = _roomStart + _ROOM_MAX;
            var max:int =(j<_roomClip.length)? j:_roomClip.length;
            var count:int = 0;

//             _roomStart = roomStart;

            for(var i:int = 0; i < _roomClip.length ; i++)
            {
                _roomClip[i].hide();
            }

            for(i = _roomStart + _SCROLL_BAR_OFFSET; i < max; i++)
            {
                if(i-count > _roomStart)
                {
                    _roomClip[i].x = 0;
                    _roomClip[i].y = (count-_roomStart) * _OFFSET_Y + int(_roomStart) * _OFFSET_Y + _OFFSET_Y;
                }
                else
                {
                    _roomClip[i].x = 0;
                    _roomClip[i].y = (count-_roomStart) * _OFFSET_Y + int(_roomStart) * _OFFSET_Y;
                }
                _roomClip[i].show();
                count++;
            }
            log.writeLog(log.LV_INFO, this, "room length is", _roomClip.length);
            page();
        }

        // 次のページ
        public function nextPage():void
        {
            var roomStart:int = _roomStart + _ROOM_MAX;

            // ルームのスタート位置が更新されてたらアップデート
            if(roomStart < MatchRoom.hashLength)
            {
                _roomStart = roomStart;
                update();
            }else{
                _roomStart = int((MatchRoom.hashLength-1)/_ROOM_MAX)*_ROOM_MAX;
                update();
            }


        }

        // 前のページ
        public function prevPage():void
        {
            var roomStart:int = _roomStart - _ROOM_MAX;
            // ルームのスタート位置が更新されてたらアップデート
            if(roomStart >= 0)
            {
                _roomStart = roomStart;
                update();
            }else{
                _roomStart = 0;
                update();
            }
        }

        // ページのセッター
        public function page():void
        {
            var pageNum:int = int(_roomStart/(_ROOM_MAX))+1;
            var maxNum:int = Math.ceil((MatchRoom.hashLength>1? MatchRoom.hashLength:1)/ _ROOM_MAX);
            _pageNo.text = (pageNum).toString()+"/"+maxNum.toString();
        }

//         // スクロール処理
//         private function scrollHandler(e:Event):void
//         {
//             var roomStart:Number = (_scrollBar.dataAll - _scrollBar.dataCap) * _scrollBar.percent;

// //            log.writeLog(log.LV_INFO, this, "percent", _scrollBar.percent);
//             // ルームのスタート位置が更新されてたらアップデート
//             if(_roomStart != roomStart)
//             {
//                 _roomStart = roomStart;
//                 update();
//             }
//         }

        // ローディングを表示
        public function showLoading():void
        {
            LoadingPanel.onLoading();
        }

        // ローディングを隠す
        public function hideLoading():void
        {
            LoadingPanel.offLoading();
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new ShowThread(this, stage, at));
//            pExec.addThread(_scrollBar.getShowThread(this))
            return pExec;
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
//            pExec.addThread(_scrollBar.getHideThread());
            pExec.addThread(new HideThread(this));
            return pExec;
        }
    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.utils.SerialExecutor;

import view.*;
import view.scene.match.RoomArea;
import controller.*;



class ShowThread extends BaseShowThread
{
    private var _ra:RoomArea;

    public function ShowThread(ra:RoomArea, stage:DisplayObjectContainer, at:int)
    {
        _ra = ra;
        super(ra, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(ra:RoomArea)
    {
        super(ra);
    }
}


// 部屋データのロードを待つスレッド
class WaitLoadingThread extends Thread
{
    private var _ra:RoomArea;

    public function WaitLoadingThread(ra:RoomArea)
    {
        _ra = ra;
    }

    protected override function run():void
    {
        next(waitingDuelServer);

    }

    private function waitingDuelServer():void
    {
        if (DuelCtrl.instance.connected)
        {
            next(hidePanel);
        }else{
            next(waitingDuelServer);
        }

    }

    private function hidePanel():void
    {
        var sExec:SerialExecutor = new SerialExecutor();
        var pExec:ParallelExecutor = new ParallelExecutor();
        pExec.addThread(new ClousureThread(_ra.initializeRoomClip));
        pExec.addThread(new SleepThread(300));
        sExec.addThread(pExec);
        sExec.addThread(new ClousureThread(_ra.hideLoading));
        sExec.start();
        sExec.join();
    }

}
