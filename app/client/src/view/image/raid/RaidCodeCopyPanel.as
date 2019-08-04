package view.image.raid
{
    import flash.display.*;
    import flash.text.*;
    import flash.events.*;
    import flash.ui.Keyboard;

    import mx.core.IToolTip;
    import mx.managers.ToolTipManager;
    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;
    import mx.core.UIComponent;

    import view.image.BaseImage;
    import view.utils.RemoveChild;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  レイドコードコピーパネル
     *
     */

    public class RaidCodeCopyPanel extends TitleWindow
    {
        public static const PANEL_TYPE_OWNER:int = 0;
        public static const PANEL_TYPE_OTHER:int = 1;

        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_TITLE:String             = "レイドコード";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_COPY:String              = "このレイドコードをみんなに知らせて協力して渦のボスと戦おう！";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_SEL_COPY_TXT:String           = "コピータイプ変更";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_BTN:String               = "変更";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_SEL_REWARD_TXT:String           = "撃破報酬ON/OFF設定変更";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_SEND_HELP_TXT:String           = "参加可能なユーザに救援信号を送る";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG_SEND_BTN:String               = "送信";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_TITLE:String             = "RAID Code";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_COPY:String              = "Call everyone and work together to take down the RAID-BOSS!";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_SEL_COPY_TXT:String           = "Change Copy type";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_BTN:String               = "Change";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_SEL_REWARD_TXT:String           = "Change the settings for defeat award ON/OFF";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_SEND_HELP_TXT:String           = "Send distress signal to players who can participate.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG_SEND_BTN:String               = "Send";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_TITLE:String             = "RAID代碼";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_COPY:String              = "讓大家知道這個RAID代碼，同心協力與渦的BOSS戰鬥吧！";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_SEL_COPY_TXT:String           = "變更複製權限";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_BTN:String               = "變更";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_SEL_REWARD_TXT:String           = "變更擊破報酬的設定ON/OFF";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_SEND_HELP_TXT:String           = "傳送求救信號給可以參加的玩家";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG_SEND_BTN:String               = "送出";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_TITLE:String             = "RAID代码";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_COPY:String              = "与大家分享这个RAID代码，同心协力与涡的BOSS战斗吧！";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_SEL_COPY_TXT:String           = "变更复制权限";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_BTN:String               = "变更";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_SEL_REWARD_TXT:String           = "变更击破报酬的设定ON/OFF";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_SEND_HELP_TXT:String           = "传送求救信号给可以参加的玩家";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG_SEND_BTN:String               = "送出";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_TITLE:String             = "";
        CONFIG::LOCALE_KR
	private static const _TRANS_MSG_COPY:String              = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_SEL_COPY_TXT:String           = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_BTN:String               = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_SEL_REWARD_TXT:String           = "撃破報酬ON/OFF設定変更";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_SEND_HELP_TXT:String           = "参加可能なユーザに救援信号を送る";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG_SEND_BTN:String               = "送信";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_TITLE:String             = "Raid Code";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_COPY:String              = "Partagez ce Raid Code avec vos amis et unissez-vous pour défaire le Boss du Vortex !";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_SEL_COPY_TXT:String      = "Changement pour rendre la copie possible";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_BTN:String               = "Changement";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_SEL_REWARD_TXT:String    = "Changez le mode des récompenses ON/OFF";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_SEND_HELP_TXT:String     = "Demandez à des joueurs pouvant participer de vous aider.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG_SEND_BTN:String          = "Envoyer";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_TITLE:String             = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_COPY:String              = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_SEL_COPY_TXT:String           = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_BTN:String               = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_SEL_REWARD_TXT:String           = "撃破報酬ON/OFF設定変更";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_SEND_HELP_TXT:String           = "参加可能なユーザに救援信号を送る";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG_SEND_BTN:String               = "送信";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_TITLE:String             = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_COPY:String              = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_SEL_COPY_TXT:String           = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_BTN:String               = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_SEL_REWARD_TXT:String           = "撃破報酬ON/OFF設定変更";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_SEND_HELP_TXT:String           = "参加可能なユーザに救援信号を送る";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG_SEND_BTN:String               = "送信";

        // 文字列
        private var _text:TextField = new TextField();
        private var _hashText:TextField = new TextField();
        private var _helpText:TextField = new TextField();
        private var _selCopyText:TextField = new TextField();
        private var _selRewardText:TextField = new TextField();

        // Hash
        private var _hash:String = "";

        // Changeボタン
        private var _changeButton:Button = new Button();
        // Helpボタン
        private var _helpButton:Button = new Button();

        // タイプ選択ボックス
        private var _selCopyTypeBox:SelectCopyTypeComboBox = new SelectCopyTypeComboBox();
        // 報酬スイッチ選択ボックス
        private var _selRewardSwitchBox:SelectDefeatRewardSwitchComboBox = new SelectDefeatRewardSwitchComboBox();

        // 表示タイプ
        private var _panelType:int = PANEL_TYPE_OTHER;

        private var _container:UIComponent = new UIComponent();

        private var _copyTypeToolTip:IToolTip;

        // 表示位置
        private const _X:int        = 255;
        private const _Y:int        = 190;
        private const _WIDTH:int    = 250;
        private const _HEIGHT:int   = 150;
        CONFIG::RAID_NEW_CONFIG_OFF
        private const _L_HEIGHT:int = 260;
        CONFIG::RAID_NEW_CONFIG_ON
        private const _L_HEIGHT:int = 380;

        private const _TEXT_X:int = 13;
        private const _TEXT_Y:int = 40;
        private const _TEXT_W:int = 228;
        private const _TEXT_H:int = 50;

        private const _HASH_TEXT_X:int = 13;
        private const _HASH_TEXT_Y:int = 85;
        private const _HASH_TEXT_W:int = 228;
        private const _HASH_TEXT_H:int = 30;

        private const _HELP_TEXT_X:int = 13;
        private const _HELP_TEXT_Y:int = 115;
        private const _HELP_TEXT_W:int = 228;
        private const _HELP_TEXT_H:int = 50;

        private const _HELP_BTN_X:int  = 95;
        private const _HELP_BTN_Y:int  = 115;
        private const _HELP_BTN_W:int  = 60;
        private const _HELP_BTN_H:int  = 23;

        private const _SEL_COPY_TEXT_X:int = 13;
        private const _SEL_COPY_TEXT_W:int = 228;
        private const _SEL_COPY_TEXT_H:int = 30;

        private const _SEL_COPY_TYPE_X:int = 55;
        private const _SEL_COPY_TYPE_W:int = 140;
        private const _SEL_COPY_TYPE_H:int = 25;

        private const _SEL_REWARD_TEXT_X:int = 13;
        private const _SEL_REWARD_TEXT_Y:int = 240;
        private const _SEL_REWARD_TEXT_W:int = 228;
        private const _SEL_REWARD_TEXT_H:int = 30;

        private const _SEL_REWARD_TYPE_X:int = 55;
        private const _SEL_REWARD_TYPE_Y:int = 265;
        private const _SEL_REWARD_TYPE_W:int = 140;
        private const _SEL_REWARD_TYPE_H:int = 25;

        private const _BTN_X:int  = 95;
        private const _BTN_W:int  = 60;
        private const _BTN_H:int  = 23;

        CONFIG::RAID_NEW_CONFIG_OFF
        {
            private const _SEL_COPY_TEXT_Y:int = 120;
            private const _SEL_COPY_TYPE_Y:int = 145;
            private const _BTN_Y:int  = 200;
        }

        CONFIG::RAID_NEW_CONFIG_ON
        {
            private const _SEL_COPY_TEXT_Y:int = 175;
            private const _SEL_COPY_TYPE_Y:int = 200;
            private const _BTN_Y:int  = 320;
        }


        /**
         * コンストラクタ
         *
         */
        public function RaidCodeCopyPanel()
        {
            super();

            layout = "absolute"
            title = _TRANS_MSG_TITLE;

            // Panel
            x = _X;
            y = _Y;
            width  = _WIDTH;
            height = _L_HEIGHT;
            showCloseButton = true;

            // Text
            _text.x = _TEXT_X;
            _text.y = _TEXT_Y;
            _text.width = _TEXT_W;
            _text.height = _TEXT_H;
            _text.text = _TRANS_MSG_COPY;
            _text.wordWrap = true;
            _text.multiline = true;
            _text.textColor = 0xFFFFFF;
            _text.alpha = 0.5;

            // hash
            _hashText.x = _HASH_TEXT_X;
            _hashText.y = _HASH_TEXT_Y;
            _hashText.width = _HASH_TEXT_W;
            _hashText.height = _HASH_TEXT_H;
            _hashText.wordWrap = true;
            _hashText.multiline = true;
            _hashText.textColor = 0xFFFFFF;
            var hashFormat:TextFormat = new TextFormat();
            hashFormat.align = TextFormatAlign.CENTER;
            _hashText.defaultTextFormat = hashFormat;

            // Text
            _helpText.x = _HELP_TEXT_X;
            _helpText.y = _HELP_TEXT_Y;
            _helpText.width = _HELP_TEXT_W;
            _helpText.height = _HELP_TEXT_H;
            _helpText.text = _TRANS_MSG_SEND_HELP_TXT;
            _helpText.wordWrap = true;
            _helpText.multiline = true;
            _helpText.textColor = 0xFFFFFF;
            _helpText.alpha = 0.5;

            // helpButton
            _helpButton.label = _TRANS_MSG_SEND_BTN;
            _helpButton.x = _HELP_BTN_X;
            _helpButton.y = _HELP_BTN_Y + 30;
            _helpButton.width = _HELP_BTN_W;
            _helpButton.height = _HELP_BTN_H;

            var selFormat:TextFormat = new TextFormat();
            selFormat.align = TextFormatAlign.CENTER;

            // selCopyText
            _selCopyText.x = _SEL_COPY_TEXT_X;
            _selCopyText.y = _SEL_COPY_TEXT_Y;
            _selCopyText.width = _SEL_COPY_TEXT_W;
            _selCopyText.height = _SEL_COPY_TEXT_H;
            _selCopyText.wordWrap = true;
            _selCopyText.multiline = true;
            _selCopyText.textColor = 0xFFFFFF;
            _selCopyText.alpha = 0.5;
            _selCopyText.defaultTextFormat = selFormat;
            _selCopyText.htmlText = _TRANS_MSG_SEL_COPY_TXT;

            // selCopyTypeBox
            _selCopyTypeBox.addEventListener(ListEvent.CHANGE, selTypeHandler);
            _selCopyTypeBox.visible = true;
            _selCopyTypeBox.mouseEnabled = true;
            _selCopyTypeBox.mouseChildren = true;
            _selCopyTypeBox.dropdownWidth = _SEL_COPY_TYPE_W;
            _selCopyTypeBox.x = _SEL_COPY_TYPE_X;
            _selCopyTypeBox.y = _SEL_COPY_TYPE_Y;
            _selCopyTypeBox.width  = _SEL_COPY_TYPE_W;
            _selCopyTypeBox.height = _SEL_COPY_TYPE_H;

            // selRewardText
            _selRewardText.x = _SEL_REWARD_TEXT_X;
            _selRewardText.y = _SEL_REWARD_TEXT_Y;
            _selRewardText.width = _SEL_REWARD_TEXT_W;
            _selRewardText.height = _SEL_REWARD_TEXT_H;
            _selRewardText.wordWrap = true;
            _selRewardText.multiline = true;
            _selRewardText.textColor = 0xFFFFFF;
            _selRewardText.alpha = 0.5;
            _selRewardText.defaultTextFormat = selFormat;
            _selRewardText.htmlText = _TRANS_MSG_SEL_REWARD_TXT;

            // selRewardSwitchBox
            _selRewardSwitchBox.addEventListener(ListEvent.CHANGE, selTypeHandler);
            _selRewardSwitchBox.visible = true;
            _selRewardSwitchBox.mouseEnabled = true;
            _selRewardSwitchBox.mouseChildren = true;
            _selRewardSwitchBox.dropdownWidth = _SEL_REWARD_TYPE_W;
            _selRewardSwitchBox.x = _SEL_REWARD_TYPE_X;
            _selRewardSwitchBox.y = _SEL_REWARD_TYPE_Y;
            _selRewardSwitchBox.width  = _SEL_REWARD_TYPE_W;
            _selRewardSwitchBox.height = _SEL_REWARD_TYPE_H;

            // changeButton
            _changeButton.label = _TRANS_MSG_BTN;
            _changeButton.x = _BTN_X;
            _changeButton.y = _BTN_Y;
            _changeButton.width = _BTN_W;
            _changeButton.height = _BTN_H;

            addChild(_changeButton);
            addChild(_selCopyTypeBox);
            _container.addChild(_text);
            _container.addChild(_hashText);
            _container.addChild(_selCopyText);

            CONFIG::RAID_NEW_CONFIG_ON
            {
                addChild(_selRewardSwitchBox);
                _container.addChild(_selRewardText);
                addChild(_helpButton);
                _container.addChild(_helpText);
            }

            addChild(_container);
        }

        public function show(hash:String,type:int,defCopyType:int,defSetReward:Boolean):void
        {
            _hash = hash;
            _hashText.htmlText = hash;
            _hashText.textColor = 0xFFFFFF;
            var hashFormat:TextFormat = new TextFormat();
            hashFormat.align = TextFormatAlign.CENTER;
            _hashText.defaultTextFormat = hashFormat;
            _panelType = type;
            _selCopyTypeBox.selectedIndex = defCopyType;
            _selRewardSwitchBox.setSelectedIndex(defSetReward);
            initPos();
            visible = true;
        }

        private function initPos():void
        {
            if (_panelType == PANEL_TYPE_OWNER) {
                _selCopyText.visible = true;
                _selCopyTypeBox.visible = true;
                _selRewardText.visible = true;
                _selRewardSwitchBox.visible = true;
                _changeButton.visible = true;
                _helpText.visible = true;
                _helpButton.visible = true;
                initilizeToolTipOwners();

                // Panel
                x = _X;
                y = _Y;
                width  = _WIDTH;
                height = _L_HEIGHT;

                addChild(_changeButton);
                addChild(_selCopyTypeBox);
                _container.addChild(_selCopyText);

                CONFIG::RAID_NEW_CONFIG_ON
                {
                    addChild(_selRewardSwitchBox);
                    _container.addChild(_selRewardText);
                    addChild(_helpButton);
                    _container.addChild(_helpText);
                }
            } else {
                _selCopyText.visible = false;
                _selCopyTypeBox.visible = false;
                _changeButton.visible = false;
                _helpText.visible = false;
                _helpButton.visible = false;
                _selRewardText.visible = false;
                _selRewardSwitchBox.visible = false;
                finalizeToolTipOwners();

                // Panel
                x = _X;
                y = _Y;
                width  = _WIDTH;
                height = _HEIGHT;

                RemoveChild.apply(_selCopyText);
                RemoveChild.apply(_selCopyTypeBox);
                RemoveChild.apply(_changeButton);

                CONFIG::RAID_NEW_CONFIG_ON
                {
                    RemoveChild.apply(_selRewardText);
                    RemoveChild.apply(_selRewardSwitchBox);
                    RemoveChild.apply(_helpText);
                    RemoveChild.apply(_helpButton);
                }
            }
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            CONFIG::LOCALE_EN
            {
                _selCopyTypeBox.addEventListener(MouseEvent.ROLL_OVER, toolTipMouseOverHandler);
                _selCopyTypeBox.addEventListener(MouseEvent.ROLL_OUT, toolTipMouseOutHandler);
            }
            CONFIG::LOCALE_FR
            {
                _selCopyTypeBox.addEventListener(MouseEvent.ROLL_OVER, toolTipMouseOverHandler);
                _selCopyTypeBox.addEventListener(MouseEvent.ROLL_OUT, toolTipMouseOutHandler);
            }
        }
        // ツールチップが必要なオブジェクトをすべて削除する
        private function finalizeToolTipOwners():void
        {
            CONFIG::LOCALE_EN
            {
                _selCopyTypeBox.removeEventListener(MouseEvent.ROLL_OVER, toolTipMouseOverHandler);
                _selCopyTypeBox.removeEventListener(MouseEvent.ROLL_OUT, toolTipMouseOutHandler);
            }
            CONFIG::LOCALE_FR
            {
                _selCopyTypeBox.removeEventListener(MouseEvent.ROLL_OVER, toolTipMouseOverHandler);
                _selCopyTypeBox.removeEventListener(MouseEvent.ROLL_OUT, toolTipMouseOutHandler);
            }
        }

        private function toolTipMouseOverHandler(e:MouseEvent):void
        {
            if (_copyTypeToolTip == null)
            {
                _copyTypeToolTip = ToolTipManager.createToolTip(_selCopyTypeBox.selTypeData, e.stageX,e.stageY);
            }
        }

        private function toolTipMouseOutHandler(e:MouseEvent):void
        {
             if (_copyTypeToolTip != null)
             {
                 ToolTipManager.destroyToolTip(_copyTypeToolTip);
                 _copyTypeToolTip =null;
             }
        }

        public function get change():Button
        {
            return _changeButton;
        }

        public function get help():Button
        {
            return _helpButton;
        }

        private function selTypeHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this,"selTypeHandler",_selCopyTypeBox.selectedIndex);
        }

        public function get selType():int
        {
            return _selCopyTypeBox.selType;
        }

        public function get selSwitch():Boolean
        {
            return _selRewardSwitchBox.selSwitch;
        }

    }
}


