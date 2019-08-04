// ShowとHideのスレッド返すメソッドのインターフェイス

package view
{
    import flash.display.DisplayObjectContainer;

    import org.libspark.thread.*;

    public interface IViewThread
    {
        // 表示用のスレッドを返す
        function getHideThread(type:String=""):Thread;
        // 表示用のスレッドを返す
        function getShowThread(stage:DisplayObjectContainer,  at:int = -1, type:String=""):Thread;
        // 設定震度をす返
        function get depthAt():int;
        // 前処理
        function init():void;
        // 後処理
        function final():void;
    }

}

