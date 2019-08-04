package view.scene.item
{
    import model.*;
    import view.image.item.*;

    /**
     * BodyListPanelの表示クラス
     * 
     */

    public class ClothListPanel extends BodyListPanel
    {
        protected override function get partsGenre():int
        {
            return  AvatarPart.GENRE_CLOTH;
        }

        protected override function setButton():void
        {
            if (!_itemDic[_selectItem.avatarPart].equiped)
            {
                itemInventoryPanelImage.onUse();
                itemInventoryPanelImage.offRemove();
            }else{
                itemInventoryPanelImage.offUse();
                itemInventoryPanelImage.onRemove();
            }
            if(Player.instance.avatar.checkMaxPartInventory)
            {
                log.writeLog(log.LV_FATAL, this, "set button drop on");
                ItemInventoryPanelImage(itemInventoryPanelImage).onDrop();
            }else{
                ItemInventoryPanelImage(itemInventoryPanelImage).offDrop();
            }
        }

    }


}

