package view.image.quest
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.filters.*;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;

    import view.image.BaseImage;
    import view.utils.*;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  使用パネル
     *
     */

    public class GetSendPanel extends BaseImage
    {
        // 翻訳データ
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_0	:String = "0分";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_3	:String = "3分";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_10	:String = "10分";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_30	:String = "30分";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_60	:String = "1時間";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_120	:String = "2時間";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_240	:String = "4時間";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_480	:String = "8時間";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_960	:String = "16時間";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_1440	:String = "1日";
        CONFIG::LOCALE_JP
        private static const _TRANS_TIME_4320	:String = "3日";
        CONFIG::LOCALE_JP
        private static const _TRANS_CONFIRM	:String = "確認";

        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_0	:String = "0 minutes";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_3	:String = "3 minutes";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_10	:String = "10 minutes";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_30	:String = "30 minutes";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_60	:String = "1 hour";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_120	:String = "2 hours";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_240	:String = "4 hours";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_480	:String = "8 hours";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_960	:String = "16 hours";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_1440	:String = "1 day";
        CONFIG::LOCALE_EN
        private static const _TRANS_TIME_4320	:String = "3 days";
        CONFIG::LOCALE_EN
        private static const _TRANS_CONFIRM	:String = "Confirm";

        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_0	:String = "0分";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_3	:String = "3分";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_10	:String = "10分";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_30	:String = "30分";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_60	:String = "1小時";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_120	:String = "2小時";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_240	:String = "4小時";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_480	:String = "8小時";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_960	:String = "16小時";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_1440	:String = "1天";
        CONFIG::LOCALE_TCN
        private static const _TRANS_TIME_4320	:String = "3天";
        CONFIG::LOCALE_TCN
        private static const _TRANS_CONFIRM	:String = "確認";

        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_0	:String = "0分";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_3	:String = "3分";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_10	:String = "10分";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_30	:String = "30分";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_60	:String = "1小时";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_120	:String = "2小时";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_240	:String = "4小时";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_480	:String = "8小时";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_960	:String = "16小时";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_1440	:String = "1天";
        CONFIG::LOCALE_SCN
        private static const _TRANS_TIME_4320	:String = "3天";
        CONFIG::LOCALE_SCN
        private static const _TRANS_CONFIRM	:String = "确认";

        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_0	:String = "0분";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_3	:String = "3분";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_10	:String = "10분";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_30	:String = "30분";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_60	:String = "1시간";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_120	:String = "2시간";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_240	:String = "4시간";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_480	:String = "8시간";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_960	:String = "16시간";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_1440	:String = "1일";
        CONFIG::LOCALE_KR
        private static const _TRANS_TIME_4320	:String = "3일";
        CONFIG::LOCALE_KR
        private static const _TRANS_CONFIRM	:String = "확인";

        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_0	:String = "0 minute";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_3	:String = "3 minutes";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_10	:String = "10 minutes";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_30	:String = "30 minutes ";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_60	:String = "1 heure";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_120	:String = "2 heures";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_240	:String = "4 heures";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_480	:String = "8 heures";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_960	:String = "16 heures";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_1440	:String = "1 jour";
        CONFIG::LOCALE_FR
        private static const _TRANS_TIME_4320	:String = "3 jour";
        CONFIG::LOCALE_FR
        private static const _TRANS_CONFIRM	:String = "Confirmer";

        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_0	:String = "0分";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_3	:String = "3分";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_10	:String = "10分";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_30	:String = "30分";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_60	:String = "1時間";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_120	:String = "2時間";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_240	:String = "4時間";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_480	:String = "8時間";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_960	:String = "16時間";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_1440	:String = "1日";
        CONFIG::LOCALE_ID
        private static const _TRANS_TIME_4320	:String = "3日";
        CONFIG::LOCALE_ID
        private static const _TRANS_CONFIRM	:String = "確認";

        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_0  :String = "0นาที";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_3  :String = "3นาที";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_10 :String = "10นาที";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_30 :String = "30นาที";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_60 :String = "1ชั่วโมง";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_120    :String = "2ชั่วโมง";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_240    :String = "4ชั่วโมง";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_480    :String = "8ชั่วโมง";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_960    :String = "16ชั่วโมง";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_1440   :String = "1วัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_TIME_4320   :String = "3วัน";
        CONFIG::LOCALE_TH
        private static const _TRANS_CONFIRM :String = "ตกลง";


        // HP表示元SWF
        [Embed(source="../../../../data/image/quest/quest_search.swf")]
        private var _Source:Class;

        private static const OK:String ="ok";
        private static const CLOSE:String = "btn_search_close";


        // タイトル表示
        private var _text:Label = new Label();
        private var _text2:Label = new Label();

        private var _apLabel:Label = new Label();

        // 決定ボタン
        private var _okButton:SimpleButton;
        private var _closeButton:SimpleButton;

        private var _timerSlider:HSlider = new HSlider();
        private var _timer:int;

//        private static const TIMER_STR_SET:Array = ["0分","3分","10分","30分", "1時間","2時間","4時間","8時間","16時間","1日", "3日"];
        private static const TIMER_STR_SET:Array = [_TRANS_TIME_0,_TRANS_TIME_3,_TRANS_TIME_10,_TRANS_TIME_30,_TRANS_TIME_60,_TRANS_TIME_120,_TRANS_TIME_240,_TRANS_TIME_480,_TRANS_TIME_960,_TRANS_TIME_1440,_TRANS_TIME_4320];
        private static const TIMER_NUM_SET:Array = [0,3,10,30,1,2,4,8,16,1,3];

        private var _ap:int = 0;
        private var _okFunc:Function;
        private var _closeFunc:Function;

        // サムネイル
        private var _thumbnail:SearchThumbnail;

        /**
         * コンストラクタ
         *
         */
        public function GetSendPanel()
        {
            super();
            x = 270;
            y = 280;
//             width  = 250;
//             height = 150;
//             layout = "absolute"
////             title = "確認";
//             title = _TRANS_CONFIRM;

            _timerSlider.styleName = "TimerSlider";
            _timerSlider.width = 200;
            _timerSlider.maximum = 10;
////            _timerSlider.labels = ["3分","10分","30分", "1時間","2時間","4時間","8時間","16時間","1日", "3日"];
//            _timerSlider.labels = [_TRANS_TIME_3,_TRANS_TIME_10,_TRANS_TIME_30,_TRANS_TIME_60,_TRANS_TIME_120,_TRANS_TIME_240,_TRANS_TIME_480,_TRANS_TIME_960,_TRANS_TIME_1440,_TRANS_TIME_4320];
            _timerSlider.tickInterval = 1;
            _timerSlider.snapInterval = 1;
            _timerSlider.x = 23;
            _timerSlider.y = 80;
            _timerSlider.dataTipFormatFunction = dataTipFormatter;
            _timerSlider.addEventListener(SliderEvent.CHANGE, timerHandler);
            _timerSlider.addEventListener(SliderEvent.THUMB_DRAG, timerHandler)

            _text.x = 230;
            _text.y = 30;
            _text.width = 135;
            _text.height = 50;
            _text.text = "";
            _text.styleName = "GetSendPanelLabel";
            _text.filters = [new GlowFilter(0x000000, 0.9, 2.5, 2.5, 2, 1),];

            _text2.width = 200;
            _text2.height = 50;
//            _text2.text = "0分";
            _text2.text = _TRANS_TIME_0;
            _text2.styleName = "GetSendPanelLabel";
            _text2.filters = [new GlowFilter(0x000000, 0.7, 2, 2, 2, 1),];
            _text2.x = 25;
            _text2.y = 43;

            _apLabel.width = 28;
            _apLabel.height = 50;
            _apLabel.styleName = "GetSendPanelMapApLabel";
//            _apLabel.filters = [new GlowFilter(0x00000, 1.0, 2, 2, 2, 1),];
            _apLabel.filters = [new GlowFilter(0xFFFFFF, 1.0, 4, 4, 2, 1),];
            _apLabel.x = 100;
//             _apLabel.y = 103;
            _apLabel.y = 87;
            _apLabel.mouseEnabled = false;
            _apLabel.mouseChildren = false;
//          _apLabel.visible       = false;

            addChild(_text);
            addChild(_text2);
            addChild(_timerSlider);
            addChild(_apLabel);

//             addChild(_noButton);
        }


        protected override function get Source():Class
        {
            return _Source;
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            _okButton = SimpleButton(_root.getChildByName(OK));
            _closeButton = SimpleButton(_root.getChildByName(CLOSE));
            _okButton.addEventListener(MouseEvent.CLICK, okHandler);
            _closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
        }

        override public function final():void
        {
            _timerSlider.removeEventListener(SliderEvent.CHANGE, timerHandler);
            _timerSlider.removeEventListener(SliderEvent.THUMB_DRAG, timerHandler);
            _okButton.removeEventListener(MouseEvent.CLICK, okHandler);
            _closeButton.removeEventListener(MouseEvent.CLICK, closeHandler);
            RemoveChild.apply(_thumbnail);
            _okFunc = null;
            _closeFunc = null;
        }


        //
        public function  setOKHandler(handler:Function):void
        {
             _okFunc = handler;
        }
        public function  setCloseHandler(handler:Function):void
        {
             _closeFunc = handler;
        }

        public function setQuestMapName(str:String):void
        {
            _text.text = str;
        }

        public function setQuestMapThumbnail(i:int):void
        {
            if(_thumbnail)
            {
                removeChild(_thumbnail);
            }
            _thumbnail = new SearchThumbnail(i);
            _thumbnail.x = 252;
            _thumbnail.y = 58;
            addChild(_thumbnail);
        }


        public function setQuestMapAp(ap:int):void
        {
            _ap = ap;
            updateAp();

        }

        private function updateAp():void
        {
            if (_ap>0)
            {
                _apLabel.htmlText = _ap.toString();
            }else{
                _apLabel.htmlText = "";
            }
        }



        public function get timer():int
        {
            return _timerSlider.value;
        }

        private function dataTipFormatter(value:Number):String
        {
            return TIMER_STR_SET[int(value)]
        }

        public function timerHandler(e:SliderEvent):void
        {
            _text2.text = TIMER_STR_SET[int(e.value)];
            updateAp();
        }

        public function okHandler(e:MouseEvent):void
        {
            if (_okFunc !=null)
            {
                _okFunc();
            }

        }

        public function closeHandler(e:MouseEvent):void
        {
            if (_closeFunc !=null)
            {
                _closeFunc();
            }

        }


    }
}