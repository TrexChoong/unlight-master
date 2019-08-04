package view.utils
{
    import flash.display.*;

    public class RemoveChild extends Object
    {

        public static function apply(d:DisplayObject):void
        {
            if (d !=null&&d.parent != null) {d.parent.removeChild(d)}

        }

        public static function all(d:DisplayObjectContainer):void
        {
            var len:int = d.numChildren;
            for(var i:int = len-1; i > -1; i--){
                d.removeChildAt(i);
            }
        }

    }

}