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
     * 渦情報表示クラス
     *
     */
    public class RaidInfo extends BaseScene
    {
        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_CLOSE_AT:String = "残り[__CLOSE_TIME__]";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_CLOSE_AT:String = "[__CLOSE_TIME__]";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_CLOSE_AT:String = "剩餘[__CLOSE_TIME__]";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_CLOSE_AT:String = "剩余[__CLOSE_TIME__]";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_CLOSE_AT:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_CLOSE_AT:String = "Reste [__CLOSE_TIME__]";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_CLOSE_AT:String = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_CLOSE_AT:String = "เวลาที่เหลือ[__CLOSE_TIME__]";

        CONFIG::LOCALE_JP
        private static const _TRANS_BTL_CNT_MSG:String = "戦闘行動中の渦の個数と最大個数です";
        CONFIG::LOCALE_EN
        private static const _TRANS_BTL_CNT_MSG:String = "The number of active and maximum possible vortex battles.";
        CONFIG::LOCALE_TCN
        private static const _TRANS_BTL_CNT_MSG:String = "戰鬥進行中的渦的數量以及最大數量";
        CONFIG::LOCALE_SCN
        private static const _TRANS_BTL_CNT_MSG:String = "战斗中的漩涡个数及个数上限值。";
        CONFIG::LOCALE_KR
        private static const _TRANS_BTL_CNT_MSG:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_BTL_CNT_MSG:String = "Voici le nombre de Vortex et le nombre maximal de Vortex dans lesquels des combats ont lieu.";
        CONFIG::LOCALE_ID
        private static const _TRANS_BTL_CNT_MSG:String = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_BTL_CNT_MSG:String = "จำนวนน้ำวนในขณะต่อสู้กับจำนวนสูงสุด"; // 戦闘行動中の渦の個数と最大個数です

        CONFIG::LOCALE_JP
        private static const _TRANS_MAP_NAME_HEX:String      = "隠者の道";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP_NAME_SHADOW:String   = "影斬り森";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP_NAME_MOON:String     = "幻影城";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP_NAME_ANEMONEA:String = "翼竜の宝物庫";
        CONFIG::LOCALE_JP
        private static const _TRANS_MAP_NAME_ANGEL:String    = "聖女の玉座";

        CONFIG::LOCALE_EN
        private static const _TRANS_MAP_NAME_HEX:String      = "Hermit Road";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP_NAME_SHADOW:String   = "Shadowthief Forest";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP_NAME_MOON:String     = "The Phantom Castle";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP_NAME_ANEMONEA:String = "The Wyvern's Treasure";
        CONFIG::LOCALE_EN
        private static const _TRANS_MAP_NAME_ANGEL:String    = "Throne of the saint";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP_NAME_HEX:String      = "隱者之道";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP_NAME_SHADOW:String   = "斬影森林";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP_NAME_MOON:String     = "幻影城";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP_NAME_ANEMONEA:String = "翼龍的藏寶庫";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MAP_NAME_ANGEL:String    = "聖女的玉座";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP_NAME_HEX:String      = "隐士之道";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP_NAME_SHADOW:String   = "斩影之森";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP_NAME_MOON:String     = "幻影城";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP_NAME_ANEMONEA:String = "翼龙的宝物库";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MAP_NAME_ANGEL:String    = "圣女的宝座";

        CONFIG::LOCALE_KR
        private static const _TRANS_MAP_NAME_HEX:String      = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP_NAME_SHADOW:String   = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP_NAME_MOON:String     = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP_NAME_ANEMONEA:String = "";
        CONFIG::LOCALE_KR
        private static const _TRANS_MAP_NAME_ANGEL:String    = "";

        CONFIG::LOCALE_FR
        private static const _TRANS_MAP_NAME_HEX:String      = "Route des Ermites";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP_NAME_SHADOW:String   = "Forêt voleuse d'ombres";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP_NAME_MOON:String     = "Château du Fantôme";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP_NAME_ANEMONEA:String = "Coffre de Wyvern";
        CONFIG::LOCALE_FR
        private static const _TRANS_MAP_NAME_ANGEL:String    = "Trône de Rrine";

        CONFIG::LOCALE_ID
        private static const _TRANS_MAP_NAME_HEX:String      = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP_NAME_SHADOW:String   = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP_NAME_MOON:String     = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP_NAME_ANEMONEA:String = "";
        CONFIG::LOCALE_ID
        private static const _TRANS_MAP_NAME_ANGEL:String    = "";

        CONFIG::LOCALE_TH
        private static const _TRANS_MAP_NAME_HEX:String      = "ถนนลักซ่อน"; // 隠者の道
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP_NAME_SHADOW:String   = "ป่าตัดเงา"; // 影斬り森
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP_NAME_MOON:String     = "ปราสาทเงาลวง"; // 幻影城
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP_NAME_ANEMONEA:String = "คลังสมบัติมังกรบิน"; // 翼竜の宝物庫
        CONFIG::LOCALE_TH
        private static const _TRANS_MAP_NAME_ANGEL:String    = "ที่อยู่ของนักบุญหญิง"; // 聖女の玉座

        private static const _MAP_NAME_LIST:Array = [
            _TRANS_MAP_NAME_HEX,
            _TRANS_MAP_NAME_SHADOW,
            _TRANS_MAP_NAME_MOON,
            _TRANS_MAP_NAME_ANEMONEA,
            _TRANS_MAP_NAME_ANGEL
            ];
        private static const _PAGE_MAX:int = 10;

        private static const _RANKING_UPDATE_TIME:int = 1000*60*3; // 3分毎に更新

        // コントローラー
        private var _ctrl:RaidCtrl = RaidCtrl.instance;

        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private var _infoImage:RaidInfoImage = new RaidInfoImage();

        // 選択中の渦
        private var _selectPrf:Profound = null;

        // 渦の情報
        private var _closeAtTimeLabel:Label = new Label();
        private var _prfName:Label = new Label();
        private var _bossName:Label = new Label();
        private var _bossHp:Label = new Label();
        private var _countLabel:Label = new Label();
        private var _hpGauge:BossHPGauge = new BossHPGauge();
        private var _timeGauge:TimeLimitGauge = new TimeLimitGauge();
        private var _timeGaugeUpdate:Boolean = false;
        private var _caption:TextField = new TextField();
        private var _itemsLabel:Label = new Label();

        private var _cntMsgText:TextField = new TextField();

        private var _time:Timer;  // 消滅監視用タイマー

        // ランキング
        private var _ranking:ProfoundRankingList = new ProfoundRankingList();
        private var _rankPage:int = 0;
        private var _updateTime:Timer;  // 更新用タイマー

        private const _Y:int = 32;

        private const _LABEL_X:int           = 115;
        private const _LABEL_PRF_NAME_X:int  = 70;
        private const _LABEL_CLOSE_AT_Y:int  = 63;
        private const _LABEL_PRF_NAME_Y:int  = 8;
        private const _LABEL_BOSS_X:int      = 100;
        private const _LABEL_BOSS_NAME_Y:int = 25;
        private const _LABEL_BOSS_HP_X:int   = 95;
        private const _LABEL_BOSS_HP_Y:int   = 43;
        private const _LABEL_W:int           = 160;
        private const _LABEL_PRF_NAME_W:int  = 210;
        private const _LABEL_BOSS_W:int      = 180;
        private const _LABEL_H:int           = 20;
        private const _LABEL_ITEM_NAME_X:int = 338;
        private const _LABEL_ITEM_NAME_Y:int = _LABEL_PRF_NAME_Y;
        private const _LABEL_ITEM_NAME_W:int = 165;
        private const _URL_BTN_X:int         = 540;
        private const _URL_BTN_Y:int         = 260;

        private const _LABEL_CNT_X:int  = 435;
        private const _LABEL_CNT_Y:int  = 485;
        private const _LABEL_CNT_W:int  = 50;
        private const _LABEL_CNT_H:int  = 40;

        private const _CAPTION_X:int = 285;
        private const _CAPTION_Y:int = 43;
        private const _CAPTION_W:int = 220;
        private const _CAPTION_H:int = 50;

        /**
         * コンストラクタ
         *
         */
        public function RaidInfo()
        {
        }

        public override function init():void
        {
            y = _Y;

            _closeAtTimeLabel.x      = _LABEL_X;
            _closeAtTimeLabel.y      = _LABEL_CLOSE_AT_Y;
            _closeAtTimeLabel.width  = _LABEL_W;
            _closeAtTimeLabel.height = _LABEL_H;
            _closeAtTimeLabel.setStyle("textAlign", "right");
            _closeAtTimeLabel.setStyle("color", "0xFFFFFF");
            _closeAtTimeLabel.text = "";

            _prfName.x      = _LABEL_PRF_NAME_X;
            _prfName.y      = _LABEL_PRF_NAME_Y;
            _prfName.width  = _LABEL_PRF_NAME_W;
            _prfName.height = _LABEL_H;
            _prfName.setStyle("textAlign", "right");
            _prfName.setStyle("color", "0xFFFFFF");
            _prfName.text = "";

            _bossName.x      = _LABEL_BOSS_X;
            _bossName.y      = _LABEL_BOSS_NAME_Y;
            _bossName.width  = _LABEL_BOSS_W;
            _bossName.height = _LABEL_H;
            _bossName.setStyle("textAlign", "right");
            _bossName.setStyle("fontWeight", "bold");
            _bossName.setStyle("color", "0xFFFFFF");
            _bossName.text = "";

            _bossHp.x      = _LABEL_BOSS_HP_X;
            _bossHp.y      = _LABEL_BOSS_HP_Y;
            _bossHp.width  = _LABEL_BOSS_W;
            _bossHp.height = _LABEL_H;
            _bossHp.setStyle("textAlign", "right");
            _bossHp.setStyle("color", "0xFFFFFF");
            _bossHp.text = "";

            _countLabel.x      = _LABEL_CNT_X;
            _countLabel.y      = _LABEL_CNT_Y;
            _countLabel.width  = _LABEL_CNT_W;
            _countLabel.height = _LABEL_CNT_H;
            _countLabel.styleName = "RaidCountLabel";
            _countLabel.filters = [new GlowFilter(0x000000, 1, 1.5, 1.5, 16, 1),];
            _countLabel.text = ProfoundInventory.battleProfoundCount.toString();

            _caption.x = _CAPTION_X;
            _caption.y = _CAPTION_Y;
            _caption.width = _CAPTION_W;
            _caption.height = _CAPTION_H;
            _caption.textColor = 0xFFFFFF;
            _caption.mouseEnabled = false;
            _caption.wordWrap = true;
            _caption.multiline = true;
            _caption.alpha = 1.0;
            _caption.htmlText = "";

            _itemsLabel.x      = _LABEL_ITEM_NAME_X;
            _itemsLabel.y      = _LABEL_ITEM_NAME_Y;
            _itemsLabel.width  = _LABEL_ITEM_NAME_W;
            _itemsLabel.height = _LABEL_H;
            _itemsLabel.setStyle("textAlign", "left");
            _itemsLabel.setStyle("color", "0xFFFFFF");
            _itemsLabel.text = "";

            var txtFormat:TextFormat = new TextFormat();
            txtFormat.align = TextFormatAlign.CENTER;
            _cntMsgText.defaultTextFormat = txtFormat;
            _cntMsgText.text = _TRANS_BTL_CNT_MSG;
            _cntMsgText.height = _LABEL_H;
            _cntMsgText.width = _cntMsgText.textWidth + 10;
            _cntMsgText.x = _LABEL_CNT_X - (_cntMsgText.textWidth / 3 * 2);
            _cntMsgText.y = _LABEL_CNT_Y + _LABEL_H;
            _cntMsgText.alpha  = 1.0;
            _cntMsgText.background = true;
            _cntMsgText.backgroundColor = 0x000000;
            _cntMsgText.textColor = 0xFFFFFF;
            _cntMsgText.border = true;
            _cntMsgText.borderColor = 0x4CE1FF;
            _cntMsgText.visible = false;
            _countLabel.addEventListener(MouseEvent.MOUSE_OVER,cntLabelMouseOverHandler);
            _countLabel.addEventListener(MouseEvent.MOUSE_OUT,cntLabelMouseOutHandler);

            _hpGauge.setHP(0,0);
            _hpGauge.visible = false;

            _timeGauge.setTime(0,0);
            _timeGauge.visible = false;
            _infoImage.limit = false;

            setRankPage(_rankPage,true);
            _ranking.updateMyRank(0,true);

            _container.addChild(_infoImage);
            _container.addChild(_prfName);
            _container.addChild(_bossName);
            _container.addChild(_bossHp);
            //_container.addChild(_countLabel);
            _container.addChild(_cntMsgText);
            _container.addChild(_closeAtTimeLabel);
            _container.addChild(_hpGauge);
            _container.addChild(_timeGauge);
            _container.addChild(_caption);
            _container.addChild(_itemsLabel);
            _ranking.getShowThread(_container,20).start();
            addChild(_container);

            _infoImage.setRankButtonFunc(rankNextButtonHandler,rankBackButtonHandler);

            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER, updateDuration);
            _time.start();
            _updateTime = new Timer(_RANKING_UPDATE_TIME);
            _updateTime.addEventListener(TimerEvent.TIMER, updateRankingHandler);
            _updateTime.start();

            RaidDataCtrl.instance.addEventListener(RaidDataCtrl.BOSS_HP_UPDATE,updateBossHPHandler);

            visible = false;
        }

        // 後始末処理
        public override function final():void
        {
            RaidDataCtrl.instance.removeEventListener(RaidDataCtrl.BOSS_HP_UPDATE,updateBossHPHandler);

            _updateTime.stop();
            _updateTime.removeEventListener(TimerEvent.TIMER, updateRankingHandler);

            _time.stop();
            _time.removeEventListener(TimerEvent.TIMER, updateDuration);

            _countLabel.removeEventListener(MouseEvent.MOUSE_OVER,cntLabelMouseOverHandler);
            _countLabel.removeEventListener(MouseEvent.MOUSE_OUT,cntLabelMouseOutHandler);

            _infoImage.getHideThread().start();
            _ranking.getHideThread().start();
            RemoveChild.apply(_container);
        }

        private function cntLabelMouseOverHandler(e:MouseEvent):void
        {
            _cntMsgText.visible = true;
        }

        private function cntLabelMouseOutHandler(e:MouseEvent):void
        {
            _cntMsgText.visible = false;
        }

        public function setButtonFunctions(startFunc:Function,giveFunc:Function,urlFunc:Function):void
        {
            _infoImage.setBossButtonFunc(startFunc,giveFunc,urlFunc);
        }

        public function set buttonVisibles(v:Boolean):void
        {
            _infoImage.bossDuelButtonVisible = v;
        }

        public function buttonVisibleCheck():void
        {
            if (_selectPrf) {
                if (_selectPrf.isFinished) {
                    _infoImage.bossDuelButtonVisible = false;
                } else {
                    _infoImage.bossDuelButtonVisible = true;
                }
            } else {
                _infoImage.bossDuelButtonVisible = false;
            }
        }

        public function setProfoundInfo(prf:Profound):void
        {
            log.writeLog(log.LV_FATAL, this,"setProfoundInfo", prf.id,prf.isFinished);
            var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(prf.id);
            _selectPrf = prf;
            if (prf.isFinished) {
                _infoImage.bossDuelButtonVisible = false;
            } else {
                _infoImage.bossDuelButtonVisible = true;
            }
            _prfName.text = prf.profoundData.name;
            _bossName.text = prf.bossName;
            _caption.htmlText = prf.profoundData.caption;
            _infoImage.limit = false;
            setBossHp();
            setTimeLimit();
            setCloseAtTime();
            setItems();
            if (prfRank) prfRank.setUpdateFunc(rankingUpdateHandler,myRankUpdateHandler);
            _rankPage = 0;
            setRankPage(_rankPage);
            if (_selectPrf) _ranking.updateMyRank(_selectPrf.id);
            visible = true;
        }

        public function clearProfoundInfo():void
        {
            log.writeLog(log.LV_FATAL, this,"clearProfound",_selectPrf);
            if (_selectPrf) {
                var prfRank:ProfoundRanking = ProfoundRanking.getProfoundRanking(_selectPrf.id);
                _infoImage.bossDuelButtonVisible = false;
                _infoImage.limit = false;
                _prfName.text = "";
                _bossName.text = "";
                _caption.htmlText = "";
                setBossHp(true);
                setTimeLimit(true);
                setItems(true);
                _hpGauge.setHP(0,0);
                _hpGauge.visible = false;
                _closeAtTimeLabel.text = "";
                if (prfRank) prfRank.setUpdateFunc(null,null);
                setRankPage(0,true);
                _ranking.updateMyRank(0,true);
                _selectPrf = null;
                visible = false;
            }
        }

        public function updateBossHp():void
        {
            setBossHp();
        }

        public function updateProfoundState(prf:Profound):void
        {
            _bossName.text = prf.bossName;
            setBossHp();
        }

        private function setCloseAtTime():void
        {
            if (_selectPrf) {
                var lastTime:String = TimeFormat.toString(_selectPrf.closeAtRestTime);
                _closeAtTimeLabel.text = _TRANS_AREA_CLOSE_AT.replace("__CLOSE_TIME__",lastTime);
            }
        }
        private function setBossHp(clear:Boolean=false):void
        {
            var nowHp:int = 0;
            var maxHp:int = 0;
            var setText:String = "";
            if (_selectPrf && !clear) {
                maxHp = _selectPrf.profoundData.coreMonsterMaxHp;
                if (maxHp > 0) nowHp = maxHp - _selectPrf.viewDamage;
                if (nowHp <= 0) nowHp = 0;
                setText = nowHp.toString() + "/" + maxHp.toString();
                _hpGauge.setHP(nowHp,maxHp);
                _hpGauge.visible = true;
                _hpGauge.getUpdateHPThread(nowHp).start();
            }
            _bossHp.text = setText;
        }
        private function setTimeLimit(clear:Boolean=false):void
        {
            if (_selectPrf && !clear) {
                var startTime:Number = _selectPrf.createdAt.getTime();
                var closeTime:Number = 0.0;
                if (_selectPrf.closeAt) closeTime = _selectPrf.closeAt.getTime();
                var nowDate:Date = new Date();
                var nowTime:Number = nowDate.getTime();
                var max:int = Math.round(closeTime-startTime);
                var now:int = Math.round(closeTime-nowTime);
                _infoImage.limit = _timeGauge.timeLimitAlert;
                _timeGauge.setTime(now,max);
                _timeGauge.visible = true;
                timeGaugeUpdate();
                _timeGaugeUpdate = true;
            } else {
                _infoImage.limit = false;
                _timeGauge.setTime(0,0);
                _timeGauge.visible = false;
                _timeGaugeUpdate = false;
            }
        }
        private function timeGaugeUpdate():void
        {
            if (_selectPrf&&_selectPrf.closeAt) {
                _infoImage.limit = _timeGauge.timeLimitAlert;
                var closeTime:Number = _selectPrf.closeAt.getTime();
                var nowDate:Date = new Date();
                var nowTime:Number = nowDate.getTime();
                var now:int = Math.round(closeTime-nowTime);
                _timeGauge.getUpdateTimeThread(now).start();
            }
        }
        private function setItems(clear:Boolean=false):void
        {
            if (_selectPrf && !clear) {
                var setTexts:Array = [];
                var setData:Array =  _selectPrf.profoundData.allItems;
                for (var  i:int  = 0; i < setData.length; i++) {
                    var t:String = "";
                    switch (setData[i]["type"])
                    {
                    case Const.TG_CHARA_CARD:
                        var cc:CharaCard = CharaCard.ID(setData[i]["id"]);
                        t = "Lv"+ cc.level + cc.name + "×"  +setData[i]["num"].toString();
                        break;
                    case Const.TG_SLOT_CARD:
                        switch (setData[i]["sctType"])
                        {
                        case Const.SCT_WEAPON:
                            t = WeaponCard.ID(setData[i]["id"]).name + "×"  +setData[i]["num"].toString();
                            break;
                        case Const.SCT_EQUIP:
                            t = EquipCard.ID(setData[i]["id"]).name + "×"  +setData[i]["num"].toString();
                            break;
                        case Const.SCT_EVENT:
                            t = EventCard.ID(setData[i]["id"]).name + "×"  +setData[i]["num"].toString();
                            break;
                        default:
                        }
                        break;
                    case Const.TG_AVATAR_ITEM:
                        t = AvatarItem.ID(setData[i]["id"]).name + "×"  +setData[i]["num"].toString();
                        break;
                    case Const.TG_AVATAR_PART:
                        t = AvatarPart.ID(setData[i]["id"]).name + "×"  +setData[i]["num"].toString();
                        break;
                    case Const.TG_GEM:
                        t = setData[i]["num"] + "Gem";
                        break;
                    case Const.TG_OWN_CARD:
                        break;
                    case Const.TG_NONE:
                    case Const.TG_BONUS_GAME:
                    default:
                    }
                    setTexts.push(t);
                }
                _itemsLabel.text = setTexts.join("、");
            } else {
                _itemsLabel.text = "";
            }
        }
        private function updateBossHPHandler(e:Event):void
        {
            log.writeLog(log.LV_DEBUG, this,"updateBossHPHandler !!!!!");
            setBossHp();
        }

        private function rankNextButtonHandler():void
        {
            // log.writeLog(log.LV_FATAL, this,"NextButtonHandler", _rankPage);
            _rankPage -= 1;
            if (_rankPage < 0) _rankPage = 0;
            setRankPage(_rankPage);
        }
        private function rankBackButtonHandler():void
        {
            // log.writeLog(log.LV_FATAL, this,"BackButtonHandler", _rankPage);
            _rankPage += 1;
            if (_rankPage >= _ranking.pageMax) _rankPage = _ranking.pageMax - 1;
            setRankPage(_rankPage);
        }
        private function rankingUpdateHandler():void
        {
            // log.writeLog(log.LV_FATAL, this,"rankingUpdateHandler");
            setRankPage(_rankPage);
        }
        private function myRankUpdateHandler():void
        {
            // log.writeLog(log.LV_FATAL, this,"myRankUpdateHandler");
            if (_selectPrf) _ranking.updateMyRank(_selectPrf.id);
        }
        private function updateRankingHandler(e:Event):void
        {
            // log.writeLog(log.LV_FATAL, this,"updateRankingHandler");
            setRankPage(_rankPage);
            if (_selectPrf) _ranking.updateMyRank(_selectPrf.id);
        }
        public function updateRanking():void
        {
            log.writeLog(log.LV_FATAL, this,"updateRanking");
            if (_selectPrf) _ranking.resetRanking(_selectPrf.id);
            setRankPage(_rankPage);
            if (_selectPrf) _ranking.updateMyRank(_selectPrf.id);
        }
        private function updateDuration(e:Event):void
        {
            setCloseAtTime();
            if (_timeGaugeUpdate) {
                timeGaugeUpdate();
            }
        }

        public function get selectProfound():Profound
        {
            return _selectPrf;
        }

        private function setRankPage(p:int,clear:Boolean=false):void
        {
            // log.writeLog(log.LV_FATAL, this,"setRankPage",clear);
            var max:int = clear ? 1 : _ranking.pageMax;
            _infoImage.setPage(p+1,max);
            if (_selectPrf) {
                _ranking.pageChange(_selectPrf.id,p,clear);
                _ranking.updateMyRank(_selectPrf.id,clear);
            }
        }

        public function updateBtlPrfCount():void
        {
            _countLabel.text = ProfoundInventory.battleProfoundCount.toString();
        }

        // 選択中の渦へのリンクを返す
        public function get selectPrfURL():String
        {
            return (_selectPrf) ? _selectPrf.prfURL : "";
        }

        public function set infoMonsId(id:int):void
        {
            //_infoImage.monsterId = id;
        }
    }
}


