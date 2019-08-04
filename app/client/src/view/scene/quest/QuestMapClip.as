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

    import view.utils.*;
    import view.image.quest.*;
    import view.scene.*;
    import view.*;

    import controller.QuestCtrl;


    /**
     * クエストマップ表示クラス
     *
     */
    public class QuestMapClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "クエストのマップです。選択した場所に進み、戦闘が始まります。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "The quest's map. Make progress and engage in battles in the selected area.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "任務地圖。移動到選擇的地方，並進行戰鬥。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "任务的地图。进入所选的场所后战斗开始。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "퀘스트의 맵 입니다. 선택한 장소로 진행해 전투가 시작됩니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Carte de votre Quête. Les Duels auront lieu dans les régions sélectionnées.";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "クエストのマップです。選択した場所に進み、戦闘が始まります。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "แผนที่ของเควส ท่านสามารถดำเนินเควสได้โดยการเลือกพื้นที่ที่ต้องการและเริ่มทำการต่อสู้";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private static const _MAP_Y:int = 20;                          // カードのY基本位置

        private var _landMap:Vector.<QuestLandClip> = new Vector.<QuestLandClip>();
        private var _nextPass:Vector.<QuestPassClip> = new Vector.<QuestPassClip>();

        private var _quest:Quest;

        // マップデータ
        private var _questDataClip:QuestDataClip = new QuestDataClip();
        // マップへ戻るボタン
        private var _mapBackButton:MapBackButton = new MapBackButton();


        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["クエストのマップです。選択した場所に進み、戦闘が始まります。"],
                [_TRANS_MSG],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        // コントローラー
        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        /**
         * コンストラクタ
         *
         */
        public function QuestMapClip(quest:Quest)
        {
            _quest = quest;
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
            var row:int;        // 横列
            var column:int;     // 縦列
            var start:int = _quest.startRow;
//            log.writeLog(log.LV_FATAL, this, "start is " ,start);

            // スタート位置を作る
            for(var i:int = 0; i < 3; i++){
                _landMap.push(new QuestLandClip(QuestLand.ID(0),i,0,(start == i)))
            }

            // ここでQuestからmapを作る。スタート部分は別なのでColumn＋１
            _quest.landSet.forEach(function(item:*, index:int, array:Vector.<QuestLand>):void
                                   {
                                       row =index%3;
                                       column =int(index/3)+1;
                                       _landMap.push(new QuestLandClip(item,row,column,false,false,_quest.isGoal(index)))
                                   });

            // ここでQuestからpassを作る。passは12固定なので
            for(var j:int = 0; j < 12; j++){
                row =j%3;
                column =int(j/3);
                var v:Vector.<int> = _quest.nextSet;
                _nextPass.push(new QuestPassClip(row, column, v[column*3],v[column*3+1],v[column*3+2]))
            }


            // ここでハンドラを登録
            _mapBackButton.addEventListener(MouseEvent.CLICK, backButtonClickHandler);
            _quest.addEventListener(Quest.PROGRESS_UPDATE, progressUpdateHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_INPROGRESS, improgressHandler);
            _ctrl.addEventListener(QuestCtrl.QUEST_SOLVED, solevedHandler);
            _ctrl.addEventListener(QuestCtrl.CHARA_POINT_UPDATE, charaPointUpdateHandler)

            // 出すものをだす
//            _container.addChild(_mapImage);
            _container.addChild(_mapBackButton);
            addChild(_container);

            _landMap.forEach(function(land:*, index:int, array:Vector.<QuestLandClip>):void{land.getShowThread(_container,100).start()});
            _nextPass.forEach(function(land:*, index:int, array:Vector.<QuestPassClip>):void{land.getShowThread(_container,0).start()});
            _questDataClip.getShowThread(_container).start();

            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);
        }

        // 後始末処理
        public override function final():void
        {
            // ここでハンドラを取り除く
            _mapBackButton.removeEventListener(MouseEvent.CLICK, backButtonClickHandler);
            _quest.removeEventListener(Quest.PROGRESS_UPDATE, progressUpdateHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_INPROGRESS, improgressHandler);
            _ctrl.removeEventListener(QuestCtrl.QUEST_SOLVED, solevedHandler);
            _ctrl.removeEventListener(QuestCtrl.CHARA_POINT_UPDATE, charaPointUpdateHandler)

            RemoveChild.apply(_mapBackButton);
            RemoveChild.apply(_container);

//            _container.removeChild(_mapBackButton);
//            removeChild(_container)

            _landMap.forEach(function(land:*, index:int, array:Vector.<QuestLandClip>):void{land.getHideThread().start()});
            _nextPass.forEach(function(land:*, index:int, array:Vector.<QuestPassClip>):void{land.getHideThread().start()});
            _questDataClip.getHideThread().start();
        }


        // マップへ戻るボタンが押されたときのハンドラ
        private function backButtonClickHandler(e:MouseEvent):void
        {
            _ctrl.currentMap = Quest.ID(0);
            _ctrl.questInitialize();
        }

        // マップの進行度が更新されたとき
        private function progressUpdateHandler(e:Event):void
        {
//            _ctrl.currentMap = Quest.ID(0);
            _landMap.forEach(function(land:QuestLandClip, index:int, array:Vector.<QuestLandClip>):void{
                    if (_quest.checkLandDone(land.position))
                    {
                        new WaitThread(1200,land.hideEvent).start();
                    }else{
                        land.showEvent();
                    };
                    land.enableClick(_quest.checkRoadExist(_ctrl.currentCharaPoint.x,_ctrl.currentCharaPoint.y, land.point.x, land.point.y));
                });
        }

        // キャラの位置が更新されたとき
        private function charaPointUpdateHandler(e:Event):void
        {
//            log.writeLog(log.LV_FATAL, this, "chara Point  update!!!!!!!");
            _landMap.forEach(function(land:QuestLandClip, index:int, array:Vector.<QuestLandClip>):void
                             {
//                                 log.writeLog(log.LV_FATAL, this, "chara Point  update",_quest.checkRoadExist(_ctrl.currentCharaPoint.x,_ctrl.currentCharaPoint.y, land.point.x, land.point.y));
                                 land.enableClick(_quest.checkRoadExist(_ctrl.currentCharaPoint.x,_ctrl.currentCharaPoint.y, land.point.x, land.point.y));
                             });
        }


        private function improgressHandler(e:Event):void
        {
            _mapBackButton.visible = false;
        }

        private function solevedHandler(e:Event):void
        {
            _mapBackButton.visible = true;
            _ctrl.currentMap = Quest.ID(0);
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
//            log.writeLog(log.LV_FATAL, this, "show?!!!!!!!!!!!!!!!!!!!",_quest);
            _depthAt = at;
            // 必ずパーツが読み込み済みでないといけない
            return new ModelWaitShowThread(this, stage, _quest);
        }

    }

}


