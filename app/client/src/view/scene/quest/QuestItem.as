package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;
    import flash.utils.*;
    import flash.events.TimerEvent;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.BaseScene;
    import view.utils.*;

    import controller.QuestCtrl;

    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class QuestItem extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "現在開始可能なクエストです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM		:String = "確認";
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM_DELMSG	:String = "この探索中のクエストを削除しますか？\n残り時間";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Quests you can begin.";
        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM		:String = "Confirm";
        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM_DELMSG	:String = "Do you really want to delete this quest?\nTime remaining: ";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "現在可以開始的任務。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM		:String = "確認";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM_DELMSG	:String = "確定要刪除這個任務?";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "现在可开始的任务。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM		:String = "确认";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM_DELMSG	:String = "是否删除这个任务？\n剩余时间";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "현재 개시 가능한 퀘스트 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM		:String = "확인";
        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM_DELMSG	:String = "이 퀘스트를 삭제하겠습니까?";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Quête que vous pouvez commencer";
        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM		:String = "Confirmer";
        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM_DELMSG	:String = "Supprimer cette Quête ?";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "現在開始可能なクエストです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM		:String = "確認";
        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM_DELMSG	:String = "この探索中のクエストを削除しますか？\n残り時間";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "เควสที่สามารถทำได้ตอนนี้";
        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM     :String = "ตกลง";
        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM_DELMSG  :String = "จะลบเควสที่กำลังทำการสำรวจอยู่นี้ไหมครับ?\nเวลาที่เหลือ";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private static const _ITEM_X:int = 464;                         // カードのX基本位置
        private static const _ITEM_Y:int = 44;                          // カードのY基本位置
        private static const _ITEM_H:int = 16;                          // カードのY基本位置

        private var _itemImage:QuestItemImage = new QuestItemImage();
        private var _questInv:AvatarQuestInventory;
        private var _ctrl:QuestCtrl;


        // ステータスラベル
        private var _name:Label = new Label();
        private var _level:Label = new Label();
        private var _ap:Label = new Label();
        private var _rare:Label = new Label();
        private var _remainTime:Label = new Label();
        private var _time:Timer;


        private var _startTime:Number;
        private var _endTime:Number;
        private var _nowTime:Number;

        private var _sec:int;
        private var _min:int;
        private var _hour:int;
        private var _day:int;

        // 一定数
        private static const _NAME_X:int = 72;
        private static const _NAME_Y:int = 0;
        private static const _NAME_WIDTH:int = 150;
        private static const _NAME_HEIGHT:int = 20;

        private static const _LEVEL_X:int = 38;
        private static const _LEVEL_Y:int = 0;
        private static const _LEVEL_WIDTH:int = 40;
        private static const _LEVEL_HEIGHT:int = 20;

        private static const _AP_X:int = 270;
        private static const _AP_Y:int = 0;
        private static const _AP_WIDTH:int = 20;
        private static const _AP_HEIGHT:int = 20;

        private static const _REMAIN_X:int = 100;
        private static const _REMAIN_Y:int = 0;
        private static const _REMAIN_WIDTH:int = 100;
        private static const _REMAIN_HEIGHT:int = 20;

        private static const _RARE_X:int = 235;
        private static const _RARE_Y:int = 0;
        private static const _RARE_WIDTH:int = 20;
        private static const _RARE_HEIGHT:int = 20;


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["現在開始可能なクエストです。"],
                [_TRANS_MSG],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function QuestItem(aqi:AvatarQuestInventory,index:int)
        {
            _ctrl = QuestCtrl.instance;
            _questInv = aqi;
            setPosition(index);
        }

        public function setPosition(i:int):void
        {
            x = _ITEM_X;
            y = _ITEM_Y+i*_ITEM_H;

        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
        }



        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        public override function init():void
        {

            // ここでハンドラを登録
            addEventListener(MouseEvent.MOUSE_OVER, overHandler);
            addEventListener(MouseEvent.MOUSE_OUT, outHandler);
            addEventListener(MouseEvent.CLICK, clickHandler);
            _questInv.addEventListener(AvatarQuestInventory.STATUS_UPDATE, statusUpdateHandler);
            _questInv.addEventListener(AvatarQuestInventory.FIND_AT_UPDATE, findAtUpdateHandler);

            // 出すものをだす
            _container.addChild(_itemImage);
            addChild(_container);

            itemInitialize(_questInv.quest);

            _helpTextArray[0][0] = _questInv.quest.caption;

            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);
        }

        // 後始末処理
        public override function final():void
        {
            // ここでハンドラを取り除く
            removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
            removeEventListener(MouseEvent.CLICK, clickHandler);
            _questInv.removeEventListener(AvatarQuestInventory.STATUS_UPDATE, statusUpdateHandler);
            _questInv.removeEventListener(AvatarQuestInventory.FIND_AT_UPDATE, findAtUpdateHandler);
            if (_time !=null)
            {
                _time.removeEventListener(TimerEvent.TIMER, updateHandler);
            }
            itemFinalize();
        }


        // リストの初期化
        public  function itemInitialize(quest:Quest):void
        {
            log.writeLog(log.LV_INFO, this, "initialize!!!");

            // 一個ずつリストとインベントリのクエスト内容とをを結びつける
            _name.text = quest.name;
            if (quest.id==0)
            {
                if (_time == null)
                {
                    _endTime = _questInv.getRemainTime;
                    _startTime = getTimer();
                    _nowTime = _endTime;
                    _level.text = "Lv ?";
                    _rare.text = "?";
                    _ap.text = " ?";
                    _time = new Timer(1000);
                    _time.start();
                    _time.addEventListener(TimerEvent.TIMER, updateHandler);
                    updateTime();
                }
            }else{
                _level.text = "Lv "+quest.difficulty.toString();

                // By_K2 (무한의탑인경우 레어도 숨김처리)
                if (quest.name == "무한의탑")
                {
                    _rare.text = "?";
                }
                else
                {
                    _rare.text = quest.rarity.toString();
                }

                _ap.text = "x"+quest.ap.toString();
                _remainTime.text = ""
            }


            _remainTime.styleName = "QuestItemTimer";

            _name.x = _NAME_X;
            _name.y = _NAME_Y;
            _name.width = _NAME_WIDTH;
            _name.height = _NAME_HEIGHT;
            _name.setStyle("color","#AAAAAA");

            _ap.x = _AP_X;
            _ap.y = _AP_Y;
            _ap.width = _AP_WIDTH;
            _ap.height = _AP_HEIGHT;
            _ap.setStyle("color","#AAAAAA");

            _level.x = _LEVEL_X;
            _level.y = _LEVEL_Y;
            _level.width = _LEVEL_WIDTH;
            _level.height = _LEVEL_HEIGHT;
            _level.setStyle("color","#AAAAAA");
            _level.setStyle("fontSize",8);

            _remainTime.x = _REMAIN_X;
            _remainTime.y = _REMAIN_Y;
            _remainTime.width = _REMAIN_WIDTH;
            _remainTime.height = _REMAIN_HEIGHT;
            _remainTime.setStyle("color","#AAAAAA");

            _rare.x = _RARE_X;
            _rare.y = _RARE_Y;
            _rare.width = _RARE_WIDTH;
            _rare.height = _RARE_HEIGHT;
            _rare.setStyle("textAlign",  "center");
            _rare.setStyle("letterSpacing", "-1");
            _rare.setStyle("color","#AAAAAA");

            // 正しい位置に並べる
            _container.addChild(_name);
            _container.addChild(_ap);
            _container.addChild(_level);
            _container.addChild(_remainTime);
            _container.addChild(_rare);
            _itemImage.changeState(_questInv.status);
            _itemImage.changeType(quest.kind);
        }

        private function updateTime():void
        {
//            _remainTime.text = "["+_nowTime.toString()+"]";
            _remainTime.text = "["+TimeFormat.toString(_nowTime)+"]";

        }

