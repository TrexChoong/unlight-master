package view.scene.match
{
    import flash.display.*;
    import flash.events.*;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import view.image.match.*;

    import model.Match;
    import model.Channel;
    import model.events.*;
    import controller.*;

    /**
     * マッチング画面のチャンネル表示部分のクラス
     *
     */
    public class ChannelArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "存在するチャンネルのリストです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CAPA	:String = "許容人数";
        CONFIG::LOCALE_JP
        private static const _TRANS_CAPA_NUM	:String = "人\n";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "List of channels.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CAPA	:String = "";
        CONFIG::LOCALE_EN
        private static const _TRANS_CAPA_NUM	:String = " people allowed\n";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "目前頻道的列表";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CAPA	:String = "上限人數 + ";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CAPA_NUM	:String = "人\n";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "既有通道的列表。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CAPA	:String = "容纳人数";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CAPA_NUM	:String = "人\n";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "존재하고 있는 채널 리스트 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CAPA	:String = "허용인수 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_CAPA_NUM	:String = "명\n";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Liste des Couloirs.";
        CONFIG::LOCALE_FR
        private static const _TRANS_CAPA	:String = "Max de Joueurs + ";
        CONFIG::LOCALE_FR
        private static const _TRANS_CAPA_NUM	:String = "\n";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "存在するチャンネルのリストです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CAPA	:String = "許容人数";
        CONFIG::LOCALE_ID
        private static const _TRANS_CAPA_NUM	:String = "人\n";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "รายชื่อ Channel ที่มีอยู่";//"存在するチャンネルのリストです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_CAPA    :String = "จำนวน";//"許容人数";
        CONFIG::LOCALE_TH
        private static const _TRANS_CAPA_NUM    :String = "คน";//"人\n";


        // マッチインスタンス
        private var _match:Match = Match.instance;

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // 表示オブジェクト
        private var _channelClips:Array = [];                        // Array of ChannelClip
        private var _channelList:ChannelList = new ChannelList();   // チャンネルリスト
        private var _caption:Text = new Text();                     // チャンネル説明の表示枠

        // 定数
        private static const _X:int = 0;                           // 基本位置X
        private static const _Y:int = 0;                           // 基本位置Y
        private static const _OFFSET_Y:int = 0;                    // Yのずれ

        private static const _WIDTH:int = 70;                      // 説明の横幅
        private static const _HEIGHT:int = 70;                      // 説明の縦幅
        private static const _CAPTION_OFFSET_Y:int = 8;             // チャンネル説明Yのずれ

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["存在するチャンネルのリストです。"],
                [_TRANS_MSG],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _MATCH_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function ChannelArea()
        {
            addChild(_container);
        }


        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  //
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
             initChannelList();
             initChannelClip();
//              initCaption();
             initilizeToolTipOwners();
             updateHelp(_MATCH_HELP);
//             addEventListener(MouseEvent.CLICK, mouseClickHandler);
//             _channelList.channelA.addEventListener(MouseEvent.CLICK, pushChannelAHandler);
//             _channelList.channelB.addEventListener(MouseEvent.CLICK, pushChannelBHandler);
//             _channelList.channelC.addEventListener(MouseEvent.CLICK, pushChannelCHandler);
        }

        // 終了
        public override function final():void
        {
             deleteChannelClip();
//             deleteCaption();

//             _channelList.channelA.removeEventListener(MouseEvent.CLICK, pushChannelAHandler);
//             _channelList.channelB.removeEventListener(MouseEvent.CLICK, pushChannelBHandler);
//             _channelList.channelC.removeEventListener(MouseEvent.CLICK, pushChannelCHandler);

//            removeEventListener(MouseEvent.CLICK, mouseClickHandler);
        }

        // チャンネルリストクリップの初期化
        private function initChannelList():void
        {
            _container.addChild(_channelList);
        }


         // チャンネルクリップの初期化
         private function initChannelClip():void
        {
            var length:int = Channel.list.length;

            for(var i:int=0; i < length; i++)
            {
                _channelClips.push(new ChannelClip(i));
                _channelClips[i].x = _X;
                _channelClips[i].y = _Y + _OFFSET_Y * i;
                _channelClips[i].getShowThread(_container).start();
                // チャンネルステートがOKのときのみマウスイベントを設定
                if ( _channelClips[i].state == Const.CSTATE_OK ) {
                    _channelClips[i].addEventListener(ChannelClip.CHANNEL_CLICK, mouseClickHandler);
                }

//                 _channelClips[i].addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler)
//                 _channelClips[i].addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler)
            }
        }

        // チャンネルクリップの後始末
        private function deleteChannelClip():void
        {
            var length:int = _channelClips.length;

            for(var i:int; i < length; i++)
            {
                _channelClips[i].visible = false;
                // チャンネルステートがOKのときのみマウスイベントを解除
                if ( _channelClips[i].state == Const.CSTATE_OK ) {
                    _channelClips[i].removeEventListener(ChannelClip.CHANNEL_CLICK, mouseClickHandler);
                }
                _channelClips[i].getHideThread().start();
            }

            _channelClips = [];
        }

