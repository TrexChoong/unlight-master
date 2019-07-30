package org.as3s{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public dynamic class TweenParams {
		
		private var className:String;
		
		private var _multiLevel:Boolean = false;
		public function get multiLevel():Boolean {
			return _multiLevel;
		}
		
		public function TweenParams(params:Object) {
			className = getQualifiedClassName(params);
			if (className=="Object" || className=="Array") {
				for (var key:String in params) {
					this[key] = setParam(params[key]);
				}
			} else {
				for each(var accessor:XML in describeType(params).accessor.(@access="readwrite"&&@type=="Number")) {
					key = accessor.@name;
					this[key] = setParam(params[key]);
				}
				for each(var variable:XML in describeType(params).variable) {
					key = variable.@name;
					this[key] = setParam(params[key]);
				}
			}
		}
		
		private function setParam(value:*):* {
			if (value is Number) {
				return new TweenParam(value);
			} else {
				_multiLevel = true;
				return new TweenParams(value);
			}
		}
		
		public function getValue():* {
			var cls:Class = getDefinitionByName(className) as Class;
			var instance:Object = new cls();
			for (var key:String in this) {
				if (this[key] is TweenParams) instance[key] = this[key].getValue();
				else instance[key] = this[key].value;
			}
			return instance;
		}
		
		public function getBegin():* {
			var cls:Class = getDefinitionByName(className) as Class;
			var instance:Object = new cls();
			for (var key:String in this) {
				if (this[key] is TweenParams) instance[key] = this[key].getBegin();
				else instance[key] = this[key].begin;
			}
			return instance;
		}
		
		public function getEnd():* {
			var cls:Class = getDefinitionByName(className) as Class;
			var instance:Object = new cls();
			for (var key:String in this) {
				if (this[key] is TweenParams) instance[key] = this[key].getEnd();
				else instance[key] = this[key].end;
			}
			return instance;
		}
		
	}
}