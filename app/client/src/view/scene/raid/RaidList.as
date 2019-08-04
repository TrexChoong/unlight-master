package view.scene.raid
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.filters.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.controls.Label;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.ParallelExecutor;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.*;

    import view.image.raid.*;
    import view.*;
    import view.scene.BaseScene;
    import view.utils.*;

    import controller.RaidCtrl;
    import controller.RaidChatCtrl;
    import controller.RaidDataCtrl;


    /**
     * 渦List表示クラス
     *
     */
    public class RaidList extends BaseScene
    {
        private static const LIST_MAX:int = 5;

        private var _container:UIComponent = new UIComponent();
        private var _baseImage:RaidListImage = new RaidListImage();

        private var _panelListScene:RaidPanelListScene = new RaidPanelListScene();

        /**
         * コンストラクタ
         *
         */
        public function RaidList()
        {
        }

        public override function init():void
        {
            var i:int = 0;

            _baseImage.sortTimeFunc = listSortTimeHandler;
            _baseImage.sortNameFunc = listSortNameHandler;
            _baseImage.sortRareFunc = listSortRareHandler;
            _baseImage.nextFunc = listNextHandler;
            _baseImage.backFunc = listBackHandler;

            _container.addChild(_baseImage);
            addChild(_container);

            _panelListScene.selPrfFunc = selPrfFunc;
            _panelListScene.setPageBtnFunc = setPageButton;
            _panelListScene.getShowThread(_container,1).start();
        }

        // 後始末処理
        public override function final():void
        {
            RemoveChild.apply(_container);
        }

        private function listSortTimeHandler():void
        {
            log.writeLog(log.LV_DEBUG, this,"listSortTimeHandler");
            if (_panelListScene.sortType != Profound.PRF_SORT_TIME) {
                _panelListScene.sortType = Profound.PRF_SORT_TIME;
            } else {
                _panelListScene.sortType = Profound.PRF_SORT_ID;
            }
            _panelListScene.page  = 0;
            _panelListScene.pageUpdate();
            setPageButton();
        }
        private function listSortNameHandler():void
        {
            log.writeLog(log.LV_DEBUG, this,"listSortNameHandler");
            if (_panelListScene.sortType != Profound.PRF_SORT_FINDER) {
                _panelListScene.sortType = Profound.PRF_SORT_FINDER;
            } else {
                _panelListScene.sortType = Profound.PRF_SORT_ID;
            }
            _panelListScene.page  = 0;
            _panelListScene.pageUpdate();
            setPageButton();
        }
        private function listSortRareHandler():void
        {
            log.writeLog(log.LV_DEBUG, this,"listSortRareHandler");
            if (_panelListScene.sortType != Profound.PRF_SORT_RARE) {
                _panelListScene.sortType = Profound.PRF_SORT_RARE;
            } else {
                _panelListScene.sortType = Profound.PRF_SORT_ID;
            }
            _panelListScene.page  = 0;
            _panelListScene.pageUpdate();
            setPageButton();
        }
        private function listNextHandler():void
        {
            log.writeLog(log.LV_DEBUG, this,"listNextHandler");
            var listNum:int = Profound.getSortListLength(_panelListScene.sortType);
            var max:int = listNum/LIST_MAX;
            _panelListScene.page += 1;
            if  (_panelListScene.page > max ) {
                _panelListScene.page = 0;
            }
            _panelListScene.pageUpdate();
            setPageButton();
        }
        private function listBackHandler():void
        {
            log.writeLog(log.LV_DEBUG, this,"listBackHandler");
            var listNum:int = Profound.getSortListLength(_panelListScene.sortType);
            var max:int = listNum/LIST_MAX;
            _panelListScene.page -= 1;
            if  (_panelListScene.page < 0 ) {
                _panelListScene.page = max;
            }
            _panelListScene.pageUpdate();
            setPageButton();
        }
        private function setPageButton():void
        {
            var listNum:int = Profound.getSortListLength(_panelListScene.sortType);
            log.writeLog(log.LV_DEBUG, this,"setPageButton",listNum);
            if (listNum > LIST_MAX) {
                if (_panelListScene.page <= 0) {
                    _baseImage.nextBtn.visible = true;
                    _baseImage.backBtn.visible = false;
                } else if ((listNum*LIST_MAX) >= ((_panelListScene.page+1)*LIST_MAX) ) {
                    _baseImage.nextBtn.visible = false;
                    _baseImage.backBtn.visible = true;
                }  else {
                    _baseImage.nextBtn.visible = true;
                    _baseImage.backBtn.visible = true;
                }
            } else {
                _baseImage.nextBtn.visible = false;
                _baseImage.backBtn.visible = false;
            }
        }
        public function resetList():void
        {
            _panelListScene.pageUpdate();
            setPageButton();
        }
        public function setSelectProfound(prf:Profound):void
        {
            _panelListScene.setSelPrf(prf);
        }
        public function selPrfFunc(prf:Profound):void
        {
            dispatchEvent(new ProfoundEvent(ProfoundEvent.SELECT, prf));
        }
        public function unselPrf():void
        {
            _panelListScene.resetSelect();
            setPageButton();
        }

    }
}

