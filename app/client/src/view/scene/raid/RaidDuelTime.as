package view.scene.raid
{

    import flash.display.*;
    import flash.filters.*;
    import flash.events.*;
    import flash.utils.*;

    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Profound;

    import view.WaitThread;
    import view.scene.BaseScene;
    import view.image.game.PassiveSkillBarImage;

    /**
     * レイドデュエル中タイム表示クラス
     *
     */
    public class RaidDuelTime extends BaseScene
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG	:String = "渦戦闘可能残り時間です。";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG	:String = "Time remaining for this vortex battle.";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG	:String = "渦戰鬥僅存可能時間。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG	:String = "漩涡战斗的剩余时间。";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG	:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG	:String = "Voici le temps qu'il vous reste pour cette bataille de Vortex.";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG	:String = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG	:String = "ยังเหลือเวลาต่อสู้กับน้ำวน";  // 渦戦闘可能残り時間です。

        CONFIG::LOCALE_JP
        private static const _TRANS_FIN_MSG:String = "戦闘を終了します";
        CONFIG::LOCALE_EN
        private static const _TRANS_FIN_MSG:String = "The battle is over.";
        CONFIG::LOCALE_TCN
        private static const _TRANS_FIN_MSG:String = "戰鬥結束";
        CONFIG::LOCALE_SCN
        private static const _TRANS_FIN_MSG:String = "战斗结束";
        CONFIG::LOCALE_KR
        private static const _TRANS_FIN_MSG:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_FIN_MSG:String = "Fin de la bataille.";
        CONFIG::LOCALE_ID
        private static const _TRANS_FIN_MSG:String = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_FIN_MSG:String = "จุดจบของการต่อสู้"; // 戦闘を終了します

        private var _selectPrf:Profound;
        private var _limitLabel:Label = new Label();
        private var _finLabel:Label = new Label();

        private var _time:Timer;

        private const _LABEL_X:int = 620;
        private const _LABEL_Y:int = 30;
        private const _LABEL_W:int = 150;
        private const _LABEL_H:int = 30;

        // チップヘルプの設定（上記HELPステート分必要）
        private var  _helpTextArray:Array =
            [
                [_TRANS_MSG],     // 0
            ];
        // チップヘルプを設定される側のUIComponetオブジェクト
        private var _toolTipOwnerArray:Array = [];
        // チップヘルプのステート
        private const _TIME_HELP:int   = 0;

        public function RaidDuelTime():void
        {
            initilizeToolTipOwners();
        }

        public override function init():void
        {
            updateHelp(_TIME_HELP);

            _limitLabel.styleName = "ResultLabel";
            _limitLabel.setStyle("fontSize", 24);
            _limitLabel.setStyle("textAlign", "center");
            _limitLabel.x = _LABEL_X;
            _limitLabel.y = _LABEL_Y;
            _limitLabel.width = _LABEL_W;
            _limitLabel.height = _LABEL_H;
            _limitLabel.filters  = [new GlowFilter(0x000000, 1, 1, 1, 8, 1),
                                    new DropShadowFilter(8, 270, 0x000000, 0.1, 4, 4, 1, 1, true),
                                    new DropShadowFilter(2, 45, 0x000000, 0.5, 1, 1, 1, 1, false),];
            _limitLabel.text = "";
            _limitLabel.visible = false;

            _finLabel.styleName = "FeatInfoLabel";
            _finLabel.setStyle("fontSize", 14);
            _finLabel.setStyle("textAlign", "center");
            _finLabel.x = _LABEL_X;
            _finLabel.y = _LABEL_Y;
            _finLabel.width = _LABEL_W;
            _finLabel.height = _LABEL_H;
            _finLabel.filters  = [new GlowFilter(0x000000, 1, 1, 1, 8, 1),
                                  new DropShadowFilter(8, 270, 0x000000, 0.1, 4, 4, 1, 1, true),
                                  new DropShadowFilter(2, 45, 0x000000, 0.5, 1, 1, 1, 1, false),];
            _finLabel.text = "";
            _finLabel.visible = false;

            setLimitTime();
            addChild(_limitLabel);
            addChild(_finLabel);

            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER, updateDuration);
            _time.start();
        }

        public override function final():void
        {
            _time.stop();
            _time.removeEventListener(TimerEvent.TIMER, updateDuration);
        }

        // ツールチップが必要なオブジェクトをすべて追加する
        private function initilizeToolTipOwners():void
        {
            _toolTipOwnerArray.push([0,this]);  //
        }

        //
        protected override function get helpTextArray():Array /* of String or Null */
        {
            return _helpTextArray;
        }

        protected override function get toolTipOwnerArray():Array /* of String or Null */
        {
            return _toolTipOwnerArray;
        }

        public function getBringOnThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_limitLabel, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_finLabel, {alpha:1.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }
        public function getBringOffThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_limitLabel, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_finLabel, {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }

        public function set selProfound(prf:Profound):void
        {
            log.writeLog(log.LV_DEBUG, this,"set selProfound");
            _selectPrf = prf;
            setLimitTime();
        }

        private function setLimitTime():void
        {
            log.writeLog(log.LV_DEBUG, this,"setLimitTime",_selectPrf);
            if (_selectPrf) {
                var restTime:Number = _selectPrf.closeAtRestTime;
                if (restTime > 0.0) {
                    _limitLabel.text = TimeFormat.toString(_selectPrf.closeAtRestTime);
                    _finLabel.text = "";
                } else {
                    _limitLabel.text = "";
                    _finLabel.text = _TRANS_FIN_MSG;
                }
            }
        }

        private function updateDuration(e:Event):void
        {
            setLimitTime();
        }

    }

}