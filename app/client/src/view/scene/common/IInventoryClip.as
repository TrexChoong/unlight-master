// ShowとHideのスレッド返すメソッドのインターフェイス

package view.scene.common
{
    import org.libspark.thread.Thread;
//     import flash.display.DisplayObjectContainer;
//     import org.libspark.thread.*;

    import view.image.common.*;
    import model.AvatarItem;
    import model.*;

    public interface IInventoryClip
    {
        function onEquip():void;
        function offEquip():void;
        function onSelect():void;
        function offSelect():void;
        function get avatarItem():AvatarItem;
        function get avatarItemImage():AvatarItemImage;
        function get avatarPart():AvatarPart;
        function get avatarPartIcon():AvatarPartIcon;
        function get realMoneyItem():RealMoneyItem;
        function getUpdateCount():int;
        function get price():int;
        function get coins():Array;
        function get card():ICard;
        function set price(c:int):void;
        function set coins(c:Array):void;
        function get count():int;
        function set count(c:int):void;
    }

}

