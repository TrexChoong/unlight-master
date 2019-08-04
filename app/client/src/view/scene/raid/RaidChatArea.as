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

    import model.MessageLog;
    import model.ProfoundLogs;

    import view.ClousureThread;
    import view.utils.*;
    import view.scene.BaseScene;
    import view.scene.common.*;
    import view.image.game.ChatBase;
    import controller.ChatCtrl;

    /**
     * レイド画面チャット表示クラス
     *
     */

    public class RaidChatArea extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "渦戦闘ログ・チャットです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Log/chat for vortex battles.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "渦戰鬥紀錄及聊天頻道履歷。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "漩涡战斗的聊天纪录。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Log Chat.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG	:String = "เข้าสู่ระบบแชทขณะต่อสู้กับน้ำวน"; // 渦戦闘ログ・チャットです。

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // 実態
        private var _boxs:Vector.<Box> = Vector.<Box>([new Box(),new Box(),new Box()]);
        private var _prfText:RaidLogTextArea = new RaidLogTextArea(ProfoundLogs.PRF_LOG);
        private var _chatText:RaidLogTextArea = new RaidLogTextArea(ProfoundLogs.CHAT_LOG);
        private var _allText:RaidLogTextArea = new RaidLogTextArea(ProfoundLogs.ALL_LOG);
        private var _chatInputs:Vector.<RaidCommentInput> = Vector.<RaidCommentInput>([new RaidCommentInput(),new RaidCommentInput(),new RaidCommentInput()]);
        private var _typeSelComboBox:LogTypeComboBox = new LogTypeComboBox();


        // 定数
        private static const _X:int = 1;
        private static const _Y:int = 498;
        private static const _WIDTH:int = 363;
        private static const _HEIGHT:int = 158;
        private static const _SEL_X:int = 8;
        private static const _SEL_Y:int = 481;
        private static const _SEL_WIDTH:int = 48;
        private static const _SEL_HEIGHT:int = 14;

        private static const _HIDE_X:int = -400;

        private static const _TYPE_ALL:int  = 0;
        private static const _TYPE_CHAT:int = 1;
        private static const _TYPE_PRF:int  = 2;
        private static const _TYPE_NUM:int  = 3;

        /**
         * コンストラクタ
         *
         */
        // ヤバゲ側チャットAPIくるまでOFF
        public function RaidChatArea()
        {
            addChild(_container);
            initChatData();
        }

        private function initChatData():void
        {
            _prfText.percentWidth = 100;
            _prfText.percentHeight = 100;
            _prfText.styleName = "RaidChatArea";
            _chatText.percentWidth = 100;
            _chatText.percentHeight = 100;
            _chatText.styleName = "RaidChatArea";
            _allText.percentWidth = 100;
            _allText.percentHeight = 100;
            _allText.styleName = "RaidChatArea";

            _boxs[_TYPE_ALL].addChild(_allText);
            _boxs[_TYPE_ALL].visible = true;
            _boxs[_TYPE_ALL].alpha = 1.0;
            _boxs[_TYPE_CHAT].addChild(_chatText);
            _boxs[_TYPE_CHAT].visible = false;
            _boxs[_TYPE_CHAT].alpha = 0.0;
            _boxs[_TYPE_PRF].addChild(_prfText);
            _boxs[_TYPE_PRF].visible = false;
            _boxs[_TYPE_PRF].alpha = 0.0;
            for (var i:int = 0; i < _TYPE_NUM; i++) {
                _boxs[i].x = _HIDE_X;
                _boxs[i].y = _Y;
                _boxs[i].width = _WIDTH;
                _boxs[i].height = _HEIGHT;
                _chatInputs[i].percentWidth = 100;
                _chatInputs[i].styleName = "RaidChatInput";
                _boxs[i].addChild(_chatInputs[i]);
                _container.addChild(_boxs[i]);
            }

            _typeSelComboBox.x = _HIDE_X;
            _typeSelComboBox.y = _SEL_Y;
            _typeSelComboBox.width = _SEL_WIDTH;
            _typeSelComboBox.height = _SEL_HEIGHT;

            _typeSelComboBox.addEventListener(ListEvent.CHANGE, changeTypeHandler);
            _container.addChild(_typeSelComboBox);

            enabled = true;
            mouseEnabled = true;
            mouseChildren = true;
        }
        public override function init():void
        {
            _prfText.init();
            _allText.init();
            _chatText.init();
        }

        public override function final():void
        {
            for (var i:int = 0; i < _TYPE_NUM; i++) {
                RemoveChild.apply(_boxs[i]);
            }
            RemoveChild.apply(_container);
            _chatText.final();
            _prfText.final();
            _allText.final();
        }

        public function set inputFlag(f:Boolean):void
        {
            for (var i:int = 0; i < _TYPE_NUM; i++) {
                _chatInputs[i].mouseEnabled = f;
                _chatInputs[i].mouseChildren = f;
            }
        }

        public function openWindow():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            for (var i:int = 0; i < _TYPE_NUM; i++) {
                pExec.addThread(new BeTweenAS3Thread(_boxs[i], {x:_X}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE));
            }
            pExec.addThread(new BeTweenAS3Thread(_typeSelComboBox, {x:_SEL_X}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE));
            sExec.addThread(pExec);
            sExec.addThread(new ClousureThread(changeType));
            sExec.start();
        }

        public function closeWindow():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            for (var i:int = 0; i < _TYPE_NUM; i++) {
                pExec.addThread(new BeTweenAS3Thread(_boxs[i], {x:_HIDE_X}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE));
            }
            pExec.addThread(new BeTweenAS3Thread(_typeSelComboBox, {x:_HIDE_X}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.start();
        }

        private function changeTypeHandler(e:ListEvent):void
        {
            changeType();
        }
        private function changeType():void
        {
            for (var i:int = 0; i < _TYPE_NUM; i++) {
                if (i == _typeSelComboBox.selectedIndex) {
                    _boxs[i].visible = true;
                    _boxs[i].alpha = 1.0;
                } else {
                    _boxs[i].visible = false;
                    _boxs[i].alpha = 0.0;
                }
            }
        }

        public function resetInputText():void
        {
            for (var i:int = 0; i < _TYPE_NUM; i++) {
                _chatInputs[i].resetText();
            }
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

class LogTypeComboBox extends ComboBox
{
    public function LogTypeComboBox()
    {
        dataProvider = ["All", "Chat", "Log"];
        dropdownWidth = 95;
        styleName = "RaidChatChannelDropBox";
    }

    public function get typeNum():int
    {
        return dataProvider.length;
    }

}
