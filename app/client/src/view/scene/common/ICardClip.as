// ShowとHideのスレッド返すメソッドのインターフェイス

package view.scene.common
{
    import org.libspark.thread.Thread;
//     import flash.display.DisplayObjectContainer;
//     import org.libspark.thread.*;

    import model.ICardInventory;

    public interface ICardClip
    {
        // 関連づけられたインベントリを返す
        function set cardInventory(inv:ICardInventory):void;
        function get cardInventory():ICardInventory;
//        function getEditHideThread():Thread;
    }

}

