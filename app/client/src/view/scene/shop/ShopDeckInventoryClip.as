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
    import view.scene.common.*;
    import view.scene.common.IInventoryClip;

    import view.scene.BaseScene;
    import view.scene.ModelWaitShowThread;
    import view.*;
    import view.utils.*;
    import view.scene.item.*;

    import controller.LobbyCtrl;
    import controller.*;

    /**
     * ShopDeckInventoryClipの表示クラス
     * 
     */
    public class ShopDeckInventoryClip extends ShopBaseInventoryClip
    {
        public function ShopDeckInventoryClip(card:*,url:String="",state:int=0,frame:int=0)
        {
            super(card,ShopBaseItemClip.BASE_TYPE_DECK,state,false,url,frame);
        }
    }
}