import flash.geom.*;
import flash.filters.*;

import flash.display.*;
import flash.events.*;
import flash.utils.*;
import mx.core.*;
import mx.controls.Label;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import model.*;
import model.events.*;

import view.image.raid.*;
import view.scene.BaseScene;
import view.utils.*;

import controller.RaidCtrl;
import controller.RaidDataCtrl;

class RaidPanelListScene extends BaseScene
{
    private static const LIST_MAX:int = 5;
    private static const _SET_TIME_CNT:int = 2;

    private var _container:UIComponent = new UIComponent();

    private var _prfList:Vector.<Profound> = new Vector.<Profound>();
    private var _panelList:Vector.<RaidListPanelImage> = new Vector.<RaidListPanelImage>();
    private var _hpGaugeList:Vector.<ListHPGauge> = new Vector.<ListHPGauge>();
    private var _nameList:Vector.<Label> = new Vector.<Label>();
    private var _timeList:Vector.<Label> = new Vector.<Label>();
    private var _pointList:Vector.<Label> = new Vector.<Label>();
    private var _hpList:Vector.<Label> = new Vector.<Label>();
    private var _rareList:Vector.<Label> = new Vector.<Label>();
    private var _apList:Vector.<Label> = new Vector.<Label>();
    private var _finderList:Vector.<Label> = new Vector.<Label>();

    private var _selPrfFunc:Function;
    private var _setPageBtnFunc:Function;

    private var _selectPrfId:int = 0;
    private var _pageIdx:int = 0;
    private var _sortType:int = Profound.PRF_SORT_ID;

    private var _time:Timer;

    private static const _Y_START:int = 40;
    private static const _HEIGHT:int = 16;

    private static const _NAME_X:int = 23;
    private static const _NAME_W:int = 160;
    private static const _TIME_X:int = _NAME_X+_NAME_W+13;
    private static const _TIME_W:int = 50;
    private static const _POINT_X:int = _TIME_X+_TIME_W+15;
    private static const _POINT_W:int = 50;
    private static const _HP_X:int = _POINT_X+_POINT_W+20;
    private static const _HP_W:int = 130;
    private static const _HP_Y_DIFF:int = 2;
    private static const _RARE_X:int = _HP_X+_HP_W+18;
    private static const _RARE_W:int = 20;
    private static const _AP_X:int = _RARE_X+_RARE_W+10;
    private static const _AP_W:int = 20;
    private static const _FINDER_X:int = _AP_X+_AP_W+20;
    private static const _FINDER_W:int = 100;
    private static const _LABEL_H:int = 20;

    private static const _HP_GAUGE_X:int = _HP_X - 15;
    private static const _HP_GAUGE_Y:int = _Y_START + 13;

    public function RaidPanelListScene()
    {
    }

