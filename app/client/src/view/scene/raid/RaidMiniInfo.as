package view.scene.raid
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.filters.*;
    import flash.utils.*;
    import mx.core.*;
    import mx.controls.Label;

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
    public class RaidMiniInfo extends BaseScene
    {
        // コントローラー
        private var _ctrl:RaidCtrl = RaidCtrl.instance;

        protected var _container:UIComponent = new UIComponent();       // 表示コンテナ

        private var _infoImage:RaidMiniInfoImage = new RaidMiniInfoImage();

        // 選択中の渦
        private var _selectPrf:Profound = null;

        // 渦の情報
        private var _bossName:Label = new Label();
        private var _hpLabel:Label = new Label();
        private var _bossHp:Label = new Label();
        private var _hpGauge:BossMiniHPGauge = new BossMiniHPGauge();

        private const _LABEL_X:int = 5;
        private const _NAME_Y:int = 3;
        private const _HP_Y:int = 21;
        private const _LABEL_W:int = 140;
        private const _LABEL_H:int = 20;
        private const _POS_REDUCE_X:int = 60;
        private const _POS_ADD_Y:int = 15;

        /**
         * コンストラクタ
         *
         */
        public function RaidMiniInfo()
        {
            mouseEnabled = false;
            mouseChildren = false;
        }

        public override function init():void
        {
            _bossName.x      = _LABEL_X;
            _bossName.y      = _NAME_Y;
            _bossName.width  = _LABEL_W;
            _bossName.height = _LABEL_H;
            _bossName.setStyle("textAlign", "left");
            _bossName.setStyle("color", "0xFFFFFF");
            _bossName.text = "";

            _hpLabel.x      = _LABEL_X;
            _hpLabel.y      = _HP_Y;
            _hpLabel.width  = _LABEL_W;
            _hpLabel.height = _LABEL_H;
            _hpLabel.setStyle("textAlign", "left");
            _hpLabel.setStyle("color", "0x000000");
            _hpLabel.text = "HP";

            _bossHp.x      = _LABEL_X;
            _bossHp.y      = _HP_Y;
            _bossHp.width  = _LABEL_W;
            _bossHp.height = _LABEL_H;
            _bossHp.setStyle("textAlign", "center");
            _bossHp.setStyle("color", "0xFFFFFF");
            _bossHp.text = "";

            _hpGauge.setHP(0,0);
            _hpGauge.visible = true;

            _container.addChild(_infoImage);
            _container.addChild(_bossName);
            _container.addChild(_hpLabel);
            _container.addChild(_bossHp);
            _container.addChild(_hpGauge);
            addChild(_container);
            _container.visible = false;

            RaidDataCtrl.instance.addEventListener(RaidDataCtrl.BOSS_HP_UPDATE,updateBossHPHandler);
        }

        // 後始末処理
        public override function final():void
        {
            RaidDataCtrl.instance.removeEventListener(RaidDataCtrl.BOSS_HP_UPDATE,updateBossHPHandler);
            RemoveChild.apply(_container);
        }

        public function setProfoundInfo(prf:Profound,posX:int,posY:int):void
        {
            log.writeLog(log.LV_FATAL, this,"setProfoundInfo", prf.id,posX,posY,prf.bossCharaId - ProfoundData.PROFOUND_BOSS_START_CHARA_ID);
            _selectPrf = prf;
            _bossName.text = prf.bossName;
            setBossHp();
            _infoImage.monsterId = _selectPrf.bossCharaId - ProfoundData.PROFOUND_BOSS_START_CHARA_ID + 1;

            _container.x = posX - _POS_REDUCE_X;
            _container.y = posY + _POS_ADD_Y;

            _container.visible = true;
        }
        public function clearProfoundInfo():void
        {
            if (_selectPrf) {
                _bossName.text = "";
                setBossHp(true);
                _infoImage.monsterId = 0;
                _hpGauge.setHP(0,0);
                _hpGauge.visible = false;
                _selectPrf = null;
            }

            _container.visible = false;
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
        private function updateBossHPHandler(e:Event):void
        {
            log.writeLog(log.LV_FATAL, this,"updateBossHPHandler");
            setBossHp();
        }

        public function get selPrfId():int
        {
            return (_selectPrf) ? _selectPrf.id : 0;
        }

    }
}


