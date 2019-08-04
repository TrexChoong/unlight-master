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

    import controller.*;

    /**
     * クエストマップ表示クラス
     *
     */
    public class QuestWorldMap extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG1	:String = "全体マップです。クリックした地域からクエストを探索できます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "探索の設定を行います。探索時間が長いほどレアなクエストを見つけることができます。";
        CONFIG::LOCALE_JP
        private static const _TRANS_PRESENT	:String = "(プレゼント)";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG1	:String = "World map. Click to explore an area for quests.";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "Exploration settings. Searching for longer increases the chances of discovering a rare quest.";
        CONFIG::LOCALE_EN
        private static const _TRANS_PRESENT	:String = "(Gift)";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG1	:String = "大地圖。可以在點擊的區域裡搜索任務。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "搜索的設定。搜索時間越長越能找到稀有的任務。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_PRESENT	:String = "（禮物）";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG1	:String = "整体地图。可在点击的区域中搜索任务。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "进行搜索的设定。搜索时间越长，找到稀有任务的概率越高。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_PRESENT	:String = "（礼物）";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG1	:String = "전체 맵입니다. 클릭한 지역에서 퀘스트를 탐색 할 수 있습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "탐색 설정을 합니다. 탐색 시간이 길수록 레어한 퀘스트를 발견할 수 있습니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG1	:String = "Carte du Monde. Cliquez pour trouver les Quêtes.";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "Explorer une région : plus vous passerez de temps dans une région et plus vous aurez de chance de trouver une Quête rare.";
        CONFIG::LOCALE_FR
        private static const _TRANS_PRESENT	:String = "(Cadeau)";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG1	:String = "全体マップです。クリックした地域からクエストを探索できます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "探索の設定を行います。探索時間が長いほどレアなクエストを見つけることができます。";
        CONFIG::LOCALE_ID
        private static const _TRANS_PRESENT	:String = "(プレゼント)";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG1    :String = "แผนที่ทั้งหมด ท่านสามารถคลิกที่พื้นที่ที่จะทำการสำรวจเควสได้";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "กำหนดการทำเควส ยิ่งใช้เวลามากเท่าไหร่ ก็จะยิ่งมีโอกาสพบเควสหายากได้มากเท่านั้น";
        CONFIG::LOCALE_TH
        private static const _TRANS_PRESENT :String = "(ของขวัญ)";


        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ
//        private var _worldMap:WorldMapImage = new WorldMapImage();
        private var _worldMap:WorldMapImage;
        // クエスト進行度
        private var _questClearGauge:QuestClearGauge = new QuestClearGauge();

        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
//                ["全体マップです。クリックした地域からクエストを探索できます。"],
//                ["探索の設定を行います。探索時間が長いほどレアなクエストを見つけることができます。"],
                //[_TRANS_MSG1],
                [_TRANS_MSG2],
            ];

        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];

        // チップヘルプのステート
        private const _QUEST_HELP:int = 0;

        // 選択中のクエストマップのID
        private var _selectQuestMapId:int = -1;

        // 取得確認パネル
        private var _getSendPanel:GetSendPanel = new GetSendPanel();
        private var _getResultPanel:GetResultPanel = new GetResultPanel();

        private var _avatar:Avatar;
        private var _searchContainer:UIComponent;
        private var _questContainer:UIComponent;

        private static var __questType:int = Const.QUEST_NORMAL;

        /**
         * コンストラクタ
         *
         */
        public function QuestWorldMap()
        {
            _getSendPanel.visible = false;
            _getResultPanel.visible = false;
        }
        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            //toolTipOwnerArray.push([0,this]);  //
            toolTipOwnerArray.push([0,_getSendPanel]);  //
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
            _avatar = Player.instance.avatar;
            log.writeLog(log.LV_FATAL, this, "wo no",_avatar.questFlag);
            _worldMap = WorldMapImage.getNewestWorldMapImage(_avatar.questFlag);
            initilizeToolTipOwners();

            _worldMap.getShowThread(_container,0).start();
            updateHelp(_QUEST_HELP);
            _ctrl.addEventListener(QuestCtrl.QUEST_MAP_UPDATE, updateHandler);

            addChild(_container);
