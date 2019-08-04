package view.scene.match
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import view.image.match.ChannelBase;

    import model.Match;
    import model.Channel;
    import model.Player;
    import model.Avatar;

    import controller.*;

    /**
     * チャンネル表示クラス
     *
     */
    public class ChannelClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "チャンネルルールに合わないため、入場できませんでした。";
        CONFIG::LOCALE_JP
        private static const _TRANS_INFO	:String = "情報";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "You cannot enter this channel because you do meet the requirements.";
        CONFIG::LOCALE_EN
        private static const _TRANS_INFO	:String = "Information";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "不符合頻道規則，無法進入。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_INFO	:String = "訊息";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "不符合通道规则，无法进入通道。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_INFO	:String = "信息";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "채널 룰에 맞지 않으므로 입장할 수 없습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_INFO	:String = "정보";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "Vous ne pouvez pas entrer car vous ne satisfaisez pas les critères d'entrée dans ce Couloir.";
        CONFIG::LOCALE_FR
        private static const _TRANS_INFO	:String = "Informations";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "チャンネルルールに合わないため、入場できませんでした。";
        CONFIG::LOCALE_ID
        private static const _TRANS_INFO	:String = "情報";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "ท่านไม่สามารถเข้าใช้งาน Channel ได้เนื่องจากขัดกับกฎที่มีอยู่";//"チャンネルルールに合わないため、入場できませんでした。";
        CONFIG::LOCALE_TH
        private static const _TRANS_INFO    :String = "ข้อมูล";


        // マッチインスタンス
        private var _match:Match = Match.instance;

        // アバター
        private var _avatar:Avatar = Player.instance.avatar;

        // 表示コンテナ
        private var _container:UIComponent = new UIComponent();

        // 自身の配列
        private static var _baseList:Array = [];                      // Array of ChannelBase

        // 実体
        private var _no:int;                                          // チャンネルナンバー
        private var _name:String;                                     // チャンネル名
        private var _rule:int;                                        // ルール
        private var _capacity:int;                                    // 許容人数
        private var _caption:String;                                  // 説明
        private var _count:int;                                       // 現在の人数
        private var _crowded:int;                                     // 混雑度（収容人数の100+赤）
        private var _state:int;                                       // チャンネルのステート
        private var _host:String;
        private var _port:int;
        private var _duelHost:String;
        private var _duelPort:int;
        private var _chatHost:String;
        private var _chatPort:int;
        private var _watchHost:String;
        private var _watchPort:int;

        // 表示オブジェクト
        private var _channelBase:ChannelBase;                         // チャンネルの下地
        private var _channelName:Label = new Label();                 // チャンネル名の表示
        private var _channelCaption:Text = new Text();                 // チャンネル名の表示

        // 定数
        private static const _X_SET:Array = [15, 191, 15, 191, 15, 191, 15, 191, 15, 191, 15, 191, 15, 191]; /* of int*/
//        private static const _Y_SET:Array = [55, 55, 127, 127, 199, 199, 271, 271, 343, 343]; /* of int*/
        private static const _Y_SET:Array = [55, 55, 110, 110, 165, 165, 220, 220, 275, 275, 330, 330, 385, 385,]; /* of int*/

        private static const _CT_ORIG:ColorTransform = new ColorTransform(1.0,1.0,1.0); // トーン元にに
        private static const _CT_DOWN:ColorTransform = new ColorTransform(0.3,0.3,0.3); // トーンを半分に

        private static const _NAME_X:int = 20;                         // チャンネル名X
        private static const _NAME_Y:int = 2;                         // チャンネル名X
        private static const _WIDTH:int = 115;                        // 表示ラベルの幅
        private static const _HEIGHT:int = 20;                        // 表示ラベルの高さ

        private static const _CAPTION_X:int = 9;                // チャンネル説明X
        private static const _CAPTION_Y:int = 17;               // チャンネル説明Y
        private static const _CAPTION_WIDTH:int = 148;                        // 表示ラベルの幅
        private static const _CAPTION_HEIGHT:int = 50;                        // 表示ラベルの高さ
        private static const _CROWDED_PERCE:Array = [0.4,0.7,0.9,1.0,1.1]; /* of ElementType */


        // イベント
        public static const CHANNEL_CLICK:String = "channel_click";                 // チャンネルクリック

