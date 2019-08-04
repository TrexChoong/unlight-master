package view.scene.common
{
    import flash.utils.IDataInput;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.*;

    import mx.controls.Label;
    import mx.controls.Text;
    import mx.controls.Button;
    import mx.core.UIComponent;
    import mx.containers.Canvas;
    import mx.core.IDataRenderer;
    import mx.events.FlexEvent;
    import mx.events.ListEvent;

    import model.*;
    import view.scene.BaseScene;
    import view.utils.*;
    import view.image.common.*;

    public class AchievementListContainer extends UIComponent
    {
        private static var __instance:AchievementListContainer;

        private static const STATE_START:int  = 0;
        private static const STATE_FINISH:int = 1;
        private static const STATE_NUM:int    = 2;

        private static const TAB_ALL:int     = 0;
        private static const TAB_AVATAR:int  = 1;
        private static const TAB_DUEL:int    = 2;
        private static const TAB_QUEST:int   = 3;
        private static const TAB_EVENT:int   = 4;
        private static const TAB_FRIENDS:int = 5;
        private static const TAB_SIZE:int    = 6;

        private var _currentState:int = 0;
        private var _currentTab:int = 0;

        // 継続中のレコード
        private var _pageNumSet:Vector.<int> = Vector.<int>([0,0,0,0,0,0]); // 今いるページのセット
        private var _counterSet:Vector.<int> = Vector.<int>([0,0,0,0,0,0]); // 要素数
        private var _containerSet:Vector.<UIComponent>  =  Vector.<UIComponent>(
            [
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent()
                ]);
        private var _achievementInvSet:Vector.<Vector.<AchievementInventory>>  =  Vector.<Vector.<AchievementInventory>>(
            [
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>()
                ]);

        // 達成済みのレコード
        private var _finPageNumSet:Vector.<int> = Vector.<int>([0,0,0,0,0,0]); // 今いるページのセット
        private var _finCounterSet:Vector.<int> = Vector.<int>([0,0,0,0,0,0]); // 要素数
        private var _finContainerSet:Vector.<UIComponent>  =  Vector.<UIComponent>(
            [
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent()
                ]);
        private var _finAchievementInvSet:Vector.<Vector.<AchievementInventory>>  =  Vector.<Vector.<AchievementInventory>>(
            [
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>(),
                new Vector.<AchievementInventory>()
                ]);

        // 継続中、達成済み合わせたセット
        private var _pageNumStateSet:Vector.<Vector.<int>> = Vector.<Vector.<int>>([_pageNumSet,_finPageNumSet]);
        private var _counterStateSet:Vector.<Vector.<int>> = Vector.<Vector.<int>>([_counterSet,_finCounterSet]);
        private var _containerStateSet:Vector.<Vector.<UIComponent>> = Vector.<Vector.<UIComponent>>([_containerSet,_finContainerSet]);
        private var _achievementInvStateSet:Vector.<Vector.<Vector.<AchievementInventory>>> = Vector.<Vector.<Vector.<AchievementInventory>>>([ _achievementInvSet,_finAchievementInvSet]);

        private var _achievementSceneDic:Dictionary = new Dictionary(); // アチーブメントシーンのキャッシュ
        private var _achievementInfoScene:AchievementInfoScene = new AchievementInfoScene();

        private var _selectBox:KindSelectComboBox = new KindSelectComboBox();

        private var _pageNum:Label = new Label();

        private var _selectIndex:int = 0;

        private static const _PAGE_LABEL_X:int = 320;
        private static const _PAGE_LABEL_Y:int = 328;
        private static const _PAGE_LABEL_W:int = 24;
        private static const _PAGE_LABEL_H:int = 20;

        private static const _ACHIEVEMENT_LABEL_X:int = 432;
        private static const _ACHIEVEMENT_LABEL_Y:int = 50;
        private static const _ACHIEVEMENT_LABEL_W:int = 80;
        private static const _ACHIEVEMENT_LABEL_H:int = 32;


        private static const PAGE_MAX:int = 16;
        private static const ACHIEVEMENT_Y:int = 63;
        private static const ACHIEVEMENT_W:int = 450;
        private static const ACHIEVEMENT_H:int = 16;

        private static const _ACHIEVEMENT_INFO_H:int = 340;

        private var _bg:AchievementListImage;


        // コンテナを取る
        public static function get instance():AchievementListContainer
        {
            if (__instance == null)
            {
                __instance = new AchievementListContainer();
            }
            return __instance;
        }

        public function AchievementListContainer()
        {
            _pageNum.x = _PAGE_LABEL_X;
            _pageNum.y = _PAGE_LABEL_Y;
            _pageNum.height = _PAGE_LABEL_H;
            _pageNum.width = _PAGE_LABEL_W;
            addChild(_pageNum);

            _selectBox.addEventListener(ListEvent.CHANGE, changeTypeHandler);
            addChild(_selectBox);

            _achievementInfoScene.y = _ACHIEVEMENT_INFO_H;
            addChild(_achievementInfoScene);

            updateList();

            setTab(TAB_ALL);
        }

        // 更新
        public static function update():void
        {
            if (__instance != null)
            {
                __instance.updateAchievementSceneDic();
                __instance.updateList();
                __instance.resetPage();
                __instance.updatePosition();
                __instance.pageNumUpdate();
                __instance.setTab(__instance.currentTab,true);
            }
        }

        // AchievementSceneDicを更新
        public function updateAchievementSceneDic():void
        {
            for ( var key:* in _achievementSceneDic )
            {
                if ( _achievementSceneDic[key]) {
                    var state:int = _achievementSceneDic[key].achievementInv.state;
                    if (state == Const.ACHIEVEMENT_STATE_FINISH || state == Const.ACHIEVEMENT_STATE_FAILED) {
                        RemoveChild.apply(_achievementSceneDic[key]);
                        _achievementSceneDic[key] = null;
                        delete _achievementSceneDic[key];
                    }
                }
            }
        }

        // コンテナのクリップを並べ直す
        private function updatePosition():void
        {
            // タブごとに並べ直す
            for(var j:int = 0; j < TAB_SIZE; j++)
            {
                var len:int = _achievementInvStateSet[_currentState][j].length;
                for(var i:int = 0; i < len; i++){
                    setPosition(i, getAchivementScene(_achievementInvStateSet[_currentState][j][i]),j);
                }
                // すべての場合、他のタブの処理を行う必要はない
                if (_currentTab==TAB_ALL) {
                    break;
                }
            }

        }

        // クリップを正しい位置に置く
        private function setPosition(i:int, bs:BaseScene, tabType:int):void
        {
            var pageNum:int = int(i/PAGE_MAX);
            var pos:int = i%PAGE_MAX;

            // 現在のページなら
            if(_pageNumStateSet[_currentState][tabType] == pageNum)
            {
                bs.y = ACHIEVEMENT_Y + pos*ACHIEVEMENT_H;
                bs.addEventListener(MouseEvent.CLICK,achievementClickHandler);
                _containerStateSet[_currentState][tabType].addChild(bs);
            }else{
                RemoveChild.apply(bs);
            }

        }

        public function resetPage():void
        {
            if ((currentPage()) > 1)
            {
                _pageNumStateSet[_currentState][_currentTab] = 0;
                updatePosition();
                pageNumUpdate();
            }
        }

        public function nextPage():void
        {
            if ((currentPage()) < currentPageNum())
            {
                _pageNumStateSet[_currentState][_currentTab] = _pageNumStateSet[_currentState][_currentTab] +1;
                updatePosition();
                pageNumUpdate();
            }
        }

        public function prevPage():void
        {
            if ((currentPage()) > 1)
            {
                _pageNumStateSet[_currentState][_currentTab] = _pageNumStateSet[_currentState][_currentTab] -1;
                updatePosition();
                pageNumUpdate();
            }
        }


        private function resetItems():void
        {
            for(var j:int = 0; j < TAB_SIZE; j++){
                RemoveChild.apply(_containerStateSet[STATE_START][j]);
                RemoveChild.apply(_containerStateSet[STATE_FINISH][j]);
            }
        }
        // 表示タブをセット
        public function setTab(tabType:int,isReset:Boolean=false):void
        {
            _currentTab = tabType;
            resetAllStateImageSelectFlag();
            _achievementInfoScene.labelUpdate();
            updatePosition();

            if (isReset) {
                resetItems();
            }

            // セットされたタブだけ表示する
            for(var j:int = 0; j < TAB_SIZE; j++){
                if (j == _currentTab)
                {
                    if ( _currentState == STATE_START ) {
                        addChild(_containerStateSet[STATE_START][j]);
                        RemoveChild.apply(_containerStateSet[STATE_FINISH][j]);
                    } else {
                        addChild(_containerStateSet[STATE_FINISH][j]);
                        RemoveChild.apply(_containerStateSet[STATE_START][j]);
                    }
                }else{
                    RemoveChild.apply(_containerStateSet[STATE_START][j]);
                    RemoveChild.apply(_containerStateSet[STATE_FINISH][j]);
                }
            }
            pageNumUpdate();

        }

        // 表示タブをセット
        public function setState(stateType:int,isReset:Boolean=false):void
        {
            _currentState = stateType;
            resetAllStateImageSelectFlag();
            _achievementInfoScene.labelUpdate();
            updatePosition();

            if (isReset) {
                resetItems();
            }

            // セットされたタブだけ表示する
            for(var j:int = 0; j < TAB_SIZE; j++){
                if (j == _currentTab)
                {
                    if ( stateType == STATE_START ) {
                        addChild(_containerStateSet[STATE_START][j]);
                        RemoveChild.apply(_containerStateSet[STATE_FINISH][j]);
                    } else {
                        addChild(_containerStateSet[STATE_FINISH][j]);
                        RemoveChild.apply(_containerStateSet[STATE_START][j]);
                    }
                }else{
                    RemoveChild.apply(_containerStateSet[STATE_START][j])
                    RemoveChild.apply(_containerStateSet[STATE_FINISH][j])
                }
            }
            pageNumUpdate();

        }

        private function pageNumUpdate():void
        {
            _pageNum.text = currentPage()+"/"+Math.max(currentPageNum(),1);
            if(_bg != null)
            {
                _bg.pageButtonVisible(Math.max(currentPageNum(),1),currentPage());
            }
        }

        public function currentPageNum():int
        {
            return int((_achievementInvStateSet[_currentState][_currentTab].length-1)/(PAGE_MAX)+ 1);
        }
        public function currentPage():int
        {
            return (_pageNumStateSet[_currentState][_currentTab]+1)
        }


        // アチーブメントリストを表示リストとして再構成
        private function updateList():void
        {
            // タブごとのアチーブメントリストセットを空に戻す
            for(var j:int = 0; j < TAB_SIZE; j++){
                if (_achievementInvSet[j].length > 0)
                {
                    _achievementInvSet[j].length = 0;
                }
                if (_finAchievementInvSet[j].length > 0)
                {
                    _finAchievementInvSet[j].length = 0;
                }
            }

            // ソートを行うため、ALLタブの分は一度配列に入れる
            var allAchievementSet:Array = new Array();
            var allFinAchievementSet:Array = new Array();

            var f_set:Object = AchievementInventory.items;
            for (var key:Object in f_set)
            {
                if (convertTabType(f_set[key].achievement.kind) != -1&&f_set[key].achievement.checkTimeOver())
                {
                    if ( f_set[key].state == Const.ACHIEVEMENT_STATE_START) {
                        allAchievementSet.push(f_set[key]);
                        _achievementInvSet[convertTabType(f_set[key].achievement.kind)].push(f_set[key]);
                    } else {
                        allFinAchievementSet.push(f_set[key]);
                        _finAchievementInvSet[convertTabType(f_set[key].achievement.kind)].push(f_set[key]);
                    }
                }
                else if (!(f_set[key].achievement.checkTimeOver()))
                {
                    if (_achievementSceneDic[f_set[key].achievement.id] != null){_achievementSceneDic[f_set[key].achievement.id].visible = false}
                }
            }

            // ALLタブに入れる配列をソートし、InvSetに入れる
            allAchievementSet.sortOn(["achievementKind","achievementId"],[Array.NUMERIC,Array.NUMERIC]);
            allFinAchievementSet.sortOn(["achievementKind","achievementId"],[Array.NUMERIC,Array.NUMERIC]);
            allAchievementSet.forEach(function(item:*, index:int, array:Array):void{_achievementInvSet[TAB_ALL].push(item)});
            allFinAchievementSet.forEach(function(item:*, index:int, array:Array):void{_finAchievementInvSet[TAB_ALL].push(item)});
        }

        // ソート用チェック関数
        private function aInvOrderCheck(itemA:AchievementInventory,itemB:AchievementInventory):int
        {
            return ( int(itemA.achievement.kind > itemB.achievement.kind) - int(itemA.achievement.kind < itemB.achievement.kind)  );
        }

        // インベントリタイプからタブタイプに変換
        private function convertTabType(fType:int):int
        {
//            log.writeLog(log.LV_WARN, this, "convertTabType fType", fType);

            var ret:int;
            switch (fType)
            {
            case Const.ACHIEVEMENT_TYPE_AVATAR:
                ret = TAB_AVATAR;
                break;
            case Const.ACHIEVEMENT_TYPE_DUEL:
                ret = TAB_DUEL;
                break;
            case Const.ACHIEVEMENT_TYPE_QUEST:
                ret = TAB_QUEST;
                break;
            case Const.ACHIEVEMENT_TYPE_FRIEND:
                ret = TAB_FRIENDS;
                break;
            case Const.ACHIEVEMENT_TYPE_EVENT:
                ret = TAB_EVENT;
                break;
            default:
                ret = -1;
            }
            return ret;
        }

        private function changeTypeHandler(e:ListEvent):void
        {
            setTab(_selectBox.selectedIndex);

            // タイトル背景を変更
            _bg.setRecordNameBG(_selectBox.selectedIndex);
        }


        private function getAchivementScene(aInv:AchievementInventory):AchievementScene
        {
            if (_achievementSceneDic[aInv.achievement.id]==null)
            {
                _achievementSceneDic[aInv.achievement.id] = new AchievementScene(aInv);
            }
            _achievementSceneDic[aInv.achievement.id].statusUpdate();

            return _achievementSceneDic[aInv.achievement.id];
        }

        // フレンド人数アップデート
        private function updateAchievementMaxHandler(e:Event):void
        {
            pageNumUpdate();
        }

        public function set bg(bg:AchievementListImage):void
        {
            _bg = bg;
        }

        private function achievementClickHandler(e:MouseEvent):void
        {
            log.writeLog(log.LV_WARN, this, "achievementClickHandler",e.currentTarget);
            // 先に選択済みのものを解除
            resetAllStateImageSelectFlag();

            // 今回選択したものを選択状態に変更
            e.currentTarget.setStateImageSelectFlag(true);

            // 情報を更新
            _achievementInfoScene.labelUpdate(e.currentTarget.achievementInv);

            // ALLカテゴリの場合、背景切り替え
            if (_currentTab == TAB_ALL ) {
                _bg.setRecordNameBG(e.currentTarget.achievementInv.achievement.kind);
            }
        }

        private function resetAllStateImageSelectFlag():void
        {
            // 現在表示中のAchievementSceneの選択状態を解除
            var len:int = _achievementInvStateSet[_currentState][_currentTab].length;
            for(var i:int = 0; i < len; i++){
                getAchivementScene(_achievementInvStateSet[_currentState][_currentTab][i]).setStateImageSelectFlag(false);
            }
        }

        public function get currentTab():int
        {
            return _currentTab;
        }


    }
}

