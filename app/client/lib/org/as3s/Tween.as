/**
 * org.as3s.Tween
 * 
 * Tween Class for ActionScript3.0
 * 
 * Download: http://as3s.org/tween/tween.zip
 *
 * Copyright (c) 2008 Hisato Ogata
 * Licensed under the MIT License
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * @langversion ActionScript 3.0
 * @playerversion Flash 9
 * 
 * @version 2.0
 * @author Hisato Ogata
 * @see http://as3s.org/tween/
 * 
 * @example usage:
 * <listing version="3.0">
 * 
 * // Standard Tweening
 * var tween:Tween = new Tween(mc, {x:300, y:200}, fl.motion.easing.Quadratic.easeInOut, 24);
 * tween.addEventListener(Tween.UPDATE, onTweenUpdate);
 * tween.addEventListener(Tween.COMPLETE, onTweenComplete);
 * tween.start();
 *  
 * // Repeat Tweening
 * tween.repeat();		//unlimited repeat
 * tween.repeat(5); 	//repeat 5 times
 *  
 * // Time-Based Tweening
 * var tween:Tween = new Tween(mc, {x:300, y:200}, fl.motion.easing.Quadratic.easeInOut, 1, null, true);
 * 
 * // Proportional Easing
 * var tween:Tween = new Tween(mc, {x:100}, Tween.easing);
 * var tween:Tween = new Tween(mc, {x:100}, Tween.easing, 0, [0.2]);
 * 
 * // Physical Motion
 * var tween:Tween = new Tween(mc, {x:100}, Tween.uniform); 
 * var tween:Tween = new Tween(mc, {x:100}, Tween.accelerate);
 * var tween:Tween = new Tween(mc, {x:100}, Tween.bounce);
 * var tween:Tween = new Tween(mc, {x:100}, Tween.elastic);
 * 
 * // Delay
 * var tween:Tween = new Tween(mc, null, null, 24);
 * 
 * // Multi Step Tweening
 * var tween:Tween = new Tween(mc, [{x:300}, fl.motion.easing.Quadratic.easeInOut, 24], 
 *                                 [null, null, 24],
 *                                 [{y:200}, Tween.easing]);
 * 
 * // One Liner
 * Tween.start(mc, {update: onTweenUpdate, complete:onTweenComplete}, {x:300, y:200}, fl.motion.easing.Quadratic.easeInOut, 24);
 * Tween.repeat(5, mc, {update: onTweenUpdate, complete:onTweenComplete}, {x:300, y:200}, fl.motion.easing.Quadratic.easeInOut, 24);
 * 
 * </listing>
 */
  
