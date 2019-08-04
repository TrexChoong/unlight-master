// アバターパーツセットを持っているオブジェ用のインターフェイス

package model
{
    import org.libspark.thread.*;

//     import flash.display.DisplayObjectContainer;

//     import org.libspark.thread.*;

    public interface ICardInventory
    {
        // インベントリIDを取得
        function get inventoryID():int;
        // キャラカードを取得
        function get card():ICard;
        // キャラカードIDを取得
        function get cardId():int;
        // デッキ番号を取得
        function get index():int;
        // 書き換えフラグを取得
        function get dirtyFlag():int;
        // デッキ番号を設定
        function set index(index:int):void;

        // ポジション番号取得
        function get position():int;

        // ポジション番号を設定
        function set position(index:int):void;

        // ポジション番号取得
        function get cardPosition():int;
        // カード内ポジション番号を設定
        function set cardPosition(index:int):void;

    }

}