import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.filters.GlowFilter;
import flash.geom.*;
import flash.text.*;

import mx.core.UIComponent;
import mx.controls.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;

import view.scene.BaseScene;
import view.scene.common.*;
import view.image.common.*;
import view.*;
import view.utils.*;

import model.*;
import model.events.*;
import model.utils.*;

import controller.*;


/**
 * アチーブメント情報
 *
 */
class AchievementScene extends BaseScene
{

    CONFIG::LOCALE_JP
    private static const _TRANS_MSG1:String = "有効期限:";
    CONFIG::LOCALE_EN
    private static const _TRANS_MSG1:String = "Expiration date:";
    CONFIG::LOCALE_TCN
    private static const _TRANS_MSG1:String = "有效期限:";
    CONFIG::LOCALE_SCN
    private static const _TRANS_MSG1:String = "到期时间:";
    CONFIG::LOCALE_KR
    private static const _TRANS_MSG1:String = "有効期限:";
    CONFIG::LOCALE_FR
    private static const _TRANS_MSG1:String = "Date d'expiration:";
    CONFIG::LOCALE_ID
    private static const _TRANS_MSG1:String = "有効期限:";
    CONFIG::LOCALE_TH
    private static const _TRANS_MSG1:String = "เวลาหมดอายุ:";

//    private var _stateImage:AchievementCrownImage = new AchievementCrownImage();
    private var _stateImage:AchievementIconImage;

