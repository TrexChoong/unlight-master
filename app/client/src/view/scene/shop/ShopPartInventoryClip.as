package view.scene.shop
{
    import flash.display.*;
    import flash.filters.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import flash.utils.Dictionary;

    import flash.filters.GlowFilter;
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
    import view.image.shop.*;

    import view.scene.BaseScene;
    import view.scene.item.PartInventoryClip;
    import view.scene.ModelWaitShowThread;
    import view.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ShopPartInventoryClipの表示クラス
     * 
     */
    public class ShopPartInventoryClip extends ShopBaseInventoryClip
    {
        public function ShopPartInventoryClip(avatarItem:AvatarPart,state:int=0)
        {
            super(avatarItem,ShopBaseItemClip.BASE_TYPE_PART,state);
        }
    }

}

