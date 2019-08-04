package view.utils
{
    import flash.display.*;
    import flash.events.Event;
    import flash.events.*;
    import flash.ui.Keyboard;
    import flash.utils.Timer;

    import mx.containers.*;
    import mx.collections.ArrayCollection;
    import mx.controls.*;
    import mx.events.*;


    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;
    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;


    import view.scene.BaseScene;

    import controller.TitleCtrl;

    import model.Option;

    /**
     *  アナウンス用パネル
     *
     */

    public class Announce extends BaseScene
    {

        private static var __an:Announce;
        // 5分に一回チェックする
        private static const _UPDATE_TIME:int = 10*60*1000;

        // 2～1時間前ならどこかで1回
        // 1～0.5時間前なら10分に一回（3回）
        // 30～15分は5分に一回（3回）
        // 15～5分は3分に一回（3回）
        // 5分～0分30秒に一回（3回）
        // 0～-30分ずっとでている
        private static var __counter:Array = [1,3,3,3]; /* of int */ 
        private static var __delay:Array = [60*60*1000,10*60,3*60,30]; /* of int */ 
        private static const  DELAY:Array = [60*60*1000,10*60*1000,3*60*1000,30*10000]; /* of int */ 


        private static var __updateTimer:Timer;                                 // ハートビート用のタイマー
        private static var __showTimer:Timer;                                 // ハートビート用のタイマー

        // タイトル表示
        private var _textLabel:Label = new Label();
        private var _content:String;
        private var _tween:ITween;
        //背景（大）
        private  var _bg:Shape = new Shape();

        public static function init():void
        {
            __an = new Announce;
        }

        /**
         * コンストラクタ
         *
         */
        public function Announce()
        {
            super();
            _bg.graphics.beginFill(0xFFFFFF);
            _bg.graphics.drawRect(0, 0, Unlight.WIDTH, 50);
            _bg.graphics.endFill();
            _bg.y = 0;
            _bg.alpha = 0.5;
//             _bg.filters = [new GlowFilter(0xEEEEEE, 1, 0, 110, 4, 1),];

            _textLabel.x = Unlight.WIDTH;
            _textLabel.y = 5;
            _textLabel.width = Unlight.WIDTH+30;
            _textLabel.height = 50;
            _textLabel.styleName = "AnnounceLabel";
            addChild(_bg);
            addChild(_textLabel);
            alpha = 0;

            __updateTimer = new Timer(_UPDATE_TIME,0)
            __updateTimer.addEventListener(TimerEvent.TIMER, announeDataUpdateHandler);
            __updateTimer.start();

            __showTimer = new Timer(10*1000,0);
            __showTimer.addEventListener(TimerEvent.TIMER, showHandler);
            // log.writeLog(log.LV_FATAL, this, "Announce create++");
            Unlight.INS.topContainer.parent.addChild(this);
            mouseEnabled = false;
            mouseChildren = false;

            News.instance.addEventListener(News.ANNOUNCE_CHANGE, updateHandler);

        }

        // アナウンス文をセットする
        public function setText():void
        {
            // log.writeLog(log.LV_FATAL, this, "setText",News.instance.loaded);
            if (News.instance.loaded)
            {
                _textLabel.htmlText = News.announceText;
                _textLabel.validateNow();
                _textLabel.width = _textLabel.textWidth+30;
                log.writeLog(log.LV_FATAL, this, News.announceText, _textLabel.textWidth);
            }

        }

        // アナウンス間隔をアップデート
        public  function update(hide:Boolean = true):void
        {
            var now:Date = new Date();

            now.setTime(now.getTime() + (now.getTimezoneOffset() * 60 * 1000));

            var remainTime:int =  News.announceDate.valueOf() - now.valueOf();
            log.writeLog(log.LV_FATAL, this, "+++++++ update remaintime", remainTime,News.announceDate,now);
            if (remainTime > 60*60*1000)
            // 一時間以上前ならなにもしない
            {
                __showTimer.stop();
                __showTimer.reset();
//                 show();
                log.writeLog(log.LV_INFO, this, "update rstop 0", remainTime);
            }else if (remainTime > 30*60*1000)
                // 一時間以下で30分以上
            {
                // 10分に１回出す
                __showTimer.delay = 10*60*1000;
                __showTimer.reset();
                __showTimer.start();
                show();
                log.writeLog(log.LV_INFO, this, "update rstop 1", remainTime);
            }else if (remainTime >  15*60*1000)
                // 30以下で15分以上
            {
                // 5分に１回出す
                __showTimer.delay = 5*60*1000;
                __showTimer.reset();
                __showTimer.start();
                show();
                log.writeLog(log.LV_INFO, this, "update rstop 2", remainTime);
            }else if (remainTime >  5*60*1000)
                // 15以下で5分以上
            {
                // 1分に１回出す
                __showTimer.delay = 1*60*1000;
                __showTimer.reset();
                __showTimer.start();
                show();
                log.writeLog(log.LV_INFO, this, "update rstop 3", remainTime);
            }else if (remainTime >  -30*60*1000)
                // 5分以下で -30分まで
            {
                // 30秒に１回出す
                __showTimer.delay = 30*1000;
                __showTimer.reset();
                __showTimer.start();
                show();
                log.writeLog(log.LV_INFO, this, "update rstop 4", remainTime);
            }else{
                // 30分以上過ぎたら
                __showTimer.reset();
                __showTimer.stop();
                log.writeLog(log.LV_INFO, this, "update rstop 5", remainTime);
            }
        }

        public  function show(hide:Boolean = true):void
        {

            if(_textLabel.htmlText.length >0 && (_tween==null || !(_tween.isPlaying)))
            {
                log.writeLog(log.LV_FATAL, this, "Announce show");
                _tween = BetweenAS3.serial(
                    BetweenAS3.addChild(this,Unlight.INS.topContainer.parent),
                    BetweenAS3.tween(this,
                                     { alpha:1.0},
                                     { alpha:0.0},
                                     0.5,
                                     Sine.easeIn),
                    BetweenAS3.tween(_textLabel,
                                     { x:-_textLabel.width},
                                     { x:Unlight.WIDTH},
                                     _textLabel.width/80,
                                     Linear.linear),
                    BetweenAS3.tween(this,
                                     { alpha:0.0},
                                     { alpha:1.0},
                                     0.5,
                                     Sine.easeIn),
                    BetweenAS3.removeFromParent(__an)
                     );
                _tween.play();
            }
        }

        private  function updateHandler(e:Event):void
        {
            setText();
            update();
        }

        private  function announeDataUpdateHandler(e:Event):void
        {
            News.getText();
        }

        private  function showHandler(e:Event):void
        {
           update();
//            show();
        }



    }
}