//         // チャンネル説明の初期化
//         private function initCaption():void
//         {
//             _caption.x = 15;
//             _caption.y = 295;
//             _caption.width = _WIDTH;
//             _caption.height = _HEIGHT;
//             _caption.styleName = "GameLobbyChannelCaptionLabel";
// //            _container.addChild(_caption);
//         }

//         // チャンネル説明の後始末
//         private function deleteCaption():void
//         {
// //            _container.removeChild(_caption);
//         }

//         // マウスを乗せたときの処理
//         private function mouseOverHandler(e:MouseEvent):void
//         {
//// //            _caption.text = "許容人数" + e.currentTarget.capacity + "人\n" + e.currentTarget.caption;
// //            _caption.text = _TRANS_CAPA + e.currentTarget.capacity + _TRANS_CAPA_NUM + e.currentTarget.caption;
//             _caption.text = e.currentTarget.caption;
//         }

//         // マウスをはなしたときの処理
//         private function mouseOutHandler(e:MouseEvent):void
//         {
//             _caption.text = "";
//         }

//         private function pushChannelAHandler(e:MouseEvent):void
//         {
//             _match.currentRoomId = "";
//             _match.loading(0);
//             Channel.exitChannel(0);
//             Channel.joinChannel(0);
//             this.visible = false;
//         }

//         private function pushChannelBHandler(e:MouseEvent):void
//         {
//             _match.currentRoomId = "";
//             _match.loading(1);
//             Channel.exitChannel(0);
//             Channel.joinChannel(1);
//             this.visible = false;
//         }

//         private function pushChannelCHandler(e:MouseEvent):void
//         {
//             _match.currentRoomId = "";
//             _match.loading(2);
//             Channel.exitChannel(0);
//             Channel.joinChannel(2);
//             this.visible = false;
//         }

        // ゲームから抜けてきた場合の処理（再
        public function joinChannel(i:int):void
        {
            _match.currentRoomId = "";
            _match.loading(i);
//             Channel.exitChannel(0);
//             Channel.joinChannel(i);
            this.visible = false;
        }

        // マウスでクリックしたときの処理
        private function mouseClickHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this, "mouseclick");
            LoadingPanel.onLoading();
            this.visible = false;
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 非表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }
    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.Channel;
import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.match.ChannelArea;


class ShowThread extends BaseShowThread
{
    public function ShowThread(ca:ChannelArea, stage:DisplayObjectContainer, at:int)
    {
        super(ca, stage);
    }

    protected override function run():void
    {
        next(waitChannel);
    }

    private function waitChannel():void
    {
//        log.writeLog(log.LV_FATAL, this, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!!!!!!!!!!!!!!!!!!!!!!!");
        var t:Thread = Channel.getLoadWaitingThread();
        t.start();
        t.join();
        next(close)
    }


}

class HideThread extends BaseHideThread
{
    public function HideThread(ca:ChannelArea)
    {
        super(ca);
    }
}
