package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.LocalConnection;

    public class GC
    {
        private static var sprite:Sprite = new Sprite();

        public static function start():void {
            try {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            } catch (e:*) {}
        }

        public static function watch(value:Object, callback:Function = null):GCItem {
            var item:GCItem = new GCItem(value);
            value = null;
            sprite.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
                    if (!item.target) {
                        callback && callback();
                        e.target.removeEventListener(e.type, arguments.callee);
                    }
                });
            return item;
        }
    }
}