    private var _ct:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
    private var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーン元にに

    private var _container:UIComponent;
    private var _name:Label = new Label();
    private var _endTime:Label = new Label();
    private var _count:Label = new Label();

    private var _achievementInv:AchievementInventory;
//     private var _bg:Shape = new Shape();


    private static const _X:int = 16;
    private static const _NAME_X:int = 34;
    private static const _NAME_Y:int = 0;           // 名称のY
    private static const _NAME_H:int = 28;           // カードの初期位置Y
    private static const _NAME_W:int = 355;           // カードの初期位置Y

    private static const _END_TIME_X:int = 415;

    public function AchievementScene(aInv:AchievementInventory)
    {
        _achievementInv = aInv;
        labelUpdate();
        statusUpdate();
    }

    private function labelUpdate():void
    {
//        addChild(_bg);
        x =_X;
        _name.x = _NAME_X;
        _endTime.y = _name.y = _NAME_Y;
        _endTime.width = _name.width = _NAME_W;
        _endTime.height = _name.height = _NAME_H;
        _endTime.x =  _END_TIME_X;
        _name.setStyle("textSize",  11);
        _endTime.setStyle("textSize",  11);
        _name.htmlText = _achievementInv.achievement.caption;

        var setTimeStr:String = "";
        if (_achievementInv.achievement.endAtTimeStr != "") {
            setTimeStr = _achievementInv.achievement.endAtTimeStr;
        } else if (_achievementInv.endAtTimeStr != "") {
            setTimeStr = _achievementInv.endAtTimeStr;
        }
        if (setTimeStr != "") {
            if (_achievementInv.state == Const.ACHIEVEMENT_STATE_FAILED) {
                setTimeStr = '<font color="#FF0000">'+setTimeStr+'</font>';
            }
        } else {
            setTimeStr = "---";
        }
        _endTime.htmlText = _TRANS_MSG1+setTimeStr;

        if(_achievementInv.state == Const.ACHIEVEMENT_STATE_FAILED)
        {
            alpha = 0.3;
        }

        _stateImage = new AchievementIconImage(_achievementInv.achievement.kind);

        addChild(_name);
        addChild(_endTime)
    }


