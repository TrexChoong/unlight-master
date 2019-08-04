import flash.utils.getTimer;

import mx.core.UIComponent;
import mx.controls.*;

import com.potix2.utils.GCWatcher;
import org.libspark.thread.Thread;
import org.libspark.thread.EnterFrameThreadExecutor;
import org.libspark.thread.utils.*;
import org.libspark.thread.threads.between.BeTweenAS3Thread;


import view.*;
import view.image.title.*;
import net.server.*;
import view.utils.*;
import model.utils.*;

public var mainView:MainView;
private var _container:UIComponent;

public static var INS:Unlight;
private static var GCW:GCWatcher;
public static var RELOAD_COUNT:int = 0;

// 全体スピード
public static var SPEED:Number = 1.7



public static const WIDTH:int = 760;
public static const HEIGHT:int = 680;
public static const VERSION:String = Version.NO+"."+Version.REVISION;
CONFIG::LOCALE_JP
//public static const DISCONNECT_TIME:int = 60*1000;
public static const DISCONNECT_TIME:int = 6*60*60*1000;
CONFIG::LOCALE_TCN
public static const DISCONNECT_TIME:int = 3*60*60*1000;
CONFIG::LOCALE_SCN
public static const DISCONNECT_TIME:int = 3*60*60*1000;
CONFIG::LOCALE_EN
public static const DISCONNECT_TIME:int = 3*60*60*1000;
CONFIG::LOCALE_FR
public static const DISCONNECT_TIME:int = 3*60*60*1000;
CONFIG::LOCALE_ID
public static const DISCONNECT_TIME:int = 3*60*60*1000;
CONFIG::LOCALE_TH
public static const DISCONNECT_TIME:int = 3*60*60*1000;

private var rmenu:ContextMenu;
private var rmenuitem:ContextMenuItem;
private static var _preLoader:PreLoader;
private var _lastOperation:int;

private var singleChecker:SingleConnectionChecker;
private var _loading:Loading = new Loading();

CONFIG::DEBUG
private var _debugLabel:Label = new Label();     // タイトル
CONFIG::DEBUG
private var _versionInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _authSeverInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _lobbySeverInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _dataServerInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _globalChatServerInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _questServerInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _raidServerInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _raidChatServerInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _raidDataServerInfo:String = "";     // タイトル
CONFIG::DEBUG
private var _raidRankServerInfo:String = "";     // タイトル

CONFIG::LOCALE_JP
private static const _ALERT_LOGIN	:String = "多重起動は禁止されております";
CONFIG::LOCALE_JP
private static const _ERROR		:String = "エラー";

CONFIG::LOCALE_EN
private static const _ALERT_LOGIN	:String = "Multiple launch is prohibited.";
CONFIG::LOCALE_EN
private static const _ERROR		:String = "Error";

CONFIG::LOCALE_TCN
private static const _ALERT_LOGIN	:String = "禁止多重啟動遊戲";
CONFIG::LOCALE_TCN
private static const _ERROR		:String = "錯誤";

CONFIG::LOCALE_SCN
private static const _ALERT_LOGIN	:String = "禁止多次启动";
CONFIG::LOCALE_SCN
private static const _ERROR		:String = "错误";

CONFIG::LOCALE_KR
private static const _ALERT_LOGIN	:String = "다중 기동은 금지 되어 있습니다.";
CONFIG::LOCALE_KR
private static const _ERROR		:String = "에러";

CONFIG::LOCALE_FR
private static const _ALERT_LOGIN	:String = "Interdiction de lancer plusieurs plate-formes simultanément.";
CONFIG::LOCALE_FR
private static const _ERROR		:String = "Erreur";

CONFIG::LOCALE_ID
private static const _ALERT_LOGIN	:String = "多重起動は禁止されております";
CONFIG::LOCALE_ID
private static const _ERROR		:String = "エラー";

CONFIG::LOCALE_TH
private static const _ALERT_LOGIN   :String = "ไม่อนุญาตให้เริ่มหลายเควสพร้อมกัน";
CONFIG::LOCALE_TH
private static const _ERROR     :String = "พบข้อผิดพลาด";


CONFIG::ENCRYPT_ON
public static var _IMAGE_MD5_IS_SET:Boolean = true;
CONFIG::ENCRYPT_OFF
public static var _IMAGE_MD5_IS_SET:Boolean = false;

