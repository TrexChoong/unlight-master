// カードモデルの共通インターフェイス定義

package model
{
    import org.libspark.thread.*;

//     import flash.display.DisplayObjectContainer;

//     import org.libspark.thread.*;

    public interface ICard
    {
        function get id():int;
        function get name():String;
        function get abName():String;
        function get level():int;
        function get hp():int;
        function get ap():int;
        function get dp():int;
        function get rarity():int;
        function get kind():int;
        function set num(i:int):void;
        function get num():int;
        function get caption():String;
        function get bookExist():Boolean;
        function get color():int;
        function get cost():int;
        function get restriction():Array;
        function get type():int;

    }

}