    public function statusUpdate():void
    {
        addChild(_stateImage);
    }

    public function get achievementInv():AchievementInventory
    {
        return _achievementInv;
    }

    public function setStateImageSelectFlag(flag:Boolean=false):void
    {
        _stateImage.setSelectMCVisible(flag);
    }

//     // 名前が全部はいるように調整
//     private function fontSizeAdjust(label:Label):void
//     {
//         var w:int = label.width;
//         label.validateNow();
//         while (label.textWidth > w-3)
//         {
//             label.validateNow();
//             label.setStyle("fontSize",  int(label.getStyle("fontSize"))-1);
//             label.setStyle("paddingTop",  int(label.getStyle("paddingTop"))+1);
//         }

//         if (int(label.getStyle("fontSize")) < 6)
//         {
//             label.setStyle("fontSize",  6);
//             label.setStyle("paddingTop",  6);
//         }
//     }



}

/**
 * アチーブメント情報
 *
 */
class AchievementInfoScene extends BaseScene
{

    CONFIG::LOCALE_JP
    private static const _TRANS_MSG1:String = "有効期限";
    CONFIG::LOCALE_EN
    private static const _TRANS_MSG1:String = "Expiration date";
    CONFIG::LOCALE_TCN
    private static const _TRANS_MSG1:String = "有效期限";
    CONFIG::LOCALE_SCN
    private static const _TRANS_MSG1:String = "到期时间:";
    CONFIG::LOCALE_KR
    private static const _TRANS_MSG1:String = "有効期限";
    CONFIG::LOCALE_FR
    private static const _TRANS_MSG1:String = "Date d'expiration";
    CONFIG::LOCALE_ID
    private static const _TRANS_MSG1:String = "有効期限";
    CONFIG::LOCALE_TH
    private static const _TRANS_MSG1:String = "เวลาหมดอายุ:";

