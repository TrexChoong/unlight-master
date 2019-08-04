package view.image.common
{

    import flash.display.*;
    import flash.filters.GlowFilter;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.text.*;
    import mx.core.UIComponent;
    import mx.controls.Text;
    import mx.controls.*;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Avatar;
    import model.events.AvatarSaleEvent;
    import view.image.BaseImage;
    import controller.LobbyCtrl;
    import view.utils.*;
    import view.RealMoneyShopView;

    /**
     * ActionPointGauge表示クラス
     *
     */

   public class ActionPointGauge extends BaseImage
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG		:String = "次の回復まであと";
        CONFIG::LOCALE_JP
        private static const _TRANS_HOUR	:String = "時間";
        CONFIG::LOCALE_JP
        private static const _TRANS_MIN		:String = "分";
        CONFIG::LOCALE_JP
        private static const _TRANS_SEC		:String = "秒";
        CONFIG::LOCALE_JP
        private static const _TRANS_MSG2	:String = "です";
        CONFIG::LOCALE_JP
        private static const _TRANS_APMAX	:String = "現在APはMAXです";

        CONFIG::LOCALE_EN
        private static const _TRANS_MSG		:String = "";
        CONFIG::LOCALE_EN
        private static const _TRANS_HOUR	:String = "h ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MIN		:String = "min ";
        CONFIG::LOCALE_EN
        private static const _TRANS_SEC		:String = "sec ";
        CONFIG::LOCALE_EN
        private static const _TRANS_MSG2	:String = "until AP renewal.";
        CONFIG::LOCALE_EN
        private static const _TRANS_APMAX	:String = "Your AP are full.";

        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG		:String = "到下一次回復還剩";
        CONFIG::LOCALE_TCN
        private static const _TRANS_HOUR	:String = "小時";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MIN		:String = "分鐘";
        CONFIG::LOCALE_TCN
        private static const _TRANS_SEC		:String = "秒";
        CONFIG::LOCALE_TCN
        private static const _TRANS_MSG2	:String = "。";
        CONFIG::LOCALE_TCN
        private static const _TRANS_APMAX	:String = "現在的AP是最大值。";

        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG		:String = "距离下次恢复还有";
        CONFIG::LOCALE_SCN
        private static const _TRANS_HOUR	:String = "小时";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MIN		:String = "分";
        CONFIG::LOCALE_SCN
        private static const _TRANS_SEC		:String = "秒";
        CONFIG::LOCALE_SCN
        private static const _TRANS_MSG2	:String = "。";
        CONFIG::LOCALE_SCN
        private static const _TRANS_APMAX	:String = "现在的AP是上限值";

        CONFIG::LOCALE_KR
        private static const _TRANS_MSG		:String = "다음 회복까지 앞으로 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_HOUR	:String = "시간";
        CONFIG::LOCALE_KR
        private static const _TRANS_MIN		:String = "분";
        CONFIG::LOCALE_KR
        private static const _TRANS_SEC		:String = "초 ";
        CONFIG::LOCALE_KR
        private static const _TRANS_MSG2	:String = "남았습니다.";
        CONFIG::LOCALE_KR
        private static const _TRANS_APMAX	:String = "현재 AP는 MAX입니다.";

        CONFIG::LOCALE_FR
        private static const _TRANS_MSG		:String = "";
        CONFIG::LOCALE_FR
        private static const _TRANS_HOUR	:String = " h ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MIN		:String = " min ";
        CONFIG::LOCALE_FR
        private static const _TRANS_SEC		:String = " sec ";
        CONFIG::LOCALE_FR
        private static const _TRANS_MSG2	:String = "avant rétablissement";
        CONFIG::LOCALE_FR
        private static const _TRANS_APMAX	:String = "AP au Maximum";

        CONFIG::LOCALE_ID
        private static const _TRANS_MSG		:String = "次の回復まであと";
        CONFIG::LOCALE_ID
        private static const _TRANS_HOUR	:String = "時間";
        CONFIG::LOCALE_ID
        private static const _TRANS_MIN		:String = "分";
        CONFIG::LOCALE_ID
        private static const _TRANS_SEC		:String = "秒";
        CONFIG::LOCALE_ID
        private static const _TRANS_MSG2	:String = "です";
        CONFIG::LOCALE_ID
        private static const _TRANS_APMAX	:String = "現在APはMAXです";

        CONFIG::LOCALE_TH
        private static const _TRANS_MSG     :String = "เหลืออีก";
        CONFIG::LOCALE_TH
        private static const _TRANS_HOUR    :String = "ชั่วโมง";
        CONFIG::LOCALE_TH
        private static const _TRANS_MIN     :String = "นาที";
        CONFIG::LOCALE_TH
        private static const _TRANS_SEC     :String = "";
        CONFIG::LOCALE_TH
        private static const _TRANS_MSG2    :String = "วินาทีจะฟื้นพลัง";
        CONFIG::LOCALE_TH
        private static const _TRANS_APMAX   :String = "AP ปัจจุบันเต็มแล้ว";



        // CharaCardFrame表示元SWF
        [Embed(source="../../../../data/image/avatar/social_ap.swf")]
        private var _Source:Class;
        private var _frame:int;

        private const MASK:String = "ap_mask"
        private const GUAGE:String = "ap_gauge"
        private const POINT:String = "point"
        private var _apMaskMC:MovieClip;
        private var _apGuageMC:MovieClip;
        private var _apPointMC:MovieClip;
        private var _time:Timer;
        private var _remainLabel:TextArea = new TextArea();

//         private static const _LABEL_X:int = -68;
//         private static const _LABEL_Y:int = 12;
        private static const _LABEL_X:int  = -145;
        private static const _LABEL_Y:int = 280;

        private static const _LABEL_WIDTH:int = 120;
        private static const _LABEL_HEIGHT:int = 20;


        private var _interval:int = 3600;
        private var _remainTime:int = 1800;
        private var _ctrl:LobbyCtrl;
        private var _avatar:Avatar;

        /**
         * コンストラクタ
         *
         */
        public function ActionPointGauge()
        {
            super();
            _time = new Timer(1000);
            _ctrl = LobbyCtrl.instance;
//             mouseEnabled = false;
//             mouseChildren = false;
            addChild(_remainLabel);
            _remainLabel.x = _LABEL_X;
            _remainLabel.y = _LABEL_Y;
            _remainLabel.width = _LABEL_WIDTH;
            _remainLabel.height = _LABEL_HEIGHT;
            _remainLabel.htmlText = "testestets";
            _remainLabel.styleName= "ApRemainArea";
            _remainLabel.alpha = 0;
            _remainLabel.mouseEnabled= false;
            _remainLabel.mouseChildren= false;
            _remainLabel.selectable = false;
        }

        public function set avatar(a:Avatar):void
        {
            _avatar = a;
            setRemainTime();
        }

        override protected function swfinit(event: Event):void
        {
            super.swfinit(event);
            _apMaskMC =  MovieClip(_root.getChildByName(MASK));
            _apGuageMC = MovieClip( _root.getChildByName(GUAGE));
            _apMaskMC.visible = false;
            _apGuageMC.mask = _apMaskMC;
            _apGuageMC.scaleY = 0.0;
//            SwfNameInfo.toLog(_root);
            RemoveChild.apply(_apPointMC);
        }
        public override function init():void
        {
            _time.addEventListener(TimerEvent.TIMER, updateHandler);
            this.addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
            this.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
        }
        override protected function get Source():Class
        {
            return _Source;
        }

        public function setRemainTime():void
        {
//            log.writeLog(log.LV_WARN, this, "++n",n);
            waitComplete(updateGuage);
            if (_avatar.remainTime <=0){
                if (_avatar.isEnergyMax)
                {
                    _time.stop();
//                    log.writeLog(log.LV_WARN, this, "++updateend");
//                    _ctrl.avatarUpdateCheck();
                }else{
                    //                  log.writeLog(log.LV_WARN, this, "++updatecheck with gauge",_avatar.remainTime, _avatar.isEnergyMax);
                    _ctrl.avatarUpdateCheck();
                }
            }else{
                _time.start();
            }

        }

        CONFIG::PAYMENT
        public function updateGuage():void
        {
            var i:Number  = (_avatar.energy/_avatar.energyMax);
            _apGuageMC.scaleY= i*0.98;
            _remainLabel.htmlText = timeFormating(_avatar.remainTime);
            if(_avatar.energy< 3||i<0.1)
            {
                addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_AVATAR));
            }else{
                RealMoneyShopView.offShopButton(RealMoneyShopView.TYPE_AVATAR);
            }

        }

        CONFIG::NOT_PAYMENT
        public function updateGuage():void
        {
            var i:Number  = (_avatar.energy/_avatar.energyMax);
            _apGuageMC.scaleY= i*0.98;
            _remainLabel.htmlText = timeFormating(_avatar.remainTime);
        }


        private function timeFormating(remain:int):String
        {
            var s:int = remain;
            // (0になってもまだMAX出なければ予定の値を入れる)
            if (remain==0&&!_avatar.isEnergyMax)
            {
                s = _avatar.recoveryInterval;
            }
            // MAXだったら0を入れる
            if (_avatar.isEnergyMax)
            {
                s = 0;
            }

            _remainLabel.width = _LABEL_WIDTH;
            _remainLabel.x = _LABEL_X;
            var str:String;
//            log.writeLog(log.LV_FATAL, this, "++++ test",s);
            if (s>=1)
            {
                var ret:Array = [];
                var min:int;
                var hour:int;
                var sec:int;
//                ret.push("次の回復まで後")
                ret.push(_TRANS_MSG)
                hour =int(s/(60*60))%24;
                if (s>=60*60)
                {
//                    ret.push(hour.toString()+"時間");
                    ret.push(hour.toString()+_TRANS_HOUR);
                    _remainLabel.width +=20;
                    _remainLabel.x -=20;
                }
                min = int(s/60)%60;
                if (s>=60)
                {
                    _remainLabel.width +=18;
                    _remainLabel.x -=18;
//                    ret.push(min.toString()+"分");
                    ret.push(min.toString()+_TRANS_MIN);
                }
                sec = int(s)%60;
//                ret.push(sec.toString()+"秒");
                ret.push(sec.toString()+_TRANS_SEC);
                _remainLabel.x -=18;
                _remainLabel.width +=18;
//                ret.push("です")
                ret.push(_TRANS_MSG2)
                _remainLabel.width +=20;
                _remainLabel.x -=20;
                str =  ret.join("");

            }else{
//                    str = "現在APはMAXです";
                    str = _TRANS_APMAX;
            }
//            log.writeLog(log.LV_FATAL, this, "++++ test",str);
            return str;
        }

        public function updateHandler(e:TimerEvent):void
        {
            _avatar.remainTime -=1
            setRemainTime();
        }

        public function stopUpdateTimer():void
        {
            _time.stop();
        }

        public function startUpdateTimer():void
        {
            _time.start();
        }

        public override function final():void
        {
            _time.removeEventListener(TimerEvent.TIMER, updateHandler);
            this.removeEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
            this.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
            _avatar.removeEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
        }

        private function mouseOverHandler(e:Event):void
        {
            if (this.parent != null)
            {
                this.parent.addChild(_remainLabel);
            }

            new BeTweenAS3Thread(_remainLabel, {alpha:1.0}, {alpha:0.0}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ).start();
        }
        private function mouseOutHandler(e:Event):void
        {
            new BeTweenAS3Thread(_remainLabel, {alpha:0.0}, {alpha:1.0}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ).start();
        }

        // セールの終了判定が出たときのハンドラ
        private function saleFinishHandler(e:AvatarSaleEvent):void
        {
            // log.writeLog (log.LV_INFO,this,"saleFinish!");
            RealMoneyShopView.hideButtonSaleMC(RealMoneyShopView.TYPE_AVATAR);
            // ショップアイテムリストの更新
            RealMoneyShopView.itemReset();
        }


    }

}