import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.geom.*;

import mx.core.UIComponent;
import mx.controls.*;

import model.Profound;

/**
 * タイプ選択用コンボボックス
 *
 */
class SelectCopyTypeComboBox extends ComboBox
{
    CONFIG::LOCALE_JP
    private static const _TRANS_TYPE_ALL:String    = "無制限";
    CONFIG::LOCALE_JP
    private static const _TRANS_TYPE_OWNER:String  = "発見者のみ";
    CONFIG::LOCALE_JP
    private static const _TRANS_TYPE_FRIEND:String = "発見者及びFriendのみ";

    CONFIG::LOCALE_EN
    private static const _TRANS_TYPE_ALL:String    = "Unlimited";
    CONFIG::LOCALE_EN
    private static const _TRANS_TYPE_OWNER:String  = "Only discoverer";
    CONFIG::LOCALE_EN
    private static const _TRANS_TYPE_FRIEND:String = "Only discoverer and their friends";

    CONFIG::LOCALE_TCN
    private static const _TRANS_TYPE_ALL:String    = "無限制";
    CONFIG::LOCALE_TCN
    private static const _TRANS_TYPE_OWNER:String  = "只限發現者";
    CONFIG::LOCALE_TCN
    private static const _TRANS_TYPE_FRIEND:String = "只限發現者與好友";

