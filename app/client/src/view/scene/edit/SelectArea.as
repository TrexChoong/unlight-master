package view.scene.edit
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;

    import mx.core.UIComponent;
    import mx.events.ListEvent;
    import mx.controls.ComboBox;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;

    import view.image.edit.*;
    import view.scene.BaseScene;

    import model.DeckEditor;
    import model.InventorySet;
    import model.events.*;
    import controller.LobbyCtrl;

    public class SelectArea extends BaseScene
    {
        private var _deckEditor:DeckEditor = DeckEditor.instance;
        private var _ctrl:LobbyCtrl = LobbyCtrl.instance;

        private var _charaSelecter:CharaSelectComboBox = new CharaSelectComboBox();

        public function SelectArea()
        {
            _charaSelecter.selectedIndex = _deckEditor.selectChara;
        }

        public override function init():void
        {
            _deckEditor.addEventListener(DeckEditor.CHANGE_TYPE, changeTypeHandler);
            _charaSelecter.addEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            addChild(_charaSelecter);
        }

        public override function final():void
        {
            _deckEditor.removeEventListener(DeckEditor.CHANGE_TYPE, changeTypeHandler);
            _charaSelecter.removeEventListener(ListEvent.CHANGE, changeDropDownListHandler);
            removeChild(_charaSelecter);
        }

        private function changeTypeHandler(e:Event):void
        {
            switch (_deckEditor.editType)
            {
            case InventorySet.TYPE_CHARA:
                _charaSelecter.visible = true;
                break;
            default:
                _charaSelecter.visible = false;
                break;
            }
        }

        private function changeDropDownListHandler(e:ListEvent):void
        {
            var select:int = _charaSelecter.selectedIndex;

            _deckEditor.selectChara = select;

            _deckEditor.binderSelect();
        }

        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }

        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }
    }
}

import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import mx.controls.ComboBox;
import org.libspark.thread.Thread;

import model.DeckEditor;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.edit.SelectArea;

class ShowThread extends BaseShowThread
{
    public function ShowThread(sa:SelectArea, stage:DisplayObjectContainer, at:int)
    {
        super(sa, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(sa:SelectArea)
    {
        super(sa);
    }
}

class CharaSelectComboBox extends ComboBox
{
    CONFIG::LOCALE_JP
    private static const _ALL_STR:String = "- ALL -";
    CONFIG::LOCALE_EN
    private static const _ALL_STR:String = "- ALL -";
    CONFIG::LOCALE_TCN
    private static const _ALL_STR:String = "- ALL -";
    CONFIG::LOCALE_SCN
    private static const _ALL_STR:String = "- ALL -";
    CONFIG::LOCALE_KR
    private static const _ALL_STR:String = "- 전체 -";
    CONFIG::LOCALE_FR
    private static const _ALL_STR:String = "- ALL -";
    CONFIG::LOCALE_ID
    private static const _ALL_STR:String = "- ALL -";
    CONFIG::LOCALE_TH
    private static const _ALL_STR:String = "- ALL -";

    public function CharaSelectComboBox():void
    {
        var setArray:Array = [_ALL_STR];
        for (var i:int = 0; i < Const.CARD_LENGTH; i++) {
            setArray.push(Const.CHARACTOR_NAME[i+1]);
        }
        log.writeLog(log.LV_DEBUG, this, "CharaSelectComboBox", setArray);
        dataProvider = setArray;

        dropdownWidth = 95;
        x = 452;
        y = 423;
        width = 96;
        height =18;
        rowCount = 10;
        visible = false;
    }
}