//            addChild(_getSendPanel);

            // ここでハンドラを登録
            _ctrl.addEventListener(QuestMapEvent.UPDATE, questMapUpdateHandler);
            _ctrl.addEventListener(AvatarQuestEvent.GET_QUEST, getQuestSuccessHandler);
            _avatar.addEventListener(Avatar.QUEST_FLAG_UPDATE, worldMapUpdateHandler);
            _worldMap.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            _worldMap.addEventListener(WorldMapImage.NEXT, nextClickHandler);
            _worldMap.addEventListener(WorldMapImage.BACK, backClickHandler);

            _getSendPanel.setOKHandler(pushUseOKHandler);
            _getSendPanel.setCloseHandler(pushUseCloseHandler);
            _getResultPanel.okButton.addEventListener(MouseEvent.CLICK, pushOkHandler);
            _questClearGauge.getShowThread(_container,10).start();

            if (_avatar.questClearNum == 0 && !_avatar.questCap)
            {
                // Voice.playCharaVoice(Voice.my_chara, Const.VOICE_SITUATION_QUEST_INTRO, _avatar.questFlag+1);
            }
//            _ctrl.addEventListener(QuestCtrl.QUEST_LAND_UPDATE, updateHandler)
        }


        public function set searchContainer(e:UIComponent):void
        {
            _searchContainer = e;
            _searchContainer.addChild(_getSendPanel);
            _searchContainer.addChild(_getResultPanel);
        }
        public function set questContainer(e:UIComponent):void
        {
            _questContainer = e;
        }

        // 後始末処理
        public override function final():void
        {
            _worldMap.getHideThread().start();
            // ここでハンドラを取り除く
            _ctrl.removeEventListener(QuestCtrl.QUEST_MAP_UPDATE, updateHandler)
//            _ctrl.removeEventListener(QuestCtrl.QUEST_LAND_UPDATE, updateHandler)
            // ここでハンドラを取り除く
            _ctrl.removeEventListener(QuestMapEvent.UPDATE, questMapUpdateHandler);
            _ctrl.removeEventListener(AvatarQuestEvent.GET_QUEST, getQuestSuccessHandler);
            _worldMap.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
            _worldMap.removeEventListener(WorldMapImage.NEXT, nextClickHandler);
            _worldMap.removeEventListener(WorldMapImage.BACK, backClickHandler);
            _getResultPanel.okButton.removeEventListener(MouseEvent.CLICK, pushOkHandler);
            _avatar.removeEventListener(Avatar.QUEST_FLAG_UPDATE, worldMapUpdateHandler);


            _getSendPanel.final();
            _questClearGauge.getHideThread().start();
            RemoveChild.apply(_getSendPanel);
            _searchContainer = null;
            _questContainer = null;

        }


        private function updateHandler(e:Event):void
        {
            log.writeLog(log.LV_INFO, this, "update map ");
            if(_ctrl.currentMap.id !=0)
            {
                _worldMap.setFade(true);
                _questClearGauge.setFade(true);
            }
            else
            {
                _worldMap.setFade(false);
                _questClearGauge.setFade(false);
            }
        }

        // マップを最新のものに更新
        private function worldMapUpdateHandler(e:Event):void
        {
            updateWorldMap(0,__questType);
            _avatar.questFlag == _ctrl.currentMapNo ? _questClearGauge.visible = true : _questClearGauge.visible = false ;
//            _questClearGauge.visible = true;
        }

        // マップを1つ進む
        private function nextClickHandler(e:Event):void
        {
            updateWorldMap(1,__questType);
            _avatar.questFlag == _ctrl.currentMapNo && _avatar.questFlag < Const.QUEST_CAP_LIST[__questType] ? _questClearGauge.visible = true : _questClearGauge.visible = false ;
        }

        // マップを1つ戻る
        private function backClickHandler(e:Event):void
        {
            updateWorldMap(-1,__questType);
            _questClearGauge.visible = false;
        }

        // マップを更新
        private function updateWorldMap(delta:int = 0,questType:int = 0):void
        {
            _worldMap.getHideThread().start();
            _worldMap.removeEventListener(MouseEvent.CLICK, mouseClickHandler);

            if (delta == 0) {
                _worldMap = WorldMapImage.getNewestWorldMapImage(_avatar.questFlag, __questType);
            } else if (delta > 0) {
                _worldMap = WorldMapImage.getNextWorldMapImage(_avatar.questFlag);
            } else {
                _worldMap = WorldMapImage.getPrevWorldMapImage(_avatar.questFlag);
            }
            _worldMap.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            _worldMap.addEventListener(WorldMapImage.NEXT, nextClickHandler);
            _worldMap.addEventListener(WorldMapImage.BACK, backClickHandler);
            _worldMap.getShowThread(_container,0).start();
        }

        // 指定したマップへ移動
        public function moveMap(idx:int,questType:int = Const.QUEST_NORMAL):void
        {
            if (__questType != questType) {
                __questType = questType;
                _questClearGauge.questType = __questType;
                _avatar.setQuestType(__questType);
            }
            _worldMap.getHideThread().start();
            _worldMap.removeEventListener(MouseEvent.CLICK, mouseClickHandler);

            log.writeLog(log.LV_DEBUG, this, "questName!!!",_avatar.questFlag, idx, __questType);
            _worldMap = WorldMapImage.getIndexWorldMapImage(_avatar.questFlag, idx, __questType);
            _worldMap.addEventListener(MouseEvent.CLICK, mouseClickHandler);
            _worldMap.addEventListener(WorldMapImage.NEXT, nextClickHandler);
            _worldMap.addEventListener(WorldMapImage.BACK, backClickHandler);
            _worldMap.getShowThread(_container,0).start();
            _avatar.questFlag == _ctrl.currentMapNo && _avatar.questFlag < Const.QUEST_CAP_LIST[__questType] ? _questClearGauge.visible = true : _questClearGauge.visible = false ;
        }

        // クエストを取得したときのハンドラ
        public function getQuestSuccessHandler(e:AvatarQuestEvent):void
        {
            log.writeLog(log.LV_INFO, this, "questName!!!",e.obj.quest , e.obj.quest.id, e.obj.quest.name, e.obj.quest.caption);
            // ペンド状態で絵無ければ
            if (e.obj.status != Const.QS_PENDING)
            {
                if (e.obj.status == Const.QS_PRESENTED)
                {
                    _getResultPanel.setQuestName(e.obj.quest.name+_TRANS_PRESENT);
                }else{
                    _getResultPanel.setQuestName(e.obj.quest.name);
                }
                _getResultPanel.visible = true;
                _questContainer.mouseChildren = false;
                _questContainer.mouseEnabled = false;
            }
        }

        // クエスト取得
        private function pushOkHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_INFO, this, "push ok");
            // クエストを取得
            _getResultPanel.visible = false;
            _questContainer.mouseChildren = true;
            _questContainer.mouseEnabled = true;

            SE.playClick();
        }


        // クエスト取得
        private function pushUseOKHandler():void
        {
            // クエストを取得
            _ctrl.getQuest(_selectQuestMapId,_getSendPanel.timer);
            _getSendPanel.visible = false;
            _questContainer.mouseChildren = true;
            _questContainer.mouseEnabled = true;

            SE.playClick();
        }

        // クエスト取得
        private function pushUseCloseHandler():void
        {
            _getSendPanel.visible = false;
            _questContainer.mouseChildren = true;
            _questContainer.mouseEnabled = true;

            SE.playClick();
        }

        // ハンドラ
        private function questMapUpdateHandler(e:QuestMapEvent):void
        {
            _container.visible =true;
        }

        // マウスクリックされたときのハンドラ
        public function mouseClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_FATAL, this, " mouse click event", e.currentTarget, e.target);
            _selectQuestMapId = _worldMap.getReligion(e.target);
            if (_selectQuestMapId > 0)
            {
                if (__questType == Const.QUEST_EVENT) {
                    _selectQuestMapId += QuestMap.EVENT_QUEST_START_ID;
                } else if (__questType == Const.QUEST_TUTORIAL) {
                    _selectQuestMapId += QuestMap.TUTORIAL_QUEST_START_ID;
                } else if (__questType == Const.QUEST_CHARA_VOTE) {
                    _selectQuestMapId += QuestMap.CHARA_VOTE_QUEST_START_ID;
                }
                log.writeLog(log.LV_FATAL, this, "select map no", _selectQuestMapId);
                _getSendPanel.setQuestMapName(QuestMap.ID(_selectQuestMapId).name);
                _getSendPanel.setQuestMapThumbnail(QuestMap.ID(_selectQuestMapId).id);
                _getSendPanel.setQuestMapAp(QuestMap.ID(_selectQuestMapId).ap);
                _getSendPanel.visible = true;
                log.writeLog(log.LV_FATAL, this, _questContainer);
                if(_questContainer!=null)
                {
                    _questContainer.mouseChildren = false;
                    _questContainer.mouseEnabled = false;
                }
            }
        }

        public static function get questType():int
        {
            return __questType;
        }
        public static function set questType(t:int):void
        {
            __questType = t;
        }

        public function isSameErea(idx:int,type:int):Boolean
        {
            return (WorldMapImage.ereaMapNo == idx && __questType == type);
        }
    }

}