    public override function init():void
    {
        for ( var i:int = 0; i < LIST_MAX; i++) {
            var panel:RaidListPanelImage = new RaidListPanelImage();
            panel.y = _Y_START + _HEIGHT * i;
            panel.addEventListener(MouseEvent.MOUSE_OVER,panelMouseOverHandler);
            panel.addEventListener(MouseEvent.MOUSE_OUT,panelMouseOutHandler);
            panel.addEventListener(MouseEvent.CLICK,panelClickHandler);
            _container.addChild(panel);
            _panelList.push(panel);

            var gauge:ListHPGauge = new ListHPGauge();
            gauge.x = _HP_GAUGE_X;
            gauge.y = _HP_GAUGE_Y + _HEIGHT * i;
            //gauge.visible = false;
            _container.addChild(gauge);
            _hpGaugeList.push(gauge);

            _nameList.push(labelInit(_NAME_X,_Y_START,_NAME_W,i));

            _timeList.push(labelInit(_TIME_X,_Y_START,_TIME_W,i));

            _pointList.push(labelInit(_POINT_X,_Y_START,_POINT_W,i));

            _hpList.push(labelInit(_HP_X,_Y_START-_HP_Y_DIFF,_HP_W,i));

            _rareList.push(labelInit(_RARE_X,_Y_START,_RARE_W,i));

            _apList.push(labelInit(_AP_X,_Y_START,_AP_W,i));

            _finderList.push(labelInit(_FINDER_X,_Y_START,_FINDER_W,i,"left"));
        }
        addChild(_container);

        _selectPrfId = 0;
        pageUpdate();

        RaidDataCtrl.instance.addEventListener(RaidDataCtrl.BOSS_HP_UPDATE,updateBossHPHandler);

        _time = new Timer(1000);
        _time.addEventListener(TimerEvent.TIMER, updateDuration);
        _time.start();
    }
    private function labelInit(x:int,yStart:int,width:int,idx:int,align:String="right"):Label
    {
        var l:Label = new Label();
        l.x = x;
        l.y = yStart + _HEIGHT * idx;
        l.width = width;
        l.height = _LABEL_H;
        l.text = "";
        l.setStyle("textAlign",align);
        l.mouseEnabled = false;
        l.mouseChildren = false;
        _container.addChild(l);
        return l;
    }

    public override function final():void
    {
        _time.stop();
        _time.removeEventListener(TimerEvent.TIMER, updateDuration);

        RaidDataCtrl.instance.removeEventListener(RaidDataCtrl.BOSS_HP_UPDATE,updateBossHPHandler);

        RemoveChild.all(_container);
        RemoveChild.apply(_container);
        _selPrfFunc = null;
    }

    public function set selPrfFunc(f:Function):void
    {
        _selPrfFunc = f;
    }
    public function set setPageBtnFunc(f:Function):void
    {
        _setPageBtnFunc = f;
        _setPageBtnFunc();
    }

