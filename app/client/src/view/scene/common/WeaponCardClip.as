package view.scene.common
{

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.controls.Label;
    import mx.controls.Text;
    import mx.events.ToolTipEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import view.image.common.*;
    import view.image.requirements.ExpGauge;
    import view.ClousureThread;
    import view.scene.BaseScene;
    import view.scene.game.BuffClip;
    import view.scene.ModelWaitShowThread;

    /**
     * WeaponCardClipのアイコン表示クラス
     * 全部ビットマップでキャッシュすべできか。同時に二つでることがない？
     */

    public class WeaponCardClip extends BaseScene implements ICardClip
    {
        // イメージ
        private var _image:WeaponCardImage;
        private var _weaponCard:WeaponCard;
        private var _cardFrame:CardFrame;
        private var _weaponCardInventory:ICardInventory;
        private var _deckEditor:DeckEditor = DeckEditor.instance;
        private var _filter:Array = [new GlowFilter(0xFFFFFF, 1, 2, 2, 16, 1)];
        private var _prmFilter:Array = [new GlowFilter(0x000000, 1, 2, 2, 16, 1)];
        private var _isCombine:Boolean = false;

        // 共有
        private var _name:Label = new Label();
        // 通常のみ
        private var _caption:Text = new Text();
        // 合成のみ
        private var _level:Label = new Label();
        private var _baseSap:Label = new Label();
        private var _baseSdp:Label = new Label();
        private var _baseAap:Label = new Label();
        private var _baseAdp:Label = new Label();
        private var _baseParams:Array = [_baseSap,_baseSdp,_baseAap,_baseAdp];
        private var _addSap:Label = new Label();
        private var _addSdp:Label = new Label();
        private var _addAap:Label = new Label();
        private var _addAdp:Label = new Label();
        private var _addParams:Array = [_addSap,_addSdp,_addAap,_addAdp];

        private var _expGauge:ExpGauge = new ExpGauge(ExpGauge.TYPE_FRAME);
        private var _skillIcons:Array = [];
        private var _useCntLabelList:Array = [];

        private var _combine:Combine = Combine.instance;

        private const _NAME_X:int = 0;
        private const _CMB_NAME_X:int = _NAME_X+10;
        private const _NAME_Y:int = 5;
        private const _NAME_W:int = 164;
        private const _NAME_H:int = 50;
        private const _CAPTION_X:int = 15;
        private const _CAPTION_Y:int = 180;
        private const _CAPTION_W:int = 144;
        private const _CAPTION_H:int = 60;

        private const _LV_X:int = 17;
        private const _LV_Y:int = 17;
        // satk,sdef,mlatk,mldef
        private const _PRM_X_LIST:Array = [10,80,43,115];
        private const _BASE_PRM_Y:int = 185;
        private const _ADD_PRM_Y:int  = 212;

        private const _LBL_W:int = 50;
        private const _LBL_H:int = 50;
        private const _LBL_SIZE:int = 24;

        private const _ICON_NUM:int = 3;
        private const _ICON_X_LIST:Array = [4,52,100];
        private const _ICON_Y:int = 152;
        private const _CNT_LBL_X_LIST:Array = [22,70,118];
        private const _CNT_LBL_Y:int = 158;
        private const _CNT_LBL_W:int = 50;
        private const _CNT_LBL_H:int = 20;
        private const _CNT_LBL_SIZE:int = 8;

        private const _EXP_X:int = 42;
        private const _EXP_Y:int = 27;

        /**
         * コンストラクタ
         *
         */
        public function WeaponCardClip(wc:WeaponCard)
        {
            _weaponCard = wc;
            log.writeLog(log.LV_DEBUG, this, "weaponcardclip", _weaponCard.id, _weaponCard.image);
        }

        // 初期化
        public override function init():void
        {
            _isCombine = _weaponCard.combined;

            var type:int = (_isCombine) ? CardFrame.FRAME_TYPE_WEAPON : CardFrame.FRAME_TYPE_NORMAL;
            _cardFrame = new CardFrame(CardFrame.FRAME_GREEN,type);
            addChildAt(_cardFrame,0);

            _image.x = 83;
            _image.y = 100;

            labelInit(_name,_NAME_X,_NAME_Y,_NAME_W,_NAME_H,"",0,"ResultNameLabel",_filter);

            labelInit(_level,_LV_X,_LV_Y,_LBL_W,_LBL_H,"left",_LBL_SIZE,"ResultLabel",_prmFilter);

            textInit(_caption,_CAPTION_X,_CAPTION_Y,_CAPTION_W,_CAPTION_H,"",0,"ResultTextLabel",_filter);

            var i:int;
            for (i = 0; i < WeaponCard.PARAM_NUM; i++) {
                labelInit(_baseParams[i],_PRM_X_LIST[i],_BASE_PRM_Y,_LBL_W,_LBL_H,"right",_LBL_SIZE,"ResultLabel",_prmFilter);
                labelInit(_addParams[i],_PRM_X_LIST[i],_ADD_PRM_Y,_LBL_W,_LBL_H,"right",_LBL_SIZE,"ResultLabel",_prmFilter);
            }

            for (i =  0; i < _ICON_NUM; i++) {
                _skillIcons.push(iconInit(_ICON_X_LIST[i],_ICON_Y));
                var lb:Label = new Label();
                labelInit(lb,_CNT_LBL_X_LIST[i],_CNT_LBL_Y,_CNT_LBL_W,_CNT_LBL_H,"left",_CNT_LBL_SIZE,"ResultNameLabel",_filter);
                lb.visible = false;
                _useCntLabelList.push(lb);
            }

            _expGauge.x = _EXP_X;
            _expGauge.y = _EXP_Y;
            _expGauge.visible = false;

            setLabel();

            addChild(_expGauge);

            _weaponCard.addEventListener(WeaponCard.UPDATE,updateLabelHandler)
        }
        private function labelInit(l:Label,x:int,y:int,w:int,h:int,align:String,size:int,style:String,filters:Array=null):void
        {
            l.x = x;
            l.y = y;
            l.width = w;
            l.height = h;
            if (style != "") {
                l.styleName = style;
            }
            if (filters) {
                l.filters = filters;
            }
            if (align != "") {
                l.setStyle("textAlign",align);
            }
            if (size != 0) {
                l.setStyle("fontSize",size);
            }
            l.mouseEnabled = false;
            l.mouseChildren = false;
            addChild(l);
        }
        private function textInit(t:Text,x:int,y:int,w:int,h:int,align:String,size:int,style:String,filters:Array=null):void
        {
            t.x = x;
            t.y = y;
            t.width = w;
            t.height = h;
            if (style != "") {
                t.styleName = style;
            }
            if (filters) {
                t.filters = filters;
            }
            if (align != "") {
                t.setStyle("textAlign",align);
            }
            if (size != 0) {
                t.setStyle("fontSize",size);
            }
            t.mouseEnabled = false;
            t.mouseChildren = false;
            addChild(t);
        }
        private function iconInit(x:int,y:int):WeaponCardPassiveSkillIcon
        {
            var ic:WeaponCardPassiveSkillIcon = new WeaponCardPassiveSkillIcon();
            ic.x = x;
            ic.y = y;
            ic.visible = false;
            addChild(ic);
            return ic;
        }
        public function getNowPercent():Number
        {
            var prevLvUpExp:Number = 0.0;
            var nextLvUpExp:Number = 0.0;
            var expTable:Array = Const.SC_LEVEL_EXP_TABLE;
            var expTableLen:int = expTable.length;
            for (var i:int = 1; i < expTableLen; i++) {
                if (_weaponCard.exp < expTable[i]) {
                    prevLvUpExp = Number(expTable[i-1]);
                    nextLvUpExp = Number(expTable[i]);
                    break;
                }
            }
            var nowParam:Number = Number(_weaponCard.exp) - prevLvUpExp;
            var totalParam:Number = nextLvUpExp - prevLvUpExp;
            log.writeLog(log.LV_FATAL, this, "getNowPercent","_nowExp",_weaponCard.exp,"prevLvUpExp",prevLvUpExp,"nextLvUpExp",nextLvUpExp,"nowParam",nowParam,"totalParam",totalParam,"percent",(Number(nowParam)/Number(totalParam) * 100));
            return (nowParam/totalParam * 100);
        }
        private function setGauge():void
        {
            var setPercent:Number = 0.0;
            if (_weaponCard.level >= Const.SC_LEVEL_MAX) {
                setPercent = 100.0;
            } else {
                setPercent = getNowPercent();
            }
            _expGauge.setGauge(setPercent);
            _expGauge.visible = true;
        }

        private function setLabel():void
        {
            _name.text = _weaponCard.name;
            var i:int;
            if (_weaponCard.combined) {
                _caption.text = "";
                _level.text = _weaponCard.level.toString();
                for (i = 0; i < WeaponCard.PARAM_NUM; i++) {
                    _baseParams[i].text = _weaponCard.getBaseParamIdx(i).toString();
                    _addParams[i].text = _weaponCard.getAddParamIdx(i).toString();
                }

                var slotIdx:int = 0;
                if (0 < _weaponCard.weaponPassiveNum) {
                    _skillIcons[slotIdx].changePassiveNo(0);
                    _skillIcons[slotIdx].visible = true;
                    _useCntLabelList[slotIdx].visible = false;
                    slotIdx++;
                }

                for (i = 0;i<_weaponCard.passiveNumMax; i++) {
                    var idx:int = i+slotIdx;
                    if (_weaponCard.useCntSet[i] > 0) {
                        _skillIcons[idx].changePassiveNo(_weaponCard.passiveIdPassSet[i]+1);
                        _skillIcons[idx].visible = true;
                        _useCntLabelList[idx].text = _weaponCard.useCntSet[i].toString() + "/" + _weaponCard.useCntMaxSet[i].toString();
                        _useCntLabelList[idx].visible = true;
                    } else {
                        _skillIcons[idx].visible = false;
                        _useCntLabelList[idx].visible = false;
                    }
                }

                _cardFrame.setBaseMax(_weaponCard.baseMax);

                setGauge();
            } else {
                _caption.text = _weaponCard.caption;
                _level.text = "";
                for (i = 0; i < WeaponCard.PARAM_NUM; i++) {
                    _baseParams[i].text = "";
                    _addParams[i].text = "";
                }
                _expGauge.visible = false;
            }
        }

        public function imageInitialize():Thread
        {
            log.writeLog(log.LV_DEBUG, this, "imageinitialize", _weaponCard.image);
            _image = new WeaponCardImage(_weaponCard.image);
            return _image.getShowThread(this);

        }

        private function updateLabelHandler(e:Event):void
        {
            setLabel();
        }

        // 後処理
        public override function final():void
        {
            _weaponCard.removeEventListener(WeaponCard.UPDATE,updateLabelHandler)
            removeEventListener(MouseEvent.CLICK, selectCardHandler);
//            _image.getHideThread().start();
            if (_cardFrame != null &&_cardFrame.parent ==this){ removeChild(_cardFrame)};
            if (_name.parent == this){ removeChild(_name)};
            if (_caption.parent == this){ removeChild(_caption)};
        }

        // 表示用スレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(  _weaponCard, this, stage);
        }

        // エディット用表示スレッドを返す
        public function getEditShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            addEventListener(MouseEvent.CLICK, selectCardHandler);
            return getShowThread(stage, at, type);
        }

        public  function get itemID():int
        {
            return _weaponCard.id;
        }

        public function set cardInventory(inv:ICardInventory):void
        {
            _weaponCardInventory = inv;
        }

        public function get cardInventory():ICardInventory
        {
            return _weaponCardInventory
        }

        public function addDeckUpdatedEventHandler():void
        {
        }

        public function setCaution(co:Array, ch:Array, pa:Array):void
        {
        }

        public function removeDeckUpdatedEventHandler():void
        {
        }

        // カード選択ハンドラ
        private function selectCardHandler(e:MouseEvent):void
        {
            _deckEditor.selectCard(_weaponCard.id,_weaponCardInventory);
        }

        // 系統樹表示イベント
        public function pushRequirementsHandler(e:MouseEvent):void
        {
            _combine.combines();
        }

    }

}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.geom.*;

import org.libspark.thread.Thread;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import model.WeaponCard;
import view.scene.common.WeaponCardClip;
import view.BaseShowThread;
import view.BaseHideThread;
import controller.LobbyCtrl;



// 表示スレッド
class ShowThread extends BaseShowThread
{
    protected var _ai:WeaponCard;
    protected var _icc:WeaponCardClip;

    public function ShowThread(ai:WeaponCard, icc:WeaponCardClip, stage:DisplayObjectContainer)
    {
        log.writeLog(log.LV_DEBUG, this, "showthread", ai.id,ai.image);
        _ai = ai;
        _icc = icc;
        super(icc,stage)
    }

    protected override function run():void
    {
        log.writeLog(log.LV_DEBUG, this, "showthread", _ai.id,_ai.image,_ai.loaded);
        // キャラカードの準備を待つ
        if (_ai.loaded == false)
        {
            _ai.wait();
        }
        next(init);
    }


    private function init ():void
    {
        var thread:Thread;
        thread =  _icc.imageInitialize();
        thread.start();
        thread.join();
        next(close);
    }

}