// ShowとHideのスレッド返すメソッドのインターフェイス

package view.image.item
{
    import flash.display.DisplayObjectContainer;

    import org.libspark.thread.*;

    public interface IInventoryBaseImage
    {
        function onUse():void;
        function offUse():void;
        function backButtonsEnable(b:Boolean):void;
        function nextButtonsEnable(b:Boolean):void;

    }

}

