package view.scene.game
{

    import flash.display.*;
    import flash.events.*;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.MessageLog;

    import view.ClousureThread;
    import view.utils.*;
    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.image.game.ChatBase;
    import controller.ChatCtrl;

    /**
     * ゲーム画面チャット表示クラス
     *
     */

    public class ChatArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "対戦ログです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2:String = "観戦チャットです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "The battle log.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2:String = "Spectator chat.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "對戰記錄。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2:String = "觀戰聊天室";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "对战记录。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2:String = "观战交流";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "대전 로그입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Duel Log";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2:String = "Chat pour spectateur.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "対戦ログです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "บันทึกการต่อสู้";//"対戦ログです。";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2:String = "แชทระหว่างดูการประลอง";//"観戦チャットです。";

        private static const AREA_X:int = 168;
        private static const AREA_Y:int = 560;
        private static const AREA_WIDHT:int = 285;
        private static const AREA_HEIGHT:int = 68;

        private static const INPUT_X:int = 169;
        private static const INPUT_Y:int = 631;
        private static const INPUT_WIDHT:int = 258;
        private static const INPUT_HEIGHT:int = 20;

        private static const TAB_X:int = 450;
        private static const TAB_Y:int = 565;

        private static const APPEAR_X:int = -210;

        private var _chatText:LogTextArea = new LogTextArea(MessageLog.MATCH_LOG);
        private var _gameText:LogTextArea = new LogTextArea(MessageLog.GAME_LOG);
        private var _allText:LogTextArea = new LogTextArea(MessageLog.ALL_LOG);
        private var _chatInput:ChatTextInput = new ChatTextInput(MessageLog.MATCH_LOG);
        private var _chatBase:ChatBase = new ChatBase();


        private var _appear:Boolean = false;
        private var _state:int = MessageLog.CHANNEL_LOG;

        private var _isWatch:Boolean = false;
        private var _currentRoomId:String;

        private var tag1Label:Label = new Label();
        private var tag2Label:Label = new Label();
        private var tag3Label:Label = new Label();
        private var _ctrl:ChatCtrl;

        private var _enable:Boolean = true;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["対戦ログです。"],   // 0
                [_TRANS_MSG],     // 0
                [_TRANS_MSG2],    // 1
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _GAME_HELP:int   = 0;
        private const _WATCH_HELP:int  = 1;

        /**
         * コンストラクタ
         *
         */
        // ヤバゲ側チャットAPIくるまでOFF
        public function ChatArea(enable:Boolean = true)
        {
            _ctrl = ChatCtrl.instance;
            _chatBase.alpha = 0.0;
            _chatBase.visible = false;

            _chatInput.x = INPUT_X;
            _chatInput.y = INPUT_Y;
            _chatInput.width = INPUT_WIDHT;
            _chatInput.height = INPUT_HEIGHT;
            _chatInput.alpha = 0.0;
            _chatInput.visible = false;
            _chatInput.editable = enable;
            _enable = enable;

            _chatInput.styleName = "GameChatInput";

            initilizeToolTipOwners();
        }

        public override function init():void
        {
            addChild(_chatBase);

            initializeTab(_allText,tag1Label);
            _allText.visible = true;
            tag1Label.text = "All";
            tag1Label.styleName = "SelectedChatTab";

            initializeTab(_chatText,tag2Label);
            _chatText.visible = false;
            tag2Label.text = "Chat";
            tag2Label.y = tag1Label.y + 23;

            initializeTab(_gameText,tag3Label);
            _gameText.visible = false;
            tag3Label.text = "Game";
            tag3Label.y = tag1Label.y + 46;

            if ( !_isWatch ) {
                updateHelp(_GAME_HELP);
            } else {
                updateHelp(_WATCH_HELP);
            }

            _gameText.init();
            _allText.init();
            _chatText.init();

            alpha = 0.0;
            y = 0;
            _appear = false;
            _ctrl.channelOut(0); // 仮。常に０からでて０似戻る
            _ctrl.clearAllChatLog(); // ログを消去
            _ctrl.clearDuelChatLog(); // ログを消去
            _ctrl.clearChannelChatLog(); // ログを消去
            _ctrl.clearGameChatLog(); // ログを消去
            _ctrl.clearAudienceChatLog(); // ログを消去
            _chatBase.addEventListener(ChatBase.CHAT_ON, chatOnHandler);
            _chatBase.addEventListener(ChatBase.TAB1_ON, tab1OnHandler);
            _chatBase.addEventListener(ChatBase.TAB2_ON, tab2OnHandler);
            _chatBase.addEventListener(ChatBase.TAB3_ON, tab3OnHandler);
            _chatBase.init();
            _chatBase.visible = false;

            if (_isWatch) {
                _ctrl.audienceChannelIn(_currentRoomId);
            }

            _chatBase.setTabEnabled(_enable);

            if (!_enable) {
                _chatInput.mouseEnabled  = false;
                _chatInput.mouseChildren = false;
            }

            addChild(_chatInput);
        }

        public override function final():void
        {
            if (_isWatch) {
                _ctrl.audienceChannelOut();
            }

            RemoveChild.apply(_chatInput);
            RemoveChild.apply(_chatBase);
            _ctrl.channelIn(0); // 仮。常に０からでて０似戻る
            _ctrl.clearAllChatLog(); // ログを消去
            _ctrl.clearDuelChatLog(); // ログを消去
            _ctrl.clearChannelChatLog(); // ログを消去
            _ctrl.clearGameChatLog(); // ログを消去
            _ctrl.clearAudienceChatLog(); // ログを消去
            _chatBase.removeEventListener(ChatBase.CHAT_ON, chatOnHandler);
            _chatBase.removeEventListener(ChatBase.TAB1_ON, tab1OnHandler);
            _chatBase.removeEventListener(ChatBase.TAB2_ON, tab2OnHandler);
            _chatBase.removeEventListener(ChatBase.TAB3_ON, tab3OnHandler);
            _chatBase.final();
            _chatText.final();
            _gameText.final();
            _allText.final();

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

        private function initializeTab(tab:TextArea,label:Label):void
        {
            tab.x = AREA_X;
            tab.y = AREA_Y;
            tab.width = AREA_WIDHT;
            tab.height = AREA_HEIGHT;
            tab.styleName = "GameChatArea";
            // tab.mouseEnabled = false;
            // tab.mouseChildren = false;
            addChild(tab);
            label.styleName = "ChatTab";
            label.width = 60;
            label.height = 20;
            label.x = TAB_X;
            label.y = TAB_Y;
            label.filters = [
                new GlowFilter(0xffffff, 1, 2, 2, 16, 1),
//              new DropShadowFilter(2, 45, 0x000000, 1, 2, 2, 16)
                ];

            label.mouseEnabled = false;
            label.doubleClickEnabled = false;
            label.mouseChildren = false;
            addChild(label);
        }

        private function finalizeTab(tab:TextArea,label:Label):void
        {
            removeChild(tab);
            removeChild(label);
        }


        private function chatOnHandler(e:Event):void
        {
            if (_appear)
            {
//                (new TweenerThread(this, {y:0, transition:"easeOutQuad", time: 0.2})).start();
                (new BeTweenAS3Thread(this, {x:0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_QUAD)).start();
                _appear =false;
            }else{
//                (new TweenerThread(this, {y:APPEAR_Y, transition:"easeOutQuad", time: 0.2})).start();
                (new BeTweenAS3Thread(this, {x:APPEAR_X}, null, 0.2, BeTweenAS3Thread.EASE_OUT_QUAD)).start();
                _appear =true;
            }
        }

        private function tab1OnHandler(e:Event):void
        {
            _gameText.visible = false;
            _chatText.visible = false;
            _allText.visible = true;
            tag1Label.styleName = "SelectedChatTab";
            tag2Label.styleName = "ChatTab";
            tag3Label.styleName = "ChatTab";
        }
        private function tab2OnHandler(e:Event):void
        {
            _gameText.visible =false;
            _allText.visible =false;
            _chatText.visible =true;
            tag1Label.styleName = "ChatTab";
            tag2Label.styleName = "SelectedChatTab";
            tag3Label.styleName = "ChatTab";
        }
        private function tab3OnHandler(e:Event):void
        {
            _chatText.visible =false;
            _allText.visible =false;
            _gameText.visible =true;
            tag1Label.styleName = "ChatTab";
            tag2Label.styleName = "ChatTab";
            tag3Label.styleName = "SelectedChatTab";
        }

        // 実画面に表示するスレッドを返す
        public function getBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(this, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_chatBase, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_chatInput, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_allText, {alpha:0.7}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_chatText, {alpha:0.7}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_gameText, {alpha:0.7}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(tag1Label, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(tag2Label, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(tag3Label, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }

        // 実画面から隠すスレッドを返す
        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_chatBase, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_chatInput, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_allText, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(tag1Label, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_chatText, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(tag2Label, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_gameText, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(tag3Label, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            return pExec;
        }

        // 隠すスレッドを返す
        public override function getHideThread(type:String = ""):Thread
        {
            getBringOffThread().start();
            return super.getHideThread(type);
        }

        public function changeInputType(isWatch:Boolean):void
        {
            _isWatch = isWatch;
            var type:int = (!isWatch) ? MessageLog.MATCH_LOG : MessageLog.WATCH_LOG;
            _chatText.typeChange(type);
            _chatInput.typeChange(type);
        }

        public function set currentRoomId(roomId:String):void
        {
            _currentRoomId = roomId;
        }

        public function set inputFlag(f:Boolean):void
        {
            if (_enable) {
                _chatInput.mouseEnabled = f;
                _chatInput.mouseChildren = f;
            }
        }
    }

}
