package view.scene.common
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    import org.libspark.thread.*;

    import mx.containers.*;
    import mx.controls.*;
    import mx.core.UIComponent;

    import view.scene.BaseScene;
    import view.image.common.*;

    /**
     * スクロールバーのクラス
     *
     */
    public class ScrollBar extends BaseScene
    {
        private var _stage:Sprite;                     // 親ステージ

        private var _range:Number;                     // スクロール出来る長さ

        private var _position:Number;                  // スクロールバーの位置
        private var _percent:Number;                   // スクロールのパーセント(0.00～1.00)

        private var _dataCap:Number = -1;              // 1画面に表示できるデータの限界
        private var _dataAll:Number = -1;              // 全体のデータ数

        private var _bg:Box = new Box();               // スクロールバーの枠組み
        private var _bar:ScrollBarBase = new ScrollBarBase();        // スクロールバー本体(ボタンで代用)
        private var _up:ScrollBarUp = new ScrollBarUp();             // スクロールバーを上げるボタン
        private var _down:ScrollBarDown = new ScrollBarDown();       // スクロールバーを下げるボタン

        private var _timer:Timer = new Timer(10,1);    // マウスホイール用アニメーションタイマー

        public static const UPDATE:String = 'update';

        private static const _BAR_SIZE:int = 15;        // スクロールバーのサイズ

        /**
         * コンストラクタ
         *
         */
        public function ScrollBar()
        {
            addChild(_bg);
            addChild(_bar);
            addChild(_up);
            addChild(_down);
        }

        // 初期化
        public override function init():void
        {
            _up.addEventListener(MouseEvent.CLICK, clickUpHandler);
            _down.addEventListener(MouseEvent.CLICK, clickDownHandler);
            _bar.addEventListener(MouseEvent.MOUSE_DOWN, pressBarHandler);
            _bar.addEventListener(MouseEvent.MOUSE_UP, releaseBarHandler);
            parent.addEventListener(MouseEvent.MOUSE_WHEEL, wheelBarHandler);
            Unlight.INS.addEventListener(MouseEvent.MOUSE_UP, releaseBarHandler);
        }

        // 後処理
        public override function final():void
        {
            _up.removeEventListener(MouseEvent.CLICK, clickUpHandler);
            _down.removeEventListener(MouseEvent.CLICK, clickDownHandler);
            _bar.removeEventListener(MouseEvent.MOUSE_DOWN, pressBarHandler);
            _bar.removeEventListener(MouseEvent.MOUSE_UP, releaseBarHandler);
            _timer.removeEventListener(TimerEvent.TIMER, timerHandler);
            Unlight.INS.removeEventListener(MouseEvent.MOUSE_UP, releaseBarHandler);
        }

        // 1画面に表示できるデータの限界を設定
        public function set dataCap(d:Number):void
        {
            _dataCap = d;
            barUpdate();
        }

        // 1画面に表示できるデータの限界を取得
        public function get dataCap():Number
        {
            return _dataCap;
        }

        // 全データの数を設定
        public function set dataAll(d:Number):void
        {
            _dataAll = d;
            barUpdate();

            // ドラッグをやめる
            _bar.stopDrag();
            removeEventListener(Event.ENTER_FRAME, updateBarHandler);
        }

        // 全てのデータの数を設定
        public function get dataAll():Number
        {
            return _dataAll;
        }

        // パーセントの取得
        public function get percent():Number
        {
            return _percent > 0.99 ? 1.0 : _percent;
        }

        // プロパティのオーバーライド
        public override function set x(_x:Number):void
        {
            _bar.x = _bg.x = _up.x = _down.x = _x;
        }
        public override function set y(_y:Number):void
        {
            _bg.y = _up.y = _y;
            barUpdate();
        }
        public override function set height(h:Number):void
        {
            _bg.height = h;
            barUpdate();
        }
        public override function set width(w:Number):void
        {
            _bg.width = _bar.width = _up.width = _down.width = w;
            barUpdate();
        }
        public override function set alpha(a:Number):void
        {
            _bar.alpha = _bg.alpha = a;
        }

        // スクロールバーの更新
        public function barUpdate():void
        {
            _down.y = _bg.y + _bg.height - _bg.width + 3;
            _bar.y = _bg.y + _bg.width;

            // スクロールバーの長さの計算
            if(_dataCap >= _dataAll)
            {
                _bar.visible = _up.visible = _down.visible = false;
                _bar.height = _up.height = _down.height = 0;
            }
            else
            {
                _bar.visible = _up.visible = _down.visible = true;
                _up.height = _down.height = _bg.width;
                _bar.height = _bg.height * (_dataCap / _dataAll) - _up.height - _down.height;
            }

            _bar.scaleY = _bar.height / _BAR_SIZE;

            if(_bar.scaleY < 1.0)
            {
                _bar.scaleY = 1.0;
                // 余白の計算
                _range = int(_bg.height - _BAR_SIZE - _up.height - _down.height);

            }
            else
            {
                // 余白の計算
                _range = int(_bg.height - _bar.height - _up.height - _down.height);
            }
        }

        // スクロールバーを押した状態時の処理
        private function pressBarHandler(e:MouseEvent):void
        {
            _bar.startDrag(false, new Rectangle(_bg.x, _bg.y + _up.height, 0, _range));
            addEventListener(Event.ENTER_FRAME, updateBarHandler);
        }

        // スクロールバーを離した状態時の処理
        private function releaseBarHandler(e:MouseEvent):void
        {
            _bar.stopDrag();
            removeEventListener(Event.ENTER_FRAME, updateBarHandler);
        }

        // スクロールバーをホイールした状態時の処理
        private function wheelBarHandler(e:MouseEvent):void
        {
            if(_dataCap < dataAll)
            {
                if(e.delta > 0)
                {
                    clickUpHandler(e);
                }
                else if(e.delta < 0)
                {
                    clickDownHandler(e);
                }
                parent.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelBarHandler);
                _timer.addEventListener(TimerEvent.TIMER, timerHandler);
                _timer.start();
            }
        }

        //ホイールハンドラをセットする
        private function timerHandler(t:TimerEvent):void
        {
            parent.addEventListener(MouseEvent.MOUSE_WHEEL, wheelBarHandler);
            _timer.removeEventListener(TimerEvent.TIMER, timerHandler);
        }


        // 上ボタンをクリックしたときのイベント
        private function clickUpHandler(e:MouseEvent):void
        {
            _bar.y -= _bg.height / _dataAll;

            if(_bar.y < _bg.y + _up.height)
            {
                _bar.y = _bg.y + _up.height;
            }

            updatePercent();
        }

        // 下ボタンをクリックしたときのイベント
        private function clickDownHandler(e:MouseEvent):void
        {
            _bar.y += _bg.height / _dataAll;

            if(_bar.y > _bg.y + _up.height + _range)
            {
                _bar.y = _bg.y + _up.height + _range;
            }

            updatePercent();
        }

        // スクロールバーをアップデート
        private function updateBarHandler(e:Event):void
        {
            updatePercent();
        }

        // パーセント値を更新
        private function updatePercent():void
        {
//             log.writeLog(log.LV_INFO, this, "_bar.height", _bar.height);

            _position = _bar.y - _bg.y - _down.height;
            _percent = _position / _range;

//             log.writeLog(log.LV_INFO, this, "position, bar.y, bg.y, down.height", _position, _bar.y, _bg.y, _down.height);
//             log.writeLog(log.LV_INFO, this, "scroll percent, range", _percent, _range);

            dispatchEvent(new Event(UPDATE));
        }

        // 表示用のスレッドを返す
        public override function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread
        {
            _depthAt = at;
            return new ShowThread(this, stage);
        }

        // 表示用のスレッドを返す
        public override function getHideThread(type:String=""):Thread
        {
            return new HideThread(this);
        }
    }
}


import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

import org.libspark.thread.Thread;
import org.libspark.thread.utils.ParallelExecutor;

import view.scene.common.ScrollBar;
import view.BaseShowThread;
import view.BaseHideThread;


// 基本的なShowスレッド
class ShowThread extends BaseShowThread
{

    public function ShowThread(sb:ScrollBar, stage:DisplayObjectContainer)
    {
        super(sb, stage);
    }

    protected override function run():void
    {
        addStageAt();
        next(close);
    }
}

// 基本的なHideスレッド
class HideThread extends BaseHideThread
{
    public function HideThread(sb:ScrollBar)
    {
        super(sb);
    }

}
