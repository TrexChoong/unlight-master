/*
  * ActionScript Thread Library
  * 
  * Licensed under the MIT License
  * 
  * Copyright (c) 2008 BeInteractive! (www.be-interactive.org) and
  *                    Spark project  (www.libspark.org)
  * 
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to deal
  * in the Software without restriction, including without limitation the rights
  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  * copies of the Software, and to permit persons to whom the Software is
  * furnished to do so, subject to the following conditions:
  * 
  * The above copyright notice and this permission notice shall be included in
  * all copies or substantial portions of the Software.
  * 
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  * THE SOFTWARE.
  * 
  */
package org.libspark.thread.threads.between
{

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.tweens.ITween;
    import org.libspark.betweenas3.easing.*;
    import org.libspark.betweenas3.core.easing.IEasing;
    import org.libspark.betweenas3.events.TweenEvent;
    import flash.display.DisplayObject;
    import org.libspark.thread.IMonitor;
    import org.libspark.thread.Monitor;
    import org.libspark.thread.Thread;
    import flash.utils.getTimer;

    public class BeTweenAS3Thread extends Thread
    {
        public static const EASE_OUT_SINE:IEasing  = Sine.easeOut;
        public static const EASE_IN_SINE:IEasing  = Sine.easeIn;
        public static const LINEAR:IEasing  = Linear.linear;
        public static const EASE_IN_EXPO:IEasing  = Expo.easeIn;
        public static const EASE_OUT_EXPO:IEasing  = Expo.easeOut;
        public static const EASE_IN_QUAD:IEasing  = Quad.easeIn;
        public static const EASE_OUT_QUAD:IEasing  = Quad.easeOut;
        public static const EASE_IN_QUART:IEasing  = Quart.easeIn;
        public static const EASE_OUT_QUART:IEasing  = Quart.easeOut;
        public static const EASE_OUT_BOUNCE:IEasing  = Bounce.easeOut;
        public static const EASE_IN_OUT_BOUNCE:IEasing  = Bounce.easeInOut;
        /**
         * 新しい TweenerThread クラスのインスタンスを作成します.
         * 
         * @param      target  Tweener に渡す、トゥイーンのターゲット
         * @param      to    Tweener に渡す、トゥイーンの引数
         * @param      from    Tweener に渡す、トゥイーンの引数
         */
        private var _target:Object;
        private var _to:Object;
        private var _startTime:uint;
        private var _monitor:IMonitor;
        private var _tween:ITween;
        private var _visible:Boolean;

        public function BeTweenAS3Thread(target:Object, to:Object, from:Object = null, time:Number = 1.0, easing:IEasing = null, delay:Number = 0.0, visible:Boolean =true)
        {
            _target = target;
            _to = to;
            _tween = BetweenAS3.tween(_target, _to, from, time, easing);
            if (delay > 0.0)
            {
                _tween =  BetweenAS3.delay(_tween, delay)
            }

            _monitor = new Monitor();
            _visible = visible;
            _tween.addEventListener(TweenEvent.COMPLETE, completeHandler);
//            log.writeLog(log.LV_FATAL, this, "create between",_target, _to, time, easing);
        }

        /**
         * @private
         */
        override protected function run():void
        {
            if (_visible == true) {
                if (_target is DisplayObject) {
                    DisplayObject(_target).visible = true;
                }
                else {
                    if ('visible' in _target) {
                        _target.visible = true;
                    }
                }
            }

            _tween.play();
//            log.writeLog(log.LV_FATAL, this, "play between",_tween);
            waitTween();

        }

        /**
         * @private
         */
        private function waitTween():void
        {
            _monitor.wait();
            interrupted(interruptedHandler);
        }

        /**
         * @private
         */
        private function completeHandler(e:TweenEvent):void
        {
//            log.writeLog(log.LV_FATAL, this, "complete between");
            if (_visible == false) {
                if (_target is DisplayObject) {
                    DisplayObject(_target).visible = false;
                }
                else {
                    if ('visible' in _target) {
                        _target.visible = false;
                    }
                }
            }
            _tween.removeEventListener(TweenEvent.COMPLETE, completeHandler);
            _monitor.notifyAll();
            notifyAll();
        }

        /**
         * @private
         */
        private function interruptedHandler():void
        {
            _monitor.notifyAll();
            _tween.removeEventListener(TweenEvent.COMPLETE, completeHandler);
            _tween.stop();
            _tween = null;
        }
    }
}
