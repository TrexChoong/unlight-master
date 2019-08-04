package view.image.rmshop
{

    import flash.display.*;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;

    import mx.core.UIComponent;
    import mx.controls.*

    import model.Player;

    import view.image.BaseImage;
    import view.RealMoneyShopView;
    import view.utils.*;

    import org.libspark.thread.Thread;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;


    /**
     * EventCardValue表示クラス
     *
     */

    public class RealMoneyShopButton extends BaseImage
    {
        [Embed(source="../../../../data/image/rmshop/shop.swf")]
        private var _Source:Class;
        private static const SCALE:Number = 1.0;

        private static const SHOP_TYPE:Array = ["heal", "quest","lucky", "card", "card", "heal","quest_go","ticket", "piece", "quest_use"];

        private static const SHOP_ON_TYPE:Array = [0, 4, 2, 3, 3, 0 ,1, 5, 6];

        CONFIG::LOCALE_JP
        private static const _TRANS_AREA_SALE           :String = "残り[__SALE_TIME__]";
        CONFIG::LOCALE_EN
        private static const _TRANS_AREA_SALE           :String = "[__SALE_TIME__]";
        CONFIG::LOCALE_TCN
        private static const _TRANS_AREA_SALE           :String = "剩餘 [__SALE_TIME__]";
        CONFIG::LOCALE_SCN
        private static const _TRANS_AREA_SALE           :String = "剩余 [__SALE_TIME__]";
        CONFIG::LOCALE_KR
        private static const _TRANS_AREA_SALE           :String = "残り[__SALE_TIME__]";
        CONFIG::LOCALE_FR
        private static const _TRANS_AREA_SALE           :String = "Reste [__SALE_TIME__]";
        CONFIG::LOCALE_ID
        private static const _TRANS_AREA_SALE           :String = "残り[__SALE_TIME__]";
        CONFIG::LOCALE_TH
        private static const _TRANS_AREA_SALE           :String = "เวลาที่เหลือ[__SALE_TIME__]";


        private var _saleMC:MovieClip;
        private var _saleDiscountLabel:Label = new Label();
        private static const _LABEL_WIDTH:int  = 20;
        private static const _LABEL_HEIGHT:int = 15;

        private var _type:int =0;
        private var _buttonSet:Array = []; /* of SimpleButton */

        // セール表示用ラベル
        private var _saleRestTimeLabel:TextArea = new TextArea();
        private static const _TIME_LABEL_WIDTH:int  = 120;
        private static const _TIME_LABEL_HEIGHT:int = 20;

        // 描画コンテナ
        private var _labelContainer:UIComponent = new UIComponent();

        private var _time:Timer;
        private var _addMouseEvent:Boolean = false;

        /**
         * コンストラクタ
         *
         */
        public function RealMoneyShopButton(t:int)
        {
            _type = t;
            super();
//            log.writeLog(log.LV_FATAL, this, "++++++++++++++root is");
        }
        override protected function swfinit(event: Event): void
        {
            super.swfinit(event);
//               log.writeLog(log.LV_FATAL, this, "++++++++++++++rm root is",_root);
//               SwfNameInfo.toLog(_root)
            _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_AVATAR]))); // 0
            _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_QUEST]))); // 1
            _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_BONUS]))); // 2
            _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_CHARA_CARD]))); // 3
            _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_QUEST_PROGRESS]))); // 4
            _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_LOT]))); // 5
            _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_EX_CARD]))); // 6

            _saleMC = MovieClip(_root.getChildByName("sale"));
            _saleMC.visible = false;

            _labelContainer.mouseEnabled = false;
            _labelContainer.mouseChildren = false;
            _labelContainer.visible = false;

            _saleDiscountLabel.styleName = "ApRemainArea";
            _saleDiscountLabel.x = 13;
            _saleDiscountLabel.y = -12;
            _saleDiscountLabel.width = _LABEL_WIDTH;
            _saleDiscountLabel.height = _LABEL_HEIGHT;
            _saleDiscountLabel.text = (Const.SALE_DISCOUNT_VALUES[Player.instance.avatar.saleType]*10).toString();
            _saleDiscountLabel.setStyle("fontSize", 8);
            _saleDiscountLabel.setStyle("color", 0xFFFFFF);
            _labelContainer.addChild(_saleDiscountLabel);

            _saleRestTimeLabel.styleName = "ApRemainArea";
            _saleRestTimeLabel.width = _TIME_LABEL_WIDTH;
            _saleRestTimeLabel.height = _TIME_LABEL_HEIGHT;
            var lastTime:String = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
            _saleRestTimeLabel.text = _TRANS_AREA_SALE.replace("__SALE_TIME__",lastTime);
            _saleRestTimeLabel.alpha = 0.0;
            _saleRestTimeLabel.mouseEnabled = false;
            _saleRestTimeLabel.mouseChildren = false;
            // 作ったラベルをトップビューに突っ込む
            Unlight.INS.topContainer.parent.addChild(_saleRestTimeLabel);

            addChild(_labelContainer);

            _time = new Timer(1000);
            _time.addEventListener(TimerEvent.TIMER,updateDuration);
            _time.start();

            // 必要ならマウスオーバー、アウトイベントを付ける
            addMouseOverOutEvent();