    CONFIG::LOCALE_JP
    private static const _TRANS_MSG2:String = "達成コード:   __CODE_NUMBER__";
    CONFIG::LOCALE_EN
    private static const _TRANS_MSG2:String = "Accomplishment Code: __CODE_NUMBER__";
    CONFIG::LOCALE_TCN
    private static const _TRANS_MSG2:String = "達成代碼:   __CODE_NUMBER__";
    CONFIG::LOCALE_SCN
    private static const _TRANS_MSG2:String = "达成代码:   __CODE_NUMBER__";
    CONFIG::LOCALE_KR
    private static const _TRANS_MSG2:String = "Clear Code:   __CODE_NUMBER__";
    CONFIG::LOCALE_FR
    private static const _TRANS_MSG2:String = "Code Réalisation: __CODE_NUMBER__";
    CONFIG::LOCALE_ID
    private static const _TRANS_MSG2:String = "Accomplishment Code: __CODE_NUMBER__";
    CONFIG::LOCALE_TH
    private static const _TRANS_MSG2:String = "Accomplishment Code: __CODE_NUMBER__";

    private static const _NAME_SIZE:int = 18;
    private static const _LABEL_SIZE:int = 12;

    private static const _NAME_X:int = 40;
    private static const _NAME_Y:int = 8;
    private static const _NAME_W:int = 580;
    private static const _NAME_H:int = 30;