    CONFIG::LOCALE_SCN
    private static const _TRANS_TYPE_ALL:String    = "无限制";
    CONFIG::LOCALE_SCN
    private static const _TRANS_TYPE_OWNER:String  = "只限发现者";
    CONFIG::LOCALE_SCN
    private static const _TRANS_TYPE_FRIEND:String = "只限发现者与好友";

    CONFIG::LOCALE_KR
    private static const _TRANS_TYPE_ALL:String    = "無制限";
    CONFIG::LOCALE_KR
    private static const _TRANS_TYPE_OWNER:String  = "発見者のみ";
    CONFIG::LOCALE_KR
    private static const _TRANS_TYPE_FRIEND:String = "発見者及びFriendのみ";

    CONFIG::LOCALE_FR
    private static const _TRANS_TYPE_ALL:String    = "Illimité";
    CONFIG::LOCALE_FR
    private static const _TRANS_TYPE_OWNER:String  = "Réservé à celui qui le découvre";
    CONFIG::LOCALE_FR
    private static const _TRANS_TYPE_FRIEND:String = "Réservé à celui qui le découvre et ses amis";

    CONFIG::LOCALE_ID
    private static const _TRANS_TYPE_ALL:String    = "無制限";
    CONFIG::LOCALE_ID
    private static const _TRANS_TYPE_OWNER:String  = "発見者のみ";
    CONFIG::LOCALE_ID
    private static const _TRANS_TYPE_FRIEND:String = "発見者及びFriendのみ";

