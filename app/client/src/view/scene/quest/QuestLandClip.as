package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.quest.*;
    import view.scene.*;
    import view.utils.*;
    import view.*;

    import controller.QuestCtrl;

    /**
     * キャラカードデッキ表示クラス
     *
     */
    public class QuestLandClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "現在開始可能なクエストです。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Quests you can begin.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "現在可以開始的任務。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "现在可开始的任务。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "현재 개시 가능한 퀘스트 입니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Quête que vous pouvez commencer";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "現在開始可能なクエストです。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "เควสที่สามารถทำได้ตอนนี้";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2	:String = "";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ
        private  var _stageContainer:UIComponent = new UIComponent();       // 地形部分表示コンテナ

        private static const _BASE_X_SET:Vector.<int> = Vector.<int>([88,184,280]);                         // 地形のX位置
        private static const _BASE_Y_SET:Vector.<int> = Vector.<int>([16,80,160,240,320,400]);              // 地形のY基本位置
        private static const _STAGE_X:int = 40;                    // 地形のX位置
        private static const _STAGE_Y:int = 56;


        private static const _Y:int = 20;
        private var _baseImage:MapBaseImage;
        private var _stageImage:MapStageImage;

        private var _eventImage:MapEventImage;
        private var _subEventImage:MapSubEventImage;

        private var _questLand:QuestLand;

        // 一定数
        private static const _NAME_X:int = 72;
        private static const _NAME_Y:int = 0;

        private var _start:Boolean;
        private var _data:Boolean;

        private var _goal:Boolean;
        private var _point:Point;
        private var _enable:Boolean = false;


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["現在開始可能なクエストです。"],
                [_TRANS_MSG],
                [_TRANS_MSG2],
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_OK_HELP:int = 0;
        private const _QUEST_NO_HELP:int = 1;
        private var _ctrl:QuestCtrl;

        /**
         * コンストラクタ
         *
         */
        public function QuestLandClip(ql:QuestLand, row:int,column:int, start:Boolean = false, data:Boolean = false, goal:Boolean= false)
        {
            _ctrl = QuestCtrl.instance;
            _start = start;
            _goal = goal;
            _data = data;
            _questLand = ql;
            x = _BASE_X_SET[row];
            y = _BASE_Y_SET[column]+_Y;
            _point = new Point(row,column-1);
            _stageContainer.x = _STAGE_X;
            _stageContainer.y = _STAGE_Y;
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,this]);  //
        }
        public function get point():Point
        {
            return _point;
        }

        // 現在の位置
        public function get position():int
        {
            return (_point.y*3+_point.x)
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
            // まずベースをLand情報に合わせて設定する
            // 空の場合なにもしない
            if (_questLand.id != 0 || _start)
            {
                if(!_data)
                {
                    // ベース部分と地形ステージを表示させる
                    if (_start)
                    {
                        _baseImage = new MapBaseImage(MapBaseImage.TYPE_START);
                        _container.addChild(_baseImage);
                    }else
                    {
                        if (_goal)
                        {
                            _baseImage = new MapBaseImage(MapBaseImage.TYPE_GOAL);
                        }else{
                            _baseImage = new MapBaseImage(MapBaseImage.TYPE_PASS);
                        }
                        _stageImage = new MapStageImage(_questLand.stage);
                        _container.addChild(_baseImage);
//                        _stageContainer.addChild(_stageImage);
                        _stageImage.getShowThread(_stageContainer,0).start();
                    }
                }
                else
                {
                    _stageImage = new MapStageImage(_questLand.stage);
//                    _stageContainer.addChild(_stageImage);
                    _stageImage.getShowThread(_stageContainer,0).start();
                }
                log.writeLog(log.LV_FATAL, this, "monster NO is",_questLand.monsterNo,"treasure no is", _questLand.treasureType);
                // その上にモンスターかトレジャーかを置く。
                if (_questLand.monsterNo !=0)
                {
                    if (_questLand.treasureType !=Const.TG_BONUS_GAME)
                    {
                        _eventImage= new MapEventImage();
                    }else
                    {
                        _eventImage= new MapEventImage(Const.TG_BONUS_GAME);

                    }
                    _eventImage.mouseEnabled = false;
                    _eventImage.mouseChildren = false;
//                    _stageContainer.addChild(_eventImage);
                    _eventImage.getShowThread(_stageContainer,10).start();
//                    log.writeLog(log.LV_FATAL, this, "tresure no",_questLand.treasureNo);
                    // モンスターでかつトレジャーありの場合
                    if (_questLand.treasureType !=Const.TG_NONE)
                    {
                        _subEventImage= new MapSubEventImage(_questLand.treasureType);
                        _subEventImage.mouseEnabled = false;
                        _subEventImage.mouseChildren = false;
                        _subEventImage.getShowThread(_stageContainer,11).start();
                    }
                }else if (_questLand.treasureType !=Const.TG_NONE && _questLand.treasureType !=Const.TG_BONUS_GAME){
                    _eventImage= new MapEventImage(_questLand.treasureType);
                    _eventImage.mouseEnabled = false;
                    _eventImage.mouseChildren = false;
//                    _stageContainer.addChild(_eventImage);
                    _eventImage.getShowThread(_stageContainer,10).start();
                }

                // ここでハンドラを登録
                _stageContainer.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
                _stageContainer.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
                _stageContainer.addEventListener(MouseEvent.CLICK, clickHandler);

                // 出すものをだす
                addChild(_container);
                addChild(_stageContainer)
                initilizeToolTipOwners();
                updateHelp(_QUEST_NO_HELP);
            }

        }
        public function hideEvent():void
        {
            if( _eventImage!=null){RemoveChild.apply(_eventImage)};
            if( _subEventImage!=null){RemoveChild.apply(_subEventImage)};
        }

        public function showEvent():void
        {
            if( _eventImage!=null){_stageContainer.addChild(_eventImage)};
            if( _subEventImage!=null){_stageContainer.addChild(_subEventImage)};
        }

        // 後始末処理
        public override function final():void
        {
            // ここでハンドラを取り除く
            _stageContainer.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
            _stageContainer.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
//            landFinalize();
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
//            log.writeLog(log.LV_FATAL, this, "show?!!!!!!!!!!!!!!!!!!!",_questLand);
            _depthAt = at;
            // 必ずパーツが読み込み済みでないといけない
            return new ModelWaitShowThread(this, stage, _questLand);
        }

        //
        private function overHandler(e:MouseEvent):void
        {
//            log.writeLog(log.LV_INFO, this, "mouse over");
            _ctrl.currentLand = _questLand;
        }
        private function outHandler(e:MouseEvent):void
        {
//            log.writeLog(log.LV_INFO, this, "mouse out");
            _ctrl.currentLand = QuestLand.ID(0);
        }

        private function clickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "mouse click",_point);

            if (_ctrl.progress&&_enable)
            {
                TopView.enable(false);
                log.writeLog(log.LV_INFO, this, "mouse click");
//                _ctrl.currentCharaPoint = _point;
                _ctrl.nextLand(_point);
                new WaitThread(1200,TopView.enable,[true]).start();
            }

        }
        public function enableClick(e:Boolean):void
        {
            log.writeLog(log.LV_INFO, this, "en click",_point);
            _enable = e;
            if (_stageImage != null)
            {
                _stageImage.enable(e);

            }
            if (_enable)
            {
                updateHelp(_QUEST_OK_HELP);
            }else{
                updateHelp(_QUEST_NO_HELP);
            }

        }



    }
}


