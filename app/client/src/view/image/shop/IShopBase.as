// ShowとHideのスレッド返すメソッドのインターフェイス

package view.image.shop
{
    import flash.display.DisplayObjectContainer;

    import org.libspark.thread.*;

    public interface IShopBase
    {
        function onEquip():void;
        function offEquip():void;
        function onSelect():void;
        function offSelect():void;
        function onTitle():void;
        function offTitle():void;

    }

}