    private function  panelMouseOverHandler(e:MouseEvent):void
    {
        //log.writeLog(log.LV_DEBUG, this,"pageUpdate !!!!!!!");
        if (_selectPrfId != 0) return;
        if (_panelList.indexOf(e.currentTarget) < _prfList.length && _selectPrfId != _prfList[_panelList.indexOf(e.currentTarget)].id) {
            e.currentTarget.select = true;
        }
    }
    private function panelMouseOutHandler(e:MouseEvent):void
    {
        if (_selectPrfId != 0) return;
        if (_panelList.indexOf(e.currentTarget) < _prfList.length && _selectPrfId != _prfList[_panelList.indexOf(e.currentTarget)].id) {
            e.currentTarget.select = false;
        }
    }
    private function panelClickHandler(e:MouseEvent):void
    {
        log.writeLog(log.LV_DEBUG, this,"click !!!!!!!",_selectPrfId,_prfList.length,_panelList.indexOf(e.currentTarget));
        if (_selectPrfId != 0) return;
        for (var i:int = 0; i < _prfList.length; i++) {
            if (_panelList.indexOf(e.currentTarget) == i) {
                _panelList[i].select = true;
                var selPrf:Profound  = _prfList[_panelList.indexOf(e.currentTarget)];
                _selectPrfId = selPrf.id;
                _selPrfFunc(selPrf);
            } else {
                _panelList[i].select = false;
            }
        }
    }
    public function setSelPrf(prf:Profound):void
    {
        for (var i:int = 0; i < _prfList.length; i++) {
            if (_prfList[i].id == prf.id) {
                _panelList[i].select = true;
                _selectPrfId = prf.id;
            } else {
                _panelList[i].select = false;
            }
        }
    }
    public function resetSelect():void
    {
        if (_panelList.length > 0) {
            for (var i:int  = 0; i < LIST_MAX; i++) {
                if (_panelList[i]) {
                    _panelList[i].select = false;
                }
            }
        }
        _selectPrfId = 0;
    }
    public function pageUpdate():void
    {
        log.writeLog(log.LV_DEBUG, this,"pageUpdate !!!!!!!");
        _prfList.length = 0;
        resetSelect();
        var list:Array = getActivePrf(_pageIdx*LIST_MAX,LIST_MAX);
        for (var i:int = 0; i < LIST_MAX; i++) {
            if (list[i]) {
                RaidDataCtrl.instance.updateMyRank(list[i].id);
                log.writeLog(log.LV_DEBUG, this,"pageUpdate !!!!!!! 1",list[i].id,list[i]);
                setLabel(list[i],i);
                _prfList.push(list[i]);
                _panelList[i].visible = true;
                _panelList[i].mouseEnabled = true;
                _panelList[i].mouseChildren = true;
            } else {
                clearLabel(i);
                _panelList[i].visible = false;
                _panelList[i].mouseEnabled = false;
                _panelList[i].mouseChildren = false;
            }
        }
        setCloseAtTime();
    }
    private function getActivePrf(start:int,num:int):Array
    {
        var list:Array = Profound.getSortList(_sortType);
        var ret:Array = [];
        for (var i:int = 0; i < list.length; i++) {
            var pi:ProfoundInventory = ProfoundInventory.getProfoundInventoryForPrfId(list[i].id);
            if (pi&&pi.viewCheck) {
                ret.push(list[i]);
            }
        }
        return ret.slice(start,start+num);
    }
    private function setLabel(prf:Profound,idx:int):void
    {
        if (prf) {
            var prfInv:ProfoundInventory = ProfoundInventory.getProfoundInventoryForPrfId(prf.id);
            _nameList[idx].text = "Lv"+prf.profoundData.level+" "+prf.profoundData.name;
            _pointList[idx].text =  ProfoundRanking.getProfoundRanking(prf.id).myPoint.toString();
            setHpLabel(prf,idx);
            _rareList[idx].text = prf.rarity.toString();
            _apList[idx].text = prf.profoundData.level.toString();
            _finderList[idx].text = prf.finderName;
        }
    }
    private function setHpLabel(prf:Profound,idx:int):void
    {
        var nowHp:int = 0;
        var maxHp:int = 0;
        var setText:String = "";
        maxHp = prf.profoundData.coreMonsterMaxHp;
        if (maxHp > 0) nowHp = maxHp - prf.viewDamage;
        if (nowHp <= 0) nowHp = 0;
        setText = nowHp.toString() + "/" + maxHp.toString();
        _hpList[idx].text = setText;
        _hpGaugeList[idx].setHP(nowHp,maxHp);
        _hpGaugeList[idx].visible = true;
        _hpGaugeList[idx].getUpdateHPThread(nowHp).start();
    }
    private function clearLabel(idx:int):void
    {
        _nameList[idx].text = "";
        _timeList[idx].text = "";
        _pointList[idx].text = "";
        _hpList[idx].text = "";
        _rareList[idx].text = "";
        _apList[idx].text = "";
        _finderList[idx].text = "";
        _hpGaugeList[idx].visible = false;
    }
    private function updateDuration(e:Event):void
    {
        setCloseAtTime();
        setMyRankPoint();
    }
    private function updateBossHPHandler(e:Event):void
    {
        log.writeLog(log.LV_FATAL, this,"updateBossHPHandler *****");
        for (var i:int = 0; i < _prfList.length; i++) {
            setHpLabel(_prfList[i],i);
        }
    }

    private function setCloseAtTime():void
    {
        for (var i:int = 0; i < _prfList.length; i++) {
            var setTime:Number = _prfList[i].closeAtRestTime;
            var timeSet:Array = [];
            var setNum:int = 0;
            if (setTime>60*60*1000)
            {
                setNum =int(setTime/(60*60*1000))%24;
                timeSet.push((setNum.toString()).substr(-2,2))
            }

            if (timeSet.length < _SET_TIME_CNT) {
                setNum = int(setTime/(60*1000))%60;
                timeSet.push(("0"+setNum.toString()).substr(-2,2));
            }

            if (timeSet.length < _SET_TIME_CNT) {
                setNum = int(setTime/(1000))%60;
                timeSet.push(("0"+setNum.toString()).substr(-2,2));
            }

            var setTimeStr:String = timeSet.join(":");
            _timeList[i].text = setTimeStr;
        }
    }
    private function setMyRankPoint():void
    {
        for (var i:int = 0; i < _prfList.length; i++) {
            var pRanking:ProfoundRanking = ProfoundRanking.getProfoundRanking(_prfList[i].id);
            if (pRanking) {
                _pointList[i].text =  pRanking.myPoint.toString();
            }
        }
    }
    public function set page(p:int):void
    {
        _pageIdx = p;
    }
    public function get page():int
    {
        return _pageIdx;
    }
    public function set sortType(t:int):void
    {
        _sortType = t;
    }
    public function get sortType():int
    {
        return _sortType;
    }


}
