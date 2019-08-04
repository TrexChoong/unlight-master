package view.image.item
{

    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.containers.*;
    import mx.controls.*;

    import view.image.BaseImage;

    import model.events.SelectTabEvent;

    /**
     * ItemInventoryBaseImage表示クラス
     *
     */


    public class BasePanelImage extends BaseImage implements IInventoryBaseImage
    {

        public function onUse():void
        {
        }
        public function offUse():void
        {
        }

        public function onRemove():void
        {
        }
        public function offRemove():void
        {
        }

        public function backButtonsEnable(b:Boolean):void
        {
        }

        public function nextButtonsEnable(b:Boolean):void
        {
        }


    }

}
