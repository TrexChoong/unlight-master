package view.scene.match
{
    import flash.display.*;
    import flash.events.*;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.scene.BaseScene;
    import view.scene.common.LogTextArea;
    import view.scene.common.ChatTextInput;
    import view.utils.*;

    import model.Match;
    import model.MessageLog;
    import model.events.*;
    import controller.*;

    /**
     * マッチング画面のチャット表示部分のクラス
     *
     */
    public class ChatArea extends BaseScene
    {

        // マッチインスタンス
        private var _match:Match = Match.instance;

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // 実体
        private var _box:Box = new Box();
        private var _chatText:LogTextArea = new LogTextArea(MessageLog.CHANNEL_LOG);
        private var _chatInput:ChatTextInput = new ChatTextInput(MessageLog.CHANNEL_LOG);
        private var _frame:Shape = new Shape();

        private static  var __currentChannel:int = 0;



        // 定数
        private static const _X:int = 7;
        private static const _Y:int = 468;
        private static const _WIDTH:int = 357;
        private static const _HEIGHT:int = 168;

        private var _ct:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
        private var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーンを半分に
        private  var _maskShape:Shape = new Shape();

        private var _channelSelector:ChannelComboBox = new ChannelComboBox();

        /**
         * コンストラクタ
         *
         */
        public function ChatArea()
        {
            addChild(_container);
            initChatData();

            _maskShape.graphics.beginFill(0x000000);
            _maskShape.graphics.drawRect(0, 0, 367, 180);
            _maskShape.graphics.endFill();
            _maskShape.x = 00 ;
            _maskShape.y = 452;
            _maskShape.alpha = 0.7;
        }

        private function initChatData():void
        {
            _chatText.percentWidth = 100;
            _chatText.percentHeight = 100;
            _chatText.styleName = "GameLobbyChatArea";

            _chatInput.percentWidth = 93;
            _chatInput.styleName = "GameLobbyChatInput";

            _box.x = _X;
            _box.y = _Y;
            _box.width = _WIDTH;
            _box.height = _HEIGHT;
//            _box.alpha = 0.2;

            _box.addChild(_chatText);
            _box.addChild(_chatInput);

            _container.addChild(_box);
            addChild(_channelSelector);
//            chatEnable = false;
            chatEnable = ChatCtrl.instance.connected;
//            _channelSelector.selectedIndex = ChatCtrl.currentChannel;

            ChatCtrl.currentChannel = 0;
            _channelSelector.selectedIndex = 0;
            ChatCtrl.instance.channelIn(0);
        }

        // 初期化処理
        public override function init():void
        {
            _chatText.init();
            _chatText.update();
            ChatCtrl.instance.addEventListener(ChatCtrl.CONNECT_UPDATE, updateHandler);
        }

        // 後処理
        public override function final():void
        {
            _chatText.final();
            ChatCtrl.instance.removeEventListener(ChatCtrl.CONNECT_UPDATE, updateHandler);
        }


        // 初期化処理
        public function sendText():void
        {
            log.writeLog(log.LV_INFO, this, "send",__currentChannel);
            _chatInput.sendChannel(ChatCtrl.currentChannel);
        }

        // 
        private function updateHandler(e:Event):void
        {
            chatEnable = ChatCtrl.instance.connected;
        }
        // 
        public function set chatEnable(b:Boolean):void
        {
            if (b)
            {
                RemoveChild.apply(_maskShape)
                enabled = true;
                mouseEnabled = true;
                mouseChildren = true;
            }else{
                enabled = false;
                mouseEnabled = false;
                mouseChildren = false;
                addChild(_maskShape);
            }
        }

        public function resetSelector():void
        {
            log.writeLog(log.LV_INFO, this, "resetSelector selectedIndex.", _channelSelector.selectedIndex);
            ChatCtrl.currentChannel = 0;
            _channelSelector.selectedIndex = 0;
            ChatCtrl.instance.channelIn(0);
        }

        public static function set currentChannel(i:int):void
        {
            ChatCtrl.currentChannel = i;
            ChatCtrl.instance.channelIn(i); // 仮。常に０からでて０似戻る
        }

    }
}





import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;

import mx.core.UIComponent;
import mx.events.ListEvent;
import mx.controls.ComboBox;
import view.scene.match.ChatArea;

class ChannelComboBox extends ComboBox
{
    public function ChannelComboBox()
    {
        dataProvider = ["Ch:A", "Ch:B", "Ch:C", "Duel"];
        dropdownWidth = 95;
        x = 8;
        y = 455;
        width = 48;
        height = 14;
        styleName = "ChatChannelDropBox";
        addEventListener(ListEvent.CHANGE, changeDropDownListHandler);
//        super();
    }

    private function changeDropDownListHandler(e:ListEvent):void
    {
        switch (selectedItem)
        {
        case "Ch:A":
            ChatArea.currentChannel = 0;
            break;
        case "Ch:B":
            ChatArea.currentChannel = 1;
            break;
        case "Ch:C":
            ChatArea.currentChannel = 2;
            break;
        case "Duel":
            ChatArea.currentChannel = 3;
            break;
        }

    }
}