public static var _IMG_HASH_KEY:String = "";
public static var live:Boolean = true; // 二重ログインを一度でもしたら通信を出来なくする

public static function setImgHashKey(hash_key:String):void
{
    _IMG_HASH_KEY = hash_key;
    log.writeLog(log.LV_DEBUG, "[Main] setImgHashKey ", _IMG_HASH_KEY);

    // 画像プリローダーの再読み込み
    _preLoader = new PreLoader();
    _preLoader = null;
}

public static function get stageCenter ():Point
{
    return new Point(380, 340)
}

CONFIG::DEBUG
public function init():void
{
    // 画像プリローダを読み込む
//    _preLoader = new PreLoader();
    _loading.alpha = 0.0;
    _container  = new UIComponent();
    _container.width = WIDTH;
    _container.height = HEIGHT;
    horizontalScrollPolicy = "off";
    verticalScrollPolicy = "off";
    GCWOn();

    if (!Thread.isReady)
    {
        Thread.initialize(new EnterFrameThreadExecutor());
    }
    Thread.uncaughtErrorHandler = uncautError;

    addChild(_container);
    _versionInfo = "Debug Version "+VERSION+"_d";
    _debugLabel.text = _versionInfo;
    _debugLabel.x = 0;
    _debugLabel.y = 0;
    _debugLabel.width = 720;
    _debugLabel.height = 400;
    _debugLabel.filters = [ new GlowFilter(0x000000, 1, 2, 2, 16, 1) ];
    _debugLabel.alpha = 0.45;
    _debugLabel.styleName = "LoginInfoTitle";
    _debugLabel.setStyle("fontSize",  16);
    _debugLabel.setStyle("textAlign",  "left");
    _debugLabel.mouseEnabled = false;
    _debugLabel.mouseChildren = false;
    addChild(_debugLabel);

    mainView = new MainView(_container);
    mainView.start();
    INS =this;
//     this.addEventListener(MouseEvent.CLICK, reportClick);
//    _preLoader = null;
     this.addEventListener(MouseEvent.CLICK, lastClick);

}
CONFIG::RELEASE
public function init():void
{
//    _preLoader = new PreLoader();

    _loading.alpha = 0.0;
    _container  = new UIComponent();
    _container.width = WIDTH;
    horizontalScrollPolicy = "off";
    verticalScrollPolicy = "off";
    rmenu = new ContextMenu();
    rmenuitem =  new ContextMenuItem ("Ver."+VERSION);
    rmenu.hideBuiltInItems();
    rmenu.customItems.push(rmenuitem);
    this.contextMenu = rmenu;

    singleChecker = new SingleConnectionChecker("UnlightTCGApp");
    log.writeLog(log.LV_FATAL, this, "test multi deny", singleChecker.isExitsO());
    if (singleChecker.isExitsO())
    {
//      Alerter.showWithSize("多重起動は禁止されております。", "エラー");
       Alerter.showWithSize(_ALERT_LOGIN, _ERROR);
    }else{
        if (!Thread.isReady)
        {
            Thread.initialize(new EnterFrameThreadExecutor());
        }
        Thread.uncaughtErrorHandler = uncautError;

        addChild(_container);
        mainView = new MainView(_container);
        mainView.start();
        INS =this;
    }
//     this.addEventListener(MouseEvent.CLICK, reportClick);

     this.addEventListener(MouseEvent.CLICK, lastClick);
}

public function get topContainer():UIComponent
{
    return _container;
}