    CONFIG::LOCALE_TH
    private static const _TRANS_TYPE_ALL:String    = "無制限";
    CONFIG::LOCALE_TH
    private static const _TRANS_TYPE_OWNER:String  = "発見者のみ";
    CONFIG::LOCALE_TH
    private static const _TRANS_TYPE_FRIEND:String = "発見者及びFriendのみ";

    private static const _SEL_TYPE_DATA:Array = [_TRANS_TYPE_ALL,_TRANS_TYPE_OWNER,_TRANS_TYPE_FRIEND];
    private static const _SEL_TYPE:Array = [
        Profound.PRF_CODE_COPY_TYPE_ALL,
        Profound.PRF_CODE_COPY_TYPE_OWNER,
        Profound.PRF_CODE_COPY_TYPE_FRIEND
        ];

    public function SelectCopyTypeComboBox():void
    {
        dataProvider = _SEL_TYPE_DATA;
        //rowCount = 5;
    }

    public function get selType():int
    {
        return _SEL_TYPE[selectedIndex];
    }
    public function get selTypeData():String
    {
        return _SEL_TYPE_DATA[selectedIndex];
    }
}

class SelectDefeatRewardSwitchComboBox extends ComboBox
{
    private static const _SEL_TYPE_DATA:Array = ["ON","OFF"];
    private static const _SEL_TYPE:Array = [true,false];

    public function SelectDefeatRewardSwitchComboBox():void
    {
        dataProvider = _SEL_TYPE_DATA;
    }

    public function get selSwitch():Boolean
    {
        return _SEL_TYPE[selectedIndex];
    }
    public function setSelectedIndex(defSetReward:Boolean):void
    {
        selectedIndex = _SEL_TYPE.indexOf(defSetReward);
    }
}
