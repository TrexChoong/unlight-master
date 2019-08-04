package view.scene.log
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

    import model.*;
    import model.utils.ClientLog;
    import view.scene.BaseScene;
    import view.utils.*;
    import view.LogListView;
    import view.image.log.*;

    public class LogListContainer extends UIComponent
    {
        private static var __instance:LogListContainer;

        // タブタイプ
        private static const TAB_ALL:int                 = 0;      // 全記録
        private static const TAB_GOT_EXCH_CARD:int       = 1;      // 合成の記録
        private static const TAB_GOT_LOT:int             = 2;      // クジの記録
        private static const TAB_GOT_LOGIN:int           = 3;      // ログインボーナスの記録
        private static const TAB_BOUGHT_ITEM:int         = 4;      // アイテム購入の記録
        private static const TAB_BOUGHT_RMITEM:int       = 5;      // リアルマネーアイテム購入の記録
        private static const TAB_GOT_ITEM:int            = 6;      // アイテム取得の記録
        private static const TAB_GOT_LEVEL:int           = 7;      // レベルアップの記録
        private static const TAB_GOT_SLOT_CARD:int       = 8;      // スロットカード取得の記録
        private static const TAB_GOT_CHARA_CARD:int      = 9;      // キャラカード取得の記録
        private static const TAB_GOT_AVATAR_PART:int     = 10;     // アバターパーツ取得の記録
        private static const TAB_SUCC_ACHIEVEMENT:int    = 11;     // アチーブメント達成の記録
        private static const TAB_SUCC_INVITE:int         = 12;     // 招待成功の記録
        private static const TAB_VANISH_ITEM:int         = 13;     // アイテム消滅の記録
        private static const TAB_VANISH_CARD:int         = 14;     // カード消滅の記録

        private static const TAB_TYPE_NUM:int            = 15;     // タイプの合計数

        private var _currentTab:int  = 0;
        private var _currentPage:int = 0;

        private var _containerSet:Vector.<UIComponent>  =  Vector.<UIComponent>(
            [
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent(),
                new UIComponent()
                ]);

        private var _logListSet:Array = []; /* of Label */
        private var _pageNum:Label = new Label();

        private static const _PAGE_LABEL_X:int = 255;
        private static const _PAGE_LABEL_Y:int = 385;
        private static const _PAGE_LABEL_W:int = 80;
        private static const _PAGE_LABEL_H:int = 20;

        private static const _LOG_LABEL_X:int = 50;
        private static const _LOG_LABEL_Y:int = 55;
        private static const _LOG_LABEL_W:int = 400;
        private static const _LOG_LABEL_H:int = 16;

        private static const PAGE_MAX:int = 20;
        private static const LOG_Y:int = 72;
        private static const LOG_W:int = 450;
        private static const LOG_H:int = 16;


        private var _bg:BG;


        // コンテナを取る
        public static function get instance():LogListContainer
        {
            if (__instance == null)
            {
                __instance = new LogListContainer();
            }
            return __instance;
        }

        public function LogListContainer()
        {
            _currentTab = 0;
            _currentPage = 0;
            _pageNum.x = _PAGE_LABEL_X;
            _pageNum.y = _PAGE_LABEL_Y;
            _pageNum.height = _PAGE_LABEL_H;
            _pageNum.width = _PAGE_LABEL_W;
            addChild(_pageNum);

            for ( var i:int = 0; i < PAGE_MAX; i++ ) {
                var label:Label = new Label();
                label.x = _LOG_LABEL_X;
                label.y = _LOG_LABEL_Y + ( _LOG_LABEL_H * i );
                label.width = _LOG_LABEL_W;
                label.height = _LOG_LABEL_H;

                _logListSet.push(label);
                addChild( _logListSet[i] );
            }

            setTab(TAB_ALL);
            log.writeLog(log.LV_INFO, "### [LogListContainer] LogListContainer end.");
        }

        // 更新
        public static function update():void
        {
            if (__instance != null)
            {
                __instance.updateList();
                __instance.pageNumUpdate();
            }
        }

        public function nextPage():void
        {
            if ((currentPage()) < currentPageNum())
            {
                _currentPage = _currentPage+1;
                updateList();
                pageNumUpdate();
            }
        }

        public function prevPage():void
        {
            if ((currentPage()) > 1)
            {
                _currentPage = _currentPage-1;
                updateList();
                pageNumUpdate();
            }
        }

        // 表示タブをセット
        public function setTab(tabType:int):void
        {
            log.writeLog(log.LV_INFO, this, "### setTab.", tabType);
            _currentTab = tabType;
            _currentPage = 0;
            log.writeLog(log.LV_INFO, this, "### setTab 1.");
            updateList();
            log.writeLog(log.LV_INFO, this, "### setTab 2.");
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
            return int((ClientLog.getLogNum(_currentTab)-1)/(PAGE_MAX)+ 1);
        }

        public function currentPage():int
        {
            return _currentPage+1;
        }


        // ログリストを表示リストとして再構成
        private function updateList():void
        {
            var i:int;
            var start:int = _currentPage * PAGE_MAX;
            var end:int = start + PAGE_MAX;
            log.writeLog(log.LV_INFO, "### updateList.", _currentTab);
            var logList:Array = ClientLog.read( _currentTab, start, end );
            log.writeLog(log.LV_INFO, "### updateList 1.");
            for ( i = 0; i < PAGE_MAX; i++ ) {
                if ( logList[i] != null ) {
                    _logListSet[i].text = logList[i];
                    _logListSet[i].visible = true;
                } else {
                    _logListSet[i].text = "";
                    _logListSet[i].visible = false;
                }
            }
        }

        public function set bg(bg:BG):void
        {
            _bg = bg;
        }

    }
}

/*
import flash.display.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.filters.GlowFilter;
import flash.geom.*;

import mx.core.UIComponent;
import mx.controls.*;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;

import view.scene.BaseScene;
import view.scene.log.*;
import view.image.log.*;
import view.*;
import view.utils.*;

import model.*;
import model.events.*;
import model.utils.*;

import controller.*;


/**
 * ログ情報
 *
 *
class LogScene extends BaseScene
{

    private var _ct:ColorTransform = new ColorTransform(0.3,0.3,0.3);// トーンを半分に
    private var _ct2:ColorTransform = new ColorTransform(1.0,1.0,1.0);// トーン元にに

    private var _container:UIComponent;
    private var _name:Label = new Label();

    private var _clientLog:ClientLog;

    private static const _X:int = 24
    private static const _NAME_X:int = 32
    private static const _NAME_Y:int = 0;           // 名称のY
    private static const _NAME_H:int = 28;           // カードの初期位置Y
    private static const _NAME_W:int = 355;           // カードの初期位置Y

    public function LogScene(cLog:ClientLog)
    {
        _clientLog = cLog;
        labelUpdate();
    }

    private function labelUpdate():void
    {
        _name.htmlText = _clientLog;

        addChild(_name);
    }


    public function get logInv():ClientLog
    {
        return _clientLog;
    }


}

*/