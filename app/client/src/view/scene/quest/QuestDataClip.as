package view.scene.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.EventDispatcher;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.utils.*;
    import view.image.quest.*;
    import view.scene.*;

    import controller.*;

    /**
     * クエストマップ表示クラス
     *
     */
    public class QuestDataClip extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "地形の詳細です。";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Information about the area.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "地形的詳細資訊。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "地形的详细信息。";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "지형의 상세 정보 입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Informations concernant la région";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "地形の詳細です。";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG :String = "รายละเอียดของแผนที่";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ
        private var _mapData:MapDataImage = new MapDataImage();
        private var _commanData:QuestCommandImage = new QuestCommandImage();

        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        private var _questLandClip:QuestLandClip;                        // キャプション

        private var _nameText:Label = new Label();                        // 名前
        private var _dataText:Text = new Text();                          // キャプション

        private var _stageText:Label = new Label();                       // キャプション
        // private var _eventText:Label = new Label();                       // キャプション

        // 位置定数
        private static const _LAND_X:int = 472;                     // X位置
        private static const _LAND_Y:int = 347;                     // X位置

        private static const _NAME_TEXT_X:int = 468;                     // X位置
        private static const _NAME_TEXT_Y:int = 335;                     // X位置
        private static const _NAME_TEXT_WIDTH:int = 90;               // 横幅
        private static const _NAME_TEXT_HEIGHT:int = 20;              // 縦幅

        private static const _DATA_TEXT_X:int = 473;                     // X位置
        private static const _DATA_TEXT_Y:int = 412;                     // X位置
        private static const _DATA_TEXT_WIDTH:int = 80;               // 横幅
        private static const _DATA_TEXT_HEIGHT:int = 70;              // 縦幅

        private static const _STAGE_TEXT_X:int = 468;                     // X位置
        private static const _STAGE_TEXT_Y:int = 412;                     // X位置
        private static const _STAGE_TEXT_WIDTH:int = 90;               // 横幅
        private static const _STAGE_TEXT_HEIGHT:int = 20;              // 縦幅

        private static const _EVENT_TEXT_X:int = 468;                     // X位置
        private static const _EVENT_TEXT_Y:int = 430;                     // X位置
        private static const _EVENT_TEXT_WIDTH:int = 90;               // 横幅
        private static const _EVENT_TEXT_HEIGHT:int = 20;              // 縦幅



        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["地形の詳細です。"],
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
        public function QuestDataClip()
        {
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            toolTipOwnerArray.push([0,_mapData]);  //
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
            _nameText.x = _NAME_TEXT_X;
            _nameText.y = _NAME_TEXT_Y;
            _nameText.width = _NAME_TEXT_WIDTH;
            _nameText.height = _NAME_TEXT_HEIGHT;
            _nameText.styleName = "QuestLandDataLabel";


            _dataText.x = _DATA_TEXT_X;
            _dataText.y = _DATA_TEXT_Y;
            _dataText.width = _DATA_TEXT_WIDTH;
            _dataText.height = _DATA_TEXT_HEIGHT;
            _dataText.styleName = "QuestLandDataLabel";

            // _eventText.x = _EVENT_TEXT_X;
            // _eventText.y = _EVENT_TEXT_Y;
            // _eventText.width = _EVENT_TEXT_WIDTH;
            // _eventText.height = _EVENT_TEXT_HEIGHT;
            // _eventText.styleName = "QuestLandDataLabel";

            _stageText.x = _STAGE_TEXT_X;
            _stageText.y = _STAGE_TEXT_Y;
            _stageText.width = _STAGE_TEXT_WIDTH;
            _stageText.height = _STAGE_TEXT_HEIGHT;
            _stageText.styleName = "QuestLandDataLabel";

            _mapData.getShowThread(this,0).start();
            _commanData.getShowThread(this,2).start();
            addChild(_nameText);
            addChild(_dataText);
//             addChild(_eventText);
//             addChild(_stageText);

            initilizeToolTipOwners();
            updateHelp(_QUEST_HELP);

            _ctrl.addEventListener(QuestCtrl.QUEST_LAND_UPDATE, updateHandler);
//            _mapData.drop.addEventListener(MouseEvent.CLICK, pushDropHandler);
        }

        // 後始末処理
        public override function final():void
        {
            _mapData.getHideThread().start();
            _commanData.getHideThread().start();
            RemoveChild.apply(_nameText);
            RemoveChild.apply(_dataText);
//             removeChild(_eventText);
//             removeChild(_stageText);

            // ここでハンドラを取り除く
            _ctrl.removeEventListener(QuestCtrl.QUEST_LAND_UPDATE, updateHandler);
//            _mapData.drop.removeEventListener(MouseEvent.CLICK, pushDropHandler);
        }

//         private function pushDropHandler(e:MouseEvent):void
//         {
//             _ctrl.deleteQuest(_ctrl.currentQuestInventory.inventoryID);
//             _ctrl.currentMap = Quest.ID(0);
//         }

        private function updateHandler(e:Event):void
        {
            if(_ctrl.currentLand.id != 0)
            {
                _questLandClip = new QuestLandClip(_ctrl.currentLand, 0, 0, false, true);
                _questLandClip.x = _LAND_X;
                _questLandClip.y = _LAND_Y;
                _questLandClip.getShowThread(this).start();

                _nameText.text = _ctrl.currentLand.name;
                _dataText.text = _ctrl.currentLand.caption;
                // _eventText.text = _ctrl.currentLand.eventString;
                _stageText.text = _ctrl.currentLand.stageString;

                // By_K2 (무한의 탑 층 표시)
                if (_ctrl.currentLand.id >= 99991 && _ctrl.currentLand.id <= 99996)
                {
                    _dataText.text = Player.instance.avatar.floorCount + " 층";
                }
                else
                {
                    _dataText.text = _ctrl.currentLand.caption;
                }
            }
            else
            {
                if(_questLandClip)
                {
                    _questLandClip.getHideThread().start();
                    _questLandClip = null;
                }
                _nameText.text = "";
                _dataText.text = "";
                // _eventText.text = "";
                _stageText.text = "";
            }
        }

    }

}


