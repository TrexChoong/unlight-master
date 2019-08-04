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

    import view.image.common.AvatarItemImage;
    import view.image.item.*;

    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ItemInventoryClipの表示クラス
     * 
     */

    public class WindowItemInventoryClip extends ItemInventoryClip
    {

        /**
         * コンストラクタ
         *
         */
        public function WindowItemInventoryClip(avatarItem:AvatarItem,invData:ItemInventoryClipData=null)
        {
            super(avatarItem,false,invData);
        }

        protected override function initAvatarItemImage():void
        {
            // アイテムを作成
            _avatarItemImage = new AvatarItemImage(_inventoryData.image, _inventoryData.imageFrame);
            _avatarItemImage.x = 20;
            _avatarItemImage.y = 20;
            _avatarItemImage.scaleX = 0.2;
            _avatarItemImage.scaleY = 0.2;

        }

        protected override function initItemBaseImage():void
        {
            _itemInventoryBaseImage = new WindowItemInventoryBaseImage();
        }

        protected override function setLabel():void
        {

            // カウンターを作成
            _countLabel.x = 10;
            _countLabel.y = 32;
            _countLabel.width = 40;
            _countLabel.height = 20;
            _countLabel.text = "x" + _inventoryData.count;
            _countLabel.styleName = "ItemListNumeric";
            _countLabel.setStyle("color", 0xFFFFFF);
            _countLabel.filters = [new GlowFilter(0x000000, 1.0, 3, 3, 2, 1),];

        }



    }
}