    private static const _LABEL_W:int = 278;
    private static const _LABEL_H:int = 20;

    private static const _END_TIME_X:int = 345;
    private static const _END_TIME_Y:int = 147;

    private static const _CLEAR_CODE_X:int = 20;
    private static const _CLEAR_CODE_Y:int = 147;

    private static const _CAPTIONS_X:int = 20;
    private static const _CAPTION_Y:int = 40;

    private static const _CAPTION_W:int = 600;
    private static const _CAPTION_H:int = 50;

    private static const _COND_NUM_MAX:int = 3;
    private static const _COND_NAME:int  = 0;
    private static const _COND_COUNT:int = 1;

    private static const _COND_LABEL_W:int = 597;
    private static const _COND_LABEL_H:int = 20;

    private static const _COND_X:int = 27;
    private static const _COND_Y:int = 83;
    private static const _COND_REF_X:int = 302;
    private static const _COND_REF_Y:int = 16;


    private var _container:UIComponent;

    private var _name:Label = new Label();        // 名称
    private var _endTempMess:Label = new Label(); // 有効期限ラベル
    private var _endTime:Label = new Label();     // 有効期限
    private var _clearCodeMess:Label = new Label(); // クリアコードラベル
    private var _clearCode:Label = new Label();     // クリアコード
    private var _explanation:TextField = new TextField(); //説明文

    private var _condSet:Vector.<Vector.<Label>> = Vector.<Vector.<Label>>(
        [
            new Vector.<Label>(),
            new Vector.<Label>(),
            new Vector.<Label>()
            ]);

    private var _achievementInv:AchievementInventory;

    public function AchievementInfoScene()
    {
        labelInit();
    }

