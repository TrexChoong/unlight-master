package view.scene.raid
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

    import model.ProfoundLogs;

    import view.ClousureThread;
    import view.utils.*;
    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.scene.game.DuelMessage;
    import view.image.game.ChatBase;
    import controller.RaidChatCtrl;

    /**
     * ゲーム画面チャット表示クラス
     *
     */

    public class RaidDuelChatArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "対戦ログです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2:String = "レイドチャットです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "The battle log.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2:String = "Chat window for raid participants.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "對戰記錄。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2:String = "這是襲擊頻道";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "对战记录。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2:String = "这是突击聊天。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "대전 로그입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Duel Log";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2:String = "Voici le Raid Chat.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "対戦ログです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG	:String = "บันทึกการต่อสู้";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2:String = "แชทขณะต่อสู้"; // レイドチャットです。

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

        private var _prfLogs:ProfoundLogs = ProfoundLogs.getInstance();

        private var _gameText:RaidLogTextArea = new RaidLogTextArea(ProfoundLogs.GAME_LOG);
        private var _chatText:RaidLogTextArea = new RaidLogTextArea(ProfoundLogs.CHAT_LOG);
        private var _allText:RaidLogTextArea = new RaidLogTextArea(ProfoundLogs.GAME_ALL_LOG);
        private var _chatInput:RaidCommentInput = new RaidCommentInput();
        private var _chatBase:ChatBase = new ChatBase();


        private var _appear:Boolean = false;

        private var tag1Label:Label = new Label();
        private var tag2Label:Label = new Label();
        private var tag3Label:Label = new Label();
        private var _ctrl:RaidChatCtrl;

        private var _prfId:int = 0;

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
        public function RaidDuelChatArea()
        {
            _ctrl = RaidChatCtrl.instance;
            _chatBase.alpha = 0.0;
            _chatBase.visible = false;

            _chatInput.x = INPUT_X;
            _chatInput.y = INPUT_Y;
            _chatInput.width = INPUT_WIDHT;
            _chatInput.height = INPUT_HEIGHT;
            _chatInput.alpha = 0.0;

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

            updateHelp(_GAME_HELP);

            _gameText.init();
            _allText.init();
            _chatText.init();

            alpha = 0.0;
            y = 0;
            _appear = false;
            _chatBase.addEventListener(ChatBase.CHAT_ON, chatOnHandler);
            _chatBase.addEventListener(ChatBase.TAB1_ON, tab1OnHandler);
            _chatBase.addEventListener(ChatBase.TAB2_ON, tab2OnHandler);
            _chatBase.addEventListener(ChatBase.TAB3_ON, tab3OnHandler);
            _chatBase.init();
            _chatBase.visible = false;

            addChild(_chatInput);
        }

        public override function final():void
        {
            RemoveChild.apply(_chatInput);
            RemoveChild.apply(_chatBase);
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

        public function set inputFlag(f:Boolean):void
        {
            _chatInput.mouseEnabled = f;
            _chatInput.mouseChildren = f;
        }

        public function set prfId(id:int):void
        {
            _prfId = id;
            _prfLogs.clearLogs(ProfoundLogs.GAME_LOG,id);
            _prfLogs.clearLogs(ProfoundLogs.GAME_ALL_LOG,id);
            if (id != 0) {
                _ctrl.battle = true;
            } else {
                _ctrl.battle = false;
            }
            log.writeLog(log.LV_DEBUG, this, "raid duel chat area prflog.",_prfLogs.prfId,_prfLogs.lastId);
            _ctrl.requestComment(_prfLogs.prfId,_prfLogs.lastId);
        }
    }

}
