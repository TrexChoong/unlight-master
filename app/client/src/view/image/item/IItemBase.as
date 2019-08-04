// ShowとHideのスレッド返すメソッドのインターフェイス

package view.image.item
{
    import flash.display.DisplayObjectContainer;

    import org.libspark.thread.*;

    public interface IItemBase
    {
        function onEquip():void;
        function offEquip():void;
        function onSelect():void;
        function offSelect():void;

    }

}