public function loadingDisable():Boolean
{
    return (_loading == null);
}
public function loadingReset():void
{
    if (_loading == null) {
        _loading = new Loading();
    }
}
public function loadingStart():void
{
    _container.addChild(_loading);
    var loadingTween:Thread = new BeTweenAS3Thread(_loading, {alpha:1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true );
    loadingTween.start();
}

public function loadingEnd():void
{
    var sExec:SerialExecutor = new SerialExecutor();
    var t:Thread = new BeTweenAS3Thread(_loading, {alpha:0.0}, null, 0.3, BeTweenAS3Thread.EASE_IN_SINE, 4.0 ,false );
    sExec.addThread(t);
    sExec.addThread(new ClousureThread(_container.removeChild, [_loading]));
    sExec.addThread(new ClousureThread(disableLoading));
    sExec.start();
}
private function disableLoading():void
{
    _loading = null;
}


private function uncautError(e:Object, t:Thread):void
{
//     removeChild(_container);
//     init();
    log.writeLog (log.LV_ERROR,this,"スレッド内部でエラー",e,t,t.id);
//    GameServer.instance.exit();
}

public function addObj(o:UIComponent):void
{
    addChild(o);
}

// マウスイベントの流れを追うコマンド
private    function reportClick(event:MouseEvent):void
{
    log.writeLog (log.LV_ERROR,this,(event.target.toString() +" dispatches MouseEvent. Local coords [" + event.localX + "," + event.localY + "] Stage coords [" +event.stageX + "," + event.stageY + "]"));
}

// マウスの最終クリック時間を記録する
private function lastClick(event:MouseEvent):void
{
    _lastOperation = getTimer();
}

public function opetationCheck(dt:int = DISCONNECT_TIME):Boolean
{
    return (getTimer() - _lastOperation) > dt
}

// 擬似的にマウス操作している状態にする
public function dummyClick():void
{
    _lastOperation = getTimer();
}

//  ===================================
//   GC関係のデバッグ設定
//  ===================================
private static function gcWatcherHandler(e:Event):void
{
    log.writeLog(log.LV_FATAL, "GC!!", GCW.numberOfLeftObjectsWithLog, GCW.numberOfWatchedObjects);
}

public static function GCWOn():void
{
    if (GCW == null)
    {
        GCW = new GCWatcher(0);
//        GCW.addEventListener(Event.CHANGE, gcWatcherHandler)
        GCW.addEventListener(GCWatcher.GARBAGE_COLLECT, gcWatcherHandler)
    }
}

public static function GCWOff():void
{
    if (GCW != null)
    {
        GCW.removeEventListener(GCWatcher.GARBAGE_COLLECT, gcWatcherHandler);
//        GCW.removeEventListener(Event.CHANGE, gcWatcherHandler);
        GCW =null;
    }
}

public static function GCWCheckNow():void
{
    if (GCW == null)
    {
        GCW = new GCWatcher(0);
    }

    GCW.checkNow();
}

CONFIG::DEBUG
public static function GCWatch(item:Object):void
{
    GCW.watch(item)
}

CONFIG::RELEASE
public static function GCWatch(item:Object):void
{

}

CONFIG::DEBUG
public function updateSeverInfo(auth:String = "", lobby:String = "", quest:String = "",data:String = "",raid:String = "",raidChat:String = "",raidData:String = "",raidRank:String = "",globalChat:String = ""):void
{
    log.writeLog(log.LV_INFO, this,"updateServerInfo","auth:",auth,"lobby:",lobby,"quest:",quest,"data:",data,"raid:",raid,"raidChat:",raidChat,"raidData:",raidData,"raidRank:",raidRank,"globalChat:",globalChat);
    if (auth !="")
    {
        _authSeverInfo = auth;
    }
    if (lobby !="")
    {
        _lobbySeverInfo = lobby;
    }
    if (data !="")
    {
        _dataServerInfo = data;
    }
    if (globalChat !="")
    {
        _globalChatServerInfo = globalChat;
    }
    if (quest !="")
    {
        _questServerInfo = quest;
    }
    if (raid !="")
    {
        _raidServerInfo = raid;
    }
    if (raidChat !="")
    {
        _raidChatServerInfo = raidChat;
    }
    if (raidData !="")
    {
        _raidDataServerInfo = raidData;
    }
    if (raidRank !="")
    {
        _raidRankServerInfo = raidRank;
    }

    _debugLabel.text = _versionInfo+"\n"+_authSeverInfo+"\n"+_lobbySeverInfo+"\n"+_dataServerInfo+"\n"+_globalChatServerInfo+"\n"+_questServerInfo+"\n"+_raidServerInfo+"\n"+_raidChatServerInfo+"\n"+_raidDataServerInfo+"\n"+_raidRankServerInfo;

}

CONFIG::DEBUG
public function debugInfoVisibleToggle():void
{
    _debugLabel.visible = !_debugLabel.visible;
}


// 使うときには
// Unlightg.GCWOn();
// Unlight.GCW.watch(obj)


// public function get currencyString():String
// {
//     ret = COIN_STR
//     return

// }


