package view.scene.item
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import flash.utils.Dictionary;

    import flash.filters.DropShadowFilter;
    import flash.geom.*;

    import mx.core.UIComponent;
    import mx.core.ClassFactory;
    import mx.containers.*;
    import mx.controls.*;
    import mx.collections.ArrayCollection;

    import org.libspark.thread.*;
    import org.libspark.thread.utils.*;
    import org.libspark.thread.threads.between.BeTweenAS3Thread;

    import model.*;
    import model.events.AvatarItemEvent;


    import view.*;
    import view.utils.*;
    import view.image.BaseImage;
    import view.image.common.AvatarItemImage;
    import view.image.item.*;
    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.scene.common.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * BaseinventoryClipの表示クラス
     * 
     */

    public class BaseInventoryClip extends BaseScene  implements IInventoryClip
    {

        /**
         * コンストラクタ
         *
         */
        public function BaseInventoryClip()
        {
            // アバターアイテムを保存

        }

        // 装備する
        public function onEquip():void
        {
        }

        // 装備を外す
        public function offEquip():void
        {
        }

        // 選択する
        public function onSelect():void
        {
        }

        // 装備を外す
        public function offSelect():void
        {
        }

        // 
        public function get avatarItem():AvatarItem
        {
            return null;
        }

        // 
        public function get avatarItemImage():AvatarItemImage
        {
            return null;
        }

        // 
        public function get avatarPart():AvatarPart
        {
            return null;
        }

        // 
        public function get avatarPartIcon():AvatarPartIcon
        {
            return null;
        }

        // 
        public function get realMoneyItem():RealMoneyItem
        {
            return null;
        }

        // 
        public function get count():int
        {
            return 0;
        }

        // 
        public function set count(c:int):void
        {

        }

        // 
        public function get coins():Array
        {
            return [0,0,0,0,0];
        }

        // 
        public function set coins(c:Array):void
        {
        }

        // 
        public function get price():int
        {
            return 0;
        }

        // 
        public function set price(c:int):void
        {
        }


        public function get card():ICard
        {
            return null;
        }

        public function getUpdateCount():int
        {
            return 0;
        }

    }
}

