// アバターパーツセットを持っているオブジェ用のインターフェイス

package model
{
    import org.libspark.thread.*;

//     import flash.display.DisplayObjectContainer;

//     import org.libspark.thread.*;

    public interface IAvatarParts
    {
        // 装備済みのアイテムを返す
        function getEquipedParts():Array;
        function getWaitEquipedPartsDataThread():Thread;

    }

}

