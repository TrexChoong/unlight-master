package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;

    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.utils.*;
    import view.image.common.AvatarImage;
    import view.scene.BaseScene;
    import view.scene.edit.CharaCardDeckClip;
    import view.scene.common.CharaCardClip;

    import model.CharaCard;
    import model.CharaCardDeck;
    import model.DeckEditor;
    import model.events.*;

    /**
     * クエストに使用するデッキクラス
     *
     */
    public class QuestDeck extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "クエストに使用するデッキです。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "The deck used for quests.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "在任務中使用的牌組。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "用于任务的卡组。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "퀘스트에서 사용하는 덱입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Pioche utilisée pour cette Quête";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "クエストに使用するデッキです。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "สำรับที่ใช้ในเควส";


        // エディットインスタンス
        protected var _deckEditor:DeckEditor;
        // 表示コンテナ
        protected var _container:UIComponent = new UIComponent();
        // カレントデッキ
        protected var _deckClip:CharaCardDeckClip;
        // デッキの名前ラベル
        protected var _deckName:Label = new Label();


        private const _LABEL_WIDTH:int = 200;                      // ラベルの幅
        private const _LABEL_HEIGHT:int = 20;                      // ラベルの高さ
        private const _LABEL_X:int = 500;                          // デッキエリアのX位置
        private const _LABEL_Y:int = 10;                           // デッキエリアのY位置

        private const _DECK_X:int = 125;                           // デッキエリアのX位置
        private const _DECK_Y:int = 475;                            // デッキエリアのY位置
        private const _DECK_SIZE:Number = 1.0;                     // デッキサイズ
        private const _DECK_NAME_X:int = 65;                      // デッキネームのX位置
        private const _DECK_NAME_Y:int = 635;                      // デッキネームのY位置

        // private const _LABEL_WIDTH:int = 200;                      // ラベルの幅
        // private const _LABEL_HEIGHT:int = 20;                      // ラベルの高さ
        // private const _LABEL_X:int = 500;                          // デッキエリアのX位置
        // private const _LABEL_Y:int = 10;                           // デッキエリアのY位置

        // private const _DECK_X:int = 110;                           // デッキエリアのX位置
        // private const _DECK_Y:int = 497;                            // デッキエリアのY位置
        // private const _DECK_SIZE:Number = 1.0;                     // デッキサイズ
        // private const _DECK_NAME_X:int = 145;                      // デッキネームのX位置
        // private const _DECK_NAME_Y:int = 478;                      // デッキネームのY位置

        private const _CHANGE_X:int = 964;                         //
        private const _CHANGE_Y:int = 693;                         //
        private const _CHANGE_OFFSET_X:int = 20;                   //
        private const _CHANGE_OFFSET_Y:int = 30;                   //


        // 変数
        protected var _selectIndex:int = 0;                      // 選択中のデッキインデックス



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
        public function QuestDeck()
        {
//             mouseEnabled = false;
//             mouseChildren = false;
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
            _deckEditor = DeckEditor.instance;
            _selectIndex = _deckEditor.currentIndex;
            _deckEditor.initialize();

            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);

            initDeckData();

            addChild(_container);
        }

        // 終了
        public override function final():void
        {
            _deckEditor.finalize();

            RemoveChild.apply(_container);
            deleteDeckData();
        }

        // デッキを初期化
        protected function initDeckData():void
        {
            _deckClip = new CharaCardDeckClip(CharaCardDeck.decks[_selectIndex]);
            _deckClip.x = _DECK_X;
            _deckClip.y = _DECK_Y;
            _deckClip.scaleX = _deckClip.scaleY = _DECK_SIZE;
            _deckClip.getShowThread(_container).start();

            if(_deckEditor.currentIndex == CharaCardDeck.decks.indexOf(_deckClip.charaCardDeck))
            {
                _deckName.styleName = "CurrentQuestDeckNameLabel";
            }
            else
            {
                _deckName.styleName = "CurrentQuestDeckNameLabel";
//                 _deckName.styleName = "QuestDeckNameLabel";
            }
            _deckName.x = _DECK_NAME_X;
            _deckName.y = _DECK_NAME_Y;
            _deckName.width = 160;
            _deckName.height = _LABEL_HEIGHT;
            _deckName.text = CharaCardDeck.decks.indexOf(_deckClip.charaCardDeck) + ". " + _deckClip.charaCardDeck.name;
            _deckName.filters = [new GlowFilter(0xffffff, 1, 2, 2, 16, 1),]
            _container.addChild(_deckName);
        }

        // デッキを消去
        protected function deleteDeckData():void
        {
            if (_deckClip != null)
            {
                _deckClip.getHideThread().start();
                _deckClip = null;
            }
        }


        // 左のデッキをクリック
        public function leftDeckClick():void
        {
            _deckEditor.selectIndex = _selectIndex-1;
            _selectIndex = _deckEditor.selectIndex;
            deleteDeckData();
            initDeckData();

            // カレントデッキを変更
            _deckEditor.changeCurrentDeck(_selectIndex);
            log.writeLog(log.LV_INFO, this, "aaaaa", _deckEditor.selectIndex);
        }

        // 右のデッキをクリック
        public function rightDeckClick():void
        {
            _deckEditor.selectIndex = _selectIndex+1;
            _selectIndex = _deckEditor.selectIndex;
            deleteDeckData();
            initDeckData();

            // カレントデッキを変更
            _deckEditor.changeCurrentDeck(_selectIndex);
            log.writeLog(log.LV_INFO, this, "bbbbb", _deckEditor.selectIndex);
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

import view.BaseShowThread;
import view.BaseHideThread;
import view.scene.quest.QuestDeck;


class ShowThread extends BaseShowThread
{
    public function ShowThread(aa:QuestDeck, stage:DisplayObjectContainer, at:int)
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
    public function HideThread(aa:QuestDeck)
    {
        super(aa);
    }

}