package org.as3s {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	public class Tween extends EventDispatcher {
		
		public static const START:String  = "start";
		public static const UPDATE:String  = "update";
		public static const PAUSE:String  = "pause";
		public static const COMPLETE:String  = "complete";
		
		private static var frame:Sprite = new Sprite();
		private static var tweens:Array = new Array();
		private static var time:Number;
		
		private static function updateTween(event:Event=null):void {
			Tween.time = getTimer();
			for each (var t:Tween in Tween.tweens) {
				t.update();
			}
		}
		
		private static function addTween(tween:Tween):void {
			for each (var t:Tween in Tween.tweens) {
				if (t==tween) return;
			}
			if (Tween.tweens.length==0) {
				Tween.time = getTimer();
				Tween.frame.addEventListener(Event.ENTER_FRAME, Tween.updateTween);
			}
			Tween.tweens.push(tween);
		}
		
		private static function removeTween(tween:Tween):void {
			var i:int = Tween.tweens.length;
			while (i--) {
				if (Tween.tweens[i]==tween) {
					Tween.tweens.splice(i,1);
					return;
				}
			}
			if (Tween.tweens.length==0) {
				Tween.frame.removeEventListener(Event.ENTER_FRAME, Tween.updateTween);
			}
		}
		
		public static function start(target:Object, events:Object, ...args):Tween {
			var tween:Tween = new Tween(target);
			tween.setTween.apply(tween, args);
			for (var key:String in events) {
				if (Tween[key] != null) {
					tween.addEventListener(Tween[key], events[key]);
				}
			}
			tween.start();
			return tween;
		}
		
		public static function repeat(count:int, target:Object, events:Object, ...args):Tween {
			var tween:Tween = new Tween(target);
			tween.setTween.apply(tween, args);
			for (var key:String in events) {
				if (Tween[key] != null) {
					tween.addEventListener(Tween[key], events[key]);
				}
			}
			tween.repeat(count);
			return tween;
		}
		
		private var tweenParams:TweenParams;
		private var initParams:TweenParams;
		
		private var initArgsList:Array = new Array();
		private var argsList:Array = new Array();
		
		private var func:Function;
		private var duration:Number = Number.POSITIVE_INFINITY;
		private var args:Array = new Array();
		private var useSeconds:Boolean = false;
		
		private var repeatLength:int = 1;
		private var repeatCount:int = 0;
		
		private var initTime:Number;
		private var currentTime:Number;
		
		private var updateParams:Function;
		private var updateTime:Function;
		private var updateEvent:Event;
		
		/**
		 * The flag to check the completion of the tween
		 * 
		 */
		public function get complete():Boolean {
			if (currentTime < duration) {
				return false;
			} else if (duration > 0) {
				return true;
			} else {
				return isComplete(tweenParams);
			}
		}
		
		private function isComplete(params:Object):Boolean {
			for each (var item:Object in params) {
				if (item is TweenParam) {
					if (!item.complete) return false;
				} else {
					return isComplete(item);
				}
			}
			return true;
		}
		
		/**
		 * The Target Object that should be tweened (read only)
		 * 
		 */
		private var _target:Object;
		public function get target():Object {
			return _target;
		}
		
		/**
		 * The flag to pause tweening
		 * 
		 * @param value Set TRUE to pause tweening and set FALSE to resume tweening
		 * 
		 */
		private var _pause:Boolean = false;
		public function get pause():Boolean {
			return _pause;
		}
		public function set pause(value:Boolean):void {
			if (_pause != value) {
				_pause = value;
				if (currentTime < duration) {
					if (_pause) {
						Tween.removeTween(this);
					} else {
						if (useSeconds) initTime = Tween.time - currentTime;
						Tween.addTween(this);
					}
					dispatchEvent(new Event(Tween.PAUSE));
				}
			}
		}
		
		/**
		 * Constructor for Tween class
		 * 
		 * for Single Step Tween
		 * @param target Object that should be tweened
		 * @param params Object containing the specified parameters
		 * @param func A reference to a function with a (t, b, c, d) signature like the methods in the fl.motion.easing classes
		 * @param duration A value of the duration of the effect
		 * @param args An array of values to be passed to the easing function 
		 * @param useSeconds A flag specifying whether to use seconds instead of frames
		 * 
		 * for Multi Step Tween
		 * @param target Object that should be tweened
		 * @param argsList An array of args to be passed to 'setTween' function
		 * 
		 */	
		public function Tween(target:Object, ...args) {
			_target = target;
			if (args.length>0) setTween.apply(this, args);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (type == Tween.UPDATE) updateEvent = new Event(Tween.UPDATE);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			super.addEventListener(type, listener, useCapture);
			if (type == Tween.UPDATE) updateEvent = null;
		}
		
		private function setTweenArgs(params:Object, func:Function = null, duration:Number = 0, args:Array = null, useSeconds:Boolean = false):void {
			
			tweenParams = new TweenParams(params);

			this.func = func;
			this.duration = useSeconds ? duration*1000 : duration;
			this.args = args != null ? args.concat() : null;
			this.useSeconds = useSeconds;
			
			updateTime = useSeconds ? updateTimeBySeconds : updateTimeByFrames;
			if (tweenParams.multiLevel) {
				updateParams = args == null ? updateParamsWithoutArgsM : updateParamsWithArgsM;
			} else {
				updateParams = args == null ? updateParamsWithoutArgs : updateParamsWithArgs;
			}
						
		}
		
		
		/**
		 * set tween
		 * 
		 * for Single Step Tween
		 * @param params Object containing the specified parameters
		 * @param func A reference to a function with a (t, b, c, d) signature like the methods in the fl.motion.easing classes
		 * @param duration A value of the duration of the effect
		 * @param args An array of values to be passed to the easing function 
		 * @param useSeconds A flag specifying whether to use seconds instead of frames
		 * 
		 * for Multi Step Tween
		 * @param argsList An array of args to be passed to 'setTween' function
		 * 
		 */	
		public function setTween(...args):void {
			if (getQualifiedClassName(args[0])!="Array") args = new Array(args);
			initArgsList = args;
			reset();
		}
		
		/**
		 * Reset tweening
		 * 
		 */	
		public function reset():void {
			Tween.removeTween(this);
			argsList = initArgsList.concat();
			setTweenArgs.apply(this, argsList.shift());
		}
		
		/**
		 * Start tweening
		 * 
		 */		
		public function start():void {
			startParams(_target, tweenParams);
			pause = false;
			Tween.addTween(this);
			initTime = Tween.time;
			currentTime = 0;
			dispatchEvent(new Event(Tween.START));
		}
		
		private function startParams(target:Object, params:Object):void {
			for (var key:String in params) {
				if (params[key] is TweenParam) params[key].start(target[key]);
				else startParams(target[key], params[key]);
			}
		}
		
		/**
		 * Repeat tweening
		 * 
		 */
		public function repeat(count:int = 0):void {
			repeatLength = count; 
			repeatCount = 0;
			start();
			initParams = tweenParams;
		}
		
		private function update():void {
			updateParams(_target, tweenParams);
			if (updateEvent) dispatchEvent(updateEvent);
			if (complete) setComplete();
			updateTime();
		}
		
		private function updateParamsWithoutArgs(target:Object, params:Object):void {
			for (var key:String in params) {
				params[key].value = func.call(params[key], currentTime, params[key].begin, params[key].change, duration);
				target[key] = params[key].value;
			}
		}
		
		private function updateParamsWithArgs(target:Object, params:Object):void {
			for (var key:String in params) {
				params[key].value = func.apply(params[key], [currentTime, params[key].begin, params[key].change, duration].concat(args));
				target[key] = params[key].value;
			}
		}
		
		private function updateParamsWithoutArgsM(target:Object, params:Object):void {
			for (var key:String in params) {
				if (params[key] is TweenParam) {
					params[key].value = func.call(params[key], currentTime, params[key].begin, params[key].change, duration);
					target[key] = params[key].value;
				} else {
					updateParamsWithoutArgsM(target[key], params[key]);
					target[key] = params[key].getValue();
				}
			}
		}
		
		private function updateParamsWithArgsM(target:Object, params:Object):void {
			for (var key:String in params) {
				if (params[key] is TweenParam) {
					params[key].value = func.apply(params[key], [currentTime, params[key].begin, params[key].change, duration].concat(args));
					target[key] = params[key].value;
				} else {
					updateParamsWithArgsM(target[key], params[key]);
					target[key] = params[key].getValue();
				}
			}
		}
		
		private function updateTimeByFrames():void {
			currentTime++;
		}
		private function updateTimeBySeconds():void {
			currentTime = Tween.time - initTime;
		}
		
		private function setComplete():void {
			if (argsList.length>0) {
				setParams(_target, tweenParams);
				setTweenArgs.apply(this, argsList.shift());
				start();
			} else {
				if (repeatLength>0 && ++repeatCount>=repeatLength) {
					setParams(_target, tweenParams);
					dispatchEvent(new Event(Tween.COMPLETE));
					Tween.removeTween(this);
				} else {
					//repeat
					resetParams(_target, initParams);
					reset();
					start();
				}
			}
		}
		
		private function setParams(target:Object, params:Object):void {
			for (var key:String in params) {
				if (params[key] is TweenParam) {
					target[key] = params[key].end;
				} else {
					setParams(target[key], params[key]);
					target[key] = params[key].getEnd();
				}
			}
		}
		
		private function resetParams(target:Object, params:Object):void {
			for (var key:String in params) {
				if (params[key] is TweenParam) {
					target[key] = params[key].begin;
				} else {
					resetParams(target[key], params[key]);
					target[key] = params[key].getBegin();
				}
			}
		}
		
		
		
		/**
		 * Basic Fractional Easing Function
		 * 
	     * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 * 
		 * @param fraction Specifies the value of the fraction.
		 * @param threshold Specifies the value of the threshold of the convergence.
		 * 
		 */	
		public static var easing:Function = function(t:Number, b:Number, c:Number, d:Number, fraction:Number = 0.5, threshold:Number = 0.05):Number {
			var distance:Number = this.end - this.value;
			var v:Number = distance*fraction;
			if ((v<0 ? -v : v) < threshold) { // (v<0 ? -v : v)  is an optimization of Math.abs(v)
				this.complete = true;
				return this.end;
			} else {
				return this.value + v;
			}
		};
		
		/**
		 * Non-Accelerated Motion Function
		 * 
	     * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 * 
		 * @param v Specifies the velocity of the motion.
		 * 
		 */	
		public static var uniform:Function = function(t:Number, b:Number, c:Number, d:Number, v:Number = 1):Number {
			if (v*c<0) v = -v;
			var distance:Number = this.end - this.value;
			if (v>0 && v>distance || v<0 && v<distance) {
				this.complete = true;
				return this.end;
			} else {
				return this.value + v;
			}
		};
		
		/**
		 * Accelerated Motion Function
		 * 
	     * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 * 
		 * @param a Specifies the acceleration of the motion.
		 * @param iv Specifies the initial velocity of the motion.
 		 * 
		 */	
		public static var accelerate:Function = function(t:Number, b:Number, c:Number, d:Number, a:Number = 1, iv:Number = 0):Number {
			if (a*c<0) a = -a;
			this.v = this.v!=null ? this.v + a : iv + a; 
			var distance:Number = this.end - this.value;
			if (this.v>0 && this.v>distance || this.v<0 && this.v<distance) {
				this.complete = true;
				return this.end;
			} else {
				return this.value + this.v;
			}
		};
		
		/**
		 * Bounce Motion Function
		 * 
	     * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 * 
		 * @param a Specifies the acceleration of the motion.
		 * @param iv Specifies the initial velocity of the motion.
		 * @param reflect Specifies the reflectance　of the motion.
 		 * 
		 */	
		public static var bounce:Function = function(t:Number, b:Number, c:Number, d:Number, a:Number = 1, iv:Number = 0, reflect:Number = 1):Number {
			if (a*c<0) a = -a;
			if (this.v==null) this.v = iv; 
			var distance:Number = this.end - this.value;
			if (a>0 && this.v>0 && this.v>distance || a<0 && this.v<0 && this.v<distance) {
				if ((this.v<0 ? -this.v : this.v) <= (a<0 ? -a : a)) {
					this.complete = true;
				} else {
					this.v *= -reflect;
					this.v += a;
				}
				return this.end;
			} else {
				this.v += a;
				return this.value + this.v;
			}
		};
		
		/**
		 * Elastic Motion Function
		 * 
	     * @param t Specifies the current time, between 0 and duration inclusive.
		 * @param b Specifies the initial value of the animation property.
		 * @param c Specifies the total change in the animation property.
		 * @param d Specifies the duration of the motion.
		 * 
		 * @param k Specifies the constant of the spring.
		 * @param damper Specifies the damper of the spring.
		 * @param iv Specifies the initial velocity of the motion.
		 * @param threshold Specifies the value of the threshold of the convergence.
 		 * 
		 */	
		public static var elastic:Function = function(t:Number, b:Number, c:Number, d:Number, k:Number = 0.5, damper:Number = 0.5, iv:Number = 0, threshold:Number = 0.05):Number {
			if (this.v==null) this.v = iv; 
			var distance:Number = this.end - this.value;
			var a:Number = k*distance - damper*this.v;
			this.v += a;
			if ((this.v<0 ? -this.v : this.v) < threshold && (distance<0 ? -distance : distance) < threshold) {
				this.complete = true;
				return this.end;
			} else {
				return this.value + this.v;
			}
		};
		
	}
}