//         private var _clickFunc:Function;

        /**
         * コンストラクタ
         *
         */
        public function ChannelClip(no:int)
        {
            _no = no;
            _name = Channel.list[no].name;
            _rule = Channel.list[no].rule;
            _capacity = Channel.list[no].capacity;
            _count = Channel.list[no].count;
            _caption = Channel.list[no].caption;
            _state = Channel.list[no].state;
            _host = Channel.list[no].host;
            _port = Channel.list[no].port;
            _duelHost = Channel.list[no].duelHost;
            _duelPort = Channel.list[no].duelPort;
            _chatHost = Channel.list[no].chatHost;
            _chatPort = Channel.list[no].chatPort;
            _watchHost = Channel.list[no].watchHost;
            _watchPort = Channel.list[no].watchPort;
            calcCrowded();
            clipInitialize();
        }
        private function calcCrowded():void
        {
            var v:Number =  _count/_capacity;
            if (v <= _CROWDED_PERCE[0])
            {
                _crowded = 1;
            }else if(v <= _CROWDED_PERCE[1]){
                _crowded = 2;

            }else if(v <= _CROWDED_PERCE[2]){
                _crowded = 3;

            }else if(v <= _CROWDED_PERCE[3]){
                _crowded = 4;

            }else{
                _crowded = 5;
            }
            log.writeLog(log.LV_INFO, this, "calc crowded", v,_crowded, _count, _capacity);
        }

        // 初期化処理
        public override function init():void
        {
            // チャンネルステートがOKのときのみマウスイベントを設定
            if ( _state == Const.CSTATE_OK ) {
                _channelBase.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            }
            _container.addChild(_channelBase);
            _container.addChild(_channelName);
            _container.addChild(_channelCaption);
            addChild(_container);

            _baseList.push(_channelBase);

            if(Channel.current == _no)
            {
                _channelBase.up();
                _match.reconnect();
            }
        }

        // 後始末処理
        public override function final():void
        {
            // チャンネルステートがOKのときのみマウスイベントを解除
            if ( _state == Const.CSTATE_OK ) {
                _channelBase.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            }
            _container.removeChild(_channelBase);
            _container.removeChild(_channelName);
            _container.removeChild(_channelCaption);
            removeChild(_container);
//             _clickFunc = null;
            _baseList = [];
        }

        // クリップを初期化する
        private function clipInitialize():void
        {
            _channelBase = new ChannelBase(_no,_crowded);
            _channelBase.x = _X_SET[_no];
            _channelBase.y = _Y_SET[_no];

            _channelName = new Label();
            _channelName.x = _X_SET[_no]+_NAME_X;
            _channelName.y = _Y_SET[_no]+_NAME_Y;
            _channelName.text = _name;
            _channelName.styleName = "GameLobbyChannelLabel";
            _channelName.width = _WIDTH;
            _channelName.height = _HEIGHT;
            _channelName.mouseEnabled = false;
            _channelName.mouseChildren = false;
            _channelCaption = new Text();
            _channelCaption.x = _X_SET[_no]+_CAPTION_X;
            _channelCaption.y = _Y_SET[_no]+_CAPTION_Y;
            _channelCaption.text = _caption;
            _channelCaption.styleName = "GameLobbyChannelCaptionLabel";
            _channelCaption.width = _CAPTION_WIDTH;
            _channelCaption.height = _CAPTION_HEIGHT;
            _channelCaption.mouseEnabled = false;
            _channelCaption.mouseChildren = false;

            // チャンネルステートがOKじゃなければトーンダウンとマウスイベントカット
            if ( _state != Const.CSTATE_OK ) {
                _channelBase.mouseEnabled = false;
                _channelBase.mouseChildren = false;
                _channelBase.transform.colorTransform = _CT_DOWN;
//                _channelCaption.transform.colorTransform = _CT_DOWN;
                _channelCaption.visible = false;
            }
        }

        // マウスをクリックした時のハンドラ
        private function mouseClickHandler(e:MouseEvent):void
        {
            var isSunccess:Boolean = false;
            if (_rule == Const.CRULE_FREE || _rule == Const.CRULE_RADDER ||_rule == Const.CRULE_EVENT || _rule == Const.CRULE_COST_A || _rule == Const.CRULE_COST_B) {
                isSunccess = true;
            }
            if (_rule == Const.CRULE_LOW && _avatar.level <= 30) {
                isSunccess = true;
            }
            if (_rule == Const.CRULE_HIGH && _avatar.point <= 1600) {
                isSunccess = true;
            }
            if (_rule == Const.CRULE_NEWBIE && _avatar.level <= 10) {
                isSunccess = true;
            }
            if(isSunccess)
            {
                channelClickSuccess();
            }
            else
            {
//                Alerter.showWithSize("チャンネルルールに合わないため、入場できませんでした。", "情報");
                Alerter.showWithSize(_TRANS_MSG, _TRANS_INFO);
            }
        }

        // チャンネルに入る
        private function channelClickSuccess():void
        {
            _baseList.forEach(function(item:*, index:int, array:Array):void{item.down()});
            _match.currentRoomId = "";
            _match.loading(_no);
            log.writeLog(log.LV_FATAL, this, "host",_host,_duelHost,_port,_duelPort);

            Channel.joinChannel(_no);
            MatchCtrl.instance.selectChannelServerConnect(_host, _port);
            DuelCtrl.instance.selectChannelServerConnect(_duelHost, _duelPort);
            WatchCtrl.instance.selectChannelServerConnect(_watchHost, _watchPort);
            ChatCtrl.instance.selectChannelServerConnect(_chatHost, _chatPort);
            dispatchEvent(new Event(CHANNEL_CLICK));
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        // 非表示スレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }

        // チャンネル説明を返す
        public function get caption():String
        {
            return _caption;
        }

        // 許容人数を返す
        public function get capacity():int
        {
            return _capacity;
        }

        // チャンネルステートを返す
        public function get state():int
        {
            return _state;
        }

    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.DeckEditor;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.match.ChannelClip;

class ShowThread extends BaseShowThread
{
    public function ShowThread(cc:ChannelClip, stage:DisplayObjectContainer, at:int)
    {
        super(cc, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(cc:ChannelClip)
    {
        super(cc);
    }
}
