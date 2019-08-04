package view.image.requirements
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import view.ClousureThread;
    import view.image.BaseImage;
    import view.utils.SwfNameInfo;
    import controller.*;

    /**
     * 結果表示枠クラス
     *
     */
    public class GrowthDetailImage extends BaseImage
    {
        public static const TYPE_WEAPON:int = 0;
        public static const TYPE_CHARA:int  = 1;

        // result表示元SWF
        [Embed(source="../../../../data/image/compo/compo_detail.swf")]
        private var _Source:Class;


        // 必要カードの種類
        private var _num:int = 0;
        private const COMPO_BUTTON:String = "b_key";
        private const DETAIL:String = "detail";

        private const BTN_BIT:String = "btn_bit";
        private const SALE:String = "sale";

        private const BTN_FORTUNE:String = "btn_fortune";
        private const BTN_RESET:String = "btn_reset";

        private const BTN_UPDOWN_LIST_NUM:int = 5;
        private const BTN_10UP_LIST:Array   = ["btn_a_10_u","btn_b_10_u","btn_c_10_u","btn_d_10_u","btn_e_10_u"];
        private const BTN_10DOWN_LIST:Array = ["btn_a_10_d","btn_b_10_d","btn_c_10_d","btn_d_10_d","btn_e_10_d"];
        private const BTN_1UP_LIST:Array    = ["btn_a_1_u","btn_b_1_u","btn_c_1_u","btn_d_1_u","btn_e_1_u"];
        private const BTN_1DOWN_LIST:Array  = ["btn_a_1_d","btn_b_1_d","btn_c_1_d","btn_d_1_d","btn_e_1_d"];

        private var _compoButton:SimpleButton;
        private var _main:MovieClip;

        private var _bitBtn:SimpleButton;
        private var _sale:MovieClip;

        private var _bitBtnFunc:Function;

        private var _fortuneBtn:SimpleButton;
        private var _resetBtn:SimpleButton;

        private var _btn10upList:Array = [];
        private var _btn10downList:Array = [];
        private var _btn1upList:Array = [];
        private var _btn1downList:Array = [];

        private var _btn10upFunc:Function;
        private var _btn10downFunc:Function;
        private var _btn1upFunc:Function;
        private var _btn1downFunc:Function;

        private var _type:int = TYPE_CHARA;
        private var _nowFrame:int = 0;

        /**
         * コンストラクタ
         *
         */
        public function GrowthDetailImage(type:int=TYPE_CHARA)
        {
            _type = type;
            super();
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
            var compoDetail:MovieClip = MovieClip(_root.getChildByName("compo_detail"));
            compoDetail.gotoAndStop(_type+1);

            if (SimpleButton(_root.getChildByName("btn_bit")))  {
                SimpleButton(_root.getChildByName("btn_bit")).visible = false;
            }
            if (MovieClip(_root.getChildByName("sale"))) {
                MovieClip(_root.getChildByName("sale")).visible = false;
            }

            if (_type == TYPE_WEAPON) {
                _fortuneBtn = SimpleButton(compoDetail.getChildByName(BTN_FORTUNE));
                _resetBtn = SimpleButton(compoDetail.getChildByName(BTN_RESET));

                _fortuneBtn.visible = false;
                _resetBtn.visible = false;

                for (var i:int = 0;i < BTN_UPDOWN_LIST_NUM; i++) {
                    var btn10up:SimpleButton = SimpleButton(compoDetail.getChildByName(BTN_10UP_LIST[i]));
                    var btn10down:SimpleButton = SimpleButton(compoDetail.getChildByName(BTN_10DOWN_LIST[i]));
                    var btn1up:SimpleButton = SimpleButton(compoDetail.getChildByName(BTN_1UP_LIST[i]));
                    var btn1down:SimpleButton = SimpleButton(compoDetail.getChildByName(BTN_1DOWN_LIST[i]));
                    btn10up.addEventListener(MouseEvent.CLICK,btn10upHandler);
                    btn10down.addEventListener(MouseEvent.CLICK,btn10downHandler);
                    btn1up.addEventListener(MouseEvent.CLICK,btn1upHandler);
                    btn1down.addEventListener(MouseEvent.CLICK,btn1downHandler);
                    btn10up.visible = false;
                    btn10down.visible = false;
                    btn1up.visible = false;
                    btn1down.visible = false;
                    _btn10upList.push(btn10up);
                    _btn10downList.push(btn10down);
                    _btn1upList.push(btn1up);
                    _btn1downList.push(btn1down);
            }
            }
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // データをセット
        public function setDetail(num:int):void
        {
            _num = num;
            if(_num)
            {
                visible = true;
                //waitComplete(setDetailComplete);
            }
            else
            {
                visible = false;
            }
        }
        // データをセット
        public function setDetailComplete():void
        {
            log.writeLog(log.LV_INFO, this, "set detail num", _num);
            // 必要カードの枚数を設定
            //MovieClip(_root.getChildByName("compo_detail")).gotoAndStop(_num);
            if (_nowFrame != _type+1) {
                log.writeLog(log.LV_DEBUG, this, "change frame", _type,_nowFrame);
                // MovieClip(_root.getChildByName("compo_detail")).gotoAndStop(_type+1);
                _nowFrame = _type+1;
            }
//            _main.gotoAndStop(_num);
        }

        // ボタンを取得
        public function get unlock():SimpleButton
        {
            return _compoButton;
//             log.writeLog(log.LV_INFO, this, "button ", _root.getChildAt(0));
//             return SimpleButton(_root.getChildAt(0));
//             log.writeLog(log.LV_INFO, this, "button ", _root);
//             return SimpleButton(_root)
        }

        public function get resetBtn():SimpleButton
        {
            return _resetBtn;
        }

        public function setNumBtnFunc(func10up:Function,func10down:Function,func1up:Function,func1down:Function):void
        {
            _btn10upFunc = func10up;
            _btn10downFunc = func10down;
            _btn1upFunc = func1up;
            _btn1downFunc = func1down;
        }
        public function numBtnShow(idx:int, num:int, max:int):void
        {
            log.writeLog(log.LV_DEBUG, this, "numBtnShow", idx,num,max);
            if(num >= max&&num == 1)
            {
                _btn1upList[idx].visible =false;
                _btn1downList[idx].visible =false;
                _btn10upList[idx].visible =false;
                _btn10downList[idx].visible =false;
            }
            else if(num >= max)
            {
                _btn1upList[idx].visible =false;
                _btn1downList[idx].visible =true;
                _btn10upList[idx].visible =false;
                _btn10downList[idx].visible =true;
            }else if(num <= 1)
            {
                _btn1upList[idx].visible =true;
                _btn1downList[idx].visible =false;
                _btn10upList[idx].visible =true;
                _btn10downList[idx].visible =false;
            }else{
                _btn1upList[idx].visible =true;
                _btn1downList[idx].visible =true;
                _btn10upList[idx].visible =true;
                _btn10downList[idx].visible =true;
            }


        }
        public function numBtnHide():void
        {
            for (var i:int = 0;i < BTN_UPDOWN_LIST_NUM; i++) {
                _btn1upList[i].visible =false;
                _btn1downList[i].visible =false;
                _btn10upList[i].visible =false;
                _btn10downList[i].visible =false;
            }
        }

        private function btn10upHandler(e:MouseEvent):void
        {
            var idx:int = _btn10upList.indexOf(e.currentTarget);
            log.writeLog(log.LV_DEBUG, this, "button 10up", idx);
            if (_btn10upFunc != null) {
                _btn10upFunc(idx);
            }
        }
        private function btn10downHandler(e:MouseEvent):void
        {
            var idx:int = _btn10downList.indexOf(e.currentTarget);
            log.writeLog(log.LV_DEBUG, this, "button 10down", idx);
            if (_btn10downFunc != null) {
                _btn10downFunc(idx);
            }
        }
        private function btn1upHandler(e:MouseEvent):void
        {
            var idx:int = _btn1upList.indexOf(e.currentTarget);
            log.writeLog(log.LV_DEBUG, this, "button 1up", idx);
            if (_btn1upFunc != null) {
                _btn1upFunc(idx);
            }
        }
        private function btn1downHandler(e:MouseEvent):void
        {
            var idx:int = _btn1downList.indexOf(e.currentTarget);
            log.writeLog(log.LV_DEBUG, this, "button 1down", idx);
            if (_btn1downFunc != null) {
                _btn1downFunc(idx);
            }
        }
    }
}

// import flash.display.*
// import flash.events.Event;

// import org.libspark.thread.Thread;
// import org.libspark.thread.utils.*;
// import org.libspark.thread.threads.between.BeTweenAS3Thread;

// class GetCompleteThread extends Thread
// {
//     private var _mc:MovieClip;

//     public function GoToPlayThread(mc:MovieClip)
//     {
//         _mc = mc;
//     }

//     protected override function run():void
//     {
//         if()
//         _mc.gotoAndPlay(0);
//         _mc.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
//         next(run);
//     }

//     private function enterFrameHandler(e:Event):void
//     {
//         if (_mc.currentFrame == _mc.totalFrames-1)
//         {
//             _mc.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
//             _mc.stop();
//         }
//     }
// }
