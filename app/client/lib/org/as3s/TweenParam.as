package org.as3s{
	public dynamic class TweenParam {
		
		public var init:Number;
		public var begin:Number;
		public var value:Number;
		public var end:Number;
		public var change:Number;
		
		public function TweenParam(end:Number) {
			this.end = end;
		}
		
		public function start(begin:Number = 0):void {
			this.begin = begin;
			this.value = begin;
			this.change = end - begin;
		}
		
	}
}