    private function labelInit():void
    {
        _name.x = _NAME_X;
        _name.y = _NAME_Y;
        _name.width = _NAME_W;
        _name.height = _NAME_H;
        _name.setStyle("fontSize", _NAME_SIZE);
        _name.htmlText = "";

        _endTempMess.x = _END_TIME_X;
        _endTempMess.y = _END_TIME_Y;
        _endTempMess.width = _LABEL_W;
        _endTempMess.height = _LABEL_H;
        _endTempMess.setStyle("color", 0xFFFFFF);
        _endTempMess.setStyle("textAlign", "left");
        _endTempMess.setStyle("fontSize", _LABEL_SIZE);
        _endTempMess.text = "";

        _clearCodeMess.x = _CLEAR_CODE_X;
        _clearCodeMess.y = _END_TIME_Y;
        _clearCodeMess.width = _LABEL_W;
        _clearCodeMess.height = _LABEL_H;
        _clearCodeMess.setStyle("color", 0xFFFF00);
        _clearCodeMess.setStyle("textAlign", "left");
        _clearCodeMess.setStyle("fontSize", _LABEL_SIZE);
        _clearCodeMess.text = "";

        _endTime.x = _END_TIME_X;
        _endTime.y = _END_TIME_Y;
        _endTime.width = _LABEL_W;
        _endTime.height = _LABEL_H;
        _endTime.setStyle("color", 0xFFFFFF);
        _endTime.setStyle("textAlign", "right");
        _endTime.setStyle("fontSize", _LABEL_SIZE);
        _endTime.text = "";

        // _explanation のみ TextField
        var format:TextFormat = new TextFormat();
        format.leading = 4;// 行間の垂直の行送り
        format.font = "_ゴシック";// フォント名
        format.letterSpacing = 1;// 文字間スペースの量(単位:ピクセル)
        _explanation.defaultTextFormat = format;
        _explanation.x = _CAPTIONS_X;
        _explanation.y = _CAPTION_Y;
        _explanation.width = _CAPTION_W;
        _explanation.height = _CAPTION_H;
        _explanation.textColor = 0xFFFFFF;
        _explanation.mouseEnabled = false;
        _explanation.wordWrap = true;
        _explanation.multiline = true;
        _explanation.alpha = 0.5;
        _explanation.htmlText = "";

        for (var i:int=0;i<_COND_NUM_MAX;i++) {

            var _cond:Label = new Label();
            _cond.x = _COND_X;
            _cond.y = _COND_Y + (_COND_REF_Y * i);
            _cond.width = _COND_LABEL_W;
            _cond.height = _COND_LABEL_H;
            _cond.setStyle("color", 0xFFFFFF);
            _cond.setStyle("textAlign", "left");
            _cond.setStyle("fontSize", _LABEL_SIZE);
            _cond.text = "";
            _condSet[i].push(_cond);

            var _condCnt:Label = new Label();
            _condCnt.x = _COND_X;
            _condCnt.y = _COND_Y + (_COND_REF_Y * i);
            _condCnt.width = _COND_LABEL_W;
            _condCnt.height = _COND_LABEL_H;
            _condCnt.setStyle("color", 0xFFFFFF);
            _condCnt.setStyle("textAlign", "right");
            _condCnt.setStyle("fontSize", _LABEL_SIZE);
            _condCnt.text = "";
            _condSet[i].push(_condCnt);

            addChild(_condSet[i][_COND_NAME]);
            addChild(_condSet[i][_COND_COUNT]);
        }

        addChild(_name);
        addChild(_endTempMess);
        addChild(_clearCodeMess);
        addChild(_endTime);
        addChild(_explanation);
    }

    private function labelReset():void
    {
        _name.htmlText = "";
        _endTempMess.text = "";
        _clearCodeMess.text = "";
        _endTime.text = "";
        _explanation.htmlText = "";
        for (var i:int=0;i<_COND_NUM_MAX;i++) {
            _condSet[i][_COND_NAME].text = "";
            _condSet[i][_COND_COUNT].text = "";
            _condSet[i][_COND_COUNT].setStyle("color", 0xFFFFFF);
        }
    }

    public function labelUpdate(ai:AchievementInventory=null):void
    {
        _achievementInv = ai;
        labelReset();

        if (ai) {
            // タイトル
            _name.htmlText = "<b>" + ai.achievement.caption + "</b>";
            // 説明
            if (ai.achievement.explanation) {
                _explanation.htmlText = ai.achievement.explanation;
            }

            // 有効期限
            _endTempMess.text = _TRANS_MSG1;
            if (_achievementInv.achievement.endAtTimeStr != "") {
                _endTime.text = _achievementInv.achievement.endAtTimeStr;
            } else if (_achievementInv.endAtTimeStr != "") {
                _endTime.text = _achievementInv.endAtTimeStr;
            } else {
                _endTime.text = "---";
            }
            if (_achievementInv.state == Const.ACHIEVEMENT_STATE_FAILED) {
                _endTime.setStyle("color", 0xFF0000);
            } else {
                _endTime.setStyle("color", 0xFFFFFF);
            }

            // 達成条件
            if ( _achievementInv.achievement.successCond > 0 ) {
                setCondInfoLabel();
            }
            if (_achievementInv.code !="")
            {
                _clearCodeMess.text = _TRANS_MSG2.replace("__CODE_NUMBER__", _achievementInv.code);
            }else{
                _clearCodeMess.text = ""
            }

        }
    }