//         private function timeFormating():String
//         {
//             var ret:Array = []
//             _day = int(_nowTime/(24*60*60*1000));
//             if (_nowTime>24*60*60*1000)
//             {
//                 ret.push(_day.toString());
//             }

//             _hour =int(_nowTime/(60*60*1000))%24;
//             if (_nowTime>60*60*1000)
//             {
//                 ret.push(("0"+_hour.toString()).substr(-2,2))
//             }

//             _min = int(_nowTime/(60*1000))%60;
//             ret.push(("0"+_min.toString()).substr(-2,2));

//             _sec = int(_nowTime/(1000))%60;
//             ret.push(("0"+_sec.toString()).substr(-2,2))

//             return ret.join(":");
//         }

        public function updateHandler(e:TimerEvent):void
        {
            var now:int = getTimer();
            _nowTime = _nowTime - ( now - _startTime );
            _startTime = now;
            if (_nowTime <0)
            {
                _time.stop();
                _nowTime = 0;
                _ctrl.questFindCheck(_questInv.inventoryID);
            }
            updateTime();

        }

        private function overHandler(e:MouseEvent):void
        {
            _itemImage.changeSelect(true);

        }

        private function outHandler(e:MouseEvent):void
        {
            _itemImage.changeSelect(false);
        }
        private function clickHandler(e:MouseEvent):void
        {
            _ctrl.currentMap = _questInv.quest;
            _ctrl.currentQuestInventory = _questInv;
            _ctrl.questListItemClick();
            if (_questInv.status == Const.QS_NEW)
            {
                _ctrl.confirmQuest(_questInv.inventoryID);
            }else if (_questInv.status == Const.QS_PENDING)
            {
                ConfirmPanel.show(_TRANS_CONFIRM, _TRANS_CONFIRM_DELMSG+"["+TimeFormat.toString(_nowTime)+"]", _ctrl.deleteQuest, this);
            }
            SE.playClick();
        }

        // リストの後始末処理
        protected   function itemFinalize():void
        {
            RemoveChild.apply(_name);
            RemoveChild.apply(_ap);
            RemoveChild.apply(_level);
        }

        public function get questInv():AvatarQuestInventory
        {
            return _questInv;
        }

        private function statusUpdateHandler(e:Event):void
        {
            _itemImage.changeState(_questInv.status);
//            itemInitialize(_questInv.quest);
            new UpdateStateThread(_questInv.quest, this).start();

        }

        private function findAtUpdateHandler(e:Event):void
        {
            _time.stop();
            _time.removeEventListener(TimerEvent.TIMER, updateHandler);
            _endTime = _questInv.getRemainTime;
            _startTime = getTimer();
            _nowTime = _endTime;
            _level.text = "Lv ?";
            _rare.text = "?";
            _ap.text = "?";
            _time = new Timer(1000);
            _time.start();
            _time.addEventListener(TimerEvent.TIMER, updateHandler);
        }


        // 全体の更新
        public function update():void
        {
//             for (var key:Object in _cccDic)
//             {
//                 clipUpdate(_cccDic[key])
//             }
        }

        // リストのの更新
        protected function itemUpdate():void
        {
//            new BeTweenAS3Thread(cc, {x:_CARD_X+_CARD_OFFSET_X*CharaCardInventory(cc.cardInventory).position ,y:_CARD_Y}, null, 0.20, BeTweenAS3Thread.EASE_OUT_SINE).start();
        }

        // カードを消す
        protected function removeCard():void
        {
//            _deckEditor.deckToBinderCharaCard(CharaCardInventory(cc.cardInventory));
        }


        // カードを足す
        protected function addCard():void
        {
//             clipInitialize(cci);
//             addMouseEventHandler();
//             update();
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(_questInv.quest, this, stage);
        }

        // 非表示スレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }
        // 探索中か
        public function get isFinding():Boolean
        {
            // 残り時間が存在すれば探索中とみなす
            log.writeLog(log.LV_FATAL, this, "++++++++++++++++++",_remainTime.text);
            return _remainTime.text !="";
        }

    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import model.Quest;
import view.scene.quest.*;
import view.BaseShowThread;
import view.BaseHideThread;
import controller.LobbyCtrl;


// 表示スレッド
class ShowThread extends BaseShowThread
{
    protected var _qs:Quest;
    protected var _qsi:QuestItem;

    public function ShowThread(qs:Quest, qsi:QuestItem, stage:DisplayObjectContainer)
    {
        _qs = qs;
        _qsi = qsi;
        super(qsi,stage)
    }

    protected override function run():void
    {
        // キャラカードの準備を待つ
        if (_qs.loaded == false)
        {
            _qs.wait();
        }
        next(close);
    }
}




// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(qs:QuestItem)
    {
        super(qs);
     }

}

// 表示スレッド
class UpdateStateThread extends Thread
{
    protected var _qs:Quest;
    protected var _qsi:QuestItem;

    public function UpdateStateThread(qs:Quest, qsi:QuestItem)
    {
        _qs = qs;
        _qsi = qsi;
    }

    protected override function run():void
    {
        // キャラカードの準備を待つ
        if (_qs.loaded == false)
        {
            _qs.wait();
        }
        next(fin);
    }

    private function fin():void
    {
        _qsi.itemInitialize(_qs);
    }

}


