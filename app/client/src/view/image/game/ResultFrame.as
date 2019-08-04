package view.image.game
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import mx.controls.*

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.Player;
    import model.events.AvatarSaleEvent;
    import view.*;
    import view.image.BaseImage;
    import controller.*;

    /**
     * 結果表示枠クラス
     *
     */
    public class ResultFrame extends BaseImage
    {

        // result表示元SWF
        [Embed(source="../../../../data/image/game/result/result.swf")]
        private var _Source:Class;


        // リザルトMCインスタンス
        private var _resultMC:Array = [];
        // インスタンスのX位置を記憶しておく
        private var _xPosition:Array = [];

        // 定数
        private static const MC_NUM_EXP:String = "num_exp";
        private static const MC_NUM_ROLL:String = "num_roll";
        private static const MC_TEXT_RESULT:String = "text_result";
        private static const SB_NEXT:String = "b_next";
        private static const SB_GET:String = "b_get";
        private static const SB_HIGH:String = "b_high";
        private static const SB_LOW:String = "b_low";
        private static const SB_HIGH_ON:String = "b_high_on";
        private static const SB_LOW_ON:String = "b_low_on";
        private static const MC_FRAME_BASE:String = "frame_base";
        private static const SB_EXIT:String = "b_exit";
        private static const SB_ITEM:String = "b_item";

        private static const MC_NUM_EXP_NO:int      = 0;
        private static const MC_NUM_ROLL_NO:int     = 1;
        private static const MC_TEXT_RESULT_NO:int  = 2;
        private static const SB_NEXT_NO:int         = 3;
        private static const SB_GET_NO:int          = 4;
        private static const SB_HIGH_NO:int         = 5;
        private static const SB_LOW_NO:int          = 6;
        private static const SB_HIGH_ON_NO:int      = 7;
        private static const SB_LOW_ON_NO:int       = 8;
        private static const MC_FRAME_BASE_NO:int   = 9;
        private static const SB_EXIT_NO:int         = 10;
        private static const SB_ITEM_NO:int         = 11;

        private static const OK:int = 0


        private var _rollNum:int = 0;           // 番号

        // ボタンイベント定数
        public static const NEXT:String = "next";        // 次のカードへ移行
        public static const GET:String = "get";          // 現在のカードを取得
        public static const HIGH:String = "high";        // アップにチャレンジ
        public static const LOW:String = "low";          // ダウンにチャレンジ
        public static const ITEM:String = "item";        // アイテムを呼び出す
        public static const EXIT:String = "exit";        // 終了


        protected var _gemsLabel:Label = new Label();                               // 獲得ジェム
        protected var _expLabel:Label = new Label();                                // 獲得経験値
        protected var _gemsBonusLabel:Label = new Label();                          // 獲得ジェム
        protected var _expBonusLabel:Label = new Label();                           // 獲得経験値
        protected var _gemsPowLabel:Label = new Label();                            // 獲得ジェム倍率
        protected var _expPowLabel:Label = new Label();                             // 獲得経験値倍率
        protected var _gemsCPowLabel:Label = new Label();                           // 獲得ジェム倍率
        protected var _expCPowLabel:Label = new Label();                            // 獲得経験値倍率
        protected var _gemsTotalLabel:Label = new Label();                          // トータル獲得ジェム
        protected var _expTotalLabel:Label = new Label();                           // トータル獲得経験値

        private static const _GEM_LABEL_X:int          = 83;                  // ジェム表示X:Base
        private static const _EXP_LABEL_X:int          = _GEM_LABEL_X;     // 経験値表示X:Base
        private static const _GEM_BONUS_LABEL_X:int    = _GEM_LABEL_X+78;      // ジェム表示X:Bonus
        private static const _EXP_BONUS_LABEL_X:int    = _EXP_LABEL_X+78;      // 経験値表示X:Bonus
        private static const _GEM_POW_LABEL_X:int      = _GEM_LABEL_X+142;      // ジェム表示X:ItemPower
        private static const _EXP_POW_LABEL_X:int      = _EXP_LABEL_X+142;      // 経験地表示X:ItemPower
        private static const _GEM_C_POW_LABEL_X:int    = _GEM_LABEL_X+222;     // ジェム表示X:CardPower
        private static const _EXP_C_POW_LABEL_X:int    = _EXP_LABEL_X+222;     // 経験地表示X:CardPoer
        // おおきいとこ +329

        private static const _LABEL_START_Y:int        = 800; //800            // ラベル表示Y:開始
        // private static const _LABEL_CENTER_Y:int       = 392;                  // ラベル表示Y:中央
        // private static const _LABEL_CENTER_Y2:int      = 437;                  // ラベル表示Y:中央2段目
        private static const _LABEL_CENTER_Y:int       = 592;                  // ラベル表示Y:中央
        private static const _LABEL_CENTER_Y2:int      = 637;                  // ラベル表示Y:中央2段目
        private static const _LABEL_UNDER_Y:int        = _LABEL_CENTER_Y+252;  // ラベル表示Y:画面下部

        private static const _LABEL_WIDTH:int          = 60;                   // ラベルの幅
        private static const _LABEL_HEIGHT:int         = 40;                   // ラベルの高さ

        private static const _GEM_TOTAL_LABEL_X:int    = 378;                  // Totalジェム表示X
        private static const _EXP_TOTAL_LABEL_X:int    = _GEM_TOTAL_LABEL_X;   // Total経験地表示X
        private static const _TOTAL_LABEL_Y:int        = 648;                  // Totalラベル表示Y:画面下部
        // private static const _TOTAL_LABEL_CENTER_Y:int = 385;                  // Totalラベル表示Y:中央
        // private static const _TOTAL_LABEL_CENTER_Y2:int= 430;                 // Totalラベル表示Y:中央2段目
        private static const _TOTAL_LABEL_CENTER_Y:int = 582;                  // Totalラベル表示Y:中央
        private static const _TOTAL_LABEL_CENTER_Y2:int= 627;                 // Totalラベル表示Y:中央2段目
        private static const _TOTAL_LABEL_WIDTH:int    = 170;                  // Totalラベルの幅

        private static const _START_TEXT_RESULT_Y:int = 800;
//        private static const _CENTER_TEXT_RESULT_Y:int = 380;
        private static const _CENTER_TEXT_RESULT_Y:int = 580;
        private static const _UNDER_TEXT_RESULT_Y:int = 632;

        private var _textDown:Boolean = false;

        private var _result:int        = 0;  // 勝敗結果 0:win 1:lose 2:draw
        private var _totalGems:int     = 0;  // Gems:合計
        private var _baseGems:int      = 0;  // Gems:Base
        private var _gemsPower:int     = 0;  // Gems:Power
        private var _gemsCardPower:int = 0;  // Gems:CardPower
        private var _totalExp:int      = 0;  // Exp:合計
        private var _baseExp:int       = 0;  // Exp:Base
        private var _expBonus:int      = 0;  // Exp:Bonus
        private var _expPower:int      = 0;  // Exp:Power
        private var _expCardPower:int  = 0;  // Exp:CardPower

        private static const _DUEL_BASE_EXP_POW:Array = [1.0,0.3,0.5]; // win,lose,draw


        /**
         * コンストラクタ
         *
         */
        public function ResultFrame()
        {
            super();

            // ラベルの設定 ============================== //
            // Base
            initLabel(_gemsLabel,_GEM_LABEL_X,_LABEL_START_Y,_LABEL_WIDTH,_LABEL_HEIGHT,false);
            initLabel(_expLabel,_EXP_LABEL_X,_LABEL_START_Y,_LABEL_WIDTH,_LABEL_HEIGHT,false);

            // Bonus
            initLabel(_gemsBonusLabel,_GEM_BONUS_LABEL_X,_LABEL_START_Y,_LABEL_WIDTH,_LABEL_HEIGHT,false);
            initLabel(_expBonusLabel,_EXP_BONUS_LABEL_X,_LABEL_START_Y,_LABEL_WIDTH,_LABEL_HEIGHT,false);

            // ItemPower
            initLabel(_gemsPowLabel,_GEM_POW_LABEL_X,_LABEL_START_Y,_LABEL_WIDTH,_LABEL_HEIGHT,false,0.0,false);
            initLabel(_expPowLabel,_EXP_POW_LABEL_X,_LABEL_START_Y,_LABEL_WIDTH,_LABEL_HEIGHT,false,0.0,false);

            // CardPower
            initLabel(_gemsCPowLabel,_GEM_C_POW_LABEL_X,_LABEL_UNDER_Y,_LABEL_WIDTH,_LABEL_HEIGHT,false,0.0,false);
            initLabel(_expCPowLabel,_EXP_C_POW_LABEL_X,_LABEL_UNDER_Y,_LABEL_WIDTH,_LABEL_HEIGHT,false,0.0,false);

            // Total
            initLabel(_gemsTotalLabel,_GEM_TOTAL_LABEL_X,_TOTAL_LABEL_Y,_TOTAL_LABEL_WIDTH,_LABEL_HEIGHT,true,0.0,false);
            initLabel(_expTotalLabel,_EXP_TOTAL_LABEL_X,_TOTAL_LABEL_Y,_TOTAL_LABEL_WIDTH,_LABEL_HEIGHT,true,0.0,false);

        }

        private function initLabel(label:Label,x:int,y:int,w:int,h:int,isTotal:Boolean,alpha:Number=1.0,visible:Boolean=true):void
        {
            label.x = x;
            label.y = y;
            label.width = w;
            label.height = h;
            label.alpha = alpha;
            label.visible = visible;
            label.setStyle("textAlign","right");
            label.styleName = "ResultLabel";

            if (isTotal) {
                label.setStyle("fontSize",40);
                label.filters = [new GlowFilter(0x000000, 1.0, 2, 2, 8, 1),];
                // label.filters = [new GlowFilter(0x000000, 1, 4, 4, 16, 1),
                //                  new DropShadowFilter(10, 270, 0x000000, 0.3, 8, 8, 1, 1, true),
                //                  new DropShadowFilter(1, 70, 0x000000, 0.7, 1, 1, 1, 1, false),];
            } else {
                label.setStyle("fontSize",30);
                label.filters = [new GlowFilter(0x000000, 1.0, 2, 2, 8, 1),];
            }
        }

        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
//             for(var i:int = 0; i < _root.numChildren; i++){
//                 log.writeLog(log.LV_FATAL, this, "name:::",_root.getChildAt(i).name);
//             }
            frameReset();
        }

        override protected function get Source():Class
        {
            return _Source;
        }

        // 初期化処理
        public function initializeResult():void
        {
            waitComplete(initializeResultComplete);
        }

        // 初期化処理
        public function initializeResultComplete():void
        {
            // かったときに呼ばれる
        }

        // 後処理
        public function frameReset():void
        {
            _resultMC = [];
            var last:int;

            last = _resultMC.push(MovieClip(_root.getChildByName(MC_NUM_EXP)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(MovieClip(_root.getChildByName(MC_NUM_ROLL)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(MovieClip(_root.getChildByName(MC_TEXT_RESULT)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(SimpleButton(_root.getChildByName(SB_NEXT)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(SimpleButton(_root.getChildByName(SB_GET)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(SimpleButton(_root.getChildByName(SB_HIGH)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(SimpleButton(_root.getChildByName(SB_LOW)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(MovieClip(_root.getChildByName(SB_HIGH_ON)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(MovieClip(_root.getChildByName(SB_LOW_ON)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(MovieClip(_root.getChildByName(MC_FRAME_BASE)));
            setPosi(_resultMC[last-1]);
            _resultMC[last-1].visible = false;

            last = _resultMC.push(SimpleButton(_root.getChildByName(SB_EXIT)));
            setPosi(_resultMC[last-1]);

            last = _resultMC.push(SimpleButton(_root.getChildByName(SB_ITEM)));
            setPosi(_resultMC[last-1]);

            // ボーナスゲームラベル
            _resultMC[MC_NUM_ROLL_NO].x = _xPosition[MC_NUM_ROLL_NO] + 1024;
            _resultMC[SB_NEXT_NO].x = _xPosition[SB_NEXT_NO];
            _resultMC[SB_GET_NO].x = _xPosition[SB_GET_NO];
            _resultMC[SB_HIGH_NO].x = _xPosition[SB_HIGH_NO] + 1024;
            _resultMC[SB_LOW_NO].x = _xPosition[SB_LOW_NO] + 1024;

            // GemとExp表示
            _resultMC[MC_TEXT_RESULT_NO].visible = false;
            _resultMC[MC_TEXT_RESULT_NO].alpha = 0.0;
            _resultMC[MC_TEXT_RESULT_NO].y = _START_TEXT_RESULT_Y;
            _gemsLabel.y = _expLabel.y = _gemsBonusLabel.y = _expBonusLabel.y  = _LABEL_START_Y;
            addChild(_gemsLabel);
            addChild(_expLabel);
            addChild(_gemsBonusLabel);
            addChild(_expBonusLabel);
            addChild(_gemsPowLabel);
            addChild(_expPowLabel);
            addChild(_gemsCPowLabel);
            addChild(_expCPowLabel);
            addChild(_gemsTotalLabel);
            addChild(_expTotalLabel);

            removeAllEventListener();
        }

        public override  function final():void
        {
            removeAllEventListener();
            _resultMC = null;
        }


        private function setPosi(d:DisplayObject):void
        {
            d.visible = false;
            _xPosition.push(d.x);
        }


        // ダイス番号をセット
        public function setRollNum(rollNum:int):void
        {
//            log.writeLog(log.LV_INFO, this, "set Roll Num!!!!!!",_resultMC[MC_NUM_ROLL_NO], rollNum);
            _rollNum = rollNum;
            _resultMC[MC_NUM_ROLL_NO].gotoAndStop(_rollNum);
//            log.writeLog(log.LV_INFO, this, "set Roll Num!!!!!!", rollNum);
        }

        public function getTextResultShowThread(gems:int, exp:int, expBonus:int, gemsPow:int, expPow:int, totalGems:int, totalExp:int, result:int):Thread
        {
            // 変数に値を保持
            _result        = result;
            _totalGems     = totalGems;
            _baseGems      = gems;
            _gemsPower     = gemsPow;
            _gemsCardPower = 100;
            _totalExp      = totalExp;
            _baseExp       = exp;
            _expBonus      = expBonus;
            _expPower      = expPow;
            _expCardPower  = 100;

            _gemsLabel.y = _expLabel.y = _gemsBonusLabel.y = _expBonusLabel.y = _LABEL_START_Y;
            _gemsLabel.text = _baseGems.toString();
            _expLabel.text = _baseExp.toString();
            _gemsBonusLabel.text = "0";
            _expBonusLabel.text = _expBonus.toString();

            // ほかの値も設定してしまう
            _gemsPowLabel.text = _gemsPower.toString();
            _expPowLabel.text = _expPower.toString();
            _gemsCPowLabel.text = _gemsCardPower.toString();
            _expCPowLabel.text = _expCardPower.toString();
            _gemsTotalLabel.text = _totalGems.toString();
            _expTotalLabel.text = _totalExp.toString();
            // _gemsTotalLabel.text = Math.floor((gems * gemsPow * 0.01)).toString();
            // _expTotalLabel.text = calcExp(getExpBase(exp),Const.DUEL_BONUS_POW*expBonus,expPow).toString();
            _gemsPowLabel.alpha = _expPowLabel.alpha = _gemsCPowLabel.alpha = _expCPowLabel.alpha = _gemsTotalLabel.alpha = _expTotalLabel.alpha = 0.0;
            _gemsPowLabel.visible = _expPowLabel.visible = _gemsCPowLabel.visible = _expCPowLabel.visible = _gemsTotalLabel.visible = _expTotalLabel.visible = false;
            _textDown = false;

            _resultMC[MC_TEXT_RESULT_NO].y = _START_TEXT_RESULT_Y;
            _resultMC[MC_TEXT_RESULT_NO].alpha = 1.0;
//            alpha = 1.0;
//            log.writeLog(log.LV_INFO, this, "get TextResult thread!!!!!!!!!!!!!!", _resultMC[MC_TEXT_RESULT_NO],_resultMC[MC_TEXT_RESULT_NO].y,_resultMC[MC_TEXT_RESULT_NO].alpha);
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_TEXT_RESULT_NO], {y:_CENTER_TEXT_RESULT_Y}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_gemsLabel, {y:_LABEL_CENTER_Y}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_expLabel, {y:_LABEL_CENTER_Y2}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_gemsBonusLabel, {y:_LABEL_CENTER_Y}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_expBonusLabel, {y:_LABEL_CENTER_Y2}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }

        // TextResultの移動
        public function getTextResultMoveThread():Thread
        {
            _textDown = true;
            log.writeLog(log.LV_INFO, this, "get TextResult Move thread!!!!!!!!!!!!!!");
            var pExec:ParallelExecutor = new ParallelExecutor();
            // pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_TEXT_RESULT_NO], {y:_UNDER_TEXT_RESULT_Y}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // pExec.addThread(new BeTweenAS3Thread(_gemsLabel, {y:_LABEL_UNDER_Y}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // pExec.addThread(new BeTweenAS3Thread(_expLabel, {y:_LABEL_UNDER_Y}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // pExec.addThread(new BeTweenAS3Thread(_gemsBonusLabel, {y:_LABEL_UNDER_Y}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // pExec.addThread(new BeTweenAS3Thread(_expBonusLabel, {y:_LABEL_UNDER_Y}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }

        // フェード
        public function getFadeThread():Thread
        {
            log.writeLog(log.LV_INFO, this, "get fade thread!!!!!!!!!!!!!!", _resultMC[MC_FRAME_BASE_NO]);
            _resultMC[MC_FRAME_BASE_NO].alpha = 0.0;
            var pExec:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_FRAME_BASE_NO], {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }

        // こんな副作用だらけの関数ありえない！
        public function setCardPowerNum(gemsCPow:int, expCPow:int, totalGems:int, totalExp:int):void
        {
            // 変数に値を保持
            _totalGems     = totalGems;
            _gemsCardPower = gemsCPow;
            _totalExp      = totalExp;
            _expCardPower  = expCPow;

            _gemsCPowLabel.text = gemsCPow.toString();
            _gemsTotalLabel.text = totalGems.toString();
            _expCPowLabel.text = expCPow.toString();
            _expTotalLabel.text = totalExp.toString();
        }

        public function getExpAndGemsShowThread():Thread
        {
//            log.writeLog(log.LV_INFO, this, "get Exp And Gems Show thread!!!!!!!!!!!!!!",_textDown);

            // if (_textDown) {
            //     _gemsPowLabel.y = _expPowLabel.y = _gemsCPowLabel.y = _expCPowLabel.y = _LABEL_CENTER_Y;
            //     _gemsTotalLabel.y = _expTotalLabel.y = _TOTAL_LABEL_Y;
            // } else {
            //     _gemsPowLabel.y = _gemsCPowLabel.y = _LABEL_CENTER_Y;
            //     _expPowLabel.y = _expCPowLabel.y = _LABEL_CENTER_Y2;
            //     _gemsTotalLabel.y =_TOTAL_LABEL_CENTER_Y;
            //     _expTotalLabel.y = _TOTAL_LABEL_CENTER_Y2;
            // }
            _gemsPowLabel.y = _gemsCPowLabel.y = _LABEL_CENTER_Y;
            _expPowLabel.y = _expCPowLabel.y = _LABEL_CENTER_Y2;
            _gemsTotalLabel.y =_TOTAL_LABEL_CENTER_Y;
            _expTotalLabel.y = _TOTAL_LABEL_CENTER_Y2;

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            var pExec3:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_gemsPowLabel, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_expPowLabel, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            sExec.addThread(pExec);

            pExec2.addThread(new BeTweenAS3Thread(_gemsCPowLabel, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec2.addThread(new BeTweenAS3Thread(_expCPowLabel, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            sExec.addThread(pExec2);

            pExec3.addThread(new BeTweenAS3Thread(_gemsTotalLabel, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec3.addThread(new BeTweenAS3Thread(_expTotalLabel, {alpha:1.0}, null, 0.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            sExec.addThread(pExec3);
            return sExec;
        }




        // Success!を呼ぶ
        public function getSuccessThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            // pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_ROLL_SUC_NO], {x:_resultMC[MC_ROLL_SUC_NO].x}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // pExec.addThread(new GoToPlayThread(_resultMC[MC_ROLL_SUC_NO]));
            // pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_ROLL_SUC_NO], {x:_resultMC[MC_ROLL_SUC_NO].x}, null, 1.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            return pExec;
        }

        // Failed!を呼ぶ
        public function getFailedThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            // pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_ROLL_FAIL_NO], {x:_resultMC[MC_ROLL_FAIL_NO].x}, null, 0.1, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            // pExec.addThread(new GoToPlayThread(_resultMC[MC_ROLL_FAIL_NO]));
            // pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_ROLL_FAIL_NO], {x:_resultMC[MC_ROLL_FAIL_NO].x}, null, 1.3, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            return pExec;
        }

        // 最終のリザルトを呼ぶ
        public function getResultThread():Thread
        {
//            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
//            var pExec2:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_NUM_ROLL_NO], {x:_xPosition[MC_NUM_ROLL_NO]-1024}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_NEXT_NO], {x:_xPosition[SB_NEXT_NO]-1024}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_GET_NO], {x:_xPosition[SB_GET_NO]-1024}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_HIGH_NO], {x:_xPosition[SB_HIGH_NO]-1024}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_LOW_NO], {x:_xPosition[SB_LOW_NO]-1024}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_EXIT_NO], {x:_xPosition[SB_EXIT_NO]-1024}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_ITEM_NO], {x:_xPosition[SB_ITEM_NO]-1024}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE));
            // pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_TEXT_GEM_NO], {x:_xPosition[MC_TEXT_GEM_NO]}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_TEXT_RESULT_NO], {x:_xPosition[MC_TEXT_RESULT_NO]}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            removeShopButton();
//            pExec2.addThread(new BeTweenAS3Thread(_resultMC[12], {alpha:0.0}, null, 0.25, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
//            sExec.addThread(pExec);
//            sExec.addThread(pExec2);

            // ボタンのイベントを外す
            removeAllEventListener();

            return pExec;
        }

        // 最終のリザルトを呼ぶ
        public function getQuestResultThread():Thread
        {
//            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
//            var pExec2:ParallelExecutor = new ParallelExecutor();

            // pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_TEXT_GEM_NO], {x:_xPosition[MC_TEXT_GEM_NO]}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_TEXT_RESULT_NO], {x:_xPosition[MC_TEXT_RESULT_NO]}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
//            pExec2.addThread(new BeTweenAS3Thread(_resultMC[12], {alpha:0.0}, null, 0.25, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
//            sExec.addThread(pExec);
//            sExec.addThread(pExec2);

            // ボタンのイベントを外す
            removeAllEventListener();

            return pExec;
        }

        // 最初のボーナスゲームを呼ぶ
        public function getBonusGameThread():Thread
        {
            _resultMC[SB_HIGH_NO].alpha = 0.0;
            _resultMC[SB_LOW_NO].alpha = 0.0;
//            _resultMC[12].alpha = 0.0;
            _resultMC[SB_NEXT_NO].alpha = 0.0;
            _resultMC[SB_GET_NO].alpha = 0.0;

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();

            pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_NUM_ROLL_NO], {x:_xPosition[MC_NUM_ROLL_NO]}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_HIGH_NO], {x:_xPosition[SB_HIGH_NO]}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_LOW_NO], {x:_xPosition[SB_LOW_NO]}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
//            pExec2.addThread(new BeTweenAS3Thread(_resultMC[12], {alpha:1.0}, null, 0.25, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_HIGH_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_LOW_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec2.addThread(new BeTweenAS3Thread(_resultMC[SB_NEXT_NO], {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec2.addThread(new BeTweenAS3Thread(_resultMC[SB_GET_NO], {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));

            sExec.addThread(pExec);
            sExec.addThread(pExec2);

            // ボタンにイベントを登録
            removeAllEventListener();
            _resultMC[SB_NEXT_NO].addEventListener(MouseEvent.CLICK, pushNextHander);
            _resultMC[SB_GET_NO].addEventListener(MouseEvent.CLICK, pushGetHander);

            return sExec;
        }

        // ボーナスチャレンジ選択スレッドを呼ぶ
        public function getSelectGameThread():Thread
        {
            _resultMC[SB_NEXT_NO].alpha = 0.0;
            _resultMC[SB_GET_NO].alpha = 0.0;

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_HIGH_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_LOW_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_HIGH_ON_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_LOW_ON_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec2.addThread(new BeTweenAS3Thread(_resultMC[SB_NEXT_NO], {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec2.addThread(new BeTweenAS3Thread(_resultMC[SB_GET_NO], {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            sExec.addThread(pExec);
            sExec.addThread(pExec2);

            // ボタンにイベントを登録
            removeAllEventListener();
            _resultMC[SB_NEXT_NO].addEventListener(MouseEvent.CLICK, pushNextHander);
            _resultMC[SB_GET_NO].addEventListener(MouseEvent.CLICK, pushGetHander);

            return sExec;
        }

        // ボーナスゲームに失敗したときのスレッドを呼ぶ
        public function getFailedSelectGameThread():Thread
        {
            _resultMC[SB_EXIT_NO].alpha = 0.0;
            _resultMC[SB_EXIT_NO].x = _xPosition[SB_EXIT_NO];
            _resultMC[SB_ITEM_NO].alpha = 0.0;
            _resultMC[SB_ITEM_NO].x = _xPosition[SB_ITEM_NO];

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_HIGH_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_LOW_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_HIGH_ON_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_LOW_ON_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec2.addThread(new BeTweenAS3Thread(_resultMC[SB_EXIT_NO], {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec2.addThread(new BeTweenAS3Thread(_resultMC[SB_ITEM_NO], {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));


            sExec.addThread(pExec);
            sExec.addThread(pExec2);
            sExec.addThread(new ClousureThread(addShopButton));

            // ボタンにイベントを登録
            removeAllEventListener();
            _resultMC[SB_EXIT_NO].addEventListener(MouseEvent.CLICK, pushExitHander);
            _resultMC[SB_ITEM_NO].addEventListener(MouseEvent.CLICK, pushItemHander);

            return sExec;
        }
          CONFIG::PAYMENT
        private function addShopButton():void
        {
            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
            addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_BONUS));
        }
          CONFIG::NOT_PAYMENT
        private function addShopButton():void
        {
//            addChild(RealMoneyShopView.onShopButton(RealMoneyShopView.TYPE_BONUS));
        }
        private function removeShopButton():void
        {
            RealMoneyShopView.offShopButton(RealMoneyShopView.TYPE_BONUS);
            Player.instance.avatar.addEventListener(AvatarSaleEvent.SALE_FINISH, saleFinishHandler);
        }

        // 2回目以降のボーナスゲームを呼ぶ
        public function getNextGameThread():Thread
        {
            _resultMC[SB_HIGH_NO].alpha = 0.0;
            _resultMC[SB_LOW_NO].alpha = 0.0;

            var sExec:SerialExecutor = new SerialExecutor();
            var pExec:ParallelExecutor = new ParallelExecutor();
            var pExec2:ParallelExecutor = new ParallelExecutor();
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_NEXT_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_GET_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_EXIT_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec.addThread(new BeTweenAS3Thread(_resultMC[SB_ITEM_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            pExec2.addThread(new BeTweenAS3Thread(_resultMC[SB_HIGH_NO], {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            pExec2.addThread(new BeTweenAS3Thread(_resultMC[SB_LOW_NO], {alpha:1.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            sExec.addThread(new ClousureThread(removeShopButton));
            sExec.addThread(pExec);
            sExec.addThread(pExec2);


            // ボタンにイベントを登録
            removeAllEventListener();
            _resultMC[SB_HIGH_NO].addEventListener(MouseEvent.CLICK, pushHighHander);
            _resultMC[SB_LOW_NO].addEventListener(MouseEvent.CLICK, pushLowHander);

            log.writeLog(log.LV_INFO, this, "next game");
            return sExec;
        }

        // Retryボタンが押された時のイベント
        private function pushNextHander(e:MouseEvent):void
        {
            // ボタンにイベントを登録
            removeAllEventListener();
            dispatchEvent(new Event(NEXT));
        }

        // Getボタンが押された時のイベント
        private function pushGetHander(e:MouseEvent):void
        {
            // ボタンにイベントを登録
            removeAllEventListener();
            dispatchEvent(new Event(GET));
        }

        // Highボタンが押された時のイベント
        private function pushHighHander(e:MouseEvent):void
        {
            removeAllEventListener();
            _resultMC[SB_HIGH_NO].alpha = 0.0;
            _resultMC[SB_HIGH_ON_NO].alpha = 1.0;
            _resultMC[SB_HIGH_ON_NO].visible = true;
            log.writeLog(log.LV_INFO, this, "push high");
            dispatchEvent(new Event(HIGH));
        }

        // Lowボタンが押された時のイベント
        private function pushLowHander(e:MouseEvent):void
        {
            removeAllEventListener();
            _resultMC[SB_LOW_NO].alpha = 0.0;
            _resultMC[SB_LOW_ON_NO].alpha = 1.0;
            _resultMC[SB_LOW_ON_NO].visible = true;
            log.writeLog(log.LV_INFO, this, "push low");
            dispatchEvent(new Event(LOW));
        }

        // Itemボタンが押された時のイベント
        private function pushItemHander(e:MouseEvent):void
        {
            removeAllEventListener();
            _resultMC[SB_EXIT_NO].addEventListener(MouseEvent.CLICK, pushExitHander);
            _resultMC[SB_ITEM_NO].addEventListener(MouseEvent.CLICK, pushItemHander);
            dispatchEvent(new Event(ITEM));
        }

        // Exitボタンが押された時のイベント
        private function pushExitHander(e:MouseEvent):void
        {
            removeAllEventListener();
            dispatchEvent(new Event(EXIT));
        }

        // セールの終了判定が出たときのハンドラ
        private function saleFinishHandler(e:AvatarSaleEvent):void
        {
            // log.writeLog (log.LV_INFO,this,"saleFinish!");
            RealMoneyShopView.hideButtonSaleMC(RealMoneyShopView.TYPE_BONUS);
            // ショップアイテムリストの更新
            RealMoneyShopView.itemReset();
        }

        // 全てのボタンのイベントをはずす
        private function removeAllEventListener():void
        {
            _resultMC[SB_NEXT_NO].removeEventListener(MouseEvent.CLICK, pushNextHander);
            _resultMC[SB_GET_NO].removeEventListener(MouseEvent.CLICK, pushGetHander);
            _resultMC[SB_HIGH_NO].removeEventListener(MouseEvent.CLICK, pushHighHander);
            _resultMC[SB_LOW_NO].removeEventListener(MouseEvent.CLICK, pushLowHander);
            _resultMC[SB_EXIT_NO].removeEventListener(MouseEvent.CLICK, pushExitHander);
            _resultMC[SB_ITEM_NO].removeEventListener(MouseEvent.CLICK, pushItemHander);
        }
        public function getWaitCompleteThread():Thread
        {
            return new WaitCompleteThread(this);
        }

        public function fadeExpAndGem():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            // pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_TEXT_GEM_NO], {alpha:0.0}, null, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
//            pExec.addThread(new BeTweenAS3Thread(_resultMC[MC_NUM_], {alpha:0.0}, null, 0.5, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true));
            return pExec;
        }
        public function showExpAndGem():void
        {
            // if (_resultMC[MC_TEXT_GEM_NO]!=null)
            // {
            //     _resultMC[MC_TEXT_GEM_NO].alpha  = 1.0;
            // }
        }

    }
}

import flash.display.*
import flash.events.Event;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.*;
import org.libspark.thread.threads.between.BeTweenAS3Thread;

import view.image.BaseImage;

class GoToPlayThread extends Thread
{
    private var _mc:MovieClip;

    public function GoToPlayThread(mc:MovieClip)
    {
        _mc = mc;
    }

    protected override function run():void
    {
        _mc.gotoAndPlay(1);
        _mc.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            //gotoAndPlay(0);
    }

    private function enterFrameHandler(e:Event):void
    {
        if (_mc.currentFrame == _mc.totalFrames-1)
        {
            _mc.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            _mc.stop();
        }
    }
}


class WaitCompleteThread extends Thread
{
    private var _bi:BaseImage;

    public function WaitCompleteThread(bi:BaseImage)
    {
        _bi = bi;
    }

    protected override function run ():void
    {
        if (_bi.loaded == false)
        {
            _bi.wait();
        }
        next(close);
    }

    private function close():void
    {

    }

}