//            _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_CHARA_CARD])));

//             _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_AVATAR_PARTS])));
//             _buttonSet.push(SimpleButton(_root.getChildByName(SHOP_TYPE[RealMoneyShopView.TYPE_QUEST_DAMAGE])));
            for(var i:int = 0; i < _buttonSet.length; i++)
            {
              var x:SimpleButton = _buttonSet[i];
                if (SHOP_ON_TYPE[_type]!=i)
                {
                    RemoveChild.apply(x);
                }
            }

        }

        override protected function get Source():Class
        {
            return _Source;
        }

        public function get sale():MovieClip
        {
            return _saleMC;
        }

        public function setViewSaleClipFlag(flag:Boolean=true):void
        {
            // 通行証用ボタンの場合は、セール関係無い
            if ( _type !=  RealMoneyShopView.TYPE_QUEST_PROGRESS) {
                _saleMC.visible = flag;
                _labelContainer.visible = flag;
            }
        }

        public function getHideSaleMCThread():Thread
        {
            var pExec:ParallelExecutor = new ParallelExecutor();
            // セール表示を隠す
            if ( _saleMC.visible == true ) {
                pExec.addThread(new BeTweenAS3Thread(_saleMC, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            }
            if ( _labelContainer.visible == true ) {
                pExec.addThread(new BeTweenAS3Thread(_labelContainer, {alpha:0.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false));
            }

            return pExec;
        }

        public function set labelX(x:int):void
        {
            _saleRestTimeLabel.x = x;
        }
        public function set labelY(y:int):void
        {
            _saleRestTimeLabel.y = y;
        }

        public function addMouseOverOutEvent():void
        {
            // 通行証用ボタンの場合は、セール関係無い
            if ( _type !=  RealMoneyShopView.TYPE_QUEST_PROGRESS) {
                if ( _addMouseEvent == false )
                {
                    if ( Player.instance.avatar.isSaleTime ) {
                        this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
                        this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
                        _addMouseEvent = true;
                    }
                } else {
                    if ( Player.instance.avatar.isSaleTime == false ) {
                        removeMouseOverOutEvent();
                    }
                }
            }
        }

        public function removeMouseOverOutEvent():void
        {
            // 通行証用ボタンの場合は、セール関係無い
            if ( _type !=  RealMoneyShopView.TYPE_QUEST_PROGRESS) {
                if ( _addMouseEvent == true )
                {
                    new BeTweenAS3Thread(_saleRestTimeLabel, {alpha:0.0}, {alpha:1.0}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ).start();
                    this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
                    this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
                    _addMouseEvent = false;
                }
            }
        }

        private function updateDuration(e:Event):void
        {
            _saleDiscountLabel.text = (Const.SALE_DISCOUNT_VALUES[Player.instance.avatar.saleType]*10).toString();
            var lastTime:String = TimeFormat.toString(Player.instance.avatar.saleLimitRestTime);
            _saleRestTimeLabel.text = _TRANS_AREA_SALE.replace("__SALE_TIME__",lastTime);
        }
        private function mouseOverHandler(e:MouseEvent):void
        {
            new BeTweenAS3Thread(_saleRestTimeLabel, {alpha:1.0}, {alpha:0.0}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,true ).start();
        }
        private function mouseOutHandler(e:MouseEvent):void
        {
            new BeTweenAS3Thread(_saleRestTimeLabel, {alpha:0.0}, {alpha:1.0}, 0.2, BeTweenAS3Thread.EASE_OUT_SINE, 0.0 ,false ).start();
        }


    }

}
