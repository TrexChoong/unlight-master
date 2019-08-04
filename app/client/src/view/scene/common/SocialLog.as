package view.scene.common
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.*;

    import flash.utils.Dictionary;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;
    import flash.ui.Keyboard;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.events.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.AvatarItemEvent;

    import view.image.common.*;
    import view.scene.common.*;

    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;

    import controller.QuestCtrl;

    import model.QuestLog;
    import model.events.QuestLogEvent;

    /**
     * SocialLogの表示クラス
     *
     */

    public class SocialLog extends BaseScene
    {
        // 種類のタブ
        private var _tabNavigator:TabNavigator = new TabNavigator();

        // ログのリスト
        private var _logList:TileList = new TileList();

        // 種別ごとのリスト内データ
        private var _dpList:Array = []

        // 描画コンテナ
        private var _container:UIComponent = new UIComponent();

        // ベースとなるパネル
        private var _basePanel:SocialLogPanel = new SocialLogPanel();

        // テキストインプット
        private var _sendLog:TextInput = new TextInput();
        // sendボタン
        private var _sendButton:SocialLogButton = new SocialLogButton();

        // 会話タブ
        private var _tabAll:SocialLogTab = new SocialLogTab("ALL");
        private var _tabQuest:SocialLogTab = new SocialLogTab("QUEST");
        private var _tabSystem:SocialLogTab = new SocialLogTab("SYSTEM");

        // 位置定数
        private static const _TAB_ALL_X:int = 120;
        private static const _TAB_ALL_Y:int = 52;
        private static const _TAB_QUEST_X:int = 200;
        private static const _TAB_QUEST_Y:int = 52;
        private static const _TAB_SYSTEM_X:int = 280;
        private static const _TAB_SYSTEM_Y:int = 52;

        // タブ設定
        public static const TAB_ALL:int = 0;
        public static const TAB_QUEST:int = 1;
        public static const TAB_SYSTEM:int = 2;
        public static const TAB_MAX:int = 3;

        // クエストのコントローラ
        private var _ctrl:QuestCtrl = QuestCtrl.instance;

        // 現在の表示ページ
        private var _page:int;

        /**
         * コンストラクタ
         *
         */
        public function SocialLog()
        {
            _container.addChild(_basePanel);
            _container.x = 230;
            _container.y = 140;
        }

        // 初期化
        public override function init():void
        {
            var itemNum:int = 0; // アイテムの個数

            // sendLogの設定
            _sendLog.x = 32;
            _sendLog.y = 23;
            _sendLog.width = 304;
            _sendLog.height = 20;
            _sendLog.maxChars = 32;
            _container.addChild(_sendLog);
            _sendLog.addEventListener(FlexEvent.ENTER, enterMessageHandler);

            _sendButton.x = 341;
            _sendButton.y = 23;
            _container.addChild(_sendButton);
            _sendButton.addEventListener(MouseEvent.CLICK, sendMessageHandler);

            // タブの設定
            _tabAll.x = _TAB_ALL_X;
            _tabAll.y = _TAB_ALL_Y;
            _tabQuest.x = _TAB_QUEST_X;
            _tabQuest.y = _TAB_QUEST_Y;
            _tabSystem.x = _TAB_SYSTEM_X;
            _tabSystem.y = _TAB_SYSTEM_Y;

            _container.addChild(_tabAll);
            _container.addChild(_tabQuest);
            _container.addChild(_tabSystem);

            _tabAll.addEventListener(MouseEvent.CLICK, setTabAllHandler);
            _tabQuest.addEventListener(MouseEvent.CLICK, setTabQuestHandler);
            _tabSystem.addEventListener(MouseEvent.CLICK, setTabSystemHandler);

            // データを空っぽにする
            _dpList = [];

            // データを格納するタブを作成する
            for(var i:int = 0; i < TAB_MAX; i++)
            {
                var dp:Array = [];
                _dpList.push(dp);
            }

            _logList.styleName = "SocialLogBase";
            _logList.columnWidth = 330;
            _logList.rowHeight= 70;
            _logList.columnCount = 2;
            _logList.rowCount = 1;
            _logList.width = 349;
            _logList.height = 120;
            _logList.dataProvider = _dpList[TAB_ALL];

            _logList.itemRenderer = new ClassFactory(LogListRenderer);
            _logList.x = 17;
            _logList.y = 72;

            _basePanel.addChild(_logList);

//            _ctrl.requestPageInfo(0);
            _ctrl.addEventListener(QuestLogEvent.UPDATE, updateHandler);
            _ctrl.addEventListener(QuestLogEvent.PAGE_UPDATE, updatePageHandler);

            // ログデータを作成する
            initLogData();

            _tabNavigator.alpha = 0;
            new BeTweenAS3Thread(_tabNavigator, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ).start();

            addChild(_container);
        }

        // インベントリからデータを生成する
        private function initLogData():void
        {
            _page = 0;
            _ctrl.requestPageInfo(_page)
        }

        // データがアップデートされる
        private function updateHandler(e:QuestLogEvent):void
        {
            new UpdateLogThread(QuestLog.ID(e.id), this).start();
        }

        // ページがアップデートされる
        private function updatePageHandler(e:QuestLogEvent):void
        {
            updatePage();
        }

        // ページを更新する
        private function updatePage():void
        {
            var sExec:SerialExecutor = new SerialExecutor();
            var a:Array = QuestLog.getPageIDs(_page);

           for(var i:int = 0; i < a.length; i++){
               sExec.addThread(new UpdateLogThread(QuestLog.ID(a[i]), this));
           }
           sExec.start();
        }

        // ログを書く
        private function writeLog():void
        {

        }


        // 後処理
        public override function final():void
        {
            _container.removeChild(_tabAll);
            _container.removeChild(_tabQuest);
            _container.removeChild(_tabSystem);

            removeChild(_container);
        }

        // タブ選択時のハンドラ
        private function setTabAllHandler(e:MouseEvent):void
        {
            _logList.dataProvider = _dpList[TAB_ALL];
        }

        // タブ選択時のハンドラ
        private function setTabQuestHandler(e:MouseEvent):void
        {
            _logList.dataProvider = _dpList[TAB_QUEST];
        }

        // タブ選択時のハンドラ
        private function setTabSystemHandler(e:MouseEvent):void
        {
            _logList.dataProvider = _dpList[TAB_SYSTEM];
        }

        // メッセージ送信ハンドラ
        private function enterMessageHandler(e:FlexEvent):void
        {
            sendMessages();
        }

        // メッセージ送信ハンドラ
        private function sendMessageHandler(e:MouseEvent):void
        {
            sendMessages();
        }

        // ログの内容を送信する
        private function sendMessages():void
        {
            log.writeLog(log.LV_INFO, this, "sendLog", _sendLog.text);

            if(_sendLog.text != "")
            {
                _logList.visible = false;

                // ここでメッセージ送信
//                insertLogClip(new SocialLogClip(SocialLogClip.LOG_SYSTEM, _sendLog.text));

                _logList.dataProvider = _dpList[TAB_ALL];
                _sendLog.text = "";

                _logList.visible = true;
            }
        }

        // 新しいログを作成する
        public function insertLogClip(slc:SocialLogClip):void
        {
//             _dpList[slc.mode].unshift( {logClip:slc} );

//              if(slc.mode != SocialLogClip.LOG_ALL)
//              {
                  _dpList[TAB_ALL].unshift( {logClip:slc} );
//             }
            _logList.dataProvider = _dpList[TAB_ALL];
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage, at);
        }
    }

}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import org.libspark.thread.Thread;

import model.QuestLog;

import view.BaseShowThread;
import view.IViewThread;
import view.scene.common.*;


class ShowThread extends BaseShowThread
{
    public function ShowThread(view:IViewThread, stage:DisplayObjectContainer, at:int)
    {
        super(view, stage);
    }

    protected override function run():void
    {
        next(close);
    }
}


class UpdateLogThread extends Thread
{
    private var _m:QuestLog;
    private var _sl:SocialLog;
    public function UpdateLogThread(m:QuestLog, sl:SocialLog)
    {
        _m = m;
        _sl = sl;
    }

    protected override function run():void
    {
        log.writeLog(log.LV_INFO, this, "run?");
        if (_m.loaded == false)
        {
            _m.wait();
        }
        next(insertClip);
    }
    private function insertClip():void
    {
        _sl.insertLogClip(new SocialLogClip(_m));
    }



}
