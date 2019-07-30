package com.potix2.utils {
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.*;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;

	public class GCWatcher extends EventDispatcher {
		public static const GARBAGE_COLLECT:String = "garbageCollect";
		private var watchedList:Dictionary;
		private var watchedNameList:Dictionary;
		private var gcChecker:Dictionary;
		private var watchTimer:Timer;
		private var count:uint;

		public function GCWatcher(interval:Number =0) {
			this.count = 0;
			watchedList = new Dictionary(true);
			watchedNameList = new Dictionary(true);
                        if (interval != 0)
                        {
                            watchTimer = new Timer(interval, 0);
                            watchTimer.addEventListener(TimerEvent.TIMER, checkAll);
                            watchTimer.start();
                        }

			gcChecker = new Dictionary(true);
			resetChecker();
		}

		public function watch(obj:Object, name:String = ""):void {
			watchedList[obj] = this.count++;
                        watchedNameList[obj] = name;
		}

		public function get watchedObjects():Array {
			var ret:Array = new Array();
			for (var key:Object in watchedList) {
				ret.push(key);
			}
			return ret;
		}

		public function get numberOfLeftObjects():uint {
			var leftObjects:Number = 0;
			for (var key:Object in watchedList) {
				leftObjects++;
                        }
			return leftObjects;
		}

		public function get numberOfLeftObjectsWithLog():uint {
			var leftObjects:Number = 0;
			for (var key:Object in watchedList) {
				leftObjects++;
                                log.writeLog(log.LV_WARN, this, "Left obj is", getQualifiedClassName(key), watchedNameList[key]);
			}
			return leftObjects;
		}



		public function get numberOfWatchedObjects():uint {
			return this.count;
		}

		private function get collectedGarbages():Boolean {
			for (var key:Object in gcChecker) {
				return false;
			}
			return true;
		}

		private function resetChecker():void {
			if ( this.collectedGarbages ) {
				gcChecker[{ dummy: "dummy"}] = true;
			}
		}

		private function checkAll(e:TimerEvent):void {
                    checkNow();
		}

                public function checkNow():void
                {
			if ( this.collectedGarbages ) {
                            GC.start();
                            System.gc();
				var leftObjects:uint = this.numberOfLeftObjects;
//				if ( leftObjects != 0 && this.count > leftObjects ) {
				if ( this.count > leftObjects ) {
					count = leftObjects;
					var ce:Event = new Event(Event.CHANGE);
					dispatchEvent(ce);
				}
				var ge:Event = new Event(GARBAGE_COLLECT);
				dispatchEvent(ge);
			}
			resetChecker();
                    
                }
	}
}
