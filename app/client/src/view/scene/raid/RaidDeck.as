package view.scene.raid
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;

    import flash.geom.*;

    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.utils.*;
    import view.ClousureThread;
    import view.image.common.AvatarImage;
    import view.scene.BaseScene;
    import view.scene.quest.QuestDeck;
    import view.scene.edit.CharaCardDeckClip;
    import view.scene.common.CharaCardClip;

    import model.CharaCard;
    import model.CharaCardDeck;
    import model.DeckEditor;
    import model.events.*;

    /**
     * レイドに使用するデッキクラス
     *
     */
    public class RaidDeck extends QuestDeck
    {
        public static const SIZE_MODE_NORMAL:int = 0;
        public static const SIZE_MODE_HALF:int   = 1;


        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "渦戦闘に使用するデッキです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "This deck will be used for vortex battles.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "在渦戰鬥所使用的牌組";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "用于漩涡战斗的卡组。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Pioche pour la bataille du Vortex.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG	:String = "Deckที่ใช้ต่อสู้กับน้ำวน";  // 渦戦闘に使用するデッキです。


        private const _LABEL_WIDTH:int = 200;                      // ラベルの幅
        private const _LABEL_HEIGHT:int = 20;                      // ラベルの高さ
        private const _LABEL_X:int = 500;                          // デッキエリアのX位置
        private const _LABEL_Y:int = 10;                           // デッキエリアのY位置

        private const _DECK_X:int = 125;                           // デッキエリアのX位置
        private const _DECK_Y:int = 475;                            // デッキエリアのY位置
        private const _DECK_SIZE:Number = 1.0;                     // デッキサイズ
        private const _DECK_NAME_X:int = 65;                      // デッキネームのX位置
        private const _DECK_NAME_Y:int = 635;                      // デッキネームのY位置

        private const _CHANGE_X:int = 964;                         //
        private const _CHANGE_Y:int = 693;                         //
        private const _CHANGE_OFFSET_X:int = 20;                   //
        private const _CHANGE_OFFSET_Y:int = 30;                   //

        private var _ctDown:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
        private var _ctNormal:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーン元にに

        private const _DECK_MOVE_X:int = _DECK_X + 300;
        private const _DECK_MOVE_Y:int = _DECK_Y + 70;
        private const _DECK_NAME_MOVE_X:int = _DECK_NAME_X + 370;

        private var _sizeMode:int = SIZE_MODE_NORMAL;
        // private var _sizeMode:int = SIZE_MODE_HALF;

        // 選択可能か
        private var _selectable:Boolean = true;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["クエストに使用するデッキです。",],
                [_TRANS_MSG,],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function RaidDeck()
        {
        }

        protected override function initDeckData():void
        {
            super.initDeckData();
            if (_sizeMode == SIZE_MODE_NORMAL) {
                log.writeLog(log.LV_DEBUG, this,"initDeckData. 1");
                _deckClip.x = _DECK_X;
                _deckClip.y = _DECK_Y;
                _deckName.x = _DECK_NAME_X;
                _deckName.y = _DECK_NAME_Y;
            } else {
                log.writeLog(log.LV_DEBUG, this,"initDeckData. 2");
                _deckClip.scaleX = 0.5;
                _deckClip.scaleY = 0.5;
                _deckClip.x = _DECK_MOVE_X;
                _deckClip.y = _DECK_MOVE_Y;
                _deckName.x = _DECK_NAME_MOVE_X;
                _deckName.y = _DECK_NAME_Y;
            }
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

        public override function leftDeckClick():void
        {
            _selectable = false;
            super.leftDeckClick();
        }
        public override function rightDeckClick():void
        {
            _selectable = false;
            super.rightDeckClick();
        }

        public function set selectable(f:Boolean):void
        {
            _selectable = f;
            setDeckTone();
        }
        public function get selectable():Boolean
        {
            return _selectable;
        }
        public function get selectIndex():int
        {
            return _deckEditor.selectIndex;
        }
        private function setDeckTone():void
        {
            if (_selectable) {
                _container.transform.colorTransform = _ctNormal;
            } else {
                _container.transform.colorTransform = _ctDown;
            }
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

        public function changeHalfMode():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_deckClip, {x:_DECK_MOVE_X,y:_DECK_MOVE_Y,scaleX:0.5,scaleY:0.5}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_deckName, {x:_DECK_NAME_MOVE_X}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new ClousureThread(function():void{_sizeMode = SIZE_MODE_HALF}));
            pExec.start();
        }
        public function changeNormalMode():void
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_deckClip, {x:_DECK_X,y:_DECK_Y,scaleX:1.0,scaleY:1.0}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_deckName, {x:_DECK_NAME_X}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new ClousureThread(function():void{_sizeMode = SIZE_MODE_NORMAL}));
            pExec.start();
        }

        public function harfDown():void
        {
            _deckClip.scaleX = 0.5;
            _deckClip.scaleY = 0.5;
        }
    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.raid.RaidDeck;


class ShowThread extends BaseShowThread
{
    public function ShowThread(aa:RaidDeck, stage:DisplayObjectContainer, at:int)
    {
        super(aa, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}

class HideThread extends BaseHideThread
{
    public function HideThread(aa:RaidDeck)
    {
        super(aa);
    }

}
