// アバターパーツセットを持っているオブジェ用のインターフェイス

package model
{
    import org.libspark.thread.*;

//     import flash.display.DisplayObjectContainer;

//     import org.libspark.thread.*;

    public interface IDeck
    {
        // キャラカードを取得
        function get name():String;
        // キャラカードIDを取得
        function get cardInventories():Array;
    }

}