    private function setCondInfoLabel():void
    {
        var pre:int = 0;
        var cond:int = 0;
        var cInfo:Array;
        var progress:Array = _achievementInv.progress.split(",");
        if ( _achievementInv.achievement.isMultiCond() ) {
            var cInfos:Array = _achievementInv.achievement.condInfo.split("_");
            var name:String = "";
            var cnt:uint = 0;
            for ( var i:int = 0; i < cInfos.length; i++ ) {
                cInfo = cInfos[i].split(",");
                pre  = (progress[i] != null) ? progress[i] : 0;
                cond = cInfo[1];

                if (cInfos.length > _condSet.length && pre >= cond && (cInfos.length - _condSet.length + cnt > i)) continue;

                if (cond < Achievement.NON_CLEAR_PROGRESS_NO) {
                    if ( pre >= cond ) {
                        pre = cond;
                        _condSet[cnt][_COND_COUNT].setStyle("color", 0xFF0000);
                    }
                    _condSet[cnt][_COND_NAME].text  = makeCondNameMsg(cInfo[0]);
                    _condSet[cnt][_COND_COUNT].text = pre+"/"+cond;
                } else {
                    _condSet[cnt][_COND_COUNT].text = pre.toString();
                }
                cnt += 1;
                if (cnt >= _condSet.length) break;
            }
        } else {
            pre  = (progress[0] != null) ? progress[0] : 0;
            cond = _achievementInv.achievement.successCond;
            if (cond < Achievement.NON_CLEAR_PROGRESS_NO) {
                if ( pre >= cond ) {
                    pre = cond;
                    _condSet[0][_COND_COUNT].setStyle("color", 0xFF0000);
                }

                cInfo = _achievementInv.achievement.condInfo.split(",");
                _condSet[0][_COND_NAME].text  = makeCondNameMsg(cInfo[0]);
                _condSet[0][_COND_COUNT].text = pre+"/"+cond;
            } else {
                _condSet[0][_COND_COUNT].text = pre.toString();
            }
        }
    }

    private function getItemName(id:int=0):String
    {
        var name:String = "";
        if ( _achievementInv.achievement.isRegCond() ) {
            switch (_achievementInv.achievement.condType)
            {
            case Achievement.COND_TYPE_QUEST_CLEAR:
            case Achievement.COND_TYPE_QUEST_NO_CLEAR:
                name = Quest.ID(id).name;
                break;
            case Achievement.COND_TYPE_ITEM_NUM:
            case Achievement.COND_TYPE_ITEM_SET_CALC:
                name = AvatarItem.ID(id).name;
                break;
            case Achievement.COND_TYPE_CHARA_CARD:
            case Achievement.COND_TYPE_CHARA_CARD_DECK:
                var cc:CharaCard = CharaCard.ID(id);
                name = "Lv"+ cc.level + cc.name;
                break;
            case Achievement.COND_TYPE_GET_PART:
                name = AvatarPart.ID(id).name;
                break;
            default:
            }
        }
        return name;
    }
    private function getCondMsg(name:String):String
    {
        return _achievementInv.achievement.getCondTypeMsg(name);
    }
    private function makeCondNameMsg(id:int=0):String
    {
        return getCondMsg(getItemName(id));
    }

    public function get achievementInv():AchievementInventory
    {
        return _achievementInv;
    }


}


/**
 * 種類選択用コンボボックス
 *
 */
class KindSelectComboBox extends ComboBox
{
    private static const _X:int = 480;
    private static const _Y:int = 27;
    private static const _WIDTH:int = 160;
    private static const _HEIGHT:int = 18;

    public function KindSelectComboBox():void
    {
        dataProvider = ["ALL", "Avatar", "Duel", "Quest", "Event", "Friend"];
        dropdownWidth = _WIDTH;
        x = _X;
        y = _Y;
        width  = _WIDTH;
        height = _HEIGHT;
        rowCount = dataProvider.length;
    }
}
